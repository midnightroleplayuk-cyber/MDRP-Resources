@echo off
rem ── Apex Minimap Studio — build the exported minimap resource ──
rem Reads tools\png_in\ (staged by the in-game export) and writes a
rem complete resource to tools\out\<name>\ . Requires Node.js.
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
    echo Node.js was not found. Install it from https://nodejs.org and run this again.
    pause
    exit /b 1
)
node make_ytd.js
echo.
pause
