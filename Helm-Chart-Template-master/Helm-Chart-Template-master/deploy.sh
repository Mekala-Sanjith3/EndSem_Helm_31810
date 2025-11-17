#!/bin/bash

# Hospital Application Helm Chart Deployment Script
# This script helps deploy the Hospital Application using Helm

echo "========================================"
echo "Hospital Application Helm Deployment"
echo "========================================"
echo ""

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "ERROR: Helm is not installed. Please install Helm first."
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "ERROR: kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Set variables
RELEASE_NAME="hospital-app"
NAMESPACE="default"
CHART_PATH="."

echo "Step 1: Validating Helm Chart..."
helm lint $CHART_PATH
if [ $? -ne 0 ]; then
    echo "ERROR: Helm chart validation failed!"
    exit 1
fi
echo "Chart validation passed!"
echo ""

echo "Step 2: Checking Kubernetes cluster connection..."
kubectl cluster-info
if [ $? -ne 0 ]; then
    echo "ERROR: Cannot connect to Kubernetes cluster!"
    exit 1
fi
echo "Cluster connection successful!"
echo ""

echo "Step 3: Deploying Hospital Application..."
echo "Release Name: $RELEASE_NAME"
echo "Namespace: $NAMESPACE"
echo ""

# Deploy using Helm
helm upgrade --install $RELEASE_NAME $CHART_PATH \
    --namespace $NAMESPACE \
    --create-namespace \
    --wait \
    --timeout 10m

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "Deployment Successful!"
    echo "========================================"
    echo ""
    echo "Checking deployment status..."
    echo ""
    
    # Show deployment status
    kubectl get pods -n $NAMESPACE -l "app in (frontend,backend,mysql)"
    echo ""
    
    # Show services
    kubectl get svc -n $NAMESPACE
    echo ""
    
    echo "To view logs, use:"
    echo "  kubectl logs -n $NAMESPACE -l app=backend --tail=50"
    echo "  kubectl logs -n $NAMESPACE -l app=frontend --tail=50"
    echo "  kubectl logs -n $NAMESPACE -l app=mysql --tail=50"
    echo ""
    echo "To uninstall, use:"
    echo "  helm uninstall $RELEASE_NAME -n $NAMESPACE"
else
    echo ""
    echo "========================================"
    echo "Deployment Failed!"
    echo "========================================"
    echo "Check the error messages above for details."
    exit 1
fi

