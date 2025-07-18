variable "location" {
    type = string
    description = "specifies the location"
    default = "central india"
}

variable "environment" {
    type = string
    description = "which environment"
    default = "test"
}

variable "cost" {
    type = string
    description = "to track cost"
    default = "terraform"
}


variable "rg_name" {
    type = string
    description = "name of the resource group"
}


variable "st_name" {
    type = string
    description = "name of the storage account"
}

variable "acc-tier" {
    type = string
    description = "account tier for storage account"

}

variable "acc_rep_type" {
    type = string
    description = "account replication type for the storage account"
}


