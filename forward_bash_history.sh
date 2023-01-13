#!/bin/bash
# Author: Ali_Alwashali
 
if test -f "/etc/bashrc"; then  
    FILE=/etc/bashrc
else 
    FILE=/etc/bash.bashrc
fi


cat << EOF >> $FILE

# Added: bash history logging
export HISTTIMEFORMAT="%F %T "
export PROMPT_COMMAND='logger -p local6.debug "\$(whoami) \$(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" ) [\$?]"'
EOF



# create log file and assign permission to syslog user
mkdir /var/log/bash_history/
touch /var/log/bash_history/bash_history.log
chown syslog /var/log/bash_history/bash_history.log


cat << EOF > /etc/rsyslog.d/bash_history_forwarding.conf
local6.*    /var/log/bash_history/bash_history.log
EOF

# select the facility you want, *.* is very intense. authpriv.* could be a good start
cat << EOF >> /etc/rsyslog.conf
## logs fowarding to syslog server 
*.*;local6.*                                          @syslog_IP:514
EOF


cat << EOF > /etc/rsyslog.d/bash_history_forwarding.conf
local6.*    /var/log/bash_history/bash_history.log
EOF

# rotate file
cat << EOF >> /etc/logrotate.d/bash_history
/var/log/bash_history/*.log {
    maxsize 50M
    hourly
    missingok
    rotate 8
    compress
    notifempty
    nocreate
}
EOF


sudo systemctl restart rsyslog.service

