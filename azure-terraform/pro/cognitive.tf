resource "azurerm_cognitive_account" "synergia-translator" {
  name                  = "${var.environment}-synergia-translator"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg-synergia.name
  kind                  = "TextTranslation"
  tags                  = var.tags_ia
  sku_name              = "S1"
  custom_subdomain_name = "${var.environment}-synergia-translator"
  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_cognitive_account" "synergia-speech" {
  name                = "${var.environment}-synergia-speech"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-synergia.name
  kind                = "SpeechServices"
  tags                = var.tags_ia
  sku_name            = "S0"
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_cognitive_account" "sacyrgpt-document-intelligence" {
  name                  = "${var.environment}-synergia-document-intelligence"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg-synergia.name
  kind                  = "FormRecognizer"
  custom_subdomain_name = "${var.environment}-synergia-document-intelligence"
  tags                  = var.tags_ia
  sku_name              = "S0"
  identity {
    type = "SystemAssigned"
  }
}