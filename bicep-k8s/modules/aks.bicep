// modules/aks.bicep - AKS Cluster module
@description('The location for all resources')
param location string

@description('The name prefix for all resources')
param namePrefix string

@description('Environment tag')
param environment string

@description('Subnet ID for AKS cluster')
param subnetId string

@description('Log Analytics Workspace ID')
param logAnalyticsWorkspaceId string

@description('AKS cluster configuration')
param aksConfig object

// Managed Identity for AKS
resource aksIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${namePrefix}-aks-identity-${environment}'
  location: location
  tags: {
    Environment: environment
    Purpose: 'AKS Identity'
  }
}

// AKS Cluster
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-10-01' = {
  name: '${namePrefix}-aks-${environment}'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${aksIdentity.id}': {}
    }
  }
  properties: {
    kubernetesVersion: aksConfig.kubernetesVersion
    dnsPrefix: '${namePrefix}-aks-${environment}'
    agentPoolProfiles: [
      {
        name: 'default'
        count: aksConfig.nodeCount
        vmSize: aksConfig.vmSize
        osDiskSizeGB: 128
        osDiskType: 'Managed'
        vnetSubnetID: subnetId
        maxPods: 110
        type: 'VirtualMachineScaleSets'
        enableAutoScaling: aksConfig.enableAutoScaling
        minCount: aksConfig.enableAutoScaling ? aksConfig.minCount : null
        maxCount: aksConfig.enableAutoScaling ? aksConfig.maxCount : null
        mode: 'System'
        osType: 'Linux'
        osSKU: 'Ubuntu'
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
      serviceCidr: '10.100.0.0/16'
      dnsServiceIP: '10.100.0.10'
    }
    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspaceId
        }
      }
      azurepolicy: {
        enabled: true
      }
    }
    apiServerAccessProfile: {
      enablePrivateCluster: false
    }
    autoUpgradeProfile: {
      upgradeChannel: 'patch'
    }
  }
  tags: {
    Environment: environment
    Purpose: 'Container Orchestration'
  }
}

// Role assignments for AKS identity
resource networkContributorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: resourceGroup()
  name: guid(resourceGroup().id, aksIdentity.id, 'NetworkContributor')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7') // Network Contributor
    principalId: aksIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Outputs
output aksClusterName string = aksCluster.name
output aksClusterFqdn string = aksCluster.properties.fqdn
output aksClusterId string = aksCluster.id
