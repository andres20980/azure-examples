subscription_id             = "5e800cb7-cf20-431c-a6f9-ceed4a9efa18" # Pro sub
tenant_id                   = "672bafce-0ccd-4867-8420-e8bb91862ae0" # Sacyr ORG
service_principal_client_id = "0446c388-8bcb-4c72-a2fd-57320b9e0264" # Pro service principal
service_principal_object_id = "b7a91f9b-59e0-4e12-a9df-6e1d77cc0e0e"
location                    = "France Central"
k8s_version                 = "1.30.3"
vnet_cidr                   = "10.236.0.0/17"
aks_subnet_cidr             = "10.236.0.0/19"
waf_subnet_cidr             = "10.236.33.0/24"
sql_subnet_cidr             = "10.236.32.0/24"
environment                 = "k8s-pro"
onpremise_environment       = "onp-pro"
dns_zone_hostname           = "app.sacyr.com"
resource_environment        = "pro"
tags                        = { "environment" = "pro", "department" = "architecture", "source" = "terraform" }
tags_ia                     = { "environment" = "pro", "department" = "architecture", "source" = "terraform", "application" = "ia" }
tags_aks                    = { "environment" = "pro", "department" = "architecture", "source" = "terraform", "resource" = "aks" }
tags_onp                    = { "environment" = "pro", "department" = "architecture", "source" = "terraform", "resource" = "onPremise" }