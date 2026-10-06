# Tus sitios de prueba

Coloca cada sitio propio en una carpeta independiente. Debe incluir `index.html`
o `index.php` en la raíz de esa carpeta.

```text
.sites/
  mi-sitio/
    index.html
    css/
    js/
```

El lanzador solo sirve carpetas directas de `.sites` y escucha localmente en
`127.0.0.1`. El túnel opcional de Cloudflare hace el sitio accesible desde
Internet; úsalo únicamente con autorización.