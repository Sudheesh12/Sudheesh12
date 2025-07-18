locals {
  test = {
    environment = "test"
    cost = "terraform test"
  }

  Prod = {
    environment = "prod"
    cost = "azure-prod"
  }
}



