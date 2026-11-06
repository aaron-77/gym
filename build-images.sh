#!/usr/bin/env bash
# build-images.sh — ciclo de versionado/build/rotación para las imágenes FitnessGym
#
# Reglas (spec acordada con el usuario, 2026-10-23):
#   0. Verificar sesión de Docker Hub; si no hay, `docker login` antes de arrancar.
#   1. Descubrimiento: solo imágenes referenciadas en los docker compose del directorio
#      actual + subdirectorios (cruzadas contra las 4 conocidas). Menú multi-selección
#      con atajo "todas".
#   2. Semver. Base = MAX entre tags semver del repo aaron77/<img> en Docker Hub y los
#      tags semver de las imágenes locales. Pregunta POR imagen: siguiente inmediato
#      (patch+1) o bump major/minor/patch.
#   3. Freeze ANTES del build, SIN push: la :latest del repo se baja y queda tageada
#      local como aaron77/<img>:<NEXT>; la :latest LOCAL queda taggeada como <img>:<NEXT>.
#   4. Build local siempre taggeado :latest; el contexto lo define el docker compose con
#      "local" en el NOMBRE de archivo que referencie la imagen (build.context/dockerfile).
#   5. Fallo de build → preguntar: continuar con la siguiente o abortar (abortar = sin push).
#   6. Push ÚNICO al final, solo de las imágenes construidas OK:
#      aaron77/<img>:<NEXT> (congelada) + aaron77/<img>:latest (rotación).
#
# Uso: ./build-images.sh  (desde la raíz del repo)
set -uo pipefail

AARON="${AARON:-aaron77}"
CANON=(fitnessgymapi fitnessgymfrontend fitnessgymnginx fitnessgymbd)

die()  { echo "❌ $*" >&2; exit 1; }
info() { echo "ℹ️  $*"; }
warn() { echo "⚠️  $*" >&2; }
ok()   { echo "✅ $*"; }

# Docker y sus CLI se dan por hechos instalados (decisión del usuario).

PUSH_LATEST=()   # imgs con build OK (lista final)
PUSH_NEXT=()     # pares img:version congelada desde el repo (push al final)
SKIP=()          # imgs omitidas o con build fallido

# ------------------------------------------------------------------
# Fase 0 — Login a Docker Hub
# ------------------------------------------------------------------
if docker system info 2>/dev/null | grep -qiE '^ *Username:'; then
  ok "Sesión de Docker Hub detectada."
else
  info "No hay sesión de Docker Hub; iniciando login…"
  docker login || die "Fallo el login a Docker Hub. Aborto."
  ok "Login completado."
fi

