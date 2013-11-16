### Intro
Pulse Audio is a sound system for Linux systems.<br>
xrdp sink is PA module for redirecting audio output from xrdp server to client over RDP.


### Building xrdp sink for PulseAudio
##### This is a temporary manual build procedure.  I hope to make this easier in the future.  Any help would be appreciated.
##### note: you don't have to build xrdp with special configuration for audio output redirection.
 
1. First we need to build xrdp pulse sink for your distro.<br>
You need to build this using the pulseaudio source code.<br>
(We don't need to install pulse from source, we just need the source code for the structures and header)
<br><br>
To get the source code for your distro, first make sure you have pulse installed.  Check by doing
pulseaudio –version
at the command prompt.
<br>
browse
http://freedesktop.org/software/pulseaudio/releases/
and grab the closes version to what you have.

**Examples**
* Debian 6
> jay@system76-x86:~$ pulseaudio --version <br>
> pulseaudio 0.9.21-rebootstrapped-dirty <br>
From this I know to download: pulseaudio-0.9.21.tar.gz

* Debian 7
> jay@system76-x86:~$ pulseaudio --version <br>
> pulseaudio 2.0 <br>
From this I know to download: pulseaudio-2.0.tar.gz

* CentOS 6.4
> [speidy@centos ~]$ pulseaudio --version <br>
> pulseaudio 0.9.21 <br>
From this I know to download: pulseaudio-0.9.21.tar.gz

2. extract and cd into pulseaudio source dir, then run
 
./configure
to get ./configure on pulse source to run, you might need to install


* Debian:
> apt-get install libjson0-dev
> apt-get install libsndfile1-dev
> apt-get install libspeex-dev
> apt-get install libspeexdsp-dev

* RHEL/CentOS:
> yum install libtool-ltdl-devel intltool libsndfile-devel speex-devel

Once you get ./configure to run, you are done with this part.  You don't need to actually build / install the downloaded pulse audio.

2. cd into xrdp/sesman/chansrv/pulse<br>
You need to edit the Makefile in order to build the pulse sink:<br>
Edit PULSE_DIR at the top of the file to point to pulseaudio source directory you extracted to above.<br>
Then run make.<br>
Then copy the file to pulseaudio system modules directory:<br>
/usr/lib/pulse-2.0/modules/<br>
or whatever your version is.
<br><br>

3. Now you need to change the pulse and alsa setting on the terminal server.
Note, this will break any local sound as all audio will go to the xrdp sink.
<br><br>
Create or change these files to look like this.  Make a backup first in case you want to go back.  Note, don't put the long lines of minus in the file, that is a seperator for this document.
 
* /etc/asound.conf
> pcm.pulse {<br>
> type pulse<br>
> }<br>
> ctl.pulse {<br>
> type pulse<br>
> }<br>
> pcm.!default {<br>
> type pulse<br>
> }<br>
> ctl.!default {<br>
> type pulse<br>
> }<br>


* /etc/pulse/default.pa
> .nofail <br>
> .fail <br>
> load-module module-augment-properties <br>
> load-module module-xrdp-sink <br>
> load-module module-native-protocol-unix <br>

<br>
More notes into sesman/chansrv/pulse/module-xrdp-sink.c
Have fun!

<br>
Jay
 