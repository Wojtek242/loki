FROM registry.wojciechkozlowski.eu/wojtek/loki/base

RUN apt-get -y install certbot cron supervisor

ADD certbot.cron /etc/cron.d/certbot

VOLUME ["/etc/letsencrypt"]

COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
