param databricksWorkspaceName string
param location string
param publicSubnetName string
param privateSubnetName string
param vNetName string

resource vNet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vNetName
}

var managedResourceGroupName = 'rg-databricks-${databricksWorkspaceName}-${uniqueString(databricksWorkspaceName, resourceGroup().id)}'
var managedResourceGroupId = subscriptionResourceId('Microsoft.Resources/resourceGroups', managedResourceGroupName)

resource databricks 'Microsoft.Databricks/workspaces@2021-04-01-preview' = {
  name: databricksWorkspaceName
  location: location
  sku: {
    name: 'standard'
  }
  properties: {
    managedResourceGroupId: managedResourceGroupId
    parameters: {
      customVirtualNetworkId: {
        value: vNet.id
      }
      customPublicSubnetName: {
        value: publicSubnetName
      }
      customPrivateSubnetName: {
        value: privateSubnetName
      }
      enableNoPublicIp: {
        value: false
      }
    }
  }
}
