# Create ACR 
az acr create --resource-group app-insight --name jagzregistry --sku Basic

# Log in to ACR
sudo chmod 666 /var/run/docker.sock
az acr login --name jagzregistry

# Tag the portal-jv-app image for ACR
docker tag portal-jv-app jagzregistry.azurecr.io/portal-jv-app:latest
docker tag postgres:15-alpine jagzregistry.azurecr.io/postgres:15-alpine

# Push to ACR
docker push jagzregistry.azurecr.io/portal-jv-app:latest
docker push jagzregistry.azurecr.io/postgres:15-alpine

# Verify the Images in ACR
# List all repositories in your ACR
az acr repository list --name jagzregistry --output table

# Check tags for your portal app
az acr repository show-tags --name jagzregistry --repository portal-jv-app --output table

# Check tags for postgres (if pushed)
az acr repository show-tags --name jagzregistry --repository postgres --output table


------------------


# Connect your AKS cluster to ACR
az aks update -n mycompany-aks-dev -g aks-demo-rg --attach-acr jagzregistry


# Get the credentials and configure kubectl
az aks get-credentials --resource-group aks-demo-rg --name mycompany-aks-dev

# This command will:
# - Download the cluster configuration
# - Set up kubectl context
# - Configure authentication


# Check if kubectl can connect to your cluster
kubectl get nodes

# You should see output like:
# NAME                                STATUS   ROLES   AGE   VERSION
# aks-nodepool1-12345678-vmss000000  Ready    agent   1h    v1.27.3

# Check cluster info
kubectl cluster-info

# Check current context
kubectl config current-context

# Deploy to AKS
kubectl apply -f deployment.yaml

# Check status
kubectl get pods
kubectl get services