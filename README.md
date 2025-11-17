# Hospital Application - Helm Chart Deployment

Complete Helm Chart deployment for Hospital Application with MySQL, Spring Boot Backend, and React Frontend.

## Repository
[GitHub Repository](https://github.com/Mekala-Sanjith3/EndSem_Helm_31810.git)

## Project Structure

```
HospitalApplication/
├── Helm-Chart-Template-master/
│   └── Helm-Chart-Template-master/
│       ├── Chart.yaml                    # Helm chart metadata
│       ├── values.yaml                   # Configurable values
│       ├── templates/                     # Kubernetes templates
│       │   ├── backend-deployment.yaml
│       │   ├── frontend-deployment.yaml
│       │   ├── mysql-deployment.yaml
│       │   ├── services.yaml
│       │   ├── ingress.yaml
│       │   ├── hpa.yaml                   # Horizontal Pod Autoscaler
│       │   ├── pvc.yaml                   # Persistent Volume Claim
│       │   ├── _helpers.tpl              # Template helpers
│       │   └── NOTES.txt                 # Post-deployment notes
│       ├── deploy.ps1                    # PowerShell deployment script
│       └── deploy.sh                     # Bash deployment script
├── hospital-backend-main/
│   └── hospital-backend-main/
│       ├── Dockerfile                    # Backend Docker image
│       ├── pom.xml                       # Maven dependencies
│       └── src/                          # Spring Boot source code
└── hospital-frontend-main/
    └── hospital-frontend-main/
        ├── Dockerfile                    # Frontend Docker image
        ├── package.json                  # Node.js dependencies
        └── src/                          # React/Vite source code
```

## Features

✅ **Configurable Helm Chart** with:
- Configurable images, ports, and replicas
- Resource limits and requests
- Health checks (liveness & readiness probes)
- Horizontal Pod Autoscaler (HPA)
- Ingress configuration
- Persistent storage for MySQL

✅ **Complete Application Stack**:
- **MySQL 8.0** - Database with persistent storage
- **Spring Boot Backend** - REST API on port 8081
- **React Frontend** - Vite-based UI on port 80

✅ **Production Ready**:
- Health checks
- Resource management
- Auto-scaling
- Service discovery

## Prerequisites

- Kubernetes cluster (Docker Desktop, Minikube, or cloud cluster)
- Helm 3.x installed
- kubectl configured
- Docker (for building images)

## Quick Start

### 1. Build Docker Images

```bash
# Build backend image
cd hospital-backend-main/hospital-backend-main
docker build -t hospital-backend:latest .

# Build frontend image
cd ../../hospital-frontend-main/hospital-frontend-main
docker build -t hospital-frontend:latest .
```

### 2. Deploy with Helm

```bash
# Navigate to chart directory
cd Helm-Chart-Template-master/Helm-Chart-Template-master

# Deploy using Helm
helm install hospital-app . --namespace default --create-namespace

# Or use the deployment script
# PowerShell: .\deploy.ps1
# Bash: ./deploy.sh
```

### 3. Access the Application

**Frontend:**
- NodePort: `http://localhost:30080`
- Ingress: `http://hospital.local/`

**Backend API:**
- NodePort: `http://localhost:30081`
- Ingress: `http://hospital.local/api`

## Configuration

All configuration is done through `values.yaml`. Key configurable options:

### Images
```yaml
backend:
  image:
    repository: hospital-backend
    tag: "latest"
    
frontend:
  image:
    repository: hospital-frontend
    tag: "latest"
```

### Ports
```yaml
backend:
  port: 8081
  nodePort: 30081

frontend:
  port: 80
  nodePort: 30080
```

### Replicas
```yaml
backend:
  replicas: 2

frontend:
  replicas: 2
```

### Autoscaling
```yaml
autoscaling:
  backend:
    enabled: true
    minReplicas: 2
    maxReplicas: 5
```

## Useful Commands

```bash
# Check deployment status
helm status hospital-app

# View all resources
kubectl get all -n default

# View logs
kubectl logs -n default -l app=backend --tail=50
kubectl logs -n default -l app=frontend --tail=50

# Scale manually
kubectl scale deployment backend --replicas=3 -n default

# Update and redeploy
helm upgrade hospital-app . -f custom-values.yaml

# Uninstall
helm uninstall hospital-app -n default
```

## Database Configuration

- **Host:** mysql
- **Port:** 3306
- **Database:** hospital
- **Username:** root
- **Password:** root (configurable in values.yaml)

## Troubleshooting

### Pods not starting
```bash
kubectl describe pod <pod-name> -n default
kubectl logs <pod-name> -n default
```

### Image pull errors
Ensure Docker images are built and available:
```bash
docker images | grep hospital
```

### Service not accessible
Check service and ingress:
```bash
kubectl get svc -n default
kubectl get ingress -n default
```

## License

This project is for educational purposes (Lab Exam).

## Author

Mekala Sanjith

