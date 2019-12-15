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

#------------------------------------------------------------------------------
# The container engine to use. Default to docker, but on Fedora must now use
# podman.
# ------------------------------------------------------------------------------

ENGINE = docker

# -----------------------------------------------------------------------------
# The container registry to use.
# -----------------------------------------------------------------------------

REGISTRY = registry.wojciechkozlowski.eu/wojtek/loki

# -----------------------------------------------------------------------------
# Default target.
# -----------------------------------------------------------------------------

default: all

# -----------------------------------------------------------------------------
# html
# -----------------------------------------------------------------------------

HTML = $(REGISTRY)/html

html-clean:
	$(ENGINE) rmi $(HTML) || /bin/true

html-build:
	$(ENGINE) build -f html/Dockerfile -t $(HTML) ./html

html-push:
	$(ENGINE) push $(HTML)

html-pull:
	$(ENGINE) pull $(HTML)

html: html-clean html-build html-push

# -----------------------------------------------------------------------------
# proxy
# -----------------------------------------------------------------------------

PROXY = $(REGISTRY)/proxy

proxy-clean:
	$(ENGINE) rmi $(PROXY) || /bin/true

proxy-build:
	$(ENGINE) build -f proxy/Dockerfile -t $(PROXY) ./proxy

proxy-push:
	$(ENGINE) push $(PROXY)

proxy-pull:
	$(ENGINE) pull $(PROXY)

proxy: proxy-clean proxy-build proxy-push

# -----------------------------------------------------------------------------
# nextcloud
# -----------------------------------------------------------------------------

NEXTCLOUD = $(REGISTRY)/nextcloud

nextcloud-clean:
	$(ENGINE) rmi $(NEXTCLOUD) || /bin/true

nextcloud-build:
	$(ENGINE) build -f nextcloud/Dockerfile -t $(NEXTCLOUD) ./nextcloud

nextcloud-push:
	$(ENGINE) push $(NEXTCLOUD)

nextcloud-pull:
	$(ENGINE) pull $(NEXTCLOUD)

nextcloud: nextcloud-clean nextcloud-build nextcloud-push

# -----------------------------------------------------------------------------
# Collect targets.
# -----------------------------------------------------------------------------

clean-all:
	$(ENGINE) container prune -f
	$(ENGINE) image prune -a -f

clean-builds: \
	html-clean \
	proxy-clean \
	nextcloud-clean

build-all: \
	html-build \
	proxy-build \
	nextcloud-build

push-all: \
	html-push \
	proxy-push \
	nextcloud-push

pull-all: \
	html-pull \
	proxy-pull \
	nextcloud-pull

# -----------------------------------------------------------------------------
# Clean - build - push
# -----------------------------------------------------------------------------

all: clean-all build-all push-all
