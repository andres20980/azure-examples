resource "azurerm_private_dns_zone" "sql_server" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql_server" {
  name                  = "sql-pre-private-dns-zone-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.sql_server.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "sql_server" {
  name                          = "${var.environment}-smartways-sql-plink"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg-smartways.name
  subnet_id                     = azurerm_subnet.sql_subnet.id
  custom_network_interface_name = "${var.environment}-smartways-sql-plink-nic"
  tags                          = var.tags

  private_service_connection {
    name                           = "k8s-pre-smartways-sql-plink"
    is_manual_connection           = false
    private_connection_resource_id = data.azurerm_mssql_server.sql-server.id
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_server.id]
  }

  ip_configuration {
    name               = "ip"
    private_ip_address = "10.232.32.46"
    member_name        = "sqlServer"
    subresource_name   = "sqlServer"
  }
}