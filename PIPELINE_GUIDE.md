# CI/CD Pipeline Execution Guide

This guide provides step-by-step instructions for running the complete CI/CD pipeline.

## Table of Contents

1. [Prerequisites Verification](#prerequisites-verification)
2. [Jenkins Setup](#jenkins-setup)
3. [Running the Pipeline](#running-the-pipeline)
4. [Expected Output](#expected-output)
5. [Verification Steps](#verification-steps)
6. [Screenshots Guide](#screenshots-guide)

## Prerequisites Verification

Before running the pipeline, verify all prerequisites are met:

### 1. Check Docker Installation

```bash
docker --version
# Expected: Docker version 20.10.0 or higher

docker-compose --version
# Expected: Docker Compose version 2.0.0 or higher
```

### 2. Check Docker Service

```bash
docker ps
# Should list running containers without errors
```

### 3. Verify Ports are Available

```bash
# Check if ports 8080 (Jenkins) and 5000 (App) are free
netstat -an | grep 8080
netstat -an | grep 5000

# OR on Linux
lsof -i :8080
lsof -i :5000
```

## Jenkins Setup

### Method 1: Jenkins with Docker Socket (Recommended)

This method allows Jenkins to use the host's Docker daemon.

```bash
# Step 1: Create Jenkins network
docker network create jenkins

# Step 2: Run Jenkins container
docker run -d \
  --name jenkins \
  --network jenkins \
  --restart unless-stopped \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u root \
  jenkins/jenkins:lts

# Step 3: Wait for Jenkins to start (30-60 seconds)
sleep 60

# Step 4: Get initial admin password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### Method 2: Jenkins with Docker-in-Docker

This method runs Docker inside the Jenkins container.

```bash
# Step 1: Create network
docker network create jenkins

# Step 2: Start Docker-in-Docker container
docker run -d \
  --name jenkins-docker \
  --privileged \
  --network jenkins \
  --network-alias docker \
  -e DOCKER_TLS_CERTDIR=/certs \
  -v jenkins-docker-certs:/certs/client \
  -v jenkins-data:/var/jenkins_home \
  docker:dind \
  --storage-driver overlay2

# Step 3: Start Jenkins container
docker run -d \
  --name jenkins \
  --network jenkins \
  --restart unless-stopped \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins-data:/var/jenkins_home \
  -v jenkins-docker-certs:/certs/client:ro \
  -e DOCKER_HOST=tcp://docker:2376 \
  -e DOCKER_CERT_PATH=/certs/client \
  -e DOCKER_TLS_VERIFY=1 \
  jenkins/jenkins:lts

# Step 4: Wait and get password
sleep 60
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### Configure Jenkins Web Interface

1. Open browser: http://localhost:8080

2. Enter the initial admin password from previous step

3. Click "Install suggested plugins" and wait for completion

4. Create First Admin User:
   - Username: admin
   - Password: admin123 (or your choice)
   - Full name: Admin User
   - Email: admin@example.com

5. Click "Save and Continue"

6. Instance Configuration: Keep default (http://localhost:8080)

7. Click "Start using Jenkins"

### Install Required Jenkins Plugins

1. Go to: Manage Jenkins > Manage Plugins

2. Click "Available" tab

3. Search and select these plugins:
   - Docker Pipeline
   - Docker
   - Pipeline
   - Git
   - Workspace Cleanup

4. Click "Install without restart"

5. Wait for installation to complete

6. Restart Jenkins:
```bash
docker restart jenkins
```

### Install Docker and Python in Jenkins Container

```bash
# Enter Jenkins container
docker exec -it -u root jenkins bash

# Update package list
apt-get update

# Install Docker CLI
apt-get install -y docker.io

# Install Docker Compose
apt-get install -y docker-compose

# Install Python and pip
apt-get install -y python3 python3-pip curl

# Add jenkins user to docker group (if using docker socket)
usermod -aG docker jenkins

# Verify installations
docker --version
docker-compose --version
python3 --version
pip3 --version

# Exit container
exit

# Restart Jenkins
docker restart jenkins

# Wait for Jenkins to be ready
sleep 30
```

## Running the Pipeline

### Step 1: Prepare the Repository

```bash
# Clone or navigate to your repository
cd /home/user/api_av_pre_scen_2

# Verify all required files exist
ls -la
# Should see: Jenkinsfile, Dockerfile, docker-compose.yml, healthcheck.sh, app/

# Make scripts executable
chmod +x healthcheck.sh
```

### Step 2: Create Jenkins Pipeline Job

1. Open Jenkins: http://localhost:8080

2. Click "New Item"

3. Enter item name: `demo-app-cicd-pipeline`

4. Select "Pipeline"

5. Click "OK"

6. In the configuration page:

   **General Section:**
   - Description: "CI/CD Pipeline for Demo Flask Application"

   **Pipeline Section:**
   - Definition: Select "Pipeline script from SCM"
   - SCM: Select "Git"
   - Repository URL: `/home/user/api_av_pre_scen_2` (or your git remote URL)
   - Credentials: None (for local path) or add your Git credentials
   - Branch Specifier: `*/claude/cicd-pipeline-docker-jenkins-011CV68m7DnvecP32SUa3tSb` or `*/main`
   - Script Path: `Jenkinsfile`

   **OR use Pipeline script:**
   - Definition: Select "Pipeline script"
   - Copy the entire content of Jenkinsfile and paste into the Script box

7. Click "Save"

### Step 3: Execute the Pipeline

1. On the pipeline page, click "Build Now"

2. Watch the build progress in the Build History

3. Click on the build number (e.g., #1)

4. Click "Console Output" to see detailed logs

### Step 4: Monitor Pipeline Execution

The pipeline will execute these stages sequentially:

1. **Checkout** (10-15 seconds)
   - Retrieves code from repository
   - Lists directory contents

2. **Build** (30-60 seconds)
   - Installs Python dependencies
   - Prepares application environment

3. **Test** (15-30 seconds)
   - Runs pytest unit tests
   - All tests must pass

4. **Package** (60-120 seconds)
   - Builds Docker image
   - Tags image with version

5. **Deploy** (20-40 seconds)
   - Stops existing containers
   - Starts new container with docker-compose
   - Waits for startup

6. **Health Check** (10-20 seconds)
   - Runs healthcheck.sh
   - Verifies container health
   - Tests endpoints

7. **Display Status** (5-10 seconds)
   - Shows deployment summary
   - Tests all endpoints
   - Displays JSON responses

## Expected Output

### Console Output Structure

```
Started by user Admin
Running in Durability level: MAX_SURVIVABILITY
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins in /var/jenkins_home/workspace/demo-app-cicd-pipeline
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Checkout)
[Pipeline] echo
Checking out source code...
...

[Pipeline] stage
[Pipeline] { (Build)
[Pipeline] echo
Installing dependencies...
Successfully installed Flask-3.0.0 pytest-7.4.3 ...
Build completed successfully
...

[Pipeline] stage
[Pipeline] { (Test)
[Pipeline] echo
Running unit tests...
test_app.py::test_home_endpoint PASSED
test_app.py::test_health_endpoint PASSED
test_app.py::test_info_endpoint PASSED
test_app.py::test_health_endpoint_structure PASSED
test_app.py::test_invalid_endpoint PASSED
===== 5 passed in 0.45s =====
All tests passed successfully
...

[Pipeline] stage
[Pipeline] { (Package)
[Pipeline] echo
Building Docker image...
Step 1/10 : FROM python:3.11-slim
Step 2/10 : WORKDIR /app
...
Successfully built abc123def456
Successfully tagged demo-app:1.0.0
Successfully tagged demo-app:latest
...

[Pipeline] stage
[Pipeline] { (Deploy)
[Pipeline] echo
Deploying application using Docker Compose...
Creating network "api_av_pre_scen_2_app-network" with driver "bridge"
Creating demo-app-container ... done
Waiting for application to start...
Name                 State    Ports
demo-app-container   Up       0.0.0.0:5000->5000/tcp
...

[Pipeline] stage
[Pipeline] { (Health Check)
[Pipeline] echo
Verifying application health...
=========================================
Starting Health Check
=========================================
1. Checking if container is running...
   [OK] Container is running
2. Checking container health status...
   Container health status: healthy
3. Testing application endpoints...
   [OK] Health endpoint is responding
4. Fetching health status...
   Response: {"status": "healthy", "uptime_seconds": 12, ...}
   [OK] Application reports healthy status
   [OK] Home endpoint is responding
=========================================
Health Check PASSED
=========================================
...

[Pipeline] stage
[Pipeline] { (Display Status)
================================
APPLICATION DEPLOYMENT SUMMARY
================================

Application: demo-app
Version: 1.0.0
Status: RUNNING

Container Status:
Name                 State    Ports
demo-app-container   Up       0.0.0.0:5000->5000/tcp

Application URL: http://localhost:5000
Health Check URL: http://localhost:5000/health

Testing endpoints:
{
    "message": "Hello World! Welcome to the CI/CD Demo Application",
    "status": "running",
    "version": "1.0.0"
}

{
    "service": "demo-app",
    "status": "healthy",
    "uptime_seconds": 15,
    "version": "1.0.0"
}

================================
DEPLOYMENT SUCCESSFUL!
================================

[Pipeline] echo
Pipeline completed successfully!
Application is deployed and healthy.

[Pipeline] End of Pipeline
Finished: SUCCESS
```

## Verification Steps

### 1. Verify Pipeline Status

In Jenkins:
- Pipeline should show green checkmark
- Status: "Success"
- All stages should be green

### 2. Verify Container is Running

```bash
docker ps | grep demo-app
# Should show container running on port 5000

docker-compose ps
# Should show "Up" status
```

### 3. Verify Application Endpoints

```bash
# Test home endpoint
curl http://localhost:5000/
# Expected: JSON with "Hello World" message

# Test health endpoint
curl http://localhost:5000/health
# Expected: JSON with "status": "healthy"

# Test info endpoint
curl http://localhost:5000/api/info
# Expected: JSON with application information
```

### 4. Run Health Check Manually

```bash
./healthcheck.sh
# Should output: Health Check PASSED
```

### 5. View Container Logs

```bash
docker-compose logs demo-app
# Should show Flask startup messages
```

### 6. Check Docker Images

```bash
docker images | grep demo-app
# Should show demo-app:1.0.0 and demo-app:latest
```

## Screenshots Guide

Capture these screenshots for documentation:

### Screenshot 1: Jenkins Dashboard
- URL: http://localhost:8080
- Show: Pipeline job listed with green status

### Screenshot 2: Pipeline Stage View
- Click on pipeline job
- Show: Stage View with all stages (Checkout, Build, Test, Package, Deploy, Health Check, Display Status)
- All stages should be green

### Screenshot 3: Console Output - Beginning
- Show first 50 lines including:
  - "Started by user"
  - Checkout stage output
  - Build stage starting

### Screenshot 4: Console Output - Test Stage
- Show test execution:
  - "Running unit tests..."
  - All 5 tests PASSED
  - "All tests passed successfully"

### Screenshot 5: Console Output - Package Stage
- Show Docker build:
  - "Building Docker image..."
  - Docker build steps
  - "Successfully built"
  - Image tags

### Screenshot 6: Console Output - Deploy Stage
- Show deployment:
  - "Deploying application..."
  - Container creation
  - Container status

### Screenshot 7: Console Output - Health Check
- Show health verification:
  - "Health Check" output
  - All checks passing
  - "Health Check PASSED"

### Screenshot 8: Console Output - Final Status
- Show:
  - "APPLICATION DEPLOYMENT SUMMARY"
  - Container status
  - Endpoint test results
  - "DEPLOYMENT SUCCESSFUL!"
  - "Finished: SUCCESS"

### Screenshot 9: Application in Browser
- URL: http://localhost:5000
- Show: JSON response with welcome message

### Screenshot 10: Health Endpoint
- URL: http://localhost:5000/health
- Show: JSON response with healthy status

### Screenshot 11: Docker Containers
- Terminal command: `docker ps`
- Show: demo-app-container running

### Screenshot 12: Manual Health Check
- Terminal command: `./healthcheck.sh`
- Show: Complete health check output with PASSED status

## Troubleshooting

### Pipeline Fails at Build Stage

**Error:** `pip: command not found`

**Solution:**
```bash
docker exec -it -u root jenkins apt-get update && apt-get install -y python3-pip
docker restart jenkins
```

### Pipeline Fails at Package Stage

**Error:** `docker: command not found`

**Solution:**
```bash
docker exec -it -u root jenkins apt-get update && apt-get install -y docker.io
docker restart jenkins
```

### Pipeline Fails at Deploy Stage

**Error:** `docker-compose: command not found`

**Solution:**
```bash
docker exec -it -u root jenkins apt-get update && apt-get install -y docker-compose
docker restart jenkins
```

### Health Check Fails

**Error:** `curl: (7) Failed to connect to localhost port 5000`

**Cause:** Container might not be accessible from Jenkins container

**Solution:**
```bash
# Use host network mode or
# Change healthcheck to use container name
# Edit healthcheck.sh to use: http://demo-app-container:5000/health
```

### Permission Denied on Docker Socket

**Error:** `permission denied while trying to connect to the Docker daemon socket`

**Solution:**
```bash
docker exec -it -u root jenkins usermod -aG docker jenkins
docker restart jenkins
```

## Cleanup After Testing

```bash
# Stop and remove application
docker-compose down

# Remove Docker images
docker rmi demo-app:latest demo-app:1.0.0

# Stop and remove Jenkins
docker stop jenkins
docker rm jenkins

# Remove Jenkins volume (optional)
docker volume rm jenkins_home

# Remove network
docker network rm jenkins
```

## Next Steps

After successful pipeline execution:

1. Modify application code in `app/app.py`
2. Run pipeline again to see changes deployed
3. Add more tests in `test_app.py`
4. Extend pipeline with additional stages
5. Configure webhooks for automatic builds
6. Set up email notifications for build status

## Performance Expectations

- Total pipeline execution time: 3-5 minutes
- Build stage: 30-60 seconds
- Test stage: 15-30 seconds
- Package stage: 60-120 seconds (first run), 10-30 seconds (subsequent runs with caching)
- Deploy stage: 20-40 seconds
- Health check: 10-20 seconds

## Success Criteria

Pipeline is successful when:
- All stages show green status
- Console output shows "Finished: SUCCESS"
- Container is running: `docker ps | grep demo-app`
- Health endpoint returns 200: `curl http://localhost:5000/health`
- Manual health check passes: `./healthcheck.sh`
- Application is accessible in browser

Congratulations! You have successfully set up and executed a complete CI/CD pipeline.
