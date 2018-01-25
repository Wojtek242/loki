#!/bin/bash

set -e

CYAN='\033[01;36m'
RED='\033[01;31m'
NC='\033[00m'

SCRIPT=$(readlink -f $0)
DIRNAME=$(dirname $SCRIPT)

SLEEP_TIME=300

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
# Wait for containers to start.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Wait ${SLEEP_TIME}s for containers to start${NC}"

sleep $SLEEP_TIME

# -----------------------------------------------------------------------------
# Remove unused images.
# -----------------------------------------------------------------------------

ACTIVE=$(systemctl status loki-server.service | grep "active (running)" -c)

if [[ $ACTIVE == 1 ]]
then

    echo -e "${CYAN}[${SCRIPT}] Remove unused images${NC}"

    yes | docker image prune -a

else

    echo -e "${RED}[${SCRIPT}] Problem with service activation${NC}"

fi
