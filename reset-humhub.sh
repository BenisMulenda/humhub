#!/bin/bash

# Constants — update if needed
HUMHUB_DIR="/var/www/html"
CONFIG_DIR="$HUMHUB_DIR/protected/config"
ASSETS_DIR="$HUMHUB_DIR/assets"
RUNTIME_DIR="$HUMHUB_DIR/protected/runtime"

MYSQL_HOST="mysql.railway.internal"
MYSQL_PORT=3306
MYSQL_USER="root"
MYSQL_PASS="your_mysql_password_here"
MYSQL_DB="railway"

echo "🧼 Resetting HumHub installation..."

# 1. Remove dynamic config if it exists
echo "🗑️  Removing dynamic config..."
rm -f "$CONFIG_DIR/dynamic.php"

# 2. Clear assets and runtime directories
echo "🧹 Clearing cache directories..."
rm -rf "$ASSETS_DIR"/* "$RUNTIME_DIR"/*

# 3. Drop and recreate MySQL database
echo "💣 Dropping and recreating MySQL database..."
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASS" <<EOF
DROP DATABASE IF EXISTS $MYSQL_DB;
CREATE DATABASE $MYSQL_DB CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
EOF

# 4. Restart Apache if inside Docker
if [ -x "$(command -v apache2ctl)" ]; then
    echo "🔁 Restarting Apache..."
    apache2ctl restart
fi

echo "✅ Reset complete. Visit your HumHub URL to reinstall."
