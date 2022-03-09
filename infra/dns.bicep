param dataFactoryPrivateLinkDnsName string
param blobStorageAccountContainerPrivateLinkDnsName string
param dfsStorageAccountContainerPrivateLinkDnsName string

resource dataFactoryPrivateLinkDns 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: dataFactoryPrivateLinkDnsName
  location: 'global'
  properties: {}
}

resource blobStorageAccountContainerPrivateLinkDns 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: blobStorageAccountContainerPrivateLinkDnsName
  location: 'global'
  properties: {}
}

resource dfsStorageAccountContainerPrivateLinkDns 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: dfsStorageAccountContainerPrivateLinkDnsName
  location: 'global'
  properties: {}
}

output dataFactoryPrivateLinkDnsName string = dataFactoryPrivateLinkDns.name
output blobStorageAccountContainerPrivateLinkDnsName string = blobStorageAccountContainerPrivateLinkDns.name
output dfsStorageAccountContainerPrivateLinkDnsName string = dfsStorageAccountContainerPrivateLinkDns.name