# ------------------------------------------------------------------
# Fase 0.5 — Descubrimiento por compose
# ------------------------------------------------------------------
mapfile -t COMPOSE_FILES < <(
  find . -type f \( \
      -name 'docker-compose*.yml' -o -name 'docker-compose*.yaml' -o \
      -name 'compose*.yml'      -o -name 'compose*.yaml' \) \
    ! -path '*/node_modules/*' ! -path '*/.git/*' | sort -u
)
[ ${#COMPOSE_FILES[@]} -gt 0 ] || die "No hay docker compose en el directorio actual ni en subdirectorios."

DISCOVERED=()
for c in "${CANON[@]}"; do
  for f in "${COMPOSE_FILES[@]}"; do
    if grep -Eqi "image:[[:space:]]*([^[:space:]#]*/)?${c}(:[a-zA-Z0-9._-]+)?[[:space:]]*\$" "$f" 2>/dev/null; then
      DISCOVERED+=("$c")
      break
    fi
  done
done
[ ${#DISCOVERED[@]} -gt 0 ] || \
  die "Ninguna imagen conocida (${CANON[*]}) está en los compose. Nada para ofrecer."

# ------------------------------------------------------------------
# Menú — multi-selección con atajo "todas"
# ------------------------------------------------------------------
echo
info "Imágenes elegibles encontradas en los compose:"
i=0
for img in "${DISCOVERED[@]}"; do
  i=$((i + 1))
  printf '  %d) %s\n' "$i" "$img"
done

SELECTED=()
while [ ${#SELECTED[@]} -eq 0 ]; do
  # shellcheck disable=SC2162
  read -r -p "Elegí por número separado por espacios (ej.: 1 3) o 'todas': " SEL
  if [[ "${SEL// /}" == "todas" ]]; then
    SELECTED=("${DISCOVERED[@]}")
    break
  fi
  for n in $SEL; do
    if [[ "$n" =~ ^[0-9]+$ ]] && [ "$n" -ge 1 ] && [ "$n" -le ${#DISCOVERED[@]} ]; then
      SELECTED+=("${DISCOVERED[$((n - 1))]}")
    else
      warn "Opción inválida: '$n' (ignorada)."
    fi
  done
  [ ${#SELECTED[@]} -gt 0 ] || warn "No se seleccionó ninguna imagen; repetí."
  # dedup preservando orden
  if [ ${#SELECTED[@]} -gt 1 ]; then
    SELECTED=($(printf '%s\n' "${SELECTED[@]}" | awk '!seen[$0]++'))
  fi
done
ok "Seleccionadas: ${SELECTED[*]}"

# ==================================================================
# Helpers de versión — bash puro + comandos docker (sin python3)
# ==================================================================

# hub_all_tags <usuario/imagen> → todos los tags del repo en Docker Hub (paginado).
# La consulta HTTP corre en un contenedor efímero curlimages/curl → solo comandos docker.
hub_all_tags() {
  local url="https://hub.docker.com/v2/repositories/$1/tags?page_size=100"
  local json next
  while [ -n "$url" ]; do
    if ! json=$(docker run --rm curlimages/curl:latest -fsS "$url" 2>/dev/null); then
      return 1
    fi
    printf '%s\n' "$json" \
      | grep -oE '"name":[[:space:]]*"[^"]+"' \
      | sed -E 's/.*"name":[[:space:]]*"([^"]+)".*/\1/'
    next=$(printf '%s\n' "$json" \
      | grep -oE '"next":[[:space:]]*"[^"]+"' \
      | sed -E 's/.*"next":[[:space:]]*"([^"]+)".*/\1/' | tail -n1)
    url="$next"   # vacío (=null) → no hay más páginas
  done
}

# deja solo semver puro (v?X.Y.Z, sin sufijos) del stdin y quita la v
semvers_only() {
  grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' | sed 's/^v//'
}

# max del semver en stdin (sort -V) → la mayor versión ('' si no hay)
max_semver() {
  sort -uV | tail -n1
}

# compute_next <base> <major|minor|patch> — base vacía parte de 0.0.0
compute_next() {
  local base="${1:-}" bump="$2" maj mi pa
  base="${base#v}"
  base="${base:-0.0.0}"
  IFS='.' read -r maj mi pa <<<"$base"
  maj="${maj:-0}"; mi="${mi:-0}"; pa="${pa:-0}"
  case "$bump" in
    major) echo "$((maj + 1)).0.0" ;;
    minor) echo "$maj.$((mi + 1)).0" ;;
    *)     echo "$maj.$mi.$((pa + 1))" ;;
  esac
}

# build_local_compose <img> → primer compose *local* que la referencia (o vacío)
find_local_compose() {
  local img="$1" f
  for f in "${COMPOSE_FILES[@]}"; do
    case "$f" in *local*.yml|*local*.yaml|*Local*.yml|*Local*.yaml)
      grep -Eqi "image:[[:space:]]*([^[:space:]#]*/)?${img}(:[a-zA-Z0-9._-]+)?[[:space:]]*\$" "$f" && \
        { printf '%s\n' "$f"; return 0; }
    ;; esac
  done
  return 1
}

# build_config <compose> <img> → "contexto|dockerfile|entorno" del servicio que referencie la img.
# awk puro: bufferiza el bloque del servicio objetivo y extrae build inline o context/dockerfile.
build_config() {
  local file="$1" img="$2"
  awk -v img="$img" '
    /^[[:space:]]*#/ { next }                                     # comentarios fuera
    /^[^[:space:]#]/ {                                            # clave top-level nueva
      if (found) { exit }                                         # el bloque del servicio ya terminó
      buf=""; found=0
      next
    }
    /^  [[:alnum:]][[:alnum:]_-]*[[:space:]]*:/ {                 # nombre de servicio (2 espacios)
      if (found) { exit }
      buf=""
      next
    }
    {
      if (!found && index($0, "image:") > 0 && index($0, img) > 0) found=1
      buf = buf $0 "\n"
    }
    END {
      if (!found) exit 1
      n = split(buf, L, "\n")
      for (k = 1; k <= n; k++) {
        ln = L[k]
        if (short == "" && match(ln, /[[:blank:]]*build:[[:blank:]]+[^[:blank:]#]+/)) {
          short = substr(ln, RSTART, RLENGTH); sub(/.*build:[[:blank:]]+/, "", short)
        }
        if (ctx == "" && match(ln, /[[:blank:]]*context:[[:blank:]]+[^[:blank:]#]+/)) {
          ctx = substr(ln, RSTART, RLENGTH); sub(/.*context:[[:blank:]]+/, "", ctx)
        }
        if (df == "" && match(ln, /[[:blank:]]*dockerfile:[[:blank:]]+[^[:blank:]#]+/)) {
          df = substr(ln, RSTART, RLENGTH); sub(/.*dockerfile:[[:blank:]]+/, "", df)
        }
        if (build_env == "" && match(ln, /[[:blank:]]*BUILD_ENVIRONMENT:[[:blank:]]*[^[:blank:]#]+/)) {
          build_env = substr(ln, RSTART, RLENGTH); sub(/.*BUILD_ENVIRONMENT:[[:blank:]]*/, "", build_env)
        }
      }
      if (short != "") {
        if (short == "{file}") exit 1
        print short "||" build_env
        exit 0
      }
      print ctx "|" df "|" build_env
    }
  ' "$file"
}

# ==================================================================
# Procesamiento POR imagen (pregunta de versión: una por imagen)
# ==================================================================
NEXTS=()   # pares img:version por imagen (para el informe y el push final)

for IMG in "${SELECTED[@]}"; do
  echo
  echo "════════════════════════════════════════════════════"
  info "Procesando: ${IMG}"
  echo "════════════════════════════════════════════════════"

  ## Fase 1 — base semver = max(local, Hub) ─────────────────────────
  HUB_VERS=$(hub_all_tags "${AARON}/${IMG}" | semvers_only) || \
      warn "No se pudieron leer los tags de ${AARON}/${IMG} en Docker Hub (¿primera versión?); base = solo locales."
  LOCAL_VERS=$(docker images --format '{{.Repository}}:{{.Tag}}' \
             | grep -E "^${IMG}:" | cut -d: -f2 | semvers_only)
  BASE=$(printf '%s\n%s\n' "$HUB_VERS" "$LOCAL_VERS" | semvers_only | max_semver)

  if [ -z "$BASE" ]; then
    info "Sin versiones previas (ni local ni Hub); se parte de 0.0.0."
  else
    info "Versión base (max locales/Hub): ${BASE}"
  fi

  ## Fase 1.1 — pregunta de versión POR imagen ─────────────────────
  echo "  [1] Siguiente inmediato (patch + 1 desde ${BASE:-0.0.0})"
  echo "  [2] Bump MAJOR  (${BASE:-0.0.0} → $(compute_next "$BASE" major))"
  echo "  [3] Bump MINOR  (${BASE:-0.0.0} → $(compute_next "$BASE" minor))"
  echo "  [4] Bump PATCH  (${BASE:-0.0.0} → $(compute_next "$BASE" patch))"
  # shellcheck disable=SC2162
  read -r -p "Versión para ${IMG}: " CH
  case "$CH" in
    1) BUMP=patch ;;
    2) BUMP=major ;;
    3) BUMP=minor ;;
    4) BUMP=patch ;;
    *) die "Opción inválida: '$CH'." ;;
  esac
  NEXT=$(compute_next "$BASE" "$BUMP")
  NEXTS+=("${IMG}:${NEXT}")
  ok "Versión asignada: ${NEXT}"

  ## Fase 2 — doble freeze, SIN push ────────────────────────────────
  REMOTE_FROZEN=0
  if docker pull "${AARON}/${IMG}:latest"; then
    docker tag "${AARON}/${IMG}:latest" "${AARON}/${IMG}:${NEXT}" &&
      ok "Freeze remoto (local):  ${AARON}/${IMG}:${NEXT}" &&
      REMOTE_FROZEN=1
  else
    warn "No se pudo bajar ${AARON}/${IMG}:latest — se omite el freeze remoto (¿primera versión de la imagen en aaron77?)."
  fi

  LOCAL_FROZEN=0
  if docker image inspect "${IMG}:latest" >/dev/null 2>&1; then
    docker tag "${IMG}:latest" "${IMG}:${NEXT}" &&
      ok "Freeze local: ${IMG}:${NEXT}" &&
      LOCAL_FROZEN=1
  else
    warn "No hay imagen local ${IMG}:latest — freeze local omitido (¿primera build?)."
  fi
  [ "$REMOTE_FROZEN" -eq 1 ] || [ "$LOCAL_FROZEN" -eq 1 ] || \
    warn "ATENCIÓN: no había nada que congelar para ${IMG}; se construirá como versión ${NEXT} desde cero."

  ## Fase 3 — build (contexto del compose local) ────────────────────
  BUILD_OK=0
  LCOMPOSE=$(find_local_compose "$IMG")
  if [ -z "$LCOMPOSE" ]; then
    warn "No hay compose con 'local' en el nombre referenciando a ${IMG} — build imposible."
    warn "Nota: el build necesita un compose *local* que defina build.context para ${IMG}."
  else
    ok "Compose local: ${LCOMPOSE}"
    CFG=$(build_config "$LCOMPOSE" "$IMG")
    CTX="${CFG%%|*}"
    REST="${CFG#*|}"
    DFILE="${REST%%|*}"
    BUILD_ENVIRONMENT="${REST#*|}"
    CTX="${CTX%\"}"; CTX="${CTX#\"}"         # valores envueltos en comillas → limpio
    DFILE="${DFILE%\"}"; DFILE="${DFILE#\"}"
    BUILD_ENVIRONMENT="${BUILD_ENVIRONMENT%\"}"; BUILD_ENVIRONMENT="${BUILD_ENVIRONMENT#\"}"
    if [ -z "$CTX" ]; then
      warn "El compose local ${LCOMPOSE} no define 'build' para ${IMG}."
    else
      CTX="${CTX#./}"
      if [ -n "$DFILE" ]; then
        DFILE="${DFILE#./}"
        DFARG=(-f "${CTX:+${CTX}/}${DFILE}")
      else
        DFARG=(-f "${CTX:+${CTX}/}Dockerfile")
      fi
      BUILD_ENV_ARGS=()
      if [ -n "$BUILD_ENVIRONMENT" ]; then
        BUILD_ENV_ARGS=(--build-arg "BUILD_ENVIRONMENT=${BUILD_ENVIRONMENT}")
      fi
      info "Build: docker build -t ${IMG}:latest -f ${DFARG[1]} ${BUILD_ENV_ARGS[*]} ${CTX:-.}"
      if docker build "${DFARG[@]}" "${BUILD_ENV_ARGS[@]}" -t "${IMG}:latest" "${CTX:-.}"; then
        ok "Build OK: ${IMG}:latest"
        BUILD_OK=1
  # rotación local del tag aaron77 (push diferido al final)
        docker tag "${IMG}:latest" "${AARON}/${IMG}:latest" &&
          ok "Rotación local: ${AARON}/${IMG}:latest → a la nueva build."
      else
        warn "FALLÓ el build de ${IMG}."
      fi
    fi
  fi

  if [ "$BUILD_OK" -eq 1 ]; then
    PUSH_LATEST+=("$IMG")
    [ "$REMOTE_FROZEN" -eq 1 ] && PUSH_NEXT+=("${IMG}:${NEXT}")
  else
    SKIP+=("$IMG")
    # shellcheck disable=SC2034
    read -r -n1 -p "¿Seguir con la siguiente imagen (c) o abortar sin pushear nada (a)? [c/a]: " OP
    echo
    case "$OP" in
      [cC]) info "Continuando con la siguiente…";;
      *)    die "Abortado (a). NO SE PUSHEÓ NADA. Tags de freeze quedaron solo locales."
    esac
  fi
done

# ==================================================================
# Fase final — push ÚNICO (solo lo construido OK)
# ==================================================================
echo
[ ${#PUSH_LATEST[@]} -gt 0 ] || \
  die "Ninguna imagen quedó OK: NO SE PUSHEA NADA (el repo aaron77 queda intacto)."

ok "Fase final: push a ${AARON} (solo imágenes construidas OK)"
for pair in ${PUSH_NEXT[@]+"${PUSH_NEXT[@]}"}; do
  rimg="${pair%%:*}"; rver="${pair#*:}"
  info "Push congelada: ${AARON}/${rimg}:${rver}"
  docker push "${AARON}/${rimg}:${rver}" || warn "Falló el push de ${AARON}/${rimg}:${rver} — el freeze quedó sin versionar en el repo."
done

for IMG in ${PUSH_LATEST[@]+"${PUSH_LATEST[@]}"}; do
  info "Push rotación: ${AARON}/${IMG}:latest"
  docker push "${AARON}/${IMG}:latest" || warn "Falló el push de ${AARON}/${IMG}:latest — la rotación quedó pendiente."
done

echo
ok "═══ Resumen ═══"
ok "Construidas OK    : ${PUSH_LATEST[*]:-ninguna}"
ok "Fallidas/omitidas : ${SKIP[*]:-ninguna}"
info "Congeladas pushed : versión por imagen: ${PUSH_NEXT[*]:-ninguna}"
info "Rotadas pushed    : ${PUSH_LATEST[*]:-ninguna}"
ok "Fin del ciclo."
