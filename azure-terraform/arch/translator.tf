resource "azurerm_cognitive_account" "sacyrgpt-translator" {
  name                  = "${var.environment}-sacyrgpt-translator"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg-sacyrgpt.name
  kind                  = "TextTranslation"
  tags                  = var.tags
  sku_name              = "S1"
  custom_subdomain_name = "${var.environment}-sacyrgpt-translator"
  identity {
    type = "SystemAssigned"
  }

}