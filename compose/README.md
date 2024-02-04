This should deploy the docker containers on the server and start librenms for SCN.

`sudo docker compose -f compose.yml up -d`

Note that:
- You need to build the librenms image yourself from https://github.com/abacef/scn-librenms-image
- In the .env file before you start the containers, you need to set the username and password of the DB to something that is not hardcoded. Also write it down somewhere
- Once the containers are started, you need to manually migrate the databases (mariadb and rrd) from the running instance

