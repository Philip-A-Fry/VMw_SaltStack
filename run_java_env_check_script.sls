run_java_env_check_script:
  cmd.script:
    - source: salt://java_report.sh
    - cwd: /root
    - shell: /bin/bash
    - timeout: 60
    - output_file: /root/java_report.json
