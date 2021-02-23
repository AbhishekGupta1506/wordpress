base:
  '*':
  - common/install_epel
  - common/install_docker
  
  'wordpress':
  - wordpress/mysql
  - wordpress/wordpress
