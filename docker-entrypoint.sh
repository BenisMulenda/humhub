#!/bin/bash

# Bind to dynamic Railway port
export PORT=${PORT:-80}
sed -i "s/80/${PORT}/g" /etc/apache2/ports.conf
sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-enabled/000-default.conf

# Start cron task loop in the background
(
  while true; do
    /var/www/html/protected/yii queue/run >/dev/null 2>&1
    /var/www/html/protected/yii cron/run >/dev/null 2>&1
    sleep 60
  done
) &

# Start Apache
exec apache2-foreground
