#!/bin/bash

# Enable debugging mode
set -x

# Redirect script output to a log file
exec > >(tee /var/log/install-wordpress.log) 2>&1

# Update and upgrade packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install required packages for WordPress
sudo apt-get install -y apache2 php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

# Secure MySQL installation (set root password and remove test DB)
# You can uncomment this line if MySQL is needed
# sudo mysql_secure_installation

# Remove the default index.html file
sudo rm /var/www/html/index.html

# Download and configure WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo mv wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/

# Additional Configuration Steps (optional):
# You can add any additional configuration or customization steps here.

# Exit with success status (0)
exit 0
