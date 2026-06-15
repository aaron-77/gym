Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Directorio de salida
$dir = Join-Path $basedir "100_default_constraints"
New-Item -ItemType Directory -Force -Path $dir | Out-Null

# Archivo único
$file = Join-Path $dir "100_default_constraints.sql"

# Limpiar archivo previo
Remove-Item $file -ErrorAction Ignore

# Opciones de scripting
$options = New-DbaScriptingOption
$options.DriDefaults   = $true
$options.PrimaryObject = $false
$options.ScriptSchema  = $true
$options.AppendToFile  = $true
$options.FileName      = $file

# Exportar DEFAULT constraints
Get-DbaDbTable -SqlInstance $server -Database $db | ForEach-Object {
    $_.Columns |
        Where-Object { $_.DefaultConstraint } |
        Sort-Object { $_.DefaultConstraint.Name } |
        ForEach-Object {
            $_.DefaultConstraint.Script($options)
        }
}
