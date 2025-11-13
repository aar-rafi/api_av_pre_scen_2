# Jenkins Pipeline Console Output Example

This document shows the expected console output when running the CI/CD pipeline successfully.

## Full Console Output

```
Started by user Admin User
Obtained Jenkinsfile from git /home/user/api_av_pre_scen_2
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins in /var/jenkins_home/workspace/demo-app-cicd-pipeline
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
No credentials specified
Cloning the remote Git repository
Cloning repository /home/user/api_av_pre_scen_2
 > git init /var/jenkins_home/workspace/demo-app-cicd-pipeline
Fetching upstream changes from /home/user/api_av_pre_scen_2
 > git --version
 > git fetch --tags --force --progress -- /home/user/api_av_pre_scen_2 +refs/heads/*:refs/remotes/origin/*
 > git config remote.origin.url /home/user/api_av_pre_scen_2
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
 > git config remote.origin.url /home/user/api_av_pre_scen_2
Fetching upstream changes from /home/user/api_av_pre_scen_2
 > git fetch --tags --force --progress -- /home/user/api_av_pre_scen_2 +refs/heads/*:refs/remotes/origin/*
Checking out Revision abc123def456ghi789 (refs/remotes/origin/main)
 > git config core.sparsecheckout
 > git checkout -f abc123def456ghi789
Commit message: "Initial CI/CD pipeline setup"
[Pipeline] }
[Pipeline] // stage
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Checkout)
[Pipeline] echo
Checking out source code...
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
No credentials specified
[Pipeline] sh
+ ls -la
total 52
drwxr-xr-x 4 jenkins jenkins 4096 Nov 13 15:41 .
drwxr-xr-x 3 jenkins jenkins 4096 Nov 13 15:41 ..
drwxr-xr-x 8 jenkins jenkins 4096 Nov 13 15:41 .git
-rw-r--r-- 1 jenkins jenkins  234 Nov 13 15:41 .gitignore
-rw-r--r-- 1 jenkins jenkins  987 Nov 13 15:41 Dockerfile
-rw-r--r-- 1 jenkins jenkins 3521 Nov 13 15:41 Jenkinsfile
-rw-r--r-- 1 jenkins jenkins 8765 Nov 13 15:41 PIPELINE_GUIDE.md
-rw-r--r-- 1 jenkins jenkins 15432 Nov 13 15:41 README.md
drwxr-xr-x 2 jenkins jenkins 4096 Nov 13 15:41 app
-rw-r--r-- 1 jenkins jenkins  456 Nov 13 15:41 docker-compose.yml
-rwxr-xr-x 1 jenkins jenkins 1987 Nov 13 15:41 healthcheck.sh
-rwxr-xr-x 1 jenkins jenkins 1654 Nov 13 15:41 quick-start.sh
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Build)
[Pipeline] echo
Installing dependencies...
[Pipeline] sh
+ cd app
+ pip install -r requirements.txt
Collecting Flask==3.0.0
  Downloading Flask-3.0.0-py3-none-any.whl (99 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 99.7/99.7 kB 2.3 MB/s eta 0:00:00
Collecting pytest==7.4.3
  Downloading pytest-7.4.3-py3-none-any.whl (325 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 325.1/325.1 kB 5.2 MB/s eta 0:00:00
Collecting pytest-flask==1.3.0
  Downloading pytest_flask-1.3.0-py3-none-any.whl (11 kB)
Collecting requests==2.31.0
  Downloading requests-2.31.0-py3-none-any.whl (62 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 62.6/62.6 kB 4.8 MB/s eta 0:00:00
Collecting Werkzeug>=3.0.0
  Downloading werkzeug-3.0.1-py3-none-any.whl (226 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 226.7/226.7 kB 6.1 MB/s eta 0:00:00
Collecting Jinja2>=3.1.2
  Downloading jinja2-3.1.2-py3-none-any.whl (133 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 133.1/133.1 kB 5.4 MB/s eta 0:00:00
Collecting click>=8.1.3
  Downloading click-8.1.7-py3-none-any.whl (97 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 97.9/97.9 kB 4.2 MB/s eta 0:00:00
Collecting itsdangerous>=2.1.2
  Downloading itsdangerous-2.1.2-py3-none-any.whl (15 kB)
Collecting blinker>=1.6.2
  Downloading blinker-1.7.0-py3-none-any.whl (13 kB)
Collecting pluggy<2.0,>=0.12
  Downloading pluggy-1.3.0-py3-none-any.whl (18 kB)
Collecting iniconfig
  Downloading iniconfig-2.0.0-py3-none-any.whl (5.9 kB)
Collecting packaging
  Downloading packaging-23.2-py3-none-any.whl (53 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 53.0/53.0 kB 3.1 MB/s eta 0:00:00
Collecting charset-normalizer<4,>=2
  Downloading charset_normalizer-3.3.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (140 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 140.3/140.3 kB 5.8 MB/s eta 0:00:00
Collecting idna<4,>=2.5
  Downloading idna-3.6-py3-none-any.whl (61 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.6/61.6 kB 3.7 MB/s eta 0:00:00
Collecting urllib3<3,>=1.21.1
  Downloading urllib3-2.1.0-py3-none-any.whl (104 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 104.6/104.6 kB 4.9 MB/s eta 0:00:00
Collecting certifi>=2017.4.17
  Downloading certifi-2023.11.17-py3-none-any.whl (162 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 162.5/162.5 kB 6.2 MB/s eta 0:00:00
Collecting MarkupSafe>=2.0
  Downloading MarkupSafe-2.1.3-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (28 kB)
Installing collected packages: urllib3, pluggy, packaging, MarkupSafe, itsdangerous, iniconfig, idna, click, charset-normalizer, certifi, blinker, Werkzeug, requests, Jinja2, pytest, Flask, pytest-flask
Successfully installed Flask-3.0.0 Jinja2-3.1.2 MarkupSafe-2.1.3 Werkzeug-3.0.1 blinker-1.7.0 certifi-2023.11.17 charset-normalizer-3.3.2 click-8.1.7 idna-3.6 iniconfig-2.0.0 itsdangerous-2.1.2 packaging-23.2 pluggy-1.3.0 pytest-7.4.3 pytest-flask-1.3.0 requests-2.31.0 urllib3-2.1.0
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
+ echo Build completed successfully
Build completed successfully
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Test)
[Pipeline] echo
Running unit tests...
[Pipeline] sh
+ cd app
+ python -m pytest test_app.py -v --tb=short
============================= test session starts ==============================
platform linux -- Python 3.11.14, pytest-7.4.3, pluggy-1.6.0 -- /usr/bin/python
cachedir: .pytest_cache
rootdir: /var/jenkins_home/workspace/demo-app-cicd-pipeline/app
plugins: flask-1.3.0
collecting ... collected 5 items

test_app.py::test_home_endpoint PASSED                                   [ 20%]
test_app.py::test_health_endpoint PASSED                                 [ 40%]
test_app.py::test_info_endpoint PASSED                                   [ 60%]
test_app.py::test_health_endpoint_structure PASSED                       [ 80%]
test_app.py::test_invalid_endpoint PASSED                                [100%]

============================== 5 passed in 0.45s ===============================
+ echo All tests passed successfully
All tests passed successfully
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Package)
[Pipeline] echo
Building Docker image...
[Pipeline] sh
+ docker build -t demo-app:1.0.0 .
Sending build context to Docker daemon  256kB
Step 1/10 : FROM python:3.11-slim
3.11-slim: Pulling from library/python
01b5b2efb836: Pulling fs layer
317c5d89c2f5: Pulling fs layer
b5c2c8a87cf0: Pulling fs layer
e2f313ba1135: Pulling fs layer
9a8a1e66a3d2: Pulling fs layer
e2f313ba1135: Waiting
9a8a1e66a3d2: Waiting
01b5b2efb836: Download complete
01b5b2efb836: Pull complete
317c5d89c2f5: Pull complete
b5c2c8a87cf0: Pull complete
e2f313ba1135: Pull complete
9a8a1e66a3d2: Pull complete
Digest: sha256:abc123def456ghi789...
Status: Downloaded newer image for python:3.11-slim
 ---> 123456789abc
Step 2/10 : WORKDIR /app
 ---> Running in def456789ghi
Removing intermediate container def456789ghi
 ---> 456789abcdef
Step 3/10 : ENV PYTHONDONTWRITEBYTECODE=1     PYTHONUNBUFFERED=1     PORT=5000     APP_VERSION=1.0.0
 ---> Running in 789abcdefghi
Removing intermediate container 789abcdefghi
 ---> 789abcdefghi
Step 4/10 : COPY app/requirements.txt .
 ---> 9abcdef12345
Step 5/10 : RUN pip install --no-cache-dir -r requirements.txt
 ---> Running in abcdef123456
Collecting Flask==3.0.0
  Downloading Flask-3.0.0-py3-none-any.whl (99 kB)
Collecting pytest==7.4.3
  Downloading pytest-7.4.3-py3-none-any.whl (325 kB)
Collecting pytest-flask==1.3.0
  Downloading pytest_flask-1.3.0-py3-none-any.whl (11 kB)
Collecting requests==2.31.0
  Downloading requests-2.31.0-py3-none-any.whl (62 kB)
[... dependency installation output ...]
Successfully installed Flask-3.0.0 Jinja2-3.1.2 MarkupSafe-2.1.3 Werkzeug-3.0.1 blinker-1.7.0 certifi-2023.11.17 charset-normalizer-3.3.2 click-8.1.7 idna-3.6 iniconfig-2.0.0 itsdangerous-2.1.2 packaging-23.2 pluggy-1.3.0 pytest-7.4.3 pytest-flask-1.3.0 requests-2.31.0 urllib3-2.1.0
Removing intermediate container abcdef123456
 ---> bcdef1234567
Step 6/10 : COPY app/ .
 ---> cdef12345678
Step 7/10 : RUN useradd -m -u 1000 appuser &&     chown -R appuser:appuser /app
 ---> Running in def123456789
Removing intermediate container def123456789
 ---> ef1234567890
Step 8/10 : USER appuser
 ---> Running in f12345678901
Removing intermediate container f12345678901
 ---> 1234567890ab
Step 9/10 : EXPOSE 5000
 ---> Running in 234567890abc
Removing intermediate container 234567890abc
 ---> 34567890abcd
Step 10/10 : CMD ["python", "app.py"]
 ---> Running in 4567890abcde
Removing intermediate container 4567890abcde
 ---> 567890abcdef
Successfully built 567890abcdef
Successfully tagged demo-app:1.0.0
+ docker tag demo-app:1.0.0 demo-app:latest
+ echo Docker image built: demo-app:1.0.0
Docker image built: demo-app:1.0.0
+ docker images
+ grep demo-app
demo-app        1.0.0    567890abcdef   10 seconds ago   158MB
demo-app        latest   567890abcdef   10 seconds ago   158MB
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Deploy)
[Pipeline] echo
Deploying application using Docker Compose...
[Pipeline] sh
+ docker-compose down
Stopping demo-app-container ... done
Removing demo-app-container ... done
Removing network api_av_pre_scen_2_app-network
+ docker-compose up -d
Creating network "api_av_pre_scen_2_app-network" with driver "bridge"
Creating demo-app-container ... done
+ echo Waiting for application to start...
Waiting for application to start...
+ sleep 10
+ docker-compose ps
       Name                     Command               State           Ports
-------------------------------------------------------------------------------------
demo-app-container   python app.py                    Up      0.0.0.0:5000->5000/tcp
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Health Check)
[Pipeline] echo
Verifying application health...
[Pipeline] sh
+ chmod +x healthcheck.sh
+ ./healthcheck.sh
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
   Response: {"service":"demo-app","status":"healthy","uptime_seconds":12,"version":"1.0.0"}
   [OK] Application reports healthy status

   [OK] Home endpoint is responding

=========================================
Health Check PASSED
=========================================

Application is running and healthy!
Access the application at: http://localhost:5000
Health endpoint: http://localhost:5000/health

+ echo Health check passed - Application is running successfully!
Health check passed - Application is running successfully!
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Display Status)
[Pipeline] echo
Application Status Report:
[Pipeline] sh
+ echo ================================
================================
+ echo APPLICATION DEPLOYMENT SUMMARY
APPLICATION DEPLOYMENT SUMMARY
+ echo ================================
================================
+ echo

+ echo Application: demo-app
Application: demo-app
+ echo Version: 1.0.0
Version: 1.0.0
+ echo Status: RUNNING
Status: RUNNING
+ echo

+ echo Container Status:
Container Status:
+ docker-compose ps
       Name                     Command               State           Ports
-------------------------------------------------------------------------------------
demo-app-container   python app.py                    Up      0.0.0.0:5000->5000/tcp
+ echo

+ echo Application URL: http://localhost:5000
Application URL: http://localhost:5000
+ echo Health Check URL: http://localhost:5000/health
Health Check URL: http://localhost:5000/health
+ echo

+ echo Testing endpoints:
Testing endpoints:
+ curl -s http://localhost:5000/
+ python -m json.tool
{
    "message": "Hello World! Welcome to the CI/CD Demo Application",
    "status": "running",
    "version": "1.0.0"
}
+ echo

+ curl -s http://localhost:5000/health
+ python -m json.tool
{
    "service": "demo-app",
    "status": "healthy",
    "uptime_seconds": 15,
    "version": "1.0.0"
}
+ echo

+ echo ================================
================================
+ echo DEPLOYMENT SUCCESSFUL!
DEPLOYMENT SUCCESSFUL!
+ echo ================================
================================
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Declarative: Post Actions)
[Pipeline] echo
Pipeline completed successfully!
[Pipeline] echo
Application is deployed and healthy.
[Pipeline] echo
Pipeline execution finished.
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```

