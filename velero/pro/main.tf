terraform {
  required_providers {

    helm = {
      source  = "hashicorp/helm"
      version = "2.13.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.31.0"
    }
  }
}