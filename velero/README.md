# boilerplate-velero

This project is a basic velero deployment within an Azure AKS. 


Velero is an open-source tool used for backup, recovery and migration of Kubernetes Cluster and persistent volumes. 

It protects the kubernetes workloads by allowing to backup the cluster resources and persistent volumes. 

Velero can be deployed in cloud environment or on-premise. 

### Migration

Velero can be used to migrate resources from one Kubernetes cluster to another. This can be useful to change between clusters, migrating between production environments or even migrate between providers. 

Migrate within the same provider can be easily done just by sharing or copying the backups generated previously by Velero, following a similar process as when doing a disaster recovery. 

Migrating the cluster between providers its a little more difficult because Velero use different backup locations and snapshot utilities in each provider. 

### Project structure 

The velero deployment using terraform uses some provider specific resources. 
For each provider, this files are separated in different folders. 

In order to deploy to the correspondent provider. change to the correct directory and do `terraform plan` or `terraform apply` to deploy it. 

Make sure that all the variables are correctly settled for the provider. The configuration of Velero for each provider is specified in the correspondent `README.md` file within each directory. 

