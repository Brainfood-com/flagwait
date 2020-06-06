#!/bin/sh
#mysql 
set -e
echo "Restoring database..."

while ! mysqladmin ping -h $MYSQL_HOST --silent; do
  sleep 1
done

echo "Database is up. Restoring archive."

export AWS_ACCESS_KEY_ID="$(cat /run/secrets/aws-access-key-id)"
export AWS_SECRET_ACCESS_KEY="$(cat /run/secrets/aws-secret-access-key)"
export RESTIC_PASSWORD="$(cat /run/secrets/restic-password)"
export MYSQL_PASSWORD="$(cat /run/secrets/mysql-password)"
export BACKUP=$(restic -p /run/secrets/restic-password -H $RESTIC_HOST ls latest /backups | tail -n 1)

restic \
  -p /run/secrets/restic-password \
  -H $RESTIC_HOST \
  dump latest $BACKUP | zcat | mysql -h $MYSQL_HOST -u $MYSQL_USER --password=$MYSQL_PASSWORD $MYSQL_DATABASE

echo "Restore complete"
touch /var/run/bfflags/loaded
