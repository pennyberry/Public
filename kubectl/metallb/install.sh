#https://metallb.io/installation/
# Configure MetalLB with a Layer 2 address pool
sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.3/config/manifests/metallb-native.yaml

#wait for deployment to complete
sudo kubectl rollout status deployment -n metallb-system
