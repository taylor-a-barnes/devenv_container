@echo off

set /p IMAGE=<.docker/image_name

REM Check if the image is already available, and pull if needed
docker image inspect %IMAGE% >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Image not found locally. Pulling %IMAGE%...
    docker pull %IMAGE%
    IF %ERRORLEVEL% NEQ 0 (
        echo Failed to pull image %IMAGE%.
        exit /b 1
    )
    echo:
    echo:
    echo:
)

REM Copy the run script from the image
FOR /F %%i IN ('docker create %IMAGE%') DO SET CID=%%i
docker cp %CID%:/interface.ps1 .interface.ps1 >nul
docker rm -v %CID% >nul

REM Run the image's interface script
REM powershell -ExecutionPolicy Bypass -File .interface.ps1 %IMAGE%
powershell -ExecutionPolicy Bypass -File .interface.ps1 -image %IMAGE%

pause
