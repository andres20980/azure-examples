module "openai-sweeden" {
  source                        = "Azure/openai/azurerm"
  version                       = "0.1.3"
  resource_group_name           = azurerm_resource_group.rg-sacyrgpt.name
  location                      = "Sweden Central"
  account_name                  = "${var.environment}-cog-sweeden"
  application_name              = "${var.environment}-cog-sweeden"
  public_network_access_enabled = true
  //dynamic_throttling_enabled = true
  deployment = {
    "chat_model" = {
      name          = "gpt-35-turbo"
      model_format  = "OpenAI"
      model_name    = "gpt-35-turbo"
      model_version = "1106"
      scale_type    = "Standard"
      capacity      = 300
    },
    "chat_model_2" = {
      name          = "gpt-4-chat-turbo"
      model_format  = "OpenAI"
      model_name    = "gpt-4"
      model_version = "1106-Preview"
      scale_type    = "Standard"
      capacity      = 150
    },
    "embedding_model" = {
      name          = "embedding"
      model_format  = "OpenAI"
      model_name    = "text-embedding-ada-002"
      model_version = "2"
      scale_type    = "Standard"
      capacity      = 350
    },
  }
  depends_on = [
    azurerm_resource_group.rg-sacyrgpt
  ]

  tags = var.tags_ia
}

module "openai-france" {
  source                        = "Azure/openai/azurerm"
  version                       = "0.1.3"
  resource_group_name           = azurerm_resource_group.rg-sacyrgpt.name
  location                      = "France Central"
  account_name                  = "${var.environment}-cog-france"
  application_name              = "${var.environment}-cog-france"
  public_network_access_enabled = true
  //dynamic_throttling_enabled = true
  deployment = {
    "chat_model" = {
      name          = "gpt-35-turbo"
      model_format  = "OpenAI"
      model_name    = "gpt-35-turbo"
      model_version = "1106"
      scale_type    = "Standard"
      capacity      = 120
    },
    "chat_model_2" = {
      name          = "gpt-4-chat-turbo"
      model_format  = "OpenAI"
      model_name    = "gpt-4"
      model_version = "1106-Preview"
      scale_type    = "Standard"
      capacity      = 80
    },
    "embedding_model" = {
      name          = "embedding"
      model_format  = "OpenAI"
      model_name    = "text-embedding-ada-002"
      model_version = "2"
      scale_type    = "Standard"
      capacity      = 240
    },
  }
  depends_on = [
    azurerm_resource_group.rg-sacyrgpt
  ]
  tags = var.tags_ia
}

// https://github.com/Azure-Samples/azure-openai-terraform-deployment-sample/blob/main/infra/openai.tf