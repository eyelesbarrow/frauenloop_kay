# Provider configuration
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  subscription_id = "4f61e6d8-8e0a-4fb2-aa80-8e32ec76fdcc"
  tenant_id       = "bfc7d022-5849-4153-be2f-6adefbf76756"
  use_cli         = true
}

# Resource Group
resource "azurerm_resource_group" "frauenloop" {
  name     = "frauenloop"
  location = "eastus"
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm_kay" {
  name                            = "vm-kay"
  location                        = azurerm_resource_group.frauenloop.location
  resource_group_name             = azurerm_resource_group.frauenloop.name
  size                            = "Standard_B1s"
  zone                            = "3"
  admin_username                  = "vm-kay"
  network_interface_ids           = [azurerm_network_interface.vm_kay_nic.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = "vm-kay"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHUr6pdpykMIVH682cd0gdQnIBS+uwL3+GUC53YzjaVor9G8VpTSC7YwkEamGRPxLWx3eVqpQUvYBo3kgTueJ+gHfaIQ9EXnKZmu2561OtAQXBLuQTfQjKwQbM2ahRrOVvR+dmoKLSpllFqgEkJW2C7XZjI8KeJcbtloSQaJhvad2k6f/OB9uvrorPppg86a7q+AqqHrZFAzkjl414+EQVaXfupcl3eIUr0+/D+bZEDW8vOY3J3eb5cRoHBQfaNh/XCwE4k/TszH+hc0rS5volGzW0KJgeUFDY3LO4cblYBY2KNn4QAB6RmEvxx8zBFQaxuBRQUIqsuNGbdIWauRFdo4u01q4XzkRqRznemuUXkw3f/Qh872qdRQhf1jK+XwCtWMpez/ZCXm/1sPv+VgyTRItyuWCQj+ypHRKjTwWmuDzfQlMsqNP/ixhgTYmKMGU1oB6DYka0bl4w+NDAe6r5/+ZymZE+lphJ8QbyRyRauurVf77dTIDjND1NSH5pp8E= generated-by-azure"
  }

  os_disk {
    name                 = "vm-kay_OsDisk_1_9b8074c1350f4b5bb214feead0aa1226"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }

  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  provision_vm_agent         = true
  allow_extension_operations = true
}

# Network Interface
resource "azurerm_network_interface" "vm_kay_nic" {
  name                = "vm-kay963_z3"
  location            = azurerm_resource_group.frauenloop.location
  resource_group_name = azurerm_resource_group.frauenloop.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.vm_kay_subnet.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }


}

# Subnet
resource "azurerm_subnet" "vm_kay_subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.frauenloop.name
  virtual_network_name = azurerm_virtual_network.vm_kay_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Virtual Network (required for subnet)
resource "azurerm_virtual_network" "vm_kay_vnet" {
  name                = "vm-kay-vnet"
  location            = azurerm_resource_group.frauenloop.location
  resource_group_name = azurerm_resource_group.frauenloop.name
  address_space       = ["10.0.0.0/16"]
}


# Network Security Group
resource "azurerm_network_security_group" "vm_kay_nsg" {
  name                = "vm-kay-nsg"
  location            = azurerm_resource_group.frauenloop.location
  resource_group_name = azurerm_resource_group.frauenloop.name

  security_rule {
    name                       = "default-allow-ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAnyCustom8080Inbound"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Storage Account
resource "azurerm_storage_account" "kay2025" {
  name                     = "kay2025"
  location                 = azurerm_resource_group.frauenloop.location
  resource_group_name      = azurerm_resource_group.frauenloop.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  large_file_share_enabled = true

  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices"]
  }

  min_tls_version = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
}

# Key Vault
resource "azurerm_key_vault" "kay_key_vault" {
  name                        = "kay-key-vault"
  location                    = azurerm_resource_group.frauenloop.location
  resource_group_name         = azurerm_resource_group.frauenloop.name
  tenant_id                   = "bfc7d022-5849-4153-be2f-6adefbf76756"
  sku_name                    = "standard"

  enable_rbac_authorization   = true
  soft_delete_retention_days  = 90
  purge_protection_enabled    = false

  network_acls {
    bypass              = "None"
    default_action      = "Allow"
  }
}

# Static Web App
resource "azurerm_static_web_app" "kay_app" {
  name                         = "kay-app"
  resource_group_name          = azurerm_resource_group.frauenloop.name
  location                     = "East US 2"
  sku_tier                     = "Free"
  sku_size                     = "Free"

  app_settings = {
    "allowConfigFileUpdates" = "true"
  }

  
}
