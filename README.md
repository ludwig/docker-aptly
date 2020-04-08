# docker-aptly

**docker-aptly** is container w `aptly` backed by `nginx`.

**aptly** is a swiss army knife for Debian repository management: it allows you to mirror remote repositories, manage local package repositories, take snapshots, pull new versions of packages along with dependencies, publish as Debian repository. More info are on [aptly.info](http://aptly.info) and on [github](https://github.com/aptly-dev/aptly).

**nginx** is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP proxy server, originally written by Igor Sysoev. More info is on [nginx.org](http://nginx.org/en/). It project use `supervisor` to run `nginx`. `supervisor` in docker allow to manage multiple processes in a container.

## Quickstart

The following command will download preparing image from dockerhub and run `aptly` and `nginx` in a container:

```bash
docker run \
  --detach=true \
  --log-driver=syslog \
  --restart=always \
  --name="aptly" \
  --publish 80:80 \
  --volume $(pwd)/aptly_files:/opt/aptly \
  --env FULL_NAME="First Last" \
  --env EMAIL_ADDRESS="youremail@example.com" \
  --env GPG_PASSWORD="PickAPassword" \
  smirart/aptly:latest
```

For stop container use:

```bash
docker stop aptly
```

### Explane of the flags

Flag | Description
--- | ---
`--detach=true` | Run the container in the background
`--log-driver=syslog` | Send nginx logs to syslog on the Docker host  (requires Docker 1.6 or higher)
`--restart=always` | Automatically start the container when the Docker daemon starts
`--name="aptly"` | Name of the container
`--volume $(pwd)/aptly:/opt/aptly` | Path that aptly will use to store its data : mapped path in the container
`--publish 80:80` | Docker host port : mapped port in the container
`--env FULL_NAME="First Last"` | The first and last name that will be associated with the GPG apt signing key
`--env EMAIL_ADDRESS="your@email.com"` | The email address that will be associated with the GPG apt signing key
`--env GPG_PASSWORD="PickAPassword"` | The password that will be used to encrypt the GPG apt signing key

### Build & run locally

If you want to build and run locally I suggest to you use `docker-compose.yml`:

```bash
docker-compose up -d
```

It command build `aptly` image and run container by same name.

### Troubleshooting w same container name

May be conflict if you already pull aptly from docker hub:

> ERROR: for aptly  Cannot create container for service aptly: Conflict. The container name "/aptly" is already in use by container "85de5904f6fc73c04f4f8e7d08a09a1a63c2ba28afb5ce45aa9578ebdefeadc7". You have to remove (or rename) that container to be able to reuse that name.

In this situation you need remove currently aptly container (or rename it):

```bash
docker rm 85de5904f6fc73c04f4f8e7d08a09a1a63c2ba28afb5ce45aa9578ebdefeadc7
```

### Manage of docker-compose

```bash
git clone https://github.com/urpylka/docker-aptly
cd docker-aptly/

# Build and up
docker-compose up -d

# Remove and down
docker-compose down

# Start containers
docker-compose start

# Restart containers
docker-compose restart

# Stop containers
docker-compose stop
```

## Setup a client for use your repo

1. Fetch the public PGP key from your aptly repository and add it to your trusted repositories

    ```bash
    wget http://YOUR_HOST_FOR_APTLY/aptly_repo_signing.key
    apt-key add aptly_repo_signing.key
    ```

2. Backup then replace /etc/apt/sources.list

    ```bash
    cp /etc/apt/sources.list /etc/apt/sources.list.bak
    echo "deb http://YOUR_HOST_FOR_APTLY/ ubuntu main" > /etc/apt/sources.list
    apt-get update
    ```

    > `ubuntu` & `main` may be another. It's require from your repos on aptly.

## Configure the repository

For attach to the container and start to configure your aptly use:

```bash
docker exec -it aptly /bin/bash
```

Create repo:

```bash
# Create repository folder
aptly repo create -comment="ROS packages for Raspbian Stretch" -component="main" -distribution="stretch" rpi-ros-kinetic

# Add deb-packages to index from `/opt/aptly/ros-kinetic-*`
aptly repo add rpi-ros-kinetic /opt/aptly/ros-kinetic-*

# Publish updates
aptly publish repo rpi-ros-kinetic rpi-ros-kinetic
```

Add new packages:

```bash
# Add deb-packages to index from `/opt/aptly/ros-kinetic/`
aptly repo add rpi-ros-kinetic /opt/aptly/ros-kinetic/

# Publish updates
aptly publish update stretch rpi-ros-kinetic
```

Read [the official documentation](https://www.aptly.info/doc/overview/) for learn more about aptly.

### Create a mirror of Ubuntu's main repository

1. Attach to the container. How attach? See [Configure the container](#configure-the-container).
2. Run `/opt/update_mirror_ubuntu.sh`.

By default, this script will automate the creation of an Ubuntu 14.04 Trusty repository with the main and universe components, you can adjust the variables in the script to suit your needs.

> If the script fails due to network disconnects etc, just re-run it.

 The initial download of the repository may take quite some time depending on your bandwidth limits, it may be in your best interest to open a screen, tmux or byobu session before proceeding.

> For host a mirror of Ubuntu's main repository, you'll need upwards of 80GB+ (x86_64 only) of free space as of Feb 2016, plan for growth.

When the script completes, you should have a functional mirror that you can point a client to.

For create Debian's mirror use `/opt/update_mirror_debian.sh`.

## Building the container

If you want to customize image or build the container locally, check out this repository and build after:

```bash
git clone https://github.com/urpylka/docker-aptly.git
docker build docker-aptly
```

Also you can use just `docker-compose` commands. It will be building own images before use.

## How this image/container works

**Data**
All of aptly's data (including PGP keys and GPG keyrings) is bind mounted outside of the container to preserve it if the container is removed or rebuilt.

**Networking**
By default, Docker will map port 80 on the Docker host to port 80 within the container where nginx is configured to listen. You can change the external listening port to map to any port you like. (See [Explane of the flags](#explane-of-the-flags)).

**Security**
The GPG password which you specified in `GPG_PASSWORD` is stored in plain text and visible as an environment variable inside the container.
It is set as an enviornment variable to allow for automation of repository updates without user interaction. The GPG password can be removed completely but it is safer to encrypt the GPG keyrings because they are bind mounted outside the container to avoid the necessity of regenerating/redistributing keys if the container is removed or rebuilt.

___

* Copyright 2018-2020 Artem B. Smirnov
* Copyright 2016 Bryan J. Hong
* Licensed under the Apache License, Version 2.0
