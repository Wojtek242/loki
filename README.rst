Loki
====

Docker files for my server, Loki.

Installation
------------

The following command will install the service file, reload systemd, and enable
the service

::

   make install

Uninstall with

::

   make uninstall

Usage
-----

To start the service run

::

   service loki-server start

To stop run

::

   service loki-server stop

To restart

::

   service loki-server restart

Note that ``docker-compose`` might have issues with HTTP timeout so you may
have to increase the ``COMPOSE_HTTP_TIMEOUT`` environment variable. ``300``
should be enough.

Updating
--------

To update the images and restart run

``WARNING: THIS WILL REMOVE ALL DANGLING DOCKER IMAGES``

::

   ./update.sh

A dangling image is one that does not have a tag, i.e., it is listed with a
``<none>`` tag. The update pulls new versions of the images being used so all
old images will now be left untagged and thus removed. However, if you have
other untagged images, this will remove them as well.
