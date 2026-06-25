#!/bin/bash
set -euo pipefail

LOG_TAG="[page-chat-ssl-renew]"
DEPLOY_DIR="$(cd "$(dirname "$0")" && pwd)"
NGINX_CONF="$DEPLOY_DIR/system-nginx-pagechat.conf"

echo "$LOG_TAG $(date -Is) starting renewal"

docker run --rm \
  -v /etc/letsencrypt:/etc/letsencrypt \
  -v /var/lib/letsencrypt:/var/lib/letsencrypt \
  -v /var/www/certbot:/var/www/certbot \
  certbot/certbot renew --webroot -w /var/www/certbot --quiet

# Always ensure the HTTPS nginx config is active (not the temporary HTTP-only file)
docker run --rm \
  -v "$NGINX_CONF:/tmp/page-chat.conf:ro" \
  -v /etc/nginx/sites-available:/etc/nginx/sites-available \
  alpine:3.20 cp /tmp/page-chat.conf /etc/nginx/sites-available/page-chat

docker run --rm --privileged --pid host -v /run:/run alpine sh -c \
  'kill -HUP $(cat /run/nginx.pid)'

echo "$LOG_TAG $(date -Is) renewal complete, nginx reloaded"
