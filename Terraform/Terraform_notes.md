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

## Terraform state file:

- Terraform state file also know as `terraform.tfstate` is a **JSON** file that acts as an persistent, up to date snapshot of the infrastructure managed by the terraform.

-  It records the current state and metadata of all resources Terraform has created, modified, or deleted, mapping them to the resource definitions in your Terraform configuration files `(.tf files)`.

- This mapping allows Terraform to determine what changes—creations, updates, deletions—need to be made to align your actual infrastructure with your configuration during each run.



![terraform state](images/statefile.png)

### Using remote backend to store the state file:


- **Enables Team Collaboration:** Multiple people can safely work on the same infrastructure and always have access to the latest state file.
- **Provides State Locking:** Prevents simultaneous changes by different users, reducing the risk of state corruption.
- **Improves Security:** State file is encrypted at rest, with access managed through Azure RBAC. Sensitive resource data is not stored on individual computers
- **Ensures Durability:** Azure Storage offers automatic redundancy and backup, protecting the state file from loss or accidental deletion.
- **Facilitates Automation:** Allows CI/CD pipelines and automation tools to reliably access and update the state file from anywhere.
- **Avoids Local Risks:** No dependency on a single machine—state is always available, even if local hardware fails.
- **Supports Versioning:** Azure Blob Storage can provide version history and point-in-time recovery for your state files.


### How to use Azure Storage as a remote backend for your Terraform state file:

Step 1 : Create a storage account.

Step 2 : add a backend in the terraform file.

```HCL
terraform {
  backend "azurerm" {
    resource_group_name   = "tfstate"
    storage_account_name  = "<STORAGE_ACCOUNT_NAME>"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"  # This can be any path/filename you wish
  }
}
```

- Here my service principle has the access to an contributor role to my subscription hence there will no issues.
- however if the your account does not have proper access this may not work and you will be requiring a SAS token, storage account access key, azure AD with manage identity.


## Variables in Terraform

Variables in terraform are used to make the configuration more flexible, reusable and modular.

There are tree types of variable:

- Input variable
- output variable
- local variable


---

###  Types of Variables in Terraform

1. **Input Variables**
   Allow users to customize Terraform modules or configurations without changing the code.

2. **Output Variables**
   Used to output information from a module or the root configuration after the apply phase.

---

###  Input Variables (Declaring)

Input variables are declared using the `variable` block:

```hcl
variable "region" {
  description = "The AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}
```

You can then reference this variable using:

```hcl
provider "aws" {
  region = var.region
}
```

---

###  Variable Types

Terraform supports the following types for variables:

| Type     | Example                           |
| -------- | --------------------------------- |
| `string` | `"us-east-1"`                     |
| `number` | `5` or `5.5`                      |
| `bool`   | `true` or `false`                 |
| `list`   | `["web", "db", "cache"]`          |
| `map`    | `{ environment = "prod" }`        |
| `object` | `{ name = string, age = number }` |
| `any`    | Accepts any type                  |

---

###  Assigning Variable Values

You can assign values to variables in various ways:

1. **Command Line:**

   ```bash
   terraform apply -var="region=us-west-1"
   ```

2. **`.tfvars` file:**

   ```hcl
   region = "us-west-1"
   ```

   Then apply using:

   ```bash
   terraform apply -var-file="vars.tfvars"
   ```

3. **Environment variables:**

   ```bash
   export TF_VAR_region="us-west-1"
   ```

---

### Output Variables

Output variables are defined using `output` block to show useful info after applying:

```hcl
output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

---

### Example

```hcl
# main.tf
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = var.instance_type
}

