param vNetName string
param publicSubnetName string
param privateSubnetName string
param endpointsSubnetName string
param location string
param dataFactoryPrivateLinkDnsName string
param publicSubnetNsgName string
param privateSubnetNsgName string
param endpointsSubnetNsgName string
param blobStorageAccountContainerPrivateLinkDnsName string
param dfsStorageAccountContainerPrivateLinkDnsName string

resource publicSubnetNsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: publicSubnetNsgName
  location: location
  properties: {
        securityRules: [
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound'
        properties: {
          description: 'Required for worker nodes communication within a cluster'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'  
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-webapp'
        properties: {
          description: 'Required for workers communication with Databricks Webapp'
          protocol: 'Tcp'
          sourcePortRange: '*' 
          destinationPortRange: '443'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'AzureDatabricks'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql'
          properties: {
          description: 'Required for workers communication with Azure SQL services.'
          protocol: 'Tcp'
          sourcePortRange: '*' 
          destinationPortRange: '3306'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Sql'
          access: 'Allow'
          priority: 101
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage'
          properties: {
          description: 'Required for workers communication with Azure Storage services.'
          protocol: 'Tcp'
          sourcePortRange: '*' 
          destinationPortRange: '443'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Storage'
          access: 'Allow'
          priority: 102
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound'
          properties: {
          description: 'Required for worker nodes communication within a cluster.'
          protocol: '*'
          sourcePortRange: '*' 
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 103
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub'
          properties: {
          description: 'Required for worker communication with Azure Eventhub services.'
          protocol: 'Tcp'
          sourcePortRange: '*' 
          destinationPortRange: '9093'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'EventHub'
          access: 'Allow'
          priority: 104
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-databricks-control-plane-to-worker-ssh'
          properties: {
          protocol: 'Tcp'
          sourcePortRange: '*' 
          destinationPortRange: '22'
          sourceAddressPrefix: 'AzureDatabricks'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 105
          direction: 'Inbound'
        }
      }
        {
        name: 'Microsoft.Databricks-databricks-control-plane-to-worker-proxy'
          properties: {
          protocol: 'Tcp'
          sourcePortRange: '*' 
          destinationPortRange: '5557'
          sourceAddressPrefix: 'AzureDatabricks'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 106
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource privateSubnetNsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: privateSubnetNsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound'
        properties: {
          description: 'Required for worker nodes communication within a cluster'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'  
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-webapp'
        properties: {
          description: 'Required for workers communication with Databricks Webapp'
          protocol: 'Tcp'
          sourcePortRange: '*' 
          destinationPortRange: '443'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'AzureDatabricks'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql'
          properties: {
          description: 'Required for workers communication with Azure SQL services.'
          protocol: 'Tcp'
          sourcePortRange: '*' 
          destinationPortRange: '3306'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Sql'
          access: 'Allow'
          priority: 101
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage'
          properties: {
          description: 'Required for workers communication with Azure Storage services.'
          protocol: 'Tcp'
          sourcePortRange: '*' 
          destinationPortRange: '443'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Storage'
          access: 'Allow'
          priority: 102
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound'
          properties: {
          description: 'Required for worker nodes communication within a cluster.'
          protocol: '*'
          sourcePortRange: '*' 
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 103
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub'
          properties: {
          description: 'Required for worker communication with Azure Eventhub services.'
          protocol: 'Tcp'
          sourcePortRange: '*' 
          destinationPortRange: '9093'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'EventHub'
          access: 'Allow'
          priority: 104
          direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-databricks-control-plane-to-worker-ssh'
          properties: {
          protocol: 'Tcp'
          sourcePortRange: '*' 
          destinationPortRange: '22'
          sourceAddressPrefix: 'AzureDatabricks'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 105
          direction: 'Inbound'
        }
      }
        {
        name: 'Microsoft.Databricks-databricks-control-plane-to-worker-proxy'
          properties: {
          protocol: 'Tcp'
          sourcePortRange: '*' 
          destinationPortRange: '5557'
          sourceAddressPrefix: 'AzureDatabricks'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 106
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource endpointsSubnetNsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: endpointsSubnetNsgName
  location: location
}

resource vNet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.33.0.0/16'
      ]
    }
    subnets: [
      {
        name: publicSubnetName
        properties: {
          addressPrefix: '10.33.1.0/26'
          serviceEndpoints: [
            {
               service: 'Microsoft.Storage'
            }
          ]
          delegations: [
            {
               name: 'databricks-del-public'
               properties: {
                 serviceName: 'Microsoft.Databricks/workspaces'
               }
            }
          ]
          networkSecurityGroup: {
             id: publicSubnetNsg.id
          }
        }
      }
      {
        name: privateSubnetName
        properties: {
          addressPrefix: '10.33.1.128/26'
          serviceEndpoints: [
            {
               service: 'Microsoft.Storage'
            }
          ]
          delegations: [
            {
               name: 'databricks-del-private'
               properties: {
                 serviceName: 'Microsoft.Databricks/workspaces'
               }
            }
          ]
          networkSecurityGroup: {
             id: privateSubnetNsg.id
          }
        }
      }
      {
        name: endpointsSubnetName
        properties: {
          addressPrefix: '10.33.1.64/26'
          serviceEndpoints: [
            {
               service: 'Microsoft.Storage'
            }
          ]
          privateLinkServiceNetworkPolicies: 'Enabled'
          privateEndpointNetworkPolicies: 'Disabled'
          networkSecurityGroup: {
             id: endpointsSubnetNsg.id
          }
        }
      }
    ]
  }
}

resource dataFactoryPrivateLinkDnsVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${dataFactoryPrivateLinkDnsName}/${uniqueString(vNet.id)}'
  location: 'global'
  properties: {
    virtualNetwork: {
      id: vNet.id
    }
    registrationEnabled: false
  }
}

resource blobStorageAccountContainerPrivateLinkDnsVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${blobStorageAccountContainerPrivateLinkDnsName}/${uniqueString(vNet.id)}'
  location: 'global'
  properties: {
    virtualNetwork: {
      id: vNet.id
    }
    registrationEnabled: false
  }
}

resource dfsStorageAccountContainerPrivateLinkDnsVirtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${dfsStorageAccountContainerPrivateLinkDnsName}/${uniqueString(vNet.id)}'
  location: 'global'
  properties: {
    virtualNetwork: {
      id: vNet.id
    }
    registrationEnabled: false
  }
}

output vNetName string = vNet.name
output endpointsSubnetName string = endpointsSubnetName
output privateSubnetName string = privateSubnetName
output publicSubnetName string = publicSubnetName
