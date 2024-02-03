set -e

if ! [[ $(which docker) && $(docker --version) ]]; then
  echo "Docker is not installed. Please install docker."
fi

if ! [[ $(which unzip) ]]; then
  echo "unzip is not installed. Please install unzip."
fi

mkdir tmp
cp librenms_image/* tmp

if [ -f "rrd.zip" ]; then
  tail -n +2 librenms_image_with_rrd/Dockerfile >> tmp/Dockerfile
  cp rrd.zip tmp
fi

# Build the custom librenms image
cd tmp
sudo docker build . -t scn-librenms
cd ..

rm -r tmp

# start all docker images
compose_repo='scn-librenms-compose'
wget https://github.com/abacef/$compose_repo/archive/main.zip
unzip main.zip
rm main.zip
install_dir='live_volumes_librenms'
mv $compose_repo-main $install_dir
cd $install_dir
sudo docker compose -f compose.yml up -d
cd ..


# Restore the database to the database container
if [ -f "librenms.sql" ]; then
  database_container=$(sudo docker ps -aqf "name=^librenms_db$")
  sudo docker cp librenms.sql $database_container:/
  sleep 10
  echo "restoring database..."
  sudo docker exec $database_container bash -c "mysql -u librenms --password=asupersecretpassword librenms < librenms.sql && rm librenms.sql"
  echo "done restoring the database"
else
  echo "Skipped restoring database because no librenms.sql exists"
fi

