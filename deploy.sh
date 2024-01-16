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
sudo docker build . -t  scn-librenms
cd ..
rm -r $image_repo-main

# start all docker images
compose_repo='scn-librenms-compose'
wget https://github.com/abacef/$compose_repo/archive/main.zip
unzip main.zip
rm main.zip
sudo docker compose -f $compose_repo-main/compose.yml up -d

# Restore the database to the database container
database_container=$(sudo docker ps -aqf "name=^librenms_db$")
sudo docker cp librenms.sql $database_container:/
sleep 5
echo "Restoring database"
sudo docker exec $database_container bash -c "mysql -u librenms --password=asupersecretpassword librenms < librenms.sql"


# Install the rrd zip folder to the librenms container
container_id=$(sudo docker ps -aqf "name=^librenms$")
sudo docker cp rrd.zip "$container_id":/opt/librenms
sudo docker exec $container_id unzip rrd.zip
sudo docker exec $container_id rm rrd.zip
