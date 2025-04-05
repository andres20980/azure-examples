data "azurerm_mssql_server" "sql-server" {
  name                = "sql-smartways-pro-weu-001"
  resource_group_name = azurerm_resource_group.rg-smartways.name
}
