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

    ssh {
        agent    = true
        username = "terraform"
    }
}
resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
    name        = var.proxmox_vm_name
    description = "Managed by Terraform"
    tags        = ["terraform", "ubuntu"]
    node_name = var.proxmox_node_name
    vm_id     = var.proxmox_vm_id
    agent {
      enabled = var.agent_enabled
    }
    cpu {
      cores = var.cpu_cores
      sockets = var.cpu_sockets
      type = var.cpu_type
    }
    memory {
      dedicated = var.memory
      floating = var.memory
    }
    disk {
      datastore_id = var.datastore_id
      interface    = var.interface
      import_from  = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_qcow2_img.id
    }
    network_device {
      bridge = var.network_bridge
    }
    lifecycle {
      ignore_changes = [ disk ]
    }
    initialization {
      user_account {
        keys = [data.local_sensitive_file.ssh_key.content]
        username = var.username
      }
      ip_config {
        ipv4 {
          address = "dhcp"
        }
      }
    }
}
resource "proxmox_virtual_environment_download_file" "latest_ubuntu_24_noble_qcow2_img" {
  content_type = "import"
  datastore_id = var.image_datastore_id
  node_name    = var.image_node_name
  url = var.image_url
  file_name = var.image_file_name
}

data "local_sensitive_file" "ssh_key" {
  filename = pathexpand("~/.ssh/id_rsa.pub")
}