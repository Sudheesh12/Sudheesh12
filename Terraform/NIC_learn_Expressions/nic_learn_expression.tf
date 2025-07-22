# here we will be learning about the Dynamic block:
# how to use it in NSG ( one of the best example )
# How to use conditional expressions.
# how to use for loop and splat expression

resource "azurerm_network_security_group" "nic-01" {
  name                = var.location == "central india" ? "sudheesh-india" : "sudheesh-other-01"
  location            = azurerm_resource_group.sudhi-rg-01.location
  resource_group_name = azurerm_resource_group.sudhi-rg-01.name



  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = security_rule.value.name

    }
  }

  tags = {
    environment = "Production"
    cost = "150"
  }
}

output "demo_splat" {
  value = azurerm_network_security_group.nic-01[*]  
  
}

output "demo_splat02" {
  value = azurerm_network_security_group.nic-01.tags.cost
  
}