# Ingress
# Ingress install

- Cleanup if needed
```
kubectl delete -f animals-ingress.yml
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kind delete cluster --name ingress-lab
  # Remove
C:\Windows\System32\drivers\etc\hosts
127.0.0.1 animals.local
```
- List of clusters
```
kind get clusters
```
- Create kind cluster with port mapping
```
tee kind-ingress.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4

nodes:
  - role: control-plane
    image: kindest/node:v1.31.0
    extraPortMappings:
      - containerPort: 80
        hostPort: 80
        protocol: TCP

      - containerPort: 443
        hostPort: 443
        protocol: TCP
EOF
```
- Execute ingress-lab cluster, type the command if copy past not work
```
kind create cluster --name ingress-lab --config kind-ingress.yaml
```
- Install NGINX Ingress Controller type
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

```
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

kubectl get pods -n ingress-nginx
```

- Run the deployment files
```
kubectl apply -f animals-ingress.yaml
```
## Test

```
Browser:

http://animals.local/cats
http://animals.local/dogs

Or curl:

curl http://animals.local/cats
curl http://animals.local/dogs

```