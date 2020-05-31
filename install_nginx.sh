# update repository index and update
sudo apt update && sudo apt upgrade -y
# install build tools and NGINX requirements
sudo apt install -y git build-essential ffmpeg libpcre3 libpcre3-dev libssl-dev zlib1g-dev
# retrieve the latest RTMP-Module
git clone https://github.com/sergey-dryabzhinsky/nginx-rtmp-module.git
# retrieve NGINX (if you want the latest release update this path according to the NGINX Website: http://nginx.org/en/download.html
wget http://nginx.org/download/nginx-1.18.0.tar.gz
# extract the .tar.gz archive
tar -xf nginx-1.18.0.tar.gz
# change into the nginx directorx update this too if you are using another version!
cd nginx-1.18.0/

# configure nginx to desired settings before making, more infos about these options: https://www.nginx.com/resources/wiki/start/topics/tutorials/installoptions/
./configure --prefix=/usr/share/nginx \
            --sbin-path=/usr/sbin/nginx \
            --modules-path=/usr/lib/nginx/modules \
            --conf-path=/etc/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --pid-path=/run/nginx.pid \
            --lock-path=/var/lock/nginx.lock \
            --user=www-data \
            --group=www-data \
            --http-client-body-temp-path=/var/lib/nginx/body \
            --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
            --http-proxy-temp-path=/var/lib/nginx/proxy \
            --http-scgi-temp-path=/var/lib/nginx/scgi \
            --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
            --with-compat \
            --with-file-aio \
            --with-threads \
            --with-http_addition_module \
            --with-http_auth_request_module \
            --with-http_dav_module \
            --with-http_flv_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_mp4_module \
            --with-http_random_index_module \
            --with-http_realip_module \
            --with-http_slice_module \
            --with-http_ssl_module \
            --with-http_sub_module \
            --with-http_stub_status_module \
            --with-http_v2_module \
            --with-http_secure_link_module \
            --add-module=../nginx-rtmp-module \
            --with-mail \
            --with-mail_ssl_module \
            --with-stream \
            --with-stream_realip_module \
            --with-stream_ssl_module \
            --with-stream_ssl_preread_module \

# make with above options ( -j 1 limits it to one job)
make -j 1
# install nginx
sudo make install
# leave the nginx directory
cd ..

# remove the old nginx conf and replace it with the one from this gist.
sudo rm /etc/nginx/nginx.conf
sudo cp nginx.conf /etc/nginx/

# remove no longer needed folders and tarballs
rm -r nginx-1.18.0 nginx-rtmp-module
rm *.tar.gz

# place the service description into correct directory
sudo cp nginx.service /etc/systemd/system/

# initially start the nginx service
sudo systemctl start nginx.service

# enable the service to start at desired runtimes
sudo systemctl enable nginx.service