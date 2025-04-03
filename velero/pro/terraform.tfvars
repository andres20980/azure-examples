
# |----------------------------------------|
# |           Velero Configuration         |
# |----------------------------------------|
environment = "k8s-pro"
## Azure Subscription id 
subscription_id = "5e800cb7-cf20-431c-a6f9-ceed4a9efa18"

## Azure tenant id 
tenant_id = "672bafce-0ccd-4867-8420-e8bb91862ae0"

## Name of the resource group where the AKS is placed
## Not the MC_xxxx, the parent of that resource group
resource_group = "k8s-pro-rg"

## Name of the AKS where velero will be running
aks_name = "k8s-pro-aks"

## Storage account name where velero use to place the backups files
storage_account_name = "k8sprostorageaccount"

## Storage account's container's name where backup files will be placed
storage_account_container_name = "velero"

service_principal_client_id = "0446c388-8bcb-4c72-a2fd-57320b9e0264" # Pro service principal
service_principal_object_id = "b7a91f9b-59e0-4e12-a9df-6e1d77cc0e0e"