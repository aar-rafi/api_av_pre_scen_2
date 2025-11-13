# CI/CD Pipeline Demo with Docker and Jenkins

A complete CI/CD pipeline demonstration featuring a Flask web application with automated build, test, package, deploy, and health check stages using Jenkins, Docker, and Docker Compose.

## Project Structure

```
.
├── app/
│   ├── app.py              # Flask application with health endpoint
│   ├── test_app.py         # Unit tests
│   └── requirements.txt    # Python dependencies
├── Dockerfile              # Container image definition
├── docker-compose.yml      # Container orchestration
├── Jenkinsfile             # Declarative CI/CD pipeline
├── healthcheck.sh          # Health verification script
└── README.md               # This file
```

## Application Features

The demo application is a Flask web server with the following endpoints:

- `GET /` - Home page with welcome message
- `GET /health` - Health check endpoint (returns status, uptime, version)
- `GET /api/info` - Application information

## Prerequisites

### Required Software

1. **Docker** (version 20.10 or higher)
   - Install from: https://docs.docker.com/get-docker/

2. **Docker Compose** (version 2.0 or higher)
   - Usually included with Docker Desktop
   - Linux users: https://docs.docker.com/compose/install/

3. **Jenkins** (for running the pipeline)
   - Option A: Local installation
   - Option B: Docker-based Jenkins (recommended)

4. **Python 3.11+** (for local testing)

5. **Git** (for version control)

### System Requirements

- 4GB RAM minimum
- 10GB free disk space
- Linux, macOS, or Windows with WSL2

## Quick Start

### Option 1: Manual Deployment (Without Jenkins)

1. Clone the repository:
```bash
git clone <repository-url>
cd api_av_pre_scen_2
```

2. Build and deploy using Docker Compose:
```bash
docker-compose up --build -d
```

3. Verify the application is running:
```bash
./healthcheck.sh
```

4. Access the application:
```bash
curl http://localhost:5000
curl http://localhost:5000/health
```

5. View in browser:
   - http://localhost:5000
   - http://localhost:5000/health

6. Stop the application:
```bash
docker-compose down
```

### Option 2: Run Jenkins Pipeline (Full CI/CD)

This is the recommended approach for experiencing the complete CI/CD pipeline.

#### Step 1: Set Up Jenkins in Docker

Create a Docker network and run Jenkins with Docker-in-Docker support:

```bash
# Create a Docker network
docker network create jenkins

# Run Jenkins container with Docker support
docker run -d \
  --name jenkins \
  --network jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

For Docker-in-Docker (DinD) approach:

```bash
# Start Docker-in-Docker container
docker run -d \
  --name jenkins-docker \
  --privileged \
  --network jenkins \
  --network-alias docker \
  -e DOCKER_TLS_CERTDIR=/certs \
  -v jenkins-docker-certs:/certs/client \
  -v jenkins-data:/var/jenkins_home \
  docker:dind

# Start Jenkins container
docker run -d \
  --name jenkins \
  --network jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins-data:/var/jenkins_home \
  -v jenkins-docker-certs:/certs/client:ro \
  -e DOCKER_HOST=tcp://docker:2376 \
  -e DOCKER_CERT_PATH=/certs/client \
  -e DOCKER_TLS_VERIFY=1 \
  jenkins/jenkins:lts
```

#### Step 2: Initial Jenkins Setup

1. Get the initial admin password:
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

2. Open Jenkins in your browser:
   - URL: http://localhost:8080

3. Enter the initial admin password

4. Install suggested plugins

5. Create your first admin user

#### Step 3: Install Required Jenkins Plugins

Navigate to: Manage Jenkins > Manage Plugins > Available

Install these plugins:
- Docker Pipeline
- Docker
- Pipeline
- Git
- Workspace Cleanup

Restart Jenkins after installation:
```bash
docker restart jenkins
```

#### Step 4: Install Docker CLI in Jenkins Container

```bash
# Enter the Jenkins container
docker exec -it -u root jenkins bash

