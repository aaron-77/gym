#!/usr/bin/env bash
set -Eeuo pipefail

INSTALL_DIR="${FITNESSGYM_INSTALL_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/fitnessgym/docker-compose}"
APP_FILE="$INSTALL_DIR/docker-compose.app.installer.dev.yml"
DB_FILE="$INSTALL_DIR/docker-compose.bd.installer.dev.yml"
PROXY_FILE="$INSTALL_DIR/docker-compose.nginx.installer.dev.yml"
ENV_FILE="$INSTALL_DIR/.env"
ENV_EXAMPLE="$INSTALL_DIR/.env.example"
STATE_FILE="$INSTALL_DIR/.infisical-installer-state"

fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
info() { printf 'INFO: %s\n' "$*"; }
ok()   { printf 'OK: %s\n' "$*"; }

read_state_value() { awk -F= -v key="$1" '$1 == key { value=substr($0, index($0, "=") + 1) } END { print value }' "$STATE_FILE"; }
run_infisical_compose_down() {
  local fail_msg="$1" project_id="$2" compose_file="$3" err_file exit_code=0
  err_file="$(mktemp)"
  if infisical run --env="$INFISICAL_ENV" --projectId="$project_id" -- docker compose -f "$compose_file" down --remove-orphans --volumes 2>"$err_file"; then
    [[ -s "$err_file" ]] && cat "$err_file" >&2
    rm -f "$err_file"
    return 0
  fi
  exit_code=$?
  printf 'ERROR: %s (código de salida %s).\n' "$fail_msg" "$exit_code" >&2
  if [[ -s "$err_file" ]]; then
    printf 'Detalle del error:\n' >&2
    cat "$err_file" >&2
  else
    printf 'El comando no emitió salida de error; verificá conectividad y credenciales de Infisical.\n' >&2
  fi
  rm -f "$err_file"
  return 1
}

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

USE_INFISICAL=0
if [[ -s "$STATE_FILE" ]]; then
  STATE_MODE="$(read_state_value MODE)"
  STATE_ENV="$(read_state_value ENV)"
  STATE_APP_PID="$(read_state_value APP_PROJECT_ID)"
  STATE_DB_PID="$(read_state_value DB_PROJECT_ID)"
  STATE_PROXY_PID="$(read_state_value PROXY_PROJECT_ID)"
  if [[ "$STATE_MODE" == 'infisical' ]] && [[ "$STATE_ENV" == 'dev' || "$STATE_ENV" == 'staging' || "$STATE_ENV" == 'prod' ]] \
     && [[ -n "$STATE_APP_PID" && -n "$STATE_DB_PID" && -n "$STATE_PROXY_PID" ]]; then
    USE_INFISICAL=1
    INFISICAL_ENV="$STATE_ENV"
  else
    info 'El archivo de estado existe pero es inválido o incompleto; se continúa con la limpieza por nombre canónico.'
  fi
fi

# Si la instalación fue con entorno prod, la app y el proxy se levantaron con
# las variantes Production de sus composes; para la bajada hay que usar los
# mismos archivos.
if (( USE_INFISICAL )) && [[ "$STATE_ENV" == 'prod' ]]; then
  APP_FILE="$INSTALL_DIR/docker-compose.app.installer.prod.yml"
  PROXY_FILE="$INSTALL_DIR/docker-compose.nginx.installer.prod.yml"
fi

if (( USE_INFISICAL )); then
  info "Bajando el stack con Infisical (entorno: $INFISICAL_ENV) según el estado guardado por el instalador..."
  if command -v infisical >/dev/null 2>&1; then
    if [[ -z "${INFISICAL_TOKEN:-}" ]]; then
      read -r -p 'Client ID de Infisical (universal-auth): ' infisical_client_id
      read -rs -p 'Client Secret de Infisical (universal-auth): ' infisical_client_secret
      printf '\n'
      if [[ -n "$infisical_client_id" && -n "$infisical_client_secret" ]]; then
        login_err="$(mktemp)"
        INFISICAL_TOKEN="$(infisical login --method=universal-auth --client-id="$infisical_client_id" --client-secret="$infisical_client_secret" --plain --silent 2>"$login_err")" || INFISICAL_TOKEN=''
        [[ -s "$login_err" ]] && { printf 'Detalle del login:\n' >&2; cat "$login_err" >&2; }
        rm -f "$login_err"
        if [[ -n "$INFISICAL_TOKEN" ]]; then
          export INFISICAL_TOKEN
        else
          info 'El login de Infisical no devolvió un token; se continúa con la limpieza por nombre canónico.'
        fi
      else
        info 'Client ID o Client Secret vacíos; se continúa con la limpieza por nombre canónico.'
      fi
    fi
  else
    info 'El CLI de Infisical no está instalado; se continúa con la limpieza por nombre canónico.'
  fi
  if [[ -n "${INFISICAL_TOKEN:-}" ]]; then
    if [ -f "$PROXY_FILE" ]; then
      run_infisical_compose_down 'Docker Compose no pudo bajar el proxy vía Infisical' "$STATE_PROXY_PID" "$PROXY_FILE" \
        || info 'Se continúa con la limpieza por nombre canónico.'
    fi
    if [ -f "$APP_FILE" ]; then
      run_infisical_compose_down 'Docker Compose no pudo bajar la aplicación vía Infisical' "$STATE_APP_PID" "$APP_FILE" \
        || info 'Se continúa con la limpieza por nombre canónico.'
    fi
    if [ -f "$DB_FILE" ]; then
      run_infisical_compose_down 'Docker Compose no pudo bajar la base de datos vía Infisical' "$STATE_DB_PID" "$DB_FILE" \
        || info 'Se continúa con la limpieza por nombre canónico.'
    fi
  fi
elif (( ${#COMPOSE_FILES[@]} > 0 )); then
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
  rm -f "$APP_FILE" "$DB_FILE" "$PROXY_FILE" "$INSTALL_DIR/create-login.sql" "$ENV_FILE" "$ENV_EXAMPLE" "$STATE_FILE" \
        "$APP_FILE.download" "$DB_FILE.download" "$PROXY_FILE.download" "$INSTALL_DIR/create-login.sql.download" "$ENV_EXAMPLE.download" 2>/dev/null || true
  # Eliminar directorio si queda vacío
  rmdir "$INSTALL_DIR" 2>/dev/null || true
fi

echo ""
read -rp "¿Desea eliminar también la línea de exportación de INFISICAL_TOKEN de su .bashrc? [s/N]: " ans_tok
if [[ "${ans_tok,,}" =~ ^s|si|y|yes$ ]]; then
  if [[ -f "$HOME/.bashrc" ]] && grep -q '^export INFISICAL_TOKEN=' "$HOME/.bashrc"; then
    awk '{ if ($0 !~ /^export INFISICAL_TOKEN=/) print }' "$HOME/.bashrc" > "$HOME/.bashrc.tmp" && mv "$HOME/.bashrc.tmp" "$HOME/.bashrc"
    ok "Línea de exportación de INFISICAL_TOKEN eliminada de .bashrc."
  else
    info "No se encontró una línea de exportación de INFISICAL_TOKEN en .bashrc."
  fi
fi

echo ""
ok "Limpieza completada: contenedores, volúmenes y red del stack eliminados."
