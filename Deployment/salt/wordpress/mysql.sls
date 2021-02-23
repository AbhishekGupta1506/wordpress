create_yml_home_dir:
  file.directory:
  - name: {{ salt['pillar.get']('wordpress:yml_home') }}/mysql
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

copy_create_wordpress_db_sql_script:
  file.managed:
    - name: {{ salt['pillar.get']('wordpress:yml_home') }}/mysql/create_wordpress_db.sql
    - source: salt://bin/create_wordpress_db.sql
    - makedirs: true
    - user: {{ salt['pillar.get']('wordpress_rel:os_user') }}
    - group: {{ salt['pillar.get']('wordpress_rel:os_group') }}
    - mode: 777
    - failhard: false

create_docker_mysql_yml:
  file.managed:
  - name: {{ salt['pillar.get']('wordpress:yml_home') }}/mysql/docker-compose.yml
  - user: {{ salt['pillar.get']('wordpress_rel:os_user') }}
  - group: {{ salt['pillar.get']('wordpress_rel:os_group') }}
  - mode: 640
  - makedirs: true
  - contents: |
      version: "3.2"
      volumes:
        db_data: {}
      services:
        mysql_db:
          image: mysql:{{ salt['pillar.get']('mysql:version') }}
          container_name: wordpress_db
          hostname: wordpress_db
          mem_limit: {{ salt['pillar.get']('mysql:mem_limit') }}
          cpus: {{ salt['pillar.get']('mysql:cpus') }}
          ports:
          - "3306:3306"
          environment:
          - MYSQL_ROOT_PASSWORD={{ salt['pillar.get']('mysql:password') }}
          volumes:
          - db_data:/var/lib/mysql
          - {{ salt['pillar.get']('wordpress:yml_home') }}/mysql/create_wordpress_db.sql:/opt/create_wordpress_db.sql
          networks: 
          - db     
          restart: always
      networks:
        db:
  - creates:
    - {{ salt['pillar.get']('wordpress:yml_home') }}/mysql/docker-compose.yml
  - failhard: True

pull_image_mysql:
  cmd.run:
  - name: docker-compose pull
  - cwd: {{ salt['pillar.get']('wordpress:yml_home') }}/mysql
  - require:
    - file: {{ salt['pillar.get']('wordpress:yml_home') }}/mysql/docker-compose.yml
  - failhard: True
  
deploy_container_mysql:
  cmd.run:
  - name: docker-compose up -d 
  - cwd: {{ salt['pillar.get']('wordpress:yml_home') }}/mysql
  - require:
    - file: {{ salt['pillar.get']('wordpress:yml_home') }}/mysql/docker-compose.yml
  - check_cmd:
    - "cd {{ salt['pillar.get']('wordpress:yml_home') }}/mysql && docker-compose ps | grep 'mysql'"
  - retry:
        attempts: 5
        until: True
        interval: 30
        splay: 10
  - failhard: True

run_db_create:
  cmd.run: 
    - names:
        - docker exec wordpress_db bash -c 'mysql -uroot -p{{ salt['pillar.get']('mysql:password') }} -hlocalhost -f <  /opt/create_wordpress_db.sql' 
    - require:
        - cmd: deploy_container_mysql