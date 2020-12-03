# Docker Notes

###### Install Docker CE (Comunity Edition) on Redhat/Centos
```shell
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce
```

###### Docker related system info
```shell
systemctl status docker # status of docker service
systemctl enable docker # enable the docker service
systemctl start docker # start the docker service
systemctl show docker # env variables used by docker
```

```shell
docker info # display system-wide information
```

```shell
docker logs hello1 # show docker logs for hello1 container
```

###### Docker images
```shell
docker pull centos # pull a centos image
docker pull harbor.somedomain.io/prlb-platform/util-chefdk:latest # pull latest image from private registry

docker images # list images
docker image ls # list images, new style
docker image history nginx # show history for image 'nginx'
docker images --no-trunc # do not truncate the image ID
docker rmi 4ab4c602aa5e # delete docker image with given image ID
```

###### Tag an image, either of the following
```shell
docker tag 311d49c8619b dtest1:v1
docker image tag 311d49c8619b dtest1:v1
```

###### Remove image tag, but leave image if other tags for the same image exist otherwise delete image.
```shell
docker rmi hello-socket host.docker.internal:5000/hello-socket2
```

###### Dockerfile example, each line is a layer
```
FROM ubuntu:16.04
LABEL maintainer=<email_address>
RUN sh -c 'mkdir /mnt/fakeapp'
COPY deploy/fakeapp/mount/logback-deployment.xml /mnt/fakeapp/
RUN apt-get update
RUN apt-get install -y python3
```

###### Build Docker image, examples
```shell
mvn package # build a JAR file from the pom.xml file
docker build . # build an image from the Dockerfile
docker build -t hello1 . # build and name image ‘hello1’
packer build packer/hello.json # build image using packer
docker build -t harbor.somedomain.io/prlb-platform/test1 . # build with repo in name
```

###### Push to a registry
```shell
docker push localhost:5000/hello # Linux
docker push host.docker.internal:5000/hello # OSX
docker push harbor.somedomain.io/prlb-platform/test1
```

##### Docker image registry login
```shell
docker login harbor.somedomain.io
docker logout
```

###### List running containers, either of the following
```shell
docker ps
docker container ls
```

###### List all containers, either of the following
```shell
docker ps -a
docker container ls -a
```

###### Find the IP address of a container
```shell
docker container inspect 8a5b3f2103ec | grep IPAdd
```

###### List volumes
```shell
docker volume ls
```

###### Run a docker container with Ubuntu 16.04 and get a command prompt (either of the following)
```shell
docker run -it ubuntu:16.04
docker container run -it ubuntu:16.04
```

###### Run a Centos container and get a Bash prompt
```shell
docker run -it centos:latest bash
```

###### Run a Centos container and 'cat /etc/redhat-release'
```shell
docker run centos cat /etc/redhat-release
```

###### Run a Docker container from image starting with image id 31 and get a command prompt
```shell
docker run -it --name python-container 31
```

###### Run an Nginx container, detached mode, publish ports
```shell
docker run -d -P nginx
```

###### Run an httpd container, detached mode, specify port mapping
```shell
docker run -d -p 80:80 httpd
```

###### Start a stopped container, either of the following.  Container will exit if not running a process.
```shell
docker start c2ffbff64f14
docker container start c2ffbff64f14
```

###### Execute the command on the running container, either of the following
```shell
docker exec c2ffbff64f14 cat /etc/*release
docker container exec c2ffbff64f14 cat /etc/*release
```

###### Attached to a container by container ID, either of the following
```shell
docker attach c2f
docker container attach c2f
```

###### Stop a container, either of the following
```shell
docker stop c2ffbff64f14
docker container stop c2ffbff64f14
```

###### Delete docker container by container ID, either of the following
```shell
docker rm aec6fa285527
docker container rm aec6fa285527
```

##### Docker Swarm Manager
```shell
docker node ls | grep us08st2con98
docker node update --availability drain us08st2con91
docker service ls
docker node rm us08st2con91
```