## Stage-by-Stage Breakdown

### Stage 1: Checkout
**Duration:** 10-15 seconds
**Key Output:**
- Source code retrieved
- Directory listing shows all required files

### Stage 2: Build
**Duration:** 30-60 seconds
**Key Output:**
- All Python dependencies installed
- Flask, pytest, requests successfully installed
- "Build completed successfully"

### Stage 3: Test
**Duration:** 15-30 seconds
**Key Output:**
- 5 tests collected
- All tests PASSED (100%)
- test_home_endpoint PASSED
- test_health_endpoint PASSED
- test_info_endpoint PASSED
- test_health_endpoint_structure PASSED
- test_invalid_endpoint PASSED

### Stage 4: Package
**Duration:** 60-120 seconds (first run), 10-30 seconds (cached)
**Key Output:**
- Docker image built successfully
- Image tagged as demo-app:1.0.0 and demo-app:latest
- Image size: ~158MB

### Stage 5: Deploy
**Duration:** 20-40 seconds
**Key Output:**
- Old containers stopped and removed
- Network created
- New container started
- Container status: Up

### Stage 6: Health Check
**Duration:** 10-20 seconds
**Key Output:**
- Container verified running
- Health status: healthy
- All endpoints responding
- "Health Check PASSED"

### Stage 7: Display Status
**Duration:** 5-10 seconds
**Key Output:**
- Deployment summary displayed
- Container status confirmed
- Endpoints tested successfully
- JSON responses validated

