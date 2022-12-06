#!/bin/bash



curl --location --request POST 'http://localhost:9000/' \
    --header 'Content-Type: application/json' \
    --data-raw '{ "jsonrpc":"2.0", "id":1, "method":"sui_getRecentTransactions", "params":[5] }'
