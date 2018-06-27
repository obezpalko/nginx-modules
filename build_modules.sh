#!/bin/sh
# You can specify nginx version and list of modules
# via ENV variables

NGINX_PLUS_RELEASE=${NGINX_PLUS_RELEASE:-15}
GITHUB_MODULES=${GITHUB_MODULES:-openresty/headers-more-nginx-module nginx-modules/ngx_cache_purge opentracing-contrib/nginx-opentracing}


for module in ${GITHUB_MODULES} ; do
    ./build_module.sh -o /tmp -s -y -r ${NGINX_PLUS_RELEASE} https://github.com/${module}.git
done


ls -l /tmp/*.deb
