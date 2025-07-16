# **Deploying azure resources using Azure**

- Terraform is an Infrastructure as Code (IaC) tool by HashiCorp, used to deploy and manage resources on cloud platforms as code rather than through a graphical user interface (GUI).
 - This makes managing and sharing infrastructure much easier.

 ### Without Infrastructure as Code or terraform:

 - Slow deployment
 - Expensive
 - limited automation
 - Human error
 - repetitive
 - Inconsistency
 - wasted resources

## Why use Terraform:

For normal usage vm creation you would go to the cloud provider and build the server using the the GUI which is easy and interactive.however if the infrastructure is much bigger and need lot of resources to be deployed which would take lot of time and is subjected to human error.

**Benefits of IaaC:**
- Consistent environment
- Easy to track cost
- Write once, deploy many (single code base)
- Time saving
- Human error
- Cost saving
- Version control, changes are tracked in git
- Automated cleanup/scheduled destruction
- Easy to set and destroy
- The developer can focus on app development
- Easy to create an identical production environment for troubleshooting

### **How terraform works**

Write your terraform files --> Run terraform commands --> Call the target cloud provider API to provision the infra using Terraform Provider

**Phases:** init --> validate --> plan --> apply --> destroy

![phases](./images/image.png)

#### What  is HCL?
- It  stands for **Hashicorp configuration language**

**Syntax of HCL:**

```HCL
<block> <parameters> {
    arguments
}
```
Example :

```HCL
resource "azurerm_resource_group" "sudhi-rg" {
    name = sudheesh-rg
    location = india
}
```
Here:

`resource` is the **block type**.

 `azurerm_resource_group` is the **parameter**. 

`sudhi-rg` is the **block name**.

`name` and `location` are the **Arguments**.


## Terraform provider:

![Terraform providers](images/image1.png)

Terraform providers are plugins that enable Terraform to interact with external services or platforms, such as cloud providers, infrastructure systems, and third-party tools.

It acts as the bridge between the target API and the terraform code.

There are different types of providers:
- official - managed by hashicorp
- community - managed by open-source community
- partners - managed by both hashicorp and the partner provider.



## Provider version V/S terraform core version:

- Provider version is the version of terraform provider such as azure, aws and GCP.
- Where as the terraform core version version is the terraform CLI version.

For the code to work seamlessly without any issues it is recommended to **lock the version** both the provider and terraform version.

by doing this we can ensure that even if the code is shared it would work in other machines. as by default terraform will use the latest version and if there is any changes are made in the future version and the code is not updated this may cause some problems.

- It is recommended to use the version which is developed and tested.

### Version operators

`=` : exact match

`!=` : Exclude the exact match

`>,>=,<,<=` : Allow the right most to increment 

`~>` : only allow the right most increments

Examples:

```HCL
version = "=3.0.0"   --> exact match
version = ">= 3.0.0"    --> greater than and equal to the version
version = "~> 3.0.0"    --> version 3.0.3 , 3.0.10, 3.0.5 can be used by not 3.2.0, 3.10.0. i.e., the lat bit in the version.
```






