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


resource "azurerm_network_security_group" "nsg_virtualnetwork_1" {
    name                                = "nsg_virtualnetwork_1"
    location                            = azurerm_resource_group.resourcegroup_terraform.location
    resource_group_name                 = azurerm_resource_group.resourcegroup_terraform.name

    depends_on                          = [azurerm_resource_group.resourcegroup_terraform]
}

resource "azurerm_virtual_network" "vnet_main_1" {
    name                                = "vnet_main_1"
    location                            = azurerm_resource_group.resourcegroup_terraform.location
    resource_group_name                 = azurerm_resource_group.resourcegroup_terraform.name
    address_space                       = var.addressspace_main
    dns_servers                         = var.dnsservers   

    depends_on                          = [azurerm_resource_group.resourcegroup_terraform] 
}

resource "azurerm_subnet" "public_subnets" {
    count                               = length(var.public_subnet_cidr)
    name                                = format("public-subnet-%s-%d", azurerm_virtual_network.vnet_main_1.name, count.index)
    resource_group_name                 = azurerm_resource_group.resourcegroup_terraform.name
    virtual_network_name                = azurerm_virtual_network.vnet_main_1.name
    address_prefix                      = element(var.public_subnet_cidr, count.index)
    #network_security_group_id           = azurerm_network_security_group.nsg_virtualnetwork_1.id
    #route_table_id                      = azurerm_route_table.rt_public.id

    depends_on                          = [azurerm_virtual_network.vnet_main_1]
}

resource "azurerm_route_table" "rt_public" {
    name                                = "rt_public"
    location                            = azurerm_resource_group.resourcegroup_terraform.location
    resource_group_name                 = azurerm_resource_group.resourcegroup_terraform.name

    depends_on                          = [azurerm_resource_group.resourcegroup_terraform]
}

data "azurerm_subnet" "data_public_subnet_ids" {
    count                               = length(var.public_subnet_cidr)
    name                                = format("public-subnet-%s-%d", azurerm_virtual_network.vnet_main_1.name, count.index)
    virtual_network_name                = azurerm_virtual_network.vnet_main_1.name
    resource_group_name                 = azurerm_resource_group.resourcegroup_terraform.name

    depends_on                          = [azurerm_subnet.public_subnets]
}


resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc_public" {
    count                               = length(data.azurerm_subnet.data_public_subnet_ids)
    network_security_group_id           = azurerm_network_security_group.nsg_virtualnetwork_1.id
    subnet_id                           = data.azurerm_subnet.data_public_subnet_ids.*.id[count.index]

    depends_on                          = [data.azurerm_subnet.data_public_subnet_ids]
}

resource "azurerm_subnet_route_table_association" "subnet_rt_assoc_public" {
    count                               = length(data.azurerm_subnet.data_public_subnet_ids)
    subnet_id                           = data.azurerm_subnet.data_public_subnet_ids.*.id[count.index]
    route_table_id                      = azurerm_route_table.rt_public.id

    depends_on                          = [data.azurerm_subnet.data_public_subnet_ids]
}
