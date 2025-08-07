#!/bin/bash

# Bind dynamic Railway port only if PORT is a valid number
if [[ "$PORT" =~ ^[0-9]+$ ]]; then
  echo "Using PORT: $PORT"
  sed -i "s/Listen 80/Listen ${PORT}/" /etc/apache2/ports.conf
  sed -i "s/:80/:${PORT}/" /etc/apache2/sites-enabled/000-default.conf
else
  echo "Warning: PORT variable is invalid or not set. Using default port 80."
fi

exec "$@"
