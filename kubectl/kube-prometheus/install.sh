git clone https://github.com/prometheus-operator/kube-prometheus.git
cd kube-prometheus
kubectl apply --server-side -f manifests/setup
kubectl wait \
    --for condition=Established \
    --all CustomResourceDefinition \
    --namespace=monitoring
kubectl apply -f manifests/

#patching this to allow access across namespaces
kubectl apply -f ~/gitlocal/Public/kubectl/kube-prometheus/prometheus-networkPolicy-patch.yaml