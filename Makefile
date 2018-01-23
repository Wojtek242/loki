# -----------------------------------------------------------------------------
# The container registry to use.
# -----------------------------------------------------------------------------

DOCKER_REGISTRY = gitlab.wojciechkozlowski.eu:8443/wojtek/loki

# -----------------------------------------------------------------------------
# Default target.
# -----------------------------------------------------------------------------

default: all

# -----------------------------------------------------------------------------
# html
# -----------------------------------------------------------------------------

html-clean:
	docker rmi $(DOCKER_REGISTRY)/html || /bin/true

html-build:
	docker-compose build html

html-push:
	docker-compose push html

html-pull:
	docker-compose pull html

html: html-clean html-build html-push

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
# gitlab
# -----------------------------------------------------------------------------

gitlab-clean:
	docker rmi $(DOCKER_REGISTRY)/gitlab || /bin/true

gitlab-build:
	docker-compose build gitlab

gitlab-push:
	docker-compose push gitlab

gitlab-pull:
	docker-compose pull gitlab

gitlab: gitlab-clean gitlab-build gitlab-push

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
	docker rmi $(shell docker images -q)

clean-builds: html-clean wiki-clean nextcloud-cron-clean gitlab-clean proxy-clean certbot-clean runner-clean

build-all:
	docker-compose build

push-all:
	docker-compose push

pull-all:
	docker-compose pull

pull-builds: html-pull wiki-pull nextcloud-cron-pull gitlab-pull proxy-pull certbot-pull runner-pull

# -----------------------------------------------------------------------------
# Clean - build - push
# -----------------------------------------------------------------------------

all: clean-all build-all push-all
