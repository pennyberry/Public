sudo pgrep -f vault | xargs kill
sudo rm -rf /home/joe/Public/hashicorp/vault/vault
sudo rm -rf /home/joe/Public/hashicorp/vault/key.txt
sudo rm -rf /home/joe/Public/hashicorp/vault/vault-1.log
unset VAULT_TOKEN VAULT_ADDR