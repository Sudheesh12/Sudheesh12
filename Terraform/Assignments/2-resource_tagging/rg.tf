resource "azurerm_resource_group" "sudhi-rg-01" {
    name = "sudheesh-RG"
    location= "central india"

    tags = merge(local.default_tag,local.Environment_tag)
}

output "meraged_tags" {
    value = azurerm_resource_group.sudhi-rg-01.tags
}