resource "azurerm_network_security_group" "nsg_virtualnetwork_1" {
    name                                = "nsg_virtualnetwork_1"
    location                            = var.location
    resource_group_name                 = var.resourcegroup_name
}

resource "azurerm_virtual_network" "vnet_main_1" {
    name                                = "vnet_main_1"
    location                            = var.location
    resource_group_name                 = var.resourcegroup_name
    address_space                       = var.addressspace_main
    dns_servers                         = var.dnsservers

    subnet {
        count                               = length(var.public_subnet_cidr)
        name                                = format("public_subnet_%d", count.index)
        address_prefix                      = element(var.public_subnet_cidr, count.index)
        security_group                      = azurerm_network_security_group.nsg_virtualnetwork_1.id
    }
    
}

