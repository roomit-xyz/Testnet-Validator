#!/bin/bash

HOME_CELESTIA=`pwd`
GOLANG_VERSION="1.18.2"
HAVE_KEY="true"
ENABLE_SNAPSHOT="true"
#SNAPSHOT_DATE=`date +%Y-%m-%d`
SNAPSHOT_DATE="2022-11-08"

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
APP_VERSION="v0.6.0"
VALIDATOR_NAME=RoomIT
CHAIN_ID=mamaki
KEY_NAME=roomit
CELES_AMOUNT="10000000000000000000000000utia"
STAKING_AMOUNT="1000000000utia"
GOBIN="\$HOME_CELESTIA/.go/bin"
GOPATH="\$HOME_CELESTIA/lib/go";
GOROOT="\$HOME_CELESTIA/.go"
CELESTIA_BIN="\$HOME_CELESTIA/bin"
export PATH="\$PATH:\$GOBIN:\$GOPATH:\$GOROOT:\$CELESTIA_BIN"
EOF
fi

echo "Install Calestia APP"
source celestia-environment
cd ${HOME_CELESTIA}/tmp
git clone https://github.com/celestiaorg/celestia-app.git
cd celestia-app/
git checkout tags/$APP_VERSION -b $APP_VERSION
make install


echo "Install Celestia Node"
cd ${HOME_CELESTIA}/tmp
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
git checkout tags/v0.3.0-rc2
make install
make cel-key

cp cel-key ${HOME_CELESTIA}/bin
cp ~/go/bin/celestia ${HOME_CELESTIA}/bin
cp ~/go/bin/celestia-appd  ${HOME_CELESTIA}/bin




function Add:Peer(){
echo "ADD PEER"
cd ${HOME_CELESTIA}/tmp
git clone https://github.com/celestiaorg/networks.git
cp networks/mamaki/genesis.json ${HOME_CELESTIA}/.celestia-app/config/
BOOTSTRAP_PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/bootstrap-peers.txt | tr -d '\n')
PERSISTENT_PEERS="e4429e99609c8c009969b0eb73c973bff33712f9@141.94.73.39:43656, 09263a4168de6a2aaf7fef86669ddfe4e2d004f6@142.132.209.229:26656, 72b34325513863152269e781d9866d1ec4d6a93a@65.108.194.40:26676, 322542cec82814d8903de2259b1d4d97026bcb75@51.178.133.224:26666, 5273f0deefa5f9c2d0a3bbf70840bb44c65d835c@80.190.129.50:49656, 5a4c337189eed845f3ece17f88da0d94c7eb2f9c@209.126.84.147:26656, ec072065bd4c6126a5833c97c8eb2d4382db85be@88.99.249.251:26656, cd1524191300d6354d6a322ab0bca1d7c8ddfd01@95.216.223.149:26656, fcff172744c51684aaefc6fd3433eae275a2f31b@159.203.18.242:26656, f7b68a491bae4b10dbab09bb3a875781a01274a5@65.108.199.79:20356, c8c0456a5174ab082591a9466a6e0cb15c915a65@194.233.85.193:26656, a46bbdb81e66c950e3cdbe5ee748a2d6bdb185dd@161.97.168.77:26656, 831cd61b04ac95155f101723b851af53460d4d65@65.108.217.169:26656, 43e9da043318a4ea0141259c17fcb06ecff816af@141.94.73.39:43656, 45d0154bea2e0bbffec343894072f5feab19d242@65.108.71.92:43656"
sed -i.bak -e "s/^bootstrap-peers *=.*/bootstrap-peers = \"${BOOTSTRAP_PEERS}\"/" ${HOME_CELESTIA}/.celestia-app/config/config.toml
sed -i.bak -e "s/^persistent-peers *=.*/persistent-peers = \"${PERSISTENT_PEERS}\"/" ${HOME_CELESTIA}/.celestia-app/config/config.toml
sed -i.bak -e "s/^timeout-commit *=.*/timeout-commit = \"25s\"/" $HOME/.celestia-app/config/config.toml
sed -i.bak -e "s/^skip-timeout-commit *=.*/skip-timeout-commit = false/" ${HOME_CELESTIA}/.celestia-app/config/config.toml
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" ${HOME_CELESTIA}/.celestia-app/config/config.toml
}

