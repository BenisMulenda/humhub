#!/bin/bash

# Replace Apache config ports with Railway-provided $PORT
if [[ -n "$PORT" ]]; then
  echo "Using Railway PORT: $PORT"
  sed -i "s/Listen 80/Listen ${PORT}/" /etc/apache2/ports.conf
  sed -i "s/:80>/:${PORT}>/" /etc/apache2/sites-available/000-default.conf
fi

# Start Apache in foreground
exec "$@"
