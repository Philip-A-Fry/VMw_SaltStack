# Print IPv4 addresses of all Minions
check_minion_ipv4:
  module.run:
    - name: network.interfaces
  register: network_interfaces

show_minion_ipv4:
  module.run:
    - name: grains.append
    - key: minion_ipv4
    - value: {{ network_interfaces[grains.id].get('IPv4', {}).get('eth0', [])[0] }}
