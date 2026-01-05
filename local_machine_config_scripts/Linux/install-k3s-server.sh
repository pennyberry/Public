#install k3s server
sudo curl -sfL https://get.k3s.io | sh -s - --token insert_your_k3s_token_here --disable=servicelb
sudo ufw allow 6443/tcp #apiserver
sudo ufw allow from 10.42.0.0/16 to any #pods
sudo ufw allow from 10.43.0.0/16 to any #services

#install nfs client for nfs storage class
sudo apt-get install -y nfs-common

#if you want to remotely manage k3s with kubectl from another machine, copy the kubeconfig file
#sudo cat /etc/rancher/k3s/k3s.yaml
#replace the server address with the server's IP in the yaml file
#copy the modified file to ~/.kube/config on your management machine

#also update your env variables for $env:KUBECONFIG