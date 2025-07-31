param location string = resourceGroup().location
param secGroup string = 'sg01'
param secRule string
param desc string
param proto string
param source string
param dest string
param sourceip string
param destip string = 'hvm01-pip'
param access 'Allow' | 'Deny'
param direction 'Inbound' | 'Outbound'

resource existingIp 'Microsoft.Network/publicIPAddresses@2024-07-01' existing = {
  name: destip
}

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
