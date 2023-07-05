#!/bin/bash

source ./.env

docker run --rm \
  -p 443:443 -p 80:80 --name letsencrypt \
  -v "kokuten_certs:/etc/letsencrypt" \
  -v "kokuten_certs-data:/var/lib/letsencrypt" \
  certbot/certbot certonly -n \
  -m $CERT_MAIL \
  -d $APP_HOST \
  --standalone --agree-tos
