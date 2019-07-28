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
# html
# -----------------------------------------------------------------------------

HTML = $(DOCKER_REGISTRY)/html

html-clean:
	docker rmi $(HTML) || /bin/true

html-build:
	docker build -f html/Dockerfile -t $(HTML) ./html

html-push:
	docker push $(HTML)

html-pull:
	docker pull $(HTML)

html: html-clean html-build html-push

# -----------------------------------------------------------------------------
# proxy
# -----------------------------------------------------------------------------

PROXY = $(DOCKER_REGISTRY)/proxy

proxy-clean:
	docker rmi $(PROXY) || /bin/true

proxy-build:
	docker build -f proxy/Dockerfile -t $(PROXY) ./proxy

proxy-push:
	docker push $(PROXY)

proxy-pull:
	docker pull $(PROXY)

proxy: proxy-clean proxy-build proxy-push

# -----------------------------------------------------------------------------
# wiki
# -----------------------------------------------------------------------------

WIKI = $(DOCKER_REGISTRY)/wiki

wiki-clean:
	docker rmi $(WIKI) || /bin/true

wiki-build:
	docker build -f dokuwiki/Dockerfile -t $(WIKI) ./dokuwiki

wiki-push:
	docker push $(WIKI)

wiki-pull:
	docker pull $(WIKI)

wiki: wiki-clean wiki-build wiki-push

# -----------------------------------------------------------------------------
# nextcloud
# -----------------------------------------------------------------------------

NEXTCLOUD = $(DOCKER_REGISTRY)/nextcloud

nextcloud-clean:
	docker rmi $(NEXTCLOUD) || /bin/true

nextcloud-build:
	docker build -f nextcloud/Dockerfile -t $(NEXTCLOUD) ./nextcloud

nextcloud-push:
	docker push $(NEXTCLOUD)

nextcloud-pull:
	docker pull $(NEXTCLOUD)

nextcloud: nextcloud-clean nextcloud-build nextcloud-push

# -----------------------------------------------------------------------------
# Collect targets.
# -----------------------------------------------------------------------------

clean-all:
	docker container prune -f
	docker image prune -a -f

clean-builds: \
	html-clean \
	proxy-clean \
	wiki-clean \
	nextcloud-clean

build-all: \
	html-build \
	proxy-build \
	wiki-build \
	nextcloud-build

push-all: \
	html-push \
	proxy-push \
	wiki-push \
	nextcloud-push

pull-all: \
	html-pull \
	proxy-pull \
	wiki-pull \
	nextcloud-pull

# -----------------------------------------------------------------------------
# Clean - build - push
# -----------------------------------------------------------------------------

all: clean-all build-all push-all
