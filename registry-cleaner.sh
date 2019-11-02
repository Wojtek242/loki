#!/bin/bash

set -e

CYAN='\033[01;36m'
YELLOW='\033[01;33m'
RED='\033[01;31m'
NC='\033[00m'

SCRIPT=$(readlink -f $0)
DIRNAME=$(dirname $SCRIPT)

# -----------------------------------------------------------------------------
# Soft delete untagged images.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Soft delete untagged images ${NC}"

install="pip3 install gitlab-registry-cleanup"
cleanup="gitlab-registry-cleanup -g https://gitlab.wojciechkozlowski.eu -r https://registry.wojciechkozlowski.eu -u wojtek"

docker run -it --rm --volumes-from gitlab python bash -c "${install} && ${cleanup}"

# -----------------------------------------------------------------------------
# Garbage collect and hard delete untagged images.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Garbage collect untagged images ${NC}"

docker exec gitlab bash -c "gitlab-ctl registry-garbage-collect"