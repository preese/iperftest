FROM alpine:latest

RUN echo "0 * * * * /bin/sh /opt/monitor/iperftest.sh" >> /etc/crontabs/root

RUN echo "* * * * * /bin/sh /opt/monitor/ping.sh" >> /etc/crontabs/root

RUN apk add --no-cache curl iperf3 jq

CMD crond -f

