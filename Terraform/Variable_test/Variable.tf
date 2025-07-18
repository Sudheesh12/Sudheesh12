terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
  }
  required_version = ">=1.0.0"
}

provider "azurerm" {
  features {
  }
}


variable "environment"  {
    type = string
    default = "test"
}


locals {
  common_tags = {
    env = "dev"
    project ="terraform"
  }
}

resource "azurerm_resource_group" "sudhi-rg" {
  name     = "sudheesh-rg"
  location = "central india"
  tags = {
    environment = local.common_tags.env
    project=local.common_tags.project
    
    
  }
}

output "location" {
    value = azurerm_resource_group.sudhi-rg.location
}

