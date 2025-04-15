name: Azure Deployment

on:
  push:
    branches:
      - main
  workflow_dispatch:
    inputs:
      environment:
        description: "Choose the environment to deploy"
        required: true
        type: choice
        options:
          - development
          - staging
          - production

jobs:
  deploy-dev:
    if: ${{ github.event_name == 'workflow_dispatch' && github.event.inputs.environment == 'development' || github.ref == 'refs/heads/main' }}
    name: Deploy to Development
    runs-on: ubuntu-latest
    environment: development

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Deploy to Azure Container App - Dev
        uses: azure/container-apps-deploy-action@v1
        with:
          appSourcePath: ${{ github.workspace }}
          acrName: ${{ secrets.AZURE_CONTAINER_REGISTRY }}
          acrUsername: ${{ secrets.AZURE_REGISTRY_USERNAME }}
          acrPassword: ${{ secrets.AZURE_REGISTRY_PASSWORD }}
          containerAppName: portal-app-dev
          resourceGroup: portal-rg-dev
          imageToDeploy: ${{ secrets.AZURE_CONTAINER_REGISTRY }}.azurecr.io/portal:${{ github.sha }}
          targetPort: 5000

  deploy-staging:
    if: ${{ github.event_name == 'workflow_dispatch' && github.event.inputs.environment == 'staging' }}
    name: Deploy to Staging
    runs-on: ubuntu-latest
    environment: staging

    steps:
      - uses: actions/checkout@v4

      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Deploy to Azure Container App - Staging
        uses: azure/container-apps-deploy-action@v1
        with:
          appSourcePath: ${{ github.workspace }}
          acrName: ${{ secrets.AZURE_CONTAINER_REGISTRY }}
          acrUsername: ${{ secrets.AZURE_REGISTRY_USERNAME }}
          acrPassword: ${{ secrets.AZURE_REGISTRY_PASSWORD }}
          containerAppName: portal-app-staging
          resourceGroup: portal-rg-staging
          imageToDeploy: ${{ secrets.AZURE_CONTAINER_REGISTRY }}.azurecr.io/portal:${{ github.sha }}
          targetPort: 5000

  deploy-prod:
    if: ${{ github.event_name == 'workflow_dispatch' && github.event.inputs.environment == 'production' }}
    name: Deploy to Production
    runs-on: ubuntu-latest
    environment: production

    steps:
      - uses: actions/checkout@v4

      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Deploy to Azure Container App - Production
        uses: azure/container-apps-deploy-action@v1
        with:
          appSourcePath: ${{ github.workspace }}
          acrName: ${{ secrets.AZURE_CONTAINER_REGISTRY }}
          acrUsername: ${{ secrets.AZURE_REGISTRY_USERNAME }}
          acrPassword: ${{ secrets.AZURE_REGISTRY_PASSWORD }}
          containerAppName: portal-app-prod
          resourceGroup: portal-rg-prod
          imageToDeploy: ${{ secrets.AZURE_CONTAINER_REGISTRY }}.azurecr.io/portal:${{ github.sha }}
          targetPort: 5000
