param location string
param environmentName string
param logAnalyticsId string
param logAnalyticsResourceId string  // Add this parameter

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-03-01' = {  // Use 2022-03-01 instead of 2025-01-01
  name: environmentName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsId
        sharedKey: listKeys(logAnalyticsResourceId, '2021-06-01').primarySharedKey  // Add this line
      }
    }
  }
}

output environmentId string = containerAppEnv.id
