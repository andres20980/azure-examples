resource "azurerm_api_management" "api-management" {
  name                = "${var.environment}-apim"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "Sacyr"
  publisher_email     = "hiberus_problesa@sacyr.com"

  sku_name = "Developer_1"
  depends_on = [
    module.openai-sweeden,
    module.openai-france,
  ]

  tags = var.tags_ia
}

resource "azurerm_api_management_api" "api-openai" {
  name                = "${var.environment}-api-openai"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.api-management.name
  revision            = "1"
  display_name        = "OpenAI"
  path                = "openai"
  protocols           = ["https"]

  import {
    content_format = "openapi-link"
    content_value  = "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/main/specification/cognitiveservices/data-plane/AzureOpenAI/inference/preview/2024-02-15-preview/inference.json"
  }
}

resource "azurerm_api_management_subscription" "subscription" {
  api_management_name = azurerm_api_management.api-management.name
  resource_group_name = azurerm_resource_group.rg.name
  display_name        = "OpenAI API"
  state               = "active"
  allow_tracing       = true
  lifecycle {
    ignore_changes = all
  }
}

# todo aqui hay que crear los distintos backends en bucle

resource "azurerm_api_management_backend" "openai-backend-france" {
  name                = "${var.environment}-openai-backend-france"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.api-management.name
  protocol            = "http"
  url                 = module.openai-france.openai_endpoint
}

resource "azurerm_api_management_backend" "openai-backend-sweeden" {
  name                = "${var.environment}-openai-backend-swdeen"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.api-management.name
  protocol            = "http"
  url                 = module.openai-sweeden.openai_endpoint
}

resource "azurerm_api_management_api_policy" "openai-policy" {
  api_name            = azurerm_api_management_api.api-openai.name
  api_management_name = azurerm_api_management.api-management.name
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [module.openai-sweeden]
  xml_content = templatefile("${path.root}/policies.tpl", {
    backend1 = azurerm_api_management_backend.openai-backend-france.name,
    backend2 = azurerm_api_management_backend.openai-backend-sweeden.name,
    key1     = module.openai-france.openai_primary_key,
  key2 = module.openai-sweeden.openai_primary_key })
}