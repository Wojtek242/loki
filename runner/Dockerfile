FROM debian

# Add files to setup GitLab repo
ADD script.deb.sh /tmp/script.deb.sh
ADD pin-gitlab-runner.pref /etc/apt/preferences.d/pin-gitlab-runner.pref

# Update
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt upgrade -y

# Install gitlab-runner
RUN apt install -y gnupg && bash /tmp/script.deb.sh
RUN apt install -y gitlab-runner

# Install pre-requisites for running tests
RUN apt install -y build-essential \
                   python \
                   python-pip

# Preserve runner's data
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]

# init sets up the environment and launches gitlab-runner
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/gitlab-runner"]
