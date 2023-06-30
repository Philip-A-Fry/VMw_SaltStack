# Print IPv4 addresses of all Minions

{% set primary_ipv4 = None %}

{% for iface, addrs in salt['network.ip_addrs']().items() %}
  {% for addr in addrs %}
    {% if addr | ipaddr('ipv4') %}
      {% set primary_ipv4 = addr %}
      {% break %}
    {% endif %}
  {% endfor %}
{% endfor %}

check_minion_ipv4:
  grains.append:
    - name: minion_ipv4
    - value: {{ primary_ipv4 }}
