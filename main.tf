provider "azurerm" {
  features {}

  subscription_id = "4f61e6d8-8e0a-4fb2-aa80-8e32ec76fdcc"
  tenant_id = "bfc7d022-5849-4153-be2f-6adefbf76756" 

  use_cli =true
}

resource "azurerm_resource_group" "frauenloop" {
  name     = "frauenloop"
  location = "eastus"
}

resource "azurerm_storage_account" "kay2025" {
  name                     = "kay2025"
  resource_group_name      = azurerm_resource_group.frauenloop.name
  location                 = azurerm_resource_group.frauenloop.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  large_file_share_enabled  = true

  network_rules {
    default_action             = "Allow"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = []
    ip_rules                   = []
  }

  min_tls_version = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  tags = {}
}