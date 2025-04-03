#------------------------------------------------------------------------------------------------------#
#  AKS NSG                                                                                             #
#------------------------------------------------------------------------------------------------------#
resource "azurerm_network_security_group" "aks_nsg_new" {
  name                = "aks-security-group-new"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "allow_http_traffic_aks_subnet_new" {
  name                        = "allow_http_traffic_aks_subnet"
  description                 = "Allow traffic from HTTP."
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = var.waf_subnet_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.aks_nsg_new.name
}

resource "azurerm_network_security_rule" "allow_https_traffic_aks_subnet_new" {
  name                        = "allow_https_traffic_aks_subnet"
  description                 = "Allow traffic from HTTPS."
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.waf_subnet_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.aks_nsg_new.name
}

resource "azurerm_network_security_rule" "allow_all_outbound_aks_subnet_new" {
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
  network_security_group_name = azurerm_network_security_group.aks_nsg_new.name
}

#------------------------------------------------------------------------------------------------------#
#  WAF NSG                                                                                             #
#------------------------------------------------------------------------------------------------------#
resource "azurerm_network_security_group" "waf_nsg_new" {
  name                = "waf-security-group-new"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "allow_http_traffic_waf_subnet_new" {
  name                        = "allow_http_traffic_waf_subnet"
  description                 = "Allow traffic from HTTP."
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = var.waf_subnet_cidr
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.waf_nsg_new.name
}

resource "azurerm_network_security_rule" "allow_https_traffic_waf_subnet_new" {
  name                        = "allow_https_traffic_waf_subnet"
  description                 = "Allow traffic from HTTPS."
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = var.waf_subnet_cidr
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.waf_nsg_new.name
}

resource "azurerm_network_security_rule" "allow_public_ip_http_traffic_waf_subnet_new" {
  name                        = "allow_public_ip_http_traffic_waf_subnet"
  description                 = "Allow HTTP traffic from public IP."
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = azurerm_public_ip.ip_new.ip_address
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.waf_nsg_new.name
}

resource "azurerm_network_security_rule" "allow_public_ip_https_traffic_waf_subnet_new" {
  name                        = "allow_public_ip_https_traffic_waf_subnet"
  description                 = "Allow HTTPS traffic from public IP."
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = azurerm_public_ip.ip_new.ip_address
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.waf_nsg_new.name
}

resource "azurerm_network_security_rule" "allow_gateway_manager_waf_subnet_new" {
  name                        = "allow_gateway_manager_waf_subnet"
  description                 = "Allow traffic from GatewayManager. This port range is required for Azure infrastructure communication."
  priority                    = 104
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.waf_nsg_new.name
}

resource "azurerm_network_security_rule" "allow_azure_load_balancer_waf_subnet_new" {
  name                        = "allow_azure_load_balancer_waf_subnet"
  description                 = "Allow incoming traffic from the source as the AzureLoadBalancer service tag."
  priority                    = 105
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.waf_nsg_new.name
}

resource "azurerm_network_security_rule" "deny_all_inbound_waf_subnet_new" {
  name                        = "deny_all_inbound_waf_subnet"
  description                 = "Deny all other inbound traffic."
  priority                    = 106
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.waf_nsg_new.name
}

resource "azurerm_network_security_rule" "allow_all_outbound_waf_subnet_new" {
  name                        = "allow_all_outbound_waf_subnet"
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
  network_security_group_name = azurerm_network_security_group.waf_nsg_new.name
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