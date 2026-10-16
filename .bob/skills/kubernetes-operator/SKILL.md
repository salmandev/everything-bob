---
name: kubernetes-operator
description: >-
  Use when the user wants to deploy to Kubernetes, write k8s manifests, configure HPA autoscaling, set up health probes, plan a zero-downtime rolling update, or troubleshoot a Kubernetes deployment.
---

# Kubernetes Operator

Write production-grade Kubernetes manifests with health probes, resource limits, and zero-downtime deploys.

## Step 1 — Write the Deployment Manifest
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: my-app
          image: myapp:v1.2.3
          ports:
            - containerPort: 3000
          resources:
            requests:
              memory: "128Mi"
              cpu: "100m"
            limits:
              memory: "256Mi"
              cpu: "500m"
          livenessProbe:
            httpGet:
              path: /health/live
              port: 3000
            initialDelaySeconds: 10
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /health/ready
              port: 3000
            initialDelaySeconds: 5
            periodSeconds: 5
```

## Step 2 — Add HPA Autoscaling
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

## Step 3 — Apply and Verify
```bash
kubectl apply -f manifests/
kubectl rollout status deployment/my-app
kubectl get pods -l app=my-app
kubectl logs -l app=my-app --tail=50
```

## Verification Checklist
- [ ] All containers have liveness and readiness probes
- [ ] Resource requests and limits defined on all containers
- [ ] RollingUpdate strategy with maxUnavailable: 0
- [ ] HPA configured with sensible min/max replicas
