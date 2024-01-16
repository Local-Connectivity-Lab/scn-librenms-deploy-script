set -e

ssh othello@10.0.1.12 'sudo mysqldump librenms -u root --password=password > librenms.sql'
scp othello@10.0.1.12:/home/othello/librenms.sql .
ssh othello@10.0.1.12 'rm /home/othello/librenms.sql'
