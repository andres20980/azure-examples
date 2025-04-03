
variable "subscription_id" {
  type        = string
  default     = ""
  description = "ID of the Azure subscription"
}

variable "tenant_id" {
  type        = string
  description = "ID of the Azure Tenant"
}

variable "environment" {
  type = string
}

variable "service_principal_client_id" {
  type = string
}

variable "service_principal_client_secret" {
  type = string
}

variable "service_principal_object_id" {
  type = string
}

## RESOURCE VARIABLES

variable "resource_group" {
  type        = string
  default     = ""
  description = "Resource Group where the AKS or ACI is running where velero is going to be deployed. Take into account that is not the MC_ one, the one that its derived from"
}

variable "aks_name" {
  type        = string
  default     = "-aks"
  description = "Name of the AKS where velero will be running"
}

variable "storage_account_name" {
  type        = string
  default     = ""
  description = "Storage account name where velero use to place the backups files"
}

variable "storage_account_container_name" {
  type        = string
  default     = ""
  description = "Storage account's container's name where backup files will be placed"
}


