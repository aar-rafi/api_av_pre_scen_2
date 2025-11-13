import pytest
from app import app as flask_app

@pytest.fixture
def app():
    """Create application fixture"""
    flask_app.config['TESTING'] = True
    return flask_app

@pytest.fixture
def client(app):
    """Create test client"""
    return app.test_client()

def test_home_endpoint(client):
    """Test home endpoint returns 200 and correct message"""
    response = client.get('/')
    assert response.status_code == 200
    data = response.get_json()
    assert 'message' in data
    assert 'Hello World' in data['message']
    assert data['status'] == 'running'

def test_health_endpoint(client):
    """Test health endpoint returns healthy status"""
    response = client.get('/health')
    assert response.status_code == 200
    data = response.get_json()
    assert data['status'] == 'healthy'
    assert 'uptime_seconds' in data
    assert 'version' in data
    assert data['service'] == 'demo-app'

def test_info_endpoint(client):
    """Test info endpoint returns application information"""
    response = client.get('/api/info')
    assert response.status_code == 200
    data = response.get_json()
    assert 'name' in data
    assert 'version' in data
    assert 'endpoints' in data
    assert '/' in data['endpoints']
    assert '/health' in data['endpoints']

def test_health_endpoint_structure(client):
    """Test health endpoint returns all required fields"""
    response = client.get('/health')
    data = response.get_json()
    required_fields = ['status', 'uptime_seconds', 'version', 'service']
    for field in required_fields:
        assert field in data, f"Missing required field: {field}"

def test_invalid_endpoint(client):
    """Test that invalid endpoint returns 404"""
    response = client.get('/invalid-endpoint')
    assert response.status_code == 404
