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
command -v od >/dev/null 2>&1 && command -v tr >/dev/null 2>&1 || fail 'Se requieren od y tr para generar secretos seguros.'
curl -fsSI --connect-timeout 5 --max-time 12 https://github.com >/dev/null || fail 'No hay conexión con GitHub. No se inició el despliegue.'

mkdir -p "$INSTALL_DIR"
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

APP_FILE="$INSTALL_DIR/docker-compose.app.installer.dev.yml"
DB_FILE="$INSTALL_DIR/docker-compose.bd.installer.dev.yml"
PROXY_FILE="$INSTALL_DIR/docker-compose.nginx.installer.dev.yml"
ENV_FILE="$INSTALL_DIR/.env"
ENV_EXAMPLE="$INSTALL_DIR/.env.example"
download_if_missing "$APP_FILE" "$APP_BASE/docker-compose.app.installer.dev.yml"
download_if_missing "$DB_FILE" "$APP_BASE/bd/docker-compose.installer.dev.yml"
download_if_missing "$PROXY_FILE" "$PROXY_BASE/docker-compose.nginx.installer.dev.yml"
if [[ ! -s "$ENV_FILE" ]]; then
  download_if_missing "$ENV_EXAMPLE" "$APP_BASE/.env.example"
  mv "$ENV_EXAMPLE" "$ENV_FILE"
else
  download_if_missing "$ENV_EXAMPLE" "$APP_BASE/.env.example"
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
if [[ "$(get_env_value DB_CONNECTION_STRING)" == "__GENERATE_AT_INSTALL__" || -z "$(get_env_value DB_CONNECTION_STRING)" ]]; then
  db_server="$(get_env_value DB_SERVER)"
  db_name="$(get_env_value DB_NAME)"
  db_user="$(get_env_value DB_APP_LOGIN)"
  db_password="$(get_env_value MSSQL_APP_LOGIN_PASSWORD)"
  set_env_value DB_CONNECTION_STRING "Server=$db_server;Database=$db_name;User Id=$db_user;Password=$db_password;TrustServerCertificate=True;MultipleActiveResultSets=True;Encrypt=True"
fi

port_is_free() { ! (echo >/dev/tcp/127.0.0.1/"$1") >/dev/null 2>&1; }
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

docker network inspect fitnessgym-net >/dev/null 2>&1 || docker network create fitnessgym-net >/dev/null || fail 'No se pudo crear la red Docker fitnessgym-net.'
# Forzar imagen de nginx dev
if [[ -f "$PROXY_FILE" ]]; then
  sed -i -E 's/^[[:space:]]*image:[[:space:]]*.*/    image: aaron77\/fitnessgymnginxdev:latest/' "$PROXY_FILE" 2>/dev/null || true
fi
docker pull aaron77/fitnessgymnginxdev:latest >/dev/null 2>&1 || true
cd "$INSTALL_DIR"
docker compose -f "$DB_FILE" -f "$APP_FILE" -f "$PROXY_FILE" config -q || fail 'Los Compose no son válidos o falta configuración en .env.'
docker compose -f "$DB_FILE" -f "$APP_FILE" -f "$PROXY_FILE" up -d || fail 'Docker Compose no pudo iniciar los contenedores.'

URL="http://localhost:$NGINX_PORT"
printf '\nFitnessGym fue desplegado. Abrí esta URL: %s\n' "$URL"
printf '\033]8;;%s\033\\%s\033]8;;\033\\\n' "$URL" "$URL"
if command -v xdg-open >/dev/null 2>&1; then xdg-open "$URL" >/dev/null 2>&1 || true; fi
