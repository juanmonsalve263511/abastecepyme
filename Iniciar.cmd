@echo off
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
  echo Se requiere Node.js 22 o superior. Consulte README.md.
  pause
  exit /b 1
)
echo Cuando el servidor inicie, abra http://127.0.0.1:3000 en su navegador.
node src/server.js
pause
