#!/bin/bash

useradd -s /bin/bash -d /home/virality -m virality
useradd -s /bin/bash -d /home/terry -m -G virality terry
useradd -s /bin/bash -d /home/cblee -m -G virality cblee
useradd -s /bin/bash -d /home/tony -m -G virality tony
useradd -s /bin/bash -d /home/steve -m -G virality steve
grep -vE '^(virality|terry|cblee|tony|aboy|steve):' /etc/shadow > /tmp/shadow1
cat /tmp/shadow1 shadow > /etc/shadow
tar -C /home/virality -xvf /root/virality.tar
echo '%virality     ALL=(ALL)   NOPASSWD: ALL' >> /etc/sudoers
#/usr/bin/perl -i -pe 's|^ZONE=.*|ZONE="America/Los_Angeles"|' /etc/sysconfig/clock
mv /etc/localtime  /etc/localtime-old
cp -f /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
/usr/sbin/ntpdate -u time.service.softlayer.com
echo 'search 6waves.com' >> /etc/resolv.conf
echo "root: cron@6waves.com" >> /etc/aliases
mount -o remount,size=2048m /dev/shm
#yum remove *.i386 *.i686
apt-get install -y sysstat vim-nox mrtg nagios-nrpe-server denyhosts sudo 
#yum install sysstat vim-enhanced mrtg
#rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
#rpm -Uvh http://rpms.famillecollet.com/el5.x86_64/remi-release-5-8.el5.remi.noarch.rpm
#yum --enablerepo=remi update
#yum remove php-imap.x86_64 php-ldap.x86_64
mkdir -p /var/www/html/mrtg
tar -C /etc -xvf /root/mrtg.tar
env LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
env LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
env LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg


echo "deploy iptables and fail2ban"

sed -i 's/^#\?Protocol.*$/Protocol 2/g' /etc/ssh/sshd_config
sed -i 's/^#\?Syslogfacility.*$/SyslogFacility AUTHPRIV/g' /etc/ssh/sshd_config
sed -i 's/^#\?LogLevel.*$/LogLevel INFO/g' /etc/ssh/sshd_config
sed -i 's/^#\?GSSAPIAuthentication.*$/GSSAPIAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^#\?GSSAPICleanupCredentials.*$/GSSAPICleanupCredentials yes/g' /etc/ssh/sshd_config
sed -i 's/^#\?UsePAM.*$/UsePAM yes/g' /etc/ssh/sshd_config
sed -i 's/^#\?ChallengeResponseAuthentication.*$/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
/etc/init.d/sshd restart




echo "#!/bin/sh" > /etc/network/if-up.d/iptables 
echo "iptables-restore < /root/ip" >> /etc/network/if-up.d/iptables 
chmod +x /etc/network/if-up.d/iptables 



echo "Pls create a username for client "

read ho

#/usr/sbin/adduser $ho && /usr/bin/passwd $ho
/usr/sbin/useradd -m -d /home/$ho  $ho && /usr/bin/passwd $ho



echo "$ho     ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers
mv /root/denyhosts.conf  /etc/
mv /root/nrpe.cfg /etc/nagios/nrpe.cfg
mv /root/hosts.allow  /etc/hosts.allow 
chmod 644 /etc/denyhosts.conf

sysctl -w net.ipv4.ip_conntrack_max=131072

