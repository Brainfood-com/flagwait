#!/bin/sh
echo Changing site name
ls -l /var/www/html
if [ ! -f /var/run/bfflags/db-translated ]; then
  wp search-replace https://proventermitesolutions.com http://pts.localhost
  wp search-replace https://www.proventermitesolutions.com http://pts.localhost
  touch /var/run/bfflags/db-translated
fi
