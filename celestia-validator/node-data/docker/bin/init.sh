#!/bin/bash

set -x

source celestia-environment

function celestia:init(){
if ! [ -f /home/${USER_IMAGES}/.celestia-light/config.toml ]
then
   ./celestia ${NODE_TYPE} init 
   ./cel-key add ${WALLET_NAME} --keyring-backend ${KEYRING} --node.type light
   ./celestia light start --core.grpc https://rpc-mamaki.pops.one:9090 --keyring.accname  ${WALLET_NAME} 
else
   ./celestia light start --core.grpc https://rpc-mamaki.pops.one:9090 --keyring.accname  ${WALLET_NAME} 
fi
}

celestia:init;
