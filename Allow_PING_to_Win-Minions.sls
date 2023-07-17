# Allow_PING_to_Win-Minions.sls
allow_ping_rule:
  cmd.run:
    - name: netsh advfirewall firewall add rule name="Allow_PING" protocol=icmpv4:8,any dir=in action=allow
