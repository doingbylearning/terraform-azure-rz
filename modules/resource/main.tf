provider "azurerm" {
    version                     = "1.38.0"

    subscription_id             = var.subscriptionid
}


resource "azurerm_resource_group" "resourcegroup_terraform" {
    name                        = var.resourcegroup_name
    location                    = var.location
}

