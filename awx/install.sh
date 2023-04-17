#install kustomize
#run terraform to create aks cluster
#connect to aks cluster 
#e.g. az aks get-credentials --resource-group rg-subtle-zebra --name k8stest
kustomize build . | kubectl apply -f -