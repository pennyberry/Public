read -rsp $'Enter the ip address of your nfs server \n' server_ip

#install nfs client
sudo apt install nfs-common -y
sudo mkdir /mnt/zfs
sudo mkdir /mnt/zfs/nfs
sudo mount $server_ip:/mnt/zfs/nfs /mnt/zfs/nfs
echo "$server_ip:/mnt/zfs/nfs /mnt/zfs/nfs nfs defaults 0 0" | sudo tee -a /etc/fstab