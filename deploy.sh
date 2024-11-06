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
if [ "$1" == "--restore" ]; then
  echo "copy librenms.sql /docker-entrypoint-initdb.d/" >> db_dockerfile
  ssh othello@10.0.1.12 'sudo mysqldump librenms -u root --password=password > librenms.sql && zip librenms.sql.zip librenms.sql && rm librenms.sql'
  scp othello@10.0.1.12:/home/othello/librenms.sql.zip .
  ssh othello@10.0.1.12 'rm /home/othello/librenms.sql.zip'
  unzip librenms.sql.zip
  rm librenms.sql.zip
fi
$sudo docker build -f db_dockerfile -t scn_mariadb_librenms .
rm db_dockerfile

if [ "$1" == "--restore" ]; then
  rm librenms.sql
  ssh othello@10.0.1.12 'cd /opt/librenms && sudo zip -r rrd.zip rrd'
  scp othello@10.0.1.12:/opt/librenms/rrd.zip .
  ssh othello@10.0.1.12 'sudo rm /opt/librenms/rrd.zip'

  cd compose
  mkdir librenms
  cd librenms
  unzip ../../rrd.zip
  cd ../..
  rm rrd.zip
fi

$sudo docker compose -f compose/compose.yml up -d

echo "If the graphs are not populating, there may be issues with the dispatcher container writing the rrd files. You may have to go into the dispatcher container and run 'chown -R librenms:librenms /data/rrd/'"
