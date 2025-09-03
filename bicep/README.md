# Bicep Infrastructure as Code

This repository contains **Bicep templates** to provision and manage Azure infrastructure for multiple application deployment targets.  
Each subfolder represents a different Azure service where applications can be deployed.  
Shared modules are reusable building blocks (e.g., networking, identity, monitoring).

---

## 📂 Folder Structure

```bash
bicep/
  modules/        # Shared infra components (network, identity, monitoring, storage, log analytics, etc.)
  aca/            # Azure Container Apps deployment
  aci/            # Azure Container Instances deployment
  aks/            # Azure Kubernetes Service deployment + Kubernetes manifests/Helm
  app-service/    # Azure App Service (Web App or Web App for Containers) deployment
  functions/      # Azure Functions (serverless) deployment
  vmss/           # Virtual Machine Scale Sets deployment
```

## 📂 Rule of Thumb

- bicep/modules/ → shared modules

    - Can be used across multiple services (e.g., VNet, identity, storage, monitoring).

- Inside each service folder (e.g., bicep/aks/modules/) → service-specific modules

    - Only make sense for that service (e.g., AKS node pool, App Service Plan, ACA revision).


---

## 🗂 Folder Details

### 1. `modules/`

* Contains reusable Bicep modules:

  * `network.bicep` → VNet, Subnets
  * `identity.bicep` → Managed Identity, Role Assignments
  * `monitoring.bicep` → Log Analytics, App Insights
  * `storage.bicep` → Storage Accounts

### 2. `aca/`

* Infrastructure for **Azure Container Apps**
* Defines environment, container apps, scaling rules, secrets, and ingress

### 3. `aci/`

* Infrastructure for **Azure Container Instances**
* Defines single-container or multi-container groups
* Useful for quick jobs, test environments, or lightweight deployments

### 4. `aks/`

* Infrastructure for **Azure Kubernetes Service**
* Defines AKS cluster, node pools, identity, networking, and monitoring
* Includes `k8s/` subfolder for Kubernetes manifests (Deployments, Services, Ingress) or Helm charts

### 5. `app-service/`

* Infrastructure for **Azure App Service (Web Apps)**
* Supports code-based apps and container-based apps
* Includes App Service Plan + Web App definitions

### 6. `functions/`

* Infrastructure for **Azure Functions**
* Defines Function App, Storage, and Hosting Plan
* Suitable for event-driven or serverless workloads

### 7. `vmss/`

* Infrastructure for **Azure Virtual Machine Scale Sets (VMSS)**
* Defines VMSS, load balancer, autoscaling rules, and extensions
* Can be used for containerized workloads (via VM extension to install Docker)

---

## 🚀 How to Deploy

### 1. Deploy Infrastructure with Bicep

```powershell
New-AzResourceGroupDeployment `
  -ResourceGroupName "<rg-name>" `
  -TemplateFile "bicep/<service>/main.bicep" `
  -TemplateParameterFile "params.json"
```

* Replace `<service>` with `aca`, `aks`, `app-service`, `aci`, `functions`, or `vmss`.

---

## ✅ Best Practices

* Keep **common infra in `modules/`** and reuse across services.
* Use **consistent naming conventions** across Bicep templates.
* Parameterize environment-specific values (dev, test, prod) in `params.json`.
* Deploy infra via **Azure DevOps or GitHub Actions** pipelines with PowerShell tasks.
