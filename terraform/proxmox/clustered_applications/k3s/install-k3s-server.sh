sudo curl -sfL https://get.k3s.io | sh -s - --token k3s_token --disable=traefik,servicelb
sudo ufw allow 6443/tcp #apiserver
sudo ufw allow from 10.42.0.0/16 to any #pods
sudo ufw allow from 10.43.0.0/16 to any #services

# Configure MetalLB with a Layer 2 address pool
sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml

#wait for deployment to complete
sudo kubectl rollout status deployment -n metallb-system

sudo kubectl apply -f - <<'EOF'
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
    name: MetallbAddressPool
    namespace: metallb-system
spec:
    addresses:
        - k3s_cluster_ip/32
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
    name: Layer2Advertisement
    namespace: metallb-system
spec:
    ipAddressPools:
        - MetallbAddressPool
EOF
