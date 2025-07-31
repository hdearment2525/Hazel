
param secGroup string = 'sg01'
param secRule string
param desc string
param proto string
param dest string
param sourceip string
param destip string = 'hvm01-pip'
param access 'Allow' | 'Deny'
param direction 'Inbound' | 'Outbound'
param priority int

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