output "instance_id" {
  value = aws_instance.web.id
}
```

---


---

### Precedence 
| Precedence | Source                                                             |
| ---------- | ------------------------------------------------------------------ |
| 🥇 Highest | Command line `-var` and `-var-file`                                |
| 🥈         | Auto-loaded `.auto.tfvars` and `.auto.tfvars.json` (lexical order) |
| 🥉         | `terraform.tfvars.json`                                            |
| 4️⃣        | `terraform.tfvars`                                                 |
| 5️⃣ Lowest | Environment variables (`TF_VAR_`)                                  |

> **Note:** Default values defined in the `variable` blocks are only used **if no value is provided from any of the above sources**.

---


## Terraform File Structure

Terraform project structure is simple and flexible. Here’s a **typical file/folder layout** used in most Terraform projects:

---

###  Basic File Structure

```
my-terraform-project/
├── main.tf           # Main configuration (resources, providers)
├── variables.tf      # Input variables declared here
├── outputs.tf        # Output values shown after apply
├── terraform.tfvars  # Variable values (optional)
├── backend.tf        # Remote backend config (optional)
├── versions.tf       # Provider and Terraform version constraints (optional)
└── .terraform/       # Internal Terraform state & plugin files (auto-created)
```

---


| File/Folder                | Purpose                                           |
| -------------------------- | ------------------------------------------------- |
| `main.tf`                  | Primary config: resources, provider setup, etc.   |
| `variables.tf`             | Declares input variables with `variable` blocks   |
| `terraform.tfvars`         | Supplies values for variables (`key = value`)     |
| `outputs.tf`               | Declares `output` blocks to export values         |
| `backend.tf`               | Configures remote state (e.g., S3, Azure blob)    |
| `versions.tf`              | Locks provider and Terraform versions             |
| `.terraform/`              | Terraform internal files (don't edit manually)    |
| `terraform.tfstate`        | Tracks the actual deployed state (auto-generated) |
| `terraform.tfstate.backup` | Backup of the last state file                     |


---

#  Terraform Meta-Arguments: `depends_on`, `count`, and `for_each`

---

## 1.  `depends_on` – Force Resource Dependency

###  Purpose:

Ensures **explicit execution order**, useful when Terraform **cannot detect implicit dependency**.

###  Syntax:

```hcl
resource "azurerm_virtual_machine_extension" "example" {
  name                 = "example-script"
  virtual_machine_id   = azurerm_linux_virtual_machine.example.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = jsonencode({
    commandToExecute = "echo Hello > /tmp/hello.txt"
  })

  depends_on = [
    azurerm_storage_account.example
  ]
}
```

###  Use Case in Azure:

* VM extension depends on storage account to be ready.
* Used when **script needs access to a blob or file share**.

---

## 2.  `count` – Create Multiple Resource Copies (Index-based)

###  Purpose:

Create **n number of identical resources** or **conditionally enable a resource**.

###  Syntax:

```hcl
resource "azurerm_network_interface" "example" {
  count               = 3
  name                = "nic-${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}
```

### Use Case in Azure:

* Create **multiple NICs** for different VMs.
* Easily scalable using a number input.

---

## 3.  `for_each` – Create Resources Using Map or Set (Key-based)

###  Purpose:

Create multiple resources from a **set or map** with **named instances** (better than `count` for readability).

### Syntax:

```hcl
variable "tags" {
  default = {
    dev  = "East US"
    prod = "West Europe"
  }
}

resource "azurerm_resource_group" "example" {
  for_each = var.tags

  name     = "rg-${each.key}"
  location = each.value
}
```

###  Use Case in Azure:

* Create **multiple resource groups**, each with a different environment name and location.

---


## Lifecycle

The `lifecycle` block is a **meta-argument** that allows you to control how Terraform **creates, updates, and destroys** resources.

It's used inside a resource block to change **default behaviors** like:

* When to **ignore changes** to specific attributes
* Whether to **create before destroy**
* Prevent accidental **deletion** of resources

---

##  Syntax

```hcl
resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = "East US"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }
}
```

---

##  Lifecycle Sub-Arguments

### 1.  `prevent_destroy`

> Prevents Terraform from destroying the resource, even if it's removed from the config.

```hcl
lifecycle {
  prevent_destroy = true
}
```

####  Use case:

* Prevent accidental deletion of **critical Azure resources** like:

  * Key Vaults
  * Resource Groups
  * Databases

---

### 2.  `create_before_destroy`

> Tells Terraform to **create a new resource before destroying the old one**.

```hcl
lifecycle {
  create_before_destroy = true
}
```

####  Use case:

* Required when **replacing resources** that cannot have downtime.
* Example: You want to change the name of a VM's NIC.

---

### 3.  `ignore_changes`

> Tells Terraform to **ignore changes** to specific attributes when doing plan/apply.

```hcl
lifecycle {
  ignore_changes = [
    tags,
    sku
  ]
}
```

####  Use case:

* Avoid unnecessary recreation of Azure resources due to **tag changes** by someone outside Terraform (e.g., Azure Portal, Policy).

---

##  Example in Azure – Using All Lifecycle Controls

```hcl
resource "azurerm_storage_account" "example" {
  name                     = "examplestoracc123"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }

  lifecycle {
    prevent_destroy     = true
    create_before_destroy = true
    ignore_changes      = [tags]
  }
}
```

###  Explanation:

* **Prevent destroy**: Protects the storage account from being deleted.
* **Create before destroy**: Ensures a new storage account is created before replacing the old one.
* **Ignore changes**: Ignores tag changes, preventing unwanted updates.

---

## To keep in mind

* **`prevent_destroy`** will cause `terraform destroy` to fail unless overridden with `-target` and lifecycle removed.
* **`ignore_changes`** should be used cautiously — it can lead to drift.
* **`create_before_destroy`** requires that the resource supports having 2 instances at once — **VM names and NICs must be unique**.

---


## PreCondition Block:

The `Precondition` block **checks an expression before applying a change to a resource**, data source , module or output.

If the expression evaluates to **false**, Terraform stops the plan/apply and returns a custom error message


 ### Syntax :

```HCL
resource "azurerm_storage_account" "example" {
  name                     = "examplestoracc123"
  location                 = "East US"
  resource_group_name      = "rg-example"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    precondition {
      condition     = var.environment != "prod" || var.enable_https
      error_message = "HTTPS must be enabled in production."
    }
  }
}

