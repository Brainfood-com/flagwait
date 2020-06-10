#!/bin/sh
echo Changing site name
ls -l /var/www/html
if [ ! -f /var/run/bfflags/db-translated ]; then
  for site in $FROM_SITES; do
    wp search-replace $site http://$VIRTUAL_HOST
  done
  touch /var/run/bfflags/db-translated
fi
