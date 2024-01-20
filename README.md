Run `./deploy.sh` on the server you want to deploy librenms on. Here is what it does
- builds a custom librenms docker container. If a "rrd.zip" file exists in the current directory (a backup of the rrd folder on a running install), it will install that onto the docker image
- executes a custom docker compose script to start the containers necessary for librenms
- restores the database onto the database container given a file named `librenms.sql` exists in the currently running directory that is a backup of a database using `mysqldump`

If you want to get the rrd files and the database off the current install (10.0.1.12), you can run the provided shell scripts `get_rrd_zip_from_running_server.sh` and `get_database_from_currently_running_server.sh` respectively. You need to have ssh access to the server. 

prereqs for deployment:
- docker is installed
- unzip is installed

There will be 2 folders inside the checkout out repository `scn-librenms-compose` called `db` and `librenms`. These should not be messed with since these are what the containers use for stuff

In the future when we want to back up the rrd folder of a docker install, you need to go into the docker container called `librenms` and everything will be in the rrd folder in the directory it puts you in by default. If you want to back up the database, you need to go into the container called `librenms_db` and do a mysqldump with the user `librenms` with the database librenms and whatever password you set, probably in the environment variables of the compose file of the deployment This means something like `mysqldump librenms -u librenms --password=<your_password> > librenms.sql`

