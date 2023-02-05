resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
  tags = var.tags
}

resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "test" {
  location            = var.log_analytics_workspace_location
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.log_analytics_workspace_sku
  tags = var.tags
}

resource "azurerm_log_analytics_solution" "test" {
  location              = azurerm_log_analytics_workspace.test.location
  resource_group_name   = azurerm_resource_group.rg.name
  solution_name         = var.azurerm_log_analytics_solution_solution_name
  workspace_name        = azurerm_log_analytics_workspace.test.name
  workspace_resource_id = azurerm_log_analytics_workspace.test.id
  tags = var.tags

  plan {
    product   = var.azurerm_log_analytics_solution_plan_product
    publisher = var.azurerm_log_analytics_solution_plan_publisher
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  tags = var.tags

  default_node_pool {
    name       = var.azurerm_kubernetes_cluste_default_node_pool_name
    vm_size    = var.azurerm_kubernetes_cluster_default_node_pool_vm_size
    node_count = var.agent_count
  }
  linux_profile {
    admin_username = var.azurerm_kubernetes_cluster_linux_profile_admin_username

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  network_profile {
    network_plugin    = var.azurerm_kubernetes_cluster_network_profile_network_plugin
    load_balancer_sku = var.azurerm_kubernetes_cluster_network_profile_load_balancer_sku
  }
  service_principal {
    client_id     = var.aks_service_principal_app_id
    client_secret = var.aks_service_principal_client_secret
  }
}