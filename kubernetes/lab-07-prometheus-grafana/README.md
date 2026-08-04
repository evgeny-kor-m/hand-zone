# Helm - Install Prometheus on K8s using Helm
## For more info go to Monitor Repo
## For Helm practice go to lesson-argocd -> practice-03 ->README.md
- Maintained by Prometheus Community
- Installation list
  - Prometheus
  - Grafana
  - Alertmanager
  - Node Exporter
  - kube-state-metrics
### Clean all
```
kubectl delete all --all
```
### Add and Install Helm Repository
```
# adds a new repository to the local Helm list:
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# updates the local cache of all added Helm repositories:
helm repo update
# View all added repositories:
helm repo list
kubectl get ns
kubectl create namespace monitoring
kubectl get ns
helm install prometheus prometheus-community/kube-prometheus-stack   --namespace monitoring
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

- Get Grafana user admin, Run the command below for Password
- Login via the browser
```
kubectl get secret prometheus-grafana -n monitoring \
  -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

```
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
http://127.0.0.1:3000/
```

### Access Prometheus UI

```
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring
```

```
http://localhost:9090
```

#### Test Prometheus Dashboard
- PromQL Example
- CPU usage percentage approximation
- Change the time on Prometheus Dashboard

```
rate(process_cpu_seconds_total[1m])
rate(process_cpu_seconds_total[1m]) * 100
```

- From git bash cli
```
kubectl run cpu-test \
  --image=busybox \
  --restart=Never \
  -- sh -c "while true; do :; done"

```
- Check the CPU usage by cAdvisor metrics:  
  cAdvisor (Container Advisor) is a Google agent built directly into kubelet that automatically collects metrics for all containers on a node.   
```
  CPU usage — container_cpu_usage_seconds_total  
  Memory usage — container_memory_usage_bytes  
  Network I/O — container_network_transmit_bytes_total  
  Disk I/O — container_fs_reads_bytes_total 

rate(container_cpu_usage_seconds_total{pod="cpu-test"}[1m]) * 100
```
- After testing stop it
```
kubectl delete pod cpu-test
```
##### Common Helm Commands

```
# - Shows all installed Helm releases in namespace monitoring
helm list -n monitoring       

# - Updates an already installed prometheus release to the latest chart version from the prometheus-community repository
helm upgrade prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring
  
helm uninstall prometheus -n monitoring

```