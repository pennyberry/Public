variable "proxmox_vm_name" {
    description = "Proxmox VM name."
    type        = string
}
variable "username" {}

variable "proxmox_node_name" {
    description = "Proxmox node name where the VM will be created."
    type        = string
    default     = "pve"
}

variable "agent_enabled" {
    description = "Whether the QEMU guest agent should be enabled."
    type        = bool
    default     = true
}

variable "cpu_cores" {
    description = "Number of CPU cores."
    type        = number
    default     = 2

    validation {
        condition     = var.cpu_cores >= 1
        error_message = "cpu_cores must be at least 1."
    }
}

variable "cpu_sockets" {
    description = "Number of CPU sockets."
    type        = number
    default     = 1

    validation {
        condition     = var.cpu_sockets >= 1
        error_message = "cpu_sockets must be at least 1."
    }
}

variable "cpu_type" {
    description = "CPU type exposed to the VM. Common values: host, qemu64, kvm64, kvm32."
    type        = string
    default     = "x86-64-v2-AES"

    validation {
        condition = contains([
            "x86-64-v2-AES",
            "486",
            "Broadwell", "Broadwell-IBRS", "Broadwell-noTSX", "Broadwell-noTSX-IBRS",
            "Cascadelake-Server", "Cascadelake-Server-noTSX", "Cascadelake-Server-v2", "Cascadelake-Server-v4", "Cascadelake-Server-v5",
            "Conroe",
            "Cooperlake", "Cooperlake-v2",
            "EPYC", "EPYC-Genoa", "EPYC-IBPB", "EPYC-Milan", "EPYC-Rome", "EPYC-Rome-v2", "EPYC-v3", "EPYC-v4",
            "Haswell", "Haswell-IBRS", "Haswell-noTSX", "Haswell-noTSX-IBRS",
            "Icelake-Client", "Icelake-Client-noTSX",
            "Icelake-Server", "Icelake-Server-noTSX", "Icelake-Server-v3", "Icelake-Server-v4", "Icelake-Server-v5", "Icelake-Server-v6",
            "IvyBridge", "IvyBridge-IBRS",
            "KnightsMill",
            "Nehalem", "Nehalem-IBRS",
            "Opteron_G1", "Opteron_G2", "Opteron_G3", "Opteron_G4", "Opteron_G5",
            "Penryn",
            "SandyBridge", "SandyBridge-IBRS",
            "SapphireRapids",
            "Skylake-Client", "Skylake-Client-IBRS", "Skylake-Client-noTSX-IBRS", "Skylake-Client-v4",
            "Skylake-Server", "Skylake-Server-IBRS", "Skylake-Server-noTSX-IBRS", "Skylake-Server-v4", "Skylake-Server-v5",
            "Westmere", "Westmere-IBRS",
            "athlon", "core2duo", "coreduo",
            "host",
            "kvm32", "kvm64",
            "max",
            "pentium", "pentium2", "pentium3",
            "phenom",
            "qemu32", "qemu64",
            "x86-64-v2", "x86-64-v3", "x86-64-v4"
        ], var.cpu_type)
        error_message = "cpu_type must be one of the supported CPU model strings (e.g. qemu64, host, x86-64-v2-AES, EPYC, Skylake-Server, etc.)."
    }
}

variable "memory" {
    description = "Amount of RAM in MiB."
    type        = number
    default     = 2048

    validation {
        condition     = var.memory >= 128
        error_message = "memory must be at least 128 MiB."
    }
}

variable "datastore_id" {
    description = "Datastore ID where the VM disk will be created/imported."
    type        = string
    default     = "nvme"
}

variable "interface" {
    description = "Disk interface for the VM (e.g. scsi, virtio, sata)."
    type        = string
    default     = "scsi0"
}

variable "image_url" {
    description = "Remote URL of the cloud image to download for import."
    type        = string
    default     = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

variable "image_file_name" {
    description = "Target file name (should end with .qcow2 for import)."
    type        = string
    default     = "noble-server-cloudimg-amd64.qcow2"
}

variable "image_datastore_id" {
    description = "Datastore used to store the downloaded image before import."
    type        = string
    default     = "iso-storage"
}

variable "image_node_name" {
    description = "Node used to download the cloud image."
    type        = string
    default     = "pve"
}

variable "network_bridge" {
    description = "Network bridge to attach the VM's network interface to."
    type        = string
    default     = "vmbr0"
}
variable "SSH_PASSWORD" {}

variable "number_of_vms" {
  description = "Number of VMs to create."
  type = number
  default = 1
}

variable "remote_exec_script" {
  description = "script to run via ssh after the machine has completed provisioning."
  type = string
  default = "hostname"
}
variable "disk_size_gb" {
  description = "Size of the VM disk in GB."
  type = number
  default = 10
}
# Note: Provider credentials (SSH_PASSWORD, PROXMOX_VE_ENDPOINT, and PROXMOX_VE_API_TOKEN) are expected to be supplied
# via environment variables as recommended by the proxmox provider.