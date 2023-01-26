{%- set on_docker = salt['grains.get']('virtual_subtype', '') in ('Docker',) %}
{%- set install_from_docker_repos = True if (grains['os_family'] == 'Debian' and grains['osarch'] in ('amd64', 'armhf', 'arm64') and grains['osmajorrelease'] != 11) or grains['os'] in ('AlmaLinux', 'CentOS', 'CentOS Stream', 'Fedora') else False %}
{%- if grains['os'] == 'Amazon' or (grains['os_family'] == 'Debian' and grains['osarch'] in ('amd64', 'armhf', 'arm64') and grains['osmajorrelease'] != 11) %}
docker-prereqs:
  pkg.installed:
    - pkgs:
  {%- if grains['os_family'] == 'Debian' %}
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg
      - lsb-release
  {%- elif grains['os'] == 'Amazon' %}
      - amazon-linux-extras
  {%- endif %}
{%- endif %}
{%- if install_from_docker_repos == True %}
docker-repo-workaround:
  cmd.run:
  {%- if grains['os'] == 'Ubuntu' %}
    - name: |
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch={{ grains['osarch'] }} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    - require:
      - docker-prereqs
  {%- elif grains['os'] == 'Debian' %}
    - name: |
        curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch={{ grains['osarch'] }} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    - require:
      - docker-prereqs
  {%- elif grains['os'] in ('AlmaLinux', 'CentOS Stream', 'CentOS') and grains['osmajorrelease'] >= 7 %}
    - name: |
        yum install -y yum-utils
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  {%- elif grains['os'] == 'Fedora' %}
    - name: |
        dnf -y install dnf-plugins-core
        dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  {%- endif %}
{%- endif %}
{%- if grains['os'] == 'Amazon' %}
amazon-install-docker:
  cmd.run:
    - name: 'amazon-linux-extras install docker -y'
    - creates: /usr/bin/docker
  {%- if on_docker == False %}
amazon-docker-service:
  service.running:
    - name: docker
    - require:
      - file: /bin/sh
  {%- endif %}
{%- endif %}
{%- if grains['os'] != 'Amazon' %}
docker:
  pkg.installed:
    - refresh: True
    - pkgs:
  {%- if install_from_docker_repos == True %}
      - docker-ce
      - docker-ce-cli
      - containerd.io
  {%- else %}
      - docker
  {%- endif %}
  {%- if install_from_docker_repos == True %}
    - require:
      - cmd: docker-repo-workaround
    - aggregate: False
  {%- endif %}
  {%- if on_docker == False and (grains['os'] == 'Debian' and grains['osmajorrelease'] != 11) %}
  service.running:
    - enable: True
    - require:
      - file: /bin/sh
      - pkg: docker
  {%- endif %}
{%- endif %}
