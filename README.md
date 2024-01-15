Run `./deploy.sh` on the server you want to deploy librenms on. Here is what it does
- builds a custom librenms docker container
- executes a custom docker compose script to start the containers necessary for librenms
- copies the rrd folder from the currently running librenms server (10.0.1.12) to the local container

This script relies on the server running this deploy script to have ssh access to 10.0.1.12 (the currently running librenms server)

prereqs:
- docker is installed
- unzip is installed

There will be 2 folders inside the checkout out repository `scn-librenms-compose` called `db` and `librenms`. These should not be messed with since these are what the containers use for stuff

