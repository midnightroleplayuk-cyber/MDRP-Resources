@echo off
REM ============================================================
REM  Apex Minimap Studio - import a minimap you already have
REM
REM  TWO WAYS TO USE THIS:
REM    A) Drag your minimap FOLDER or .ZIP onto this file.
REM    B) Copy the files into tools\map_in\ and double-click this.
REM
REM  It reads .ytd / .dds / .png tiles (or one big PNG of the
REM  whole map), installs it as a new base map and adds it to the
REM  studio's Maps rail. No OpenIV, no CodeWalker, no Photoshop.
REM ============================================================
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
    echo.
    echo [ERROR] Node.js is not installed or not on PATH.
    echo Download it from https://nodejs.org  then run this again.
    echo.
    pause
    exit /b 1
)
node import_map.js %*
echo.
pause
