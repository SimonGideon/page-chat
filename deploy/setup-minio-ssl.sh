#!/bin/bash
# Sets up SSL for minio.simongideon.me and enables the Nginx vhost.
# Run on the server: bash ~/page_chat/deploy/setup-minio-ssl.sh

set -e

DOMAIN="minio.simongideon.me"
NGINX_CONF="/etc/nginx/sites-available/minio.conf"
NGINX_LINK="/etc/nginx/sites-enabled/minio.conf"
WEBROOT="/var/www/certbot"

echo "=== [1/4] Creating ACME webroot ==="
sudo mkdir -p "$WEBROOT"

echo "=== [2/4] Installing temporary HTTP-only nginx block for ACME ==="
sudo tee /etc/nginx/sites-available/minio-temp.conf > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN;
    location /.well-known/acme-challenge/ { root $WEBROOT; }
    location / { return 200 'ok'; add_header Content-Type text/plain; }
}
EOF
sudo ln -sf /etc/nginx/sites-available/minio-temp.conf /etc/nginx/sites-enabled/minio-temp.conf
sudo nginx -t && sudo systemctl reload nginx

echo "=== [3/4] Obtaining SSL certificate ==="
sudo certbot certonly --webroot -w "$WEBROOT" -d "$DOMAIN" --non-interactive --agree-tos \
  -m simongideon918@gmail.com

echo "=== [4/4] Installing MinIO nginx config ==="
sudo cp ~/page_chat/deploy/system-nginx-minio.conf "$NGINX_CONF"
sudo ln -sf "$NGINX_CONF" "$NGINX_LINK"
sudo rm -f /etc/nginx/sites-enabled/minio-temp.conf
sudo nginx -t && sudo systemctl reload nginx

echo ""
echo "✅ Done! MinIO is now available at:"
echo "   Console : https://$DOMAIN"
echo "   S3 API  : https://$DOMAIN:9000"
