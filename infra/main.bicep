param appName string
param region string
param environment string
param location string = resourceGroup().location

module names 'resource-names.bicep' = {
  name: 'resource-names'
  params: {
    appName: appName
    region: region
    env: environment
  }
}

module dnsDeployment 'dns.bicep' = {
  name: 'dns-deployment'
  params: {
    dataFactoryPrivateLinkDnsName: names.outputs.dataFactoryPrivateLinkDnsName
    blobStorageAccountContainerPrivateLinkDnsName: names.outputs.blobStorageAccountContainerPrivateLinkDnsName
    dfsStorageAccountContainerPrivateLinkDnsName: names.outputs.dfsStorageAccountContainerPrivateLinkDnsName
  }
}

module vNetDeployment 'vnet.bicep' = {
  name: 'vnet-deployment'
  params: {
    endpointsSubnetName: names.outputs.endpointsSubnetName
    privateSubnetName: names.outputs.privateSubnetName
    publicSubnetName: names.outputs.publicSubnetName
    vNetName: names.outputs.vNetName
    location: location
    endpointsSubnetNsgName: names.outputs.endpointsSubnetNsgName
    privateSubnetNsgName: names.outputs.privateSubnetNsgName
    publicSubnetNsgName: names.outputs.publicSubnetNsgName
    blobStorageAccountContainerPrivateLinkDnsName: dnsDeployment.outputs.blobStorageAccountContainerPrivateLinkDnsName
    dataFactoryPrivateLinkDnsName: dnsDeployment.outputs.dataFactoryPrivateLinkDnsName
  }
}

module managedIdentityDeployment 'managed-identities.bicep' = {
  name: 'managed-identity-deployment'
  params: {
    dataFactoryManagedIdentityName: names.outputs.dataFactoryManagedIdentityName
    location: location
  }
}

module storageDeployment 'storage.bicep' = {
  name: 'storage-deployment'
  params: {
    dataFactoryManagedIdentityName: managedIdentityDeployment.outputs.dataFactoryManagedIdentityName
    endpointsSubnetName: names.outputs.endpointsSubnetName
    landingStorageAccountName: names.outputs.landingStorageAcocuntName
    privateSubnetName: names.outputs.privateSubnetName
    publicSubnetName: names.outputs.publicSubnetName
    rawStorageAccountName: names.outputs.rawStorageAccountName
    readyStorageAccountName: names.outputs.readyStorageAccountName
    vNetName: vNetDeployment.outputs.vNetName
    location: location
    blobStorageAccountContainerPrivateLinkDnsName: dnsDeployment.outputs.blobStorageAccountContainerPrivateLinkDnsName
    landingStorageAccountBlobContainerPrivateEndpointName: names.outputs.landingStorageAccountBlobContainerPrivateEndpointName
    dfsStorageAccountContainerPrivateLinkDnsName: dnsDeployment.outputs.dfsStorageAccountContainerPrivateLinkDnsName
    landingStorageAccountDfsContainerPrivateEndpointName: names.outputs.landingStorageAccountDfsContainerPrivateEndpointName
    rawStorageAccountBlobContainerPrivateEndpointName: names.outputs.rawStorageAccountBlobContainerPrivateEndpointName
    rawStorageAccountDfsContainerPrivateEndpointName: names.outputs.rawStorageAccountDfsContainerPrivateEndpointName
    readyStorageAccountBlobContainerPrivateEndpointName: names.outputs.readyStorageAccountBlobContainerPrivateEndpointName
    readyStorageAccountDfsContainerPrivateEndpointName: names.outputs.readyStorageAccountDfsContainerPrivateEndpointName
  }
}

module dataFactoryDeployment 'data-factory.bicep' = {
  name: 'data-factory-deployment'
  params: {
    dataFactoryManagedIdentityName: managedIdentityDeployment.outputs.dataFactoryManagedIdentityName
    dataFactoryName: names.outputs.dataFactoryName
    location: location
    dataFactoryPrivateEndpointName: names.outputs.dataFactoryPrivateEndpointName
    dataFactoryPrivateLinkDnsName: dnsDeployment.outputs.dataFactoryPrivateLinkDnsName
    endpointsSubnetName: vNetDeployment.outputs.endpointsSubnetName
    vNetName: vNetDeployment.outputs.vNetName
  }
}

module databricksDeployment 'databricks.bicep' = {
  name: 'databricks-deployment'
  params: {
    databricksWorkspaceName: names.outputs.databricksWorkspaceName
    location: location
    privateSubnetName: vNetDeployment.outputs.privateSubnetName
    publicSubnetName: vNetDeployment.outputs.publicSubnetName
    vNetName: vNetDeployment.outputs.vNetName
  }
}
