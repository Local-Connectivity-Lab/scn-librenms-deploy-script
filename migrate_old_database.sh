# given the old backup of the database is restored, there is an issue where the migration command fails
# because a table needs to be dropped. That table has to manually be dropped then the migration will succeed

app_container=$(sudo docker ps -aqf "name=^librenms$")
sudo docker exec $app_container /opt/librenms/lnms migrate --force
database_container=$(sudo docker ps -aqf "name=^librenms_db$")
sudo docker exec $database_container bash -c "echo 'drop table vendor_ouis;' > drop_table_command.sql"
sudo docker exec $database_container bash -c 'mysql -u librenms --password=asupersecretpassword librenms < drop_table_command.sql'
sudo docker exec $database_container bash -c "rm drop_table_command.sql"
sudo docker exec $app_container /opt/librenms/lnms migrate --force

