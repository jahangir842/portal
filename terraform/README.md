Below is a Terraform example to create an Azure Container Registry (ACR), optionally with a private endpoint (if you want private access only).


---

Option 1: Public ACR (simpler for GitHub Actions CI/CD)

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

This creates a public ACR with admin credentials enabled. You can fetch credentials in your pipeline using Azure CLI.


---

Option 2: Private ACR with Private Endpoint (for high security)

resource "azurerm_virtual_network" "vnet" {
  name                = "portal-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "private-endpoint-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.ContainerRegistry/registries"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

resource "azurerm_private_endpoint" "acr_pe" {
  name                = "acr-private-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "acr-priv-conn"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone" "acr_dns" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "acr-dns-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_a_record" "acr_dns_record" {
  name                = azurerm_container_registry.acr.name
  zone_name           = azurerm_private_dns_zone.acr_dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.acr_pe.private_service_connection[0].private_ip_address]
}


---

Notes:

If you use admin_enabled = true, you can log in from GitHub Actions using docker/login-action with username and password.

For private access (Premium SKU), GitHub-hosted runners will not work unless they are inside your VNet.

The name must be globally unique for the registry.



---

Want to combine this with Terraform to create the Azure Container App too?

