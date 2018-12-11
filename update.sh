#!/bin/bash

set -e

CYAN='\033[01;36m'
RED='\033[01;31m'
NC='\033[00m'

SCRIPT=$(readlink -f $0)
DIRNAME=$(dirname $SCRIPT)

# -----------------------------------------------------------------------------
# Pull updated images.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Pull updated images${NC}"

make -C $DIRNAME pull-all

# -----------------------------------------------------------------------------
# Stop the containers.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Stop the containers${NC}"

service loki-server stop

# -----------------------------------------------------------------------------
# Start the containers.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Start the containers${NC}"

service loki-server start

# -----------------------------------------------------------------------------
# Remove untagged images.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Remove untagged images${NC}"

docker image prune -f
