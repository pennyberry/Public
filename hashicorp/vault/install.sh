#make sure to set a hostfile 127.0.0.1 social.joeberry.org
#vars
source /home/joe/Public/hashicorp/vault/env-vars.env

#install
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update
sudo apt install vault

#certs
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

#config
sudo cp /home/joe/Public/hashicorp/vault/vault.hcl /etc/vault.d/vault.hcl

#service
systemctl daemon-reload
sudo systemctl enable vault
service vault start

#init
export VAULT_ADDR=https://${domainname}:8200
export VAULT_CACERT="/opt/vault/tls/tls.crt"
vault operator init > /home/joe/Public/hashicorp/vault/key.secrets
vault operator unseal $(grep "Unseal Key" /home/joe/Public/hashicorp/vault/key.secrets | awk 'NR==1 {print $NF}')
vault operator unseal $(grep "Unseal Key" /home/joe/Public/hashicorp/vault/key.secrets | awk 'NR==2 {print $NF}')
vault operator unseal $(grep "Unseal Key" /home/joe/Public/hashicorp/vault/key.secrets | awk 'NR==3 {print $NF}')

#login
vault login $(grep "Initial Root Token" /home/joe/Public/hashicorp/vault/key.secrets | awk 'NR==1 {print $NF}')