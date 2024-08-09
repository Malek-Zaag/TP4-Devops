terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.115.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
resource "azurerm_resource_group" "resource-group" {
  name     = "AKS-resource-group"
  location = "East US"
  
}
resource "azurerm_kubernetes_cluster" "cluster1" {
  name                = "cluster1-aks"
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
  dns_prefix          = "cluster1-k8s-dns"
  kubernetes_version  = "1.28.3"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_A2_v2"
    os_disk_size_gb = 30
  }

 identity {
    type = "SystemAssigned"
  }
  tags = {
    environment = "Demo"
  }
}
