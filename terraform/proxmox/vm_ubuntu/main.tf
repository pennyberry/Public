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
    username = "root@pam"
    ssh {
        agent    = true
        username = "root"
        private_key = sensitive(file("~/.ssh/id_rsa"))
    }
}

locals {
  vm_indexes = range(var.number_of_vms)
  vm_names = var.number_of_vms == 1 ? [var.proxmox_vm_name] : [for i in local.vm_indexes : "${var.proxmox_vm_name}-${i}"]
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
    count       = var.number_of_vms
    name        = local.vm_names[count.index]
    description = "Managed by Terraform"
    tags        = ["terraform", "ubuntu"]
    node_name   = var.proxmox_node_name
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
      import_from  = data.proxmox_virtual_environment_file.latest_ubuntu_24_noble_qcow2_img.id
      size = var.disk_size_gb
    }
    network_device {
      bridge = var.network_bridge
    }
    lifecycle {
      ignore_changes = [ disk, node_name, agent, initialization, cpu, memory, hostpci ]
    }
    provisioner "remote-exec" {
      when = create
      inline = [var.remote_exec_script]
      connection {
        type        = "ssh"
        user        = var.username
        private_key = sensitive(file("~/.ssh/id_rsa"))
        host = [for ip in flatten(self.ipv4_addresses) : ip if substr(ip, 0, 4) != "127."][0]

        timeout     = "2m"
      }
    }
    initialization { 
      user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config[count.index].id
      datastore_id = var.image_datastore_id
      ip_config {
        ipv4 {
          address = "dhcp"
        }
      }
    }
}

data "proxmox_virtual_environment_file" "latest_ubuntu_24_noble_qcow2_img" {
  node_name = var.proxmox_node_name
  datastore_id = "iso-storage"
  content_type = "import"
  file_name    = "ubuntu-noble-amd64.qcow2"
}

data "local_sensitive_file" "ssh_key" {
  filename = pathexpand("~/.ssh/id_rsa.pub")
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  count = var.number_of_vms
  content_type = "snippets"
  datastore_id = var.image_datastore_id
  node_name    = var.image_node_name


  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: "${local.vm_names[count.index]}"
    timezone: America/New_York
    users:
      - default
      - name: ${var.username}
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(data.local_sensitive_file.ssh_key.content)}
        sudo: ALL=(ALL) NOPASSWD:ALL
    package_update: true
    packages:
      - qemu-guest-agent
      - net-tools
      - curl
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - sleep 5
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "user-data-cloud-config-${local.vm_names[count.index]}.yaml"
  }
}

output "ip" {
  value = [for ip in flatten(proxmox_virtual_environment_vm.ubuntu_vm.*.ipv4_addresses) : ip if substr(ip, 0, 4) != "127."]
}
output "name" {
  value = proxmox_virtual_environment_vm.ubuntu_vm.*.name
}