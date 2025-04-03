locals {
  mc_rg = "MC_${data.azurerm_resource_group.rg.name}_${data.azurerm_kubernetes_cluster.aks.name}_${lower(trim(data.azurerm_kubernetes_cluster.aks.location, " "))}"
}

data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

data "azurerm_storage_account" "storage-account" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group
}

data "azurerm_storage_container" "velero-container" {
  name                 = var.storage_account_container_name
  storage_account_name = data.azurerm_storage_account.storage-account.name
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

data "azurerm_resource_group" "mc_rg_aks" {
  name = local.mc_rg
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_client_config" "current" {
}

