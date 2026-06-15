@echo off
setlocal enabledelayedexpansion

set "source_dir=D:\general\estudio\proyectos\gymwebapp linux\bd\backupsonlydata un archivo por tabla"
set "dest_dir=D:\general\estudio\proyectos\gymwebapp linux\bd\archivosnumerados"
set "order_file=D:\general\estudio\proyectos\gymwebapp linux\bd\orden de insercion de datos en FitnessCenterDb de acuerdo a sus dependencias.md"

if not exist "%dest_dir%" (
    mkdir "%dest_dir%"
)

set /a count=1

for /f "tokens=2 delims=`" %%T in ('findstr /r /c:"^\*   `" "%order_file%"') do (
    set "table_name=%%T"
    for %%F in ("%source_dir%\!table_name!_*.sql") do (
        if exist "%%F" (
            copy "%%F" "%dest_dir%\!count!_%%~nxF"
        )
    )
    set /a count+=1
)

echo "Archivos numerados y copiados a la carpeta 'archivosnumerados'."