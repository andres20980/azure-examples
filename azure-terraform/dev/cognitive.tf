resource "azurerm_cognitive_account" "sacyrgpt-translator" {
  name                  = "${var.environment}-sacyrgpt-translator"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg-sacyrgpt.name
  kind                  = "TextTranslation"
  tags                  = var.tags_ia
  sku_name              = "S1"
  custom_subdomain_name = "${var.environment}-sacyrgpt-translator"
  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_cognitive_account" "sacyrgpt-speech" {
  name                = "${var.environment}-sacyrgpt-speech"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg-sacyrgpt.name
  kind                = "SpeechServices"
  tags                = var.tags_ia
  sku_name            = "S0"
  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_cognitive_account" "sacyrgpt-document-intelligence" {
  name                  = "${var.environment}-sacyrgpt-document-intelligence"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg-sacyrgpt.name
  kind                  = "FormRecognizer"
  custom_subdomain_name = "${var.environment}-sacyrgpt-document-intelligence"
  tags                  = var.tags_ia
  sku_name              = "S0"
  identity {
    type = "SystemAssigned"
  }

}