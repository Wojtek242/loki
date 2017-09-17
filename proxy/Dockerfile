FROM nginx

RUN apt update && apt install -y openssl
RUN mkdir /etc/nginx/cert && openssl dhparam -out /etc/nginx/cert/dhparam.pem 2048