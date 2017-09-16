FROM debian

ENV HTML_PATH /usr/share/nginx/html
ENV DOKU_VOL /var/dokuwiki-storage

RUN apt update && apt install -y wget php7.0-fpm php7.0-xml nginx
RUN sed -i -e "s|cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g" /etc/php/7.0/fpm/php.ini

RUN rm -rf /etc/nginx/sites-enabled/*
RUN rm -rf /etc/nginx/conf.d
ADD nginx-conf.d /etc/nginx/conf.d

RUN rm -rf $HTML_PATH && \
    mkdir $HTML_PATH && \
    mkdir $DOKU_VOL && \
    mkdir $DOKU_VOL/data && \
    cd $HTML_PATH && \
    wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz && \
    tar xf dokuwiki-stable.tgz --strip 1 && \
    rm dokuwiki-stable.tgz && \
    chown -R www-data:www-data ./ && \
    mv $HTML_PATH/data/pages $DOKU_VOL/data/pages && \
    ln -s $DOKU_VOL/data/pages $HTML_PATH/data/pages && \
    mv $HTML_PATH/data/meta $DOKU_VOL/data/meta && \
    ln -s $DOKU_VOL/data/meta $HTML_PATH/data/meta && \
    mv $HTML_PATH/data/media $DOKU_VOL/data/media && \
    ln -s $DOKU_VOL/data/media $HTML_PATH/data/media && \
    mv $HTML_PATH/data/media_attic $DOKU_VOL/data/media_attic && \
    ln -s $DOKU_VOL/data/media_attic $HTML_PATH/data/media_attic && \
    mv $HTML_PATH/data/media_meta $DOKU_VOL/data/media_meta && \
    ln -s $DOKU_VOL/data/media_meta $HTML_PATH/data/media_meta && \
    mv $HTML_PATH/data/attic $DOKU_VOL/data/attic && \
    ln -s $DOKU_VOL/data/attic $HTML_PATH/data/attic && \
    mv $HTML_PATH/conf $DOKU_VOL/conf && \
    ln -s $DOKU_VOL/conf $HTML_PATH/conf

EXPOSE 80
VOLUME ["$DOKU_VOL"]

CMD service php7.0-fpm start && nginx -g "daemon off;"
