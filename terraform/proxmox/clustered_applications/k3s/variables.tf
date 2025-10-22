variable "username" {
  default = "joe"
}

variable "SSH_PASSWORD" {
  description = "Note: Provider credentials (SSH_PASSWORD, PROXMOX_VE_ENDPOINT, and PROXMOX_VE_API_TOKEN) are expected to be supplied via environment variables as recommended by the proxmox provider."
}

variable "k3s_token" {
  description = "Note: Provider credentials (k3s_token, SSH_PASSWORD, PROXMOX_VE_ENDPOINT, and PROXMOX_VE_API_TOKEN) are expected to be supplied via environment variables as recommended by the proxmox provider."
}

variable "proxmox_node_name" {
  description = "Enter the Proxmox node name where the VMs will be created."
}

variable "k3s_server_cpu_cores" {
  default = 2
}

variable "k3s_server_memory" {
  default = 4096
}

variable "k3s_server_network_bridge" {
  default = "vmbr0"
}

variable "k3s_agent_network_bridge" {
  default = "vmbr0"
}

variable "k3s_server_disk_size_gb" {
  default = 25
}

variable "datastore_id" {
  description = "Enter the name of the storage in Proxmox that will store the VM disks"
}

variable "number_of_k3s_agents" {
  default = 2
}

variable "image_datastore_id" {
  description = "Enter the datastore ID which will hold the image for the OS"
}

variable "image_node_name" {
  description = "Enter the Proxmox node name where the OS image datastore is located"
}

variable "k3s_agent_cpu_cores" {
  default = 2
}

variable "k3s_agent_memory" {
  default = 4096
}

variable "k3s_agent_disk_size_gb" {
  default = 25
}

variable "k3s_cluster_ip" {
  description = "dedicated MetalLB cluster IP that will be used in install-k3s-server.sh when building the server. Grab an unused IP from your network and set it here. Make sure you allocate the IP if using DHCP."
}

variable "k3s_nfs_ip" {
  description = "NFS IP for persistent storage"
}