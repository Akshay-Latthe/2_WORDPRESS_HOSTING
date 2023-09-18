#!/bin/bash
while [ ! -d "/var/www/html" ]; do
  sleep 10  # Wait for 1 minute
done

sudo mkdir -p /var/www/html/wp-content/uploads

# Wait until the desired directory exists
while [ ! -d "/var/www/html/wp-content/uploads" ]; do
  sleep 10  # Wait for 1 minute
done
sudo chown -R www-data:www-data /var/www/html/wp-content/uploads
sudo chmod -R 755 /var/www/html/wp-content/uploads
sudo apt-get update -y 
sudo apt-get install -y amazon-efs-utils
sudo apt-get install -y nfs-common

# Once the directory exists, proceed with mounting the EFS drive
efs_host="${efs_name}"
# Use either of these mount commands based on your use case
#sudo mount -t efs -o tls $efs_host:/ /var/www/html/wp-content/uploads
# OR
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $efs_host:/ /var/www/html/wp-content/uploads

echo $efs_host

## https://faun.pub/terraform-ec2-userdata-and-variables-a25b3859118a
## ==================================== ========================================================================
sleep 30

# sudo mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Navigate to the /var/www/html directory
WP_CONFIG="/var/www/html/wp-config.php"

# Define the new values for DB_NAME, DB_USER, DB_PASSWORD, DB_HOST, and DB_REDIS
NEW_DB_NAME="${db_name}"
NEW_DB_USER="${db_user}"
NEW_DB_PASSWORD="${db_password}"
NEW_DB_HOST="${db_host}"
NEW_REDIS="${db_redis}"

# Create a copy of wp-config-sample.php as wp-config.php
sudo cp /var/www/html/wp-config-sample.php "$WP_CONFIG"

# Replace <?php line with HTTPS redirect code
sudo sed -i '/<\?php/a\
if (isset($_SERVER['\''HTTP_X_FORWARDED_PROTO'\'']) && $_SERVER['\''HTTP_X_FORWARDED_PROTO'\''] === '\''https'\'') {\
    $_SERVER['\''HTTPS'\''] = '\''on'\'';\
}' "$WP_CONFIG"

# Replace database credentials with new values
sudo sed -i "s/define( 'DB_NAME', '.*' );/define( 'DB_NAME', '$NEW_DB_NAME' );/" "$WP_CONFIG"
sudo sed -i "s/define( 'DB_USER', '.*' );/define( 'DB_USER', '$NEW_DB_USER' );/" "$WP_CONFIG"
sudo sed -i "s/define( 'DB_PASSWORD', '.*' );/define( 'DB_PASSWORD', '$NEW_DB_PASSWORD' );/" "$WP_CONFIG"
sudo sed -i "s/define( 'DB_HOST', '.*' );/define( 'DB_HOST', '$NEW_DB_HOST' );/" "$WP_CONFIG"

# Add Redis configuration and set WP_CACHE to a new line
sudo sed -i "/define( 'DB_COLLATE'/a\
\/\*\* REDIS HOST \*\/\
define( 'WP_REDIS_HOST', '$NEW_REDIS', '' );\
\ndefine( 'WP_CACHE', true );" "$WP_CONFIG"

echo "Updated DB_NAME in wp-config.php to $NEW_DB_NAME"