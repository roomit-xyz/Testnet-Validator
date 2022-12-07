# DONATE

1. Ethereum : <pre>0xB0e6e6c379389bBB30fACD427e02d74d27ec0C78</pre>
2. Near Blockchain : <pre>xoreth.near</pre>
3. Mina Protocol : <pre>B62qiiBBXKN5CdgXv7wPkXxC1prdzQxwfaTMAi3isAeb9F7gCbzi5dU</pre>


> https://www.masa.finance/

### Requierment

```
2 vCPU
2 GB RAM
30 GB Disk

OS : Ubuntu ^20.04
```

### Flow
```bash
apt install wget
wget -c https://github.com/luneareth/masa-validator-tesnet-02/archive/refs/heads/main.zip
unzip main.zip
mv masa-validator-tesnet-02 MASA
```

go to Setup Environment
```
# bash setup-env.sh
ctrl + D, exit and fill password
```

move MASA
```
mv MASA /home/${USER}/
su - ${USER}
cd MASA
```

Goes to Install Masa
If you have nodekey before you could restore, go to Restore Validator
```
bash restore-key.sh 
```

If you did not have nodekey before, you could backup in
```
cat  /HOME/${USER}/MASA/masa-node/masa-storage/vol-01/dd/geth/nodekey
```
If you want look status system, go to Simple CLI Interactive
```
bash cli.sh
```
note: change ${USER} with your username 

### Setup Environment
Running As Root
```bash
# bash setup-env.sh
```



### Install Masa
Running As User
```bash
$ bash masa.sh
```


### Restore Validator Nodes
Running As Root
```bash
# bash restore-key.sh 
```


### Simple CLI Interactive
Runnng As user
```bash
$ bash cli.sh
```
