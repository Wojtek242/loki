FROM nextcloud:fpm

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install \
        supervisor \
        cron

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /var/log/supervisord /var/run/supervisord && \ 
  echo "*/15 * * * * su - www-data -s /bin/bash -c \"php -f /var/www/html/cron.php\""| crontab -

COPY supervisord.conf /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord"]
