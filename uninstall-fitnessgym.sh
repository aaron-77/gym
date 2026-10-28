#!/usr/bin/env bash
set -Eeuo pipefail

INSTALL_DIR="${FITNESSGYM_INSTALL_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/fitnessgym/docker-compose}"
APP_FILE="$INSTALL_DIR/docker-compose.app.installer.dev.yml"
DB_FILE="$INSTALL_DIR/docker-compose.bd.installer.dev.yml"
PROXY_FILE="$INSTALL_DIR/docker-compose.nginx.installer.dev.yml"
ENV_FILE="$INSTALL_DIR/.env"

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
info "Se van a detener y eliminar los contenedores del stack FitnessGym levantados con los installers."
info "Se mantendrán los volúmenes de la base de datos (fitnessgym-mssql-data, fitnessgym-mssql-log)."
echo ""
read -rp "¿Desea continuar? [s/N]: " confirm
[[ "${confirm,,}" =~ ^s|si|y|yes$ ]] || { info "Operación cancelada."; exit 0; }

cd "$INSTALL_DIR" 2>/dev/null || { info "No existe el directorio de instalación. Nada que limpiar."; exit 0; }

COMPOSE_FILES=()
[ -f "$DB_FILE" ]    && COMPOSE_FILES+=(-f "$DB_FILE")
[ -f "$APP_FILE" ]   && COMPOSE_FILES+=(-f "$APP_FILE")
[ -f "$PROXY_FILE" ] && COMPOSE_FILES+=(-f "$PROXY_FILE")

if (( ${#COMPOSE_FILES[@]} > 0 )); then
  info "Deteniendo y eliminando contenedores/ redes del stack..."
  docker compose "${COMPOSE_FILES[@]}" down --remove-orphans 2>/dev/null || true
else
  info "No se encontraron archivos compose. Intentando limpieza por nombre de contenedor..."
  for c in apicontainer frontendcontainer fitnessgymdbcontainer fitnessgym-nginx; do
    docker rm -f "$c" 2>/dev/null || true
  done
fi

echo ""
read -rp "¿Desea eliminar también las imágenes descargadas (aaron77/fitnessgymapi, aaron77/fitnessgymfrontend, aaron77/fitnessgymbd, aaron77/fitnessgymnginxdev)? [s/N]: " ans_img
if [[ "${ans_img,,}" =~ ^s|si|y|yes$ ]]; then
  info "Eliminando imágenes..."
  docker rmi -f aaron77/fitnessgymapi:latest 2>/dev/null || true
  docker rmi -f aaron77/fitnessgymfrontend:latest 2>/dev/null || true
  docker rmi -f aaron77/fitnessgymbd:latest 2>/dev/null || true
  docker rmi -f aaron77/fitnessgymnginxdev:latest 2>/dev/null || true
  docker image prune -f 2>/dev/null || true
fi

echo ""
read -rp "¿Desea eliminar también los archivos descargados para la instalación (.env, .env.example y los docker-compose)? [s/N]: " ans_files
if [[ "${ans_files,,}" =~ ^s|si|y|yes$ ]]; then
  info "Eliminando archivos de instalación..."
  rm -f "$APP_FILE" "$DB_FILE" "$PROXY_FILE" "$ENV_FILE" "$ENV_EXAMPLE" \
        "$APP_FILE.download" "$DB_FILE.download" "$PROXY_FILE.download" "$ENV_EXAMPLE.download" 2>/dev/null || true
  # Eliminar directorio si queda vacío
  rmdir "$INSTALL_DIR" 2>/dev/null || true
fi

echo ""
ok "Limpieza completada."
info "Los volúmenes de BD se han conservado. Para eliminarlos manualmente: docker volume rm fitnessgym-mssql-data fitnessgym-mssql-log"
