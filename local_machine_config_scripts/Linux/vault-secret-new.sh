#!/bin/bash

#usage: ./vault-secret-new.sh <secret_path> <secret_value> [vault_token]

SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
ENV_FILE="$SCRIPT_DIR/env-vars.env"
source "$ENV_FILE"
VAULT_ADDR="${VAULT_LOCATION}"

SECRET_PATH="$1"
SECRET_VALUE="$2"
VAULT_TOKEN="${3:-$VAULT_TOKEN}"

if [[ -z "$SECRET_PATH" || -z "$SECRET_VALUE" ]]; then
    echo "Usage: $0 <secret-path> <secret-value> [vault-token]"
fi

response=$(curl -s --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data "{\"data\": {\"value\": \"$SECRET_VALUE\"}}" \
    "$VAULT_ADDR/v1/kv/data/$SECRET_PATH")

echo "$response" | jq