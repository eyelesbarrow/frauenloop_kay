Cloud Engineering #2 

#Provisioning with terraform


Syntax  https://developer.hashicorp.com/terraform/language/syntax

- argument assigns value to a particular name 
- blocks - container for other content

An example of a block is the resource block. This contains the infrastructure objects. Example: 

resource "azurerm_resource_group" "frauenloop" {
  name     = "frauenloop"
  location = "eastus"
}


resource "azurerm_virtual_network" "vm_kay_vnet" {
  name                = "vm-kay-vnet"
  location            = azurerm_resource_group.frauenloop.location
  resource_group_name = azurerm_resource_group.frauenloop.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.frauenloop.name
  virtual_network_name = azurerm_virtual_network.vm_kay_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}


