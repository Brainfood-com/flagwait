#!/bin/sh
#mysql 
set -e
echo "Restoring database..."

while ! mysqladmin ping -h $MYSQL_HOST --silent; do
  sleep 1
done

ls /run/secrets

export AWS_ACCESS_KEY_ID="$(cat /run/secrets/aws-access-key-id)"
export AWS_SECRET_ACCESS_KEY="$(cat /run/secrets/aws-secret-access-key)"

export RESTIC_PASSWORD="$(< /run/secrets/restic-password)"

restic dump \
  -p /run/secrets/restic-password \
  -H $RESTIC_HOST

echo "Restore complete"
touch /var/run/bfflags/loaded
