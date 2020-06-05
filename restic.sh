#!/bin/bash
source .env

AWS_ACCESS_KEY_ID=$(cat secrets/aws-access-key-id.txt | xargs)
AWS_SECRET_ACCESS_KEY=$(cat secrets/aws-secret-access-key.txt | xargs)

echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $RESTIC_URL

restic -r $RESTIC_URL -p ./secrets/restic-password.txt $@
