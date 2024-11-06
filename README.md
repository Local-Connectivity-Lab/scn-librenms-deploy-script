# Deployment
## Software requirements
Only tested on debian, ubuntu, and a root install of alpine. Other OS deployments may not work
## Steps
1. Install docker if it is not installed already
1. Install docker compose if it is not installed already
1. Instal unzip if it is not installed already
1. Check out this repo
1. Run `./deploy.sh`
   1. builds the librenms image
   1. builds the database image and restores the backup if specified
   1. Starts the service using `docker compose`. This creates 2 shared volumes in the `compose` directory
      1. The `librenms` folder is for the librenms docker images to share configuration data including rrd files
      1. The `db` volume is the database
   1. Restores the RRD files if specified

The UI will run on port 8000

# Backing up this install
To back up the install, the commands are in the deployment script. You just need to zip all the RRD files and `mysqldump` the database. Depending on the type of install, you may need to exec into the containers first.

# Upgrading this install
- I am sure we want to do operating system security updates on a frequent basis to each container so I assume we need to go into each container and run the os's package manager update command every once and a while. We probably need to also do a `docker container restart` after that too
- I have not tried this but I assume if we want to upgrade the mariadb version, we would need to simply run this deployment script again after changing the mysql version in the corresponding dockerfile in the `FROM` dockerfile command. I think since the database is in a volume outside of docker, the new image will know to use the same volume. We also may need to migrate the database to the new version. I think there is a script to do this `/librenms migrate` or something
- Upgrading librenms can be done by running `./daily.sh` in the dockerfile. I dont think cron is running on the librenms install, so it wont do it itself. 
