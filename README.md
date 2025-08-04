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

resource "azurerm_network_security_group" "vm_kay_nsg" {
  name                = "vm-kay-nsg"
  location            = azurerm_resource_group.frauenloop.location
  resource_group_name = azurerm_resource_group.frauenloop.name

  security_rule {
    name                       = "Allow-8080-Inbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

