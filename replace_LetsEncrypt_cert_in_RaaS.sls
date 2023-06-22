backup_files:
  file.managed:
    - name: /etc/pki/raas/certs/localhost.crt
    - source: salt://raas/localhost.crt
    - makedirs: True
    - backup: /etc/pki/raas/certs/z.OLD_certs/localhost.crt

  file.managed:
    - name: /etc/pki/raas/certs/localhost.key
    - source: salt://raas/localhost.key
    - makedirs: True
    - backup: /etc/pki/raas/certs/z.OLD_certs/localhost.key

copy_files:
  cmd.run:
    - name: cp /etc/letsencrypt/live/drewz-macpro.ddns.net/fullchain.pem /etc/pki/raas/certs/localhost.crt
    - creates: /etc/pki/raas/certs/localhost.crt

  cmd.run:
    - name: cp /etc/letsencrypt/live/drewz-macpro.ddns.net/privkey.pem /etc/pki/raas/certs/localhost.key
    - creates: /etc/pki/raas/certs/localhost.key

set_ownership:
  cmd.run:
    - name: chown raas /etc/pki/raas/certs/localhost.*
    - unless: stat -c %U /etc/pki/raas/certs/localhost.crt | grep -q raas

  cmd.run:
    - name: chgrp raas /etc/pki/raas/certs/localhost.*
    - unless: stat -c %G /etc/pki/raas/certs/localhost.crt | grep -q raas

set_permissions:
  cmd.run:
    - name: chmod 400 /etc/pki/raas/certs/localhost.*
    - unless: stat -c %a /etc/pki/raas/certs/localhost.crt | grep -q 400

restart_raas:
  service.running:
    - name: raas
    - enable: True
    - restart: True
