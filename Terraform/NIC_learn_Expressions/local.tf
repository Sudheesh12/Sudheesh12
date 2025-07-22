locals {
  nsg_rules = {

    Rule-01 = {
      name                   = "Allow HTTP"
      priority               = 100
      destination_port_range = "80"
    }

    Rule-02 = {
      name                   = "Allow HTTPs"
      priority               = 110
      destination_port_range = "443"
    }
  }
}