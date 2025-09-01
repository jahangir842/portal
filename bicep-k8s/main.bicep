// main.bicep - Main deployment file
@description('The location for all resources')
param location string = resourceGroup().location

@description('The name prefix for all resources')
param namePrefix string = 'aks-demo'

@description('Environment (dev, staging, prod)')
param environment string = 'dev'

@description('AKS cluster configuration')
param aksConfig object = {
  nodeCount: 3
  vmSize: 'Standard_DS2_v2'
  kubernetesVersion: '1.28.3'
  enableAutoScaling: true
  minCount: 1
  maxCount: 5
}

@description('Network configuration')
param networkConfig object = {
  vnetAddressPrefix: '10.0.0.0/16'
  aksSubnetPrefix: '10.0.1.0/24'
  servicesSubnetPrefix: '10.0.2.0/24'
}

// Virtual Network Module
module vnet 'modules/network.bicep' = {
  name: 'vnet-deployment'
  params: {
    location: location
    namePrefix: namePrefix
    environment: environment
    vnetAddressPrefix: networkConfig.vnetAddressPrefix
    aksSubnetPrefix: networkConfig.aksSubnetPrefix
    servicesSubnetPrefix: networkConfig.servicesSubnetPrefix
  }
}

// Log Analytics Workspace Module
module logAnalytics 'modules/log-analytics.bicep' = {
  name: 'log-analytics-deployment'
  params: {
    location: location
    namePrefix: namePrefix
    environment: environment
  }
}

// AKS Cluster Module
module aks 'modules/aks.bicep' = {
  name: 'aks-deployment'
  params: {
    location: location
    namePrefix: namePrefix
    environment: environment
    subnetId: vnet.outputs.aksSubnetId
    logAnalyticsWorkspaceId: logAnalytics.outputs.workspaceId
    aksConfig: aksConfig
  }
}

// Outputs
output aksClusterName string = aks.outputs.aksClusterName
output aksClusterFqdn string = aks.outputs.aksClusterFqdn
output vnetId string = vnet.outputs.vnetId
output logAnalyticsWorkspaceId string = logAnalytics.outputs.workspaceId
