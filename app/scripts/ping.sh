#!/bin/sh
DB_HOST="${DB_HOST:-http://influxdb:8086}"
DB_NAME="${DB_NAME:-iperftest}"
DB_USERNAME="${DB_USERNAME:-admin}"
DB_PASSWORD="${DB_PASSWORD:-password}"

DATE=$(date +%s)
GW=$(ip -4 route | awk '/^default/ { print $3 }')
PUBLIC_IP=$(curl ifconfig.me)
COUNT=3
TIMEOUT=3

for host in $GW 1.1.1.1 8.8.8.8 9.9.9.9 76.76.19.19 185.228.168.9 208.67.222.222; do

  result=$(ping -c $COUNT -W $TIMEOUT $host)
  avg=$(echo $result | grep "= [0-9]" | cut -f4 -d"/" | cut -f3 -d" " )
  loss=$(echo $result | grep -o "[0-9]\+%" | cut -f1 -d% )

  curl -s -S -XPOST "$DB_HOST/write?db=$DB_NAME&precision=s&u=$DB_USERNAME&p=$DB_PASSWORD" --data-binary "ping,host=$host,public=$PUBLIC_IP avg=$avg,loss=$loss $DATE"

done
