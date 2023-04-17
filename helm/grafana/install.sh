helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana --create-namespace --wait --namespace grafana