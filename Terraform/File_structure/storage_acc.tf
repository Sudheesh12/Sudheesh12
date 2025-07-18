resource "azurerm_storage_account" "st_acc_01" {
    name = var.st_name
    resource_group_name = azurerm_resource_group.sudhi-rg-01.name
    location = azurerm_resource_group.sudhi-rg-01.location
    account_tier             = var.acc-tier
    account_replication_type = var.acc_rep_type

    tags = {
        environment = local.test.environment
        cost = local.test.cost
    }
}