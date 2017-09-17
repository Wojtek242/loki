FROM debian

RUN apt update && apt install -y certbot cron

ADD certbot.cron /etc/cron.d/certbot

VOLUME ["/etc/letsencrypt"]

CMD ["cron", "-f"]
