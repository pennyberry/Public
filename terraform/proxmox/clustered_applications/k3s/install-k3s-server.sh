#install k3s server - we're not using the default servicelb, we're using MetalLB instead
sudo curl -sfL https://get.k3s.io | sh -s - --token k3s_token --disable=traefik,servicelb
sudo ufw allow 6443/tcp #apiserver
sudo ufw allow from 10.42.0.0/16 to any #pods
sudo ufw allow from 10.43.0.0/16 to any #services

#install nfs client for nfs storage class
sudo apt-get install -y nfs-common

# Configure MetalLB with a Layer 2 address pool
sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml

#wait for deployment to complete
sudo kubectl rollout status deployment -n metallb-system

# Apply MetalLB configuration with the dedicated external IP - make sure you set k3s_cluster_ip variable in your terraform code / env variables!
sudo kubectl apply -f - <<'EOF'
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
    name: metallbaddresspool
    namespace: metallb-system
spec:
    addresses:
        - k3s_cluster_ip/32
---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
    name: metallbaddresspool-nginx
    namespace: metallb-system
spec:
    addresses:
        - k3s_nginx_cluster_ip/32
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
    name: layer2advertisement
    namespace: metallb-system
spec:
    ipAddressPools:
        - metallbaddresspool
        - metallbaddresspool-nginx
EOF

#apply TrueNAS NFS persistent volume
sudo kubectl apply -f - <<'EOF'
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: truenas
spec:
  capacity:
    storage: 39Ti
  storageClassName: nfs
  accessModes:
    - ReadWriteMany
  nfs:
    server: k3s_nfs_ip
    path: /mnt/zfs/nfs
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: truenas-pvc
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 39Ti
  storageClassName: nfs
  volumeName: truenas
EOF