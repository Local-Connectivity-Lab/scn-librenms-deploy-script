set -e

if ! [[ $(which docker) && $(docker --version) ]]; then
  echo "Docker is not installed. Please install docker."
  exit 1
fi

if ! [[ $(which unzip) ]]; then
  echo "unzip is not installed. Please install it"
  exit 1
fi

cd librenms_image
sudo docker build . -t scn-librenms
cd ..

if [ -f "librenms.sql" ]; then
  mkdir tmp
  cp db_image_with_backup/Dockerfile tmp
  cp librenms.sql tmp
  cd tmp
  sudo docker build . -t scn_mariadb_librenms
  cd ..
  rm -r tmp
else
  cd db_image
  sudo docker build . -t scn_mariadb_librenms
  cd ..
fi

sudo docker compose -f compose/compose.yml up -d

sleep 5

if [ -f "rrd.zip" ]; then
  cd compose/librenms
  cp ../../rrd.zip .
  unzip rrd.zip
  rm rrd.zip
  cd ../..
fi

