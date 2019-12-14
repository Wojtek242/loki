#!/bin/bash

set -e

CYAN='\033[01;36m'
NC='\033[00m'

SCRIPT=$(readlink -f $0)
DIRNAME=$(dirname $SCRIPT)

# -----------------------------------------------------------------------------
# Soft delete untagged images.
# -----------------------------------------------------------------------------

if [ -t 1 ]; then
    echo -e "${CYAN}[${SCRIPT}] Soft delete untagged images ${NC}"
fi

install="pip3 install gitlab-registry-cleanup"
cleanup="gitlab-registry-cleanup -g https://gitlab.wojciechkozlowski.eu -r https://registry.wojciechkozlowski.eu -c /gitlab.cred"

docker run -it --rm --volumes-from gitlab \
       -v ${DIRNAME}/gitlab.cred:/gitlab.cred \
       python bash -c "${install} && ${cleanup}"

# -----------------------------------------------------------------------------
# Garbage collect and hard delete untagged images.
# -----------------------------------------------------------------------------

if [ -t 1 ]; then
    echo -e "${CYAN}[${SCRIPT}] Garbage collect untagged images ${NC}"
fi

docker exec gitlab bash -c "gitlab-ctl registry-garbage-collect"
