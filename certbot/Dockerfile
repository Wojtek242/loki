FROM debian

RUN apt update && apt install -y certbot cron supervisor

ADD certbot.cron /etc/cron.d/certbot

VOLUME ["/etc/letsencrypt"]

COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
