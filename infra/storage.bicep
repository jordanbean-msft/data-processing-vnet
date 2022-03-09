param blobStorageAccountContainerPrivateLinkDnsName string
param dataFactoryManagedIdentityName string
param endpointsSubnetName string
param landingStorageAccountBlobContainerPrivateEndpointName string
param landingStorageAccountDfsContainerPrivateEndpointName string
param landingStorageAccountName string
param rawStorageAccountBlobContainerPrivateEndpointName string
param rawStorageAccountDfsContainerPrivateEndpointName string
param rawStorageAccountName string
param readyStorageAccountBlobContainerPrivateEndpointName string
param readyStorageAccountDfsContainerPrivateEndpointName string
param readyStorageAccountName string
param location string
param privateSubnetName string
param publicSubnetName string
param vNetName string
param dfsStorageAccountContainerPrivateLinkDnsName string

resource vNet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vNetName
}

resource endpointsSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  name: '${vNetName}/${endpointsSubnetName}'
}

resource blobStorageAccountContainerPrivateLinkDns 'Microsoft.Network/privateDnsZones@2018-05-01' existing = {
  name: blobStorageAccountContainerPrivateLinkDnsName
}

resource dfsStorageAccountContainerPrivateLinkDns 'Microsoft.Network/privateDnsZones@2018-05-01' existing = {
  name: dfsStorageAccountContainerPrivateLinkDnsName
}

resource landingStorageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: landingStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    isHnsEnabled: true
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: '${vNet.id}/subnets/${endpointsSubnetName}'
          action: 'Allow'
        } 
      ]
    }
  }
}

resource landingStorageAccountBlobContainerPrivateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: landingStorageAccountBlobContainerPrivateEndpointName
  location: location
  properties: {
    subnet: {
      id: endpointsSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: landingStorageAccountBlobContainerPrivateEndpointName
        properties: {
          privateLinkServiceId: landingStorageAccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

resource landingStorageAccountDfsContainerPrivateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: landingStorageAccountDfsContainerPrivateEndpointName
  location: location
  properties: {
    subnet: {
      id: endpointsSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: landingStorageAccountDfsContainerPrivateEndpointName
        properties: {
          privateLinkServiceId: landingStorageAccount.id
          groupIds: [
            'dfs'
          ]
        }
      }
    ]
  }
}

resource blobStorageAccountContainerPrivateLinkDnsNameZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  name: '${landingStorageAccountBlobContainerPrivateEndpoint.name}/default'
  location: location
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-blob-azure-net'
        properties: {
          privateDnsZoneId: blobStorageAccountContainerPrivateLinkDns.id
        }
      }
    ]
  }
}

resource dfsStorageAccountContainerPrivateLinkDnsNameZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  name: '${landingStorageAccountDfsContainerPrivateEndpoint.name}/default'
  location: location
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-dfs-azure-net'
        properties: {
          privateDnsZoneId: dfsStorageAccountContainerPrivateLinkDns.id
        }
      }
    ]
  }
}

resource dataFactoryManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: dataFactoryManagedIdentityName
}

var storageBlobDataContributorRoleDefinition = resourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')

resource landingStorageAccountdataFactoryManagedIdentityRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(landingStorageAccount.id, dataFactoryManagedIdentity.id, storageBlobDataContributorRoleDefinition)
  properties: {
    principalId: dataFactoryManagedIdentity.properties.principalId
    roleDefinitionId: storageBlobDataContributorRoleDefinition
    principalType: 'ServicePrincipal'
  }
  scope: landingStorageAccount
}

resource rawStorageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: rawStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    isHnsEnabled: true
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: '${vNet.id}/subnets/${publicSubnetName}'
          action: 'Allow'
        }
        {
          id: '${vNet.id}/subnets/${privateSubnetName}'
          action: 'Allow'
        }
        {
          id: '${vNet.id}/subnets/${endpointsSubnetName}'
          action: 'Allow'
        } 
      ]
    }
  }
}

resource rawStorageAccountBlobContainerPrivateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: rawStorageAccountBlobContainerPrivateEndpointName
  location: location
  properties: {
    subnet: {
      id: endpointsSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: rawStorageAccountBlobContainerPrivateEndpointName
        properties: {
          privateLinkServiceId: rawStorageAccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

resource rawStorageAccountdataFactoryManagedIdentityRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(rawStorageAccount.id, dataFactoryManagedIdentity.id, storageBlobDataContributorRoleDefinition)
  properties: {
    principalId: dataFactoryManagedIdentity.properties.principalId
    roleDefinitionId: storageBlobDataContributorRoleDefinition
    principalType: 'ServicePrincipal'
  }
  scope: rawStorageAccount
}

resource rawStorageAccountDfsContainerPrivateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: rawStorageAccountDfsContainerPrivateEndpointName
  location: location
  properties: {
    subnet: {
      id: endpointsSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: rawStorageAccountDfsContainerPrivateEndpointName
        properties: {
          privateLinkServiceId: rawStorageAccount.id
          groupIds: [
            'dfs'
          ]
        }
      }
    ]
  }
}

resource readyStorageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: readyStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    isHnsEnabled: true
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: '${vNet.id}/subnets/${publicSubnetName}'
          action: 'Allow'
        }
        {
          id: '${vNet.id}/subnets/${privateSubnetName}'
          action: 'Allow'
        }
        {
          id: '${vNet.id}/subnets/${endpointsSubnetName}'
          action: 'Allow'
        }
      ]
    }
  }
}

resource readyStorageAccountBlobContainerPrivateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: readyStorageAccountBlobContainerPrivateEndpointName
  location: location
  properties: {
    subnet: {
      id: endpointsSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: readyStorageAccountBlobContainerPrivateEndpointName
        properties: {
          privateLinkServiceId: readyStorageAccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

resource readyStorageAccountDfsContainerPrivateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: readyStorageAccountDfsContainerPrivateEndpointName
  location: location
  properties: {
    subnet: {
      id: endpointsSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: readyStorageAccountDfsContainerPrivateEndpointName
        properties: {
          privateLinkServiceId: readyStorageAccount.id
          groupIds: [
            'dfs'
          ]
        }
      }
    ]
  }
}
