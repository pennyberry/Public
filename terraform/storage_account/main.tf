terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  name     = var.azurerm_resource_group_name
  location = var.azurerm_resource_group_location
  tags = var.tags
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "${random_string.resource_code.result}tfstate"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

data "azurerm_storage_account_sas" "sas" {
    
    connection_string = "${azurerm_storage_account.tfstate.primary_connection_string}"
    https_only        = true
    resource_types {
        service   = true
        container = true
        object    = false
    }
    services {
        blob  = true
        queue = false
        table = false
        file  = false
    }
    start   = "2023-04-21"
    expiry  = "2080-03-21"
    permissions {
        filter  = false
        read    = true
        write   = true
        delete  = false
        list    = false
        add     = true
        create  = true
        update  = false
        process = false
        tag     = false
    }
}