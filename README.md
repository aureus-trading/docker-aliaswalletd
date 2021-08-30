Aliaswalletd for Docker
=======================

[![Docker Stars](https://img.shields.io/docker/stars/aliascash/docker-aliaswalletd.svg)](https://hub.docker.com/r/aliascash/docker-aliaswalletd/)
[![Docker Pulls](https://img.shields.io/docker/pulls/aliascash/docker-aliaswalletd.svg)](https://hub.docker.com/r/aliascash/docker-aliaswalletd/)
[![ImageLayers](https://images.microbadger.com/badges/image/aliascash/docker-aliaswalletd.svg)](https://microbadger.com/#/images/aliascash/docker-aliaswalletd)

Docker image that runs the Alias daemon node in a container for easy deployment.

This is a fork of [kylemanna/docker-bitcoind](https://github.com/kylemanna/docker-bitcoind), thx for the great work!

Requirements
------------

* Physical machine, cloud instance, or VPS that supports Docker (i.e. [Vultr](http://bit.ly/1HngXg0), [Digital Ocean](http://bit.ly/18AykdD), KVM or XEN based VMs) running Ubuntu 14.04 or later (*not OpenVZ containers!*)
* At least 10 GB to store the block chain files (and always growing!)
* At least 2 GB RAM + 2 GB swap file

Recommended and tested on unadvertised (only shown within control panel) [Vultr SATA Storage 1024 MB RAM/250 GB disk instance @ $10/mo](http://bit.ly/vultrbitcoind).  Vultr also *accepts Bitcoin payments*!


Really Fast Quick Start
-----------------------

One liner for Ubuntu 14.04 LTS machines with JSON-RPC enabled on localhost and adds upstart init script:

    curl https://raw.githubusercontent.com/aliascash/docker-aliaswalletd/master/bootstrap-host.sh | sh -s trusty


Quick Start
-----------

1. Create a `alias-data` volume to persist the Alias blockchain data, should exit immediately.  The `alias-data` container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):

        docker volume create --name=alias-data
        docker run -v alias-data:/alias --name=aliaswalletd-node -d \
            -p 37347:37347 \
            -p 127.0.0.1:36657:36657 \
            aliascash/docker-aliaswalletd

2. Verify that the container is running and aliaswalletd node is downloading the blockchain

        $ docker ps
        CONTAINER ID        IMAGE                         COMMAND             CREATED             STATUS              PORTS                                              NAMES
        d0e1076b2dca        aliascash/docker-aliaswalletd:latest     "alias_oneshot"       2 seconds ago       Up 1 seconds        127.0.0.1:36657->36657/tcp, 0.0.0.0:37347->37347/tcp   alias-node

3. You can then access the daemon's output thanks to the [docker logs command]( https://docs.docker.com/reference/commandline/cli/#logs)

        docker logs -f aliaswalletd-node

4. Install optional init scripts for upstart and systemd are in the `init` directory.


Documentation
-------------

* Additional documentation in the [docs folder](docs).
