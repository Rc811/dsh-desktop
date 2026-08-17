@echo off
setlocal
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
if errorlevel 1 (
  echo.
  echo 安装失败。请看上面的报错。
  pause
  exit /b 1
)
echo.
pause
