# Print IPv4 addresses of all Minions

{% set command = '' %}
{% set kernel = grains.get('kernel', '') %}

{% if kernel == 'Windows' %}
  {% set command = "powershell 'ipconfig | sls IPv4'" %}
{% elif kernel == 'Linux' %}
  {% set command = "ifconfig | grep -m7 \'inet \'" %}
{% endif %}

check_minion_ipv4:
  cmd.run:
    - name: {{ command }}
 #   - shell: {{ kernel }}
    - python_shell: True
    - onlyif: '{{ command }}'

