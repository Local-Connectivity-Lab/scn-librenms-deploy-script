set -e

if ! [[ $(which docker) && $(docker --version) ]]; then
  echo "Docker is not installed. Please install docker."
fi

if ! [[ $(which unzip) ]]; then
  echo "unzip is not installed. Please install unzip."
fi

# build custom librenms docker image
image_repo='scn-librenms-image'
wget https://github.com/abacef/$image_repo/archive/main.zip
unzip main.zip
rm main.zip
cd $image_repo-main
sudo docker build . -t scn-librenms
cd ..
rm -r $image_repo-main

# Add the rrd folder to the librenms image if available
if [ -f "rrd.zip" ]; then
  sudo docker build . -f rrd-dockerfile -t scn-librenms
fi

# start all docker images
compose_repo='scn-librenms-compose'
wget https://github.com/abacef/$compose_repo/archive/main.zip
unzip main.zip
rm main.zip
sudo docker compose -f $compose_repo-main/compose.yml up -d

# Restore the database to the database container
if [ -f "librenms.sql" ]; then
  echo "restoring database..."
  database_container=$(sudo docker ps -aqf "name=^librenms_db$")
  sudo docker cp librenms.sql $database_container:/
  sleep 5
  sudo docker exec $database_container bash -c "mysql -u librenms --password=asupersecretpassword librenms < librenms.sql && rm librenms.sql"
  echo "done restoring the database"
else
  echo "Skipped restoring database because no librenms.sql exists"
fi

echo "Restarting service or else your graphs will not populate for some reason"
cd $image_repo
sudo docker compose stop
sudo docker compose start
cd ..

