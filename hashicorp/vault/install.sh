. cleanup.sh
source env-vars.env
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update
sudo apt install vault

# sudo cp /etc/letsencrypt/live/${domainname}/fullchain.pem /opt/vault/tls/tls.crt
# sudo cp /etc/letsencrypt/live/${domainname}/privkey.pem /opt/vault/tls/tls.key
# sudo chown vault:vault /opt/vault/tls/tls.crt
# sudo chown vault:vault /opt/vault/tls/tls.key

# sudo cp /etc/letsencrypt/live/${domainname}/fullchain.pem /opt/vault/tls/vault-cert.pem
# sudo cp /etc/letsencrypt/live/${domainname}/fullchain.pem /opt/vault/tls/vault-ca.pem
# sudo cp /etc/letsencrypt/live/${domainname}/privkey.pem /opt/vault/tls/vault-key.pem
# sudo chown root:root /opt/vault/tls/vault-cert.pem /opt/vault/tls/vault-ca.pem
# sudo chown root:vault /opt/vault/tls/vault-key.pem
# sudo chmod 0644 /opt/vault/tls/vault-cert.pem /opt/vault/tls/vault-ca.pem
# sudo chmod 0640 /opt/vault/tls/vault-key.pem

#create transit vault for auto-unseal
vault server -dev -dev-root-token-id root &
sleep 1
# Set the environment variables: VAULT_ADDR and VAULT_TOKEN
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root
# Enable and configure transit secrets engine
vault secrets enable transit
vault write -f transit/keys/autounseal
# Create an autounseal policy
vault policy write autounseal -<<EOF
path "transit/encrypt/autounseal" {
   capabilities = [ "update" ]
}

path "transit/decrypt/autounseal" {
   capabilities = [ "update" ]
}
EOF

# Create a token for main vault to use for root key encryption
vault token create -orphan -policy="autounseal" -wrap-ttl=120 -period=24h -field=wrapping_token > wrapping-token.txt
export VAULT_TOKEN=$(vault unwrap -field=token $(cat wrapping-token.txt))
rm /home/joe/Public/hashicorp/vault/wrapping-token.txt

#create main vault
sudo cp /home/joe/Public/hashicorp/vault/vault.hcl /etc/vault.d/vault.hcl
mkdir -p vault/vault-2
VAULT_ADDR=http://127.0.0.1:8100
vault server -config=/etc/vault.d/vault.hcl &
vault operator init > key.txt

# sudo systemctl daemon-reload
# sudo systemctl enable vault
# sudo systemctl start vault
# sudo systemctl status vault
