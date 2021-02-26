# Docker Notes

##### Install Docker CE (Comunity Edition) on Redhat/Centos
```shell script
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce
```

### Docker related system info
```shell script
systemctl status docker  # Status of docker service
systemctl enable docker  # Enable the docker service
systemctl start docker  # Start the docker service
systemctl show docker  # Environment variables used by docker

docker info  # Display system-wide information

docker logs hello1  # Show docker logs for hello1 container

docker network ls  # list networks
```

### Docker images
```shell script
docker pull centos  # Pull a centos image
docker pull harbor.somedomain.io/prlb-platform/util-chefdk:latest  # Pull latest image from private registry

docker images  # List images
docker image ls  # List images, new style
docker image history nginx  # Show history for image 'nginx'
docker images --no-trunc  # Do not truncate the image ID
docker rmi 4ab4c602aa5e  # Delete docker image with given image ID

# Tag an image, either of the following:
docker tag 311d49c8619b dtest1:v1
docker image tag 311d49c8619b dtest1:v1

# Remove image tag, but leave image if other tags for the same image exist otherwise delete image:
docker rmi hello-socket host.docker.internal:5000/hello-socket2
```

##### Dockerfile example, each line is a layer
```
FROM ubuntu:16.04
LABEL maintainer=<email_address>
RUN sh -c 'mkdir /mnt/fakeapp'
COPY deploy/fakeapp/mount/logback-deployment.xml /mnt/fakeapp/
RUN apt-get update
RUN apt-get install -y python3
```

##### Build Docker image, examples
```shell script
mvn package  # Build a JAR file from the pom.xml file
docker build .  # Build an image from the Dockerfile
docker build -t hello1 .  # Build and name image ‘hello1’
packer build packer/hello.json  # Build image using packer
docker build -t harbor.somedomain.io/prlb-platform/test1 .  # Build with repo in name
```

##### Push to a registry
```shell script
docker push localhost:5000/hello  # Linux
docker push host.docker.internal:5000/hello  # OSX
docker push harbor.somedomain.io/prlb-platform/test1
```

##### Docker image registry login
```shell script
docker login harbor.somedomain.io
docker logout
```

### Docker containers

```shell script
# List running containers, either of the following:
docker ps
docker container ls

# List all containers, either of the following:
docker ps -a
docker container ls -a

# Find the IP address of a container:
docker container inspect 8a5b3f2103ec | grep IPAdd

# List volumes:
docker volume ls
```

```shell script
# Run a docker container with Ubuntu 16.04 & get a command prompt, either of the following:
docker run -it ubuntu:16.04
docker container run -it ubuntu:16.04

# Run a Centos container and get a Bash prompt:
docker run -it centos:latest bash

# Run a Centos container and 'cat /etc/redhat-release'
docker run centos cat /etc/redhat-release

# Run a Docker container from image starting with image id 31 and get a command prompt:
docker run -it --name python-container 31

# Run an Nginx container, detached mode, publish ports:
docker run -d -P nginx

# Run an httpd container, detached mode, specify port mapping:
docker run -d -p 80:80 httpd
```

```shell script
# Start a stopped container, either of the following.  Container will exit if not running a process.
docker start c2ffbff64f14
docker container start c2ffbff64f14

# Execute the command on the running container, either of the following:
docker exec c2ffbff64f14 cat /etc/*release
docker container exec c2ffbff64f14 cat /etc/*release

# Attached to a container by container ID, either of the following:
docker attach c2f
docker container attach c2f

# Stop a container, either of the following:
docker stop c2ffbff64f14
docker container stop c2ffbff64f14

# Delete docker container by container ID, either of the following:
docker rm aec6fa285527
docker container rm aec6fa285527
```

### Docker Swarm

```shell script
# Run from manager node:
docker node ls | grep us08st2con98
docker node update --availability drain us08st2con91
docker service ls
docker node rm us08st2con91
```
