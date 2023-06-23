# Wait for complete reboot
{% set target = salt['pillar.get']('target') %}

reboot_minion:
  salt.function:
    - name: system.reboot
    - tgt: {{ target }}

sleep_orch:
  salt.runner:
    - name: test.sleep
    - kwarg:
        s_time: 10

wait_for_reboot:
  salt.wait_for_event:
    - name: salt/minion/*/start
    - id_list:
      - {{ target }}
    - require:
      - sleep_orch
