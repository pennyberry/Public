this ingress is used to proxy applications not inside the k3s cluster. 
since we assume we have only 1 public IP to use, we can only forward 443 traffic to 1 internal ip
as we we can only use 1 internal ip, we will use this ingress to route traffic to external services/VMs/applications in our network.