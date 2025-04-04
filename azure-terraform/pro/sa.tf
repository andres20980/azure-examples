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

#------------------------------------------------------------------------------------------------------#
#  SynergIA Storage                                                                                    #
#------------------------------------------------------------------------------------------------------#

resource "azurerm_storage_account" "synergia" {
  name                            = "synergia${var.resource_environment}"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg-synergia.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  tags                            = var.tags_ia
  blob_properties {
    versioning_enabled       = false
    last_access_time_enabled = true
  }
}
resource "azurerm_storage_container" "synergia_translated_documents" {
  depends_on            = [azurerm_storage_account.synergia]
  name                  = "translated-documents"
  storage_account_name  = azurerm_storage_account.synergia.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "synergia_smemory" {
  depends_on            = [azurerm_storage_account.synergia]
  name                  = "smemory"
  storage_account_name  = azurerm_storage_account.synergia.name
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
  name                  = "geos-data-pro"
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
  name                  = "cyma-data-pro"
  storage_account_name  = azurerm_storage_account.cyma.name
  container_access_type = "private"
}