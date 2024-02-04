# Deployment
## Prereqs
prereqs for deployment:
- docker is installed

Run `./deploy.sh` on the server you want to deploy librenms on. Here is what it does
- builds a custom librenms docker container. If a "rrd.zip" file exists in the current directory (a backup of the rrd folder on a running install), it will copy those files into the volume to be made available by the image
- executes a custom docker compose script to start the containers necessary for librenms
- restores the database onto the database container given a file named `librenms.sql` exists in the currently running directory that is a backup of a database using `mysqldump`

There will be 2 folders inside the folder `compose` called `db` and `librenms`. These should not be messed with since these are shared docker volumes

The UI of the server will be running on port 8000 (http) by default

# Backing up previous install
If you want to get the rrd files and the database off the current install (10.0.1.12), you can run the provided shell scripts `get_rrd_zip_from_running_server.sh` and `get_database_from_currently_running_server.sh` respectively. You need to have ssh access to the server.

# Backing up this install
In the future when we want to back up the rrd folder of a docker install, you just need to copy the compose/librenms/rrd folder. If you want to back up the database, you need to go into the container called `librenms_db` and do a mysqldump with the user `librenms` with the database librenms and whatever password you set, probably in the environment variables of the compose file of the deployment This means something like `mysqldump librenms -u librenms --password=<your_password> > librenms.sql`

# Upgrading this install
- I am sure we want to do operating system security updates on a frequent basis to each container so I assume we need to go into each container and run the update command every once and a while.
- I have not tried this but I assume if we want to upgrade the mariadb version, we would need to simply run this deployment script again after changing the mysql version in the corresponding dockerfile in the `FROM` dockerfile command. I think since the database is in a volume outside of docker, the new image will know to use the same volume. We also may need to migrate the database to the new version. I think there is a script to do this `/librenms migrate` or something
- Upgrading librenms can be done by running `./daily.sh` in the dockerfile. I dont think cron is running on the librenms install, so it wont do it itself. 
