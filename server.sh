#!/bin/sh
dnf -y install epel-release dnf-plugins-core
dnf -y config-manager --set-enabled crb || true

dnf -y install nginx firewalld git policycoreutils-python-utils

systemctl enable --now nginx
systemctl enable --now firewalld

firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --permanent --zone=public --add-port=3000/tcp
firewall-cmd --permanent --zone=public --add-port=3001/tcp
firewall-cmd --permanent --zone=public --add-port=3002/tcp
firewall-cmd --permanent --zone=public --add-port=3003/tcp
firewall-cmd --reload

dnf -y makecache --refresh

dnf -y module reset nodejs
dnf -y module enable nodejs:18    
dnf -y install nodejs

git --version || true
node --version
npm --version

