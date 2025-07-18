terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
  }
  required_version = ">= 1.0.0"
  backend "azurerm" {
    resource_group_name  = "sudheesh-st-test"
    storage_account_name = "sudheesh1229"
    container_name       = "terraform-state-files"
    key                  = "test-demo-terraform.tfstate"
  }


}


provider azurerm {
    features {}
}

resource "azurerm_resource_group" "rg-sudhi" {
  name     = "sudheesh-SA-test01"
  location = "central india"
}





