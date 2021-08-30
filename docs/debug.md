# Debugging

## Things to Check

* RAM utilization -- aliaswalletd is very hungry and typically needs in excess of 1GB.  A swap file might be necessary.
* Disk utilization -- The Alias blockchain will continue growing and growing and growing.  Then it will grow some more.  At the time of writing, 5GB+ is necessary.

## Viewing aliaswalletd Logs

    docker logs aliaswalletd-node


## Running Bash in Docker Container

*Note:* This container will be run in the same way as the aliaswalletd node, but will not connect to already running containers or processes.

    docker run -v alias-data:/alias --rm -it aliascash/docker-aliaswalletd bash -l

You can also attach bash into running container to debug running aliaswalletd

    docker exec -it aliaswalletd-node bash -l


