run ./deploy.sh on the server you want to deploy librenms on

prereqs:
- docker is installed
- unzip is installed

There will be 2 folders inside the checkout out repository `scn-librenms-compose` called `db` and `librenms`. These should not be messed with since these are what the containers use for stuff

Once the containers are running, it is then necessary to restore the database (which is a pain) and overwrite the rrd directory with whatever is in there in the running server. Then things should be working, as long as the devices have allowed the server's ip for snmp. Also various ports should be opened on the server, not sure which ones though. I know the UI will be running on `:8000` so probably at least that one, and it will only be http.
