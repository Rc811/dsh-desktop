@echo off
cd /d "%~dp0"
if not exist "node_modules\electron\dist\electron.exe" (
  echo 还没有安装。请先双击 setup.bat
  pause
  exit /b 1
)
start "" "node_modules\electron\dist\electron.exe" "%~dp0"
