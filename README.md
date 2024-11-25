# Deployment
Run the docker compose script: `compose.yml`, but set the `MYSQL_PASSWORD` in the `.env` file to something else 

## Restore
If you want to restore a previous deployment, you could use one of the daily backups or you could manually run a backup yourself. Put the backed up database `librenms.sql` file in the `db_image` directory, and add the following line `copy librenms.sql /docker-entrypoint-initdb.d/` to the `Dockerfile` inside that directory. Also in order to populate the graphs, you need to create a directory called `librenms` inside the compose directory and unzip the `rrd.zip` file there such chat inside the directory there is a folder named `rrd` and the folder contains folders named after the devices. Once you run docker compose, you will need to give the `librenms_dispatcher` container permissions to the rrd directory by running chown -R librenms:librenms /data/rrd/' inside the container.

The UI will run on port 8000

# Backing up this install
The backup script to backup the current installation on proxmox is hosted here: https://github.com/abacef/scn-librenms-backup-script

# Upgrading this install
The upgrade script to upgrade the current installation on the proxmox based on this deploy script is hosted here: https://github.com/abacef/scn-librenms-backup-script
