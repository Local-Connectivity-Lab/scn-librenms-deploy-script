Run `./deploy.sh` on the server you want to deploy librenms on. Here is what it does
- builds a custom librenms docker container. If a "rrd.zip" file exists in the current directory (a backup of the rrd folder on a running install), it will install that onto the docker image
- executes a custom docker compose script to start the containers necessary for librenms
- restores the database onto the database container given a file named `librenms.sql` exists in the currently running directory that is a backup of a database using `mysqldump`

If you want to get the rrd files and the database off the current install (10.0.1.12), you can run the provided shell scripts `get_rrd_zip_from_running_server.sh` and `get_database_from_currently_running_server.sh` respectively. You need to have ssh access to the server. 

prereqs:
- docker is installed
- unzip is installed

There will be 2 folders inside the checkout out repository `scn-librenms-compose` called `db` and `librenms`. These should not be messed with since these are what the containers use for stuff

