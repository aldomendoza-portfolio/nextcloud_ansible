#!/bin/bash
cd ~/nextcloud_ansible

# Reemplazar usos de OCP\ILogger por Psr\Log\LoggerInterface
ansible server1 -i inventory/hosts.yml -m shell -a "find /opt/nextcloud/nextcloud/custom_apps/cadviewer -type f -name '*.php' -exec sed -i 's/OCP\\\\ILogger/Psr\\\\Log\\\\LoggerInterface/g' {} +"

# Reemplazar la palabra ILogger por LoggerInterface (por si la importación ya se había reemplazado pero el tipo en la función no)
ansible server1 -i inventory/hosts.yml -m shell -a "find /opt/nextcloud/nextcloud/custom_apps/cadviewer -type f -name '*.php' -exec sed -i 's/ ILogger/ LoggerInterface/g' {} +"
ansible server1 -i inventory/hosts.yml -m shell -a "find /opt/nextcloud/nextcloud/custom_apps/cadviewer -type f -name '*.php' -exec sed -i 's/(ILogger/(LoggerInterface/g' {} +"

# Limpiar caché de opcache si es necesario (reiniciando contenedor de app)
ansible server1 -i inventory/hosts.yml -m command -a "docker restart nextcloud_app"
