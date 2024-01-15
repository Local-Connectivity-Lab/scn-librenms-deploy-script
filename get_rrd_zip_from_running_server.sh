# copy the rrd folder from the currently running librenms server to your local directory
ssh othello@10.0.1.12 'cd /opt/librenms && sudo zip -r rrd.zip rrd'
scp othello@10.0.1.12:/opt/librenms/rrd.zip .
ssh othello@10.0.1.12 'sudo rm /opt/librenms/rrd.zip'

