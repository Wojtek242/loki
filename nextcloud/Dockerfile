FROM nextcloud:fpm

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install supervisor

RUN rm -rf /var/lib/apt/lists/*
RUN mkdir /var/log/supervisord /var/run/supervisord

COPY supervisord.conf /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord"]
