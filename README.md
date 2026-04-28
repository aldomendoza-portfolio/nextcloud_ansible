# Despliegue de Nextcloud en Producción

Este repositorio contiene las configuraciones necesarias de Ansible para desplegar un entorno de producción de Nextcloud con Docker, Traefik, PostgreSQL, Redis, OnlyOffice y Coturn (para Nextcloud Talk).

## Requisitos Previos

1. Instalar la colección de Docker para Ansible en la máquina desde donde se ejecutará (tu equipo local):
   ```bash
   ansible-galaxy collection install community.docker
   ansible-galaxy collection install community.crypto
   ```

2. Configurar el registro DNS:
   Asegúrate de que los dominios `nextcloud.asesoresti.site` y `office.asesoresti.site` (para OnlyOffice) apunten a la IP `74.208.32.232`.

## Ejecución

1. La primera vez que ejecutes el playbook, Ansible necesitará usar el usuario `root` y su contraseña. Asegúrate de tener esto configurado o modificar el archivo `inventory/hosts.yml` si usas llaves temporales de root.

2. Ejecutar el playbook:
   ```bash
   ansible-playbook deploy.yml --ask-pass
   ```
   *Nota: `--ask-pass` te pedirá la contraseña del usuario root del servidor.*

## ¿Qué hace este proyecto?

1. **Seguridad**: Crea el usuario `amendoza`, genera una llave SSH para conectarte, deshabilita el acceso con contraseña por SSH y bloquea completamente a `root`. **(La llave privada se guardará en la carpeta `ssh_keys/` de este proyecto)**.
2. **Docker**: Instala Docker Engine y Docker Compose de forma automática.
3. **Traefik**: Despliega Traefik como proxy reverso, solicitando automáticamente un certificado HTTPS a Let's Encrypt para tus dominios.
4. **Nextcloud**: Levanta el contenedor de Nextcloud conectado a PostgreSQL y usando Redis como caché.
5. **OnlyOffice y Talk**: Despliega un servidor de documentos para edición y un servidor STUN/TURN (`coturn`) en el puerto 3478 para llamadas de audio/video.

## Post-Instalación

1. Extrae tu llave generada en `ssh_keys/amendoza_ed25519` a un lugar seguro. A partir de ahora, accederás al servidor con:
   ```bash
   ssh -i ruta/a/tu/llave amendoza@74.208.32.232
   ```

2. Accede a `https://nextcloud.asesoresti.site`. El instalador inicial de Nextcloud ha sido configurado en base a las credenciales en `group_vars/all.yml`. Por defecto:
   - **Usuario**: `admin`
   - **Contraseña**: `NextcloudAdmin_Secr3tPassword!`
   *(¡Recuerda cambiar esto en la interfaz inmediatamente!)*

3. Para configurar **OnlyOffice** dentro de Nextcloud, ve a las aplicaciones, instala el conector de OnlyOffice y en la configuración introduce la dirección: `https://office.asesoresti.site` con la clave secreta `OnlyOffice_Secr3tJWT!`.

4. Para configurar **Nextcloud Talk**, ve a Ajustes > Talk, en el servidor STUN/TURN, añade la IP `74.208.32.232:3478`, con protocolo UDP y TCP, e introduce el secreto `Coturn_Secr3tPassword!`.
