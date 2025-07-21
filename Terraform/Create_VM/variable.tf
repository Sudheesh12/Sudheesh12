variable "prefix" {
  default = "sudheesh"
}

variable "suffix" {
  default = "test"
}

variable "allowed_location" {
  type        = list(string)
  description = "allowed location for the project"
  default     = ["central india", "South India", "West India"]
}

variable "prod_tags" {
  type        = map(string)
  description = "all the tags for prod"
  default = {
    "environment" = "prod"
    "cost"        = "prod_terraform"
    "managed_by"  = "Terraform"
  }
}

# learning tuple:
variable "address_space" {
    description = "network configuration(vnet address, subnet address, subnet mask)"
    type = tuple([ string, string, number])
    default = [ "192.0.0.0/16", "192.0.1.0", 24 ]
}




