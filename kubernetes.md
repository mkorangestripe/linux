# Kubernetes Notes

### minikube
```Shell script
minikube start  # start minikube cluster
minikube stop  # stop minikube cluster
minikube delete  # delete the minikube cluster
minikube addons enable registry  # enable docker registry
```

### kubectl
```Shell script
kubectl config current-context  # get project, zone, cluster
kubectl config get-contexts  # get contexts

kubectl get namespaces  # get namespaces
kubectl get po  # get running pods in the cluster
kubectl get po -n kube-system  # get pods running in the "kube-system" namespace
kubectl get po -n zpc | grep fakeapp
kubectl get svc -n kube-system  # show the service resource associated with the registry
kubectl get svc -n zpc | grep fakeapp
kubectl get deploy  # get the deployment

# Get api-resources, ingress service info
kubectl api-resources | grep ingress
kubectl get ingresses.voyager.appscode.com -n zpc

kubectl describe po hello  # list the containers in the pod
kubectl describe svc -n zpc fakeapp  # info on the fakeapp service
kubectl describe ingresses.voyager -n zpc fakeapp-ingress  # find external IP and hostname
```

```Shell script
# Enable port forwarding from local 5000 to port 80 on the cluster and verify:
kubectl port-forward -n kube-system svc/registry 5000:80 &> /dev/null &
curl localhost:5000/v2/_catalog # {"repositories":["hello"]}

# Enable port forwarding for port 8080
kubectl port-forward -n zpc po/fakeapp-6d4c445dc8-9xz66 8080
```

```Shell script
# Tag and push the image to the local registry, on OSX
# Note, insecure registries must be enabled in Docker.
docker tag hello host.docker.internal:5000/hello
docker push host.docker.internal:5000/hello

# Tag and push the image to GCP
docker tag hello-socket us.gcr.io/xxx-xx-xx/hello-socket:gp-1
docker push us.gcr.io/xxx-xx-xx/hello-socket:gp-1

# Pull from the local registry, on OSX
docker pull host.docker.internal:5000/hello

# Start a docker container, use the bridge network
docker run -d --name hello-bridge host.docker.internal:5000/hello-socket bridge

# Create a deployment.app which sets up a basic pod with a single instastance.
kubectl create deployment --image localhost:5000/hello hello

# Create a new pod described in the yaml file.
kubectl apply -f deploy/pod-multi.yaml

# Delete the deployment
kubectl delete deploy hello

# Logs for the pod
kubectl logs hello-7f5c49b6c6-ct86z
kubectl logs -n zpc fakeapp-6d4c445dc8-rjps9
kubectl logs -n zpc voyager-fakeapp-ingress-6cddc864f5-84ksf --container haproxy
```

```Shell script
# Create a pod directly
kubectl apply -f deploy/pod-args.yaml

# Attach to a pod
kubectl exec -it hello bash
kubectl exec -it -n zpc fakeapp-6d4c445dc8-rjps9 /bin/sh

# Delete the pod
kubectl delete po hello
```

### helm
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
