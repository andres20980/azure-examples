#------------------------------------------------------------------------------------------------------#
#  AKS NSG                                                                                             #
#------------------------------------------------------------------------------------------------------#
resource "azurerm_network_security_group" "aks_nsg" {
  name                = "aks-security-group"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_http_traffic_aks_subnet" {
  name                        = "allow_http_traffic_aks_subnet"
  description                 = "Allow traffic from HTTP."
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = data.azurerm_subnet.pro-waf.address_prefix
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
}

resource "azurerm_network_security_rule" "allow_https_traffic_aks_subnet" {
  name                        = "allow_https_traffic_aks_subnet"
  description                 = "Allow traffic from HTTPS."
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = data.azurerm_subnet.pro-waf.address_prefix
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
}

resource "azurerm_network_security_rule" "allow_all_outbound_aks_subnet" {
  name                        = "allow_all_outbound_aks_subnet"
  description                 = "Allow all outbound traffic."
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
}

#------------------------------------------------------------------------------------------------------#
#  SQL NSG                                                                                             #
#------------------------------------------------------------------------------------------------------#
resource "azurerm_network_security_group" "sql_nsg" {
  name                = "sql-security-group"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_sql_traffic_sql_subnet" {
  name                        = "allow_sql_traffic_sql_subnet"
  description                 = "Allow traffic from HTTPS."
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1443"
  source_address_prefix       = var.sql_subnet_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.sql_nsg.name
}

resource "azurerm_network_security_rule" "allow_all_outbound_sql_subnet" {
  name                        = "allow_all_outbound_sql_subnet"
  description                 = "Allow all outbound traffic."
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.sql_nsg.name
}
