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







