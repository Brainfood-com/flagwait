#!/bin/sh
set -e
echo "Setup started"

chmod 666 /var/run/bfflags

ls /srv/bfsetup/parts

for f in /srv/bfsetup/parts/*.sh; do
  echo "Running $f"
  bash "$f" -H || break  # execute successfully or break
done

#/srv/bfsetup/restore-db.sh
echo "Setup complete"
touch /var/run/bfflags/setup
