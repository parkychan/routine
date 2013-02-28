#!/bin/bash


## Add users
useradd -s /bin/bash -d /home/virality -m virality
useradd -s /bin/bash -d /home/terry -m -G virality terry
useradd -s /bin/bash -d /home/cblee -m -G virality cblee
useradd -s /bin/bash -d /home/tony -m -G virality tony
useradd -s /bin/bash -d /home/steve -m -G virality steve 
grep -vE '^(virality|terry|cblee|tony|steve):' /etc/shadow > /tmp/shadow1
cat /tmp/shadow1 shadow > /etc/shadow

## clean up
rm /root/shadow
rm /tmp/shadow1

tar -C /home/virality -xvf /root/virality.tar
rm /root/virality.tar

echo '%virality     ALL=(ALL)   ALL' >> /etc/sudoers
echo 'virality     ALL=(ALL)   NOPASSWD: ALL' >> /etc/sudoers

/usr/bin/perl -i -pe 's|^ZONE=.*|ZONE="America/Los_Angeles"|' /etc/sysconfig/clock
cp -f /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
/usr/sbin/ntpdate -u time.service.softlayer.com
echo 'nameserver 208.67.220.220' >> /etc/resolv.conf
echo 'nameserver 208.67.222.222' >> /etc/resolv.conf
echo 'search 6waves.com' >> /etc/resolv.conf

echo "root: cron@6waves.com" >> /etc/aliases
mount -o remount,size=2048m /dev/shm

yum -y remove *.i386 *.i686
yum -y install sysstat vim-enhanced mrtg
#rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
rpm -Uvh http://ftp.cuhk.edu.hk/pub/linux/fedora-epel/5/x86_64/epel-release-5-4.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/el5.x86_64/remi-release-5-8.el5.remi.noarch.rpm
yum --enablerepo=remi update
yum -y remove php-imap.x86_64 php-ldap.x86_64
mkdir -p /var/www/html/mrtg
tar -C /etc -xvf /root/mrtg.tar
env LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
env LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
env LANG=C /usr/bin/mrtg /etc/mrtg/mrtg.cfg
yum -y install nrpe nagios-plugins-users nagios-plugins-load nagios-plugins-disk nagios-plugins-swap nagios-plugins-procs
rm /root/mrtg.tar

mv /root/nrpe.cfg /etc/nagios/nrpe.cfg
mv /root/check_conntrack.sh  /usr/lib64/nagios/plugins/

echo "deploy iptables and fail2ban"

sed -i 's/^#\?Protocol.*$/Protocol 2/g' /etc/ssh/sshd_config
sed -i 's/^#\?Syslogfacility.*$/SyslogFacility AUTHPRIV/g' /etc/ssh/sshd_config
sed -i 's/^#\?LogLevel.*$/LogLevel INFO/g' /etc/ssh/sshd_config
sed -i 's/^#\?GSSAPIAuthentication.*$/GSSAPIAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/^#\?GSSAPICleanupCredentials.*$/GSSAPICleanupCredentials yes/g' /etc/ssh/sshd_config
sed -i 's/^#\?UsePAM.*$/UsePAM yes/g' /etc/ssh/sshd_config
sed -i 's/^#\?ChallengeResponseAuthentication.*$/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
/etc/init.d/sshd restart
yum -y install fail2ban
#yum -y install denyhosts

mv /root/jail.conf /etc/fail2ban/;chown root:root /etc/fail2ban/jail.conf;chmod 444 /etc/fail2ban/jail.conf
#mv /root/denyhosts.conf /etc/denyhosts.conf ; mv /root/hosts.allow /etc/hosts.allow; chown root:root /etc/denyhosts.conf ;chmod 600 /etc/denyhosts.conf

/sbin/iptables-restore < /root/ip
rm /root/ip
/sbin/service iptables save
/etc/init.d/iptables start
/etc/init.d/fail2ban restart

echo "Pls create a username for client "

read ho

/usr/sbin/adduser $ho && /usr/bin/passwd $ho



echo "$ho     ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers
sysctl -w net.ipv4.ip_conntrack_max=131072

