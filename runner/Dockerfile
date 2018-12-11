FROM registry.wojciechkozlowski.eu/wojtek/loki/base

# Add files to setup GitLab repo
ADD script.deb.sh /tmp/script.deb.sh
ADD pin-gitlab-runner.pref /etc/apt/preferences.d/pin-gitlab-runner.pref

# Install gitlab-runner
RUN apt-get -y install gnupg2 && bash /tmp/script.deb.sh && apt-get -y install gitlab-runner

# Preserve runner's data
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]

# init sets up the environment and launches gitlab-runner
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/gitlab-runner"]
