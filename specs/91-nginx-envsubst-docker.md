# Especificación: nginx-envsubst-docker

## Propósito

Contenedizar el edge nginx (reverse proxy) usando el mecanismo envsubst de la imagen oficial: la config de prod va embebida en la imagen como valor por defecto, la de dev se monta como override desde el compose, los valores llegan vía un `.env` gitignored que el operador gestiona **manualmente** (cero automatización de gestores de secretos), la red se integra con la app mediante la red externa `fitnessgym-net` (declarada por el usuario en sus propios composes — **cero ediciones fuera de este repo**), y todo archivo se respalda antes de modificarse.

**Capacidades**: nginx-envsubst-templating (1, 4) · edge-network-integration (2, 3) · secrets-injection-env-manual (5) · config-backup-discipline (6, 7).

**Variables (conjunto fijo)**: `GYM_PRIMARY_DOMAIN` (por defecto `ahlaradev.website`; certs en `/etc/letsencrypt/live/${GYM_PRIMARY_DOMAIN}/`), `GYM_APP_DOMAIN` (`gympower.ahlaradev.website`), `GYM_API_UPSTREAM` (`fitnessgym_api:5274`), `GYM_FRONTEND_UPSTREAM` (`fitnessgym_frontend:5062`), `GYM_SSL_DHPARAM`, `GYM_CLIENT_MAX_BODY_SIZE` (`100M`). Los logs NO se parametrizan (los cubre el volumen).

## Archivos del cambio

### Nuevos en `fitnessgymreverseproxy` (8 archivos)

| Archivo | Contenido |
|---|---|
| `nginx/Dockerfile` | `FROM nginx:stable` · `ENV` con los defaults de prod (las 6 `GYM_*`) · `NGINX_ENVSUBST_FILTER='^GYM_'` · `NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx` · `COPY` del template prod. ~10 líneas |
| `nginx/templates/nginx.conf.template` | Tu `nginx.prod.conf.bak` tal cual (3 server blocks, redirect 80→443, TLS, headers de seguridad, SignalR) pero con los valores reemplazados por `${GYM_*}`: dominios, rutas de cert, upstreams, `client_max_body_size` |
| `nginx/nginx.local.conf.template` | Tu `nginx.conf` local (1 server block, HTTP puro) con los mismos `${GYM_*}` en upstreams y `server_name`. Sin SSL |
| `docker-compose.nginx.yml` | Servicio nginx · puertos 80/443 · volumes: `./logs/nginx` (rw) + `/etc/letsencrypt:ro` + dhparam `:ro` · red `fitnessgym-net` con `external: true` · `environment:` con los nombres `GYM_*` · healthcheck |
| `docker-compose.nginx.local.yml` | Servicio nginx · monta `nginx.local.conf.template:ro` sobre `/etc/nginx/templates/nginx.conf.template` · logs (rw) · red `fitnessgym-net` con `external: true` · `environment:` con valores dev · solo puerto 80 (HTTP) |
| `.env.example` | Las 6 variables `GYM_*` documentadas con valores de ejemplo (sin secretos reales) — plantilla para `.env` |
| `.gitignore` | `.env`, `*.bak.*`, `backup/`, `*.swp` |
| `README.md` | Runbook: build, arranque prod/dev vía `.env` manual, verificación (`nginx -t`, curl de las 4 rutas), hook de certbot, política de respaldos |

### Modificado fuera del repo: NINGUNO

Nosotros NO tocamos ningún archivo fuera de `fitnessgymreverseproxy`. La red la declara **el usuario en sus propios composes** de la app (fuera de nuestro alcance):

```yaml
# en los composes de la app (responsabilidad del usuario)
networks:
  default:
    name: fitnessgym-net
```

> Contexto verificado: hoy los contenedores de la app usan la red automática `gym_default` (tus composes no declaran red). Con este cambio pasa a `fitnessgym-net`. Nuestros composes la referencian con `external: true` → nosotros no la creamos ni la borramos. Si la red aún no existe al arrancar el nginx, primero se levanta la app.

> `nginx.conf` y `nginx.prod.conf.bak` son **insumos**: se copian a los templates y NUNCA se modifican.

---

### Requisito 1: envsubst y seguridad de las variables de nginx

`NGINX_ENVSUBST_FILTER='^GYM_'` SHALL ser el ÚNICO mecanismo que proteja las variables de runtime de nginx (`$host`, `$connection_upgrade`, …). NO se usarán listas explícitas de variables de envsubst (rechazado por el usuario).

#### Escenario: las variables de runtime sobreviven

- DADO que el contenedor arranca con las `GYM_*` definidas
- CUANDO `20-envsubst-on-templates.sh` renderiza los `*.template`
- ENTONCES `$host` y `$connection_upgrade` quedan sin expandir y `nginx -t` sale con código 0

### Requisito 2: certs de prod (ro) y headers TLS

El compose de prod SHALL montar los certs SOLO LECTURA (`/etc/letsencrypt`, dhparam) más los logs escribibles. Runbook: `deploy-hook` de certbot → `docker exec <nginx> nginx -s reload`. HSTS solo sobre HTTPS de prod; `add_header` dentro de un `location` NO hereda los headers del server — redeclarar en cada location.

#### Escenario: certs solo lectura

