# Terraform
https://www.terraform.io/


Terrform is developed by 
##Hashicorp
And can be downloaded from
https://www.terraform.io/downloads.html


Same as HEAT, terraform
allows you to

build, change, and version
## infrastructure


Terraform is
##Cloud-Agnostic
(it doesn't care which cloud you use)


It also supports an
##Ever-Growing
number of providers


Openstack & AWS,
##but also
Consul, Docker, InfluxDB, Mysql

And more...


The syntax is custom, but
#Simple


##Subcommands
```
Available commands are:
    apply       Builds or changes infrastructure
    destroy     Destroy Terraform-managed infrastructure
    get         Download and install modules for the configuration
    graph       Create a visual graph of Terraform resources
    init        Initializes Terraform configuration from a module
    output      Read an output from a state file
    plan        Generate and show an execution plan
    push        Upload this Terraform module to Atlas to run
    refresh     Update local state file against real resources
    remote      Configure remote state storage
    show        Inspect Terraform state or plan
    taint       Manually mark a resource for recreation
    untaint     Manually unmark a resource as tainted
    validate    Validates the Terraform files
    version     Prints the Terraform version
```


Terraform is also different from HEAT

in that it separates between
##Planning
and
##Executing


This allows terraform to determine what
##changed
in a configuration
##before
executing the plan


A few
## Examples


#### `openstack_compute_instance_v2`
Configures new Nova guests


```
resource "openstack_compute_instance_v2" "Genesis" {
  name = "genesis44-1"
  image_name = "mobile_genesis"
  flavor_name = "m1.small"
  key_pair = "mobile_cloud_key"
}
```


Let's create our server with `terraform plan`

```
+ openstack_compute_instance_v2.Genesis
    access_ip_v4:      "" => "<computed>"
    access_ip_v6:      "" => "<computed>"
    flavor_id:         "" => "<computed>"
    flavor_name:       "" => "1C-1G-10G-V1-S"
    image_id:          "" => "<computed>"
    image_name:        "" => "mobile_genesis"
    key_pair:          "" => "mobile_cloud_key"
    name:              "" => "genesis"
    network.#:         "" => "<computed>"
    region:            "" => "ams1"
    security_groups.#: "" => "<computed>"
    volume.#:          "" => "<computed>"

Plan: 1 to add, 0 to change, 0 to destroy.
```


`terraform apply` will create our server

```
openstack_compute_instance_v2.Genesis: Creating...
  access_ip_v4:      "" => "<computed>"
  access_ip_v6:      "" => "<computed>"
  flavor_id:         "" => "<computed>"
  flavor_name:       "" => "1C-1G-10G-V1-S"
  image_id:          "" => "<computed>"
  image_name:        "" => "mobile_genesis"
  key_pair:          "" => "mobile_cloud_key"
  name:              "" => "genesis"
  network.#:         "" => "<computed>"
  region:            "" => "ams1"
  security_groups.#: "" => "<computed>"
  volume.#:          "" => "<computed>"
openstack_compute_instance_v2.Genesis: Creation complete

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```


`openstack_compute_secgroup_v2`

creates a security group


```
resource "openstack_compute_secgroup_v2" "base" {
  name = "base_security_group"
  description = "Basic SSH/SSL Security Policy"
  rule { from_port = 22 to_port = 22 ip_protocol = "tcp" cidr = "0.0.0.0/0" }
  rule { from_port = 80 to_port = 80 ip_protocol = "tcp" cidr = "0.0.0.0/0" }
  rule { from_port = 53 to_port = 53 ip_protocol = "tcp" cidr = "0.0.0.0/0" }
  rule { from_port = 53 to_port = 53 ip_protocol = "udp" cidr = "0.0.0.0/0" }
  rule { from_port = 443 to_port = 443 ip_protocol = "tcp" cidr = "0.0.0.0/0" }
  rule { from_port = -1 to_port = -1 ip_protocol = "icmp" cidr = "0.0.0.0/0" }
}
```


##Using Parameters


```
variable genesis-flavor { default = "2C-2G-10G-V1-S" }
variable key-pair { default = "mobile_cloud_key" }
```


Or from the command line
```
terraform plan \
  -var 'genesis-flavor=2C-2G-10G-V1-S' \
  -var 'key-pair=mobile_cloud_key'
```


```
resource "openstack_compute_instance_v2" "Genesis" {
  name = "genesis44-1"
  image_name = "mobile_genesis"
  flavor_name = "${var.genesis-flavor}"
  key_pair = "${var.key-pair}"
  security_groups = ["base_security_group"]
}
```


##Dependencies
`(depends_on)`


```
resource "openstack_compute_instance_v2" "Genesis" {
  name = "genesis44-1"
  image_name = "mobile_genesis"
  flavor_name = "${var.genesis-flavor}"
  key_pair = "${var.key-pair}"
  depends_on = [ "openstack_compute_secgroup_v2.base" ]
```


What if we have a number of servers,
##Identical 
in all ways, but the hostname?


```
// Variables
variable "db_count" { default = 3 }

variable "db_hostnames" {
  default = {
    "0" = "dbmaster44-1"
    "1" = "db44-1"
    "2" = "batchdb44-1"
  }
}
```


`count` makes it easier
```
resource "openstack_compute_instance_v2" "Databases" {
  count = "${var.db_count}"
  name = "${lookup(var.db_hostnames, count.index)}"
  image_name = "mobile_db"
  ...
}
```
