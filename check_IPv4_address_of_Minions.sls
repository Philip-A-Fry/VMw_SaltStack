# Print IPv4 addresses of all Minions

{% set primary_ipv4 = salt['network.ip_addrs']() | select('ipv4') | first() %}

check_minion_ipv4:
  grains.append:
    - name: minion_ipv4
    - value: {{ primary_ipv4 }}
