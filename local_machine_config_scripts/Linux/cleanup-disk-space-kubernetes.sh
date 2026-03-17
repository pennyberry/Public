#check images used
sudo k3s crictl images
#remove unused images
sudo k3s crictl rmi --prune