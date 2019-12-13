provider "azurerm" {
    version                     = "1.38.0"

    subscription_id             = var.subscriptionid
}

terraform {
    backend "azurerm" {

    }
}


#Creating the resource group to work in
resource "azurerm_resource_group" "resourcegroup_terraform" {
    name                        = var.resourcegroup_name
    location                    = var.location
}


