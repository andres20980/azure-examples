## Azure Terraform infrastructure definition

This repository contains the current state of the infrastructure per environment.

Current environments are: **Dev**, **Arch**, **Pre** and **Pro**

Each environment has, as a baseline, the following components:
- An Azure Kubernetes Service (AKS).
- An Azure Application Gateway with WAF capabilities.
- A public static IPv4 with a DDoS protection plan attached to it.
- A Virtual Network with two subnets and its network security rules configured.
- A Storage account with a container to persist the terraform state and a fileshare.
- An Api Management and 2 OpenAI instances.
- A Search Service.
- Two Cognitive accounts.
- A Key Vault with an access policy to the service principal account tied to the AKS.
- A Cosmos DB instance.

Additionally, **Dev** and **Arch** environments have an automation schedule to start and stop the AKS before starting and after ending the working day from monday to friday. The schedule is set to trigger at 7AM and at 10PM. The cluster remains stopped during weekends.

## Prerequisites

To perform terraform operations outside automation the following tools need to be installed
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Considerations

- If executing `terraform` commands outside automation, make sure to have logged in with an account with proper permissions using the `az cli`.
- If you want the `tfstate` to persist outside the scope of local execution (which is very much recommended), you will need to create the `resource group`, the `storage account` and the container before initializing the terraform backend. 
Then you need to import de RG -->  terraform import azurerm_resource_group.rg "/subscriptions/2e3f6de2-88dd-4c8e-b2dd-b8208b832958/resourceGroups/k8s-arch-rg". And you need to import Storage account: 
terraform import azurerm_storage_account.storage_account "/subscriptions/2e3f6de2-88dd-4c8e-b2dd-b8208b832958/resourceGroups/k8s-arch-rg/providers/Microsoft.Storage/storageAccounts/k8sarchstorageaccount"

## TODO:
- Add automation that performs plans on PR and executes them on merge to main