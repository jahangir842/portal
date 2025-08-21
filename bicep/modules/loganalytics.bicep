param location string
param workspaceName string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

output workspaceId string = logAnalytics.properties.customerId
output workspaceName string = logAnalytics.name
output workspaceResourceId string = logAnalytics.id  // Add this for referencing
