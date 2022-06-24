# Kubernetes Notes

Control Plane / Master
* Container orchestration layer that exposes the API and interfaces.
* Manages the worker nodes and the pods.
* In production, runs across multiple nodes in the cluster.
* Control plane components:
  * API server
  * etcd
  * scheduler
  * controller manager

API server
* Front end for the Kubernetes control plane.
* Validates and configures data for the api objects which include pods, services.

etcd
* Runs on an odd number of machines, commonly 5 to 7.
* A five member cluster can tolerate up to 2 member failures.
* The leader receives config changes and fsyncs the proposal to the other members.
* When the leader receives confirmation from a quorum, the proposal is approved, and the changes are stored.
* A Quorum is a majority (half the members plus one) of cluster members in agreement.
* Consensus by quorum is reached by the raft protocol.

Scheduler
* Maintains the state of the cluster by assigning workloads to the nodes available to the cluster.

Controller manager
* Runs various controllers that watch the state of the cluster and help to maintain the desired state.
* Job controller checks that the correct number of pods are running.
* Node controller checks that the nodes are healthy.

<br>

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

kubectl get secret/datadog-api -o json  # show base64 encoded API key, namespace, uid, etc
kubectl get secret/datadog-api -o json | jq .data.token | base64 -d -i  # show base64 decoded API key
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
kubectl get po  # list running pods in the cluster
kubectl get po -n kube-system  # list pods running in the kube-system namespace
kubectl get po -n zpc | grep fakeapp  # show the fakeapp pod in the zpc namespace
kubectl get pods -w  # watch state of pods

kubectl get pods -l run=mynginx -o wide  # list pods with label run=mynginx, wide output
kubectl get pods -l tier=backend -o wide  # list pods with label tier=backend, wide output

kubectl get pods --show-all  # list all pods including completed
kubectl get pods --show-all --selector=job-name=pi --output=jsonpath='{.itmes..metadata.name}'

# Get pods, filter by NAME column:
kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep datadog

# Get counts of pods by status:
kubectl get pods --no-headers | awk {'print $3'} | datamash -s -g 1 count 1

kubectl describe po hello  # list the containers in the pod

kubectl exec datadog-agent-khj9q -- agent status  # run the 'agent status' command on the pod

# Attach to a pod:
kubectl exec -it hello bash
kubectl exec -it hello -- /bin/bash
kubectl exec -it -n zpc fakeapp-6d4c445dc8-rjps9 /bin/sh
kubectl exec -it my-pod --container main-app -- /bin/bash  # attach to a specific container

kubectl delete po hello  # delete the hello pod
kubectl delete po -l app=nginx  # delete a pod with the app=nginx label
```

### Services

* Services define a logical set of pods and a policy by which to access them.
* The set of Pods targeted by a Service is usually determined by a selector.
* Services allow the pods within to be replaced or modified while maintaining consistent access.
```Shell script
kubectl describe svc -n zpc fakeapp  # show info on the fakeapp service
kubectl get svc -n kube-system  # show the service resource associated with the registry
kubectl get svc -n zpc | grep fakeapp  # show the fakeapp service in the zpc namespace
kubectl get service nginx  # show the nginx service

kubectl expose deployment nginx --target-port=80 --type=NodePort  # create a NodePort service on port 80

kubectl api-resources | grep ingress  # find the ingress service
kubectl get ing basic-ingress  # show the basic-ingress service including IP address
kubectl get ingresses.voyager.appscode.com -n zpc  # show info for the ingress service in the zpc namespace
kubectl describe ingresses.voyager -n zpc fakeapp-ingress  # show info for the ingress service including external IP and hostname
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


# Create an nginx deployment (just a pod in this case) in the development namespace:
kubectl --namespace=development run nginx --image=nginx

# Create a deployment running Apache and expose it as a service:
kubectl run apache --image=k8s.gcr.io/hpa-example --requests=cpu=200m --expose --port=80

# Create and attach to a pod from a busybox image:
kubectl run -i --tty --image busybox dns-test --restart=Never /bin/sh


