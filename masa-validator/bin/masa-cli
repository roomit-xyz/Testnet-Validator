echo -e "1. node data directory with configs and keys - admin.datadir
2. check if node is connected - net.listening
3. show synchronization status - eth.syncing
4. node status - admin.nodeInfo
5. show synchronization percentage - eth.syncing.currentBlock * 100 / eth.syncing.highestBlock
6. list of all connected peers (short list) - admin.peers.forEach(function(value){console.log(value.network.remoteAddress+\"\t\"+value.name)})
7. list of all connected peers (long list) - admin.peers
8. show connected peer count - net.peerCount
9. enode - web3.admin.nodeInfo.enode"

docker exec -it masa-node-backend geth attach /qdata/dd/geth.ipc 
