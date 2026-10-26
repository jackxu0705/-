@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

set NODE=C:\ProgramData\WorkBuddy\chromium-env\6syi6x\.workbuddy\binaries\node\versions\22.22.2\node.exe
if not exist "%NODE%" (
  where node >nul 2>nul
  if not errorlevel 1 (set NODE=node) else (
    echo Node not found
    pause
    exit /b 1
  )
)

echo Starting server...
start /B "" "%NODE%" "%~dp0start.js"

REM Wait for server to start
timeout /t 2 /nobreak >nul

REM Get the node process PID
for /f "tokens=2" %%a in ('tasklist /fi "imagename eq node.exe" /nh ^| findstr node') do set SERVER_PID=%%a

echo Opening browser...
start msedge http://127.0.0.1:8768/ 2>nul || start http://127.0.0.1:8768/
echo.
echo  AR Vision server is running
echo  http://127.0.0.1:8768/
echo.
echo  Press any key to stop the server and exit.
echo.
pause >nul

echo Stopping server...
if defined SERVER_PID (
  taskkill /f /pid %SERVER_PID% >nul 2>nul
) else (
  taskkill /f /im node.exe >nul 2>nul
)
exit