## Success Indicators

Look for these indicators in the console output to confirm success:

1. Each stage shows `[Pipeline] { (Stage Name)` and closes with `[Pipeline] }`
2. No error messages or exceptions
3. Test output shows "5 passed"
4. Docker build shows "Successfully built" and "Successfully tagged"
5. Docker compose shows container "Up"
6. Health check shows "Health Check PASSED"
7. Final status: "Finished: SUCCESS"

## Time Breakdown

Total pipeline execution time: approximately 3-5 minutes

- Checkout: 10-15 seconds
- Build: 30-60 seconds
- Test: 15-30 seconds
- Package: 60-120 seconds (first run)
- Deploy: 20-40 seconds
- Health Check: 10-20 seconds
- Display Status: 5-10 seconds

Subsequent runs will be faster due to Docker layer caching.

## Common Output Patterns

### Successful Build
```
Successfully installed Flask-3.0.0 pytest-7.4.3 ...
Build completed successfully
```

### Successful Tests
```
===== 5 passed in 0.45s =====
All tests passed successfully
```

### Successful Docker Build
```
Successfully built [image-id]
Successfully tagged demo-app:1.0.0
```

### Successful Deployment
```
Creating demo-app-container ... done
Container Status: Up
```

### Successful Health Check
```
[OK] Application reports healthy status
Health Check PASSED
```

This console output represents a complete, successful CI/CD pipeline execution from checkout to deployment and verification.
