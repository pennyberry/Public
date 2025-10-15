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

resource "proxmox_virtual_environment_vm" "vm" {
    acpi                    = true
    bios                    = "seabios"
    name                    = "Ubuntu-Server-1"
    node_name               = "kiwi"
    scsi_hardware           = "virtio-scsi-single"
    vm_id                   = 111

    cpu {
        cores        = 6
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
        file_id           = null
        import_from       = null
        interface         = "scsi0"
        iothread          = true
        path_in_datastore = "vm-111-disk-0"
        replicate         = true
        serial            = null
        size              = 64
        ssd               = false
    }

    memory {
        dedicated      = 12288
    }

    network_device {
        bridge       = "vmbr0"
        firewall     = true
        model        = "virtio"
    }

    operating_system {
        type = "l26"
    }
}