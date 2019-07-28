#!/bin/bash

set -e

CYAN='\033[01;36m'
YELLOW='\033[01;33m'
RED='\033[01;31m'
NC='\033[00m'

SCRIPT=$(readlink -f $0)
DIRNAME=$(dirname $SCRIPT)

# -----------------------------------------------------------------------------
# Get the list of volumes.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Extract list of volumes ${NC}"

# Find the line where "services:" start
services_line=$(grep -n services docker-compose.yml | awk '{split($0, a, ":"); print a[1]}')

# The volumes are listed between "volumes:" and "services:"
volume_list=$(head -n $services_line docker-compose.yml | awk '/volumes:/,/services:/')

# Split into array
IFS=':'; volumes=($volume_list); unset IFS;

# Trim whitespace
for ((i = 0; i < ${#volumes[@]}; i++)); do
    volumes[$i]=$(echo -e "${volumes[$i]}" | tr -d '[:space:]')
done

# Verify that the first entry is "volumes" and the last "services"
if [ ${volumes[0]} != "volumes" ] || [ "${volumes[-1]}" != "services" ]; then
    echo -e "${RED}Unexpected input${NC}" >&2
    exit 1
fi

# Remove first and last entry - they will be "volumes" and " services"
let len=${#volumes[@]}-2
volumes=("${volumes[@]:1:$len}")

# Print final list
echo -e "${YELLOW}Volumes${NC}:"
for vol in "${volumes[@]}"; do
    echo -e "  - ${YELLOW}${vol} ${NC}"
done

# -----------------------------------------------------------------------------
# Stop the server.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Stop loki-server ${NC}"

service loki-server stop

# -----------------------------------------------------------------------------
# Back up volumes.
# -----------------------------------------------------------------------------

for vol in "${volumes[@]}"; do
    echo -e "${CYAN}[${SCRIPT}] Back up ${YELLOW}${vol}${CYAN} volume ${NC}"

    set -o xtrace
    docker run --rm -v loki_${vol}:/opt/${vol} -v /srv/backup:/opt/backup debian:stable-slim bash -c \
           "cd /opt/${vol} && tar cf /opt/backup/${vol}.tar ."
    set +o xtrace
done

# -----------------------------------------------------------------------------
# Restart the server.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Restart loki-server ${NC}"

service loki-server start
