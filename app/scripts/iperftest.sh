#!/bin/sh
DB_HOST="${DB_HOST:-http://influxdb:8086}"
DB_NAME="${DB_NAME:-iperftest}"
DB_USERNAME="${DB_USERNAME:-admin}"
DB_PASSWORD="${DB_PASSWORD:-password}"
DATE=$(date +%s)
IPERFHOST=srn-dm.stanford.edu
PUBLIC_IP=$(curl ifconfig.me)

echo "running iperftest"
let "UL = $(iperf3 -4 -O1 -fK -c $IPERFHOST | grep receiver | awk '{print $7 }') * 1000"
sleep 7
let "DL = $(iperf3 -4 -O1 -fK -R -c $IPERFHOST | grep receiver | awk '{print $7 }') * 1000"

curl -s -S -XPOST "$DB_HOST/write?db=$DB_NAME&precision=s&u=$DB_USERNAME&p=$DB_PASSWORD" \
    --data-binary "bandwidth,server=$IPERFHOST,public=$PUBLIC_IP down=$DL,up=$UL $DATE"
