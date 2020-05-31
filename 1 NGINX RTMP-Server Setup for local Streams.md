# Compile NGINX with RTMP and setup Multi-Streaming
These Scripts will install NGINX with the RTMP Module in the usual directories similar to installation with apt-get.


The RTMP-Server you get with this can then be used to do one ore more of the following:
 - deliver streams in a local network
 - deliver streams to websites similar to youtube
 - transcode rtmp streams to hls video
 - publish to multiple streaming providers
 - record livestreams to a harddrive
 - many, many more: Check the Docs on [Nginx RTMP-Module](https://github.com/arut/nginx-rtmp-module/wiki/Directives)


And it also runs flawless on the Raspberry Pi 4!

## Installation
If git is not present, install it: [Download Git](https://git-scm.com/downloads)


Get the Scripts:
```bash
git clone https://gist.github.com/489c5c0cf5a561a32f757d7513465344.git install_nginx
```

Change into the directory:
```bash
cd install_nginx
```

Then Run the main Script:
```bash
sudo install install_nginx.sh
```

Publish from OBS or another Streaming-Device to the following URL (where hostname is the Name or IP of your server).
```
rtmp://hostname:1935/live
```
If you have an api-key for example to publish to youtube, either set it in your OBS or alter the URL like so:
```
rtmp://hostname:1935/live/your-api-key
```

## Explanation
This script installs a rtmp-config which accepts Livestreams and accepts client-connections to play them.

By default the following options are disabled in the configuration file nginx.conf but you can enable and alter them according to your scenario:

### Publishing to Streaming-Service (i.e. Youtube):
If you enable the push option, every published stream will also be pushed to the provided server, by default youtube.

### local VLC Playback (i.e. on Raspberry Pi):
The second option is very handy if you want to Livestream into the internet but have to also Stream into another Room/Location at your site where an audience is watching.

The command after exec_publish will be executed when starting a livestream and will be killed on stop.

### remote VLC Playback
The Command can be altered to start the VLC-Window on another device if you use it with ssh.

To get this running you will have to do some things first, replace username and remote-client with the values fitting your setup:

```bash
sudo -u www-data ssh-keygen -t rsa -b 4096
sudo -u www-data ssh-copy-id username@remote-client

```
After that you can enable an option similar to this:
```bash
ssh -o "StrictHostKeyChecking no" user@remote-client "export DISPLAY=:0.0 && vlc -f --video-on-top --no-video-title-show --mouse-hide-timeout 1 rtmp://localhost/live/$name";
```


To see what the Scripts do exactly or what the config means, look into the Files below.


