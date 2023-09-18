#!/bin/bash
set -x
# Update and upgrade packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install required packages for WordPress
sudo apt-get install -y apache2 php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip


# Download and configure WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo mv wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/

# Remove the default index.html file
sudo rm /var/www/html/index.html