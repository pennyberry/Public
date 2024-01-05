source /home/joe/Public/hashicorp/vault/env-vars.env
export VAULT_ADDR=https://${domainname}:8200
export VAULT_CACERT="/opt/vault/tls/tls.crt"
vault operator unseal $(grep "Unseal Key" /home/joe/Public/hashicorp/vault/key.secrets | awk 'NR==1 {print $NF}')
vault operator unseal $(grep "Unseal Key" /home/joe/Public/hashicorp/vault/key.secrets | awk 'NR==2 {print $NF}')
vault operator unseal $(grep "Unseal Key" /home/joe/Public/hashicorp/vault/key.secrets | awk 'NR==3 {print $NF}')
vault login $(grep "Initial Root Token" /home/joe/Public/hashicorp/vault/key.secrets | awk 'NR==1 {print $NF}')