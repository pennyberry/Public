read -rsp $'Enter the kubernetes node you would like to bring back into production \n' NODE_NAME

#uncordon the node
sudo kubectl uncordon $NODE_NAME

#check if the node is successfully uncordoned
sudo kubectl get nodes | grep $NODE_NAME