# Create a deployment from file:
kubectl create -f mynginx.yaml

# Create a deployment that creates a pod with a single instance:
kubectl create deployment single-container-catlb --image mkorangestripe/loadbalancer:1.3.0


# Edit the deployment manifest and update the deployment:
kubectl edit deployment/nginx-deployment

# Update pods to use the latest image version:
kubectl set image deployment/nginx-deployment nginx=nginx

# Create and update resources in the cluser:
kubectl apply -f deployment.yaml

# Get the rollout status of the deployment:
kubectl rollout status deployment/single-container-catlb-deployment

# Get the rollout status of the daemon set:
kubectl rollout status ds fluentd


# Create a horizontal pod autoscaler (HPA) that maintains between 1 and 10 replicas...
# and average cpu utilization of 50% across all pods:
kubectl autoscale deployment apache --cpu-percent=50 --min=1 --max-10

# Show HPA's including target percentages:
kubectl get hpa


kubectl delete deployment single-container-catl  # delete the deployment
kubectl delete namesspaces development  # delete everything under the development namespace
kubectl delete deploy --all  # delete all
```

### PetSets

* Stateful pods treated as clustered applications. 
* Decouple dependency on hardware/infrastructure by assigning identities to individual instances of an application.
* PetSets have been repalced by Stateful Sets.

### Replica Sets

* Use deployments to manage replica sets instead of defining replica sets directly in most cases.
```Shell script
kubectl create -f replication_controller.yaml  # create a replication controller
kubectl describe rc/nginx  # show info on replication controller
kubectl scale rc nginx --replicas=3  # scale the replica set to 3
```

### Stateful Sets

* Manages pods based on an identical container specification but maintains an identity for each pod in the set.
* Each pod has a persistent identifier and is maintained across rescheduling events.
* The desired state is defined in a stateful set object and the controller maintains this state.
* Uses a StatefulSet Controller to update to the desired state.

### Daemon Sets

* Manage groups of replicated pods.
* They try to maintain one pod per node and add pods to new nodes as required.
* Useful for ongoing background tasks like log collection fluentd.
* Use a pod templete.
```Shell script
kubectl get daemonset  # get state of daemon sets
```

### Jobs

* Creates one or more pods and ensures that the specified number successfully terminates.
* The job tracks the successful completions and is itself complete when the specified number is reached.
* Deleting a job, deletes the pods it created. 
```Shell script
kubectl delete jobs --all  # delete all jobs
```

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
helm list  # list deployed releases
helm search fakeapp  # search helm charts in the repo

helm repo list  # list helm repos
helm repo add xxx-xx-xx-charts gs://xxx-xx-xx-helm-repo  # add the helm repo

# Install GCS plugin for helm:
helm plugin install https://github.com/hayorov/helm-gcs --version 0.2.1

helm lint hello  # syntax validation of helm chart

# Validate the template:
helm install --dry-run --debug hello
helm install --dry-run --debug hello --set 'helloArgs[0]=Ben'

# Install a release of the helm chart.
# These will produce a new pod named something like 'nordic-quail-hello' unless specified.
helm install hello
helm install hello --name antlers
helm install hello --set helloArgs[0]=Ben
helm install --set imageRegistry=us.gcr.io/xxx-xx-xx hello
helm install --name hello-gp1 --set imageRegistry=us.gcr.io/xxx-xx-xx --set dockerTag=gp-1 hello-socket

# More helm install examples:
helm install --name fakeapp --namespace zpc spg-zpc-sb-charts/fakeapp
helm install --name fakeapp --namespace zpc spg-zpc-sb-charts/fakeapp --set replicaCount=1 \
--set deployment.environment.productDomain=gp-cluster.zpc-sandbox.xxxxx.com --set deployment.envirionment.type=sandbox

# Upgrade the release:
helm upgrade datadogagent --set datadog.apiKey=$DD_API_KEY --set datadog.appKey=$DD_APP_KEY -f values.yaml datadog/datadog 

# Delete the helm release:
helm delete nordic-quail
helm delete --purge hello-gp1 # and free up the name for later use
```
