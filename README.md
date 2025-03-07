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

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Run the development server:
   ```bash
   python app.py
   ```

## Production Deployment

The application uses Gunicorn as the WSGI server with the following configuration:
- 4 worker processes
- Binds to all interfaces on port 5000
- WSGI entry point: wsgi.py

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