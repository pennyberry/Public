#!/usr/bin/env sh

#logging
# set -x

export VAULT_ADDR="${VAULT_API_ADDR}"

#start up
vault server -config=/vault/config/config.hcl &
VAULT_PID=$!

#initialize Vault if keys file does not exist
until [ -s /vault/file/keys ]; do
  sleep 6
  vault operator init > /vault/file/keys
done


# unseal Vault
while true; do
  STATUS_OUTPUT=$(vault status 2>/dev/null)
  SEALED=$(echo "$STATUS_OUTPUT" | grep '^Sealed' | awk '{print $2}')
  INITIALIZED=$(echo "$STATUS_OUTPUT" | grep '^Initialized' | awk '{print $2}')
  echo "Vault status: Sealed=$SEALED, Initialized=$INITIALIZED"
  if [ "$SEALED" = "false" ] && [ "$INITIALIZED" = "true" ]; then
    break
  fi
  if [ "$SEALED" = "true" ]; then
    echo "Vault is sealed, unsealing..."
    vault operator unseal $(grep 'Key 1:' /vault/file/keys | awk '{print $NF}')
    vault operator unseal $(grep 'Key 2:' /vault/file/keys | awk '{print $NF}')
    vault operator unseal $(grep 'Key 3:' /vault/file/keys | awk '{print $NF}')
  fi
  echo "Waiting for Vault to be unsealed and initialized..."
  sleep 1
done

#login
export ROOT_TOKEN=$(grep 'Initial Root Token:' /vault/file/keys | awk '{print $NF}')
vault login $ROOT_TOKEN

#OIDC Configuration
vault auth enable oidc

vault write auth/oidc/config \
    oidc_discovery_url="${VAULT_OIDC_DISCOVERY_URL}" \
    oidc_client_id=${VAULT_OIDC_CLIENT_ID} \
    oidc_client_secret=${VAULT_OIDC_CLIENT_SECRET} \
    default_role=default \

vault write auth/oidc/role/default \
    user_claim=email \
    oidc_scopes=email \
    allowed_redirect_uris=${VAULT_OIDC_REDIRECT_URI}

#create admin policy
cat > admin.hcl <<EOF
path "*" {
    capabilities = ["sudo","read","create","update","delete","list","patch"]
}
EOF
vault policy write admin admin.hcl

#keep vault running
wait $VAULT_PID