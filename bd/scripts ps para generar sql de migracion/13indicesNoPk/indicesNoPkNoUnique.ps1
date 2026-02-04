Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$dir = Join-Path $basedir "110_indexes"
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$file = Join-Path $dir "110_indexes.sql"

$options = New-DbaScriptingOption
$options.Indexes              = $true
$options.PrimaryObject        = $true
$options.ClusteredIndexes     = $true
$options.NonClusteredIndexes  = $true
$options.AppendToFile               = $true
$options.FileName             = $file

Get-DbaDbTable -SqlInstance $server -Database $db |
ForEach-Object {
    $_.Indexes |
    Where-Object {
        $_.IndexKeyType -notin @('DriPrimaryKey', 'DriUniqueKey')
    } |
    Sort-Object Schema, Table, Name |
    ForEach-Object {
        $_.Script($options)
    }
}