# Install Docker CLI
apt-get update && apt-get install -y docker.io

# Add jenkins user to docker group (if using docker.sock)
usermod -aG docker jenkins

# Exit the container
exit

# Restart Jenkins
docker restart jenkins
```

#### Step 5: Create Jenkins Pipeline Job

1. Click "New Item"
2. Enter job name: "demo-app-pipeline"
3. Select "Pipeline" and click OK
4. Under "Pipeline" section:
   - Definition: "Pipeline script from SCM"
   - SCM: Git
   - Repository URL: (your repository URL or local path)
   - Branch: */main (or your branch name)
   - Script Path: Jenkinsfile
5. Click "Save"

#### Step 6: Run the Pipeline

1. Click "Build Now"
2. Watch the pipeline execute through stages:
   - Checkout
   - Build
   - Test
   - Package
   - Deploy
   - Health Check
   - Display Status

3. View console output for detailed logs

4. After successful completion, access the application at http://localhost:5000

## Pipeline Stages Explained

### 1. Checkout
- Retrieves source code from version control
- Verifies repository structure

### 2. Build
- Installs Python dependencies
- Prepares application environment
- Validates requirements

### 3. Test
- Runs pytest unit tests
- Verifies application functionality
- Ensures code quality
- All tests must pass to proceed

### 4. Package
- Builds Docker image from Dockerfile
- Tags image with version and latest
- Validates image creation

### 5. Deploy
- Stops any existing containers
- Starts application using docker-compose
- Waits for application initialization
- Verifies container status

### 6. Health Check
- Executes healthcheck.sh script
- Validates container is running
- Tests /health endpoint
- Ensures application is responding
- Verifies healthy status

### 7. Display Status
- Shows deployment summary
- Displays container status
- Tests all endpoints
- Provides access URLs

## Running Tests Locally

### Unit Tests

```bash
cd app
pip install -r requirements.txt
python -m pytest test_app.py -v
```

### Manual Testing

```bash
# Start the application
python app/app.py

# In another terminal, test endpoints
curl http://localhost:5000/
curl http://localhost:5000/health
curl http://localhost:5000/api/info
```

## Docker Commands

### Build Image
```bash
docker build -t demo-app:1.0.0 .
```

### Run Container
```bash
docker run -d -p 5000:5000 --name demo-app demo-app:1.0.0
```

### View Logs
```bash
docker logs demo-app-container
docker-compose logs -f
```

### Stop Container
```bash
docker stop demo-app-container
docker-compose down
```

### Remove Image
```bash
docker rmi demo-app:1.0.0
```

### Inspect Container
```bash
docker inspect demo-app-container
docker-compose ps
```

## Health Check Script

The `healthcheck.sh` script performs comprehensive health verification:

1. Verifies container is running
2. Checks container health status
3. Tests health endpoint with retries
4. Validates healthy response
5. Tests home endpoint
6. Reports overall status

Run manually:
```bash
./healthcheck.sh
```

## Troubleshooting

### Issue: Container fails to start

**Solution:**
```bash
# Check logs
docker-compose logs

# Check if port 5000 is already in use
lsof -i :5000
netstat -an | grep 5000

# Kill process using the port
kill -9 <PID>
```

### Issue: Health check fails

**Solution:**
```bash
# Check container status
docker-compose ps

# View application logs
docker-compose logs demo-app

# Check if application is responding
curl -v http://localhost:5000/health

# Restart the container
docker-compose restart
```

### Issue: Jenkins cannot connect to Docker

**Solution:**
```bash
# Verify Docker socket is mounted
docker inspect jenkins | grep docker.sock

# Check Docker is running in Jenkins container
docker exec jenkins docker ps

# Verify jenkins user has docker permissions
docker exec jenkins groups jenkins
```

### Issue: Tests fail in Jenkins

**Solution:**
```bash
# Run tests locally first
cd app
python -m pytest test_app.py -v

