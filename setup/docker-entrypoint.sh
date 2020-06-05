#!/bin/sh
echo "Setup started"
/srv/bfsetup/restore-db.sh
echo "Setup complete"
touch /var/run/bfflags/setup
