Dott

Local Site Server & Temporary Public Tunnel

Dott permite servir y probar sitios web propios desde tu máquina mediante PHP y, opcionalmente, compartirlos temporalmente mediante Cloudflare Tunnel.

Uso autorizado: utiliza Dott únicamente con sitios y sistemas propios o con autorización.

Características

Servidor local con PHP.

Selección de sitio y puerto.

Modo local mediante 127.0.0.1.

Túnel público temporal mediante Cloudflare Tunnel.

Descarga automática de cloudflared cuando es necesario.

Soporte para Docker.

Sin acortadores ni ocultación de enlaces.

Sin recolección de credenciales ni visitantes.

Requisitos

Bash

PHP CLI

curl

Internet para utilizar el túnel público si cloudflared no está instalado.

Arch Linux
sudo pacman -S bash php curl

Instalación

Clona el repositorio:

git clone https://github.com/dott152/web1.git
cd web1


Dale permisos al script:

chmod +x dott.sh

Estructura
web1/
├── dott.sh
├── run-docker.sh
├── Dockerfile
├── README.md
├── sites/
│   └── demo/
│       └── index.html
└── server/


Los sitios deben estar directamente dentro de sites/.

Ejemplo:

sites/
└── mi-sitio/
    ├── index.html
    ├── css/
    ├── js/
    └── images/


También puedes utilizar index.php:

sites/
└── mi-sitio/
    └── index.php

Uso

Inicia Dott:

bash dott.sh


Selecciona uno de los sitios disponibles y el puerto que quieras utilizar.

El puerto predeterminado es:

8080

Modo local

Selecciona:

1) Solo local


El sitio estará disponible en:

http://127.0.0.1:8080/


Este modo no crea un enlace público.

Modo público

Selecciona:

2) Cloudflare Tunnel


Dott iniciará el sitio localmente y creará un enlace temporal trycloudflare.com.

El programa pedirá confirmación antes de publicar el sitio.

Cualquier persona que tenga el enlace podrá acceder mientras el túnel esté activo. No publiques información privada ni servicios que no tengas autorización para exponer.

Docker

Ejecuta:

bash run-docker.sh


El proyecto utiliza sites/ para los sitios que quieres servir.

Detener

Presiona:

Ctrl+C


Dott detendrá el servidor PHP y el túnel activo.

Licencia

Dott se distribuye bajo la GNU General Public License v3.0 (GPL-3.0).

Consulta LICENSE para los términos completos.

Aviso

Dott es una herramienta para desarrollo, pruebas y demostraciones de sitios propios.

El usuario es responsable del contenido que ejecute o publique mediante la herramienta.
