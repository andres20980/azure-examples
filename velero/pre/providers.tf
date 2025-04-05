provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "azurerm" {

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  features {}
}