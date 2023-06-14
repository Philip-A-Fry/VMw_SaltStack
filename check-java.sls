list-java:
  cmd.run:
    - name: find / -type f -not -path "*/proc/*" -name java -exec ls -lah {} \; ; exit 0

list-java2:
  cmd.run:
    - name: find / -type f -not -path "*/proc/*" -name java -exec ls -lu {} \; -print

list-java-versions:
  cmd.run:
    - name: find / -type f -not -path "*/proc/*" -name java -exec sh -c 'echo {};{} -version;echo' \; ; exit 0

list-java-rpms:
  cmd.run:
    - name: rpm -qa java*

list-backup-dirs:
  cmd.run:
    - name: find / -type d -not -path "*/proc/*" -name backup* ; exit 0

list-cron-jobs:
  cmd.run:
    - name: cat /etc/cron.*/*
