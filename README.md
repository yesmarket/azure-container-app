# Overview

The motivation for this POC is that I wanted to secure the network access to some cloud resources in Azure - specifically an Azure Storage Account and an Azure SQL Database. *Note: this POC is in Azure, but would also apply to AWS.*

Using Service Endpoints in Azure allows access to multi-tenant PaaS services (such as those mentioned) to be locked down to specific subnets. This is good, but the services still have a public IP. An even *more* secure approach is to use Private Endpoints, which allow PaaS services to have an IP in a customers VNET that represents their service instance.

Having completely disabled public network access to the specified PaaS services in Azure (i.e. Storage Account and SQL Database), I wanted a way to allow authorized users with tools like Microsoft Azure Storage Explorer and Microsoft SQL Server Management Studio (SSMS) on their remote workstations to access the private Storage Account and SQL Database respectively.

I'd heard about a WireGuard-based VPN service called [Tailscale](https://tailscale.com/kb/1151/what-is-tailscale), so I set up my own tailnet consisting of my desktop, laptop, and mobile. I then deployed and configured a Tailscale [subnet-router](https://tailscale.com/kb/1019/subnets) and [app-connector](https://tailscale.com/kb/1281/app-connectors) to an Azure VNET peered to second VNET containing the private endpoint connections for the Azure Storage Account and SQL Database, as well as a internal VM for testing purposes.

I was able to do the following:
1. SSH access from my local workstation to the internal VM in the peered network using the VMs private IP.
2. SSMS access from my local workstation to the private SQL Database.
3. Azure Storage Explorer access from my local workstation to the private Storage Account.

Ultimately this means I can completely lock down the network access to PaaS resources, while still allowing authorized users to access using tools on their their local workstations.

# Deploy

`terraform plan --out=plan.tfplan`<br/>
`terraform apply "plan.tfplan"`

# Destroy

`terraform destroy`
