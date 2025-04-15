Awesome! Here’s a complete and **production-ready guide** for setting up a **single manual + auto-triggered GitHub Actions deployment workflow** that:

- 🚀 Deploys to `development`, `staging`, or `production`
- 🖐️ Can be run **manually** (via `workflow_dispatch`)
- 🔁 Auto-triggers on `push` to the `main` branch
- 🛡️ Uses **GitHub Environments** for isolated secrets, approvals, and status
- ✅ Clean, modular, and ready for teams

---

## 📂 File: `.github/workflows/deploy.yml`

```yaml
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
```

---

## 🔐 GitHub Environments Setup

In your repository:

1. Go to **Settings → Environments**
2. Create 3 environments:
   - `development`
   - `staging`
   - `production`
3. For each:
   - Add required **secrets**:
     - `AZURE_CREDENTIALS`
     - `AZURE_CONTAINER_REGISTRY`
     - `AZURE_REGISTRY_USERNAME`
     - `AZURE_REGISTRY_PASSWORD`
   - (Optional) Enable **approval rules** for `production`

---

## 🧪 How to Use

### Option 1: Manual Deployment

1. Go to **Actions**
2. Select **“Azure Deployment”**
3. Click **“Run workflow”**
4. Choose the environment to deploy to

---

### Option 2: Auto Deploy

- A push to the `main` branch will automatically trigger **development deployment** only.

If you want to auto-deploy to `staging` or `production` from branches like `release` or `tags`, we can extend the logic — just say the word.

---

Would you like this turned into a **reusable template** next, or is this version good for you right now?
