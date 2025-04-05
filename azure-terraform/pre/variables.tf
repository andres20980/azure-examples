# Azure provider configuration
variable "subscription_id" {
  type = string
}

variable "tenant_id" {
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

variable "location" {
  type = string
}

# On premise 
variable "onpremise_environment" {
  type = string
}

# AKS
variable "environment" {
  type = string
}

variable "k8s_version" {
  type = string
}

# Network
variable "vnet_cidr" {
  type = string
}

variable "aks_subnet_cidr" {
  type = string
}

variable "sql_subnet_cidr" {
  type = string
}

variable "dns_zone_hostname" {
  type = string
}

# resources
variable "resource_environment" {
  type = string
}

# tags de todos los recursos generados
variable "tags" {
  description = "Tags que se van a establecer en todos los recursos"
  type        = map(string)
}

variable "tags_ia" {
  description = "Tags que se van a establecer en todos los recursos relativos a la aplicación de IA"
  type        = map(string)
}

variable "tags_aks" {
  description = "Tags que se van a establecer en todos los recursos relativos a la aplicación de IA"
  type        = map(string)
}

variable "tags_onp" {
  description = "Tags que se van a establecer en todos los recursos relativos a aplicaciones on Premise"
  type        = map(string)
}