# Proposal: Minificación CSS/JS con Vite en GymFrontend

## Intent

GymFrontend sirve hoy 22 CSS + 30 JS (27 `.js` + 3 `.mjs`) desde `wwwroot/css` y `wwwroot/js` sin minificar ni cache-busting, referenciados directamente por ~25 vistas/layouts (~49 refs JS, ~30 CSS). Esto degrada performance (payloads grandes, sin hashes → caché ineficiente) y obliga a mantener nombres de archivo estables. Se introduce Vite como build de assets: fuente en `wwwroot/src/{css,js}`, output minificado + hasheado en `wwwroot/dist/` con `manifest.json`, y un `ViteTagHelper` que resuelve rutas por ambiente. Se corrige de paso una referencia rota (`detalles-clase.js`).

## Scope

### In Scope
- Migrar los 52 archivos (22 CSS + 30 JS) a `wwwroot/src/{css,js}` (fuente sin minificar).
- Vite: `package.json` (dependencia `vite`, script `build`) + `vite.config.mjs` con entrada nombrada por archivo (autogenerada por glob), `outDir: wwwroot/dist`, `emptyOutDir: true`, `build.manifest: true`.
- Excluir `src` del publish vía `<Content Update="wwwroot\src\**" CopyToPublishDirectory="Never" />` en `GymFrontend.csproj`.
- Auto-build en publish: target MSBuild `BuildViteAssets` (`BeforeTargets="PrepareForPublish"`) con `npm ci` (o `npm install` sin lock) + `npm run build`, escapable con `-p:NpmBuildAssets=false`.
- Docker: `RUN` de instalación de Node v20 en la stage SDK existente (sin stages nuevas); `.dockerignore` excluye `node_modules/` y `wwwroot/dist/` (generados), NO `wwwroot/src`.
- `TagHelpers/ViteTagHelper.cs`: atributos `css`/`js` (listas por coma) + `type="module"`; Dev → `~/src/...`; Prod/Staging → rutas hasheadas `~/dist/...` desde manifest cacheado. Registro explícito en `_ViewImports.cshtml`.
- Migrar las ~25 vistas/layouts a tag helper; eliminar la referencia rota a `~/js/detalles-clase.js` (`Views/Home/DetalleDeClase.cshtml:266`).
- `.gitignore`: `GymFrontend/node_modules/` y `GymFrontend/wwwroot/dist/`.
- Spec `85-spect-*.md` (se crea en fase sdd-spec).

### Out of Scope
- `wwwroot/lib/*` (assets de terceros importados) — NO se tocan.
- CDN, bundling de librerías de terceros, code-splitting avanzado, HMR.
- CI/CD (el publish ya dispara el build de assets automáticamente).
- Cambios de lógica en los JS/CSS — solo movimiento y build.

## Capabilities

### New Capabilities
- `assets-vite-build` (specs/85-spect-assetsVite.md): build de assets CSS/JS con Vite (src → dist minificado+hasheado con manifest), contrato de `ViteTagHelper` por ambiente, exclusión de `src` del publish y auto-build en publish.

### Modified Capabilities
None (cambio de tooling/implementación; no altera requerimientos de capabilities existentes).

## Approach

