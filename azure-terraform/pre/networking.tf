resource "azurerm_public_ip" "ip" {
  name                 = "${var.environment}-public-ip"
  location             = var.location
  resource_group_name  = "k8s-pre-rg"
  allocation_method    = "Static"
  sku                  = "Standard"
  ddos_protection_mode = "Enabled"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.environment}-vnet"
  resource_group_name = "k8s-pre-rg"
  location            = var.location
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = "k8s-pre-rg"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.aks_subnet_cidr]
}

resource "azurerm_subnet" "sql_subnet" {
  name                 = "${var.environment}-sql-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.sql_subnet_cidr]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_subnet_network_security_group_association" "aks_nsg_subnet_association" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "sql_nsg_subnet_association" {
  subnet_id                 = azurerm_subnet.sql_subnet.id
  network_security_group_id = azurerm_network_security_group.sql_nsg.id
}

#------------------------------------------------------------------------------------------------------#
#  PEERING TO LEVERAGE FROM PRO WAF                                                                    #
#------------------------------------------------------------------------------------------------------#

resource "azurerm_virtual_network_peering" "pre-to-pro" {
  name                      = "pre-to-pro"
  remote_virtual_network_id = data.azurerm_virtual_network.pro.id
  virtual_network_name      = azurerm_virtual_network.vnet.name
  resource_group_name       = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network_peering" "pro-to-pre" {
  provider                  = azurerm.pro
  name                      = "pro-to-pre"
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  virtual_network_name      = data.azurerm_virtual_network.pro.name
  resource_group_name       = "k8s-pro-rg"
}
