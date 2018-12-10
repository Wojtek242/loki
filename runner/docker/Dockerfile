FROM registry.wojciechkozlowski.eu/wojtek/loki/runner-base

RUN apt install -y apt-transport-https \
                   ca-certificates \
                   curl \
                   gnupg2 \
                   software-properties-common

RUN curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -

RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable"

RUN apt update && apt install -y docker-ce docker-compose

ENV DOCKER_HOST "tcp://docker:2375"
