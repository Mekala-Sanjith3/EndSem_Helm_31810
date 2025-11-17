# Hospital Application Helm Chart Deployment Script
# This script helps deploy the Hospital Application using Helm

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Hospital Application Helm Deployment" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Helm is installed
if (-not (Get-Command helm -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Helm is not installed. Please install Helm first." -ForegroundColor Red
    exit 1
}

# Check if kubectl is installed
if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: kubectl is not installed. Please install kubectl first." -ForegroundColor Red
    exit 1
}

# Set variables
$RELEASE_NAME = "hospital-app"
$NAMESPACE = "default"
$CHART_PATH = "."

Write-Host "Step 1: Validating Helm Chart..." -ForegroundColor Yellow
helm lint $CHART_PATH
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Helm chart validation failed!" -ForegroundColor Red
    exit 1
}
Write-Host "Chart validation passed!" -ForegroundColor Green
Write-Host ""

Write-Host "Step 2: Checking Kubernetes cluster connection..." -ForegroundColor Yellow
kubectl cluster-info
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Cannot connect to Kubernetes cluster!" -ForegroundColor Red
    exit 1
}
Write-Host "Cluster connection successful!" -ForegroundColor Green
Write-Host ""

Write-Host "Step 3: Deploying Hospital Application..." -ForegroundColor Yellow
Write-Host "Release Name: $RELEASE_NAME" -ForegroundColor Cyan
Write-Host "Namespace: $NAMESPACE" -ForegroundColor Cyan
Write-Host ""

# Deploy using Helm
helm upgrade --install $RELEASE_NAME $CHART_PATH `
    --namespace $NAMESPACE `
    --create-namespace `
    --wait `
    --timeout 10m

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Deployment Successful!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Checking deployment status..." -ForegroundColor Yellow
    Write-Host ""
    
    # Show deployment status
    kubectl get pods -n $NAMESPACE -l "app in (frontend,backend,mysql)"
    Write-Host ""
    
    # Show services
    kubectl get svc -n $NAMESPACE
    Write-Host ""
    
    Write-Host "To view logs, use:" -ForegroundColor Cyan
    Write-Host "  kubectl logs -n $NAMESPACE -l app=backend --tail=50" -ForegroundColor White
    Write-Host "  kubectl logs -n $NAMESPACE -l app=frontend --tail=50" -ForegroundColor White
    Write-Host "  kubectl logs -n $NAMESPACE -l app=mysql --tail=50" -ForegroundColor White
    Write-Host ""
    Write-Host "To uninstall, use:" -ForegroundColor Cyan
    Write-Host "  helm uninstall $RELEASE_NAME -n $NAMESPACE" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Deployment Failed!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Check the error messages above for details." -ForegroundColor Yellow
    exit 1
}

