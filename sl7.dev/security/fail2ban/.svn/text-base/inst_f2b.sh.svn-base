#!/bin/sh

ssh -t $1 "sudo sed -i 's/^#\?Protocol.*$/Protocol 2/g' /etc/ssh/sshd_config"
ssh -t $1 "sudo sed -i 's/^#\?Syslogfacility.*$/SyslogFacility AUTHPRIV/g' /etc/ssh/sshd_config"
ssh -t $1 "sudo sed -i 's/^#\?LogLevel.*$/LogLevel INFO/g' /etc/ssh/sshd_config"
ssh -t $1 "sudo sed -i 's/^#\?GSSAPIAuthentication.*$/GSSAPIAuthentication yes/g' /etc/ssh/sshd_config"
ssh -t $1 "sudo sed -i 's/^#\?GSSAPICleanupCredentials.*$/GSSAPICleanupCredentials yes/g' /etc/ssh/sshd_config"
ssh -t $1 "sudo sed -i 's/^#\?UsePAM.*$/UsePAM yes/g' /etc/ssh/sshd_config"
ssh -t $1 "sudo sed -i 's/^#\?ChallengeResponseAuthentication.*$/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config"
ssh -t $1 "sudo /etc/init.d/sshd restart"
scp -q jail.conf $1:/tmp/
ssh -t $1 "sudo yum -y install fail2ban"
ssh -t $1 "sudo mv /tmp/jail.conf /etc/fail2ban/;sudo chown root:root /etc/fail2ban/jail.conf;sudo chmod 444 /etc/fail2ban/jail.conf"
ssh -t $1 "sudo /etc/init.d/fail2ban restart"
ssh -t $1 "sudo /sbin/chkconfig  --level 2345 fail2ban on"
