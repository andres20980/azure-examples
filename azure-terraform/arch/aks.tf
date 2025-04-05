resource "azurerm_kubernetes_cluster" "aks" {
  name                              = "${var.environment}-aks"
  location                          = var.location
  resource_group_name               = azurerm_resource_group.rg.name
  dns_prefix                        = var.environment
  azure_policy_enabled              = true
  role_based_access_control_enabled = true
  kubernetes_version                = var.k8s_version

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  tags = var.tags

  lifecycle {
    ignore_changes = [default_node_pool]
  }

  service_principal {
    client_id     = var.service_principal_client_id
    client_secret = var.service_principal_client_secret
  }

  storage_profile {
    file_driver_enabled = true
    blob_driver_enabled = true
    disk_driver_enabled = true
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  default_node_pool {
    name                 = "generic"
    min_count            = 1
    max_count            = 2
    max_pods             = 101
    vm_size              = "Standard_DS2_v2"
    enable_auto_scaling  = true
    orchestrator_version = var.k8s_version
    upgrade_settings {
      max_surge = "10%"
    }
    node_labels = {
      app = "generic"
    }
    vnet_subnet_id = azurerm_subnet.aks_subnet_new.id
  }
}

#resource "azurerm_kubernetes_cluster_node_pool" "nubia" {
#  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
#  name                  = "nubia"
#  min_count             = 1
#  max_count             = 50
#  max_pods              = 100
#  vm_size               = "Standard_D4s_v3"
#  mode                  = "User"
#  enable_auto_scaling   = true
#  orchestrator_version  = var.k8s_version
#  node_labels = {
#    app = "nubia"
#  }
#  node_taints    = ["app=nubia:NoSchedule"]
#  vnet_subnet_id = azurerm_subnet.aks_subnet.id
#}

resource "azurerm_kubernetes_cluster_node_pool" "ai" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  name                  = "ai"
  min_count             = 0
  max_count             = 0
  max_pods              = 100
  vm_size               = "Standard_DS2_v2"
  mode                  = "User"
  os_sku                = "AzureLinux"
  enable_auto_scaling   = false
  orchestrator_version  = var.k8s_version
  node_labels = {
    app = "ai"
  }
  node_taints    = ["app=ai:NoSchedule"]
  vnet_subnet_id = azurerm_subnet.aks_subnet_new.id
}
