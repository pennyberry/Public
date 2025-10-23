data "azurerm_resource_group" "rg" {
  name = var.vnet_rg_name
}
data "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}
data "azurerm_subnet" "subnet" {
  name = var.subnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}
data "terraform_remote_state" "remotestate" {
  backend = "local"
  config = {
    path = "../1_avd_workspace/terraform.tfstate"
  }
}