#!/bin/bash
EXTERNAL_COMPILE="true"


if [ $EXTERNAL_COMPILE == true ]
then
cat > Dockerfile <<EOF
FROM ubuntu:20.04
ARG NODE_TYPE
ARG USER_IMAGES
ENV USER_IMAGES \${USER_IMAGES}
ENV NODE_TYPE \${NODE_TYPE}
RUN useradd -U -m -s /sbin/nologin \${USER_IMAGES}
WORKDIR /home/\${USER_IMAGES}
COPY bin/init.sh /home/\${USER_IMAGES}/
COPY bin/celestia /home/\${USER_IMAGES}/
COPY bin/cel-key /home/\${USER_IMAGES}/
COPY celestia-environment /home/\${USER_IMAGES}/
RUN mkdir -p /home/\${USER_IMAGES}/.celestia-light 
#VOLUME ["/home/\${USER_IMAGES}/.celestia-light/"]
RUN chown -R \${USER_IMAGES}:\${USER_IMAGES} /home/\${NODE_TYPE}/.celestia-light
RUN chmod +x /home/\${USER_IMAGES}/init.sh && chmod +x /home/\${USER_IMAGES}/celestia && chown -R \${USER_IMAGES}:\${USER_IMAGES} /home/\${NODE_TYPE}
USER \${USER_IMAGES}
RUN ls -ltra
EXPOSE 2121
EXPOSE 26658
CMD ["./init.sh"]
EOF
if ! [ -f ../bin/celestia ] && ! [ -f ../bin/cel-key ]
then	
cd ../
bash install-celestia.sh
unset GOBIN
unset GOPATH
unset GOROOT
unset CELESTIA_BIN
cp -rf ~/go/bin/* docker/bin/
cd docker
else
  cp -rf ../bin/{celestia,cel-key} bin/
fi
else
cat > Dockerfile <<EOF	
FROM golang:1.18.2-alpine as builder
RUN apk add bash  curl tar wget clang pkgconfig libressl-dev jq build-base  git make ncdu
RUN mkdir -p /app
WORKDIR /app
COPY src/celestia-source/. .
COPY src/celestia-source/go.mod .
COPY src/celestia-source/go.sum .
RUN go mod download
COPY . .
RUN git checkout tags/v0.3.0-rc2
RUN make install
RUN make cel-key

FROM ubuntu:20.04
ARG NODE_TYPE
ARG USER_IMAGES
ENV USER_IMAGES \${USER_IMAGES}
ENV NODE_TYPE \${NODE_TYPE}
RUN useradd -U -m -s /sbin/nologin \${USER_IMAGES}
RUN apt update -y && apt install pkg-config file -y
WORKDIR /home/\${USER_IMAGES}
COPY --from=builder /go/bin/ /home/\${USER_IMAGES}/
COPY bin/init.sh /home/\${USER_IMAGES}/
COPY celestia-environment /home/\${USER_IMAGES}/
RUN chmod +x /home/\${USER_IMAGES}/init.sh && chmod +x /home/\${USER_IMAGES}/celestia && chown -R \${USER_IMAGES}:\${USER_IMAGES} /home/\${NODE_TYPE}/
USER \${USER_IMAGES}
VOLUME ["/home/\${USER_IMAGES}/.celestia-light/"]
EXPOSE 2121
CMD ["./init.sh"]
EOF
git clone https://github.com/celestiaorg/celestia-node.git src/celestia-source
fi


docker build -t dormaaloc/celestia:test-01 . $(for i in `cat celestia-environment | grep -vE "^#" | grep -v "export"`; do out+="--build-arg $i " ; done; echo $out;out="")
cd ../
mkdir -p .celestia-light
sudo chown 1000:1000 -R .celestia-light
docker run -d  --name celestia-light -p 2121:2121 -p 127.0.0.1:26658:26658  -v $(pwd)/.celestia-light:/home/light/.celestia-light dormaaloc/celestia:test-01
docker logs -f --tail -n10 celestia-light
