#!/bin/bash
find / -type f -not -path "*/proc/*" -name java -print -exec ls -lah {} \; 
find / -type f -not -path "*/proc/*" -name java -print -exec ls -lu {} \;
find / -type f -not -path "*/proc/*" -name java -exec sh -c 'echo {};{} -version;echo' \; 
rpm -qa java*
find / -type d -not -path "*/proc/*" -name backup* ; exit 0
​
cat /etc/cron.*/*
