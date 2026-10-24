# Estado verificable del laboratorio

Fecha: 24 de octubre de 2026 (America/Lima).

La web se reconstruyó a partir del PDF; no se recuperaron los archivos anteriores de `/mnt/data`.

| Punto | Estado |
|---|---|
| Requisitos del PDF | Revisados |
| Web HTML, CSS y JavaScript | HTTP 200 local, sintaxis JS y acordeón comprobados; vista móvil de 390 px sin desbordamiento horizontal |
| Dockerfile y configuración Nginx | Construcción y pruebas correctas en GitHub Actions |
| GitHub | Repositorio público https://github.com/jeferson1802a/usil-arq-emp-lab |
| Docker Hub | Imagen publicada en https://hub.docker.com/r/jefersonmp45/usil-arq-emp-lab con etiqueta 1.0.0 |
| Blitz Cloud | Aplicación USIL Cloud Computing desplegada y en estado Online; puerto interno 80 |
| Imagen linux/amd64:1.0.0 | Construida, probada y publicada; plataforma confirmada en Docker Hub |
| URL pública HTTPS | https://usil-arq-emp-web.jeferson5456.blitz.cloud/; GET y HEAD 200; certificado verificado |
| Independencia del entorno de desarrollo | Confirmada: sirve desde Blitz; los runners de CI terminaron. No se inició Codespaces |

Docker y WSL no estaban instalados en el equipo local. Se usó el daemon Docker del runner de GitHub Actions para construir y probar el contenedor. Las sesiones web por sí solas no autentican la herramienta Docker.

La validación se realizó en el runner de GitHub Actions: https://github.com/jeferson1802a/usil-arq-emp-lab/actions/runs/40106140451 (Success). Se preparó también Codespaces, pero no se ha iniciado un Codespace.

El usuario autorizó un token Docker temporal de lectura/escritura, guardado como secreto cifrado DOCKERHUB_TOKEN en GitHub. Vence el 23 de noviembre de 2026 según Docker. No se guardó su valor en los archivos del proyecto. No se habilitaron permisos de borrado ni Cloud Sandboxes porque el flujo de publicación usa GitHub Actions y no los necesita.

Publicación confirmada: https://github.com/jeferson1802a/usil-arq-emp-lab/actions/runs/40106502121 (Success). Digest confirmado en Docker Hub: `sha256:43ed0b3f2b533b255aff146eb2a6e14cc58ddb4dccd1928c30dcb198ab8e529f`. Tamaño comprimido mostrado: 25.12 MB. La imagen publicada corresponde al código de la web en el commit 948d041618f7d4cae5ff97fae5f208994bcecfb3.

La validación externa final pasó el 24 de octubre de 2026 a las 10:24 (America/Lima). Se verificaron página, CSS, JavaScript, favicon y `/healthz`, cabeceras y rutas 404. CSS, JS y favicon coinciden por SHA-256 con los archivos locales; el HTML de la aplicación también coincide al excluir los scripts que Cloudflare añade en tránsito. La política de seguridad permanece restringida al propio sitio; esos scripts de infraestructura pueden generar avisos del navegador sin impedir la aplicación.

La configuración de Codespaces está incluida y publicada, pero se empleó GitHub Actions como alternativa para la construcción, validación y publicación. No se simula una sesión de Codespaces ni una captura de su terminal.

En Blitz se mantuvo el plan gratuito. La interfaz indica suspensión tras 30 minutos sin visitas y reactivación al volver a abrir la URL. No se contrató un plan de pago. Se conservaron la imagen, el repositorio y la aplicación para que la entrega siga accesible. El script de CI retiró su contenedor temporal al terminar.
