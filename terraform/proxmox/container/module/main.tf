terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      #https://registry.terraform.io/providers/bpg/proxmox/latest/docs
    }
  }
}
provider "proxmox" {

  # PROXMOX_VE_ENDPOINT use an environment variable for this!
  # e.g. "https://pve.yourdomain.com:8006/"

  # PROXMOX_VE_API_TOKEN use an environment variable for this!
  # run configure-pve-access.sh on your Proxmox server to create a user for terraform
  # e.g. "terraform@pve!provider=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  
  # IMPORTANT for some reason, device_passthrough and mount_point require username+password auth instead of api auth
  # set any environment variables to null that reference the api token
  # $env:PROXMOX_VE_API_TOKEN = $null
  insecure = true
  username = "root@pam"
  password = var.SSH_PASSWORD
  ssh {
    agent       = true
    username    = "root@pam"
  }
}

resource "proxmox_virtual_environment_container" "container" {
  description = "Managed by Terraform"

  node_name = var.proxmox_container_node_name
  vm_id     = var.vm_id
  cpu {
    cores = var.cpu_cores
  }
  memory {
    dedicated = var.memory_mb
    swap      = var.swap_mb
  }

  unprivileged = var.unprivileged
  
  console {
    enabled = true
    tty_count = 2
    type = "console"
  }

  initialization {
    hostname = var.proxmox_container_hostname 

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.gateway_ipv4
      }
    }

    user_account {
      keys = [
        sensitive(file("~/.ssh/id_rsa.pub"))
      ]
      password = var.proxmox_container_user_password
    }
  }

  network_interface {
    name = var.proxmox_container_network_interface_name
    enabled = true
    host_managed = true
  }

  disk {
    datastore_id = var.proxmox_container_datastore_id
    size         = var.proxmox_container_disk_size_gb
  }
  dynamic "mount_point" {
    for_each = var.proxmox_container_mount_point_settings
    content {
      volume = mount_point.value["source"]
      path   = mount_point.value["destination"]
    }
  }

  operating_system {
    template_file_id = proxmox_oci_image.ct_template.id
    type             = var.proxmox_container_operating_system_type
  }
  device_passthrough {
    path = var.proxmox_container_device_passthrough_path
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to the container's configuration that are expected to be modified outside of Terraform (e.g. via Proxmox UI or CLI)
      environment_variables,
      initialization
    ]
  }
}

resource "proxmox_oci_image" "ct_template" {
  node_name    = var.proxmox_container_node_name
  datastore_id = var.proxmox_image_datastore_id
  reference    = var.proxmox_oci_image_reference
}