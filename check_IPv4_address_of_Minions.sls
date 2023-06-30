# Print IPv4 addresses of all Minions

{% set command = '' %}
{% set kernel = grains.get('kernel', '') %}

{% if kernel == 'Windows' %}
  {% set command = 'powershell "ipconfig | Select-String -Pattern \'^\s+IPv4\'"' %}
{% elif kernel == 'Linux' %}
  {% set command = 'ifconfig | grep -m7 \'inet \'' %}
{% endif %}

check_minion_ipv4:
  cmd.run:
    - name: {{ command }}
    - shell: {{ kernel == 'Windows' }}
    - runas: root
    - python_shell: True
    - onlyif: '{{ command }}'

check_minion_ipv4_grain:
  grains.append:
    - name: minion_ipv4
    - value: {{ salt['cmd.shell']('ipconfig | findstr IPv4' if kernel == 'Windows' else 'ifconfig | grep -m1 \'inet \'' , python_shell=True) }}

