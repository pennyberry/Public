#get the pod name
$podname = kubectl get pods -l tag=crowdsec -o jsonpath="{.items[*].metadata.name}"

#logs of crowdsec pod
kubectl logs $podname -f

#generictasks
kubectl exec -it $podname -- /bin/bash

$token = Read-Host "Enter the API token for the securit engine"
kubectl exec -it $podname -- /bin/bash -c "cscli console enroll $token"

#create api token
kubectl exec -it $podname -- /bin/bash -c "cscli bouncers add bouncer -o raw"

#show bouncers
kubectl exec -it $podname -- /bin/bash -c "cscli bouncers list"

#install collections
kubectl exec -it $podname -- /bin/bash -c "cscli collections install crowdsecurity/base-http-scenarios"

#create an allowlist
kubectl exec -it $podname -- /bin/bash -c "cscli allowlist create my_allowlist -d 'created from the docs'"

# add IP to allowlist
$ipaddressrange = Read-Host "Enter the IP address or range you want to allowlist (example: 192.168.1.0/24)"
kubectl exec -it $podname -- /bin/bash -c "cscli allowlist add my_allowlist $ipaddressrange"

#view the allowlist
kubectl exec -it $podname -- /bin/bash -c "cscli allowlist inspect my_allowlist"

#restart crowdsec service
kubectl delete pod $podname

#view existing decisions
kubectl exec -it $podname -- /bin/bash -c "cscli decisions list"

#check logs for a specific IP
# kubectl exec -it $podname -- /bin/bash -c "grep 192.168.1.1 /opt/npmplus/nginx/logs/access.log | tail -n 1 | cscli explain -f- --type login"

#check logs from traefik
$traefikpod = kubectl get pods -l app.kubernetes.io/name=traefik -n kube-system -o jsonpath="{.items[*].metadata.name}"
kubectl logs $traefikpod -n kube-system -f