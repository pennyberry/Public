variable "SSH_PASSWORD" {}

variable "proxmox_hosts" {
    type    = list(string)
    default = ["kiwi", "pve2", "pve3"]
}

variable "datastore_id" {
  default = "iso-storage"
}