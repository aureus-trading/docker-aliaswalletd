Spectrecoind for Docker
===================

[![Docker Stars](https://img.shields.io/docker/stars/spectreproject/spectrecoind.svg)](https://hub.docker.com/r/spectreproject/spectrecoind/)
[![Docker Pulls](https://img.shields.io/docker/pulls/spectreproject/spectrecoind.svg)](https://hub.docker.com/r/spectreproject/spectrecoind/)
[![Build Status](https://travis-ci.org/spectreproject/docker-spectrecoind.svg?branch=master)](https://travis-ci.org/spectreproject/docker-spectrecoind/)
[![ImageLayers](https://images.microbadger.com/badges/image/spectreproject/spectrecoind.svg)](https://microbadger.com/#/images/spectreproject/spectrecoind)

Docker image that runs the Spectrecoin spectrecoind node in a container for easy deployment.


Requirements
------------

* Physical machine, cloud instance, or VPS that supports Docker (i.e. [Vultr](http://bit.ly/1HngXg0), [Digital Ocean](http://bit.ly/18AykdD), KVM or XEN based VMs) running Ubuntu 14.04 or later (*not OpenVZ containers!*)
* At least 100 GB to store the block chain files (and always growing!)
* At least 1 GB RAM + 2 GB swap file

Recommended and tested on unadvertised (only shown within control panel) [Vultr SATA Storage 1024 MB RAM/250 GB disk instance @ $10/mo](http://bit.ly/vultrbitcoind).  Vultr also *accepts Bitcoin payments*!


Really Fast Quick Start
-----------------------

One liner for Ubuntu 14.04 LTS machines with JSON-RPC enabled on localhost and adds upstart init script:

    curl https://raw.githubusercontent.com/spectreproject/docker-spectrecoind/master/bootstrap-host.sh | sh -s trusty


Quick Start
-----------

1. Create a `spectrecoind-data` volume to persist the spectrecoind blockchain data, should exit immediately.  The `spectrecoind-data` container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):

        docker volume create --name=spectrecoind-data
        docker run -v spectrecoind-data:/spectrecoin --name=spectrecoind-node -d \
            -p 8333:8333 \
            -p 127.0.0.1:8332:8332 \
            spectreproject/spectrecoind

2. Verify that the container is running and spectrecoind node is downloading the blockchain

        $ docker ps
        CONTAINER ID        IMAGE                         COMMAND             CREATED             STATUS              PORTS                                              NAMES
        d0e1076b2dca        spectreproject/spectrecoind:latest     "spectrecoin_oneshot"       2 seconds ago       Up 1 seconds        127.0.0.1:8332->8332/tcp, 0.0.0.0:8333->8333/tcp   spectrecoind-node

3. You can then access the daemon's output thanks to the [docker logs command]( https://docs.docker.com/reference/commandline/cli/#logs)

        docker logs -f spectrecoind-node

4. Install optional init scripts for upstart and systemd are in the `init` directory.


Documentation
-------------

* Additional documentation in the [docs folder](docs).
