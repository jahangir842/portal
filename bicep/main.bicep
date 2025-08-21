param location string = resourceGroup().location
param containerAppName string
param containerImage string
param environmentName string
param logAnalyticsName string

module loganalytics './modules/loganalytics.bicep' = {
  name: 'loganalytics'
  params: {
    location: location
    workspaceName: logAnalyticsName
  }
}

module environment './modules/environment.bicep' = {
  name: 'environment'
  params: {
    location: location
    environmentName: environmentName
    logAnalyticsId: loganalytics.outputs.workspaceId
    logAnalyticsResourceId: loganalytics.outputs.workspaceResourceId  // Add this line
  }
}

module containerapp './modules/containerapp.bicep' = {
  name: 'containerapp'
  params: {
    location: location
    appName: containerAppName
    environmentId: environment.outputs.environmentId
    containerImage: containerImage
  }
}
