# Kubernetes Deployment for Flask Web Portal

This directory contains Kubernetes manifests for deploying the Flask Web Portal application.

## Prerequisites

Before deploying the application, ensure the following prerequisites are met:

- Kubernetes cluster is set up and running.
- `kubectl` is installed and configured to interact with the cluster.
- Docker image for the Flask Web Portal is built and pushed to a container registry accessible by the cluster.

## Files

- `deployment.yaml`: Defines the Deployment resource for the Flask application.
- `service.yaml`: Defines the Service resource to expose the application within the cluster.
- `ingress.yaml`: Defines the Ingress resource for external access to the application.

## Deployment Steps

1. **Create the Namespace**

   Create the portal namespace first:

   ```bash
   kubectl create namespace portal
   ```

2. **Apply the Deployment Manifest**

   Deploy the Flask application to the cluster:

   ```bash
   kubectl apply -f deployment.yaml
   ```

3. **Apply the Service Manifest**

   Expose the application within the cluster:

   ```bash
   kubectl apply -f service.yaml
   ```

4. **Apply the Ingress Manifest**

   Configure external access to the application:

   ```bash
   kubectl apply -f ingress.yaml
   ```

## Verify Deployment

1. Check the status of the pods:

   ```bash
   kubectl get pods -n portal
   ```

2. Check the status of the services:

   ```bash
   kubectl get svc -n portal
   ```

3. Check the status of the ingress:

   ```bash
   kubectl get ingress -n portal
   ```

## Accessing the Application

### LoadBalancer Access

If using a LoadBalancer service, get the external IP:

```bash
kubectl get svc -n portal
```

Then access the application at: `http://<EXTERNAL-IP>:8000`

### Ingress Access

1. Ensure an ingress controller is installed (e.g., NGINX Ingress Controller)
2. Get the ingress controller's external IP:
   ```bash
   kubectl get svc -n ingress-nginx
   ```
3. Add the following entry to your `/etc/hosts` file (Linux/Mac) or `C:\Windows\System32\drivers\etc\hosts` (Windows):
   ```
   <INGRESS-CONTROLLER-IP> portal.local
   ```
4. Access the application at: `http://portal.local`

## Cleanup

To delete the resources created by the manifests:

```bash
kubectl delete -f ingress.yaml
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
kubectl delete namespace portal
```

## Notes

- All resources are deployed in the `portal` namespace for better organization and isolation.
- Update the `image` field in `deployment.yaml` to point to the correct Docker image.
- Ensure the `ingress.yaml` file is configured with the correct hostname and TLS settings if required.
- Make sure an ingress controller is installed in your cluster for the ingress to work properly.

## Troubleshooting

### Common Issues

1. **Namespace not found error**: Make sure to create the namespace first with `kubectl create namespace portal`
2. **Ingress not working**: Verify that an ingress controller is installed and running
3. **Service not accessible**: Check if pods are running with `kubectl get pods -n portal`

---

For more information on Kubernetes, refer to the [official documentation](https://kubernetes.io/docs/).