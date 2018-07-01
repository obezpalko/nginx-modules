#!/bin/sh
# You can specify nginx version and list of modules
# via ENV variables

NGINX_PLUS_RELEASE=${NGINX_PLUS_RELEASE:-15}
GITHUB_MODULES=${GITHUB_MODULES:-openresty/headers-more-nginx-module nginx-modules/ngx_cache_purge opentracing-contrib/nginx-opentracing}
ARTIFACTS_DIR=/tmp/nginx_modules_packages


mkdir -p ${ARTIFACTS_DIR}

for module in ${GITHUB_MODULES} ; do
	./build_module.sh -o ${ARTIFACTS_DIR} -s -y -r ${NGINX_PLUS_RELEASE} https://github.com/${module}.git
done


## Uploading packages to Artifactory
for package in $(ls ${ARTIFACTS_DIR}) ; do
    curl -u "admin:avIIon11" -XPUT "https://repo.dev.wixpress.com/artifactory/nginx-modules/${package};deb.distribution=stable;deb.component=main;deb.architecture=amd64" -T ${ARTIFACTS_DIR}/${package}
done

rm -rf ${ARTIFACTS_DIR}

