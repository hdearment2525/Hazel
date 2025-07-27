param location string = resourceGroup().location
param vmName string = 'hvm01'
param ausername string
@secure()
param apassword string

resource storage 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: 'diag${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {}
}

resource pip 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: '${vmName}-pip'
  location: location
  sku: {name: 'Standard'}
  
  properties: {
    publicIPAllocationMethod: 'Static'
    
  }

}
resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: '${vmName}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}
resource nic 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', '${vmName}-vnet', 'default')
          }
        }
      }
    ]
  }
  dependsOn: [
    vnet
    pip
]
}

resource ubuntuVM 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    osProfile: {
      computerName: vmName
      adminUsername: ausername
      adminPassword: apassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: 'https://${storage.name}.blob.${environment().suffixes.storage}/'
      }
    }
  }
  dependsOn: [
    nic
    storage
  ]
}

