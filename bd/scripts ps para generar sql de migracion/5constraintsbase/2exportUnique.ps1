Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Directorio de salida
$dir = Join-Path $basedir "070_unique_constraints"
New-Item -ItemType Directory -Force -Path $dir | Out-Null

# Archivo único
$file = Join-Path $dir "070_unique_constraints.sql"

# Limpiar archivo previo
Remove-Item $file -ErrorAction Ignore

# Opciones de scripting
$options = New-DbaScriptingOption
$options.DriUniqueKeys = $true
$options.PrimaryObject = $false
$options.ScriptSchema  = $true
$options.AppendToFile  = $true
$options.FileName      = $file

# Exportar UNIQUE constraints
Get-DbaDbTable -SqlInstance $server -Database $db |
    ForEach-Object {
        $_.Indexes |
            Where-Object { $_.IndexKeyType -eq 'DriUniqueKey' } |
            Sort-Object Name |
            ForEach-Object {
                $_.Script($options)
            }
    }
