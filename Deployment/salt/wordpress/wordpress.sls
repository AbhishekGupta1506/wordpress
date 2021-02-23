{% set host_list = salt['minion.list']()['minions'] %}

create_yml_home_dir:
  file.directory:
  - name: {{ salt['pillar.get']('wordpress:yml_home') }}/wordpress 
  - makedirs: True  
  - user: {{ salt['pillar.get']('wordpress_rel:os_user') }}
  - group: {{ salt['pillar.get']('wordpress_rel:os_group') }}
  - dir_mode: 755
  - file_mode: 644
  - failhard: True    
  - recurse:
    - user
    - group
    - mode

create_wordpress_config_file:
  file.managed:
  - name: {{ salt['pillar.get']('wordpress:yml_home') }}/wordpress/conf/wordpress.properties
  - user: {{ salt['pillar.get']('wordpress_rel:os_user') }}
  - group: {{ salt['pillar.get']('wordpress_rel:os_group') }}
  - mode: 640
  - makedirs: true
  - contents: |
      ## Mysql db details
      KEYSTORE_ALIAS={{ salt['pillar.get']('wmic_config:is_keystore_alias') }} 
      USER={{ salt['pillar.get']('mysql:user') }}
      PASSWORD={{ salt['pillar.get']('mysql:password') }}
      HOSTNAME={{ salt['mine.get']('*', 'network.ip_addrs') }}
      DATABASE={{ salt['pillar.get']('mysql:database_name') }}
  - creates:
    - {{ salt['pillar.get']('wordpress:yml_home') }}/wordpress/conf/wordpress.properties
  - failhard: True

copy_wordpress_db_conf_script:
  file.managed:
    - name: {{ salt['pillar.get']('wordpress:yml_home') }}/wordpress/conf/update_db_detail_wp_config.sh
    - source: salt://bin/update_db_detail_wp_config.sh
    - makedirs: true
    - user: {{ salt['pillar.get']('wordpress_rel:os_user') }}
    - group: {{ salt['pillar.get']('wordpress_rel:os_group') }}
    - mode: 777
    - failhard: True

create_docker_wordpress_yml:
  file.managed:
  - name: {{ salt['pillar.get']('wordpress:yml_home') }}/wordpress/docker-compose.yml
  - user: {{ salt['pillar.get']('wordpress_rel:os_user') }}
  - group: {{ salt['pillar.get']('wordpress_rel:os_group') }}
  - mode: 640
  - makedirs: true
  - contents: |
      version: "3.2"
      volumes:
        wordpress_data: {}
      services:
        wordpress:
          image: {{ salt['pillar.get']('wordpress:docker_repo') }}:{{ salt['pillar.get']('wordpress:version') }}
          container_name: wordpress_instance
          hostname: wordpress_instance
          mem_limit: {{ salt['pillar.get']('wordpress:mem_limit') }}
          cpus: {{ salt['pillar.get']('wordpress:cpus') }}
          ports:
          - "80:80"
          volumes:
          - wordpress_data:/var/www/html/
          - {{ salt['pillar.get']('wordpress:yml_home') }}/wordpress/conf/:/opt
          networks: 
          - db     
          - wordpress
          restart: always
      networks:
        wordpress:
  - creates:
    - {{ salt['pillar.get']('wordpress:yml_home') }}/wordpress/docker-compose.yml
  - failhard: True

pull_image_wordpress:
  cmd.run:
  - name: docker-compose pull
  - cwd: {{ salt['pillar.get']('wordpress:yml_home') }}/wordpress
  - require:
    - file: {{ salt['pillar.get']('wordpress:yml_home') }}/wordpress/docker-compose.yml
  - failhard: True
  
deploy_container_wordpress:
  cmd.run:
  - name: docker-compose up -d 
  - cwd: {{ salt['pillar.get']('wordpress:yml_home') }}/wordpress
  - require:
    - file: {{ salt['pillar.get']('wordpress:yml_home') }}/wordpress/docker-compose.yml
  - check_cmd:
    - "cd {{ salt['pillar.get']('wordpress:yml_home') }}/wordpress && docker-compose ps | grep 'wordpress'"
  - retry:
        attempts: 5
        until: True
        interval: 30
        splay: 10
  - failhard: True

run_update_db_details_wp_config:
  cmd.run: 
    - names:
        - docker exec wordpress_instance bash -c '/opt/update_db_detail_wp_config.sh' 
    - require:
        - cmd: deploy_container_wordpress