# Horizontal Pod Autoscaler (HPA)

- CleanUp
- Apply Deployment
- Install metrics-server
- Check deployment metrics-server
- load-generator
- Test

## Install HPA
1. Check Metrics Server:
kubectl get pods -n kube-system | grep metrics

2. install:
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

For kind add flag --kubelet-insecure-tls:
kubectl patch deployment metrics-server -n kube-system --type='json' -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

## Cleanup
```
kubectl delete all --all
kubectl get deployments
```
## Apply Deployment
```

kubectl apply -f autoscaling-hpa.yaml
kubectl get deployments
kubectl get pods
kubectl get svc
kubectl top pods
kubectl autoscale deployment php-apache \
  --cpu-percent=10 \
  --min=1 \
  --max=5
  
kubectl get hpa
kubectl get hpa --watch
kubectl describe hpa php-apache

```


## load-generator in order to increase the resources till the edge
```
# On Previous terminal run
kubectl get hpa --watch
 
  #new terminal
kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- sh
  # into container run 
while sleep 0.01; do wget -q -O- http://php-apache; done
 # Output
# while sleep 0.01; do wget -q -O- http://php-apache; done
OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!wget: can't connect to remote host (10.96.92.207): Connection refused
  # Stop loader by 
Ctrl + C 

  # Output after stop, afetr few min the Replicas back to minimum
$ kubectl get hpa --watch
NAME         REFERENCE               TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   cpu: 176%/10%   1         5         5          5m24s
php-apache   Deployment/php-apache   cpu: 119%/10%   1         5         5          5m30s
php-apache   Deployment/php-apache   cpu: 18%/10%    1         5         5          6m
php-apache   Deployment/php-apache   cpu: 4%/10%     1         5         5          6m15s
php-apache   Deployment/php-apache   cpu: 2%/10%     1         5         5          6m30s
php-apache   Deployment/php-apache   cpu: 2%/10%     1         5         5          11m
php-apache   Deployment/php-apache   cpu: 2%/10%     1         5         2          11m
php-apache   Deployment/php-apache   cpu: 2%/10%     1         5         1          11m


```
# Test - back to previous cli
```
kubectl get hpa
kubectl get hpa --watch
kubectl get nodes
kubectl get deployments

kubectl get pods

# Importent - Wait few min and it will back to min pods !!!

# Edit HPA configuration to 10 ReplicaSet and load again from new terminal
kubectl edit hpa php-apache
 #Watch the HPA with the following command to see how the application is beeing scaled
kubectl get pods
kubectl get nodes
kubectl get hpa --watch

```