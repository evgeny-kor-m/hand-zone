# Secure-pod - based on lab-01

- Runs the pod as non-root user
- Prevents privilege escalation
- Uses read-only filesystem
- Adds CPU/memory limits
- Set 3 ReplicaSet for pod
  - **Note:** - cretae the pod and rs with one yaml file 


kubectl apply -f secure-pod.yaml
kubectl apply -f secure-rs.yaml