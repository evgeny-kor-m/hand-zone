# Kubernetes Deployment
A Kubernetes Deployment is used to manage the deployment, scaling, and rolling updates of a group of Pods
It ensures that the desired number of pod replicas are running and automatically replaces failed pods

Deployment Strategy in Kubernetes
Kubernetes Deployments support strategies for updating Pods when you make changes (like changing the image version)
The most common strategy is rolling update, but there's also recreate.

## Two Main Strategies
- **RollingUpdate (default)**
Updates Pods gradually to ensure zero downtime.
Creates new Pods and deletes old ones incrementally.
You can control the speed with:
  - maxUnavailable — how many old pods can be unavailable during the update.
    - How many Pods can you kill, At least 3 out of 4 Pods are always working.
    yamlreplicas: 4  
    maxUnavailable: 1  
    maxSurge: 0  
        Start:    [v1] [v1] [v1] [v1]   work 4  
        Step 1:   [v2] [v1] [v1] [v1]   kill 1, create 1 new  
        Step 2:   [v2] [v2] [v1] [v1]   kill 1 more  
        Step 3:   [v2] [v2] [v2] [v1]  
        Ready:    [v2] [v2] [v2] [v2]  
  - maxSurge — how many extra new pods can be created beyond desired replicas
    - How many Pods can be added on top? All 4 Pods are always working.
    yamlreplicas: 4  
    maxUnavailable: 0  
    maxSurge: 1  
        Start:    [v1] [v1] [v1] [v1]        work 4  
        Step 1:   [v1] [v1] [v1] [v1] [v2]   create new 1 (5 total)  
                  [v1] [v1] [v1] [__] [v2]   kill old 1 then new is ready  
        Step 2:   [v1] [v1] [v2] [v2]        again 4  
        ...  
        Ready:    [v2] [v2] [v2] [v2]  

maxUnavailable: 1, maxSurge: 0
→ Resource savings, but fewer pods in the short term

maxUnavailable: 0, maxSurge: 1
→ Zero downtime, but requires additional resources

maxUnavailable: 1, maxSurge: 1
→ Fastest, compromise

- **Recreate**
Deletes all old Pods first, then creates new ones.
Simpler, but may cause downtime.
Useful when old and new versions cannot run together (e.g., conflicting DB schema versions).


## Hands-On - Exercise 03 - my first Deployment

  - Create yaml file of first-deployment.yaml based on 1.21 image of nginx
  - Apply the Deployment​ 
  - Get the List and Describe of Deployments
  - Change the scale of rs from 3 to 5

  - Change the version of nginx to latest image
  - Apply the new version of deployment
  - Check the status of the deployment rollout
  - Rollback a Deployment
  - Delete a Deployment

- Cleanup Environment

```
kubectl delete all --all
kubectl get pods
kubectl get svc
kubectl get replicaset
kubectl get deployment
```

- Get information of cluster

```
kubectl get ns
kind get clusters
kubectl config get-contexts
```

## Solution

-  Apply Deployment

```
kubectl apply -f first-deployment.yaml
kubectl get pods
kubectl get svc
kubectl get rs
kubectl port-forward example-deployment-6fbb7d8d8f-7gfdb 8080:80
```
- Go to the browser http://localhost:8080/

- Get, Describe and Scale deployment
```
kubectl get deployments
kubectl describe deployment example-deployment
  # output the version of nginx
kubectl scale deployment example-deployment --replicas=2
kubectl get deployments
```

- Apply the new version of Deployment

```
kubectl apply -f first-deployment-latest-nginx.yaml
kubectl rollout status deployment example-deployment

Note - Restart: kubectl rollout restart deployment example-deployment
```

- Rollback a Deployment:

```
Make rollback :    
    Back to lasted ver (rollback) :    kubectl rollout undo deployment example-deployment
    Show version history :  kubectl rollout history deployment example-deployment
    Back to revision 2 :    kubectl rollout undo deployment example-deployment --to-revision=2
    
kubectl describe deployment example-deployment
kubectl describe pods
kubectl get deployments
kubectl delete deployment example-deployment
```