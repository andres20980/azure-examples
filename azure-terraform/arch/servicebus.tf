//resource "azurerm_servicebus_namespace" "example" {
//  name                = "${var.environment}-sacyr-servicebus"
//  location            = var.location
//  resource_group_name = azurerm_resource_group.rg-apps-shared.name
//  sku                 = "Standard"
//
//  tags = var.tags
//}