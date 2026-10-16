---
name: ibm-cloud-deploy
description: >-
  Use when the user wants to deploy to IBM Cloud, use IBM Code Engine, configure IBM Cloud Kubernetes Service, deploy containers to IBM Cloud, set up IBM Cloud CI/CD toolchains, manage IAM policies, or use the ibmcloud CLI.
---

# IBM Cloud Deploy

Deploy applications to IBM Cloud using Code Engine, IKS, or Cloud Foundry with production-grade config.

## Step 1 — Authenticate with ibmcloud CLI
```bash
ibmcloud login --sso
ibmcloud target -r us-south -g my-resource-group
```

## Step 2 — Deploy to IBM Code Engine (Recommended for containers)
Code Engine is IBM Cloud's serverless container platform — no cluster management needed.

```bash
# Create a project
ibmcloud ce project create --name my-project
ibmcloud ce project select --name my-project

# Deploy from a container image
ibmcloud ce application create \
  --name my-app \
  --image us.icr.io/my-namespace/my-app:latest \
  --port 3000 \
  --min-scale 1 \
  --max-scale 10 \
  --cpu 0.5 \
  --memory 1G \
  --env DATABASE_URL=secret:db-secret/DATABASE_URL

# Check deployment status
ibmcloud ce application get --name my-app
```

## Step 3 — Push Image to IBM Container Registry
```bash
ibmcloud cr login
ibmcloud cr namespace-add my-namespace

docker tag my-app:latest us.icr.io/my-namespace/my-app:latest
docker push us.icr.io/my-namespace/my-app:latest

# Verify image
ibmcloud cr image-list --restrict my-namespace
```

## Step 4 — Deploy to IBM Cloud Kubernetes Service (IKS)
```bash
# Download kubeconfig
ibmcloud ks cluster config --cluster my-cluster

# Apply manifests
kubectl apply -f k8s/
kubectl rollout status deployment/my-app
kubectl get services -l app=my-app
```

## Step 5 — Manage Secrets with IBM Secrets Manager
```bash
# Store secret
ibmcloud secrets-manager secret-create \
  --secret-type arbitrary \
  --name "database-password" \
  --payload "$(echo -n 'my-password' | base64)"

# Reference in Code Engine
ibmcloud ce secret create --name db-secret \
  --from-literal DATABASE_URL=postgresql://...
```

## Step 6 — IAM Policy Best Practices
```bash
# Grant least-privilege access to a service ID
ibmcloud iam service-policy-create my-service-id \
  --roles Reader \
  --service-name containers-kubernetes \
  --resource-type namespace \
  --resource my-namespace
```

## Verification Checklist
- [ ] Logged in with SSO (no API key in shell history)
- [ ] Container image scanned for vulnerabilities before push: `ibmcloud cr va us.icr.io/...`
- [ ] Secrets stored in Secrets Manager, not in environment variables directly
- [ ] IAM roles follow least-privilege
- [ ] Health endpoint `/health/ready` responding before routing traffic