1. **Estructura**: mover los 52 archivos a `wwwroot/src/{css,js}`.
2. **Vite**: `package.json` + `vite.config.mjs` con `rollupOptions.input` generado por glob desde `wwwroot/src` (claves `js/<nombre>` y `css/<nombre>`) → cada archivo se carga selectivamente.
3. **Excluir `src` del publish** (`CopyToPublishDirectory="Never"`) → no llega a producción ni a la imagen Docker.
4. **Auto-build en publish**: target `BuildViteAssets` con `npm ci`/`npm install` + `npm run build`, escape `-p:NpmBuildAssets=false`.
5. **Docker**: `RUN` Node v20 en la stage SDK (`sdk:8.0` no trae Node); `.dockerignore` con `node_modules/` y `dist/` excluidos, `src` incluida.
6. **ViteTagHelper**: inyecta `IWebHostEnvironment`; Dev → `~/src/...`; Prod/Staging → lee y cachea `wwwroot/dist/.vite/manifest.json` (o `dist/manifest.json` según versión) y emite rutas hasheadas. Registrar en `_ViewImports.cshtml`.
7. **Migrar vistas**: reemplazar todas las refs `~/css/...` y `~/js/...` por el tag helper; limpiar la ref rota de `detalles-clase.js`.
8. **`.gitignore`**: `node_modules/` y `wwwroot/dist/`.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `GymFrontend/wwwroot/src/{css,js}/` | New | 22 CSS + 30 JS movidos (fuente) |
| `GymFrontend/wwwroot/dist/` | New | Output Vite minificado+hasheado (gitignored) |
| `GymFrontend/package.json`, `vite.config.mjs` | New | Build Vite (entrada por archivo vía glob) |
| `GymFrontend/GymFrontend.csproj` | Modified | Exclusión `wwwroot\src\**` del publish + target `BuildViteAssets` |
| `GymFrontend/DockerFile` | Modified | `RUN` Node v20 en stage SDK |
| `GymFrontend/.dockerignore` | Modified | Excluir `node_modules/`, `wwwroot/dist/` |
| `GymFrontend/.gitignore` | Modified | `node_modules/`, `wwwroot/dist/` |
| `GymFrontend/TagHelpers/ViteTagHelper.cs` | New | Resolución de rutas por ambiente + manifest |
| `GymFrontend/Views/_ViewImports.cshtml` | Modified | Registro explícito del tag helper |
| ~25 vistas/layouts en `GymFrontend/Views/` | Modified | `~/css/...`/`~/js/...` → `<vite ...>` |
| `Views/Home/DetalleDeClase.cshtml` | Modified | Eliminar ref rota `detalles-clase.js` |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Node ausente en imagen SDK `sdk:8.0` → publish en contenedor falla | Alto | `RUN` de Node v20 en stage SDK es obligatorio |
| `npm ci` exige `package-lock.json` commiteado | Medio | Elegir `npm install` si no hay lock, o commitear lock |
| `CopyToPublishDirectory="Never"` podría no aplicar al pipeline de static web assets de .NET 8 | Medio | Verificar en publish que `src` NO está en el output (criterio de aceptación) |
| Publish local sin Node da error opaco | Medio | Escape `-p:NpmBuildAssets=false` + mensaje claro |
| Ruta del manifest varía según versión de Vite (`.vite/manifest.json` vs `manifest.json`) | Bajo | Soporte de ambos paths en el tag helper, verificado en build |

## Rollback Plan

`git revert` del cambio completo: restaura `wwwroot/css` + `wwwroot/js`, vistas, csproj, DockerFile, tag helpers y specs. No hay migraciones de BD ni assets de terceros afectados → reversión limpia sin efectos colaterales.

## Dependencies

- Node v20 (instalado vía RUN en Docker; requerido localmente para dev/publish).
- Vite (última estable) y npm en `package.json`.
- `manifest.json` de Vite como fuente de rutas hasheadas en Producción/Staging.

## Success Criteria

- [ ] Dev sirve `wwwroot/src/` sin cambios de comportamiento visibles en ~25 vistas migradas
- [ ] `dotnet publish` genera `wwwroot/dist/` con hashes y `manifest.json`; `src/` AUSENTE del output
- [ ] `docker build` exitoso con npm corriendo dentro del publish (stage SDK con Node)
- [ ] `ViteTagHelper` emite `~/dist/...` hasheadas en Producción/Staging y `~/src/...` en Desarrollo
- [ ] Referencia rota `detalles-clase.js` eliminada sin regresión visible
- [ ] Spec 85 documenta el contrato de build y tag helper