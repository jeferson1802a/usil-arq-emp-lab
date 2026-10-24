FROM nginx:alpine
LABEL org.opencontainers.image.title="USIL Cloud Computing" \
      org.opencontainers.image.description="Laboratorio de Arquitectura Empresarial 2026-2" \
      org.opencontainers.image.version="1.0.1"
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html styles.css app.js favicon.svg logo-usil.png /usr/share/nginx/html/
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/healthz || exit 1
