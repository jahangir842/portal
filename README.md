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

### Using Docker

1. Build the Docker image:
   ```bash
   docker build -t portal .
   ```

2. Run the container:
   ```bash
   docker run -p 5000:5000 portal
   ```

3. Access the application at http://localhost:5000

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