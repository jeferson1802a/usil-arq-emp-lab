# Laboratorio de Contenedores: Docker y nube

**Universidad:** Universidad San Ignacio de Loyola (USIL).  
**Curso:** Desarrollo de Sistemas Empresariales / Arquitectura Empresarial.  
**Periodo:** 2026-2, Semana 10.  
**Modalidad:** Individual.  
**Fecha de ejecución:** 24 de octubre de 2026, America/Lima.

## Resultado

La aplicación **Cloud Computing** está publicada en:

https://usil-arq-emp-web.jeferson5456.blitz.cloud/

El sitio responde mediante HTTPS y Nginx desde un contenedor alojado en Blitz Cloud. La imagen `jefersonmp45/usil-arq-emp-lab:1.0.0` está publicada en Docker Hub para `linux/amd64`.

## Objetivo

Construir una página informativa con HTML, CSS y JavaScript; empaquetarla con Nginx; publicar la imagen Docker y ejecutar el contenedor en un servicio cloud con acceso HTTPS.

## Desarrollo realizado

1. Se revisó el PDF del laboratorio. Los archivos originales de `/mnt/data` no estaban disponibles en este equipo, por lo que se reconstruyó el proyecto a partir del enunciado.
2. Se creó una web en español, adaptable a móvil, con el título Cloud Computing, objetivo del recorrido, diagrama de cinco etapas, proceso de despliegue, conceptos y respuestas desplegables a las preguntas de reflexión. No utiliza bibliotecas, fuentes ni imágenes externas.
3. Se creó el repositorio público https://github.com/jeferson1802a/usil-arq-emp-lab y se publicaron los archivos de la web, Dockerfile, configuración de Nginx y configuración de Codespaces.
4. Docker y WSL no estaban instalados localmente. La construcción y la prueba reales se realizaron mediante GitHub Actions, en lugar de la terminal de Codespaces. No se creó un Codespace.
5. Se construyó la imagen para `linux/amd64`, se ejecutó `nginx -t` y se probó el contenedor. La prueba comprobó título, recursos, respuesta HTTP, cabeceras, plataforma y rutas inexistentes, y retiró su contenedor temporal.
6. Con autorización del usuario, se creó un acceso temporal de Docker con lectura/escritura y vigencia de 30 días. Se guardó cifrado en GitHub como `DOCKERHUB_TOKEN`. No se incluyó su valor en el código ni en las evidencias. El flujo de Actions no necesita los permisos de borrado o Cloud Sandboxes que aparecen en el ejemplo del PDF.
7. Se publicó la imagen y se comprobó en Docker Hub la etiqueta `1.0.0`, su plataforma y su digest.
8. Se desplegó en Blitz Cloud con el nombre **USIL Cloud Computing**, dirección **usil-arq-emp-web**, puerto interno **80**, sin base de datos ni variables adicionales y con el plan gratuito.
9. Se visitó la URL pública y se verificaron HTTPS, HTTP 200, estilos, JavaScript, diagrama y preguntas desplegables. La comprobación externa se realizó fuera del runner de CI.

## Arquitectura

```text
IA generativa
    ↓
HTML + CSS + JavaScript → GitHub (código fuente)
    ↓ docker build
Imagen Docker = Nginx + configuración + archivos web
    ↓ docker push
Docker Hub / jefersonmp45 / usil-arq-emp-lab:1.0.0
    ↓ descarga de la imagen
Blitz Cloud → contenedor Nginx en puerto 80
    ↓ dominio y terminación HTTPS
Navegador → https://usil-arq-emp-web.jeferson5456.blitz.cloud/
```

## Evidencias verificables

