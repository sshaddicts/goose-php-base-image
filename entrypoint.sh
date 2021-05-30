#!/usr/bin/env sh
set -e

if [ "${APP_ENV}" != "prod" ]; then
  export OPCACHE_VALIDATE_TIMESTAMPS=1
fi

if [ "${XDEBUG_ENABLE}" = "true" ] || [ "${XDEBUG_ENABLE}" = "1" ]; then
  cat << EOF > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
    zend_extension=xdebug.so
    xdebug.client_host=\${XDEBUG_CLIENT_HOST}
EOF
fi

exec "$@"
