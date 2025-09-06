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

if command -v getenforce >/dev/null 2>&1 && [ "$(getenforce)" = "Enforcing" ]; then
  for p in 3000 3001 3002 3003; do
    semanage port -a -t http_port_t -p tcp "$p" 2>/dev/null || \
    semanage port -m -t http_port_t -p tcp "$p" || true
  done
fi

dnf -y makecache --refresh

dnf -y module reset nodejs
dnf -y module enable nodejs:18    
dnf -y install nodejs

git --version || true
node --version
npm --version

