list-java:
  cmd.shell:
    - name: find / -type f -not -path "*/proc/*" -name java -exec ls -lah {} \; exit 0

list-java2:
  cmd.shell:
    - name: find / -type f -not -path "*/proc/*" -name java -exec ls -lu {} \; exit 0-print

list-java-versions:
  cmd.shell:
    - name: find / -type f -not -path "*/proc/*" -name java | xargs -I{} echo "echo {};{} -version;echo" | sh; exit 0

list-java-rpms:
  cmd.shell:
    - name: rpm -qa java*

list-backup-dirs:
  cmd.shell:
    - name: find / -type d -not -path "*/proc/*" -name backup*; exit 0

list-cron-jobs:
  cmd.shell:
    - name: cat /etc/cron.*/*
