# Dott: probador de sitios web propios

Este proyecto sirve páginas que tú agregues a `.sites` para revisar su aspecto y
funcionamiento. No incluye plantillas de terceros, recolección de contraseñas,
registro de visitantes, acortamiento ni enmascaramiento de enlaces.

## Requisitos

- Bash
- PHP CLI
- curl
- Internet solo si necesitas descargar `cloudflared` para un enlace público temporal

## Agregar un sitio

Crea una carpeta directa dentro de `.sites` y pon `index.html` o `index.php` en
su raíz:

```text
.sites/
  mi-sitio/
    index.html
    css/
    js/
```

Hay un sitio neutral en `.sites/demo` que puedes reemplazar o borrar.

## Iniciar

```bash
bash dott.sh
```

Elige un sitio y un puerto. Cloudflare Tunnel es el modo predeterminado: pulsa
Enter en el menú de modo para crear un enlace público temporal. Para servir solo
en local, elige `1`; escucha exclusivamente en `http://127.0.0.1:8080` (o el
puerto que indiques). Presiona `Ctrl+C` para detener el servidor y el túnel.

El modo Cloudflare pide confirmación porque crea un enlace público temporal que
permite acceder al sitio desde Internet. Si no encuentra `cloudflared`, descarga
el binario oficial de Cloudflare en `.server/`. Usa esta opción únicamente con
páginas y sistemas que tengas autorización para publicar. El enlace completo se
muestra sin acortadores.

## Docker

```bash
bash run-docker.sh
```

El script construye la imagen desde este directorio y monta `.sites` en modo de
solo lectura. El modo local usa la red del host; instala `cloudflared` en tu
sistema si deseas crear un túnel desde el modo normal.