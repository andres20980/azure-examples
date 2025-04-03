#------------------------------------------------------------------------------------------------------#
#  Synergia Search                                                                                     #
#------------------------------------------------------------------------------------------------------#

resource "azurerm_search_service" "search_gpt" {
  name                = "${var.environment}-synergia-search"
  location            = "France Central"
  resource_group_name = azurerm_resource_group.rg-sacyrgpt.name
  sku                 = "standard"
  semantic_search_sku = "standard"
  tags                = var.tags_ia

  local_authentication_enabled = true
  authentication_failure_mode  = "http403"
}