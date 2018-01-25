FROM debian

# Add files to setup GitLab repo
ADD script.deb.sh /tmp/script.deb.sh
ADD pin-gitlab-runner.pref /etc/apt/preferences.d/pin-gitlab-runner.pref

# Update
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt upgrade -y

# Install gitlab-runner
RUN apt install -y gnupg2 && bash /tmp/script.deb.sh
RUN apt install -y gitlab-runner

# Install pre-requisites for running tests

# Common
RUN apt install -y build-essential

# Python
RUN apt install -y python \
                   python-pip

# Docker
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

RUN apt update && apt install -y docker-ce

ENV DOCKER_HOST "tcp://docker:2375"

# Preserve runner's data
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]

# init sets up the environment and launches gitlab-runner
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/gitlab-runner"]
