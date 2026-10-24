#!/usr/bin/env bash
set -euo pipefail
image="${1:-usil-arq-emp-lab:1.0.0}"
docker info >/dev/null
docker build --platform linux/amd64 -t "$image" .
docker run --rm --entrypoint nginx "$image" -t
name="usil-test-$(date +%s)-$$"
cleanup() { docker rm -f "$name" >/dev/null 2>&1 || true; }
trap cleanup EXIT
docker run -d --name "$name" -p 127.0.0.1::80 "$image" >/dev/null
port="$(docker port "$name" 80/tcp | awk -F: '{print $NF}')"
base="http://127.0.0.1:$port"
for attempt in $(seq 1 30); do
  if curl -fsS "$base/healthz" >/dev/null; then break; fi
  sleep 1
done
curl -fsS "$base/" | grep -q 'Cloud Computing'
for path in styles.css app.js favicon.svg logo-usil.png healthz; do curl -fsS "$base/$path" >/dev/null; done
curl -fsSI "$base/" | grep -qi 'X-Content-Type-Options: nosniff'
test "$(curl -s -o /dev/null -w '%{http_code}' "$base/archivo-inexistente")" = 404
test "$(curl -s -o /dev/null -w '%{http_code}' "$base/README.md")" = 404
docker image inspect "$image" --format '{{.Os}}/{{.Architecture}}' | grep -qx 'linux/amd64'
echo 'PASS: Nginx, HTTP 200, título, recursos, cabeceras, 404 y plataforma linux/amd64.'
