#configure automatic upgrades for the cluster
sudo kubectl apply -f https://github.com/rancher/system-upgrade-controller/releases/latest/download/crd.yaml -f https://github.com/rancher/system-upgrade-controller/releases/latest/download/system-upgrade-controller.yaml

#wait for deployment to complete
sudo kubectl rollout status deployment -n system-upgrade

#create upgrade plans for server and agent nodes
sudo kubectl apply -f ./deployment.yaml

#note this is a hardcoded version. at the time of testing, the channel method was not working as expected.
#you can replace version with channel if you want to track a channel instead of a specific version... if it ever works...
#channel: https://update.k3s.io/v1-release/channels/stable

#to check on versions available
#https://update.k3s.io/v1-release/channels

#to check on updates, some commands you can run
#kubectl describe plan -n system-upgrade server-plan
#kubectl -n system-upgrade logs deployment.apps/system-upgrade-controller
#kubectl get plan -n system-upgrade -o wide
#kubectl -n system-upgrade describe jobs