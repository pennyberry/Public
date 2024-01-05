sudo pgrep -f vault | xargs kill
unset VAULT_TOKEN VAULT_ADDR VAULT_CACERT
echo "y" | sudo apt remove vault
echo "y" | sudo apt purge vault
systemctl stop vault
sudo killall -u vault && sudo deluser --remove-home -f vault
sudo userdel -f vault
systemctl daemon-reload
sudo rm -rf /opt/vault