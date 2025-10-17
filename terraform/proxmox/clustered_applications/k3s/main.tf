module "k3s_server_node" {
    source = "../../vm_ubuntu"
    proxmox_vm_name = "k3s-server"
    username = var.username
    agent_enabled = true
    cpu_cores = 2
    cpu_sockets = 1
    cpu_type = "x86-64-v2-AES"
    memory = 4096
    disk_size_gb = 25
    proxmox_node_name = "kiwi"
    datastore_id = "nvme"
    interface = "scsi0"
    image_datastore_id = "iso-storage"
    image_node_name = "kiwi"
    network_bridge = "vmbr0"
    number_of_vms = 1
    SSH_PASSWORD = var.SSH_PASSWORD  
    remote_exec_script = file("${path.module}/install-k3s-server.sh")
}

resource "null_resource" "get-kubectl-config" {
  provisioner "local-exec" {
    command = "ssh -o StrictHostKeyChecking=no ${var.username}@${module.k3s_server_node.ip[0]} sudo cat /etc/rancher/k3s/k3s.yaml > ${pathexpand("~/.kube/${module.k3s_server_node.name[0]}.yaml")}"
  }

  triggers = {
    vm_ip = module.k3s_server_node.ip[0]
  }

  depends_on = [ module.k3s_server_node ]
}

variable "username" {
  default = "joe"
}

variable "SSH_PASSWORD" {
  description = "Note: Provider credentials (SSH_PASSWORD, PROXMOX_VE_ENDPOINT, and PROXMOX_VE_API_TOKEN) are expected to be supplied via environment variables as recommended by the proxmox provider."
}

output "ip" {
  value = module.k3s_server_node.*.ip[0][0]
}

output "Windows_Kubectl_command" {
  value = "$env:KUBECONFIG = '${pathexpand("~/.kube/${module.k3s_server_node.name[0]}.yaml")}'"
}
output "Command_to_Update_IP_on_kube_config_yaml" {
  value = <<EOT
(get-content ~\.kube\k3s-server.yaml).Replace("127.0.0.1","${module.k3s_server_node.ip[0]}") | set-content ~\.kube\k3s-server.yaml
EOT
}