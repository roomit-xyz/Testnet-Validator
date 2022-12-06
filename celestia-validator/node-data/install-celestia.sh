#!/bin/bash

HOME_CELESTIA=`pwd`
GOLANG_VERSION="1.18.2"

echo "Install FHS Celestia"
mkdir -p ${HOME_CELESTIA}/tmp
mkdir -p ${HOME_CELESTIA}/lib
mkdir -p ${HOME_CELESTIA}/bin


echo "Install golang ${GOLANG_VERSION}"
cd ${HOME_CELESTIA}/tmp
if ! [ -f ${HOME_CELESTIA}/.go/bin/go ]
then
wget "https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz"
tar xvf go${GOLANG_VERSION}.linux-amd64.tar.gz 
mv go/ ${HOME_CELESTIA}/.go
rm -f ${HOME_CELESTIA}/tmp/go${GOLANG_VERSION}.linux-amd64.tar.gz
fi



cd ${HOME_CELESTIA}
###### ENV GO LANG
if ! [ -f ${HOME_CELESTIA}/celestia-environment ]
then
echo "Install Environment"
cat > celestia-environment <<EOF 
HOME_CELESTIA="`pwd`"
GOBIN="\$HOME_CELESTIA/.go/bin"
GOPATH="\$HOME_CELESTIA/lib/go";
GOROOT="\$HOME_CELESTIA/.go"
CELESTIA_BIN="\$HOME_CELESTIA/bin"
export PATH="\$PATH:\$GOBIN:\$GOPATH:\$GOROOT:\$CELESTIA_BIN"
EOF
fi

echo "Install Calestia"
source celestia-environment
cd ${HOME_CELESTIA}/tmp
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
git checkout tags/v0.3.0-rc2
make install
make cel-key

cp cel-key ${HOME_CELESTIA}/bin
cp ~/go/bin/celestia ${HOME_CELESTIA}/bin
