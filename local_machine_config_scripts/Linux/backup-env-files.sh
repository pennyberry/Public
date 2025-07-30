#!/bin/bash

#load environment variables
SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
ENV_FILE="$SCRIPT_DIR/env-vars.env"
source "$ENV_FILE"

# Define the directory containing .env files
SOURCE_DIR="/home/joe/Public"

# Get all .env files in the directory
ENV_FILES=($(find $SOURCE_DIR -type f -name "*.env" ! -path "*/volumes/*" 2>/dev/null))

BACKUP_PATH="$HOME/backup.txt"

# Loop over each .env file and back it up using gdrive
for ENV_FILE in "${ENV_FILES[@]}"; do
  # Copy the data of each .env file to a new file with the path included

    echo "File: $ENV_FILE" >> $BACKUP_PATH
    cat "$ENV_FILE" >> $BACKUP_PATH
    echo >> $BACKUP_PATH
    echo >> $BACKUP_PATH
done

#backup to vault
for ENV_FILE in "${ENV_FILES[@]}"; do
      CURRENT_ENV_FILE="$ENV_FILE"
      for SECRET in $(grep -oP '^\w+=' "$ENV_FILE" | sed 's/=$//'); do
        SECRET_VALUE=$(grep -oP "^$SECRET=\K.*" "$CURRENT_ENV_FILE")
        SECRET_PATH="$(realpath --relative-to=/home/joe/Public "$CURRENT_ENV_FILE")"/$SECRET
        echo "Setting secret: $SECRET_PATH with value: $SECRET_VALUE"
        . /home/joe/Public/local_machine_config_scripts/Linux/vault-secret-new.sh $SECRET_PATH "$SECRET_VALUE" ${VAULT_TOKEN}
      done
done

#GUIDE TO ENABLE SSH on Windows
# Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
# Start-Service sshd
# Set-Service -Name sshd -StartupType 'Automatic'
# New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
# new-item -ItemType File -Path C:\ProgramData\ssh\administrators_authorized_keys

#generate ssh key using ssh-keygen on your linux device
#paste the value of the public key in C:\ProgramData\ssh\administrators_authorized_keys
#set your backup location like such in your env file:
#BACKUP_LOCATION="USERWITHADMINRIGHTS@IPADDRESS:/Users/USERWITHADMINRIGHTS/somewhere/backuplocation.txt"

# Copy the backup file to the remote Windows machine
scp "$BACKUP_PATH" ${BACKUP_LOCATION}

#remove backup locally
rm "$HOME/backup.txt"