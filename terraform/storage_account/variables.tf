variable "tags" {
   type = map
   default =  {
      "Environment" = "Development"
      "Creator" = "JoeBerry"
   }
}

variable "current_date" {
  default = timestamp()
}

variable "azurerm_resource_group_name" {}

variable "azurerm_resource_group_location" {
  default = "East US"
}