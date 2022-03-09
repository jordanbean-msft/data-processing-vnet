param dataFactoryManagedIdentityName string
param location string

resource dataFactoryManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: dataFactoryManagedIdentityName
  location: location
}

// resource databricksManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
//   name: databricksManagedIdentityName
//   location: 
// }

output dataFactoryManagedIdentityName string = dataFactoryManagedIdentity.name
