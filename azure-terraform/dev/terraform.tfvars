subscription_id             = "7ed271cf-21f2-4685-8190-0c8056606cb7" # Dev subscription
tenant_id                   = "672bafce-0ccd-4867-8420-e8bb91862ae0" # Sacyr ORG
service_principal_client_id = "559683eb-31f8-40ed-b400-1f6f8f532214" # Dev service principal
service_principal_object_id = "8eb1b799-7a90-4081-a9ee-715a2f426cf5"
location                    = "West Europe"
k8s_version                 = "1.30.3"
vnet_cidr                   = "10.230.0.0/18"
aks_subnet_cidr             = "10.230.0.0/19"
sql_subnet_cidr             = "10.230.32.0/24"
sql_subnet_mi_cidr          = "10.230.33.0/24"
environment                 = "k8s-dev"
onpremise_environment       = "onp-dev"
resource_environment        = "dev"
dns_zone_hostname           = "app.dev.sacyr.com"
tags                        = { "environment" = "dev", "department" = "architecture", "source" = "terraform" }
tags_ia                     = { "environment" = "dev", "department" = "architecture", "source" = "terraform", "application" = "ia" }
tags_aks                    = { "environment" = "dev", "department" = "architecture", "source" = "terraform", "resource" = "aks" }
tags_onp                    = { "environment" = "dev", "department" = "architecture", "source" = "terraform", "resource" = "onPremise" }