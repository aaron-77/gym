#!/usr/bin/env bash
set -Eeuo pipefail

APP_REPO_URL="https://github.com/aaron-77/gym.git"
PROXY_REPO_URL="https://github.com/aaron-77/fitnessgymreverseproxy.git"
APP_REPO_PATH="${APP_REPO_URL#https://github.com/}"
PROXY_REPO_PATH="${PROXY_REPO_URL#https://github.com/}"
APP_BASE="https://raw.githubusercontent.com/${APP_REPO_PATH%.git}/main"
PROXY_BASE="https://raw.githubusercontent.com/${PROXY_REPO_PATH%.git}/main"
INSTALL_DIR="${FITNESSGYM_INSTALL_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/fitnessgym/docker-compose}"

fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
command -v docker >/dev/null 2>&1 || fail 'Docker no está instalado o no está en PATH.'
docker info >/dev/null 2>&1 || fail 'Docker está instalado, pero el daemon no está disponible.'
docker compose version >/dev/null 2>&1 || fail 'Se requiere Docker Compose v2.'
command -v curl >/dev/null 2>&1 || fail 'Se requiere curl para descargar los archivos.'
curl -fsSI --connect-timeout 5 --max-time 12 https://github.com >/dev/null || fail 'No hay conexión con GitHub. No se inició el despliegue.'

read -r -p 'Origen de configuración: [1] archivo .env (por defecto) [2] gestor de secretos: ' config_origin
CONFIG_SOURCE='env'
if [[ "$config_origin" == 2 ]]; then
  printf 'Gestores de secretos disponibles:\n  [1] Infisical\n'
  read -r -p 'Elegí el gestor de secretos: ' manager_choice
  [[ "$manager_choice" == 1 ]] || fail 'Opción de gestor de secretos inválida.'
  CONFIG_SOURCE='infisical'
  command -v infisical >/dev/null 2>&1 || fail 'El CLI de Infisical no está instalado. No se puede continuar con el modo gestor de secretos; instalalo y volvé a ejecutar este instalador.'
  read -r -p 'Entorno de Infisical: [1] dev [2] staging [3] prod: ' env_choice
  case "$env_choice" in
    1) INFISICAL_ENV='dev' ;;
    2) INFISICAL_ENV='staging' ;;
    3) INFISICAL_ENV='prod' ;;
    *) fail 'Opción de entorno inválida.' ;;
  esac
  if [[ -z "${INFISICAL_TOKEN:-}" ]]; then
    read -r -p 'Client ID de Infisical (universal-auth): ' infisical_client_id
    read -rs -p 'Client Secret de Infisical (universal-auth): ' infisical_client_secret
    printf '\n'
    [[ -n "$infisical_client_id" && -n "$infisical_client_secret" ]] || fail 'Client ID y Client Secret son obligatorios para generar el token.'
    login_err="$(mktemp)"
    INFISICAL_TOKEN="$(infisical login --method=universal-auth --client-id="$infisical_client_id" --client-secret="$infisical_client_secret" --plain --silent 2>"$login_err")" || {
      printf 'ERROR: El login de Infisical falló. Verificá el Client ID y el Client Secret.\n' >&2
      [[ -s "$login_err" ]] && { printf 'Detalle del error:\n' >&2; cat "$login_err" >&2; }
      rm -f "$login_err"
      exit 1
    }
    rm -f "$login_err"
    [[ -n "$INFISICAL_TOKEN" ]] || fail 'El login de Infisical no devolvió un token.'
    export INFISICAL_TOKEN
    if grep -q '^export INFISICAL_TOKEN=' "$HOME/.bashrc" 2>/dev/null; then
      awk -v line="export INFISICAL_TOKEN=$INFISICAL_TOKEN" '{ if ($0 ~ /^export INFISICAL_TOKEN=/) print line; else print }' "$HOME/.bashrc" > "$HOME/.bashrc.tmp" && mv "$HOME/.bashrc.tmp" "$HOME/.bashrc"
    else
      printf 'export INFISICAL_TOKEN=%s\n' "$INFISICAL_TOKEN" >> "$HOME/.bashrc"
    fi
  fi
  read -r -p 'Project ID de Infisical para fitnessgymapp: ' APP_PROJECT_ID
  [[ -n "$APP_PROJECT_ID" ]] || fail 'El Project ID de fitnessgymapp es obligatorio.'
  read -r -p 'Project ID de Infisical para fitnessgymbd: ' DB_PROJECT_ID
  [[ -n "$DB_PROJECT_ID" ]] || fail 'El Project ID de fitnessgymbd es obligatorio.'
  read -r -p 'Project ID de Infisical para fitnessgymnginx: ' PROXY_PROJECT_ID
  [[ -n "$PROXY_PROJECT_ID" ]] || fail 'El Project ID de fitnessgymnginx es obligatorio.'