# Check Python version in Jenkins
docker exec jenkins python3 --version

# Install pip if missing
docker exec -u root jenkins apt-get install -y python3-pip
```

### Issue: Permission denied on healthcheck.sh

**Solution:**
```bash
chmod +x healthcheck.sh
```

## Project Configuration

### Environment Variables

The application uses these environment variables:

- `APP_VERSION`: Application version (default: 1.0.0)
- `PORT`: Application port (default: 5000)

Set in docker-compose.yml or pass during docker run:
```bash
docker run -e APP_VERSION=2.0.0 -e PORT=8000 -p 8000:8000 demo-app:latest
```

### Customization

#### Change Application Port

Edit `docker-compose.yml`:
```yaml
ports:
  - "8000:8000"  # Change from 5000:5000
environment:
  - PORT=8000
```

#### Modify Health Check Interval

Edit `Dockerfile`:
```dockerfile
HEALTHCHECK --interval=60s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:5000/health')" || exit 1
```

## CI/CD Pipeline Flow Diagram

```
[Checkout] --> [Build] --> [Test] --> [Package] --> [Deploy] --> [Health Check] --> [Display Status]
     |            |          |           |            |               |                  |
     v            v          v           v            v               v                  v
  Get Code   Install    Run Tests   Build Image  Start App    Verify Health      Show Results
               Deps
```

## Security Considerations

1. **Non-root User**: Container runs as non-root user (appuser)
2. **No Cached Credentials**: pip uses --no-cache-dir
3. **Health Checks**: Automated container health monitoring
4. **Environment Variables**: Sensitive data should use secrets
5. **Network Isolation**: Uses Docker bridge network

## Performance Optimization

1. **Layer Caching**: Requirements copied before code for better caching
2. **Slim Base Image**: Uses python:3.11-slim instead of full image
3. **No Write Bytecode**: PYTHONDONTWRITEBYTECODE=1 reduces disk I/O
4. **Unbuffered Output**: PYTHONUNBUFFERED=1 for real-time logs

## Extending the Pipeline

### Add Code Quality Stage

Add to Jenkinsfile:
```groovy
stage('Code Quality') {
    steps {
        sh '''
            pip install pylint flake8
            pylint app/app.py || true
            flake8 app/app.py || true
        '''
    }
}
```

### Add Security Scanning

```groovy
stage('Security Scan') {
    steps {
        sh '''
            pip install bandit safety
            bandit -r app/ || true
            safety check || true
        '''
    }
}
```

### Add Integration Tests

```groovy
stage('Integration Tests') {
    steps {
        sh '''
            sleep 5
            curl -f http://localhost:5000/health
            # Add more integration tests
        '''
    }
}
```

## Monitoring and Logging

### View Real-time Logs
```bash
docker-compose logs -f demo-app
```

### Export Logs
```bash
docker-compose logs > application.log
```

### Container Stats
```bash
docker stats demo-app-container
```

## Cleanup

### Remove Everything
```bash
# Stop and remove containers
docker-compose down

# Remove images
docker rmi demo-app:latest demo-app:1.0.0

# Remove Jenkins containers
docker stop jenkins jenkins-docker
docker rm jenkins jenkins-docker

# Remove volumes
docker volume rm jenkins_home jenkins-data jenkins-docker-certs

# Remove network
docker network rm jenkins
```

## Additional Resources

- Flask Documentation: https://flask.palletsprojects.com/
- Docker Documentation: https://docs.docker.com/
- Jenkins Documentation: https://www.jenkins.io/doc/
- Docker Compose: https://docs.docker.com/compose/
- pytest Documentation: https://docs.pytest.org/

## License

This is a demonstration project for educational purposes.

## Support

For issues or questions, please refer to the documentation or check:
- Docker logs: `docker-compose logs`
- Jenkins console output
- Application logs in Jenkins workspace
