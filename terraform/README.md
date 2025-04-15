## Terraform Guide

#### Here's a complete terraform main.tf for your project that creates:

- Resource Group
- Azure Container Registry (ACR) with admin_enabled = true

**Optional:** You can extend this later to include Azure Container Apps or Private Endpoints



---

## main.tf

'''bash
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "portal-rg"
  location = "East US"
}

# Azure Container Registry (public access with login required)
resource "azurerm_container_registry" "acr" {
  name                = "portalacr2025"  # must be globally unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"          # Standard or Premium for production
  admin_enabled       = true             # allows using username/password in CI/CD
}

# Output login details (optional)
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "acr_admin_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}

'''

---

**Usage:**

1. Save this as main.tf


2. Run:

'''bash
terraform init
terraform apply
'''


3. Outputs will include the ACR login server, username, and password — great for using in your GitHub Actions CI/CD.




---

## Next Steps (Optional):

- Add Azure Container App
- Lock ACR to private network access
- Use managed identity instead of admin creds



