sudo apt install ssh -y
sudo ufw allow ssh
read -rsp $'Enter the ssh public key - located in ~/.ssh/id_rsa.pub \n' ssh_public_key
echo $ssh_public_key >> ~/.ssh/authorized_keys
read -rsp $'You will want to copy your private key from your local machine. it is multi-line but located at ~/.ssh/id_rsa . press enter to continue.... \n'