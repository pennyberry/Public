#migrate from 1 to 2
##create api token at datacenter -> permissions -> api token -> add
##grant api token permissions at datacenter -> permissions  -> add
token='root@pam!TokenName=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx'
#fingerprint at node -> system -> certificates -> pve-ssl.pem (the sha256 fingerprint)
fingerprint=XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
#target node IP and port
host=192.168.x.x
port=8006
source_vm_id=107
target_vm_id=108
target_storage='local-lvm'
target_bridge='vmbr0'

qm remote-migrate $source_vm_id $target_vm_id "apitoken=PVEAPIToken=$token,host=$host,fingerprint=$fingerprint,port=$port" --target-storage $target_storage --target-bridge $target_bridge --online