else
  command -v od >/dev/null 2>&1 && command -v tr >/dev/null 2>&1 || fail 'Se requieren od y tr para generar secretos seguros.'
fi

mkdir -p "$INSTALL_DIR"
STATE_FILE="$INSTALL_DIR/.infisical-installer-state"
if [[ "$CONFIG_SOURCE" == 'infisical' ]]; then
  printf 'MODE=%s\nENV=%s\nAPP_PROJECT_ID=%s\nDB_PROJECT_ID=%s\nPROXY_PROJECT_ID=%s\n' \
    "$CONFIG_SOURCE" "$INFISICAL_ENV" "$APP_PROJECT_ID" "$DB_PROJECT_ID" "$PROXY_PROJECT_ID" > "$STATE_FILE"
else
  [[ ! -e "$STATE_FILE" ]] || rm -f "$STATE_FILE"
fi
download_if_missing() {
  local file="$1" url="$2" tmp="${1}.download"
  if [[ -s "$file" ]]; then
    printf 'Ya existe; se conserva: %s\n' "$file"
    return
  fi
  printf 'Descargando %s\n' "$(basename "$file")"
  curl -fL --connect-timeout 10 --max-time 120 "$url" -o "$tmp" || { rm -f "$tmp"; fail "No se pudo descargar $url"; }
  [[ -s "$tmp" ]] || { rm -f "$tmp"; fail "La descarga está vacía: $url"; }
  mv "$tmp" "$file"
}
download_file() {
  local file="$1" url="$2" tmp="${1}.download"
  printf 'Descargando %s\n' "$(basename "$file")"
  curl -fL --connect-timeout 10 --max-time 120 "$url" -o "$tmp" || { rm -f "$tmp"; fail "No se pudo descargar $url"; }
  [[ -s "$tmp" ]] || { rm -f "$tmp"; fail "La descarga está vacía: $url"; }
  mv "$tmp" "$file"
}