- DADO el compose de prod con los mounts de certs/dhparam
- CUANDO corre `docker compose -f docker-compose.nginx.yml config`
- ENTONCES valida, certs/dhparam en `:ro`, logs escribibles, y `curl -I https://$GYM_APP_DOMAIN/` devuelve HSTS

### Requisito 3: Red — opción A (interna), external

El compose de nginx SHALL unirse a la red EXTERNA `fitnessgym-net` declarándola `external: true` (NUNCA host network); la red la crea y gestiona el dueño de la app en SUS composes (`networks: default: name: fitnessgym-net`) — nosotros NO la creamos ni la borramos. Upstreams `fitnessgym_api:5274` / `fitnessgym_frontend:5062` (`127.0.0.1` es inválido post-containerización). CERO ediciones fuera de este repo.

#### Escenario: red externa y ruteo

- DADO `fitnessgym-net` creada por el compose de la app (bloque `networks: default: name: fitnessgym-net`)
- CUANDO corre `docker compose -f docker-compose.nginx.yml config` y curl golpea `/api`, `/health`, `/reservacionesHub`, `/`
- ENTONCES nuestro compose declara `fitnessgym-net: {external: true}` y cada ruta devuelve non-502 desde `fitnessgym_api`/`fitnessgym_frontend`

### Requisito 4: Dos templates, un solo set de variables

Base `nginx:stable` (1.30.5, `www-data`, `envsubst`): la config actual funciona sin modificaciones. El template de prod es el POR DEFECTO de la imagen (`NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx` → `/etc/nginx/nginx.conf`, se le quita el sufijo `.template`); el compose de dev monta `nginx.local.conf.template` en solo lectura encima. Ambos templates usan el mismo set `${GYM_*}` con placeholders únicamente (sin dominios ni backends hardcodeados); nginx NO tiene condicionales.

#### Escenario: la imagen sola levanta prod

- DADO la imagen construida, sin mount dev, con los `ENV` de respaldo prod
- CUANDO arranca el contenedor
- ENTONCES la config contiene `/etc/letsencrypt/live/ahlaradev.website/`, `fitnessgym_api:5274`, `fitnessgym_frontend:5062` y cero literales `${GYM_`

#### Escenario: el mount dev renderiza HTTP-only

- DADO que el compose de dev monta el template en solo lectura
- CUANDO arranca el contenedor con valores dev de `GYM_*`
- ENTONCES la config es HTTP-only y `nginx -t` pasa

### Requisito 5: Mecanismo de inyección vía `.env` manual + respaldo ENV

El `environment:` del compose SHALL listar los nombres `GYM_*`; los valores SHALL llegar vía un `.env` gitignored que el operador crea y gestiona **a mano** (copiando `.env.example`) — este repo NO incluye ni invoca ningún gestor de secretos automático. El `ENV` del Dockerfile SHALL llevar los defaults de respaldo de prod (la imagen levanta prod sola). Nuestros archivos nuevos NO deben contener valores secretos hardcodeados. **Los valores de los secretos son responsabilidad del operador — FUERA DE ALCANCE.**

#### Escenario: valores entregados, nunca commiteados

- DADO que `.env` está gitignored y los composes solo referencian nombres `GYM_*`
- CUANDO se commitea el cambio
- ENTONCES git no rastrea ningún literal de secreto ni el `.env`

#### Escenario: fallback sin `.env`

- DADO que no hay ningún mecanismo automático de secretos en el repo
- CUANDO el operador provee el `.env` gitignored (creado a mano desde `.env.example`)
- ENTONCES compose lo consume y el contenedor arranca

### Requisito 6: Ubicación

TODO el trabajo de nginx SHALL vivir en el repo `fitnessgymreverseproxy`; **CERO archivos fuera de este repo serán modificados por nosotros**. El bloque `networks` en los composes de la app es responsabilidad del usuario (fuera de alcance).

#### Escenario: localidad del diff

- DADO que la implementación está completa
- CUANDO se revisa el estado de git de `fitnessgymreverseproxy`
- ENTONCES todos los cambios están dentro del repo y ningún archivo externo fue modificado por nosotros

### Requisito 7: Respaldos antes de editar

ANTES de modificar cualquier compose, Dockerfile o configuración de nginx, SHALL existir un respaldo con timestamp `<archivo>.bak.<AAAA-MM-DD-HHMMSS>`; los insumos (`nginx.conf`, `nginx.prod.conf.bak`) NUNCA se sobreescriben.

#### Escenario: el respaldo precede a la edición

- DADO los archivos insumo presentes
- CUANDO se modifica cualquier archivo objetivo
- ENTONCES existe un `.bak.<timestamp>` hermano y los insumos están byte-a-byte idénticos al estado previo

## Aceptación

| #  | Criterio                                                        | Verificación                        |
|----|-----------------------------------------------------------------|-------------------------------------|
| A1 | Los templates renderizan válido, sin `${GYM_` sin resolver      | `nginx -t` + grep                   |
| A2 | Ambos composes válidos                                          | `docker compose config`             |
| A3 | `/`, `/api`, `/health`, `/reservacionesHub` responden           | curl (dev HTTP, prod HTTPS)         |
| A4 | Sin secretos hardcodeados en nuestros archivos; respaldos existen | `git ls-files`; `.bak.*`          |
