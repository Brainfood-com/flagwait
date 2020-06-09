#!/bin/sh
#mysql 
set -e
echo "* Restoring database..."

chmod 777 /var/run/bfflags

while ! mysqladmin ping -h $MYSQL_HOST --silent; do
  sleep 1
done

echo "- MariaDB is up."

export AWS_ACCESS_KEY_ID="$(cat /run/secrets/aws-access-key-id)"
export AWS_SECRET_ACCESS_KEY="$(cat /run/secrets/aws-secret-access-key)"
export RESTIC_PASSWORD="$(cat /run/secrets/restic-password)"
export MYSQL_PASSWORD="$(cat /run/secrets/mysql-password)"

export DB_EXISTS=$(mysql -h $MYSQL_HOST -u $MYSQL_USER --password=$MYSQL_PASSWORD $MYSQL_DATABASE -sse "select count(*) from information_schema.tables where table_schema='$MYSQL_DATABASE' and table_name='wp_users';")

if [ "$DB_EXISTS" -eq "1" ]; then
  echo "- Database exists and is loaded"
else
  echo "- Database does not exist. Checking for latest available backup."
  export BACKUP=$(restic -p /run/secrets/restic-password -H $RESTIC_HOST ls latest /backups | tail -n 1)
  echo "- Retrieving and loading $BACKUP"
  restic \
    -p /run/secrets/restic-password \
    -H $RESTIC_HOST \
    dump latest $BACKUP | zcat | mysql -h $MYSQL_HOST -u $MYSQL_USER --password=$MYSQL_PASSWORD $MYSQL_DATABASE
fi

if [ -d /var/www/html/wp-content/themes/klaus ]; then
  echo "- Site files exist."
else
  echo "- Site files do not exist, loading from archive"
  restic \
    -p /run/secrets/restic-password \
    -H $RESTIC_HOST \
    --target /tmp \
    --include /data \
    restore latest
  rsync -r /tmp/data/www/ /var/www/html/
  rm -r /tmp/data

cat > /var/www/etc/wp-config.php <<EOF 
<?php
#This will disable the update notification.
define('WP_CORE_UPDATE', false);

define('DB_NAME', '$MYSQL_DATABASE');
define('DB_USER', '$MYSQL_USER');
define('DB_PASSWORD', '$MYSQL_PASSWORD');
define('DB_HOST', '$MYSQL_HOST');
EOF

cat > /var/www/html/wp-config.php <<EOF 
<?php
require_once(ABSPATH . '../etc/wp-config.php');
\$server = '$MYSQL_HOST';
\$loginsql = '$MYSQL_USER';
\$passsql = '$MYSQL_PASSWORD';
\$base = '$MYSQL_DATABASE';
\$table_prefix  = 'wp_';

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
        define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
?>
EOF
fi

echo "* Restore complete"

touch /var/run/bfflags/loaded
