#auth to your aks cluster before running
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade my-cert-manager jetstack/cert-manager \
    --install \
    --create-namespace \
    --wait \
    --namespace cert-manager \
    --set installCRDs=true

#make sure you install homebrew + envsubst + cmctl
#follow https://cert-manager.io/docs/tutorials/getting-started-aks-letsencrypt/