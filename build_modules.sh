#!/bin/sh
# You can specify nginx version and list of modules
# via ENV variables

NGINX_VERSION=${NGINX_VERSION:-1.13.7}
GITHUB_MODULES=${GITHUB_MODULES:-openresty/headers-more-nginx-module nginx-modules/ngx_cache_purge opentracing-contrib/nginx-opentracing/opentracing }

sudo apt-get install devscripts build-essential lintian

for module in ${GITHUB_MODULES} ; do
    rm -rf /home/builduser/debuild
    ./build_module.sh -s -r 15 https://github.com/$(echo $module | sed 's#^\([^/]*\)/\([^/]*\)\(/[^/]*\)$#\1/\2#').git
done
