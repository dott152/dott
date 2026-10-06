Dott

Local Site Server & Temporary Public Tunnel

Dott permite servir y probar sitios web propios desde tu máquina mediante PHP y, opcionalmente, compartirlos temporalmente mediante Cloudflare Tunnel.

Uso autorizado: utiliza Dott únicamente con sitios y sistemas propios o con autorización.

Características

Servidor web local mediante PHP.

Selección de sitio y puerto.

Modo local mediante 127.0.0.1.

Túnel público temporal mediante Cloudflare Tunnel.

Descarga automática de cloudflared cuando es necesario.

Soporte para Docker.

Sin acortadores ni ocultación de enlaces.

Sin recolección de credenciales ni visitantes.

Compatibilidad

Dott está diseñado para sistemas Linux con Bash, PHP CLI y curl.

Compatible o pensado para funcionar en:

Arch Linux

Manjaro

Debian

Ubuntu

Linux Mint

Fedora

Kali Linux

Raspberry Pi OS

WSL2

También puede funcionar en otras distribuciones Linux que proporcionen los requisitos necesarios.

Requisitos

Bash

PHP CLI

curl

Internet para utilizar Cloudflare Tunnel si cloudflared no está instalado.

Instalación
Arch Linux / Manjaro
sudo pacman -S bash php curl

Debian / Ubuntu / Linux Mint / Raspberry Pi OS
sudo apt update
sudo apt install bash php-cli curl

Fedora
sudo dnf install bash php-cli curl

WSL2

Instala una distribución Linux compatible dentro de WSL2 y utiliza el comando de instalación correspondiente a esa distribución.

Descargar

Clona el repositorio:

git clone https://github.com/dott152/web1.git


Entra en el directorio:

cd web1


Dale permisos de ejecución:

chmod +x dott.sh


También puedes ejecutar el programa directamente con Bash:

bash dott.sh

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


También puedes utilizar PHP:

sites/
└── mi-sitio/
    └── index.php

Uso

Inicia Dott:

bash dott.sh


Selecciona el sitio que quieres probar y el puerto.

El puerto predeterminado es:

8080

Modo local

Selecciona:

1) Solo local


El sitio estará disponible en:

http://127.0.0.1:8080/


Este modo no crea ningún enlace público.

Modo público

Selecciona:

2) Cloudflare Tunnel


Dott iniciará el servidor local y creará un enlace temporal mediante Cloudflare Tunnel.

El programa solicitará confirmación antes de publicar el sitio.

El enlace tendrá un formato similar a:

https://example-name.trycloudflare.com


Cualquier persona que tenga el enlace puede acceder al sitio mientras el túnel esté activo. No publiques información privada ni servicios que no tengas autorización para exponer.

Docker

Para ejecutar el proyecto mediante Docker:

bash run-docker.sh


Los sitios utilizados por Dott se encuentran en:

sites/

Detener

Presiona:

Ctrl+C


Dott detendrá el servidor PHP y el túnel activo.

Licencia

Dott se distribuye bajo la GNU General Public License v3.0 (GPL-3.0).

Consulta LICENSE para conocer los términos completos.

Aviso

Dott está destinado al desarrollo, pruebas y demostraciones de sitios propios.

El usuario es responsable del contenido que ejecute o publique mediante la herramienta.
