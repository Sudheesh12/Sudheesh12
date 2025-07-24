terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {

  }
  subscription_id = "91be7d67-12e5-4b83-90ca-55c5fc0cd716"
}
