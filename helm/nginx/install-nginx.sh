#https://learn.microsoft.com/en-us/azure/aks/ingress-tls
#this should live on the same namespace as your app
#this configures an INTERNAL IP on your AKS cluster, not a public IP
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
#namespace=insertnamespacenamehere
helm install ingress-nginx ingress-nginx/ingress-nginx --create-namespace --namespace $namespace --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal"=true