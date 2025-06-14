@echo off
setlocal ENABLEDELAYEDEXPANSION

set PORT=56610
set PORTID=

REM Ensure that no other container is using port 56610, and stop it if necessary
REM This is important if the user has abruptly terminated the server, preventing proper cleanup
for /f %%i in ('docker ps --filter "publish=%PORT%" -q') do (
    set PORTID=%%i
)
if defined PORTID (
    echo Cleaning up old container on port %PORT%.
    docker stop !PORTID!
)

docker run --rm -it -v %cd%:/repo -p 127.0.0.1:%PORT%:8080 taylorabarnes/devenv
endlocal

pause
