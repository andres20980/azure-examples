
# |----------------------------------------|
# |           Velero Configuration         |
# |----------------------------------------|
environment = "k8s-dev"
## Azure Subscription id 
subscription_id = "7ed271cf-21f2-4685-8190-0c8056606cb7"

## Azure tenant id 
tenant_id = "672bafce-0ccd-4867-8420-e8bb91862ae0"

## Name of the resource group where the AKS is placed
## Not the MC_xxxx, the parent of that resource group
resource_group = "k8s-dev-rg"

## Name of the AKS where velero will be running
aks_name = "k8s-dev-aks"

## Storage account name where velero use to place the backups files
storage_account_name = "k8sdevstorageaccount"

## Storage account's container's name where backup files will be placed
storage_account_container_name = "velero"

service_principal_client_id = "559683eb-31f8-40ed-b400-1f6f8f532214" # Dev service principal
service_principal_object_id = "8eb1b799-7a90-4081-a9ee-715a2f426cf5"