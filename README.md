# wordpress

Launch wordpress site

======================================================

Pre-requisite:
    1. Docker and docker-compose needs to be installed
    2. git cli

======================================================

Clone git repo
Create docker wordpress docker image using following steps:
    1. cd ./wordpress/Images/wordpress 
    2. Update env file with own custom deatils like
        a. DTR_URL - Point to own docker repo
    3. Run . ./release.env
    3. Run command to build docker image
        docker-compose build --no-cache

=======================================================

Launch mysql DB image and create database for wordpress
1. connect to DB using following:
    a. mysql -uroot -pwordpress -hlocalhost
    b. CREATE DATABASE wordpress;
    c. FLUSH PRIVILEGES;

======================================================

Launch wordpress image and configure
1. connect to wordpress container and configure
    a. docker exec -it wordpress_wordpress_1 bash
    b. cd /var/www/html/
    c. Update mysql details in file wp-config.php
        i.  define('DB_NAME', 'wordpress');
        ii. define('DB_USER', 'root');
        iii. define('DB_PASSWORD', 'wordpress');
        iv. define( 'DB_HOST', '<EC2_instance_Host_Name>' );

=====================================================

Login to wordpress URL
1. Open url
    a. http://<hostname | public IP | Loadbalance | public domain>/
    b. Provide details:
        i. Title
        ii. Name
        iii. Password -- Passw0rd@1234
        iv. email -- abhishekgupta1506@gmail.com
        
        
