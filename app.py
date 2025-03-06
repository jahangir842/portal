from flask import Flask, render_template
from datetime import datetime

app = Flask(__name__)

# Sample portal data
links = [
    {"name": "GitHub", "url": "https://github.com", "icon": "github", "type": "fa"},
    {"name": "Gmail", "url": "https://gmail.com", "icon": "envelope", "type": "fa"},
    {"name": "Azure Portal", "url": "https://portal.azure.com", "icon": "cloud", "type": "fa"},
    {"name": "Docker Hub", "url": "https://hub.docker.com", "icon": "docker", "type": "fa"},
    {"name": "Beach", "url": "https://example.com", "icon": "beach-ball.png", "type": "image"}
]

@app.route('/')
def home():
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return render_template('index.html', 
                         links=links, 
                         current_time=current_time)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
