FROM nginx

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade

RUN apt -y install \
        openssl \
        certbot \
        cron \
        supervisor

RUN mkdir /etc/nginx/cert && openssl dhparam -out /etc/nginx/cert/dhparam.pem 2048

COPY certbot.cron /etc/cron.d/certbot
COPY supervisord.conf /etc/supervisord.conf

VOLUME ["/etc/letsencrypt"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
