docker_pkg_version:
  docker_ce: 
  docker_compose: 1.28.4

wordpress:
  yml_home: /opt/compose/
  docker_repo: abhishekgupta1506/wordpress
  version: latest
  mem_limit: 300M
  cpus: .25

wordpress_rel:
  os_user: 1000
  os_group: 1000

mysql:
  version: 5.7
  mem_limit: 350M
  cpus: .25
  user: root
  password: wordpress
  database_name: wordpress
#  hostname: wordpress