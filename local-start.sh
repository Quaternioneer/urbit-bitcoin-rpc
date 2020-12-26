#!/bin/bash
# Start BTC first so that proxy can access BTC's .cookie file
# Sleep so that the .cookie file is generated
BTC_DATADIR=/data/ledgers/bitcoin/core
#bitcoind -datadir=$BTC_DATADIR &
#sleep 2

ELECTRS_DATADIR=/data/ledgers/electrum/bitcoinCore
COOKIE=$(cat ${BTC_DATADIR}/.cookie)
export BTC_RPC_COOKIE_PASS=${COOKIE:11}
export ELECTRS_HOST=127.0.0.1
export ELECTRS_PORT=50001
export PROXY_PORT=50002

echo "This is pw for debugging: $BTC_RPC_COOKIE_PASS"
#node src/server.js &
#2020 Dec 25:
#TODO fix permissions: remove o+rwx from /data/ledgers/bitcoin/core/blocks. For some reason I was getting, "Permission Denied"

sudo docker run --network host --volume $BTC_DATADIR:$BTC_DATADIR:ro --volume $ELECTRS_DATADIR:$ELECTRS_DATADIR --rm -i -t electrs-app electrs \
    -vvvv  --timestamp \
    --cookie-file $BTC_DATADIR/.cookie \
    --daemon-dir $BTC_DATADIR \
    --db-dir $ELECTRS_DATADIR \
    --daemon-rpc-addr "localhost:8222" \
    --electrum-rpc-addr $ELECTRS_HOST:$ELECTRS_PORT
