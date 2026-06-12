#!/bin/bash
set -euo pipefail

DEPLOY_DIR="$(cd "$(dirname "$0")" && pwd)"
DOMAIN_APP="pagechat.simongideon.me"
EMAIL="${CERTBOT_EMAIL:-email.delivery.adt@gmail.com}"

if [ "$(id -u)" -ne 0 ]; then
  echo "Run with sudo: sudo bash $0"
  exit 1
fi

mkdir -p /var/www/certbot
cp "$DEPLOY_DIR/system-nginx-pagechat-http.conf" /etc/nginx/sites-available/page-chat
ln -sf /etc/nginx/sites-available/page-chat /etc/nginx/sites-enabled/page-chat
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl reload nginx

certbot certonly --webroot \
  -w /var/www/certbot \
  -d "$DOMAIN_APP" \
  --email "$EMAIL" \
  --agree-tos \
  --no-eff-email \
  --non-interactive

cp "$DEPLOY_DIR/system-nginx-pagechat.conf" /etc/nginx/sites-available/page-chat
nginx -t
systemctl reload nginx

echo "SSL active for https://$DOMAIN_APP (admin at /admin)"
