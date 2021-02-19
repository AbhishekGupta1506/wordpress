ARG CENTOS_TAG
ARG OS_TAG=${CENTOS_TAG}
FROM centos:$OS_TAG
MAINTAINER "Abhishek Kumar Gupta"
RUN yum -y install epel-release yum-utils ;\
    yum -y update ;\
#    yum -y install httpd php php-cli php-common ;\
    yum -y install httpd ;\
#    yum -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm ;\
    yum -y install php php-cli php-common php-fpm php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip ;\
    php -v ;\
    cd /tmp ;\
    curl -LO https://wordpress.org/latest.tar.gz ;\
    tar xzvf latest.tar.gz ;\
    cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php ;\
    cp -a /tmp/wordpress/. /var/www/wordpress 


COPY ./conf/index.html /var/www/html/
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80
HEALTHCHECK --start-period=30s --interval=30s --timeout=2s CMD curl -f http://localhost/ || exit 1
ARG BUILD_DATE
ARG RELEASE_DATE
ARG IMAGE_NAME
LABEL "image.name"=$IMAGE_NAME \
      "image.builddate"=$BUILD_DATE \
      "image.releasedate"=$RELEASE_DATE