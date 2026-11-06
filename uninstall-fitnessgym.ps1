$ErrorActionPreference = 'Continue'

$installDir = if ($env:FITNESSGYM_INSTALL_DIR) { $env:FITNESSGYM_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA 'FitnessGym\docker-compose' }
$appFile = Join-Path $installDir 'docker-compose.app.installer.dev.yml'
$dbFile  = Join-Path $installDir 'docker-compose.bd.installer.dev.yml'
$proxyFile = Join-Path $installDir 'docker-compose.nginx.installer.dev.yml'
$createLoginFile = Join-Path $installDir 'create-login.sql'
$envFile = Join-Path $installDir '.env'
$envExample = Join-Path $installDir '.env.example'

function Write-Info([string]$m){ Write-Host "INFO: $m" }
function Write-Ok([string]$m){ Write-Host "OK: $m" }
function Stop-WithError([string]$m){ Write-Host "ERROR: $m"; exit 1 }

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { Stop-WithError 'Docker no está instalado o no está en PATH.' }
docker info *> $null
if ($LASTEXITCODE -ne 0) { Stop-WithError 'Docker está instalado, pero el daemon no está disponible.' }
docker compose version *> $null
if ($LASTEXITCODE -ne 0) { Stop-WithError 'Se requiere Docker Compose v2.' }

Write-Info "Directorio de instalación: $installDir"
Write-Info "Se van a detener y eliminar los contenedores y volúmenes del stack FitnessGym levantados con los installers."
Write-Host ""
$confirm = Read-Host "¿Desea continuar? [s/N]"
if ($confirm -notmatch '^(?i)s|si|y|yes$') { Write-Info "Operación cancelada."; exit 0 }

if (-not (Test-Path -LiteralPath $installDir)) { Write-Info "No existe el directorio de instalación. Nada que limpiar."; exit 0 }

Push-Location $installDir
try {
    $composeFiles = @()
    if (Test-Path -LiteralPath $dbFile)    { $composeFiles += @('-f', $dbFile) }
    if (Test-Path -LiteralPath $appFile)   { $composeFiles += @('-f', $appFile) }
    if (Test-Path -LiteralPath $proxyFile) { $composeFiles += @('-f', $proxyFile) }

    if ($composeFiles.Count -gt 0) {
        Write-Info "Deteniendo y eliminando contenedores, redes y volúmenes del stack..."
        docker compose @composeFiles down --remove-orphans --volumes *> $null
        if ($LASTEXITCODE -ne 0) { Stop-WithError 'No se pudieron eliminar los contenedores y volúmenes del stack.' }
    } else {
        Write-Info "No se encontraron archivos compose. Limpiando contenedores y sus volúmenes por nombre..."
        $volumesToRemove = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
        foreach ($c in @('apicontainer','frontendcontainer','fitnessgymdbcontainer','fitnessgym-nginx')) {
            $attachedVolumes = docker inspect --format '{{range .Mounts}}{{if eq .Type "volume"}}{{println .Name}}{{end}}{{end}}' $c 2>$null
            if ($LASTEXITCODE -eq 0) {
                foreach ($volume in $attachedVolumes) {
                    $volumeName = $volume.Trim()
                    if ($volumeName) { $null = $volumesToRemove.Add($volumeName) }
                }
            }
            docker rm -f $c *> $null
        }
        foreach ($volume in $volumesToRemove) {
            docker volume rm $volume *> $null
            if ($LASTEXITCODE -ne 0) { Stop-WithError "No se pudo eliminar el volumen $volume." }
        }
    }
} finally { Pop-Location }

Write-Host ""
$ansImg = Read-Host "¿Desea eliminar también las imágenes descargadas (aaron77/fitnessgymapi, aaron77/fitnessgymfrontend, aaron77/fitnessgymbd, aaron77/fitnessgymnginx)? [s/N]"
if ($ansImg -match '^(?i)s|si|y|yes$') {
    Write-Info "Eliminando imágenes..."
    docker rmi -f aaron77/fitnessgymapi:latest *> $null
    docker rmi -f aaron77/fitnessgymfrontend:latest *> $null
    docker rmi -f aaron77/fitnessgymbd:latest *> $null
    docker rmi -f aaron77/fitnessgymnginx:latest *> $null
    docker image prune -f *> $null
}

Write-Host ""
$ansFiles = Read-Host "¿Desea eliminar también los archivos descargados para la instalación (.env, .env.example y los docker-compose)? [s/N]"
if ($ansFiles -match '^(?i)s|si|y|yes$') {
    Write-Info "Eliminando archivos de instalación..."
    Remove-Item -LiteralPath $appFile,$dbFile,$proxyFile,$createLoginFile,$envFile,$envExample -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath "$appFile.download","$dbFile.download","$proxyFile.download","$createLoginFile.download","$envExample.download" -Force -ErrorAction SilentlyContinue
    try { [IO.Directory]::Delete($installDir, $false) } catch {}
}

Write-Host ""
Write-Ok "Limpieza completada. Se eliminaron los volúmenes de BD del stack."
