pkg.docker_ce:
  pkgrepo.managed:
    - name: docker-ce
    - humanname: 'Docker CE Stable'
    - baseurl: https://download.docker.com/linux/centos/7/$basearch/stable
    - gpgkey: https://download.docker.com/linux/centos/gpg
    - gpgcheck: 1
    - require_in:
      - cmd: install_docker
    - onlyif: grep "centos" /etc/os-release
    - unless: /etc/yum.repos.d/docker-ce.repo

install_docker:
  cmd.run:
  - name: yum -y install docker-ce-{{ salt['pillar.get']('docker_pkg_version:docker_ce') }}
  - unless: systemctl status docker
  - failhard: True

add_ec2_user:
  cmd.run:
  - names: 
    - usermod -aG docker ec2-user
  - failhard: True

service_docker:
  service.running:
  - name: docker
  - enable: True
  - reload: True
  - failhard: True  

install_docker-compose:
  cmd.run:
  - name: curl -L "https://github.com/docker/compose/releases/download/{{ salt['pillar.get']('docker_pkg_version:docker_compose') }}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  - creates: /usr/local/bin/docker-compose
  - failhard: True

chmod_docker-compose:
  file.managed:
  - name: /usr/local/bin/docker-compose
  - user: root
  - group: root
  - mode: 755
  - replace: False
  - failhard: True