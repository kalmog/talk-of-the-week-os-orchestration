## Provisioing
(Automating VM install in Openstack)


# Heat
https://wiki.openstack.org/wiki/Heat


# Heat
enables you to deploy
## complete
virtual environments


###Installing the
## Heat Client
```
    apt-get install python-heatclient
```


##Subcommands
```
    output-list         Show available outputs.
    output-show         Show a specific stack output.
    resource-list       Show list of resources belonging to a stack.
    resource-metadata   List resource metadata.
    resource-show       Describe the resource.
    resource-signal     Send a signal to a resource.
    resource-template   Generate a template based on a resource.
    resource-type-list  List the available resource types.
    resource-type-show  Show the resource type.
    stack-abandon       Abandon the stack.
    stack-adopt         Adopt a stack.
    stack-create        Create the stack.
    stack-delete        Delete the stack(s).
    stack-list          List the user's stacks.
    stack-show          Describe the stack.
    stack-update        Update the stack.
    template-show       Get the template for the specified stack.
    template-validate   Validate a template with parameters.
```


## Heat
supports two distinct
# formats


# CFN
Amazon CloudFormation compatible template
# HOT
Heat Orchestration Template


HOT is 100%
# YAML


What can we
# do
with Heat?


### `OS::Nova::Server`
Configures Nova guests


```
resources:
  mybox:
    type: "OS::Nova::Server"
    properties:
      name: mybox
      image: trusty-server-cloudimg-amd64
      flavor: m1.small
      key_name: mykey
```


Now we could just
# create
this stack


```sh
heat stack-create -f stack.yml mystack
```


But as it is,

it's not very
# flexible


Let's add some
## parameters


```
parameters:
  flavor:
    type: string
    description: Flavor to use for servers
    default: m1.medium
  image:
    type: string
    description: Image name or ID
    default: trusty-server-cloudimg-amd64
  key_name:
    type: string
    description: Keypair to inject into newly created servers
```


And some
## intrinsic functions


```
resources:
  mybox:
    type: "OS::Nova::Server"
    properties:
      name: mybox
      image: { get_param: image }
      flavor: { get_param: flavor }
      key_name: { get_param: key_name }
```


And now we can
# set
these parameters


```sh
heat stack-create -f stack.yml \
  -P key_name=mykey
  -P image=cirros-0.3.3-x86_64 \
  mystack
```


How about we add some
## network connectivity
Wouldn't that be nice?


### `OS::Neutron::FloatingIP`
Allocates floating IP addresses


```
  myfloating_ip:
    type: "OS::Neutron::FloatingIP"
    properties:
      floating_network: { get_param: public_net }
```


### `OS::Neutron::SecurityGroup`
Configures Neutron security groups


```
  mysecurity_group:
    type: OS::Neutron::SecurityGroup
    properties:
      description: Neutron security group rules
      name: mysecurity_group
      rules:
      - remote_ip_prefix: 0.0.0.0/0
        protocol: tcp
        port_range_min: 22
        port_range_max: 22
      - remote_ip_prefix: 0.0.0.0/0
        protocol: icmp
        direction: ingress
```


## `get_resource`
Cross-reference between resources

Automatic dependency


```
resources:
  mybox:
    type: "OS::Nova::Server"
    properties:
      name: mybox
      image: { get_param: image }
      flavor: { get_param: flavor }
      key_name: { get_param: key_name }
      security_groups: [{ get_resource: mysecurity_group }]
```


### `OS::Neutron::Net`
### `OS::Neutron::Subnet`
Defines Neutron networks


### `OS::Neutron::Router`
### `OS::Neutron::RouterGateway`
### `OS::Neutron::RouterInterface`
Configures Neutron routers


### `outputs`
Return stack values or attributes


```
outputs:
  public_ip:
    description: Floating IP address in public network
    value: { get_attr: [ myfloating_ip, floating_ip_address ] }
```


```sh
heat output-show \
  mystack public_ip
```
