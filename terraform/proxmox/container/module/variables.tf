variable "proxmox_container_node_name" {
  description = "The name of the Proxmox node where the container will be created."
  type        = string
}

variable "vm_id" {
  description = "The unique ID to assign to the container (CT ID)."
  type        = number
}

variable "cpu_cores" {
  description = "Number of CPU cores to allocate to the container."
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "Amount of memory (in MB) to allocate for dedicated and swap."
  type        = number
  default     = 1024
}
variable "swap_mb" {
  description = "Amount of swap memory (in MB) to allocate for the container."
  type        = number
  default     = 512
}

variable "unprivileged" {
  description = "Whether the container runs in unprivileged mode."
  type        = bool
  default     = true
}

variable "proxmox_container_hostname" {
  description = "Hostname to assign to the container."
  type        = string
}

variable "proxmox_container_user_password" {
  description = "Password for the container's default user account."
  type        = string
  sensitive   = true
}

variable "proxmox_container_network_interface_name" {
  description = "Name of the network interface inside the container (e.g. 'eth0')."
  type        = string
  default     = "eth0"
}

variable "proxmox_container_datastore_id" {
  description = "Datastore ID on the Proxmox node used for the container disk and OCI image."
  type        = string
}
variable "proxmox_image_datastore_id" {
  description = "Datastore ID on the Proxmox node used for storing the pulled OCI image."
  type        = string
}

variable "proxmox_container_disk_size_gb" {
  description = "Root disk size for the container in GB."
  type        = number
  default     = 16
}

variable "proxmox_container_mount_point_settings" {
  description = "List of mount points to attach to the container. Each entry requires a 'source' (host volume or path) and a 'destination' (path inside the container)."
  type = list(object({
    source      = string
    destination = string
  }))
  default = []
}

variable "proxmox_container_operating_system_type" {
  description = "OS type hint for the container (e.g. 'debian', 'ubuntu', 'alpine')."
  type        = string
  default     = "unmanaged"
}

variable "proxmox_container_device_passthrough_path" {
  description = "Host device path to pass through into the container (e.g. '/dev/dri/card0')."
  type        = string
  default     = null
}

variable "proxmox_oci_image_reference" {
  description = "OCI image reference to use as the container template (e.g. 'docker.io/library/debian:latest')."
  type        = string
}

variable "SSH_PASSWORD" {}

variable "ipv4_address" {
  description = "Static IPv4 address to assign to the container (e.g. 192.168.1.123/24)"
  type        = string
  default     = null
}

variable "gateway_ipv4" {
  description = "Gateway IPv4 address for the container's network configuration"
  type        = string
  default     = "192.168.1.1"
}