FROM nginx

# Update
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade

RUN \
        # Install pre-requisites
        apt-get -y install wget git && \
        wget https://github.com/gohugoio/hugo/releases/download/v0.56.0/hugo_extended_0.56.0_Linux-64bit.deb && \
        dpkg -i hugo_extended_0.56.0_Linux-64bit.deb && \
        rm hugo_extended_0.56.0_Linux-64bit.deb && \

        # Fetch the website code, build and deploy
        git clone --recursive https://gitlab.wojciechkozlowski.eu/wojtek/wojciechkozlowski.eu.git && \
        cd wojciechkozlowski.eu && \
        hugo && \
        cp -r public/* /usr/share/nginx/html && \

        # Clean up
        cd .. && \
        rm -rf wojciechkozlowski.eu && \
        apt-get -y purge hugo git wget && \
        apt-get -y autoremove
