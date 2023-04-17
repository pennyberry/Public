#install kustomize
# cd ~/Public/local_machine_config_scripts/Linux
# . install-kustomize.sh

#run terraform to create aks cluster
# cd ~/Public/terraform/aks_cluster
#terraform apply

#connect to aks cluster 
#e.g. az aks get-credentials --resource-group rg-subtle-zebra --name k8stest
kustomize build . | kubectl apply -f -