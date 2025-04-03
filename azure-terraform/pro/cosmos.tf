#------------------------------------------------------------------------------------------------------#
#  Synergia CosmosDB                                                                                   #
#------------------------------------------------------------------------------------------------------#

resource "azurerm_cosmosdb_account" "synergia-cosmos" {
  name                = "${var.environment}-synergia-cosmos"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-synergia.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  tags                = var.tags_ia

  consistency_policy {
    consistency_level = "Strong"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  capacity {
    total_throughput_limit = -1
  }

  # https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-configure-firewall#allow-requests-from-the-azure-portal
  ip_range_filter = "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,13.88.56.148,40.91.218.243,13.91.105.215,4.210.172.107"

  lifecycle {
    ignore_changes = [ip_range_filter]
  }
}

resource "azurerm_private_dns_zone" "cosmos_db" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags_ia
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_db" {
  name                  = "cosmosdb-pro-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos_db.name
  virtual_network_id    = azurerm_virtual_network.vnet_new.id
}

resource "azurerm_private_endpoint" "cosmos_db" {
  name                          = "${var.environment}-synergia-cosmosdb-plink"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg-synergia.name
  subnet_id                     = azurerm_subnet.aks_subnet_new.id
  custom_network_interface_name = "${var.environment}-synergia-cosmosdb-plink-nic"
  tags                          = var.tags_ia

  private_service_connection {
    name                           = "${var.environment}-synergia-cosmosdb-plink"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cosmosdb_account.synergia-cosmos.id
    subresource_names              = ["Sql"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmos_db.id]
  }
}