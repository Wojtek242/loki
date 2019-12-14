#!/bin/sh

# Import all account and GPG variables
source ./b2.cred

# Local directory to backup
LOCAL_DIR="/media/usb0/backup"

# Perform a full backup
duplicity full \
          --encrypt-sign-key $GPG_KEY \
          ${LOCAL_DIR} b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}

# Cleanup failures
duplicity cleanup --force \
          --encrypt-sign-key $GPG_KEY \
          b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}

# Show collection-status
duplicity collection-status \
          --encrypt-sign-key $GPG_KEY \
          b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}
