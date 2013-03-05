function usage() {
usage: $0 [hs - for host server setup]
}

majortomcatversion=5
setup=customer
while [ -n "$1" ]; do
    case "$1" in
    hs)
        setup=hs
        ;;
    custom)
        setup=custom
        ;;
    --version) 
	shift
        if [ -z "$1" ]; then
                echo "Exiting: no version"
		usage
                exit 1
        fi
	majortomcatversion=$1
	;;
    *)
        usage
        exit 1;
        ;;
    esac
    shift
done

if [ "$majortomcatversion" = "5" ]; then
export tomcatversion=5.5.25
tomcaturl="http://www.apache.org/dist/tomcat/tomcat-5/v$tomcatversion/bin/apache-tomcat-$tomcatversion.tar.gz"
elif  [ "$majortomcatversion" = "6" ]; then
export tomcatversion=6.0.14
tomcaturl="http://apache.mirror99.com/tomcat/tomcat-6/v$tomcatversion/bin/apache-tomcat-$tomcatversion.tar.gz"
fi

if [ "$setup" = "custom" ]; then
true
elif [ "$setup" = "customer" ]; then
remexample=n
disableunpackwars=n
reducesparethreads=y
installadmin=y
runonstartup=n
elif [ "$setup" = "hs" ]; then
remexample=y
disableunpackwars=y
reducesparethreads=y
installadmin=n
runonstartup=y
else
	echo "unrecognized option '$1'.  Expecting $0 cust/hs"
fi
{
cd /usr/local
tomcatscripts=`find /etc/init.d/ | grep tomcat`
if [ ! -z "$tomcatscripts" ]; then
    for i in /etc/init.d/tomcat*; do
    $i stop
    mv $i /root
    done
fi
if [ ! -e /usr/bin/replace ]; then
wget -O - http://downloads.rimuhosting.com/replace > /usr/bin/replace
chmod +x /usr/bin/replace
fi

wget -O - "http://downloads.rimuhosting.com/javainitscript" > /etc/init.d/tomcat
if [ $? -ne 0 ]; then echo "failed downloading init script" >&2; return 1; fi
replace "TOMCAT_USER=tomcat4" "TOMCAT_USER=tomcat" -- /etc/init.d/tomcat
if [ $? -ne 0 ]; then echo "failed replacing the tomcat user name " >&2; return 1; fi
chmod +x /etc/init.d/tomcat
if [ -e /usr/local/tomcat ]; then
	echo "Moving original tomcat directory to /usr/local/tomcat.old"
	mv /usr/local/tomcat /usr/local/tomcat.old
fi
wget -O - "$tomcaturl" | tar xz
if [ $? -ne 0 ]; then echo "failed downloading tomcat itself " >&2; return 1; fi
# needed on tomcat 5.5 for it to work with a 1.4 jdk
if [ "$majortomcatversion" = "5" ] ; then
wget -O - "http://www.apache.org/dist/tomcat/tomcat-5/v$tomcatversion/bin/apache-tomcat-$tomcatversion-compat.tar.gz" 2>/dev/null| tar xz 2>/dev/null
if [ $? -ne 0 ]; then echo "failed downloading tomcat itself " >&2; return 1; fi
fi

mv /usr/local/apache-tomcat-$tomcatversion /usr/local/tomcat
cd /usr/local/tomcat

echo "/usr/local/tomcat/logs/*.txt /usr/local/tomcat/logs/*.out{
copytruncate
weekly
rotate 5
compress
missingok
}" > /etc/logrotate.d/tomcat

