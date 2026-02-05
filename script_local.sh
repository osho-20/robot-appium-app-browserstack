#!/bin/bash
set -e  # Exit on error

echo "starting pytest testing"

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Script directory: $SCRIPT_DIR"
cd "$SCRIPT_DIR"

echo "Python version:"
python -V

# Export BrowserStack credentials from Copado parameters
if [ -n "$BROWSERSTACK_USERNAME" ]; then
    export BROWSERSTACK_USERNAME
    echo "BrowserStack username configured from Copado parameters"
else
    echo "WARNING: BROWSERSTACK_USERNAME not set"
fi

if [ -n "$BROWSERSTACK_ACCESS_KEY" ]; then
    export BROWSERSTACK_ACCESS_KEY
    echo "BrowserStack access key configured from Copado parameters"
else
    echo "WARNING: BROWSERSTACK_ACCESS_KEY not set"
fi

# Detect if running in Copado environment (or any CI/CD that already provides isolation)
if [ -n "$CI" ] || [ -n "$COPADO_EXECUTION" ] || [ -d "/home/executor/execution" ]; then
    echo "CI/CD environment detected - skipping virtual environment creation"
    SKIP_VENV=true
else
    echo "Local environment detected - creating virtual environment"
    SKIP_VENV=false
fi

# Create and activate virtual environment only if not in CI/CD
if [ "$SKIP_VENV" = false ]; then
    echo "Creating virtual environment"
    python -m venv env
    
    if [ ! -f "env/bin/activate" ]; then
        echo "ERROR: Failed to create virtual environment"
        exit 1
    fi
    
    source env/bin/activate
    echo "Virtual environment created and activated"
else
    echo "Using system Python environment"
fi

echo "installing dependencies from requirements.txt"
if [ ! -f "requirements.txt" ]; then
    echo "ERROR: requirements.txt not found"
    exit 1
fi

# Upgrade pip to ensure platform markers work correctly
pip install --upgrade pip setuptools wheel

# Install dependencies with verbose output for debugging
pip install -r requirements.txt --verbose
echo "dependencies installed"

cd ./robot

if [ ! -d "tests" ]; then
    echo "ERROR: android directory not found"
    exit 1
fi

cd tests
echo "running pytest for SingleTestAndroid.robot"
rm -rf log logs
browserstack-sdk robot ./test-1.robot
TEST_EXIT_CODE=$?

echo "pytest testing completed with exit code: $TEST_EXIT_CODE"

cd "$SCRIPT_DIR"
cd ..

# Only deactivate if we created a venv
if [ "$SKIP_VENV" = false ]; then
    deactivate
    rm -rf env
fi

exit $TEST_EXIT_CODE