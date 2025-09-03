variable "resource_group_name" {
  description = "The name of the resource group in which to create the Container App."
  type        = string
  default     = "portal-rg"
  
}

variable "location" {
  description = "The Azure region in which to create the Container App."
  type        = string
  default     = "West Europe"
  
}

variable "azurerm_log_analytics_workspace" {
    description = "The name of the Log Analytics Workspace in which to create the Container App."
    type        = string
    default     = "portal-log-workspace"   
  
}

variable "container_app_environment" {
    description = "The name of the Container App Environment in which to create the Container App."
    type        = string
    default     = "portal-cont-app-env"
}

variable "container_app_name" {
    description = "The name of the Container App to create."
    type        = string
    default     = "portal-container-app"
  
}

variable "container_image" {
    description = "The container image to deploy to the Container App."
    type        = string
    default     = "jahangir842/portal:109"
  
}

variable "container_port" {
    description = "The port on which the container listens."
    type        = number
    default     = 5000
  
}