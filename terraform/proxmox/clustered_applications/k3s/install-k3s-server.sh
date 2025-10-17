sudo curl -sfL https://get.k3s.io | sh -s - --flannel-backend none --token 12345 --with-node-id
sudo ufw allow 6443/tcp #apiserver
sudo ufw allow from 10.42.0.0/16 to any #pods
sudo ufw allow from 10.43.0.0/16 to any #services