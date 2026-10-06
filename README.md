Dott

Local Site Server & Temporary Public Tunnel

Dott es una herramienta ligera para servir y probar sitios web propios desde tu máquina. Permite seleccionar un proyecto, levantarlo mediante PHP y, opcionalmente, crear un enlace público temporal mediante Cloudflare Tunnel.

Uso autorizado únicamente: utiliza Dott con sitios, aplicaciones y contenido que sean tuyos o para los que tengas autorización para realizar pruebas y compartirlos.

✨ Características

🖥️ Servidor web local mediante PHP CLI.

🌐 Enlace público temporal mediante Cloudflare Tunnel.

📁 Gestión sencilla de múltiples sitios mediante sites/.

🔌 Selección personalizada del puerto.

🔒 El modo local escucha únicamente en 127.0.0.1.

📦 Compatible con ejecución mediante Docker.

⬇️ Descarga automática de cloudflared cuando es necesario.

🧹 Limpieza automática de procesos al cerrar Dott.

🚫 Sin acortadores ni sistemas de ocultación de enlaces.

🚫 Sin recolección de credenciales ni registro de visitantes.

📋 Requisitos

Necesitas:

Bash

PHP CLI

curl

Internet, únicamente si quieres utilizar el túnel público y necesitas descargar cloudflared.

En Arch Linux:

sudo pacman -S bash php curl

📂 Estructura del proyecto

Dott utiliza una estructura sencilla:

web1/
├── dott.sh
├── run-docker.sh
├── Dockerfile
├── README.md
├── sites/
│   └── demo/
│       └── index.html
└── server/

sites/

Contiene los sitios que quieres probar.

Cada sitio debe ser una carpeta directa dentro de sites/ y contener index.html o index.php en su raíz.

Ejemplo:

sites/
├── demo/
│   └── index.html
│
├── proyecto1/
│   ├── index.html
│   ├── css/
│   ├── js/
│   └── images/
│
└── proyecto2/
    └── index.php


Dott detectará automáticamente los sitios válidos al iniciarse.

server/

Es un directorio utilizado por Dott para archivos generados durante la ejecución, como:

server/
├── php.log
├── cloudflared.log
└── cloudflared


No necesitas colocar sitios manualmente dentro de esta carpeta.

🚀 Instalación

Clona el repositorio:

git clone https://github.com/dott152/web1.git
cd web1


Dale permisos de ejecución al script:

chmod +x dott.sh


Agrega tu sitio dentro de:

sites/


Por ejemplo:

sites/
└── mi-sitio/
    └── index.html

▶️ Uso

Ejecuta:

bash dott.sh


Dott mostrará los sitios disponibles:

[?] Selecciona un sitio disponible:

  1) demo
  2) mi-sitio

❯ Elige una opción [1-2]:


Después podrás seleccionar el puerto:

❯ Puerto local [Predeterminado 8080]:


Si presionas Enter, utilizará:

127.0.0.1:8080

🖥️ Modo local

Selecciona:

1) Solo local


El sitio estará disponible únicamente desde tu propia máquina:

http://127.0.0.1:8080/


Este modo es adecuado para desarrollar y comprobar un sitio antes de compartirlo.

🌐 Túnel público temporal

También puedes seleccionar:

2) Cloudflare Tunnel (Público)


Dott iniciará el servidor PHP local y utilizará Cloudflare Tunnel para proporcionar una dirección temporal accesible desde Internet.

El resultado será similar a:

https://example-name.trycloudflare.com


El programa solicitará confirmación antes de crear el enlace público.

Importante: cualquier persona que tenga el enlace puede intentar acceder al sitio mientras el túnel permanezca activo. No publiques información privada, credenciales reales, datos personales ni servicios que no tengas autorización para exponer.

Si cloudflared no está instalado, Dott puede descargar el binario oficial automáticamente y almacenarlo en:

server/cloudflared


El túnel se cierra automáticamente cuando detienes Dott.

🛑 Detener Dott

Para detener el servidor y el túnel:

Ctrl+C


Dott realiza automáticamente la limpieza de los procesos que inició.

🐳 Docker

También puedes ejecutar Dott mediante Docker:

bash run-docker.sh


La imagen se construye utilizando el Dockerfile incluido en el proyecto.

Los sitios de:

sites/


se montan dentro del contenedor en modo de solo lectura para evitar modificaciones accidentales.

El modo público mediante Cloudflare Tunnel requiere que cloudflared esté disponible según la configuración del proyecto.

🔐 Seguridad

Dott está diseñado como una herramienta para desarrollo, demostración y pruebas de sitios propios.

No incorpora:

Recolección de contraseñas.

Captura de cookies.

Registro de visitantes.

Plantillas de servicios de terceros.

Acortamiento de enlaces.

Enmascaramiento de enlaces.

Sistemas para ocultar el destino de un enlace.

El modo local utiliza:

127.0.0.1


por lo que el servidor PHP no se expone directamente a la red local.

Cuando utilizas Cloudflare Tunnel, en cambio, el sitio se vuelve accesible públicamente mediante el enlace temporal generado.

⚙️ Funcionamiento

El flujo básico de Dott es:

          ┌───────────────┐
          │     Dott      │
          └───────┬───────┘
                  │
                  ▼
          ┌───────────────┐
          │    sites/     │
          │               │
          │  mi-sitio/    │
          └───────┬───────┘
                  │
                  ▼
          ┌───────────────┐
          │   PHP CLI     │
          │ 127.0.0.1:8080│
          └───────┬───────┘
                  │
             ┌────┴────┐
             │         │
             ▼         ▼
          Local    Cloudflare
                     Tunnel
                       │
                       ▼
                  Internet

🧪 Ejemplo rápido

Crea:

sites/
└── prueba/
    └── index.html


Con un HTML sencillo:

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi sitio</title>
</head>
<body>
    <h1>Hola desde Dott</h1>
</body>
</html>


Después ejecuta:

bash dott.sh


Selecciona:

1) prueba


y elige el modo que necesites.

📜 Licencia

Este proyecto se distribuye bajo la licencia GNU General Public License v3.0 (GPL-3.0).

Consulta el archivo LICENSE incluido en el repositorio para conocer los términos completos.

⚠️ Aviso

Dott proporciona infraestructura para servir y compartir sitios web. El usuario es responsable del contenido que ejecuta y publica mediante la herramienta.

Utiliza el modo público únicamente con sistemas y páginas para los que tengas autorización.

⭐ Contribuciones

Las mejoras, correcciones y propuestas son bienvenidas.

Antes de realizar cambios importantes, abre una discusión o issue para explicar la propuesta.

📌 Resumen

Dott permite pasar rápidamente de:

sitio local
    ↓
PHP
    ↓
127.0.0.1:8080


a una demostración temporal mediante:

sitio local
    ↓
PHP
    ↓
Cloudflare Tunnel
    ↓
enlace HTTPS temporal


Simple, directo y pensado para probar tus propios sitios web.
