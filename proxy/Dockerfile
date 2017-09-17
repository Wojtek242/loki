FROM nginx

RUN apt update && apt install -y certbot
RUN mkdir -p /var/www/html

VOLUME ["/etc/letsencrypt"]
