#!/bin/bash
cd ~/nextcloud_ansible
ansible server1 -i inventory/hosts.yml -m shell -a "find /opt/nextcloud/nextcloud/custom_apps/cadviewer -type f -name '*.php' -exec sed -i 's/getLogger()/get(\\\Psr\\\Log\\\LoggerInterface::class)/g' {} +"
ansible server1 -i inventory/hosts.yml -m command -a "docker exec -u www-data nextcloud_app php occ app:enable cadviewer"
