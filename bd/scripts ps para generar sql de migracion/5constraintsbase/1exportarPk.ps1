Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Directorio de salida
$dir = Join-Path $basedir "060_primary_keys"
New-Item -ItemType Directory -Force -Path $dir | Out-Null

# Archivo destino
$file = Join-Path $dir "060_primary_keys.sql"

# Asegurar archivo limpio
Remove-Item $file -ErrorAction Ignore

# Opciones de scripting
$options = New-DbaScriptingOption
$options.DriPrimaryKey = $true
$options.PrimaryObject = $false
$options.ScriptSchema  = $true
$options.AppendToFile  = $true
$options.FileName      = $file

# Exportar Primary Keys
Get-DbaDbTable -SqlInstance $server -Database $db | ForEach-Object {
    $_.Indexes |
        Where-Object { $_.IndexKeyType -eq 'DriPrimaryKey' } |
        ForEach-Object {
            $_.Script($options)
        }
}
