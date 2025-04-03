#------------------------------------------------------------------------------------------------------#
#  Bastion Host                                                                                        #
#------------------------------------------------------------------------------------------------------#

# resource "azurerm_public_ip" "bastion_host_ip" {
#   name = "octopus-bastion-host-public-ip"
#   location             = var.location
#   resource_group_name  = azurerm_resource_group.rg.name
#   allocation_method    = "Static"
#   sku                  = "Standard"
#   tags                 = var.tags
# }

# resource "azurerm_bastion_host" "octopus_bastion_host" {
#   name = "octopus-bastion"
#   location = var.location
#   resource_group_name = azurerm_resource_group.rg.name
#   copy_paste_enabled = true

#   ip_configuration {
#     name = "bastion-subnet"
#     subnet_id = azurerm_subnet.bastion_subnet.id
#     public_ip_address_id = azurerm_public_ip.bastion_host_ip.id
#   }
# }

# resource "azurerm_subnet" "bastion_subnet" {
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = [var.bastion_subnet_cidr]
# }

# resource "azurerm_network_security_group" "bastion_nsg" {
#   name                = "bastion-security-group"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_subnet_network_security_group_association" "bastion_nsg_association" {
#   subnet_id                 = azurerm_subnet.bastion_subnet.id
#   network_security_group_id = azurerm_network_security_group.bastion_nsg.id
# }

# resource "azurerm_network_security_rule" "bastion_nsg_ingress_https" {
#   name                        = "AllowHttpsInbound"
#   description                 = "Allow traffic from the public internet"
#   priority                    = 120
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_address_prefix       = "Internet"
#   source_port_range           = "*"
#   destination_port_range      = "443"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.bastion_nsg.name
# }

# resource "azurerm_network_security_rule" "bastion_nsg_ingress_cplane" {
#   name                        = "AllowGatewayManagerInbound"
#   description                 = "Allow traffic from GatewayManager. This port range is required for Azure infrastructure communication."
#   priority                    = 130
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_address_prefix       = "GatewayManager"
#   destination_address_prefix  = "*"
#   destination_port_range      = "443"
#   source_port_range           = "*"
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.bastion_nsg.name
# }

# resource "azurerm_network_security_rule" "bastion_nsg_ingress_lb" {
#   name                        = "AllowAzureLoadBalancerInbound"
#   description                 = "For data plane communication between the underlying components of Azure Bastion."
#   priority                    = 140
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_address_prefix       = "AzureLoadBalancer"
#   destination_address_prefix  = "*"
#   destination_port_range      = "443"
#   source_port_range           = "*"
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.bastion_nsg.name
# }

# resource "azurerm_network_security_rule" "bastion_nsg_ingress_dplane" {
#   name                        = "AllowBastionHostCommunication"
#   description                 = "For health probes."
#   priority                    = 150
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_address_prefix       = "VirtualNetwork"
#   destination_address_prefix  = "VirtualNetwork"
#   source_port_range           = "*"
#   destination_port_ranges      = ["8080","5701"]
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.bastion_nsg.name
# }


# resource "azurerm_network_security_rule" "bastion_nsg_egress_vm_subnet" {
#   name                        = "AllowSshRdpOutbound"
#   description                 = "Allow."
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "VirtualNetwork"
#   source_port_range           = "*"
#   destination_port_ranges      = ["22","3389"]
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.bastion_nsg.name
# }


# resource "azurerm_network_security_rule" "bastion_nsg_egress_azure_cloud" {
#   name                        = "AllowAzureCloudOutbound"
#   description                 = "Egress Traffic to other public endpoints in Azure."
#   priority                    = 110
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "AzureCloud"
#   source_port_range           = "*"
#   destination_port_range      = "443"
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.bastion_nsg.name
# }

# resource "azurerm_network_security_rule" "bastion_nsg_egress_dplane" {
#   name                        = "AllowBastionCommunication"
#   description                 = "Egress Traffic to Azure Bastion data plane."
#   priority                    = 120
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_address_prefix       = "VirtualNetwork"
#   destination_address_prefix  = "VirtualNetwork"
#   source_port_range           = "*"
#   destination_port_ranges      = ["8080","5701"]
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.bastion_nsg.name
# }

# resource "azurerm_network_security_rule" "bastion_nsg_egress_http" {
#   name                        = "egress_to_http"
#   description                 = "Egress traffic to the internet"
#   priority                    = 130
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "Internet"
#   source_port_range           = "*"
#   destination_port_range      = "80"
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.bastion_nsg.name
# }

#------------------------------------------------------------------------------------------------------#
#  Octopus Deploy VM                                                                                   #
#------------------------------------------------------------------------------------------------------#

# resource "azurerm_subnet" "vm_subnet" {
#   name                 = "${var.environment}-vm-subnet"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = [var.vm_subnet_cidr]
# }

# resource "azurerm_network_security_group" "vm_nsg" {
#   name                = "vm-security-group"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_subnet_network_security_group_association" "vm_nsg_association" {
#   subnet_id                 = azurerm_subnet.vm_subnet.id
#   network_security_group_id = azurerm_network_security_group.vm_nsg.id
# }

# resource "azurerm_network_security_rule" "vm_nsg_rule_allow_rdp" {
#   name                        = "allow_rdp"
#   description                 = "Allow traffic to RDP"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_address_prefix       = var.bastion_subnet_cidr
#   source_port_range           = "*"
#   destination_port_range      = "3389"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.vm_nsg.name
# }


