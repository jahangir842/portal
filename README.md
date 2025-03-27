# Flask Web Portal

A production-ready Flask web application using Gunicorn as WSGI server and Docker for containerization.

## Project Structure

```
portal/
├── app.py              # Main Flask application
├── wsgi.py            # WSGI entry point
├── requirements.txt   # Python dependencies
├── Dockerfile        # Docker configuration
├── static/          # Static files (CSS, JS, images)
└── templates/       # HTML templates
```

## Requirements

- Docker
- Python 3.10+ (for local development)

## Quick Start

### Local Development

1. Create a virtual environment:
2. Create and activate a virtual environment for linux (recommended):

   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   python3 -m venv venv
   source venv/bin/activate  # On Windows use: venv\Scripts\activate
   ```

3. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

4. Run the development server:
   ```bash
   python app.py
   ```

## Production Deployment

The application uses Gunicorn as the WSGI server with the following configuration:

- 4 worker processes
- Binds to all interfaces on port 5000
- WSGI entry point: wsgi.py

## Running with WSGI Server

### Direct Execution

1. Make the run script executable:

```bash
chmod +x run_wsgi.sh
```

2. Run directly with Gunicorn:

```bash
./run_wsgi.sh
```

Or manually:

```bash
# Basic usage
gunicorn wsgi:app

# With configuration
gunicorn --workers=4 --bind=0.0.0.0:5000 wsgi:app

# With additional options
gunicorn --workers=4 \
         --bind=0.0.0.0:5000 \
         --access-logfile=- \
         --error-logfile=- \
         --reload \  # Auto-reload on code changes
         wsgi:app
```

### **Using Docker to Build and Run the Application**

#### **1. Build and Run with Docker**

```bash
# Build the Docker image with a specific tag
docker build -t jahangir842/portal:v1.0 .

# Run the container, mapping port 5000 on the host to port 5000 in the container
docker run -d --name portal -p 5000:5000 jahangir842/portal:v1.0
```

- The `-d` flag runs the container in detached mode.
- The `--name portal` assigns a custom name to the container.
- While building, change the version number as required.

To check running containers:

```bash
docker ps
```

To stop and remove the container:

```bash
docker stop portal && docker rm portal
```

---

#### **2. Run with Docker Compose**

If your project includes a `docker-compose.yml` file, you can start the application using Docker Compose:

```bash
docker-compose up -d
```

- The `-d` flag runs services in detached mode.

To stop and remove containers:

```bash
docker-compose down
```

Would you like me to add instructions for pushing the image to Docker Hub? 🚀

### Common Gunicorn Options

- `--workers`: Number of worker processes (2-4 x NUM_CORES)
- `--bind`: Address and port to bind
- `--reload`: Auto-reload on code changes (development only)
- `--access-logfile`: Access log file location
- `--error-logfile`: Error log file location
- `--timeout`: Worker timeout in seconds (default: 30)
- `--worker-class`: Worker class to use (default: sync)

## Architecture

### WSGI (Web Server Gateway Interface)

WSGI is a specification that describes how a web server communicates with web applications in Python. It provides a standard interface between web servers and Python web applications/frameworks.

In this project:

- `wsgi.py` serves as the WSGI entry point
- Gunicorn acts as the WSGI server
- Flask application is the WSGI application

### Using Nginx as Reverse Proxy

While Gunicorn is excellent for serving Python applications, it's recommended to use Nginx as a reverse proxy in production for:

- Better static file handling
- SSL/TLS termination
- Load balancing
- Request buffering
- Security features

To use Nginx with this application:

1. Build and run the Flask container:

```bash
docker run -p 8000:5000 --name flask_app portal
```

2. Run Nginx container:

```bash
docker run -p 80:80 --link flask_app:flask_app nginx
```

### SSL Installation:

https://github.com/jahangir842/linux-notes/blob/main/encryption-ssl-etc/Self-Signed-SSL-Certificate.md

## Docker Deployment

### Building the Docker Image

1. Standard build:

```bash
docker build -t portal:latest .
```

2. Build with different Python version:

```bash
docker build --build-arg PYTHON_VERSION=3.11-slim -t portal:py3.11 .
```

### Running Containers

1. Run just the Flask application:

```bash
# Run in foreground
docker run -p 5000:5000 portal:latest

# Run in background (detached)
docker run -d -p 5000:5000 portal:latest

# Run with custom name and restart policy
docker run -d --name portal --restart always -p 5000:5000 portal:latest
```

2. Run with Docker Compose (recommended for production):

```bash
# Start all services
docker-compose up -d

# Check logs
docker-compose logs -f

# Stop all services
docker-compose down
```

### Docker Management Commands

```bash
# List running containers
docker ps

# View container logs
docker logs portal

# Stop container
docker stop portal

# Remove container
docker rm portal

# List images
docker images | grep portal

# Remove image
docker rmi portal:latest
```

### Publishing Docker Image

1. Tag image for Docker Hub:

```bash
# Format: docker tag local-image:tag username/repository:tag
docker tag portal:latest username/portal:latest
docker tag portal:latest username/portal:v1.0.0  # version specific

# Push to Docker Hub
docker login
docker push username/portal:latest
docker push username/portal:v1.0.0
```

2. Push to private registry:

```bash
# Tag for private registry
docker tag portal:latest private-registry.example.com/portal:latest

# Login to private registry
docker login private-registry.example.com

# Push image
docker push private-registry.example.com/portal:latest
```

3. Using GitHub Container Registry:

```bash
# Tag for GitHub
docker tag portal:latest ghcr.io/username/portal:latest

# Login to GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Push to GitHub
docker push ghcr.io/username/portal:latest
```

4. Pull published image:

```bash
# From Docker Hub
docker pull username/portal:latest

# From private registry
docker pull private-registry.example.com/portal:latest

# From GitHub
docker pull ghcr.io/username/portal:latest
```

### Image Tagging Conventions

- `latest`: Most recent build
- `v1.0.0`: Specific version
- `stable`: Production-ready version
- `dev`: Development version

### Environment Variables

The application supports the following environment variables:

```bash
# Override using -e flag
docker run -e FLASK_ENV=production -e PORT=8000 -p 8000:8000 portal:latest
```

## Dependencies

- Flask 2.3.3
- Gunicorn 21.2.0
- Python-dateutil 2.8.2

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.

On branch feature.
