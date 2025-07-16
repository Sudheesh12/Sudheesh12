terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }
  required_version = ">= 1.9.0"
}

provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "sudhi-rg" {
  name     = "sudheesh-SA-test01"
  location = "central india"
  tags = {
    environment = "test"
    Project     = "terraform-test"
  }
}

resource "azurerm_storage_account" "st-01" {
  name                     = "sudheesh28348y"
  resource_group_name      = azurerm_resource_group.sudhi-rg.name
  location                 = azurerm_resource_group.sudhi-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "test"
    Project     = "terraform-test"
  }

}


