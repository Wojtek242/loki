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

docker-compose -f $DIRNAME/docker-compose.yml pull

# -----------------------------------------------------------------------------
# Stop the containers.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Stop the containers${NC}"

systemctl stop loki-server

# -----------------------------------------------------------------------------
# Start the containers.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Start the containers${NC}"

systemctl start loki-server

# -----------------------------------------------------------------------------
# Remove untagged images.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Remove untagged images${NC}"

docker container prune -f
docker image prune -f
