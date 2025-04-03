resource "azurerm_dns_zone" "pro" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = var.dns_zone_hostname
}

resource "azurerm_public_ip" "ip_new" {
  name                 = "${var.environment}-public-ip-new"
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  allocation_method    = "Static"
  sku                  = "Standard"
  ddos_protection_mode = "Enabled"
}

#-----------------------------------------------------------------------#
#  New networking spacing                                               #
#-----------------------------------------------------------------------#

resource "azurerm_virtual_network" "vnet_new" {
  name                = "${var.environment}-vnet-new"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "waf_subnet_new" {
  name                 = "waf-subnet-new"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_new.name
  address_prefixes     = [var.waf_subnet_cidr]
}

resource "azurerm_subnet" "aks_subnet_new" {
  name                 = "aks-subnet-new"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_new.name
  address_prefixes     = [var.aks_subnet_cidr]
}

resource "azurerm_subnet" "sql_subnet" {
  name                 = "sql-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_new.name
  address_prefixes     = [var.sql_subnet_cidr]
}

resource "azurerm_subnet_network_security_group_association" "aks_nsg_subnet_association_new" {
  subnet_id                 = azurerm_subnet.aks_subnet_new.id
  network_security_group_id = azurerm_network_security_group.aks_nsg_new.id
}

resource "azurerm_subnet_network_security_group_association" "waf_nsg_subnet_association_new" {
  subnet_id                 = azurerm_subnet.waf_subnet_new.id
  network_security_group_id = azurerm_network_security_group.waf_nsg_new.id
}

resource "azurerm_subnet_network_security_group_association" "sql_nsg_subnet_association" {
  subnet_id                 = azurerm_subnet.sql_subnet.id
  network_security_group_id = azurerm_network_security_group.sql_nsg.id
}
