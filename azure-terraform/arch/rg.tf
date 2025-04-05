resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg-smartways" {
  name     = "${var.environment}-smartways-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg-nubia" {
  name     = "${var.environment}-nubia-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "rg-sacyrgpt" {
  name     = "${var.environment}-sacyrgpt-rg"
  location = var.location
  tags     = var.tags
}

//resource "azurerm_resource_group" "rg-apps-shared" {
//  name     = "${var.environment}-apps-shared-rg"
//  location = var.location
//  tags     = var.tags
//}