if ! command -v docker > /dev/null; then
  echo "Docker is not installed. Please install docker."
  exit 1
fi

if ! command -v unzip > /dev/null; then
  echo "unzip is not installed. Please install it"
  exit 1
fi

if ! docker compose > /dev/null; then
  echo "docker compose not installed. Please install the docker compose plugin"
  exit 1
fi

set -e

cd librenms_image
docker build . -t scn-librenms
cd ..

touch db_dockerfile
echo "from  mariadb:10.5" >> db_dockerfile
if [ -f "librenms.sql" ]; then
  echo "copy librenms.sql /docker-entrypoint-initdb.d/" >> db_dockerfile
fi
docker build -f db_dockerfile -t scn_mariadb_librenms .
rm db_dockerfile

docker compose -f compose/compose.yml up -d

sleep 5

if [ -f "rrd.zip" ]; then
  cd compose/librenms
  cp ../../rrd.zip .
  unzip rrd.zip
  rm rrd.zip
  cd ../..
fi
