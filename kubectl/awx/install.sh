#install kustomize
# cd ~/Public/local_machine_config_scripts/Linux
# . install-kustomize.sh

#run terraform to create aks cluster
# cd ~/Public/terraform/aks_cluster
#terraform apply

#connect to aks cluster 
#e.g. az aks get-credentials --resource-group rg-subtle-zebra --name k8stest
cd ../../helm/nginx
namespace=awx
install.nginx.sh
cd ../../kubectl/awx
kubectl apply -k .

#wait about 3-4 minutes
#check logs
# . watch-logs.sh

#get default creds
#username : admin

#password
# . get-awx-password.sh

#ip is Azure Portal --> AKS Cluster --> Services and ingresses -->awx-service --> endpoints