#!/bin/bash

set -e

RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
CYAN='\033[01;36m'
NC='\033[00m'

if [ -t 1 ]; then
    RED=''
    GREEN=''
    YELLOW=''
    CYAN=''
    NC=''
fi

SCRIPT=$(readlink -f $0)
DIRNAME=$(dirname $SCRIPT)

BACKUP_DIR="/media/usb0/backup"

# -----------------------------------------------------------------------------
# Get the list of volumes.
# -----------------------------------------------------------------------------

function get_volumes {

    # Find the line where "services:" start
    services_line=$(grep -n services docker-compose.yml | \
                        awk '{split($0, a, ":"); print a[1]}')

    # The volumes are listed between "volumes:" and "services:"
    volume_list=$(head -n $services_line docker-compose.yml | \
                      awk '/volumes:/,/services:/')

    # Split into array
    IFS=':'; volumes=($volume_list); unset IFS;

    # Trim whitespace
    for ((i = 0; i < ${#volumes[@]}; i++)); do
        volumes[$i]=$(echo -e "${volumes[$i]}" | tr -d '[:space:]')
    done

    # Verify that the first entry is "volumes" and the last "services"
    if [ ${volumes[0]} != "volumes" ] || [ "${volumes[-1]}" != "services" ]
    then
        echo -e "${RED}Unexpected input${NC}" >&2
        exit 1
    fi

    # Remove first and last entry - they will be "volumes" and " services"
    let len=${#volumes[@]}-2
    volumes=("${volumes[@]:1:$len}")

    echo ${volumes[*]}

}


# -----------------------------------------------------------------------------
# Start the server.
# -----------------------------------------------------------------------------

function server_start {

    echo -e "${CYAN}[${SCRIPT}] Restart loki-server ${NC}"

    systemctl start loki-server

}

# -----------------------------------------------------------------------------
# Stop the server.
# -----------------------------------------------------------------------------

function server_stop {

    echo -e "${CYAN}[${SCRIPT}] Stop loki-server ${NC}"

    systemctl stop loki-server

}

# -----------------------------------------------------------------------------
# Back up volumes.
# -----------------------------------------------------------------------------

function backup {

    volumes=$1

    # Remove old backup directory
    if [ -d ${BACKUP_DIR} ]; then
        rm -f ${BACKUP_DIR}/*.tar
        rmdir ${BACKUP_DIR}
    fi

    # Make sure directory exists
    mkdir ${BACKUP_DIR}

    for vol in "${volumes[@]}"
    do
        echo -e "${CYAN}[${SCRIPT}] Back up ${YELLOW}${vol}${CYAN} volume${NC}"

        set -o xtrace
        docker run --rm \
               -v loki_${vol}:/opt/${vol} \
               -v ${BACKUP_DIR}:/opt/backup \
               debian:stable-slim \
               bash -c "cd /opt/${vol} && tar cf /opt/backup/${vol}.tar ."
        set +o xtrace
    done

}

# -----------------------------------------------------------------------------
# Restore volumes.
# -----------------------------------------------------------------------------

function restore {

    volumes=$1

    for vol in "${volumes[@]}"
    do
        echo -e "${CYAN}[${SCRIPT}] Restore ${YELLOW}${vol}${CYAN} volume${NC}"

        set -o xtrace
        docker run --rm \
               -v loki_${vol}:/opt/${vol} \
               -v ${BACKUP_DIR}:/opt/backup \
               debian:stable-slim \
               bash -c "cd /opt/${vol} && tar xf /opt/backup/${vol}.tar"
        set +o xtrace
    done

}

# -----------------------------------------------------------------------------
# Main.
# -----------------------------------------------------------------------------

while getopts "br" option
do
    case ${option} in
        b )
            echo -e "${CYAN}[${SCRIPT}] Extract list of volumes ${NC}"

            volumes=($(get_volumes))

            echo -e "${YELLOW}Volumes${NC}:"
            for vol in "${volumes[@]}"
            do
                echo -e "  - ${YELLOW}${vol} ${NC}"
            done

            server_stop
            backup ${volumes}
            server_start
            exit 0
            ;;
        r )
            echo -e "${CYAN}[${SCRIPT}] Extract list of volumes ${NC}"

            volumes=($(get_volumes))

            echo -e "${YELLOW}Volumes${NC}:"
            for vol in "${volumes[@]}"
            do
                echo -e "  - ${YELLOW}${vol} ${NC}"
            done

            server_stop
            restore ${volumes}
            server_start
            exit 0
            ;;
        \? )
            echo -e "${GREEN} Usage: backup.sh [-b|-r]${NC}"
            exit 1
            ;;
    esac
done

# If we get here then no options were triggered
echo -e "${GREEN} Usage: backup.sh [-b|-r]${NC}"
