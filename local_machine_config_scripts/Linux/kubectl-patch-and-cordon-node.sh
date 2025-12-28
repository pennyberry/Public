read -rsp $'Enter the kubernetes node you would like to patch and drain all nodes from \n' NODE_NAME

#evict pods from the node
sudo kubectl drain $NODE_NAME --ignore-daemonsets --delete-emptydir-data

#check if the node is successfully drained
sudo kubectl get pods --all-namespaces -o wide | grep $NODE_NAME

#do this on the node to be patched
# sudo apt update
# sudo apt upgrade -y

#sudo reboot