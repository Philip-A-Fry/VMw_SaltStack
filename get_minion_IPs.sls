{% set command = '' %}
{% set kernel = grains.get('kernel') %}

{% if kernel == 'Windows' %}
  {% set command = "ipconfig | Select-String IPv4" %}
  {% set shell = 'powershell' %}
{% elif kernel == 'Linux' %}
  {% set command = "ifconfig | grep -m3 \'inet \'" %}
  {% set shell = '/bin/bash' %}
{% endif %}

check_minion_ipv4:
  cmd.run:
    - name: {{ command }}
    - shell: {{ shell }}
