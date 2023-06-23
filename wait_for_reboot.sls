# Wait for complete reboot
{% set target = salt['pillar.get']('target') %}

reboot_minion:
  salt.function:
    - name: system.reboot
    - tgt: {{ target }}

wait_for_reboot:
  salt.wait_for_event:
    - name: salt/minion/*/start
    - id_list:
      - {{ target }}
    - require:
      - reboot_minion
