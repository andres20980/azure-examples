subscription_id             = "2e3f6de2-88dd-4c8e-b2dd-b8208b832958" # Arch subscription
tenant_id                   = "672bafce-0ccd-4867-8420-e8bb91862ae0" # Sacyr ORG
service_principal_client_id = "c5f7d128-2582-466d-b643-d796433ecb29" # Arch service principal
service_principal_object_id = "90b42038-6ac2-4777-acf4-c896d13a517d"
location                    = "France Central"
k8s_version                 = "1.30.3"
vnet_cidr                   = "10.230.64.0/18"
aks_subnet_cidr             = "10.230.64.0/19"
sql_subnet_cidr             = "10.230.96.0/24"
environment                 = "k8s-arch"
resource_environment        = "arch"
dns_zone_hostname           = "app.arch.sacyr.com"
tags                        = { "environment" = "arch", "department" = "architecture", "source" = "terraform" }