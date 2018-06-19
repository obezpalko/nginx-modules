#!/bin/sh
# You can specify nginx version and list of modules
# via ENV variables

NGINX_VERSION=${NGINX_VERSION:-1.13.7}
GITHUB_MODULES=${GITHUB_MODULES:-openresty/headers-more-nginx-module nginx-modules/ngx_cache_purge opentracing-contrib/nginx-opentracing/opentracing }

dynamic_modules=""

for module in ${GITHUB_MODULES} ; do
    ./build_module.sh -r 15 https://github.com/$(echo $module | sed 's#^\([^/]*\)/\([^/]*\)\(/[^/]*\)$#\1/\2#').git
done

