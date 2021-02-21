# wordpress

Launch wordpress site

======================================================

Pre-requisite:

    1. Docker and docker-compose needs to be installed

        a. Install Docker

            i. yum install -y docker

            ii. usermod -aG docker ec2-user

            iii. service docker start

            iv. service docker status

        b. Install docker-compose

            i. curl -L "https://github.com/docker/compose/releases/download/1.28.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

            ii. chmod +x /usr/local/bin/docker-compose
    
    2. git cli

        a. yum install git

======================================================

1. Clone git repo

    a. git clone https://github.com/AbhishekGupta1506/wordpress.git --recursive

2. Create docker wordpress docker image using following steps:

    1. cd ./wordpress/Images/wordpress 
    
    2. Update env file with own custom deatils like
    
        a. DTR_URL - Point to own docker repo
        
    3. Run . ./release.env
    
    4. Run command to build docker image
    
        a. docker-compose build --no-cache

=======================================================

Launch mysql DB image and create database for wordpress

1. Create DB container:

    a. cd ./wordpress/Images/mysql

    b. docker-compose up -d

2. connect to DB using following:

    a. docker exec -it <mysql_container_name> bash

    b. mysql -uroot -pwordpress -hlocalhost
    
    c. CREATE DATABASE wordpress;
    
    d. FLUSH PRIVILEGES;

======================================================

Launch wordpress image and configure

1. Create wordpress container:

    a. cd ./wordpress/Images/wordpress

    b. docker-compose up -d

2. connect to wordpress container and configure

    a. docker exec -it <wordpress_container_name> bash
    
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
                
======================================================

Infra creation using terraform

Pre-requisite:

    1. Install Terraform v0.12.16

        a. Download the Package and configure

            i. curl -OL https://releases.hashicorp.com/terraform/0.12.16/terraform_0.12.16_linux_amd64.zip

            ii. yum install -y unzip; unzip terraform_0.12.16_linux_amd64.zip

            iii. mv terraform /usr/local/bin/terraform1216

            iv. check the terraform - terraform1216 --version

    2. Create key to use for accessing ec2 instance

        a. cd ./wordpress/Infra/key

        b. ssh-keygen -f aws

        c. Two files(aws & aws.pub) will be created. Keep it at safe location

    3. Initialize the terraform

        a. cd ./wordpress/Infra/

        b. Add the network Ip from where connection to ec2 is needed in var.tf(var name to update network_ip_local)
        
        c. Init the terraform dir
            
                i. terraform1216 init

        d. Verify what all resources terraform going to create using following command:
            
                i. export AWS_ACCESS_KEY_ID="XXXXXXXXX"; export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXX" ; terraform1216 plan

        Note: update the aws access key and secret key

        f. Once the output seems ok then run command to create the required stack:

                i. export AWS_ACCESS_KEY_ID="XXXXXXXXX"; export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXX" ; terraform1216 apply
    
    4. Connect to EC2 instance

        a. ssh -i ./key/aws ec2-user@<public_ip>

        b. Create mysql & wordpress docker container by running command

            i. cd ~

            ii. docker-compose up -d

    5. Connect to DB and create wordpress database

        a. Follow the steps 2. mentioned under "Launch mysql DB image and create database for wordpress"
    
    6. Configure wordpress 

        a. Follow the steps 2. mentioned under "Launch wordpress image and configure" 

        b. Follow steps mentioned under "Login to wordpress URL"