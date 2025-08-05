---
nav_exclude: True
---

# Security Group Creation with IAC


[Skip to Deployment](#deployment)


## Params:

```powershell
param location string = resourceGroup().location
param secGroup string = 'sg01'
param secRule string
param desc string
param proto string
param source string
param dest string
param sourceip string
param access 'Allow' | 'Deny'
param direction 'Inbound' | 'Outbound'
```

Our Params are a little more involved for the security groups mostly because we do not want to expose any of the information.

## Script:

```powershell
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: secGroup
  location: location
  properties: {
    securityRules: [
      {
        name: secRule
        properties: {
          description: desc
          protocol: proto
          sourcePortRange: source
          destinationPortRange: dest
          sourceAddressPrefix: sourceip
          destinationAddressPrefix: '*'
          access: access
          priority: 101
          direction: direction
        }
      }
    ]
  }
}
```

This could have been declared in the properties in the VM deployement.
However I think it useful to have seprateley so you can create multiple security groups.
I want to go over each varaible in the script.

## Top Level Name:

This is the name of your security group.


## Location:

This is your region like US-West2


## Security Rule:

This will be a base security rule, and we can also create them in a seperate script. Which I will go into detail now and hop over to a security rule script.


## Security Rule Script:


```powershell
resource existingIp 'Microsoft.Network/publicIPAddresses@2024-07-01' existing = {
  name: destip
}
resource securityRule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${secGroup}/${secRule}'
  properties: {
    description: desc
    protocol: proto
    sourcePortRange: '*'
    destinationPortRange: dest
    sourceAddressPrefix: sourceip
    destinationAddressPrefix: existingIp.properties.ipAddress
    access: access
    direction: direction
    priority: priority
  }
}
```

Lets break this down.


## Existing IP Resource:

This is what we declared when creating the resource group for the security rule


## Security Rule Name

This is just a combination of our specific rule with our group


## Description

Is a short description of our rule


## Protocol

TCP, ICMP, UDP, etc


## Source Port Range:

Set to All because it makes it easier to connect to the vm


## Dest Port Range

This is way more important to specify, for example 22 for SSH, or 80 for HTTP


## Source Address


This is our connecting computer's ip address


## Dest Address

This is what we specified when we created the IP resource to get our VM's public IP


## Access

This is allow or deny this specific connection


## Direction

Inbound or Outbound usually


## Priority

This one is sneakily important it designates the order in which the rules apply.


# Deployment

## Security Group:

1. Login in to [Az Account](azps.md#login-to-azure-account)

2. 