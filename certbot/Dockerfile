FROM debian:stable-slim

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install \
        certbot \
        cron \
        supervisor

ADD certbot.cron /etc/cron.d/certbot

VOLUME ["/etc/letsencrypt"]

COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
