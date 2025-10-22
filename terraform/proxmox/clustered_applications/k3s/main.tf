module "k3s_server_node" {
    source = "../../vm_ubuntu"
    proxmox_vm_name = "k3s-server"
    username = var.username
    agent_enabled = true
    cpu_cores = var.k3s_server_cpu_cores
    memory = var.k3s_server_memory
    disk_size_gb = var.k3s_server_disk_size_gb
    proxmox_node_name = var.proxmox_node_name
    datastore_id = var.datastore_id
    image_datastore_id = var.image_datastore_id
    image_node_name = var.image_node_name
    network_bridge = var.k3s_server_network_bridge
    number_of_vms = 1
    SSH_PASSWORD = var.SSH_PASSWORD  
    #replace the placeholder in the script with actual token (which should be set as an env variable)
    remote_exec_script = repalce(replace(replace(file("${path.module}/install-k3s-server.sh"), "k3s_token", var.k3s_token), "k3s_cluster_ip", var.k3s_cluster_ip), "k3s_nfs_ip", var.k3s_nfs_ip)
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

module "k3s_agent" {
    source = "../../vm_ubuntu"
    proxmox_vm_name = "k3s-agent"
    username = var.username
    cpu_cores = var.k3s_agent_cpu_cores
    memory = var.k3s_agent_memory
    disk_size_gb = var.k3s_agent_disk_size_gb
    proxmox_node_name = var.proxmox_node_name
    datastore_id = var.datastore_id
    image_datastore_id = var.image_datastore_id
    image_node_name = var.image_node_name
    network_bridge = var.k3s_agent_network_bridge
    number_of_vms = var.number_of_k3s_agents
    SSH_PASSWORD = var.SSH_PASSWORD  
    #replace the placeholders in the script with actual server IP (which will be found automatically) and token (which should be set as an env variable)
    remote_exec_script = replace(replace(file("${path.module}/install-k3s-agent.sh"), "k3s-server-ip", module.k3s_server_node.ip[0]), "k3s_token", var.k3s_token)
}