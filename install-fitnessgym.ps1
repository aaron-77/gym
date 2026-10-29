$ErrorActionPreference = 'Stop'

$appRepoUrl = 'https://github.com/aaron-77/gym.git'
$proxyRepoUrl = 'https://github.com/aaron-77/fitnessgymreverseproxy.git'
$appRepoPath = ([uri]$appRepoUrl).AbsolutePath.TrimStart('/') -replace '\.git$', ''
$proxyRepoPath = ([uri]$proxyRepoUrl).AbsolutePath.TrimStart('/') -replace '\.git$', ''
$appBase = "https://raw.githubusercontent.com/$appRepoPath/main"
$proxyBase = "https://raw.githubusercontent.com/$proxyRepoPath/main"
$installDir = if ($env:FITNESSGYM_INSTALL_DIR) { $env:FITNESSGYM_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA 'FitnessGym\docker-compose' }
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Stop-WithError([string] $Message) {
    [Console]::Error.WriteLine("ERROR: $Message")
    exit 1
}
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { Stop-WithError 'Docker no está instalado o no está en PATH.' }
docker info *> $null
if ($LASTEXITCODE -ne 0) { Stop-WithError 'Docker está instalado, pero el daemon no está disponible.' }
docker compose version *> $null
if ($LASTEXITCODE -ne 0) { Stop-WithError 'Se requiere Docker Compose v2.' }
try { $null = Invoke-WebRequest -Uri 'https://github.com' -Method Head -TimeoutSec 12 }
catch { Stop-WithError 'No hay conexión con GitHub. No se inició el despliegue.' }

New-Item -ItemType Directory -Path $installDir -Force | Out-Null
function Get-ComposeFile([string] $Path, [string] $Uri, [switch] $Refresh) {
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        if ((Get-Item -LiteralPath $Path).Length -gt 0 -and -not $Refresh) { Write-Host "Ya existe; se conserva: $([IO.Path]::GetFileName($Path))"; return }
        Remove-Item -LiteralPath $Path
    }
    $temporaryPath = "$Path.download"
    Write-Host "Descargando $([IO.Path]::GetFileName($Path))"
    try {
        Invoke-WebRequest -Uri $Uri -OutFile $temporaryPath -TimeoutSec 120
        if ((Get-Item -LiteralPath $temporaryPath).Length -eq 0) { throw 'La descarga está vacía.' }
        Move-Item -LiteralPath $temporaryPath -Destination $Path -Force
    } catch {
        Remove-Item -LiteralPath $temporaryPath -Force -ErrorAction SilentlyContinue
        Stop-WithError "No se pudo descargar $Uri. $($_.Exception.Message)"
    }
}

$appFile = Join-Path $installDir 'docker-compose.app.installer.dev.yml'
$dbFile = Join-Path $installDir 'docker-compose.bd.installer.dev.yml'
$proxyFile = Join-Path $installDir 'docker-compose.nginx.installer.dev.yml'
$envFile = Join-Path $installDir '.env'
$envExample = Join-Path $installDir '.env.example'
Get-ComposeFile $appFile "$appBase/docker-compose.app.installer.dev.yml" -Refresh
Get-ComposeFile $dbFile "$appBase/bd/docker-compose.installer.dev.yml" -Refresh
Get-ComposeFile $proxyFile "$proxyBase/docker-compose.nginx.installer.dev.yml"
Get-ComposeFile $envExample "$appBase/.env.example" -Refresh
if (-not (Test-Path -LiteralPath $envFile) -or (Get-Item -LiteralPath $envFile).Length -eq 0) {
    Copy-Item -LiteralPath $envExample -Destination $envFile -Force
}

