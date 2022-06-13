# Kubernetes Notes

### minikube

```Shell script
minikube start  # start minikube cluster
minikube start --vm-driver hyperv  # start using hyperv
minikube stop  # stop minikube cluster
minikube delete  # delete the minikube cluster
minikube addons enable registry  # enable docker registry
```

### kubectl

```Shell script
kubectl version
kubectl config current-context  # get project, zone, cluster
kubectl config get-contexts  # get contexts

kubectl get namespaces  # get namespaces
kubectl get nodes  # get nodes
kubectl get nodes -o wide  # more info
kubectl get po  # get running pods in the cluster
kubectl get po -n kube-system  # get pods running in the "kube-system" namespace
kubectl get po -n zpc | grep fakeapp
kubectl get svc -n kube-system  # show the service resource associated with the registry
kubectl get svc -n zpc | grep fakeapp
kubectl get deploy  # get the deployment

# Get api-resources, ingress service info:
kubectl api-resources | grep ingress
kubectl get ingresses.voyager.appscode.com -n zpc

kubectl describe po hello  # list the containers in the pod
kubectl describe svc -n zpc fakeapp  # info on the fakeapp service
kubectl describe ingresses.voyager -n zpc fakeapp-ingress  # find external IP and hostname
```

### Port Forwarding

```Shell script
# Enable port forwarding from local 5000 to port 80 on the cluster and verify:
kubectl port-forward -n kube-system svc/registry 5000:80 &> /dev/null &
curl localhost:5000/v2/_catalog  # {"repositories":["hello"]}

# Enable port forwarding for port 8080
kubectl port-forward -n zpc po/fakeapp-6d4c445dc8-9xz66 8080

# Enable port forwarding from 127.0.0.1:8080 -> 80
kubectl port-forward po/single-container-catlb-58dcf6dd59-mswqd 8080:80
```

### Pods, Deployments

```Shell script
# Create a deployment which creates a pod with a single instastance:
kubectl create deployment single-container-catlb --image mkorangestripe/loadbalancer:1.3.0

# Create a new pod described in the yaml file:
kubectl apply -f deploy/pod-multi.yaml

# Get the deployment rollout status:
kubectl rollout status deployment/single-container-catlb-deployment

# Delete the deployment:
kubectl delete deployment single-container-catl

# Logs for the pod:
kubectl logs hello-7f5c49b6c6-ct86z
kubectl logs -n zpc fakeapp-6d4c445dc8-rjps9
kubectl logs -n zpc voyager-fakeapp-ingress-6cddc864f5-84ksf --container haproxy
```

```Shell script
# Create or update existing pod:
kubectl apply -f deploy/pod-args.yaml

# Attach to a pod:
kubectl exec -it hello bash
kubectl exec -it -n zpc fakeapp-6d4c445dc8-rjps9 /bin/sh

# Delete the pod:
kubectl delete po hello

kubectl expose deploy mynginx --type=NodePort  # expose a service
minikube service mynginx  # hit the service endpoint and open in default browser
```

### Helm

```Shell script
# Perform syntax validation of helm chart
helm lint hello

# Setup helm in the cluster
helm init

# Install GCS plugin for helm
helm plugin install https://github.com/hayorov/helm-gcs --version 0.2.1

# Validate template on server
# Get the template without passing the data on to k8s
helm install --dry-run --debug hello
helm install --dry-run --debug hello --set 'helloArgs[0]=Ben'

# Install a release of the helm chart.
# These will produce a new pod named something like 'nordic-quail-hello' unless specified.
helm install hello
helm install hello --name antlers
helm install hello --set helloArgs[0]=Ben
helm install --set imageRegistry=us.gcr.io/xxx-xx-xx hello
helm install --name hello-gp1 --set imageRegistry=us.gcr.io/xxx-xx-xx --set dockerTag=gp-1 hello-socket

# More helm install examples
helm install --name fakeapp --namespace zpc spg-zpc-sb-charts/fakeapp
helm install --name fakeapp --namespace zpc spg-zpc-sb-charts/fakeapp --set replicaCount=1 --set deployment.environment.productDomain=gp-cluster.zpc-sandbox.xxxxx.com --set deployment.envirionment.type=sandbox

# Delete the helm release
helm delete nordic-quail
helm delete --purge hello-gp1 # and free up the name for later use

# List deployed releases
helm list

# List helm charts in the repo
helm search fakeapp

# List chart repos
helm repo list

# Add helm repo
helm repo add xxx-xx-xx-charts gs://xxx-xx-xx-helm-repo
```
