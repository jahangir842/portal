# Python Application DevOps Practice

This repository contains a simple Python Flask application with complete DevOps setup using Azure DevOps, Docker, and Kubernetes.

## Prerequisites

- Python 3.x
- Docker
- kubectl
- Azure DevOps account
- Docker Hub account
- Local Kubernetes cluster (kubeadm)

## Local Development

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Run locally:
   ```bash
   python app.py
   ```

## Local Testing Instructions

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd portal
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

## Docker Operations

1. Build image:
   ```bash
   docker build -t your-dockerhub-username/python-app:latest .
   ```

2. Test locally:
   ```bash
   docker run -p 5000:5000 your-dockerhub-username/python-app:latest
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