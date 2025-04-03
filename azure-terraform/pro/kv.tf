#------------------------------------------------------------------------------------------------------#
#  SACYRGTP Key vault                                                                                  #
#------------------------------------------------------------------------------------------------------#

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "default" {
  name                        = "${var.environment}-synergia-kv"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg-synergia.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  tags                        = var.tags_ia
  sku_name                    = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List"
    ]

    secret_permissions = [
      "Get"
    ]

    storage_permissions = [
      "Get",
    ]

    certificate_permissions = [
      "Get", "Import"
    ]
  }

  lifecycle {
    ignore_changes = [
      access_policy
    ]
  }
}

resource "azurerm_key_vault_access_policy" "sp_access_policy" {
  key_vault_id = azurerm_key_vault.default.id
  tenant_id    = var.tenant_id
  object_id    = var.service_principal_object_id

  key_permissions = [
    "Get", "List"
  ]

  secret_permissions = [
    "Get", "List"
  ]

  storage_permissions = [
    "Get",
  ]

  certificate_permissions = [
    "Get", "Import"
  ]
}