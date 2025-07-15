terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}


# Adding a resource Group:
resource "azurerm_resource_group" "sud-rg" {
  name     = "sudheesh-tf-test01"
  location = "central india"
  tags = {
    env     = "test"
    Project = "Terraform-test"
  }
}


#adding virtual network:
resource "azurerm_virtual_network" "sud-vn" {
  name                = "sudheesh-tf-VN01"
  resource_group_name = azurerm_resource_group.sud-rg.name
  location            = azurerm_resource_group.sud-rg.location
}




