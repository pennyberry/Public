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
    bios                    = "seabios"
    name                    = "OPNsense2"
    node_name               = "kiwi"
    scsi_hardware           = "virtio-scsi-single"
    vm_id                   = 109

    lifecycle {
      ignore_changes = [ timeout_move_disk, keyboard_layout, on_boot, reboot, migrate, disk, stop_on_destroy, reboot_after_update, timeout_clone, timeout_create , timeout_migrate, timeout_reboot, timeout_shutdown_vm, timeout_start_vm, timeout_stop_vm   ]
    }

    cpu {
        cores        = 6
        type         = "x86-64-v2-AES"
        units        = 1024
    }

    disk {
        aio               = "io_uring"
        datastore_id      = "nvme"
        interface         = "scsi0"
        path_in_datastore = "vm-109-disk-0"
        size              = 32
    }

    memory {
        dedicated      = 8192
    }

    network_device {
        bridge       = "vmbr0"
        firewall     = true
        model        = "virtio"
    }
    network_device {
        bridge       = "vmbr1"
        firewall     = true
        model        = "virtio"
    }

    operating_system {
        type = "l26"
    }
}