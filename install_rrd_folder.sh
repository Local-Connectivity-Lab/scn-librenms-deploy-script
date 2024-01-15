# copy the rrd folder from the currently running librenms server to the librenms container
ssh othello@10.0.1.12 'bash -s' < rrd_deploy_scripts/compress_rrd_directory.sh
scp othello@10.0.1.12:/opt/librenms/rrd.zip .
ssh othello@10.0.1.12 'bash -s' < rrd_deploy_scripts/remove_rrd_folder.sh

container_id=$(sudo docker ps -aqf "name=^librenms$")
sudo docker cp rrd.zip "$container_id":/opt/librenms
sudo docker exec $container_id unzip rrd.zip
sudo docker exec $container_id rm rrd.zip
rm rrd.zip
