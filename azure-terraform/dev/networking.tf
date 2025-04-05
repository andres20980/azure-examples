resource "azurerm_virtual_network" "vnet" {
  name                = "${var.environment}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = ["10.247.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.environment}-aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.247.0.0/20"]
}

resource "azurerm_subnet" "sql_subnet" {
  name                 = "${var.environment}-sql-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.247.16.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_virtual_network" "vnet_new" {
  name                = "${var.environment}-vnet-new"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = [var.vnet_cidr]
  tags                = var.tags
}

resource "azurerm_subnet" "aks_subnet_new" {
  name                 = "${var.environment}-aks-subnet-new"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_new.name
  address_prefixes     = [var.aks_subnet_cidr]
}

resource "azurerm_subnet" "sql_subnet_new" {
  name                 = "${var.environment}-sql-subnet-new"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_new.name
  address_prefixes     = [var.sql_subnet_cidr]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_subnet" "sql_subnet_mi_new" {
  name                 = "${var.environment}-sql-mi-subnet-new"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_new.name
  address_prefixes     = [var.sql_subnet_mi_cidr]
  lifecycle {
    ignore_changes = [delegation]
  }
}

resource "azurerm_subnet_network_security_group_association" "aks_nsg_subnet_association" {
  subnet_id                 = azurerm_subnet.aks_subnet_new.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "sql_nsg_subnet_association" {
  subnet_id                 = azurerm_subnet.sql_subnet_new.id
  network_security_group_id = azurerm_network_security_group.sql_nsg.id
}

#------------------------------------------------------------------------------------------------------#
#  PEERING TO LEVERAGE FROM PRO WAF                                                                    #
#------------------------------------------------------------------------------------------------------#

resource "azurerm_virtual_network_peering" "dev-to-arch" {
  name                      = "dev-to-pro"
  remote_virtual_network_id = data.azurerm_virtual_network.pro.id
  virtual_network_name      = azurerm_virtual_network.vnet_new.name
  resource_group_name       = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network_peering" "arch-to-dev" {
  provider                  = azurerm.pro
  name                      = "pro-to-dev"
  remote_virtual_network_id = azurerm_virtual_network.vnet_new.id
  virtual_network_name      = data.azurerm_virtual_network.pro.name
  resource_group_name       = "k8s-pro-rg"
}
