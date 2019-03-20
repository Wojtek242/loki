FROM debian

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install shadowsocks

ENV SS_VOL /var/shadowsocks
RUN mkdir $SS_VOL
ADD config.json $SS_VOL

EXPOSE 7698
VOLUME ["$SS_VOL"]

CMD ["sh", "-c", "/usr/bin/ssserver -c $SS_VOL/shadowsocks.json"]
