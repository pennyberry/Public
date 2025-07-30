#!/bin/bash

# Usage: ./vault-secret-get.sh <secret_path> [vault_token]
# Example: ./vault-secret-get.sh mysecret mytoken123
#load environment variables
SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
ENV_FILE="$SCRIPT_DIR/env-vars.env"
source "$ENV_FILE"
VAULT_ADDR="${VAULT_LOCATION}"

#variables
SECRET_PATH="$1"
VAULT_TOKEN="${2:-$VAULT_TOKEN}"

if [[ -z "$SECRET_PATH" ]]; then
    echo "Usage: $0 <secret_path> [vault_addr] [vault_token]"
#    exit 1
fi

if [[ -z "$VAULT_TOKEN" ]]; then
    echo "Error: VAULT_TOKEN not set. Pass as argument or set VAULT_TOKEN env variable."
#    exit 1
fi

response=$(curl -s \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    "$VAULT_ADDR/v1/kv/data/$SECRET_PATH")

if echo "$response" | grep -q '"errors":\s*\['; then
    echo "Error fetching secret:"
    echo "$response"
#    exit 1
fi
echo "$response" | jq -r '.data.data'
