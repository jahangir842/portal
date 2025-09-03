// modules/network.bicep - Virtual Network module
@description('The location for all resources')
param location string

@description('The name prefix for all resources')
param namePrefix string

@description('Environment tag')
param environment string

@description('Virtual network address prefix')
param vnetAddressPrefix string

@description('AKS subnet address prefix')
param aksSubnetPrefix string

@description('Services subnet address prefix')
param servicesSubnetPrefix string

// Network Security Group for AKS subnet
resource aksNsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: '${namePrefix}-aks-nsg-${environment}'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowHTTPS'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowHTTP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1001
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowPort8000'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '8000'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1002
          direction: 'Inbound'
        }
      }
    ]
  }
  tags: {
    Environment: environment
    Purpose: 'AKS Security'
  }
}

// Network Security Group for services subnet
resource servicesNsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: '${namePrefix}-services-nsg-${environment}'
  location: location
  properties: {
    securityRules: []
  }
  tags: {
    Environment: environment
    Purpose: 'Services Security'
  }
}

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: '${namePrefix}-vnet-${environment}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [vnetAddressPrefix]
    }
    subnets: [
      {
        name: 'aks-subnet'
        properties: {
          addressPrefix: aksSubnetPrefix
          networkSecurityGroup: {
            id: aksNsg.id
          }
        }
      }
      {
        name: 'services-subnet'
        properties: {
          addressPrefix: servicesSubnetPrefix
          networkSecurityGroup: {
            id: servicesNsg.id
          }
        }
      }
    ]
  }
  tags: {
    Environment: environment
    Purpose: 'AKS Networking'
  }
}

// Outputs
output vnetId string = vnet.id
output vnetName string = vnet.name
output aksSubnetId string = vnet.properties.subnets[0].id
output servicesSubnetId string = vnet.properties.subnets[1].id
