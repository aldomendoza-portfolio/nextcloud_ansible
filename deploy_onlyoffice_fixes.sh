#!/bin/bash
sudo docker exec onlyoffice sed -i 's/"allowPrivateIPAddress": false/"allowPrivateIPAddress": true/g' /etc/onlyoffice/documentserver/default.json
sudo docker exec onlyoffice sed -i 's/"allowMetaIPAddress": false/"allowMetaIPAddress": true/g' /etc/onlyoffice/documentserver/default.json
sudo docker exec onlyoffice sed -i 's/"rejectUnauthorized": true/"rejectUnauthorized": false/g' /etc/onlyoffice/documentserver/default.json
sudo docker restart onlyoffice
sleep 10
sudo docker exec -u 0 onlyoffice chmod -R 755 /var/www/onlyoffice/documentserver/sdkjs
sudo docker exec -u 33 nextcloud_app php occ config:app:delete onlyoffice jwt_secret
sudo docker exec -u 33 nextcloud_app php occ config:app:delete onlyoffice jwt_header