function Read-EnvValue([string] $Key) {
    $line = Get-Content -LiteralPath $envFile | Where-Object { $_ -match "^$([regex]::Escape($Key))=" } | Select-Object -Last 1
    if ($null -eq $line) { return '' }
    return $line.Substring($line.IndexOf('=') + 1)
}
foreach ($sampleLine in Get-Content -LiteralPath $envExample) {
    if ($sampleLine -match '^([A-Za-z_][A-Za-z0-9_]*)=(.*)$') {
        $key = $Matches[1]
        if ((Read-EnvValue $key) -eq '' -or -not (Select-String -LiteralPath $envFile -Pattern "^$([regex]::Escape($key))=" -Quiet)) {
            Add-Content -LiteralPath $envFile -Value $sampleLine
        }
    }
}
function Set-EnvValue([string] $Key, [string] $Value) {
    $lines = [System.Collections.Generic.List[string]]::new()
    $found = $false
    foreach ($line in Get-Content -LiteralPath $envFile) {
        if ($line -match "^$([regex]::Escape($Key))=") {
            if (-not $found) { $lines.Add("$Key=$Value"); $found = $true }
        } else { $lines.Add($line) }
    }
    if (-not $found) { $lines.Add("$Key=$Value") }
    [IO.File]::WriteAllLines($envFile, $lines, [Text.UTF8Encoding]::new($false))
}
function New-RandomSecret([bool] $ForSqlServer = $false) {
    $bytes = [byte[]]::new(32)
    $generator = [Security.Cryptography.RandomNumberGenerator]::Create()
    try { $generator.GetBytes($bytes) } finally { $generator.Dispose() }
    $secret = [BitConverter]::ToString($bytes).Replace('-', '').ToLowerInvariant()
    if ($ForSqlServer) { return "Aa1!$secret" }
    return $secret
}
foreach ($secretKey in @('SECRET_TOKEN_KEY', 'MSSQL_SA_PASSWORD', 'MSSQL_APP_LOGIN_PASSWORD')) {
    $secret = Read-EnvValue $secretKey
    if (-not $secret -or $secret -eq '__GENERATE_AT_INSTALL__') {
        Set-EnvValue $secretKey (New-RandomSecret ($secretKey -ne 'SECRET_TOKEN_KEY'))
    }
}
$appLoginPassword = Read-EnvValue 'MSSQL_APP_LOGIN_PASSWORD'
Set-EnvValue 'DB_CONNECTION_STRING' "Server=fitnessgym_bd;Database=FitnessCenterDB;User Id=fitnessgymlogin;Password=$appLoginPassword;TrustServerCertificate=True;MultipleActiveResultSets=True;Encrypt=True"

function Test-LocalPortFree([int] $Port) {
    $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)
    try { $listener.Start(); return $true } catch { return $false } finally { try { $listener.Stop() } catch {} }
}
$nginxPortText = Read-EnvValue 'HOST_HTTP_PORT'
$nginxPort = 80
if ($nginxPortText -match '^\d+$') { $nginxPort = [int]$nginxPortText }
if ($nginxPort -in @(8090, 8091, 1433) -or -not (Test-LocalPortFree $nginxPort)) {
    $nginxPort = 0
    foreach ($candidate in @(8080..8089) + (8092..8199)) {
        if (Test-LocalPortFree $candidate) { $nginxPort = $candidate; break }
    }
    if ($nginxPort -eq 0) { Stop-WithError 'El puerto HTTP está ocupado y no hay puertos alternativos libres entre 8080 y 8199.' }
    Set-EnvValue 'HOST_HTTP_PORT' "$nginxPort"
}

docker network inspect fitnessgym-net *> $null
if ($LASTEXITCODE -ne 0) {
    docker network create fitnessgym-net *> $null
    if ($LASTEXITCODE -ne 0) { Stop-WithError 'No se pudo crear la red Docker fitnessgym-net.' }
}
# Forzar imagen de nginx dev solo para el servicio nginx
if (Test-Path -LiteralPath $proxyFile) {
    $lines = Get-Content -LiteralPath $proxyFile
    $out = New-Object System.Collections.Generic.List[string]
    $inNginx = $false
    foreach ($line in $lines) {
        if ($line -match '^\s*nginx:\s*$') { $inNginx = $true; $out.Add($line); continue }
        if ($inNginx -and $line -match '^\s{2}[a-zA-Z0-9_-]+:\s*$' -and $line -notmatch '^\s{4}') { $inNginx = $false }
        if ($inNginx -and $line -match '^\s*image:\s*') { $out.Add('    image: aaron77/fitnessgymnginxdev:latest'); continue }
        $out.Add($line)
    }
    [IO.File]::WriteAllLines($proxyFile, $out, [Text.UTF8Encoding]::new($false))
}
try { docker pull aaron77/fitnessgymnginxdev:latest *> $null } catch {}
Push-Location $installDir
try {
    $composeFiles = @('-f', $dbFile, '-f', $appFile, '-f', $proxyFile)
    docker compose @composeFiles config -q
    if ($LASTEXITCODE -ne 0) { Stop-WithError 'Los Compose no son válidos o falta configuración en .env.' }
    docker compose @composeFiles up -d
    if ($LASTEXITCODE -ne 0) { Stop-WithError 'Docker Compose no pudo iniciar los contenedores.' }
} finally { Pop-Location }

$url = "http://localhost:$nginxPort"
Write-Host "`nFitnessGym fue desplegado. Abrí esta URL: $url"
$escape = [char]27
Write-Host "$escape]8;;$url$escape\$url$escape]8;;$escape\"
try { Start-Process $url } catch { Write-Host 'No se pudo abrir el navegador automáticamente; abrí la URL indicada.' }
