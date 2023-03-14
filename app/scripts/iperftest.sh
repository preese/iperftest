#!/bin/sh
DB_HOST="${DB_HOST:-http://influxdb:8086}"
DB_NAME="${DB_NAME:-iperftest}"
DB_USERNAME="${DB_USERNAME:-admin}"
DB_PASSWORD="${DB_PASSWORD:-password}"
DATE=$(date +%s)
LOGDATE=$(date)
IPERFHOST=srn-dm.stanford.edu
PUBLIC_IP=$(curl ifconfig.me)

echo "running iperftest $LOGDATE"

UL="$(iperf3 -4 -J -O1 -t3 -p 5202 -c "$IPERFHOST" | jq -r '.end.sum_received.bits_per_second' | awk -F "." '{print $1}'  )"

sleep 10

DL="$(iperf3 -4 -J -O1 -R -t3 -p 5202 -c "$IPERFHOST" | jq -r '.end.sum_received.bits_per_second' | awk -F "." '{print $  1}')"

curl -s -S -XPOST "$DB_HOST/write?db=$DB_NAME&precision=s&u=$DB_USERNAME&p=$DB_PASSWORD" --data-binary "bandwidth,server=$IPERFHOST,public=$PUBLIC_IP down=$DL,up=$UL $DATE"