# resource "azurerm_network_interface" "octopus" {
#   name                = "octopus-vm-nic"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.vm_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "random_password" "password" {
#   length  = 24
#   special = true
# }

# resource "azurerm_windows_virtual_machine" "octopus" {
#   name                  = "octopus"
#   location              = var.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   size                  = "Standard_B2s"
#   network_interface_ids = [azurerm_network_interface.octopus.id]
#   tags                  = var.tags

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2019-Datacenter"
#     version   = "latest"
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   admin_username = "octopusadmin"
#   admin_password = random_password.password.result

# }

# resource "azurerm_virtual_machine_extension" "octopus_aad_extension" {
#   name                       = "AADLoginForWindows"
#   publisher                  = "Microsoft.Azure.ActiveDirectory"
#   virtual_machine_id         = azurerm_windows_virtual_machine.octopus.id
#   type_handler_version       = "2.0"
#   type                       = "AADLoginForWindows"
# }

# output "admin_password" {
#   value     = random_password.password.result
#   sensitive = true
# }

#resource "azurerm_container_app_environment" "octopus" {
#  name                = "octopus"
#  location            = var.location
#  resource_group_name = azurerm_resource_group.rg.name
#  # log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
#}
#
#resource "azurerm_container_app" "octopus" {
#  name                         = "octopus"
#  resource_group_name          = azurerm_resource_group.rg.name
#  revision_mode                = "Single"
#  container_app_environment_id = azurerm_container_app_environment.octopus.id
#
#  ingress {
#    allow_insecure_connections = false
#    external_enabled           = true
#    target_port                = 8080
#    transport                  = "auto"
#
#    traffic_weight {
#      latest_revision = true
#      percentage      = 100
#    }
#  }
#  template {
#    min_replicas = 1
#    max_replicas = 1
#    # init_container {
#    #   name = "install-octopus-tools"
#    #   image = "octopuslabs/k8s-workertools:1.28"
#    #   cpu = 0.5
#    #   memory = "2Gi"
#    # }
#    # init_container {
#    #   name = "install-kubectl"
#    #   image = "bitnami/kubectl:1.28.9-debian-12-r6"
#    #   cpu = 0.5
#    #   memory = "2Gi"
#    #   command = [ "cp -r /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/" ]
#    # }
#    container {
#      name   = "octopus-server"
#      image  = "octopusdeploy/octopusdeploy"
#      cpu    = 2
#      memory = "4Gi"
#
#      ## TODO: put env vars as secrets from kv, and create a user assigned identity to access that KV
#      ## TODO: create a custom octopus docker image that preinstalls az cli, kubectl and helm
#      env {
#        name  = "DB_CONNECTION_STRING"
#        value = "Server=sql-sacyr-dev.westeurope.cloudapp.azure.com;Database=octopus-poc;User Id=octopus-dev;password=Iu|Y|^bQ#E9y/xiñ;Trusted_Connection=False;TrustServerCertificate=True;MultipleActiveResultSets=true;"
#      }
#      env {
#        name  = "MASTER_KEY"
#        value = "9AyxjoKsmbt9yp0lim4wig=="
#      }
#      env {
#        name  = "OCTOPUS_SERVER_BASE64_LICENSE"
#        value = "PExpY2Vuc2UgU2lnbmF0dXJlPSJTZDVEaFNiWkNQL2dhSjBWMFdEVjRTVlR5R0JSVDdkWDBWMmJwV2sxVXFhbjhRRElHazRBMmZnQ0pPeS9HNnk5cVdrZlAvdWNVZ2EzY21lcUdnQ3ZNdz09Ij4KICA8TGljZW5zZWRUbz50ZXN0PC9MaWNlbnNlZFRvPgogIDxMaWNlbnNlS2V5PjAyMDU1LTc0MjA5LTI0NDIxLTQ4OTc5PC9MaWNlbnNlS2V5PgogIDxWZXJzaW9uPjIuMDwhLS0gTGljZW5zZSBTY2hlbWEgVmVyc2lvbiAtLT48L1ZlcnNpb24+CiAgPFZhbGlkRnJvbT4yMDI0LTA2LTEzPC9WYWxpZEZyb20+CiAgPEtpbmQ+VHJpYWw8L0tpbmQ+CiAgPFZhbGlkVG8+MjAyNC0wNy0xMzwvVmFsaWRUbz4KICA8UHJvamVjdExpbWl0PlVubGltaXRlZDwvUHJvamVjdExpbWl0PgogIDxNYWNoaW5lTGltaXQ+VW5saW1pdGVkPC9NYWNoaW5lTGltaXQ+CiAgPFVzZXJMaW1pdD5VbmxpbWl0ZWQ8L1VzZXJMaW1pdD4KPC9MaWNlbnNlPg=="
#      }
#      env {
#        name  = "ADMIN_USERNAME"
#        value = "octopusadmin"
#      }
#      env {
#        name  = "ADMIN_PASSWORD"
#        value = "@Octopus123!"
#      }
#      env {
#        name  = "DISABLE_DIND"
#        value = "Y"
#      }
#      env {
#        name  = "ACCEPT_EULA"
#        value = "Y"
#      }
#    }
#  }
#}