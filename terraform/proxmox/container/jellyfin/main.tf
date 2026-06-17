module "container" {
    source = "../module"
    proxmox_container_hostname = "jellyfin"
    vm_id = var.vm_id
    cpu_cores = var.cpu_cores
    memory_mb = var.memory_mb
    swap_mb = var.swap_mb
    gateway_ipv4 = var.gateway_ipv4
    ipv4_address = var.ipv4_address
    proxmox_container_user_password = var.proxmox_container_user_password
    proxmox_container_disk_size_gb = var.proxmox_container_disk_size_gb
    proxmox_container_datastore_id = var.proxmox_container_datastore_id
    proxmox_container_node_name = var.proxmox_container_node_name
    proxmox_image_datastore_id = var.proxmox_image_datastore_id
    proxmox_container_mount_point_settings = var.proxmox_container_mount_point_settings
    proxmox_container_device_passthrough_path = "/dev/dri/renderD128"
    proxmox_container_network_interface_name = "eth0"
    proxmox_container_operating_system_type = "debian"
    proxmox_oci_image_reference = "jellyfin/jellyfin:latest"
    unprivileged = true
    SSH_PASSWORD = var.SSH_PASSWORD
}

variable "SSH_PASSWORD" {}