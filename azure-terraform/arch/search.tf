#------------------------------------------------------------------------------------------------------#
#  SACYRGTP Search                                                                                     #
#------------------------------------------------------------------------------------------------------#

resource "azurerm_search_service" "example" {
  name                = "${var.environment}-sacyrgpt-search"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg-sacyrgpt.name
  sku                 = "standard"
  semantic_search_sku = "standard"
  tags                = var.tags

  local_authentication_enabled = true
  authentication_failure_mode  = "http403"
}