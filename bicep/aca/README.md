# 📂 Recommended folder structure

```
flask-project/
│
├── src/                           # Flask app code
│   ├── app.py
│   └── requirements.txt
│
├── bicep/                         # Infrastructure as Code
│   ├── main.bicep                 # entry point for deployments
│   ├── main.parameters.dev.json   # parameters for dev environment
│   ├── main.parameters.prod.json  # parameters for prod environment
│   │
│   └── modules/                   # reusable building blocks
│       ├── environment.bicep      # container app environment
│       ├── containerapp.bicep     # container app definition
│       └── loganalytics.bicep     # logging + monitoring
│
└── pipelines/                     # CI/CD definitions
    └── deploy.yml
```

---

# 📜 `main.bicep` (entry point)

```bicep
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
```

---

# 📜 `modules/environment.bicep`

```bicep
param location string
param environmentName string
param logAnalyticsId string

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-03-01' = {
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
```

---

# 📜 `modules/containerapp.bicep`

```bicep
param location string
param appName string
param environmentId string
param containerImage string

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: appName
  location: location
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      ingress: {
        external: true
        targetPort: 5000
      }
    }
    template: {
      containers: [
        {
          name: appName
          image: containerImage
          resources: {
            cpu: 0.5
            memory: '1Gi'
          }
        }
      ]
    }
  }
}
```

---

# 📜 `modules/loganalytics.bicep`

```bicep
param location string
param workspaceName string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: workspaceName
  location: location
  properties: {}
  sku: {
    name: 'PerGB2018'
  }
}

output workspaceId string = logAnalytics.properties.customerId
```

---

# 📜 Example parameters file (`main.parameters.dev.json`)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "containerAppName": {
      "value": "flask-api-dev"
    },
    "containerImage": {
      "value": "mydockerhubuser/flaskapi:latest"
    },
    "environmentName": {
      "value": "dev-env"
    },
    "logAnalyticsName": {
      "value": "dev-logs"
    }
  }
}
```

---

# 🚀 Deploy with PowerShell

```powershell
New-AzResourceGroup -Name "devops-rg" -Location "eastus"
```

```powershell
New-AzResourceGroupDeployment `
  -Name "portal0.1" `
  -ResourceGroupName "devops-rg" `
  -TemplateFile ./bicep/main.bicep `
  -TemplateParameterFile ./bicep/main.parameters.dev.json
```

# GitHub Actions CI/CD pipeline

## Create Service Principle

```bash
az ad sp create-for-rbac \
  --name "github-actions-portal" \
  --role "Contributor" \
  --scopes "/subscriptions/{subscription-id}/resourceGroups/devops-rg" \
  --sdk-auth
```
This will output JSON credentials - save them for GitHub secrets.

In your GitHub repository, go to Settings → Secrets and Variables → Actions, and add:

```bash
AZURE_CREDENTIALS - The JSON output from created Service Principle
AZURE_SUBSCRIPTION_ID - Your Azure subscription ID
AZURE_RESOURCE_GROUP - devops-rg
DOCKER_USERNAME - Your Docker Hub username
DOCKER_PASSWORD - Your Docker Hub password/token
CONTAINER_REGISTRY - docker.io (or your ACR if using that)
```

## ARM Deployment Action

https://github.com/Azure/arm-deploy

## Custom domain names and free managed certificates in Azure
https://learn.microsoft.com/en-us/azure/container-apps/custom-domains-managed-certificates?pivots=azure-portal

## Custom domain names and bring your own certificates 
https://learn.microsoft.com/en-us/azure/container-apps/custom-domains-certificates?tabs=general&pivots=azure-portal

## Clear the Resources

```powershell
Remove-AzResourceGroup -Name "devops-rg"
```

---

👉 This structure is **modular**, **clean**, and **ready for CI/CD pipelines**.

* In dev → use `main.parameters.dev.json`
* In prod → use `main.parameters.prod.json`

---


#########################################
       With KEDA Rules
#########################################


let’s extend the **`containerapp.bicep`** module to support **KEDA-based autoscaling rules**.

Azure Container Apps supports **KEDA (Kubernetes Event-Driven Autoscaling)** natively, so you can scale on HTTP requests, CPU, memory, or even external triggers (like Service Bus, Kafka, etc.).

---

## 📜 Updated `modules/containerapp.bicep`

```bicep
param location string
param appName string
param environmentId string
param containerImage string

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: appName
  location: location
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      ingress: {
        external: true
        targetPort: 5000
      }
    }
    template: {
      containers: [
        {
          name: appName
          image: containerImage
          resources: {
            cpu: 0.5
            memory: '1Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 5
        rules: [
          {
            name: 'http-scaling'
            custom: {
              type: 'http'
              metadata: {
                concurrentRequests: '50'
              }
            }
          }
          {
            name: 'cpu-scaling'
            custom: {
              type: 'cpu'
              metadata: {
                type: 'Utilization'
                value: '70'
              }
            }
          }
        ]
      }
    }
  }
}
```

---

## 🔑 Explanation of the KEDA rules

* **minReplicas: 1** → always keep at least 1 instance running
* **maxReplicas: 5** → can scale up to 5 instances
* **Rule 1: HTTP scaling** → If a container instance has more than `50` concurrent HTTP requests, KEDA adds replicas.
* **Rule 2: CPU scaling** → If CPU usage goes above `70%`, it triggers scaling.

You can add **multiple rules** — scaling happens if **any rule is triggered**.

---

## 📜 Example Parameters File (dev)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "containerAppName": {
      "value": "flask-api-dev"
    },
    "containerImage": {
      "value": "mydockerhubuser/flaskapi:latest"
    },
    "environmentName": {
      "value": "dev-env"
    },
    "logAnalyticsName": {
      "value": "dev-logs"
    }
  }
}
```

---

## 🚀 Deploy with PowerShell

```powershell
New-AzResourceGroupDeployment `
  -Name "flaskAppDeploymentDev" `
  -ResourceGroupName "devops-rg" `
  -TemplateFile ./bicep/main.bicep `
  -TemplateParameterFile ./bicep/main.parameters.dev.json
```

---

✅ With this, your **Flask API** will automatically scale based on:

* Incoming HTTP load
* CPU utilization

---
