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
    insecure = true
    ssh {
        agent    = true
        username = "root"
        password = var.SSH_PASSWORD
    }
}

locals {
    proxmox_hosts = toset(var.proxmox_hosts)
}

resource "proxmox_virtual_environment_download_file" "latest_ubuntu_24_noble_qcow2_img" {
  for_each = local.proxmox_hosts
  content_type = "import"
  datastore_id = var.datastore_id
  node_name    = each.key
  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  file_name = "ubuntu-noble-amd64.qcow2"
}