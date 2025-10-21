sudo curl -sfL https://get.k3s.io | sh -s - agent --server https://k3s-server-ip:6443 --token k3s_token
sudo ufw allow 6443/tcp #apiserver
sudo ufw allow from 10.42.0.0/16 to any #pods
sudo ufw allow from 10.43.0.0/16 to any #services