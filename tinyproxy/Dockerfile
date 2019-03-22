FROM debian:stable-slim as intermediate

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install \
        build-essential \
        wget

ENV VER "1.10.0"
RUN wget https://github.com/tinyproxy/tinyproxy/releases/download/$VER/tinyproxy-$VER.tar.xz
RUN tar xf tinyproxy-$VER.tar.xz && mv tinyproxy-$VER tinyproxy
RUN cd tinyproxy && \
        ./configure && \
        make -j 9

FROM debian:stable-slim

COPY --from=intermediate /tinyproxy /tinyproxy

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y stunnel4

ADD ./letsencrypt /etc/letsencrypt

ADD ./stunnel.conf /etc/stunnel/stunnel.conf
ADD ./tinyproxy.conf /tinyproxy/etc/tinyproxy.conf
EXPOSE 7700
CMD ["/tinyproxy/src/tinyproxy", "-d", "-c", "/tinyproxy/etc/tinyproxy.conf"]
