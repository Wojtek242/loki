#!/bin/bash

set -ue

CYAN='\033[01;36m'
NC='\033[00m'

if [ -t 1 ]; then
    CYAN=''
    NC=''
fi

SCRIPT=$(readlink -f $0)
DIRNAME=$(dirname $SCRIPT)

# -----------------------------------------------------------------------------
# Import all account and GPG variables.
# -----------------------------------------------------------------------------
source ./b2.cred
export PASSPHRASE=${GPG_PASSPHRASE}

# -----------------------------------------------------------------------------
# Local directory to backup.
# -----------------------------------------------------------------------------
LOCAL_DIR="/media/usb0/backup"

# -----------------------------------------------------------------------------
# Remove files older than 30 days.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Remove files older than 30 days ${NC}"

duplicity remove-older-than 30D --force \
          --encrypt-sign-key $GPG_KEY \
          b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}

# -----------------------------------------------------------------------------
# Perform a full backup.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Perform a full backup ${NC}"

duplicity full \
          --encrypt-sign-key $GPG_KEY \
          ${LOCAL_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}

# -----------------------------------------------------------------------------
# Clean up failures.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Clean up failures ${NC}"

duplicity cleanup --force \
          --encrypt-sign-key $GPG_KEY \
          b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}

# -----------------------------------------------------------------------------
# Show collection status.
# -----------------------------------------------------------------------------

echo -e "${CYAN}[${SCRIPT}] Show collection status ${NC}"

duplicity collection-status \
          --encrypt-sign-key $GPG_KEY \
          b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}

# -----------------------------------------------------------------------------
# Unset the GPG passphrase.
# -----------------------------------------------------------------------------
unset PASSPHRASE
