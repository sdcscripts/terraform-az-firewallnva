Azure Firewall with Hub and Spoke model Simple Deployment
=========================================================

![Alt text](../master/supporting/diagram.jpg?raw=true "Diagram")

This code will quickly (usually within 15 mins) build a simple deployment of a hub and spoke architecture. In each spoke is n-tier subnets and a single Linux server which is configured with a simple web page showing the hostname and uptime. This helps if you wish to test load balancing, or just if you wish to test HTTP connections to the VMs. 

The resources are provisioned into a number of resource groups by resource type, for instance, compute, network etc. 

This is designed for lab use, and further security hardening would be recommended if you wish to use this for any production workloads. This lab will provide you with the basic foundation in order to test and learn more about Azure Firewall. 

## Requirements

* terraform core `0.12.n`
* tested with terraform AzureRM provider `2.0.0`
* an authenticated connection to an azure subscription (or add service principal info to the azurerm provider block)


> Deploying this module will incur cost in your subscription!


The key points and features are:

- **Easy Run**: There is a `terraform.tfvars.example` file which you should rename to `terraform.tfvars` and you will then need to set the password for the vmadmin account. All other variable entries can be used or you can optionally set them to new values if you wish. Afterwards, simply run Terraform init, Terraform apply and it will deploy all resources into UK South.  

- **Network Security Group Rules**: This deployment will automatically attach an NSG rule to the web subnets in each spoke network to allow SSH from the hub management subnet for both SSH and ICMP. Another NSG will allow SSH direct to the management VM, be aware of this, you may wish to disallow this and set up alternative methods to remote to the VM such as Azure Bastion, VPN or Expressroute. 

- **Azure Firewall Configuration**: The firewall is configured with a Network Rule Collection which will allow spoke to spoke SSH connections. Port 80 is also permitted from the hub managmement VM to each spoke VM, which you can test using facilities such as curl. i.e curl 10.100.1.4 (if the IP for the spoke VM is 10.100.1.4). 

- **Terraform Outputs**: The configuration will output the Azure firewall public FQDN, the hub management VM public FQDN, the private IP addresses of both the web VMs in each vnet spoke and also the username and password for all VMs. 

Terraform Getting Started & Documentation
-----------------------------------------

If you're new to Terraform and want to get started creating infrastructure, please checkout our [Getting Started](https://www.terraform.io/intro/getting-started/install.html) guide, available on the [Terraform website](http://www.terraform.io).

All documentation is available on the [Terraform website](http://www.terraform.io):

  - [Intro](https://www.terraform.io/intro/index.html)
  - [Docs](https://www.terraform.io/docs/index.html)