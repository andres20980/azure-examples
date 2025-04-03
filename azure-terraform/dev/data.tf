data "azurerm_dns_zone" "dev" {
  name                = var.dns_zone_hostname
  resource_group_name = azurerm_resource_group.rg.name
}

data "azurerm_application_gateway" "pro" {
  provider            = azurerm.pro
  name                = "k8s-pro-application-gateway-new"
  resource_group_name = "k8s-pro-rg"
}

data "azurerm_virtual_network" "pro" {
  provider            = azurerm.pro
  name                = "k8s-pro-vnet-new"
  resource_group_name = "k8s-pro-rg"
}

data "azurerm_subnet" "pro-waf" {
  provider             = azurerm.pro
  name                 = "waf-subnet-new"
  resource_group_name  = "k8s-pro-rg"
  virtual_network_name = "k8s-pro-vnet-new"
}

data "azurerm_network_security_group" "pro-waf" {
  provider            = azurerm.pro
  name                = "waf-security-group-new"
  resource_group_name = "k8s-pro-rg"
}

data "azurerm_resource_group" "pro" {
  provider = azurerm.pro
  name     = "k8s-pro-rg"
}

data "azurerm_mssql_server" "sql-server" {
  name                = "sql-smartways-dev-weu-001"
  resource_group_name = azurerm_resource_group.rg-smartways.name
}
