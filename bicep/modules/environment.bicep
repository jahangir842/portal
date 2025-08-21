param location string
param environmentName string
param logAnalyticsId string

resource containerAppEnv 'Microsoft.App/managedEnvironments@2025-01-01' = {
  name: environmentName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsId
      }
    }
  }
}

output environmentId string = containerAppEnv.id