echo "Deploy Calestia"
cd ${HOME_CELESTIA}/
source celestia-environment

function Change:Config(){
   pruning="custom"
   pruning_keep_recent="100"
   pruning_interval="10"
   sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ${HOME_CELESTIA}/.celestia-app/config/app.toml
   sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \
              \"$pruning_keep_recent\"/" ${HOME_CELESTIA}/.celestia-app/config/app.toml
   sed -i -e "s/^pruning-interval *=.*/pruning-interval = \
              \"$pruning_interval\"/" ${HOME_CELESTIA}/.celestia-app/config/app.toml
}

if [ "${HAVE_KEY}" == "true" ]
then 
   celestia-appd init ${VALIDATOR_NAME} --chain-id ${CHAIN_ID} --home .celestia-app
   Change:Config
   celestia-appd keys add ${KEY_NAME} --recover --home .celestia-app

else
   celestia-appd init ${VALIDATOR_NAME} --chain-id ${CHAIN_ID} --home .celestia-app
   Change:Config;
   celestia-appd keys add ${KEY_NAME} --keyring-backend test --home .celestia-app
fi

Add:Peer;

cd ${HOME_CELESTIA}/
mkdir -p /data/celestia/
cp -rf ${HOME_CELESTIA}/.celestia-app/data /data/celestia/
mv ${HOME_CELESTIA}/.celestia-app/data ${HOME_CELESTIA}/.celestia-app/_data
ln -sf /data/celestia/data ${HOME_CELESTIA}/.celestia-app/

echo "Create Systemd"
mkdir -p systemd
cat > systemd/celestia-appd.service <<EOF
[Unit]
Description=celestia-appd Cosmos daemon
After=network-online.target

[Service]
User=gneareth
Group=gneareth
EnvironmentFile=${HOME_CELESTIA}/celestia-environment
ExecStart=$(which celestia-appd)  start --home ${HOME_CELESTIA}/.celestia-app --home ${HOME_CELESTIA}/.celestia-app
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

echo "Install Systemd"
sudo ln -sf ${HOME_CELESTIA}/systemd/celestia-appd.service /etc/systemd/system/
sudo systemctl stop celestia-appd

function download:snapshot(){
cd /data/celestia/
wget -c https://snaps.qubelabs.io/celestia/mamaki_${SNAPSHOT_DATE}.tar
}

function install:snapshot(){
cd /data/celestia
tar xvf mamaki_${SNAPSHOT_DATE}.tar -C data/
}

if [ "${ENABLE_SNAPSHOT}" == "true" ]
then
   download:snapshot;
   install:snapshot;
else 
   echo "Snapshot not deploy, Syncing Block Manual"
fi

echo "Running Service"
sudo systemctl start celestia-appd
sudo systemctl status celestia-appd

echo "Become Validator, Stake Coin TIA"
echo "celestia-appd tx staking create-validator --home ${HOME_CELESTIA}/.celestia-app --amount=1000000utia --pubkey=\$(celestia-appd tendermint show-validator --home ${HOME_CELESTIA}/.celestia-app) --moniker=${VALIDATOR_NAME} --chain-id=${CHAIN_ID} --commission-rate=0.1 --commission-max-rate=0.2 --commission-max-change-rate=0.01 --min-self-delegation=1000000 --from=${KEY_NAME}"
echo ""
echo "Delegate Validator"
echo  "celestia-appd tx staking delegate celestiavaloper1c8czuf6nwvmwl2c6p05hhzj94ruxk2r08f5k0h 2000000utia --chain-id ${CHAIN_ID} --fees=1utia --from ${KEY_NAME} --home ${HOME_CELESTIA}/.celestia-app"


echo "Installation Finished"
