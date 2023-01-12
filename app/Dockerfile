FROM alpine:3.12

RUN echo "*/40 * * * * /opt/monitor/iperftest.sh" >> /etc/crontabs/root

RUN echo "* * * * * /opt/monitor/ping.sh" >> /etc/crontabs/root

RUN apk add --no-cache curl iperf3 busybox-initscripts

CMD crond -f -l 8
