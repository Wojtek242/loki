Loki Ansible Playbooks
======================

Ansible playbooks for provisioning the server.

Requirements
------------

Make sure you have ``ansible`` installed.

Usage
-----

Before any provisioning

#. Copy secrets.def.yml to secrets.yml and fill out all the variables.
#. Encrypt the file with

::

   ansible-vault encrypt secrets.yml

#. To run a playbook

::

   ansible-playbook --vault-id @prompt playbook.yml

From this point it is assumed you have a server which can accept SSH
connections and you have setup public key authentication.

To provision the server

#. First install ``python`` on the server which is required by ``ansible``

::

   ansible-playbook --vault-id @prompt python.yml

#. Configure the SSH daemon with a new port number and better security options.

::

   ansible-playbook --vault-id @prompt ssh.yml

#. Run the remaining setup.

::

   ansible-playbook --vault-id @prompt loki.yml
