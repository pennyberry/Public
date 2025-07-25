#!/bin/sh
set -e

# Delegate to original entrypoint
exec /usr/local/bin/docker-entrypoint.sh $@ &
VAULT_PID=$!

# Wait for Vault to finalize start up.
export VAULT_ADDR="${VAULT_API_ADDR}"
export VAULT_TOKEN="${VAULT_DEV_ROOT_TOKEN_ID}"
until vault status >/dev/null 2>&1; do
  sleep 1
done

# Run init scripts in /docker-entrypoint-initvault.d/
if [ -d "/docker-entrypoint-initvault.d" ]; then
  for script in /docker-entrypoint-initvault.d/*.sh; do
    if [ -f "$script" ]; then
      echo "Running $script..."
      sh "$script"
    fi
  done
fi

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

echo "Vault initialized"
wait $VAULT_PID