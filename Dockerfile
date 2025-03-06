# Use Python 3.10 slim image as base to keep image size small
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

# Copy requirements file first to leverage Docker cache
COPY requirements.txt .
# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code and templates
# Note: This is done after installing dependencies to leverage cache
COPY app.py .
COPY templates ./templates
COPY static ./static

# Expose port 5000 for the Flask application
EXPOSE 5000

# Command to run the application
# Using array syntax for better signal handling
CMD ["python", "app.py"]
