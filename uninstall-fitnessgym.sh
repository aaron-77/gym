#!/usr/bin/env bash
set -Eeuo pipefail

INSTALL_DIR="${FITNESSGYM_INSTALL_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/fitnessgym/docker-compose}"
APP_FILE="$INSTALL_DIR/docker-compose.app.installer.dev.yml"
DB_FILE="$INSTALL_DIR/docker-compose.bd.installer.dev.yml"
PROXY_FILE="$INSTALL_DIR/docker-compose.nginx.installer.dev.yml"
ENV_FILE="$INSTALL_DIR/.env"
ENV_EXAMPLE="$INSTALL_DIR/.env.example"

fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
info() { printf 'INFO: %s\n' "$*"; }
ok()   { printf 'OK: %s\n' "$*"; }

command -v docker >/dev/null 2>&1 || fail 'Docker no está instalado o no está en PATH.'
docker info >/dev/null 2>&1 || fail 'Docker está instalado, pero el daemon no está disponible.'
docker compose version >/dev/null 2>&1 || fail 'Se requiere Docker Compose v2.'

if [ ! -t 0 ]; then
  fail 'Este script debe ejecutarse en modo interactivo (se necesita confirmación).'
fi

info "Directorio de instalación: $INSTALL_DIR"
info "Se van a detener y eliminar los contenedores y volúmenes del stack FitnessGym levantados con los installers."
echo ""
read -rp "¿Desea continuar? [s/N]: " confirm
[[ "${confirm,,}" =~ ^s|si|y|yes$ ]] || { info "Operación cancelada."; exit 0; }

if ! cd "$INSTALL_DIR" 2>/dev/null; then
  info "No existe el directorio de instalación: $INSTALL_DIR"
  info "Se continúa con la limpieza por nombre canónico, porque puede haber instalación manual."
fi

COMPOSE_FILES=()
[ -f "$DB_FILE" ]    && COMPOSE_FILES+=(-f "$DB_FILE")
[ -f "$APP_FILE" ]   && COMPOSE_FILES+=(-f "$APP_FILE")
[ -f "$PROXY_FILE" ] && COMPOSE_FILES+=(-f "$PROXY_FILE")

if (( ${#COMPOSE_FILES[@]} > 0 )); then
  info "Deteniendo y eliminando el stack con los Compose del installer..."
  docker compose "${COMPOSE_FILES[@]}" down --remove-orphans --volumes \
    || info "El down no eliminó ningún contenedor de este proyecto; se continúa con la limpieza por nombre."
else
  info "No se encontraron archivos compose; se limpia por nombre canónico."
fi

# Limpieza por nombre canónico: corre SIEMPRE, haya o no archivos compose y
# aunque el stack se haya levantado con una instalación manual (mismos container_name).
VOLUMES_TO_REMOVE=()
for c in apicontainer frontendcontainer fitnessgymdbcontainer fitnessgym-nginx; do
  if docker inspect "$c" >/dev/null 2>&1; then
    info "Eliminando contenedor: $c"
    while IFS= read -r volume; do
      if [[ -n "$volume" ]]; then VOLUMES_TO_REMOVE+=("$volume"); fi
    done < <(docker inspect --format '{{range .Mounts}}{{if eq .Type "volume"}}{{println .Name}}{{end}}{{end}}' "$c" 2>/dev/null)
    docker rm -f -v "$c" >/dev/null || info "No se pudo eliminar el contenedor: $c"
  fi
done

if (( ${#VOLUMES_TO_REMOVE[@]} > 0 )); then
  mapfile -t VOLUMES_TO_REMOVE < <(printf '%s\n' "${VOLUMES_TO_REMOVE[@]}" | sort -u)
  info "Eliminando volúmenes: ${VOLUMES_TO_REMOVE[*]}"
  docker volume rm "${VOLUMES_TO_REMOVE[@]}" >/dev/null 2>&1 \
    || info 'Algunos volúmenes no pudieron eliminarse (¿en uso por otro contenedor?).'
fi

docker network rm fitnessgym-net >/dev/null 2>&1 || true

left=0
for c in apicontainer frontendcontainer fitnessgymdbcontainer fitnessgym-nginx; do
  if docker inspect "$c" >/dev/null 2>&1; then left=$((left + 1)); fi
done
if (( left > 0 )); then
  fail "Persisten $left contenedor(es) del stack tras la limpieza. Revisalos con 'docker ps -a'."
fi

echo ""
read -rp "¿Desea eliminar también las imágenes descargadas (aaron77/fitnessgymapi, aaron77/fitnessgymfrontend, aaron77/fitnessgymbd, aaron77/fitnessgymnginx)? [s/N]: " ans_img
if [[ "${ans_img,,}" =~ ^s|si|y|yes$ ]]; then
  info "Eliminando imágenes..."
  docker rmi -f aaron77/fitnessgymapi:latest 2>/dev/null || true
  docker rmi -f aaron77/fitnessgymfrontend:latest 2>/dev/null || true
  docker rmi -f aaron77/fitnessgymbd:latest 2>/dev/null || true
  docker rmi -f aaron77/fitnessgymnginx:latest 2>/dev/null || true
  docker rmi -f aaron77/fitnessgymnginxdev:latest 2>/dev/null || true
  docker image prune -f 2>/dev/null || true
fi

echo ""
read -rp "¿Desea eliminar también los archivos descargados para la instalación (.env, .env.example y los docker-compose)? [s/N]: " ans_files
if [[ "${ans_files,,}" =~ ^s|si|y|yes$ ]]; then
  info "Eliminando archivos de instalación..."
  rm -f "$APP_FILE" "$DB_FILE" "$PROXY_FILE" "$INSTALL_DIR/create-login.sql" "$ENV_FILE" "$ENV_EXAMPLE" \
        "$APP_FILE.download" "$DB_FILE.download" "$PROXY_FILE.download" "$INSTALL_DIR/create-login.sql.download" "$ENV_EXAMPLE.download" 2>/dev/null || true
  # Eliminar directorio si queda vacío
  rmdir "$INSTALL_DIR" 2>/dev/null || true
fi

echo ""
ok "Limpieza completada: contenedores, volúmenes y red del stack eliminados."
