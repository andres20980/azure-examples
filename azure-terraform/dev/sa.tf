locals {
  storage_account_name = "${replace(var.environment, "-", "")}storageaccount"
}

#------------------------------------------------------------------------------------------------------#
#  Aks Comun Storage                                                                                   #
#------------------------------------------------------------------------------------------------------#

resource "azurerm_storage_account" "storage_account" {
  name                = local.storage_account_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "velero" {
  name                  = "velero"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_share" "fileshare" {
  name                 = "shared-configs"
  storage_account_name = azurerm_storage_account.storage_account.name
  quota                = 1
}

#------------------------------------------------------------------------------------------------------#
#  Nubia Storage                                                                                       #
#------------------------------------------------------------------------------------------------------#

resource "azurerm_storage_account" "nubia" {
  name                            = "nubia${var.resource_environment}"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg-nubia.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  tags                            = var.tags

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 30
    }
    restore_policy {
      days = 29
    }
    last_access_time_enabled = true
    change_feed_enabled      = true
  }
}

resource "azurerm_storage_container" "nubia_data" {
  depends_on            = [azurerm_storage_account.nubia]
  name                  = "nubia-data-dev"
  storage_account_name  = azurerm_storage_account.nubia.name
  container_access_type = "private"
}

#------------------------------------------------------------------------------------------------------#
#  Smartways Storage                                                                                   #
#------------------------------------------------------------------------------------------------------#

resource "azurerm_storage_account" "smartways" {
  name                            = "smartways${var.resource_environment}"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg-smartways.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  tags                            = var.tags

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 30
    }
    restore_policy {
      days = 29
    }
    last_access_time_enabled = true
    change_feed_enabled      = true
  }
}

resource "azurerm_storage_container" "smartways_data" {
  depends_on            = [azurerm_storage_account.smartways]
  name                  = "smartways-data-dev"
  storage_account_name  = azurerm_storage_account.smartways.name
  container_access_type = "private"
}

#------------------------------------------------------------------------------------------------------#
#  SACYRGTP Storage                                                                                    #
#------------------------------------------------------------------------------------------------------#

resource "azurerm_storage_account" "sacyrgtp" {
  name                            = "sacyrgtp${var.resource_environment}"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg-sacyrgpt.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  tags                            = var.tags_ia
  blob_properties {
    versioning_enabled       = false
    last_access_time_enabled = true

    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["DELETE", "GET", "HEAD", "MERGE", "OPTIONS", "PATCH", "POST", "PUT"]
      allowed_origins    = ["https://documentintelligence.ai.azure.com"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 120
    }
  }
}
resource "azurerm_storage_container" "sacyrgtp_translated_documents" {
  depends_on            = [azurerm_storage_account.sacyrgtp]
  name                  = "translated-documents"
  storage_account_name  = azurerm_storage_account.sacyrgtp.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "sacyrgtp_smemory" {
  depends_on            = [azurerm_storage_account.sacyrgtp]
  name                  = "smemory"
  storage_account_name  = azurerm_storage_account.sacyrgtp.name
  container_access_type = "private"
}

#------------------------------------------------------------------------------------------------------#
#  Geos Storage                                                                                       #
#------------------------------------------------------------------------------------------------------#

resource "azurerm_storage_account" "geos" {
  name                            = "geos${var.resource_environment}"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg-geos.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  tags                            = var.tags

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 30
    }
    restore_policy {
      days = 29
    }
    last_access_time_enabled = true
    change_feed_enabled      = true
  }
}

resource "azurerm_storage_container" "geos_data" {
  depends_on            = [azurerm_storage_account.geos]
  name                  = "geos-data-dev"
  storage_account_name  = azurerm_storage_account.geos.name
  container_access_type = "private"
}

#------------------------------------------------------------------------------------------------------#
#  Cyma Storage                                                                                       #
#------------------------------------------------------------------------------------------------------#

resource "azurerm_storage_account" "cyma" {
  name                            = "cyma${var.resource_environment}"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg-cyma.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  tags                            = var.tags

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 30
    }
    restore_policy {
      days = 29
    }
    last_access_time_enabled = true
    change_feed_enabled      = true
  }
}

resource "azurerm_storage_container" "cyma_data" {
  depends_on            = [azurerm_storage_account.cyma]
  name                  = "cyma-data-dev"
  storage_account_name  = azurerm_storage_account.cyma.name
  container_access_type = "private"
}