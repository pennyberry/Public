#get the pod name
kubectl get pods -l tag=npm-plus

$npmpod = Read-Host "Enter the npm-plus pod name from the list above"
$podname = Read-Host "Enter the crowsec pod name from the list above"
$ipaddressrange = Read-Host "Enter the IP address or range you want to allowlist (example: 192.168.1.0/24)"

#create api token
kubectl exec -it $podname -- /bin/bash -c "cscli bouncers add npmplus -o raw"

#update crowdsec.conf file to enable API and set enabled to true
kubectl exec -it $npmpod -- /bin/bash -c "vi /data/crowdsec/crowdsec.conf"

#show bouncers
kubectl exec -it $podname -- /bin/bash -c "cscli bouncers list"

#create an allowlist
kubectl exec -it $podname -- /bin/bash -c "cscli allowlist create my_allowlist -d 'created from the docs'"

# add IP to allowlist
kubectl exec -it $podname -- /bin/bash -c "cscli allowlist add my_allowlist $ipaddressrange"

#view the allowlist
kubectl exec -it $podname -- /bin/bash -c "cscli allowlist inspect my_allowlist"

#restart crowdsec service
kubectl delete pod $podname
kubectl delete pod $npmpod


#view existing decisions
# kubectl exec -it $podname -- /bin/bash -c "cscli decisions list"

#check logs for a specific IP
# kubectl exec -it $podname -- /bin/bash -c "grep 192.168.1.1 /opt/npmplus/nginx/logs/access.log | tail -n 1 | cscli explain -f- --type login"