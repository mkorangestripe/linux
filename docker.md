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

docker version #  show version info
docker info  # Display system-wide information

docker system df  # show docker disk usage

docker system prune  # remove various docker items
```

### Docker networks
```shell script
docker network ls  # list networks
docker network inspect lb1  # show info for the network
docker network connect lb1 cat_loadbalancer  # connect the container to lb1 network
docker network create lb2  # create the network
docker network rm lb2  # remove the network
```

### Docker images
```shell script
docker pull centos  # Pull a centos image
docker pull harbor.somedomain.io/prlb-platform/util-chefdk:latest  # Pull latest image from private registry

docker images  # list images
docker image ls  # list images, new style
docker images --no-trunc  # list images, no truncate image ID
docker image history nginx  # show history for image 'nginx'
docker image inspect centos | grep CMD  # show command the container will run
docker rmi 4ab4c602aa5e  # delete image with given image ID

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
docker build -t hello1 .  # build image from Dockerfile and name 'hello1'
packer build packer/hello1.json  # build image using packer
docker build -t mkorangestripe/loadbalancer:1.1.0 .  # build image including repo in name
docker build -t harbor.somedomain.io/prlb-platform/test1 .  # build image including registry and repo in name
```

##### Push to a registry
```shell script
docker push localhost:5000/hello  # push in local registry, Linux
docker push host.docker.internal:5000/hello  # push in local registry, OSX
docker push mkorangestripe/loadbalancer:1.1.0  # push to dockerhub
docker push harbor.somedomain.io/prlb-platform/test1  # push to harbor
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

# Show docker logs for hello1 container:
docker logs hello1
```

```shell script
# Run a docker container with Ubuntu 16.04 & get a command prompt, either of the following:
docker run -it ubuntu:16.04
docker container run -it ubuntu:16.04

# Run a Centos container and get a Bash prompt, remove upon exit:
docker run --rm -it centos:latest bash

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
docker-compose ps  # process state of containers started by docker-compose, -a for all
docker-compose up  # create and start containers
docker-compose up -d  # detached mode
docker-compose down #  stop containers and remove resources
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
