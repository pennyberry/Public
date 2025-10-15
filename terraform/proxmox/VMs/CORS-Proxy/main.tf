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
resource "proxmox_virtual_environment_vm" "test" {
    bios                    = "seabios"
    name                    = "CORS-Proxy"
    node_name               = "kiwi"
    scsi_hardware           = "virtio-scsi-single"
    vm_id                   = 106

    agent {
        enabled = false
    }

    cpu {
        cores        = 2
        hotplugged   = 0
        limit        = 0
        numa         = false
        sockets      = 1
        type         = "x86-64-v2-AES"
        units        = 1024
    }

    disk {
        aio               = "io_uring"
        backup            = true
        cache             = "none"
        datastore_id      = "nvme"
        discard           = "ignore"
        file_format       = "raw"
        interface         = "scsi0"
        iothread          = true
        path_in_datastore = "vm-106-disk-0"
        replicate         = true
        size              = 32
    }
        lifecycle {
            ignore_changes = [ disk ]
        }

    memory {
        dedicated      = 2048
    }

    network_device {
        bridge       = "vmbr0"
        enabled      = true
        firewall     = true
        model        = "virtio"
    }

    operating_system {
        type = "l26"
    }
}