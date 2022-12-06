# DONATE

1. Ethereum : <pre>0xB0e6e6c379389bBB30fACD427e02d74d27ec0C78</pre>
2. Near Blockchain : <pre>xoreth.near</pre>
3. Mina Protocol : <pre>B62qiiBBXKN5CdgXv7wPkXxC1prdzQxwfaTMAi3isAeb9F7gCbzi5dU</pre>



>> I have not responsible if the script could not running well. This script only for automate and  for own self consumption !!!

# aptos-validator

## Requierment
```
Ubuntu 22^
VPS 8vcpu 16GB 250GB
Used DNS 
```

## Install Environment
*IMPORTANT*
```
git clone git@github.com:luneareth/aptos-validator.git
mv aptos-validator APTOS
cd APTOS/bin
```

Turn into root
```
su -
```

Install environment
if  we want change user account name, edit file setup-env.sh, change variable
```
USER="gneareth"
```

Execution
```
bash -x setup-env.sh
```

ctrl+d -> fill password

check docker service

```
systemctl status docker
```

change variable in file environment
```
#!/usr/bin/env

### APTOS ###
export BUILD="testnet"
export WORKSPACE="${HOME}/APTOS/projects/${BUILD}"
export DNSNAME="cikura.roomit.xyz"
export NODENAME="RoomIT-dev"

### NHC ####
export CONFYAML="validator"
export CONTAINERNAME_NHC="roomit-aptos-checker"
export CONFYAMLPRETTY="RoomIT Aptos Nodes"
export KINDNODE="validator" #validator or fullnode
export CHAINID=43

```

## Deploy Devnet

```
bash -x aptos.sh deploy devnet
```

## Deploy AIT2

```
bash -x aptos.sh deploy ait2
```

## Deploy AIT3
```
bash -x aptos.sh deploy ait3
```

## Update Aptos CLI
```
bash aptosh.sh update client
```


## Install NHC

## Generate File Config NHC

```
bash -x nhc.sh generate
```

Edit file in directory conf/filename_you_have_created.yaml, delete from line 1 until before symbol ---, then save and exit


## Running Service
```
bash -x nhc.sh container
```

or 

```
bash nhc.sh start
```

Notes: if you running fullnode change variable *KINDNODE* to fullnode
```
KINDNODE="fullnode" 
```

# monitoring-stack

## Install Monitoring Stack
```
cd bin/
su - 
monitoring-stack deploy prometheus
monitoring-stack deploy grafana
apt install telegraf
```

## Configuration Monitoring Stack
copy all config from directory monitrong to each directory platform (telegraf and prometheus config), restart prometheus
```
systemctl restart prometheus
```

Import Dashboard Grafana used web base dashboard grafana.
