from flask import Flask, jsonify
import os
import time

app = Flask(__name__)

# Application metadata
APP_VERSION = os.getenv('APP_VERSION', '1.0.0')
START_TIME = time.time()

@app.route('/')
def home():
    """Home endpoint"""
    return jsonify({
        'message': 'Hello World! Welcome to the CI/CD Demo Application',
        'version': APP_VERSION,
        'status': 'running'
    })

@app.route('/health')
def health():
    """Health check endpoint"""
    uptime = int(time.time() - START_TIME)
    return jsonify({
        'status': 'healthy',
        'uptime_seconds': uptime,
        'version': APP_VERSION,
        'service': 'demo-app'
    }), 200

@app.route('/api/info')
def info():
    """Application information endpoint"""
    return jsonify({
        'name': 'CI/CD Demo Application',
        'version': APP_VERSION,
        'description': 'A simple Flask application demonstrating CI/CD pipeline',
        'endpoints': {
            '/': 'Home page',
            '/health': 'Health check',
            '/api/info': 'Application information'
        }
    })

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