echo 'JAVA_OPTS="-Xms16m -Xmx48m -Djava.awt.headless=true"' > bin/setenv.sh
wget -O - http://downloads.rimuhosting.com/mysql-connector-java-5.0.5-bin.jar > common/lib/mysql-connector.jar
if [ $? -ne 0 ]; then echo "failed downloading the mysql connector" >&2; return 1; fi
wget -O - http://downloads.rimuhosting.com/mail.jar > common/lib/mail.jar
if [ $? -ne 0 ]; then echo "failed downloading the mail.jar " >&2; return 1; fi
wget -O - http://downloads.rimuhosting.com/activation.jar > common/lib/activation.jar
if [ $? -ne 0 ]; then echo "failed downloading the activation jar " >&2; return 1; fi
if [ -e /etc/debian_version ]; then
adduser --shell /sbin/nologin --home /usr/local/tomcat --system tomcat 
else 
adduser tomcat -s /sbin/nologin -d /usr/local/tomcat
fi
chown -R tomcat /usr/local/tomcat
chown -R tomcat /usr/local/tomcat/*

#for security reasons
cd /usr/local/tomcat
mkdir webapps.removed
mv server/webapps webapps.removed/server.webapps
mv webapps/balancer webapps/webdav webapps.removed/
mv conf/Catalina/localhost/*.xml webapps.removed/
# maybe these too
while true; do
if [ -z "$remexample" ]; then
echo -n "Want to remove all the example and doc webapps? [y/n] "
read remexample
fi
if [ "$remexample" = "n" ]; then break; fi
if [ "$remexample" != "y" ]; then continue; fi
echo "Removing the webapp examples"
mv webapps/jsp-examples webapps/servlets-examples webapps/tomcat-docs webapps/ROOT webapps.removed/
break
done
while true; do
if [ -z "$disableunpackwars" ]; then
echo -n "disable unpackwars? [y/n] "
read disableunpackwars
fi
if [ "$disableunpackwars" = "n" ]; then break; fi
if [ "$disableunpackwars" != "y" ]; then continue; fi
echo "disabling the unpackWARs option"
replace "unpackWARs=\"true\"" "unpackWARs=\"false\"" -- conf/server.xml
break
done

while true; do
if [ -z "$reducesparethreads" ]; then
echo -n "reduce big spare thread count ? [y/n] "
read reducesparethreads
fi
if [ "$reducesparethreads" = "n" ]; then break; fi
if [ "$reducesparethreads" != "y" ]; then continue; fi
echo "Reducing the number of spare threads"
basedir=/usr/local/tomcat/conf/
replace "minSpareThreads=\"25\"" "minSpareThreads=\"1\"" -- $basedir/server.xml
replace "maxSpareThreads=\"75\"" "maxSpareThreads=\"2\"" -- $basedir/server.xml
replace "maxSpareThreads=\"25\"" "maxSpareThreads=\"2\"" -- $basedir/server.xml
replace "maxSpareThreads=\"15\"" "maxSpareThreads=\"2\"" -- $basedir/server.xml
replace "tcpThreadCount=\"6\"" "tcpThreadCount=\"1\"" -- $basedir/server.xml
replace 'maxThreads="4"' 'maxThreads="2"' -- $basedir/server.xml
replace 'minSpareThreads="2"' 'minSpareThreads="1"' -- $basedir/server.xml
replace 'maxSpareThreads="4"' 'maxSpareThreads="2"' -- $basedir/server.xml
# make the ajp protocol listen just on the localhost address
replace 'redirectPort="8443" protocol="AJP/1.3"' 'redirectPort="8443" address="127.0.0.1" protocol="AJP/1.3"' -- $basedir/server.xml
replace 'Connector port="8009" protocol'  'Connector port="8009" address="127.0.0.1" protocol' -- $basedir/server.xml
break
done


while true; do
if [ -z "$installadmin" ]; then
echo -n "install the admin webapp (default to n normally and only for 5.5+ in any case) ? [y/n] "
read installadmin
fi
if [ "$majortomcatversion" != "5" ]; then
	break;
fi
if [ "$installadmin" = "n" ]; then break; fi
if [ "$installadmin" != "y" ]; then continue; fi
	cd /usr/local
	mv tomcat apache-tomcat-$tomcatversion
	if [ $? -ne 0 ]; then echo "could not find tomcat dir " >&2; exit 1; fi
	echo "installing the admin webapp"
	wget -O - "http://www.apache.org/dist/tomcat/tomcat-5/v$tomcatversion/bin/apache-tomcat-$tomcatversion-admin.tar.gz" 2>/dev/null| tar xz 2>/dev/null
	if [ $? -ne 0 ]; then echo "could not download/extract the admin tarball " >&2; exit 1; fi
	mv apache-tomcat-$tomcatversion tomcat
break
done

while true; do
if [ -z "$runonstartup" ]; then
echo -n "make tomcat run on startup? [y/n] "
read runonstartup
fi
if [ "$runonstartup" = "n" ]; then break; fi
if [ "$runonstartup" != "y" ]; then continue; fi
# make tomcat start on startup
echo "Making tomcat run on startup"
if [ -e /etc/debian_version ]; then
	update-rc.d tomcat defaults
else 
	chkconfig --add tomcat
fi
# and start it up now
/etc/init.d/tomcat start
break
done

}
