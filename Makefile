# -----------------------------------------------------------------------------
# Install the service file.
# -----------------------------------------------------------------------------

install:
	cp loki-server.service /lib/systemd/system/
	systemctl daemon-reload
	systemctl enable loki-server

uninstall:
	systemctl disable loki-server
	rm /lib/systemd/system/loki-server.service
	systemctl daemon-reload

# -----------------------------------------------------------------------------
# The container registry to use.
# -----------------------------------------------------------------------------

DOCKER_REGISTRY = gitlab.wojciechkozlowski.eu:8443/wojtek/loki

# -----------------------------------------------------------------------------
# Default target.
# -----------------------------------------------------------------------------

default: all

# -----------------------------------------------------------------------------
# wiki
# -----------------------------------------------------------------------------

wiki-clean:
	docker rmi $(DOCKER_REGISTRY)/wiki || /bin/true

wiki-build:
	docker-compose build wiki

wiki-push:
	docker-compose push wiki

wiki-pull:
	docker-compose pull wiki

wiki: wiki-clean wiki-build wiki-push

# -----------------------------------------------------------------------------
# nextcloud-cron
# -----------------------------------------------------------------------------

nextcloud-cron-clean:
	docker rmi $(DOCKER_REGISTRY)/nextcloud-cron || /bin/true

nextcloud-cron-build:
	docker-compose build nextcloud-cron

nextcloud-cron-push:
	docker-compose push nextcloud-cron

nextcloud-cron-pull:
	docker-compose pull nextcloud-cron

nextcloud-cron: nextcloud-cron-clean nextcloud-cron-build nextcloud-cron-push

# -----------------------------------------------------------------------------
# proxy
# -----------------------------------------------------------------------------

proxy-clean:
	docker rmi $(DOCKER_REGISTRY)/proxy || /bin/true

proxy-build:
	docker-compose build proxy

proxy-push:
	docker-compose push proxy

proxy-pull:
	docker-compose pull proxy

proxy: proxy-clean proxy-build proxy-push

# -----------------------------------------------------------------------------
# certbot
# -----------------------------------------------------------------------------

certbot-clean:
	docker rmi $(DOCKER_REGISTRY)/certbot || /bin/true

certbot-build:
	docker-compose build certbot

certbot-push:
	docker-compose push certbot

certbot-pull:
	docker-compose pull certbot

certbot: certbot-clean certbot-build certbot-push

# -----------------------------------------------------------------------------
# runner
# -----------------------------------------------------------------------------

runner-clean:
	docker rmi $(DOCKER_REGISTRY)/runner || /bin/true

runner-build:
	docker-compose build runner

runner-push:
	docker-compose push runner

runner-pull:
	docker-compose pull runner

runner: runner-clean runner-build runner-push

# -----------------------------------------------------------------------------
# Collect targets.
# -----------------------------------------------------------------------------

clean-all:
	docker rmi $(shell docker images -q) || /bin/true

clean-builds: wiki-clean nextcloud-cron-clean proxy-clean certbot-clean runner-clean

build-all:
	docker-compose build

push-all:
	docker-compose push

pull-all:
	docker-compose pull

pull-builds: wiki-pull nextcloud-cron-pull proxy-pull certbot-pull runner-pull

# -----------------------------------------------------------------------------
# Clean - build - push
# -----------------------------------------------------------------------------

all: clean-all build-all push-all
