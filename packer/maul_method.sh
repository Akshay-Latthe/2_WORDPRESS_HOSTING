#!/bin/bash
sudo su -
# Sleep for 60 seconds (optional, for instance, if you need to ensure all updates are applied)

# Update the package list to get the latest package information
sudo apt-get update
# Upgrade packages if needed
sudo apt-get upgrade -y
# Install Nginx
sudo apt-get install nginx -y
# Start Nginx
sudo systemctl start nginx
# Enable Nginx to start on boot
sudo systemctl enable nginx

# Display Nginx status to verify that it's running
sudo systemctl status nginx
# Allow SSH, HTTP (port 80), and HTTPS (port 443) traffic through the firewall
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
# Enable the firewall
sudo ufw enable
echo "Nginx has been installed and is running."

# Configuration content
new_config="server {
    listen 80;

    root /var/www/html;
    index index.php index.html index.htm;
    client_max_body_size 8000M;

    location / {
        try_files $uri $uri/ /index.php?q=$uri&$args;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_buffer_size  256k;
        fastcgi_buffers  4 256k;
        fastcgi_busy_buffers_size  256k;

        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location = /favicon.ico {
        access_log off;
        log_not_found off;
        expires max;
    }

    location = /robots.txt {
        access_log off;
        log_not_found off;
    }

    error_page 404 /404.html;

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }

    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }

    location /wp-content/uploads/ {
        location ~ \.php$ {
            deny all;
        }
    }
}"

# Remove the existing content of /etc/nginx/sites-available/default
sudo truncate -s 0 /etc/nginx/sites-available/default

# Add the new configuration content to the file
echo "$new_config" | sudo tee /etc/nginx/sites-available/default

# Test the Nginx configuration for syntax errors

sudo systemctl restart nginx
sudo nginx -t


new_nginx_config="
user www-data;
worker_processes auto;
pid /run/nginx.pid; 
include /etc/nginx/modules-enabled/*.conf;

events {
        worker_connections 768;
        # multi_accept on;
}

http {

        ##
        # Basic Settings
        ##

        sendfile on;
        tcp_nopush on;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ##
        # SSL Settings
        ##

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
        ssl_prefer_server_ciphers on;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        ##
        # Gzip Settings
        ##

        gzip on;

        gzip_vary on;
        gzip_proxied any;
        gzip_comp_level 6;
        gzip_buffers 16 8k;
        gzip_http_version 1.1;
        gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

        ##
        # Virtual Host Configs
        ##

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
}

#mail {
#       # See sample authentication script at:
#       # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
#       # auth_http localhost/auth.php;
#       # pop3_capabilities "TOP" "USER";
#       # imap_capabilities "IMAP4rev1" "UIDPLUS";
#
#       server {
#               listen     localhost:110;
#               protocol   pop3;
#               proxy      on;
#       }
#
#       server {
#               listen     localhost:143;
#               protocol   imap;
#               proxy      on;
#       }
#}"

# Remove the contents of the nginx.conf file
sudo truncate -s 0 /etc/nginx/nginx.conf

# Use sudo tee to write the new configuration to the file
echo "$new_nginx_config" | sudo tee /etc/nginx/nginx.conf > /dev/null

echo " Nginx Configration is complete "

echo " Mariadb  Configration is start "
sudo apt-get install mariadb-server  -y   
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation<<EOF
        ${aaic}
        y
        ${aaic}
        ${aaic}
        y
        y
        y
        y
EOF

sudo mysql -e "CREATE DATABASE aaic DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin@1234';"
sudo mysql -e "GRANT ALL ON aaic.* TO 'admin'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql -e EXIT;

echo " mariadb installeintion is done ......."

echo " PHP installeintion is start ......."

sudo apt-get install php php-fpm php-curl php-cli php-zip php-mysql php-xml php-mbstring php-gd php-xmlrpc php-imagick php-intl php-soap -y


echo " PHPMyadmin  installeintion is start ......."

cd /var/www/html
sudo wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
sudo mkdir phpMyAdmin
sudo tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
sudo rm phpMyAdmin-latest-all-languages.tar.gz

echo " PHPMyadmin  installeintion is complete ......."

echo " wordpress  installeintion is STARTED ......."

sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo mv wordpress/* /var/www/html
cd ..
sudo chown -R www-data:www-data /var/www/html/

sudo systemctl restart nginx
echo " wordpress  installeintion is COMPLETE ......."

echo " php Configration  update  is started ......."
# Change to the directory where php.ini files are located
cd /etc/php/*/fpm

# Edit the php.ini file using sudo and vi


# Update the php.ini file with the specified values
sudo sed -i 's/^max_execution_time.*/max_execution_time = 300/' php.ini
sudo sed -i 's/^max_input_time.*/max_input_time = 180/' php.ini
sudo sed -i 's/^;max_input_vars.*/max_input_vars = 10000/' php.ini
sudo sed -i 's/^memory_limit.*/memory_limit = 256M/' php.ini
sudo sed -i 's/^post_max_size.*/post_max_size = 8000M/' php.ini
sudo sed -i 's/^upload_max_filesize.*/upload_max_filesize = 200/' php.ini

# Restart the PHP-FPM service
sudo systemctl restart php*-fpm

echo " php Configration  update  is completed ......."

sudo rm -rf /var/www/html/index.html

sudo systemctl restart nginx

