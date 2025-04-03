resource "azurerm_user_assigned_identity" "dns_zone_contributor" {
  name                = "${var.environment}-dns-zone-contributor"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "dns_zone_contributor_role_assignment" {
  scope                = azurerm_dns_zone.pro.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.dns_zone_contributor.principal_id
}

#------------------------------------------------------------------------------------------------------#
#  APPGW IDENTITY                                                                                      #
#------------------------------------------------------------------------------------------------------#
resource "azurerm_user_assigned_identity" "appgw_reader" {
  name                = "${var.environment}-appgw-reader"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
}

resource "azurerm_role_assignment" "appgw_identity_contributor_role_assignment" {
  scope                = azurerm_application_gateway.waf_new.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.appgw_reader.principal_id
}

# resource "azurerm_role_assignment" "appgw_identity_reader_role_assignment" {
#   scope                = data.azurerm_resource_group.pro.id
#   role_definition_name = "Reader"
#   principal_id         = azurerm_user_assigned_identity.appgw_reader.principal_id
# }

# resource "azurerm_role_assignment" "appgw_identity_network_contributor_role_assignment" {
#   scope                = data.azurerm_virtual_network.pro.id
#   role_definition_name = "Network Contributor"
#   principal_id         = azurerm_user_assigned_identity.appgw_reader.principal_id
# }

resource "azurerm_federated_identity_credential" "appgw_reader" {
  name                = "appgw"
  resource_group_name = azurerm_resource_group.rg.name
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  subject             = "system:serviceaccount:appgw:appgw-sa-ingress-azure"
  parent_id           = azurerm_user_assigned_identity.appgw_reader.id
  audience            = ["api://AzureADTokenExchange"]
}

resource "azurerm_federated_identity_credential" "cert_manager" {
  name                = "cert-manager"
  resource_group_name = azurerm_resource_group.rg.name
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  subject             = "system:serviceaccount:cert-manager:cert-manager"
  parent_id           = azurerm_user_assigned_identity.dns_zone_contributor.id
  audience            = ["api://AzureADTokenExchange"]
}
