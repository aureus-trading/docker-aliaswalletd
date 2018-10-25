# Debugging

## Things to Check

* RAM utilization -- spectrecoind is very hungry and typically needs in excess of 1GB.  A swap file might be necessary.
* Disk utilization -- The spectrecoin blockchain will continue growing and growing and growing.  Then it will grow some more.  At the time of writing, 40GB+ is necessary.

## Viewing spectrecoind Logs

    docker logs spectrecoind-node


## Running Bash in Docker Container

*Note:* This container will be run in the same way as the spectrecoind node, but will not connect to already running containers or processes.

    docker run -v spectrecoind-data:/spectrecoin --rm -it spectreproject/spectrecoind bash -l

You can also attach bash into running container to debug running spectrecoind

    docker exec -it spectrecoind-node bash -l


