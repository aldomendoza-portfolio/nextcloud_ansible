# Despliegue de Nextcloud en Producción

Este repositorio contiene las configuraciones necesarias de Ansible para desplegar un entorno de producción de Nextcloud con Docker, Traefik, PostgreSQL, Redis, OnlyOffice y Coturn (para Nextcloud Talk).

## Requisitos Previos

1. Instalar la colección de Docker para Ansible en la máquina desde donde se ejecutará (tu equipo local):
   ```bash
   ansible-galaxy collection install community.docker
   ansible-galaxy collection install community.crypto
   ```

2. Configurar el registro DNS:
   Asegúrate de que tus dominios `<TU_DOMINIO_NEXTCLOUD>` y `<TU_DOMINIO_ONLYOFFICE>` (para OnlyOffice) apunten a la IP `<TU_IP_PUBLICA>`.

## Ejecución

1. La primera vez que ejecutes el playbook, Ansible necesitará usar el usuario `root` y su contraseña. Asegúrate de tener esto configurado o modificar el archivo `inventory/hosts.yml` si usas llaves temporales de root.

2. Ejecutar el playbook:
   ```bash
   ansible-playbook deploy.yml --ask-pass
   ```
   *Nota: `--ask-pass` te pedirá la contraseña del usuario root del servidor.*

## ¿Qué hace este proyecto?

1. **Seguridad**: Crea el usuario configurado en `group_vars/all.yml`, genera una llave SSH para conectarte, deshabilita el acceso con contraseña por SSH y bloquea completamente a `root`. **(La llave privada se guardará en la carpeta `ssh_keys/` de este proyecto)**.
2. **Docker**: Instala Docker Engine y Docker Compose de forma automática.
3. **Traefik**: Despliega Traefik como proxy reverso, solicitando automáticamente un certificado HTTPS a Let's Encrypt para tus dominios.
4. **Nextcloud**: Levanta el contenedor de Nextcloud conectado a PostgreSQL y usando Redis como caché.
5. **OnlyOffice y Talk**: Despliega un servidor de documentos para edición y un servidor STUN/TURN (`coturn`) en el puerto 3478 para llamadas de audio/video.

## Post-Instalación

1. Extrae tu llave generada en `ssh_keys/<NUEVO_USUARIO>_ed25519` a un lugar seguro. A partir de ahora, accederás al servidor con:
   ```bash
   ssh -i ruta/a/tu/llave <NUEVO_USUARIO>@<TU_IP_PUBLICA>
   ```

2. Accede a `https://<TU_DOMINIO_NEXTCLOUD>`. El instalador inicial de Nextcloud ha sido configurado en base a las credenciales en `group_vars/all.yml`. Por defecto:
   - **Usuario**: `admin`
   - **Contraseña**: La definida en `nextcloud_admin_password`
   *(¡Recuerda cambiar esto en la interfaz inmediatamente!)*

3. Para configurar **OnlyOffice** dentro de Nextcloud, ve a las aplicaciones, instala el conector de OnlyOffice y en la configuración introduce la dirección: `https://<TU_DOMINIO_ONLYOFFICE>` con la clave secreta definida en `onlyoffice_jwt_secret`.

4. Para configurar **Nextcloud Talk**, ve a Ajustes > Talk, en el servidor STUN/TURN, añade la IP `<TU_IP_PUBLICA>:3478`, con protocolo UDP y TCP, e introduce el secreto definido en `turn_secret`.

5. Para usar el procesamiento de documentos por texto (**Workflow OCR**), primero debes instalar la app **AppAPI** desde la tienda de aplicaciones de Nextcloud. 
   - Ve a Ajustes > AppAPI, y añade un "Deploy Daemon" (Docker Socket Proxy). Usa como Host `nextcloud-appapi-dsp`, puerto `2375`, y la contraseña definida en `appapi_proxy_password`.
   - Luego instala el backend de OCR desde la tienda de aplicaciones externas (ExApps) buscando "Workflow OCR Backend".
   - Finalmente, instala la app "Workflow OCR" normal, ve a Ajustes > Flujo (Flow) y crea tus reglas de procesamiento OCR.
