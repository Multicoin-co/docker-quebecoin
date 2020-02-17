Quebecoind for Docker
===================

Docker image that runs the Quebecoin quebecoind node in a container for easy deployment.


Quick Start
-----------

1. Create a `quebecoind-data` volume to persist the quebecoind blockchain data, should exit immediately.  The `quebecoind-data` container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):

        docker volume create --name=quebecoind-data
        docker run -v quebecoind-data:/quebecoin --name=quebecoind-node -d ahmedbodi/quebecoin

2. Verify that the container is running and quebecoind node is downloading the blockchain

        $ docker ps
        CONTAINER ID        IMAGE                           COMMAND         CREATED             STATUS              PORTS                                              NAMES
        d0e1076b2dca        ahmedbodi/quebecoin:latest      "oneshot"       2 seconds ago       Up 1 seconds        127.0.0.1:8332->8332/tcp, 0.0.0.0:8333->8333/tcp   quebecoin-node

3. You can then access the daemon's output thanks to the [docker logs command]( https://docs.docker.com/reference/commandline/cli/#logs)

        docker logs -f quebecoind-node
