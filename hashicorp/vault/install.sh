source env-vars.env
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update
sudo apt install vault

sudo cp /etc/letsencrypt/live/${domainname}/fullchain.pem /opt/vault/tls/tls.crt
sudo cp /etc/letsencrypt/live/${domainname}/privkey.pem /opt/vault/tls/tls.key
sudo chown vault:vault /opt/vault/tls/tls.crt
sudo chown vault:vault /opt/vault/tls/tls.key

sudo cp /etc/letsencrypt/live/${domainname}/fullchain.pem /opt/vault/tls/vault-cert.pem
sudo cp /etc/letsencrypt/live/${domainname}/fullchain.pem /opt/vault/tls/vault-ca.pem
sudo cp /etc/letsencrypt/live/${domainname}/privkey.pem /opt/vault/tls/vault-key.pem
sudo chown root:root /opt/vault/tls/vault-cert.pem /opt/vault/tls/vault-ca.pem
sudo chown root:vault /opt/vault/tls/vault-key.pem
sudo chmod 0644 /opt/vault/tls/vault-cert.pem /opt/vault/tls/vault-ca.pem
sudo chmod 0640 /opt/vault/tls/vault-key.pem

#sudo cp ~/Public/hashicorp/vault/vault.hcl /etc/vault.d/vault.hcl

sudo systemctl enable vault.service
sudo systemctl restart vault.service
sudo systemctl status vault.service
vault status