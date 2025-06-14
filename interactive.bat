@echo off
setlocal

set PORT=56610

REM Ensure that no other container is using port 56610, and stop it if necessary
REM This is important if the user has abruptly terminated the server, preventing proper cleanup
for /f %%i in ('docker ps --filter "publish=%PORT%" -q') do set CID=%%i
if defined CID (
    echo Cleaning up old container on port %PORT%.
    docker stop %CID%
)

docker run --rm -it -v %cd%:/repo -p 127.0.0.1:%PORT%:8080 taylorabarnes/devenv
endlocal

pause
