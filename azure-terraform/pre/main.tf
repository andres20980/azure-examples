terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.89.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "k8s-pre-rg"
    storage_account_name = "k8sprestorageaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