run_infisical_compose() {
  local fail_msg="$1" project_id="$2" compose_file="$3" err_file="${INSTALL_DIR}/.infisical-run.err" exit_code=0
  if infisical run --env="$INFISICAL_ENV" --projectId="$project_id" -- docker compose -f "$compose_file" up -d 2>"$err_file"; then
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

# El compose de la app depende del entorno seleccionado: prod usa la variante
# con ASPNETCORE_ENVIRONMENT=Production; dev y staging la de Development.
if [[ "$CONFIG_SOURCE" == 'infisical' && "$INFISICAL_ENV" == 'prod' ]]; then
  APP_FILE="$INSTALL_DIR/docker-compose.app.installer.prod.yml"
else
  APP_FILE="$INSTALL_DIR/docker-compose.app.installer.dev.yml"
fi
DB_FILE="$INSTALL_DIR/docker-compose.bd.installer.dev.yml"
PROXY_FILE="$INSTALL_DIR/docker-compose.nginx.installer.dev.yml"
CREATE_LOGIN_FILE="$INSTALL_DIR/create-login.sql"
ENV_FILE="$INSTALL_DIR/.env"
ENV_EXAMPLE="$INSTALL_DIR/.env.example"
download_file "$APP_FILE" "$APP_BASE/$(basename "$APP_FILE")"
download_file "$DB_FILE" "$APP_BASE/bd/docker-compose.installer.dev.yml"
download_file "$CREATE_LOGIN_FILE" "$APP_BASE/bd/create-login.sql"
download_file "$PROXY_FILE" "$PROXY_BASE/docker-compose.nginx.installer.dev.yml"
if [[ "$CONFIG_SOURCE" == 'env' ]]; then
  download_file "$ENV_EXAMPLE" "$APP_BASE/.env.example"
fi

NGINX_IMAGE="aaron77/fitnessgymnginx:latest"
PROXY_FILE_TMP="${PROXY_FILE}.tmp"
if ! awk -v image="$NGINX_IMAGE" '
  /^[[:space:]]*image:[[:space:]]*(aaron77\/)?fitnessgymnginx(dev)?(:[^[:space:]]+)?[[:space:]]*$/ {
    match($0, /^[[:space:]]*image:[[:space:]]*/)
    print substr($0, 1, RLENGTH) image
    matches++
    next
  }
  { print }
  END { if (matches < 1) exit 1 }
' "$PROXY_FILE" > "$PROXY_FILE_TMP"; then
  rm -f "$PROXY_FILE_TMP"
  fail "El Compose de Nginx no contiene una imagen de fitnessgymnginx que se pueda normalizar a $NGINX_IMAGE."
fi
mv "$PROXY_FILE_TMP" "$PROXY_FILE"

if [[ "$CONFIG_SOURCE" == 'env' ]]; then
  if [[ ! -s "$ENV_FILE" ]]; then
    cp "$ENV_EXAMPLE" "$ENV_FILE"
  else
    while IFS= read -r line; do
      [[ "$line" =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]] || continue
      key="${BASH_REMATCH[1]}"
      current_value="$(awk -F= -v key="$key" '$1 == key { value=substr($0, index($0, "=") + 1) } END { print value }' "$ENV_FILE")"
      [[ -n "$current_value" ]] || printf '%s\n' "$line" >> "$ENV_FILE"
    done < "$ENV_EXAMPLE"
  fi

  set_env_value() {
    local key="$1" value="$2" file_tmp="${ENV_FILE}.tmp"
    awk -v key="$key" -v value="$value" '
      BEGIN { found=0 }
      index($0, key "=") == 1 { print key "=" value; found=1; next }
      { print }
      END { if (!found) print key "=" value }
    ' "$ENV_FILE" > "$file_tmp" && mv "$file_tmp" "$ENV_FILE"
  }
  get_env_value() { awk -F= -v key="$1" '$1 == key { value=substr($0, index($0, "=") + 1) } END { print value }' "$ENV_FILE"; }
  for secret_key in SECRET_TOKEN_KEY MSSQL_SA_PASSWORD MSSQL_APP_LOGIN_PASSWORD; do
    if [[ "$(get_env_value "$secret_key")" == "__GENERATE_AT_INSTALL__" || -z "$(get_env_value "$secret_key")" ]]; then
      generated_secret="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
      if [[ "$secret_key" != SECRET_TOKEN_KEY ]]; then generated_secret="Aa1!$generated_secret"; fi
      set_env_value "$secret_key" "$generated_secret"
    fi
  done
  app_login_password="$(get_env_value MSSQL_APP_LOGIN_PASSWORD)"
  set_env_value DB_CONNECTION_STRING "Server=fitnessgym_bd;Database=FitnessCenterDB;User Id=fitnessgymlogin;Password=$app_login_password;TrustServerCertificate=True;MultipleActiveResultSets=True;Encrypt=True"
fi

port_is_free() { ! (echo >/dev/tcp/127.0.0.1/"$1") >/dev/null 2>&1; }
if [[ "$CONFIG_SOURCE" == 'env' ]]; then
  NGINX_PORT="$(get_env_value HOST_HTTP_PORT)"
  [[ "$NGINX_PORT" =~ ^[0-9]+$ ]] || NGINX_PORT=80
  if [[ "$NGINX_PORT" == 8090 || "$NGINX_PORT" == 8091 || "$NGINX_PORT" == 1433 ]] || ! port_is_free "$NGINX_PORT"; then
    NGINX_PORT=''
    for candidate in $(seq 8080 8089) $(seq 8092 8199); do
      if port_is_free "$candidate"; then NGINX_PORT="$candidate"; break; fi
    done
    [[ -n "$NGINX_PORT" ]] || fail 'El puerto configurado está ocupado y no hay puertos alternativos libres entre 8080 y 8199.'
    set_env_value HOST_HTTP_PORT "$NGINX_PORT"
  fi
else
  port_err="$(mktemp)"
  NGINX_PORT="$(infisical secrets get HOST_HTTP_PORT --env="$INFISICAL_ENV" --projectId="$PROXY_PROJECT_ID" --plain 2>"$port_err")" || NGINX_PORT=''
  if [[ -z "$NGINX_PORT" ]]; then
    printf 'AVISO: la variable HOST_HTTP_PORT no está definida en Infisical para el entorno elegido; se espera que el Compose correspondiente tenga un valor por defecto. La instalación continúa.\n' >&2
    [[ -s "$port_err" ]] && { printf 'Detalle:\n' >&2; cat "$port_err" >&2; }
  elif [[ "$NGINX_PORT" == 8090 || "$NGINX_PORT" == 8091 || "$NGINX_PORT" == 1433 ]] || ! port_is_free "$NGINX_PORT"; then
    printf 'ADVERTENCIA: el puerto %s está ocupado o reservado. La configuración proviene de Infisical; no se modifica nada.\n' "$NGINX_PORT" >&2
  fi
  rm -f "$port_err"
fi

docker network inspect fitnessgym-net >/dev/null 2>&1 || docker network create fitnessgym-net >/dev/null || fail 'No se pudo crear la red Docker fitnessgym-net.'
cd "$INSTALL_DIR"
if [[ "$CONFIG_SOURCE" == 'env' ]]; then
  docker compose -f "$DB_FILE" -f "$APP_FILE" -f "$PROXY_FILE" config -q || fail 'Los Compose no son válidos o falta configuración en .env.'
  docker compose -f "$DB_FILE" -f "$APP_FILE" -f "$PROXY_FILE" up -d || fail 'Docker Compose no pudo iniciar los contenedores.'
else
  run_infisical_compose 'Docker Compose no pudo iniciar la base de datos vía Infisical' "$DB_PROJECT_ID" "$DB_FILE" || exit 1
  run_infisical_compose 'Docker Compose no pudo iniciar la aplicación vía Infisical' "$APP_PROJECT_ID" "$APP_FILE" || exit 1
  run_infisical_compose 'Docker Compose no pudo iniciar el proxy vía Infisical' "$PROXY_PROJECT_ID" "$PROXY_FILE" || exit 1
fi

if [[ -n "$NGINX_PORT" ]]; then
  URL="http://localhost:$NGINX_PORT"
  printf '\nFitnessGym fue desplegado. Abrí esta URL: %s\n' "$URL"
  printf '\033]8;;%s\033\\%s\033]8;;\033\\\n' "$URL" "$URL"
  if command -v xdg-open >/dev/null 2>&1; then xdg-open "$URL" >/dev/null 2>&1 || true; fi
else
  printf '\nFitnessGym fue desplegado. No se pudo determinar el puerto de Nginx (HOST_HTTP_PORT no definida); usá el puerto por defecto del Compose.\n'
fi