| Verificación | Resultado / evidencia |
|---|---|
| Construcción y prueba Docker | Success: https://github.com/jeferson1802a/usil-arq-emp-lab/actions/runs/40106140451 |
| Publicación de imagen probada | Success: https://github.com/jeferson1802a/usil-arq-emp-lab/actions/runs/40106502121 |
| Registro de contenedores | https://hub.docker.com/r/jefersonmp45/usil-arq-emp-lab |
| Etiqueta y plataforma | `1.0.0`, `linux/amd64` |
| Manifest digest | `sha256:43ed0b3f2b533b255aff146eb2a6e14cc58ddb4dccd1928c30dcb198ab8e529f` |
| Estado de Blitz | Online; imagen `jefersonmp45/usil-arq-emp-lab:1.0.0` |
| Página y cabecera HEAD | HTTP 200 mediante HTTPS |
| Recursos CSS, JS, SVG | HTTP 200, SHA-256 idéntico al código local |
| HTML de la aplicación | Coincide al excluir los scripts que Cloudflare incorpora en tránsito |
| `/healthz` | HTTP 200, cuerpo `ok` |
| Archivo inexistente y README público | HTTP 404; la imagen solo sirve los recursos de la web |
| Interacción | Acordeón comprobado en la web local y pública |
| Móvil | Diseño comprobado a 390 px; captura incluida |

El registro detallado de la prueba HTTPS y las capturas están en la carpeta `evidencias` del ZIP. Se registraron respuestas 503 durante el arranque inicial y, tras finalizar el despliegue, las verificaciones finales pasaron. Los avisos de GitHub sobre la transición de Node y Ubuntu no impidieron las ejecuciones correctas.

## Preguntas de reflexión

**14. ¿Cuál es la diferencia entre una imagen Docker y un contenedor?**  
La imagen es una plantilla de solo lectura con capas que contienen los archivos y la configuración. Un contenedor es una instancia en ejecución creada desde esa imagen, con sus procesos y su capa de escritura. Una imagen puede crear varios contenedores. Los datos que deban sobrevivir al reemplazo requieren almacenamiento persistente.

**15. ¿Por qué publicar la imagen en Docker Hub antes de desplegarla?**  
Porque el registro permite que la plataforma cloud descargue la versión que debe ejecutar. La etiqueta identifica la entrega y el digest permite comprobar el artefacto exacto. Docker Hub conserva la imagen; el servicio cloud ejecuta el contenedor.

**16. ¿Qué ventajas aporta un servicio administrado frente a configurar una máquina virtual?**  
Reduce la administración del sistema operativo, el aprovisionamiento y parte de la configuración de red. Puede aportar certificados, registros y comprobaciones de disponibilidad. La persona responsable sigue manteniendo el código, la imagen, los permisos y los datos. Las garantías concretas dependen del proveedor y del plan.

**17. ¿Qué cambia al pasar de Codespaces a una URL pública?**  
La vista previa de desarrollo depende del entorno que la ejecuta. Un despliegue cloud utiliza infraestructura independiente y un dominio público con certificado HTTPS. Por eso debe responder al cerrar el entorno de desarrollo. En esta ejecución se usó CI en lugar de Codespaces; el sitio de Blitz continúa accesible después de que finalizaran los runners.

**18. ¿Qué limitaciones puede tener el alojamiento frente a producción?**  
Puede limitar CPU, memoria, almacenamiento, transferencia y tiempo de actividad. El plan gratuito de Blitz indica suspensión tras 30 minutos sin visitas y reactivación al recibir una solicitud. Un entorno de producción requiere evaluar disponibilidad, recuperación, escalado, observabilidad, copias de seguridad, seguridad y costos.

## Limpieza y conservación

Los contenedores temporales de CI se retiraron automáticamente. No se inició un Codespace que deba detenerse. Se conservan el repositorio, la imagen y la aplicación para mantener la URL de la entrega. No se contrató ningún plan de pago. El acceso temporal de Docker vence el 23 de noviembre de 2026 según la interfaz del servicio; puede revocarse desde la cuenta cuando deje de ser necesario. Borrar un recurso no elimina automáticamente los otros.

## Conclusión

Se recorrió el flujo real de código fuente, imagen, registro y ejecución cloud. La página pública sirve desde el contenedor de Blitz y no depende del servidor local ni del runner usado para construirla. La diferencia respecto al procedimiento del PDF es el uso de GitHub Actions en lugar de Codespaces para construir, probar y publicar.
