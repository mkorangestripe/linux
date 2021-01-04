# Google Kubernetes Engine notes

### Google Cloud Compute (GCP) services

* Google Compute Engine - Infrastructure as a Service, hosts virtual machines

* Google Kuberbnetes Engine (GKE) - managed orchestrated environment for containerized apps
  * Clusters are made up of a master node and one or more worker node
  * Node Pools are a subset of nodes in the cluster which share configuration
  * Worker nodes are Google Compute Engine VM's which run Kubernetes pods
  * Pods are groups of Docker containers and share IP addresses and hostnames
  * Traffic to the pods is controlled by the Kubernetes master
  * Docker containers are stored in the Container Registry

* Google App Engine - Platform as a Service, hosts web apps

* Google Cloud Functions - serverless execution environment, single-purpose functions that are attached to events.
  * Triggers: HTTP requests, Cloud Storage even, Pub/Sub event
  * Uses: Webhooks, data & image processing, mobile back end, IOT apps

### Kubernetes Master Node
* Kubernetes API Server
* etcd: the distributed key-value store which holds all cluster data
* Core Resource Controller: manages cpu, memory, and network resources for all worker nodes
* Scheduler: watches pods and decides which node to place them on based on resources and policies

### Clusters, Deployments
```shell script
# Create a cluster in GCP:
gcloud containter clusters create k1

# List gke clusters:
gcloud container clusters list

# Show cluster info:
gcloud container clusters describe la-gke-1

# Create a simple deployment:
kubectl run app --image gcr.io/google-sample/hello-app:1.0

# Scale the deployment to 4 pods:
kubectl scale deployment app --replicas 4

# Open port 80 to the deployment (app):
kubectl expose deployment app --port 80 --type=LoadBalancer

# Show the services associated with the deployment:
kubectl get service app

# Update the deployment to a new version:
kubectl set image deployment app app=gcr.io/google-sample/hello-app:2.0

# Resize the cluster:
gcloud container clusters resize ls-containers-cluster-1 --zone us-east4-a --node-pool default-pool --size 8

# Resize the deployment to 4 Nodes (Compute Engine VM's):
kubectl scale deployment nginx-1 --replicas 4

# The above can also be done in the config.yaml file and with the following command.
# These increases do not persist unless the 'maxSurge' value is also set in the config file.
kubectl apply -f config.yaml

# Delete the cluster:
gcloud container clusters delete ls-containers-cluster-1
```

### Cluster Upgrades
```shell script
# Upgrade the master node to specified version:
gcloud container clusters upgrade la-containers-cluster-1 --master --cluster-version 1.10.5-gke.4

# Upgrade all nodes to the latest version:
gcloud container clusters upgrade la-containers-cluster-1

# Enable autoupgrade for a pool:
gcloud container node-pools update default-pool --cluster la-containers-cluster-1 --no-ebable-autoupgrade
```

### Role Based Access Control (RBAC)
* Focused more on authorization than authentication
* More targeted permissions
```shell script
# Get roles:
kubectl get roles --all-namespaces

# Create role:
kubectl create role pod-reader --verb=get --verb=list --verb=watch --resource=pods --namespace=ns-1

# Create rolebinding:
kubectl create rolebinding accoutn1-pod-reader-binding --role=pod-reader --user=$account1 --namespace=ns-1

# Create cluster rolebinding named 'cluster-admin' for the specified user:
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user mike@domain1.com

# Create the clusterrole:
kubectl apply -f lac1-clusterrole.yaml

# Create the namespace 'ns-lac1':
kubectl create namespace ns-lac1

# Create the rolebinding:
kubectl apply -f lac1-rolebinding.yaml
```

### Pod Security Policy
```shell script
# Get credentials:
gcloud container clusters get-credentials la-psp-cluster-1 --zone us-central1-a --project la-containers-001

# Get saved credentials:
export GOOGLE_APPLICATION_CREDENTIALS=~/.gcp/xxxxx.json

# Create the configured resource, this does not enable:
kubectl apply -f la-psp.yaml

# Get the pod security policy:
kubectl get psp

# Update pod security policy:
gcloud beta container clusters update la-psp-cluster-1 --zone us-central1-a --enable-pod-security-policy

# Disable pod security policy:
gcloud beta container clusters update la-psp-cluster-1 --zone us-central1-a --no-enable-pod-security-policy
```

### Security Protocols
```shell script
# Rotate IP addresses of the nodes in the cluster:
gcloud container clusters update ip-rotation-cluster-1 --start-ip-rotation
gcloud container clusters update ip-rotatoin-cluster-1 --complete-ip-rotation

# Rotate IP and credentials on the nodes in the cluster:
gcloud container clusters update credentials-rotation-cluster-1 --start-credential-rotation
gcloud container clusters update credentials-rotation-cluster-1 --complete-credential-rotation

# Disable Attribute Based Access Control (ABAC):
gcloud container clusters update la-psp-cluster-1 --no-enable-legacy-authorization

# Add network policy for pod-to-pod communication:
gcloud container clusters create la-psp-cluster-1 zone=us-central1-a --enable-network-policy
```

### Connecting to Google Cloud Pub/Sub Service
```shell script
# GCP > Big Data > Pub/Sub > Topics > Create a topic
# Create subscription

# Create the pubsub resource:
# With 'name: pubsub', 'app: pubsub', etc.
kubectl apply -f deployment.yaml

# Create a service account:
# GCP > IAM & admin > Service accounts
# Role: Pub/Sub Subscriber

# Create secret key:
# Create key.json and paste in code from key created above.
kubectl create secret generic pubsub-key --from-file=key.json=key.json
# Remember to delete the downloaded key.json

# The key.json file including path is referenced in something like deployment-secrets.yaml...
# with the GOOGLE_APPLICATION_CREDENTIALS environment variable.

# Apply the configuration:
kubectl apply -f deployment-secrets.yaml

# Check for the new app:
kubectl get pods -l app=pubsub
# This should show a status of 'running'

# Test the new app:
# GCP > Pub/Sub > Publish message:
# Enter a test message
kubectl logs -l app=pubsub
# The test message should appear after 'Data=b'
```

### Create a Kubernetes Cluster in GCP
Activate the Kubernetes Engine API:  
GCP > API & Services > Library > Kubernetes Engine API > Enable

Activate the Cloud Shell:  
GCP > Home > icon in upper right

```shell script
# Build a Docker image:
git clone https://github.com/linuxacademy/content-gc-essentials
cd content-gc-essentials/gke-lab-01/
docker build -t la-container-image .

# Configure Docker command line to authenticate to the Docker registry:
gcloud auth configure-docker

# Tag the registry image and push:
docker tag la-container-image gcr.io/creating-and-61-03b99d/la-container-image:v1
docker push gcr.io/creating-and-61-03b99d/la-container-image:v1

# Configure the compute zone:
gcloud config set compute/zone us-central1-a

# Create the cluster:
gcloud container clusters create la-gke-1 --num-nodes=4

# Get credentials for the cluster:
gcloud container clusters get-credentials la-gke-1

# Deploy the app:
kubectl run la-greetings --image=gcr.io/creating-and-61-03b99d/la-container-image:v1 --port=80

# Expose the deployment:
kubectl expose deployment la-greetings --type=LoadBalancer --name=la-greetings-service --port=80 --target-port=80

# Check its status:
kubectl get services la-greetings-service
```
