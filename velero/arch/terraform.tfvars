
# |----------------------------------------|
# |           Velero Configuration         |
# |----------------------------------------|
environment = "k8s-arch"
## Azure Subscription id 
subscription_id = "2e3f6de2-88dd-4c8e-b2dd-b8208b832958"

## Azure tenant id 
tenant_id = "672bafce-0ccd-4867-8420-e8bb91862ae0"

## Name of the resource group where the AKS is placed
## Not the MC_xxxx, the parent of that resource group
resource_group = "k8s-arch-rg"

## Name of the AKS where velero will be running
aks_name = "k8s-arch-aks"

## Storage account name where velero use to place the backups files
storage_account_name = "k8sarchstorageaccount"

## Storage account's container's name where backup files will be placed
storage_account_container_name = "velero"

service_principal_client_id = "c5f7d128-2582-466d-b643-d796433ecb29" # Arch service principal
service_principal_object_id = "90b42038-6ac2-4777-acf4-c896d13a517d"