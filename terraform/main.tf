terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.42.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "jagztfstatestorageacct"
    container_name       = "tfstate"
    key                  = "example.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "portal-log" {
  name                = var.azurerm_log_analytics_workspace
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "portal-env" {
  name                       = var.container_app_environment
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.portal-log.id
}

resource "azurerm_container_app" "portal-app" {
  name                         = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.portal-env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Multiple"

  template {
    container {
      name   = "${var.container_app_name}-container"
      image  = var.container_image
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled           = true
    target_port                = var.container_port
    transport                  = "auto"
    allow_insecure_connections = false
    client_certificate_mode    = "ignore"

    traffic_weight {
      revision_suffix = "blue"
      latest_revision = true
      percentage      = 100
    }
    traffic_weight {
      revision_suffix = "green"
      latest_revision = false
      percentage    = 0
    }
  }
}
