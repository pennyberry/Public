variable "tags" {
   type = map
   default =  {
      "Environment" = "Development"
      "Creator" = "JoeBerry"
   }
}

variable "agent_count" {
  default = 3
}

variable "aks_service_principal_app_id" {}

variable "aks_service_principal_client_secret" {}

variable "cluster_name" {
  default = "k8stest"
}

variable "dns_prefix" {
  default = "k8stest"
}

variable "log_analytics_workspace_location" {
  default = "eastus"
}

variable "azurerm_log_analytics_solution_solution_name" {
  default = "ContainerInsights"
}

variable "azurerm_log_analytics_solution_plan_product" {
  default = "OMSGallery/ContainerInsights"
}

variable "azurerm_log_analytics_solution_plan_publisher" {
  default = "Microsoft"
}

variable "log_analytics_workspace_name" {
  default = "testLogAnalyticsWorkspaceName"
}

# Refer to https://azure.microsoft.com/pricing/details/monitor/ for Log Analytics pricing
variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}

variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}
variable "azurerm_kubernetes_cluster_default_node_pool_vm_size" {
  default = "Standard_D4s_v5"
}
variable "azurerm_kubernetes_cluste_default_node_pool_name" {
  default = "agentpool"
}
variable "azurerm_kubernetes_cluster_linux_profile_admin_username" {
  default = "ubuntu"
}
variable "azurerm_kubernetes_cluster_network_profile_network_plugin" {
  default = "azure"
}
variable "azurerm_kubernetes_cluster_network_profile_load_balancer_sku" {
  default = "standard"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}
variable "vnet_subnet_id" {}
variable "virtual_network_name" {}
variable "subnet_name" {
  default = "AKS-Subnet"
}
variable "subnet_address_prefixes" {}
variable "subnet_resource_group_name" {}
variable "aks_address_prefixes" {}
variable "dns_service_ip" {}