# XRDP Server Compilation Guide


## Debian 6
_update system first, run as root_
<pre>
apt-get update
apt-get upgrade
reboot
</pre>

_install required packages_
<pre>
apt-get install git autoconf libtool pkg-config gcc g++ make
apt-get install libssl-dev libpam0g-dev libjpeg-dev libx11-dev libxfixes-dev
apt-get install flex bison libxml2-dev intltool xsltproc xutils-dev python-libxml2 g++ xutils
</pre>

_get xrdp soruce code from github repository_
<pre>
cd ~
mkdir git
cd git
mkdir neutrinolabs
cd neutrinolabs
git clone git://github.com/neutrinolabs/xrdp.git
</pre>

_xrdp server building_
<pre>
cd xrdp
./bootstrap
./configure --enable-jpeg
make
make install
</pre>

_X11rdp building_
<pre>
cd xorg
cd X11R7.6
./buildx.sh /opt/X11rdp
</pre>
_create the symbolic link for sesman_
<pre>
ln -s /opt/X11rdp/bin/X11rdp /usr/local/bin/X11rdp
</pre>

_start xrdp / xrdp-sesman on boot_
<pre>
cp /etc/xrdp/xrdp.sh /etc/init.d/
update-rc.d xrdp.sh defaults
</pre>