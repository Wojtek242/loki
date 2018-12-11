FROM nginx

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade

RUN apt -y install openssl

RUN mkdir /etc/nginx/cert && openssl dhparam -out /etc/nginx/cert/dhparam.pem 2048
