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

DOCKER_REGISTRY = registry.wojciechkozlowski.eu/wojtek/loki

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
# nextcloud
# -----------------------------------------------------------------------------

nextcloud-clean:
	docker rmi $(DOCKER_REGISTRY)/nextcloud || /bin/true

nextcloud-build:
	docker-compose build nextcloud-app

nextcloud-push:
	docker-compose push nextcloud-app

nextcloud-pull:
	docker-compose pull nextcloud-app

nextcloud: nextcloud-clean nextcloud-build nextcloud-push

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
# runners
# -----------------------------------------------------------------------------

# base ------------------------------------------------------------------------

runner-base-clean:
	docker rmi $(DOCKER_REGISTRY)/runner-base || /bin/true

runner-base-build:
	docker build -f runner/Dockerfile \
	-t $(DOCKER_REGISTRY)/runner-base \
	./runner

runner-base-push:
	docker push $(DOCKER_REGISTRY)/runner-base

runner-base-pull:
	docker pull $(DOCKER_REGISTRY)/runner-base

runner-base: runner-base-clean runner-base-build runner-base-push

# main ------------------------------------------------------------------------

runner-main-clean:
	docker rmi $(DOCKER_REGISTRY)/runner-main || /bin/true

runner-main-build: runner-base-build
	docker-compose build runner-main

runner-main-push:
	docker-compose push runner-main

runner-main-pull:
	docker-compose pull runner-main

runner-main: runner-main-clean runner-main-build runner-main-push

# docker ----------------------------------------------------------------------

runner-docker-clean:
	docker rmi $(DOCKER_REGISTRY)/runner-docker || /bin/true

runner-docker-build: runner-base-build
	docker-compose build runner-docker

runner-docker-push:
	docker-compose push runner-docker

runner-docker-pull:
	docker-compose pull runner-docker

runner-docker: runner-docker-clean runner-docker-build runner-docker-push

# collect ---------------------------------------------------------------------

runners-clean: \
	runner-base-clean \
	runner-main-clean \
	runner-docker-clean

runners-build: \
	runner-base-build \
	runner-main-build \
	runner-docker-build

runners-push: \
	runner-main-push \
	runner-docker-push

runners-pull: \
	runner-main-pull \
	runner-docker-pull

runners: runners-clean runners-build runners-push

# -----------------------------------------------------------------------------
# Collect targets.
# -----------------------------------------------------------------------------

clean-all:
	docker container prune -f
	docker image prune -a -f

clean-builds: \
	wiki-clean \
	nextcloud-clean \
	proxy-clean \
	runner-base-clean \
	runner-main-clean \
	runner-docker-clean

build-all: runner-base-build
	docker-compose build

push-all:
	docker-compose push

pull-all:
	docker-compose pull

# -----------------------------------------------------------------------------
# Clean - build - push
# -----------------------------------------------------------------------------

all: clean-all build-all push-all
