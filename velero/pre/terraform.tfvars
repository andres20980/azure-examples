
# |----------------------------------------|
# |           Velero Configuration         |
# |----------------------------------------|
environment = "k8s-pre"
## Azure Subscription id 
subscription_id = "f164d1ef-b806-40da-a94b-8c271b81c95f"

## Azure tenant id 
tenant_id = "672bafce-0ccd-4867-8420-e8bb91862ae0"

## Name of the resource group where the AKS is placed
## Not the MC_xxxx, the parent of that resource group
resource_group = "k8s-pre-rg"

## Name of the AKS where velero will be running
aks_name = "k8s-pre-aks"

## Storage account name where velero use to place the backups files
storage_account_name = "k8sprestorageaccount"

## Storage account's container's name where backup files will be placed
storage_account_container_name = "velero"

service_principal_client_id = "ed60bde3-4709-4a89-a015-c2e320a0b11f" # Pre service principal
service_principal_object_id = "5672bcc6-d6f8-4764-ba63-ed5a96fbdeb3"