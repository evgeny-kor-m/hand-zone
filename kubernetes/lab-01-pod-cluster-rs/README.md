# Installation of K8S cluster via kind
- **PreRequisite:** install Docker Desktop following:
  devops-docker-make-it-happen/lesson-docker/practice-01

- Go to the link and install it step by step following the instruction:
https://kind.sigs.k8s.io/docs/user/quick-start/
**Note:** you can install kind via section **Installing with go install**
its including kind as part of Go installtion

Go to the cli of PowerShell and check the version of kind
```
kind version
kind info
kubectl version
```
## Basic k8s commands:
- list of cluster, probably nothing will appear
```
kind get clusters
kubectl get nodes
kubectl get all --all-namespaces
  # for cleanup
kubectl config delete-context kind-example
```

- Create your first kind cluster
  
```
kind create cluster --name kind-01 --config kind-config.yaml          : create cluster
kind delete cluster --name kind-01                                    : delete cluster
kubectl config view --minify --output 'jsonpath={..namespace}'; echo  : show current ns
kind get clusters
# probably kind-01 cluster will appear
kubectl config get-contexts $(kubectl config current-context)         : show cluster, user and namespace
```

- Shortcut options
```
# 1. Enables autocompletion for kubectl (Tab completion)
# Now you can write: kubectl get po<TAB> → kubectl get pods
echo 'source <(kubectl completion bash)' >>~/.bash_profile

# 2. Creates a short alias k instead of kubectl
# Now you can write: k get pods instead of kubectl get pods
echo 'alias k=kubectl' >>~/.bash_profile

# 3. Enables tab completion for the alias k as well
# Otherwise, autocompletion would only work for kubectl, not k
echo 'complete -F __start_kubectl k' >>~/.bash_profile

# 4. Applies changes to the current session without restarting the terminal
source ~/.bash_profile
```

# Hands-On  - Exercise 01 - my first Pod
  - Create namespace with name ns-my-first-pod based on exist cluster​
  - Create yaml file  my-first-pod.yaml based on image latest of nginx​
  - Apply the pod​ to the namespace ns-my-first-pod
  - Check that the pod is running correctly under test ns  
    
## Bonus​
  - How can we get the IP and Node that the pod running ?​
  - How can we get the log of pod  ?

### Solution  - Exercise 01

  - Cleanup if needed
    
```
docker rm -f $(docker ps -a -q)
docker rmi -f $(docker images -q)

kubectl get pod
kubectl delete all --all
kubectl delete pod <pod-name> --grace-period=0 --force
kubectl get ns
kubectl delete namespace ns-my-first-pod
```

  - Create ns and Pod
  - Go to Practice-01, in case you should create cluster

```
kubectl get pod
kubectl get ns
kubectl create ns ns-my-first-pod

  # other option is via yaml file
cat << EOF > ~/ns-my-first-pod.yaml 
apiVersion: v1
kind: Namespace
metadata:
  name: test
EOF

kubectl apply -f ns-my-first-pod.yaml

kubectl get ns
kubectl config set-context --current --namespace=ns-my-first-pod
kind get clusters
kubectl config get-contexts
kubectl config get-contexts | awk '{print $1,$5}'

cat << EOF > ~/my-first-pod.yaml​
  Insert the contant of my-first-pod.yaml​ copy to nodepad and run it via cli of gitbash
EOF


kubectl apply -f my-first-pod.yaml​
kubectl get pod
kubectl get svc
kubectl get rs
kubectl describe pod example-pod​
kubectl logs example-pod​
```

## Solution via separate yaml files

  - Create ReplicaSets (rs)

```
kubectl get pods
kubectl get replicasets
kubectl apply -f my-first-replicaset.yaml
kubectl get pods
kubectl get rs
kubectl describe rs
kubectl edit rs example-replicaset

  # Change the number of rs from 3 to 2 and save the file
kubectl get rs
  # You should see 2 rs that up and running
```