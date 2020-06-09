#!/bin/bash

FINISHED=false

until [ $FINISHED == true ]
do
  FLAGCHECK=true
  for flag in $@;
  do
    if [ ! -f "/var/run/bfflags/$flag" ];
    then
      FLAGCHECK=false
    fi
  done
  if [ $FLAGCHECK == true ]
  then
    FINISHED=true
  else
    sleep 5
  fi
done
