# |-------------------------------------------------------|
# |         VELERO DISASTER RECOVERY APPLICATION          |
# |-------------------------------------------------------|

resource "azurerm_role_definition" "velero_custom_role" {
  name        = "${var.environment}-velero-role"
  scope       = data.azurerm_subscription.primary.id
  description = "Role that allows Velero to perform the required operations to backup and restore AKS resources"

  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/read",
      "Microsoft.Storage/storageAccounts/listkeys/action",
      "Microsoft.Storage/storageAccounts/regeneratekey/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/delete",
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/write",
      "Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action",
      "Microsoft.Compute/disks/read",
      "Microsoft.Compute/disks/write",
      "Microsoft.Compute/disks/endGetAccess/action",
      "Microsoft.Compute/disks/beginGetAccess/action",
      "Microsoft.Compute/snapshots/read",
      "Microsoft.Compute/snapshots/write",
      "Microsoft.Compute/snapshots/delete",
      "Microsoft.Compute/disks/beginGetAccess/action",
      "Microsoft.Compute/disks/endGetAccess/action"
    ]

    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action"
    ]
    not_actions      = []
    not_data_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id
  ]
}

# resource "azurerm_role_assignment" "velero_role_assignment" {
#   role_definition_name = azurerm_role_definition.velero_custom_role.name
#   principal_id         = var.service_principal_object_id
#   scope                = data.azurerm_subscription.primary.id
#   depends_on           = [azurerm_role_definition.velero_custom_role]
# }

resource "helm_release" "velero" {
  name = "velero"

  chart      = "velero"
  repository = "https://vmware-tanzu.github.io/helm-charts"
  version    = "7.0.0"

  namespace        = "velero"
  create_namespace = true

  values = [file("${path.module}/values-velero.yaml")]

  atomic = true

  # Set this to storage account name
  set {
    name  = "configuration.backupStorageLocation[0].config.storageAccount"
    value = data.azurerm_storage_account.storage-account.name
  }

  # Set this to AKS Storage Account's blob container name 
  set {
    name  = "configuration.backupStorageLocation[0].bucket"
    value = data.azurerm_storage_container.velero-container.name
  }

  # Set this to Resource Group where the Storage Account is placed
  set {
    name  = "configuration.backupStorageLocation[0].config.resourceGroup"
    value = data.azurerm_resource_group.rg.name
  }

  # Set this to Resource Group where the Storage Account is placed
  set {
    name  = "configuration.volumeSnapshotLocation[0].config.resourceGroup"
    value = data.azurerm_resource_group.rg.name
  }

  # set {
  #   name  = "configuration.volumeSnapshotLocation[0].config.tenantId"
  #   value = ${local.tenant_id}
  # }

  # Set the subscription ID to be able to access the Resource Group
  set {
    name  = "configuration.volumeSnapshotLocation[0].config.subscriptionId"
    value = var.subscription_id
  }

  set {
    name  = "credentials.secretContents.cloud"
    value = <<EOF
      AZURE_SUBSCRIPTION_ID=${var.subscription_id}
      AZURE_TENANT_ID=${var.tenant_id}
      AZURE_RESOURCE_GROUP=${data.azurerm_resource_group.mc_rg_aks.name}
      AZURE_CLIENT_ID=${var.service_principal_client_id}
      AZURE_CLIENT_SECRET=${var.service_principal_client_secret}
      AZURE_CLOUD_NAME=AzurePublicCloud
      EOF
  }
}