$ErrorActionPreference = 'Stop'
$appDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$electron = Join-Path $appDir 'node_modules\electron\dist\electron.exe'
$icon = Join-Path $appDir 'assets\icon.ico'
if (-not (Test-Path $icon)) { $icon = Join-Path $appDir 'assets\icon.jpg' }
if (-not (Test-Path $electron)) {
  throw "Electron 尚未安装：$electron"
}

$desktop = [Environment]::GetFolderPath('Desktop')
$programs = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
New-Item -ItemType Directory -Force -Path $programs | Out-Null

function New-DshShortcut([string]$path) {
  $w = New-Object -ComObject WScript.Shell
  $s = $w.CreateShortcut($path)
  $s.TargetPath = $electron
  $s.Arguments = '"' + $appDir + '"'
  $s.WorkingDirectory = $appDir
  $s.WindowStyle = 7
  $s.Description = 'DeepSeek Harness'
  $s.IconLocation = $icon
  $s.Save()
}

New-DshShortcut (Join-Path $desktop 'DeepSeek Harness.lnk')
New-DshShortcut (Join-Path $programs 'DeepSeek Harness.lnk')
Write-Host 'Created desktop and Start Menu shortcuts.'
