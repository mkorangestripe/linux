# Kubernetes Notes

### minikube

```Shell script
minikube start  # start minikube cluster
minikube start --vm-driver hyperv  # start using hyperv
minikube stop  # stop minikube cluster
minikube delete  # delete the minikube cluster
minikube addons enable registry  # enable docker registry
minikube ip  # show ip address of minikube
minikube ssh  # ssh to node VM
minikube service mynginx  # hit the service endpoint and open in default browser
```

### Cluster info

```Shell script
kubectl config current-context  # show project, zone, cluster
kubectl config get-contexts  # list contexts

kubectl get all  # list all objects
```

### Namespaces

Initial namespaces:
* default - for objecst with no other namespace
* kube-public - readable by all users
* kube-system - for objects created by Kubernetes
```Shell script
kubectl get namespaces  # list namespaces
```

### Nodes

```Shell script
kubectl get nodes  # list nodes
kubectl get nodes -o wide  # list nodes, wide output
```

### Pods

```Shell script
kubectl get po  # get running pods in the cluster
kubectl get po -n kube-system  # get pods running in the "kube-system" namespace
kubectl get po -n zpc | grep fakeapp  # show the fakeapp pod in the zpc namespace
kubectl get pods -l run=mynginx -o wide  # get pods with label run=mynginx, wide output
kubectl get pods -l tier=backend -o wide  # get pods with label tier=backend, wide output
kubectl describe po hello  # list the containers in the pod

# Create or update existing pod:
kubectl apply -f deploy/pod-args.yaml

# Attach to a pod:
kubectl exec -it hello bash
kubectl exec -it hello -- /bin/bash
kubectl exec -it -n zpc fakeapp-6d4c445dc8-rjps9 /bin/sh

kubectl delete po hello  # delete the hello pod
kubectl delete po -l app=nginx  # delete a pod with the app=nginx label
```

### Services

```Shell script
kubectl describe svc -n zpc fakeapp  # show info on the fakeapp service
kubectl get svc -n kube-system  # show the service resource associated with the registry
kubectl get svc -n zpc | grep fakeapp  # show the fakeapp service in the zpc namespace

kubectl expose deploy mynginx --type=NodePort  # expose a service

kubectl api-resources | grep ingress  # find the ingress service
kubectl get ingresses.voyager.appscode.com -n zpc  # show info for the ingress service in the zpc namespace
kubectl describe ingresses.voyager -n zpc fakeapp-ingress  # show info for the ingress service including external IP and hostname
```

### Replica Sets

```Shell script
kubectl create -f replication_controller.yaml  # create a replication controller
kubectl describe rc/nginx  # show info on replication controller
kubectl scale rc nginx --replicas=3  # scale the replica set to 3
```

### Volumes

```Shell script
kubectl get pv  # list persistent volumes
kubectl get pv pv-volume  # show volume info for pv-volume
kubectl create -f pv-volume.yaml  # create a volume from file
```

### API Key & Configmap

* Use secrets for confidential data like API keys.
* Use Configmaps for non-confidential data like language or ports.
```Shell script
kubectl create secret generic apikey --from-literal=API_KEY=12345-abcde  # create an API key
kubectl create configmap language --from-literal=LANGUAGE=English  # create a configmap
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

### Deployments

```Shell script
kubectl get deployments  # show deployments

kubectl get deploy mynginx -o yaml  # show deployment info for the mynginx deployment

kubectl describe deploy mynginx  # show info for the mynginx deployment

# Create a deployment that creates a pod with a single instastance:
kubectl create deployment single-container-catlb --image mkorangestripe/loadbalancer:1.3.0

kubectl create -f mynginx.yaml  # create a deployment from file

# Create an nginx deployment (just a pod in this case) in the development namespace:
kubectl --namespace=development run nginx --image=nginx

# Create and attach to a pod from a busybox image:
kubectl run -i --tty --image busybox dns-test --restart=Never /bin/sh

kubectl rollout status deployment/single-container-catlb-deployment  # get the deployment rollout status

kubectl delete deployment single-container-catl  # delete the deployment

kubectl delete namesspaces development  # delete everything under the development namespace
```

### PetSets

* Stateful pods treated as clustered applications. 
* Decouple dependency on hardware/infrastructure by assigning identities to individual instances of an application.

### Anotations

* Used for non-identifying info (not internal data used by Kubernetes).
* Used to provide info for users or external tools.
```Shell script
kubectl annotate deploy mynginx description='deployment for testing my replication sets'
```

### Labels & Selectors
* Used for selecting objects.
* Can be added/modified during or after creation of objects.
* Each key must be unique for an object.
```Shell script
kubectl label pods --all status=unhealthy  # add label of status=unhealthy to all pods
kubeclt label --overwrite pods --all status=healthy  # overwrite the status label for all pods
```

### Logs

```Shell script
kubectl logs hello-7f5c49b6c6-ct86z  # logs for the pod
kubectl logs -n zpc fakeapp-6d4c445dc8-rjps9  # logs for the pod in the zpc namespace
kubectl logs -n zpc voyager-fakeapp-ingress-6cddc864f5-84ksf --container haproxy
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