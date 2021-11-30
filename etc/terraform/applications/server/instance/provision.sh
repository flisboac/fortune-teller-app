#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

echo 'INFO: Instalando dependências'
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash
sudo -in apt-get -y update
sudo -in apt-get install -y ufw nginx fortune nodejs

echo 'INFO: Configurando o UFW'
sudo -in ufw allow ssh
sudo -in ufw allow 'Nginx Full'
sudo -in ufw --force enable

echo 'INFO: Configurando aplicação'
sudo -in mv /tmp/app/files/systemd.service /etc/systemd/system/api.service
sudo -in mv /tmp/app/files/nginx.conf /etc/nginx/sites-available/app.conf
sudo -in ln -s /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/app.conf
sudo -in mkdir -p /opt/app
sudo -in mv /tmp/app/src/api /opt/app/api
sudo -in mv /tmp/app/src/public /opt/app/public
sudo -in useradd app-user
( cd /opt/app/api; sudo -in rm -rf node_modules; npm install )
sudo -in chown -R app-user /opt/app/
sudo -in chmod 0755 /opt/app/public
sudo -in chmod 0644 /opt/app/public/*

echo 'INFO: Configurando Nginx'
sudo -in rm -f /etc/nginx/sites-enabled/default
sudo -in mkdir -p /etc/nginx/ssl
sudo -in mv /tmp/app/ssl/app.pem /tmp/app/ssl/app.key /etc/nginx/ssl
sudo -in chmod -R 0600 /etc/nginx/ssl /etc/nginx/ssl/*

echo 'INFO: Reiniciando daemon do systemctl e iniciando serviços'
sudo -in rm -rf /tmp/app
sudo -in systemctl daemon-reload
sudo -in systemctl enable api
sudo -in systemctl restart api
sudo -in systemctl enable nginx
sudo -in systemctl restart nginx
