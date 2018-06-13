#!/bin/sh
# You can specify nginx version and list of modules
# via ENV variables

NGINX_VERSION=${NGINX_VERSION:-1.13.7}
GITHUB_MODULES=${GITHUB_MODULES:-openresty/headers-more-nginx-module nginx-modules/ngx_cache_purge opentracing-contrib/nginx-opentracing/opentracing }

apt-get -y install libpcre3-dev libssl-dev git-core gnupg2 g++
[ -r "nginx-${NGINX_VERSION}.tar.gz" ] || wget -q http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
[ -r "nginx-${NGINX_VERSION}.tar.gz.asc" ] || wget -q http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc
gpg2 --list-keys a1c052f8 2>/dev/null || gpg2 --keyserver ipv4.pool.sks-keyservers.net --recv a1c052f8
# curl -s -L http://nginx.org/keys/nginx_signing.key | gpg2 --import
gpg2 --verify nginx-${NGINX_VERSION}.tar.gz.asc nginx-${NGINX_VERSION}.tar.gz || ( echo Cannot verify nginx. exiting && exit )

tar xzvf nginx-${NGINX_VERSION}.tar.gz
mv nginx-${NGINX_VERSION} nginx

dynamic_modules=""

for module in ${GITHUB_MODULES} ; do
    git clone https://github.com/$(echo $module | sed 's#^\([^/]*\)/\([^/]*\)\(/[^/]*\)$#\1/\2#').git
    stripped_module=$(echo ${module} | sed 's#^[^/]*/##')
    dynamic_modules="${dynamic_modules} --add-dynamic-module=$(pwd)/${stripped_module}"
done

cd nginx

./configure --with-compat \
    --with-http_ssl_module \
    ${dynamic_modules}

make
