# Cloud Computing · USIL

La versión actual 1.0.2 incorpora el logo USIL facilitado por el usuario. Ver `ACTUALIZACION-LOGO.md` para la publicación y validación de este cambio.

**Web pública:** https://usil-arq-emp-web.jeferson5456.blitz.cloud/

**Código:** https://github.com/jeferson1802a/usil-arq-emp-lab

**Imagen:** https://hub.docker.com/r/jefersonmp45/usil-arq-emp-lab · etiqueta `1.0.2` · `linux/amd64`.

Entrega publicada y validada el 24 de octubre de 2026. La construcción y publicación reales se ejecutaron en GitHub Actions porque este equipo no tiene Docker. Ver `ESTADO.md` para resultados y diferencias respecto al procedimiento con Codespaces.

Laboratorio individual de Arquitectura Empresarial, 2026-2. Página educativa estática en español con diseño adaptable, diagrama del flujo del proyecto y respuestas a las cinco preguntas de reflexión. Se creó de nuevo a partir del enunciado: el ZIP y la carpeta de `/mnt/data` de la conversación anterior no estaban disponibles en este equipo.

## Vista local sin Docker

Desde esta carpeta, ejecutar `python -m http.server 8080 --bind 127.0.0.1` y abrir http://127.0.0.1:8080. Esta vista prueba los archivos, pero no sustituye la prueba del contenedor Nginx.

## Arquitectura

IA generativa → HTML/CSS/JS en GitHub → Docker build (Nginx + web) → Docker Hub → Blitz Cloud → navegador HTTPS.

GitHub conserva el código. Codespaces aporta el entorno de desarrollo. Docker Hub almacena la imagen. Blitz Cloud ejecuta el contenedor. Nginx responde en su puerto interno 80; el servicio cloud gestiona el certificado y la conexión HTTPS.

## Construir y validar en Codespaces

1. Subir todos los archivos, incluidas las carpetas que empiezan por punto, al repositorio `usil-arq-emp-lab` de GitHub.
2. Abrir Code → Codespaces → Create codespace on main. La configuración incluida solicita Docker dentro del entorno; verificar que termine de inicializarse.
3. Ejecutar:

```bash
git --version
docker --version
docker buildx version
docker info
node --check app.js
bash scripts/test-container.sh jefersonmp45/usil-arq-emp-lab:1.0.2
```

La prueba construye para linux/amd64, ejecuta `nginx -t`, comprueba título, recursos, healthcheck, cabecera nosniff, rutas 404 y plataforma. Elimina solamente su contenedor temporal al finalizar. No afirma éxito si un paso falla.

Para la comprobación visual del contenedor:

```bash
docker run -d --name usil-web -p 8080:80 jefersonmp45/usil-arq-emp-lab:1.0.2
curl -I http://localhost:8080
docker inspect --format '{{.State.Health.Status}}' usil-web
```

Abrir el puerto 8080 en la pestaña Ports. Comprobar ordenador y móvil, navegación y preguntas desplegables. `EXPOSE 80` documenta el puerto interno; `-p 8080:80` publica el puerto de la prueba.

## Docker Hub

Se incluye una alternativa a Codespaces: GitHub Actions ejecuta las mismas pruebas de Docker en `.github/workflows/validate.yml`. El flujo manual `Publicar imagen en Docker Hub` construye, prueba y sube la imagen usando el secreto cifrado `DOCKERHUB_TOKEN`; se ejecuta desde Actions → Publicar imagen en Docker Hub → Run workflow. El token se configura por la persona titular o con su autorización explícita. Para este flujo basta lectura/escritura y no hace falta acceso a Cloud Sandboxes ni permisos de borrado.

Crear el repositorio público `jefersonmp45/usil-arq-emp-lab`. Iniciar sesión desde el entorno donde se construyó la imagen:

```bash
docker login -u jefersonmp45
docker push jefersonmp45/usil-arq-emp-lab:1.0.2
docker buildx imagetools inspect jefersonmp45/usil-arq-emp-lab:1.0.2
```

Introducir el token únicamente en el indicador privado de contraseña. No ponerlo en comandos, archivos, capturas ni el chat. El enunciado describe la creación de un token temporal de 30 días y los permisos que indica el docente. Su creación y almacenamiento requieren autorización de la persona titular. Guardar el digest de la imagen y confirmar que la etiqueta 1.0.2 está visible públicamente.

## Blitz Cloud

1. Iniciar sesión en https://dashboard.blitz.cloud/ y completar la configuración inicial.
2. Elegir Host something new y la opción para una imagen pública de Docker Hub.
3. Imagen: `jefersonmp45/usil-arq-emp-lab`, etiqueta: `1.0.2`, puerto: **80**.
4. Nombre de aplicación sugerido: `usil-arq-emp-web`. No necesita base de datos, variables secretas ni volúmenes.
5. Revisar que el plan elegido sea gratuito antes de confirmar. No activar un plan de pago sin autorización.
6. Publicar y esperar un estado correcto. Copiar únicamente la URL real asignada por la plataforma.

## Validación pública y evidencias

- Abrir la URL HTTPS sin sesión e inspeccionar el título Cloud Computing, el diagrama y los estilos.
- Confirmar HTTP 200 con `curl -I` y un certificado válido.
- Confirmar la etiqueta 1.0.2 en Docker Hub y registrar su digest.
- Cerrar o detener Codespaces y repetir la visita a la URL pública.
- Capturar el repositorio, la prueba del contenedor, la etiqueta de Docker Hub, el estado de Blitz y la web final. No incluir credenciales.
- Registrar resultados reales en `ESTADO.md`. Un comando preparado o una captura de ejemplo no demuestra un despliegue.

## Limpieza

Después de capturar evidencias, detener y retirar el contenedor de prueba si existe:

```bash
docker stop usil-web
docker rm usil-web
```

Detener el Codespace desde GitHub. Conservar la app y la imagen mientras se necesite la URL para la entrega. Eliminar recursos cloud solo cuando ya no sean necesarios y con autorización de la persona titular. Son recursos independientes: borrar Codespaces no elimina Blitz ni Docker Hub.

## Problemas frecuentes

| Síntoma | Revisión |
|---|---|
| Docker no existe | Usar Codespaces con la configuración incluida o el entorno del docente. |
| No conecta al daemon | Esperar la inicialización y revisar `docker info`; reconstruir el entorno si falla. |
| Push no autorizado | Revisar usuario, token, permisos y nombre del repositorio. |
| Blitz no ve la imagen | Confirmar visibilidad pública, etiqueta y nombre exactos. |
| No carga la app | Revisar puerto 80, healthcheck y registros de Nginx. |
| Carga sin diseño | Comprobar que styles.css y app.js están en la imagen. |
| Primera visita lenta | Consultar el estado del servicio y la posible suspensión por inactividad. |

La etiqueta base `nginx:alpine` sigue el enunciado y es mutable. Para una entrega reproducible de producción, fijar un digest comprobado y planificar actualizaciones. Este laboratorio no declara garantías de producción.

## Fuentes

- Enunciado del laboratorio USIL, Semana 10, facilitado por el usuario.
- https://docs.docker.com/build/building/base-images/
- https://blitz.cloud/
