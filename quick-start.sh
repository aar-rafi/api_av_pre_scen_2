#!/bin/bash

# Quick Start Script for CI/CD Demo Pipeline
# This script provides a quick way to test the application without Jenkins

set -e

echo "========================================="
echo "CI/CD Demo Application - Quick Start"
echo "========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

# Check prerequisites
echo "Step 1: Checking prerequisites..."
echo ""

if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed"
    exit 1
fi
print_success "Docker is installed"

if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed"
    exit 1
fi
print_success "Docker Compose is installed"

# Check if port 5000 is available
if lsof -Pi :5000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    print_error "Port 5000 is already in use"
    print_info "Stop the process using port 5000 or change the port in docker-compose.yml"
    exit 1
fi
print_success "Port 5000 is available"

echo ""
echo "Step 2: Running unit tests..."
echo ""

# Run tests locally
cd app
if command -v python3 &> /dev/null; then
    if [ ! -d "venv" ]; then
        print_info "Creating virtual environment..."
        python3 -m venv venv
    fi
    source venv/bin/activate
    print_info "Installing dependencies..."
    pip install -q -r requirements.txt
    print_info "Running tests..."
    python -m pytest test_app.py -v
    deactivate
    cd ..
    print_success "All tests passed"
else
    print_info "Python3 not found locally, skipping local tests (will run in Docker)"
    cd ..
fi

echo ""
echo "Step 3: Building Docker image..."
echo ""

docker build -t demo-app:1.0.0 -t demo-app:latest .
print_success "Docker image built successfully"

echo ""
echo "Step 4: Deploying application..."
echo ""

# Stop any existing containers
docker-compose down 2>/dev/null || true

# Start the application
docker-compose up -d

print_success "Application deployed"

echo ""
echo "Step 5: Waiting for application to start..."
sleep 10

echo ""
echo "Step 6: Running health check..."
echo ""

chmod +x healthcheck.sh
./healthcheck.sh

echo ""
echo "========================================="
echo "Quick Start Complete!"
echo "========================================="
echo ""
echo "Application is running at:"
echo "  - Home: http://localhost:5000"
echo "  - Health: http://localhost:5000/health"
echo "  - Info: http://localhost:5000/api/info"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f"
echo ""
echo "To stop the application:"
echo "  docker-compose down"
echo ""
echo "To run the full CI/CD pipeline with Jenkins:"
echo "  See PIPELINE_GUIDE.md for instructions"
echo ""
