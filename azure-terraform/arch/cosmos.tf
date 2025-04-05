#------------------------------------------------------------------------------------------------------#
#  SACYRGTP CsomoDb                                                                                     #
#------------------------------------------------------------------------------------------------------#

resource "azurerm_cosmosdb_account" "sacyrgpt-cosmos" {
  name                = "${var.environment}-sacyrgpt-cosmo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg-sacyrgpt.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  tags                = var.tags

  consistency_policy {
    consistency_level = "Strong"
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }

  capacity {
    total_throughput_limit = -1
  }
}