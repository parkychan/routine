# install kvm package

apt-get install ubuntu-virt-server python-vm-builder kvm-ipxe  virtinst


# add user into group

adduser `id -un` libvirtd
adduser `id -un` kvm

#check status

virsh -c qemu:///system list

#setup bridge

apt-get install bridge-utils

echo " Please setup bridge interface e.g. vi /etc/network/interfaces "

# restart the network

/etc/init.d/networking restart

echo "setup images folder"
mkdir -p /usr/local/src/images/vm1/mytemplates/libvirt

cp /etc/vmbuilder/libvirt/* /usr/local/src/images/vm1/mytemplates/libvirt/


cat >> /usr/local/src/images/vm1/vmbuilder.partition  << EOF


root 8000
swap 4000
---

EOF


cat >>  /usr/local/src/images/vm1/boot.sh <<EOF

# This script will run the first time the virtual machine boots
# It is ran as root.

# Expire the user account
passwd -e ec2-user

# Install openssh-server
apt-get update
apt-get install -qqy --force-yes openssh-server

EOF







cd /usr/local/src/images/vm1/


vmbuilder kvm ubuntu --suite=natty --flavour=virtual --arch=amd64 --mirror=http://de.archive.ubuntu.com/ubuntu -o --libvirt=qemu:///system --ip=192.168.0.101 --gw=192.168.0.1 --part=vmbuilder.partition --templates=mytemplates --user=ec2-user --name=ec2-user --pass=6waves0101 --addpkg=vim-nox --addpkg=unattended-upgrades --addpkg=acpid --firstboot=/usr/local/src/images/vm1/boot.sh --mem=256 --hostname=vm1 --bridge=br0 -t /usr/local/src/tmp/




virsh list --all




#### LVM instance

mkdir -p /usr/local/src/images/vm1/mytemplates/libvirt

cp /etc/vmbuilder/libvirt/* /usr/local/src/images/vm1/mytemplates/libvirt/


cat >> /usr/local/src/images/vm1/vmbuilder.partition  << EOF


root 8000
swap 4000
---

EOF


cat >>  /usr/local/src/images/vm1/boot.sh <<EOF

# This script will run the first time the virtual machine boots
# It is ran as root.

# Expire the user account
passwd -e ec2-user

# Install openssh-server
apt-get update
apt-get install -qqy --force-yes openssh-server


lvcreate -L20G -n vm3 vg0

#We can now create the new VM as follows:

cd /usr/local/src/images/vm3/

vmbuilder kvm ubuntu --suite=natty --flavour=virtual --arch=amd64 --mirror=http://de.archive.ubuntu.com/ubuntu -o --libvirt=qemu:///system --ip=192.168.0.103 --gw=192.168.0.1 --part=vmbuilder.partition --raw=/dev/mapper/vg0-vm3 --templates=mytemplates --user=ec2-user --name=ec2-user --pass=6waves0101 --addpkg=vim-nox --addpkg=unattended-upgrades --addpkg=acpid --firstboot=/usr/local/src/images/vm3/boot.sh --mem=256 --hostname=vm3 --bridge=br0 -t /usr/local/src/tmp/

#Please note that I use --raw=/dev/mapper/vg0-vm3 instead of --raw=/dev/vg0/vm3 switch - both /dev/vg0/vm3 and /dev/mapper/vg0-vm3 are symlinks that point to the same logical volume - /dev/dm-2 in my case - but when I used --raw=/dev/vg0/vm3 the vmbuilder process failed with the following error message...


define /usr/local/src/vm3.xml


start vm3
