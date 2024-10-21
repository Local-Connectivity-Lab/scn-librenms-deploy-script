if grep -q "Ubuntu\|Debian" /etc/os-release; then
  echo "Running on Ubuntu or Debian"
  sudo="sudo"
  source check_reqs_debian_or_ubuntu.sh
elif grep -q "Alpine Linux" /etc/os-release; then
  echo "Running on Alpine Linux"
  sudo=""
  source check_reqs_alpine.sh
else
  echo "Not running on Ubuntu or Debian. Not sure how to install"
  exit 1;
fi

cd librenms_image
$sudo docker build . -t scn-librenms
cd ..

touch db_dockerfile
echo "from  mariadb:10.5" >> db_dockerfile
if [ -f "librenms.sql" ]; then
  echo "copy librenms.sql /docker-entrypoint-initdb.d/" >> db_dockerfile
fi
$sudo docker build -f db_dockerfile -t scn_mariadb_librenms .
rm db_dockerfile

if [ -f "rrd.zip" ]; then
  cd compose
  mkdir librenms
  cd librenms
  unzip ../../rrd.zip
  cd ../..
fi

$sudo docker compose -f compose/compose.yml up -d

echo "If the graphs are not populating, there may be issues with the dispatcher container writing the rrd files. You may have to go into the dispatcher container and run `chown -R librenms:librenms /data/rrd/`"
