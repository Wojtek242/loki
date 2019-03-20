FROM debian:stable-slim

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install procps
ADD ./shadowsocksR.sh /
RUN bash /shadowsocksR.sh

ENV SS_VOL /var/shadowsocks
RUN mkdir $SS_VOL
ADD config.json $SS_VOL

EXPOSE 7698
VOLUME ["$SS_VOL"]

CMD ["sh", "-c", "/usr/local/shadowsocks/server.py -c $SS_VOL/config.json"]
