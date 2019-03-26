# Terraform Template for Digital Ocean Swarm with Storidge CIO
This repo contains a [Terraform](https://www.terraform.io/) template for generating and managing clusters of DO droplets with the community edition of the [Storidge CIO](http://storidge.com/docs/) software.

## Configuration
Default cluster configuration (can be altered in the `variables.tf`, `droplets.tf`, and `volumes.tf` files):

* 1 Swarm Master Node
  * 2GB droplet
  * 3 20GB storage drives
* 4 Swarm Worker Nodes
  * 2 GB droplets
  * 3 20GB storage drives on each worker
* Default cluster region: `sfo2`

## Usage
### Set-Up
[Download Terraform](https://www.terraform.io/downloads.html)

Download template into desired project repository:
```
git clone https://github.com/Storidge/terraform-do-swarm-cio.git
```

Initiate terraform:
```
terraform init
```
Add credentials file `terraform.tfvars`:
```
cd terraform-do-swarm-cio
cp terraform.tfvars.template terraform.tfvars
```
Add your DO API token and ssh key information to `terraform.tfvars`.

Update `variables.tf` with correct DO image and region.

To verify your configuration will work run:

```
terraform plan
```

### Deploy cluster
If there are no errors, run the following command to build infrastructure:
```
terraform apply
```
Use the ssh key defined in `terraform.tfvars` to access the cluster.

### Update state
Check current infrastructure state:
```
terraform show terraform.tfstate
```

If the infrastructure has been changed outside terraform, update the state information:
```
terraform refresh
```						

### Terminate cluster
To terminate the cluster run:
```
terraform destroy
```					
