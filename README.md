Cloud Engineering #2 

#### Provisioning with terraform


Syntax  https://developer.hashicorp.com/terraform/language/syntax

- argument assigns value to a particular name 
- blocks - container for other content

An example of a block is the resource block. This contains the infrastructure objects. Example: 

resource "azurerm_resource_group" "frauenloop" {
  name     = "frauenloop"
  location = "eastus"
}


