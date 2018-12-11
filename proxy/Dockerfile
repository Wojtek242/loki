FROM nginx

RUN apt-get update && apt-get -y upgrade && apt -y install openssl
RUN mkdir /etc/nginx/cert && openssl dhparam -out /etc/nginx/cert/dhparam.pem 2048
