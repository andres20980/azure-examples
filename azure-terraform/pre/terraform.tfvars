subscription_id             = "f164d1ef-b806-40da-a94b-8c271b81c95f" # Pre sub
tenant_id                   = "672bafce-0ccd-4867-8420-e8bb91862ae0" # Sacyr ORG
service_principal_client_id = "ed60bde3-4709-4a89-a015-c2e320a0b11f" # Pre service principal
service_principal_object_id = "5672bcc6-d6f8-4764-ba63-ed5a96fbdeb3"
location                    = "West Europe"
k8s_version                 = "1.30.3"
vnet_cidr                   = "10.232.0.0/17"
aks_subnet_cidr             = "10.232.0.0/19"
sql_subnet_cidr             = "10.232.32.0/24"
environment                 = "k8s-pre"
onpremise_environment       = "onp-pre"
dns_zone_hostname           = "app.pre.sacyr.com"
resource_environment        = "pre"
tags                        = { "environment" = "pre", "department" = "architecture", "source" = "terraform" }
tags_ia                     = { "environment" = "pre", "department" = "architecture", "source" = "terraform", "application" = "ia" }
tags_aks                    = { "environment" = "pre", "department" = "architecture", "source" = "terraform", "resource" = "aks" }
tags_onp                    = { "environment" = "pre", "department" = "architecture", "source" = "terraform", "resource" = "onPremise" }