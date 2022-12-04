FROM alpine:3.12

RUN echo "*/10 * * * * /opt/monitor/iperftest.sh" >> /etc/crontabs/root

RUN echo "* * * * * /opt/monitor/ping.sh" >> /etc/crontabs/root

RUN apk add --no-cache jq wget curl iperf3 busybox-initscripts

# RUN wget -O speedtest-cli.tgz https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz \
#     && tar zxvf speedtest-cli.tgz \
#     && rm speedtest-cli.tgz \
#     && mv speedtest* /usr/bin/

CMD crond -f -l 8
