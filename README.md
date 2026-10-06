---

# Dott: Local Site Server & Temporary Public Tunnel

Dott permite servir y probar sitios web propios desde tu máquina mediante PHP y, opcionalmente, compartirlos temporalmente mediante Cloudflare Tunnel.

> **Uso autorizado:** Utiliza Dott únicamente con sitios y sistemas propios o con autorización explícita.

---

## Características

* **Servidor web local** mediante PHP.
* **Selección personalizada** de sitio y puerto.
* **Modo local** mediante `127.0.0.1`.
* **Túnel público temporal** mediante Cloudflare Tunnel.
* **Descarga automática** de `cloudflared` cuando es necesario.
* **Soporte para Docker.**
* **Sin acortadores** ni ocultación de enlaces.
* **Sin recolección** de credenciales ni visitantes.

---

## Compatibilidad

Dott está diseñado para sistemas Linux con **Bash**, **PHP CLI** y **curl**. Compatible o pensado para funcionar en:

* Arch Linux / Manjaro
* Debian / Ubuntu / Linux Mint
* Fedora
* Kali Linux
* Raspberry Pi OS
* WSL2 (Windows Subsystem for Linux)

*También puede funcionar en otras distribuciones Linux que proporcionen los requisitos necesarios.*

---

## Requisitos

* **Bash**
* **PHP CLI**
* **curl**
* **Internet** (para utilizar Cloudflare Tunnel si `cloudflared` no está instalado previamente).

---

## Instalación

Instala los requisitos necesarios según tu distribución:

#### Arch Linux / Manjaro

```bash
sudo pacman -S bash php curl

```

#### Debian / Ubuntu / Linux Mint / Raspberry Pi OS

```bash
sudo apt update
sudo apt install bash php-cli curl

```

#### Fedora

```bash
sudo dnf install bash php-cli curl

```

#### WSL2

Instala una distribución Linux compatible dentro de WSL2 y utiliza el comando correspondiente indicado arriba.

---

## Descargar

Ejecuta los siguientes comandos para clonar el repositorio, acceder a la carpeta y ejecutar la herramienta:

```bash
git clone https://github.com/dott152/dott.git

```

```bash
cd dott

```

```bash
bash dott.sh

```

---

## Estructura de Archivos

```text
dott/
├── dott.sh
├── run-docker.sh
├── Dockerfile
├── README.md
├── sites/
│   └── demo/
│       └── index.html
└── server/

```

Los sitios deben estar ubicados directamente dentro del directorio `sites/`.

**Ejemplo sitio HTML:**

```text
sites/
└── mi-sitio/
    ├── index.html
    ├── css/
    ├── js/
    └── images/

```

**Ejemplo sitio PHP:**

```text
sites/
└── mi-sitio/
    └── index.php

```

---

## Uso

1. Inicia Dott:
```bash
bash dott.sh

```


2. Selecciona el sitio que quieres probar y define el puerto (por defecto: `8080`).

### Modo Local

Selecciona la opción `1) Solo local`. El sitio estará disponible únicamente en tu equipo:

```text
http://127.0.0.1:8080/

```

*Este modo no crea ningún enlace público.*

### Modo Público

Selecciona la opción `2) Cloudflare Tunnel`. Dott iniciará el servidor local y creará un enlace temporal público mediante Cloudflare Tunnel.

El programa solicitará confirmación antes de publicar el sitio. El enlace generado tendrá un formato similar a:

```text
https://example-name.trycloudflare.com

```

> **Advertencia:** Cualquier persona con el enlace puede acceder al sitio mientras el túnel esté activo. No publiques información privada ni servicios no autorizados.

---

## Docker

Para ejecutar el proyecto dentro de un contenedor Docker:

```bash
bash run-docker.sh

```

*Los sitios utilizados por Dott se tomarán de la carpeta `sites/`.*

---

## Detener

Para detener el servidor PHP y cerrar el túnel activo en cualquier momento, presiona:

```text
Ctrl + C

```

---

## Licencia

Dott se distribuye bajo la **GNU General Public License v3.0 (GPL-3.0)**. Consulta el archivo `LICENSE` para conocer los términos completos.

---

## Aviso Legal

Dott está destinado exclusivamente al desarrollo, pruebas y demostraciones de sitios propios. El usuario es el único responsable del contenido que ejecute o publique mediante esta herramienta.
