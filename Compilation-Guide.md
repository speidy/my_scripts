# XRDP Server Compilation Guide


## Debian 6
_update system first, as root_
`apt-get update
apt-get upgrade
reboot`

_install required packages_
`apt-get install git autoconf libtool pkg-config gcc g++ make
apt-get install libssl-dev libpam0g-dev libjpeg-dev libx11-dev libxfixes-dev
apt-get install flex bison libxml2-dev intltool xsltproc xutils-dev python-libxml2 g++ xutils`

_get xrdp soruce code from github repository_
`cd ~
mkdir git
cd git
mkdir neutrinolabs
cd neutrinolabs
git clone git://github.com/neutrinolabs/xrdp.git`

_xrdp server building_
`cd xrdp
./bootstrap
./configure --enable-jpeg
make
make install`

_X11rdp building_
`cd xorg
cd X11R7.6
./buildx.sh /opt/X11rdp
_create the symbolic link for sesman_
ln -s /opt/X11rdp/bin/X11rdp /usr/local/bin/X11rdp`

_start xrdp / xrdp-sesman on boot_
`cp /etc/xrdp/xrdp.sh /etc/init.d/
update-rc.d xrdp.sh defaults`
