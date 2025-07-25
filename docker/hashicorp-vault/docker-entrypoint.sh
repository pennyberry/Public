#!/bin/sh
set -e

# Delegate to original entrypoint
exec /usr/local/bin/docker-entrypoint.sh $@ &
VAULT_PID=$!

# Wait for Vault to finalize start up.
export VAULT_ADDR="${VAULT_API_ADDR:-http://127.0.0.1:8200}"
export VAULT_TOKEN="${VAULT_DEV_ROOT_TOKEN_ID:-root}"
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

echo "Vault initialized"
wait $VAULT_PID