#!/bin/bash
source .env

export AWS_ACCESS_KEY_ID=$(cat secrets/aws-access-key-id.txt | xargs)
export AWS_SECRET_ACCESS_KEY=$(cat secrets/aws-secret-access-key.txt | xargs)
export RESTIC_REPOSITORY
export RESTIC_HOST

restic -p ./secrets/restic-password.txt -H $RESTIC_HOST $@
