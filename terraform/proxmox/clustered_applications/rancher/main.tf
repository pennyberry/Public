module "rancher_control_node" {
    source = "../../vm_ubuntu"
    proxmox_vm_name = "rancher"
    username = "joe"
    agent_enabled = true
    cpu_cores = 2
    cpu_sockets = 1
    cpu_type = "x86-64-v2-AES"
    memory = 2048
    proxmox_node_name = "kiwi"
    datastore_id = "nvme"
    interface = "scsi0"
    image_datastore_id = "iso-storage"
    image_node_name = "kiwi"
    network_bridge = "vmbr0"
    number_of_vms = 1
    SSH_PASSWORD = var.SSH_PASSWORD  
    remote_exec_script = file("${path.module}/install-k3s.sh")
}
# Note: Provider credentials (SSH_PASSWORD, PROXMOX_VE_ENDPOINT, and PROXMOX_VE_API_TOKEN) are expected to be supplied
# via environment variables as recommended by the proxmox provider.

variable "SSH_PASSWORD" {}
output "ip" {
  value = module.rancher_control_node.*.ip
}
