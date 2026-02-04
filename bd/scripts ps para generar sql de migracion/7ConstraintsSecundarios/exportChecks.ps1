Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Directorio de salida
$dir = Join-Path $basedir "090_check_constraints"
New-Item -ItemType Directory -Force -Path $dir | Out-Null

# Archivo único
$file = Join-Path $dir "090_check_constraints.sql"

# Limpiar archivo previo
Remove-Item $file -ErrorAction Ignore

# Opciones de scripting
$options = New-DbaScriptingOption
$options.DriChecks     = $true
$options.PrimaryObject = $false
$options.ScriptSchema  = $true
$options.AppendToFile  = $true
$options.FileName      = $file

# Exportar todos los CHECK constraints
Get-DbaDbCheckConstraint -SqlInstance $server -Database $db |
    Sort-Object Schema, Table, Name |
    ForEach-Object {
        $_.Script($options)
    }
