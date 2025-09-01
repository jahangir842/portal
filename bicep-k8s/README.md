**🚀 Deploy with PowerShell**

Create the resource group:
```powershell
New-AzResourceGroup -Name "aks-demo-rg" -Location "Canada Central"
```

Deploy the AKS cluster:
```powershell
New-AzResourceGroupDeployment `
  -Name "aks-deployment-1" `
  -ResourceGroupName "aks-demo-rg" `
  -TemplateFile ./main.bicep `
  -TemplateParameterFile ./parameters.json
```

Configure kubectl to connect to your AKS cluster:
```powershell
# Get the AKS cluster credentials
Import-AzAksCredential -ResourceGroupName "aks-demo-rg" -Name "mycompany-aks-dev" -Force

# Test the connection
kubectl get nodes
```

Delete the resource group:
```powershell
Remove-AzResourceGroup -Name "aks-demo-rg" 
```