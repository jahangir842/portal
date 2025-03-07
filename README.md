# Python Application DevOps Practice

This repository contains a simple Python Flask application with complete DevOps setup using Azure DevOps, Docker, and Kubernetes.

## Prerequisites

- Python 3.x
- Docker
- kubectl
- Azure DevOps account
- Docker Hub account
- Local Kubernetes cluster (kubeadm)


## Getting Started

1. Clone the repository:
   ```bash
   git clone https://techiebricks@dev.azure.com/techiebricks/Portal/_git/Portal
   cd Portal
   ```

1. Clone the repository (If ssh Access):
   ```bash
   git clone git@ssh.dev.azure.com:v3/techiebricks/Portal/Portal
   cd Portal
   ```

2. Create and activate a virtual environment (recommended):
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows use: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Run the application:
   ```bash
   python app.py
   ```

5. Access the portal:
   - Open your browser and navigate to `http://localhost:5000`
   - You should see the dashboard with:
     - Quick links to various services
     - Current time display
     - Interactive calendar widget

6. Testing different features:
   - Click on the quick links to verify they open in new tabs
   - Check if the calendar widget responds to navigation
   - Verify the current time is displayed correctly

7. Stop the application:
   - Press `Ctrl+C` in the terminal
   - Deactivate virtual environment: `deactivate`

## Build Docker image

1. Build image:
   ```bash
   docker build -t your-dockerhub-username/python-app:latest .
   ```

2. Test locally:
   ```bash
   docker run -p 5000:5000 your-dockerhub-username/python-app:latest
   ```

### Pushing to Docker Hub Registry

1. Log in to Docker Hub:
   ```bash
   docker login
   ```

2. Tag your image with your Docker Hub username:
   ```bash
   docker tag portal-dashboard YOUR_DOCKERHUB_USERNAME/portal-dashboard:latest
   ```

3. Push the image to Docker Hub:
   ```bash
   docker push YOUR_DOCKERHUB_USERNAME/portal-dashboard:latest
   ```

### Pulling and Running from Docker Hub

After pushing, others can run your image using:
   ```bash
   docker pull YOUR_DOCKERHUB_USERNAME/portal-dashboard:latest
   docker run -d -p 5000:5000 YOUR_DOCKERHUB_USERNAME/portal-dashboard:latest
   ```

## Azure DevOps Setup

1. Create a new project in Azure DevOps
2. Import this repository
3. Create a Docker Hub service connection named 'DockerHubConnection'
4. Update the pipeline variable 'dockerHubUsername'
5. Run the pipeline

## Kubernetes Deployment

1. Update the image name in deployment.yaml
2. Deploy:
   ```bash
   kubectl apply -f deployment.yaml
   ```

3. Verify:
   ```bash
   kubectl get pods
   kubectl get svc
   ```

Access the application at http://node-ip:nodeport