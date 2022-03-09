param dataFactoryName string
param location string
param dataFactoryManagedIdentityName string
param dataFactoryPrivateLinkDnsName string
param dataFactoryPrivateEndpointName string
param vNetName string
param endpointsSubnetName string

resource dataFactoryManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: dataFactoryManagedIdentityName
}

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${dataFactoryManagedIdentity.id}': {}
    }
  }
}

resource endpointsSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  name: '${vNetName}/${endpointsSubnetName}'
}

resource dataFactoryPrivateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: dataFactoryPrivateEndpointName
  location: location
  properties: {
    subnet: {
      id: endpointsSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: dataFactoryPrivateEndpointName
        properties: {
          privateLinkServiceId: dataFactory.id
          groupIds: [
            'dataFactory'
          ]
        }
      }
    ]
  }
}

resource dataFactoryPrivateLinkDns 'Microsoft.Network/privateDnsZones@2018-05-01' existing = {
  name: dataFactoryPrivateLinkDnsName
}

resource dataFactoryPrivateLinkDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  name: '${dataFactoryPrivateEndpoint.name}/default'
  location: location
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-datafactory-azure-net'
        properties: {
          privateDnsZoneId: dataFactoryPrivateLinkDns.id
        }
      }
    ]
  }
}
