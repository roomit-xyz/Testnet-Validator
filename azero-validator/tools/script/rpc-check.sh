curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "rpc_methods"}' http://localhost:9933 | jq
sleep 1
curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "system_unstable_networkState"}' http://localhost:9333 | jq