```


 | Field           | Type    | Description                                   |
| --------------- | ------- | --------------------------------------------- |
| `condition`     | Boolean | Required. Must evaluate to `true` or `false`. |
| `error_message` | String  | Required. Shown when `condition` is `false`.  |




| Feature          | Description                                          |
| ---------------- | ---------------------------------------------------- |
| `precondition`   | Validates conditions before applying resource change |
| Common Use Cases | Region checks, environment-based enforcement         |
| Available In     | Resources, modules, outputs, data sources            |
| Required Fields  | `condition`, `error_message`                         |


---


## Dynamic Block

In Terraform, a **`dynamic` block** is used when you want to **generate nested blocks programmatically**, especially when the number or structure of those nested blocks depends on variables or other dynamic input.

This is most helpful when working with **nested configuration blocks** (like `security_rule`, `ip_configuration`, `tags`, etc.), where the number of blocks is **not fixed**.

---

## 🧠 What is a `dynamic` block?

The `dynamic` block **replaces repeated nested blocks** with a **loop** using `for_each`.

It tells Terraform:

> "Loop through this collection and generate a nested block for each item."

---

## 📘 Syntax

```hcl
resource "resource_type" "example" {
  # ...

  dynamic "block_name" {
    for_each = var.list_or_map
    content {
      # Inside here, you use item.value
    }
  }
}
```

---

## ✅ Example: Azure NSG with Dynamic Security Rules

Let’s say you want to define multiple security rules dynamically for a Network Security Group (NSG):

### 🔹 Without `dynamic` block (hardcoded):

```hcl
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = "East US"
  resource_group_name = "example-rg"

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Imagine repeating many more blocks manually...
}
```

---

### 🔹 With `dynamic` block:

```hcl
variable "nsg_rules" {
  default = [
    {
      name     = "AllowHTTP"
      port     = 80
      priority = 100
    },
    {
      name     = "AllowHTTPS"
      port     = 443
      priority = 110
    }
  ]
}

resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = "East US"
  resource_group_name = "example-rg"

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = tostring(security_rule.value.port)
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}
```

---

## 🔄 Breakdown

| Field                 | Purpose                                                   |
| --------------------- | --------------------------------------------------------- |
| `dynamic`             | Declares a dynamic block                                  |
| `security_rule`       | The name of the nested block you're dynamically creating  |
| `for_each`            | The list or map you're looping through                    |
| `security_rule.value` | Accesses the current item’s fields in the `content` block |

---

## 🧾 When to Use `dynamic`

✅ Use it when:

* You want to **generate repeated nested blocks** based on input.
* You need **clean, DRY code** for optional or variable-length configurations.

🚫 Avoid it when:

* You only need to assign attributes (not nested blocks) — use maps/lists or locals instead.

---

## 🧷 Common Use Cases in Azure

| Use Case                         | Dynamic Block Name     |
| -------------------------------- | ---------------------- |
| NSG security rules               | `security_rule`        |
| VM extensions                    | `extension`            |
| Application Gateway backend pool | `backend_address_pool` |
| DNS record sets                  | `record`               |

---


 Here's a clear and concise Terraform **notes sheet** covering **conditional** and **splat expressions**, with Azure in mind:

---



## 1. Conditional Expressions (`condition ? true_val : false_val`)

### 🔹 Syntax:

```hcl
condition ? result_if_true : result_if_false
```

### 🔹 Use Cases:

* Set different values based on a variable or resource output.
* Simplify `if-else` logic inside resource blocks or variables.

### 🔹 Example:

```hcl
variable "environment" {
  default = "prod"
}

resource "azurerm_resource_group" "example" {
  name     = var.environment == "prod" ? "rg-prod" : "rg-dev"
  location = "East US"
}
```

If `var.environment` is `"prod"`, `name = "rg-prod"`, else `name = "rg-dev"`.

---

## ⚠️ Tip:

Can be nested or combined with `count`, `for_each`, and `dynamic`.

---

## ⭐ 2. Splat Expressions (`*` operator)

Splat expressions extract values from **lists of resources** or **complex objects**.

### 🔹 Syntax:

```hcl
resource_type.resource_name[*].attribute
```

### 🔹 Example:

```hcl
output "vm_names" {
  value = azurerm_virtual_machine.example[*].name
}
```

This gives a list of VM names: `["vm1", "vm2", "vm3"]`

---

### 🔹 Full vs. Legacy Splat

| Type             | Example    | Returns             |
| ---------------- | ---------- | ------------------- |
| **Full splat**   | `[*].name` | A list of names     |
| **Legacy splat** | `.name`    | Automatically loops |

```hcl
azurerm_linux_virtual_machine.vm[*].private_ip_address
```

---

### 🔹 Splat With Conditions:

```hcl
output "prod_vm_names" {
  value = [
    for vm in azurerm_virtual_machine.example : vm.name
    if vm.tags["env"] == "prod"
  ]
}
```

---

## 🧠 When to Use Them

| Use Case                      | Use                                 |
| ----------------------------- | ----------------------------------- |
| Conditional value assignment  | `? :`                               |
| Dynamic resource names/values | Conditional + interpolation         |
| Collecting values from a list | Splat (`[*].attribute`)             |
| Filtering lists of resources  | `for` + `if` (instead of raw splat) |

---

## ✅ Final Example (Combined Use)

```hcl
output "vm_private_ips" {
  value = [
    for vm in azurerm_linux_virtual_machine.example :
    vm.private_ip_address
    if var.environment == "prod"
  ]
}
```

---

