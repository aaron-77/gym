@echo off
setlocal enabledelayedexpansion

set "input_dir=%~1"
set "output_file=datosexportadosarchivounico.sql"

if "%input_dir%"=="" (
    echo Por favor, proporciona la ruta a la carpeta con los archivos numerados.
    goto :eof
)

if not exist "%input_dir%" (
    echo La carpeta especificada no existe.
    goto :eof
)

if exist "%output_file%" (
    del "%output_file%"
)

for /f "delims=" %%F in ('dir /b /on "%input_dir%\*.sql"') do (
    type "%input_dir%\%%F" >> "%output_file%"
    echo. >> "%output_file%"
)

echo "Se ha generado el archivo %output_file% con el contenido de los archivos de la carpeta %input_dir%."
