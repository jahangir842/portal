provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "portal-rg"
  location = "East US"
}

resource "azurerm_container_registry" "acr" {
  name                = "portalacr2025" # must be globally unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic" # options: Basic, Standard, Premium
  admin_enabled       = true    # enables admin username/password login
}