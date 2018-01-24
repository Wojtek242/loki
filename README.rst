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

To update the images and restart run (``WARNING: THIS WILL REMOVE ALL UNUSED
DOCKER IMAGES``)

::

   ./update.sh
