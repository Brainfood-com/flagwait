#!/bin/sh
#mysql 
set -e
echo "Restoring database..."

while ! mysqladmin ping -h $MYSQL_HOST --silent; do
  sleep 1
done

ls /run/secrets

restic dump \
  -p /run/secrets/restic-password \
  -H $RESTIC_HOST

echo "Restore complete"
touch /var/run/bfflags/loaded
