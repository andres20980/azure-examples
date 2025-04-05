provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

provider "azurerm" {
  features {}
  alias           = "pro"
  subscription_id = "5e800cb7-cf20-431c-a6f9-ceed4a9efa18"
  tenant_id       = var.tenant_id
}
