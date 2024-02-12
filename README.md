# Deployment
## Software requiremens
Only tested on debian and ubuntu. Not sure what else it works on but it could work on other linux distros
## Steps
1. Install docker if it is not installed already
1. Install docker compose if it is not installed already
1. Instal unzip if it is not installed already
1. Check out this repo
1. If you want to restore a previous install, provide a sqldump named `librenms.sql` flat in this checked out repo. There is a helper script called `get_database_from_currently_running_server.sh` to get the database off of the non dockerized install (needs ssh access to the server)
  1, If you want to restore the graphs too you can provide a file named `rrd.zip` flat in the checked out repo which is just the rrd folder ziped up.  There is a helper script called `get_rrd_zip_from_currently_running_server.sh` to get the rrd zip from the non dockerized install (needs ssh access to the server)
1. Run `./deploy.sh`
  1. builds the librenms image
  1. builds the database image with/without the backup
  1. Starts the service using `docker compose`. This creates 2 shared volumes in the `compose` directory
    1. The `librenms` folder is for the librenms docker images to shate configuration data including rrd files
    1. the `db` volume is the database
  1. unzips the rrd folder in the rrd directory of the shared `librenms` volume
The UI will run on port 8000

# Backing up this install
In the future when we want to back up the rrd folder of a docker install, you just need to copy the compose/librenms/rrd folder. If you want to back up the database, you need to go into the container called `librenms_db` and do a mysqldump with the user `librenms` with the database librenms and whatever password you set, probably in the environment variables of the compose file of the deployment This means something like `mysqldump librenms -u librenms --password=<your_password> > librenms.sql`

# Upgrading this install
- I am sure we want to do operating system security updates on a frequent basis to each container so I assume we need to go into each container and run the os's package manager update command every once and a while.
- I have not tried this but I assume if we want to upgrade the mariadb version, we would need to simply run this deployment script again after changing the mysql version in the corresponding dockerfile in the `FROM` dockerfile command. I think since the database is in a volume outside of docker, the new image will know to use the same volume. We also may need to migrate the database to the new version. I think there is a script to do this `/librenms migrate` or something
- Upgrading librenms can be done by running `./daily.sh` in the dockerfile. I dont think cron is running on the librenms install, so it wont do it itself. 
