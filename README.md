# log_bash_history

Log bash history to syslog server

Steps 
- Clone the repository
- Replace syslog_IP with your syslog IP
- Run sh forward_bash_history.sh as root 

You may need to select the appropriate syslog facility and severity as per your need. Script forwards \*.\* which could be very intense.  
