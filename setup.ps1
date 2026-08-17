#Requires -Version 5.1
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root

function Write-Step($text) { Write-Host "`n==> $text" -ForegroundColor Cyan }
function Write-Ok($text) { Write-Host "    $text" -ForegroundColor Green }
function Fail($text) { Write-Host "`nERROR: $text" -ForegroundColor Red; exit 1 }

function Find-NodeDir {
  foreach ($dir in @(
    $env:DSH_NODE_DIR,
    'C:\Program Files\nodejs',
    'C:\Program Files (x86)\nodejs'
  )) {
    if ($dir -and (Test-Path (Join-Path $dir 'node.exe'))) { return $dir }
  }
  $cmd = Get-Command node -ErrorAction SilentlyContinue
  if ($cmd) { return Split-Path -Parent $cmd.Source }
  return $null
}

Write-Host 'DSH Desktop 安装' -ForegroundColor White
Write-Host '非官方 DeepSeek Harness 桌面端' -ForegroundColor DarkGray

$nodeDir = Find-NodeDir
if (-not $nodeDir) {
  Fail @"
未找到 Node.js。
请先安装 Node.js 22.19 或更高版本（推荐 22 LTS）：
  https://nodejs.org/
装完重新打开终端，再运行 setup.bat
"@
}

$nodeExe = Join-Path $nodeDir 'node.exe'
$verRaw = & $nodeExe -p 'process.versions.node'
$parts = $verRaw.Split('.')
$major = [int]$parts[0]
$minor = [int]$parts[1]
if (-not (($major -eq 22 -and $minor -ge 19) -or $major -ge 24)) {
  Fail "当前 Node 是 $verRaw，需要 22.19+ 或 24+"
}
Write-Ok "Node $verRaw  ($nodeDir)"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Fail "未找到 git。请安装 Git for Windows：https://git-scm.com/download/win"
}

$env:Path = "$nodeDir;$env:Path"
$env:COREPACK_HOME = Join-Path $Root 'data\corepack'
New-Item -ItemType Directory -Force -Path $env:COREPACK_HOME, (Join-Path $Root 'data\sessions'), (Join-Path $Root 'data\media-inbox') | Out-Null

Write-Step '启用 pnpm'
$corepack = Join-Path $nodeDir 'corepack.cmd'
if (Test-Path $corepack) {
  & $corepack enable
  & $corepack prepare pnpm@11.7.0 --activate
} else {
  npm install -g pnpm@11.7.0
}
Write-Ok 'pnpm 11.7.0'

$harness = Join-Path $Root 'vendor\deepseek-harness'
Write-Step '获取官方引擎 deepseek-harness'
if (-not (Test-Path (Join-Path $harness 'package.json'))) {
  New-Item -ItemType Directory -Force -Path (Join-Path $Root 'vendor') | Out-Null
  git clone --depth 1 https://github.com/deepseek-ai/deepseek-harness.git $harness
} else {
  Write-Ok '已存在，跳过 clone'
}

Write-Step '编译官方引擎（首次较慢）'
Push-Location $harness
try {
  pnpm install
  pnpm run build
} finally {
  Pop-Location
}
$bin = Join-Path $harness 'apps\cli\lib\bin.js'
if (-not (Test-Path $bin)) { Fail "引擎编译后找不到 $bin" }
Write-Ok '引擎已就绪'

Write-Step '安装桌面壳 Electron'
Push-Location $Root
try { npm install } finally { Pop-Location }
if (-not (Test-Path (Join-Path $Root 'node_modules\electron\dist\electron.exe'))) {
  Fail 'Electron 安装失败'
}
Write-Ok 'Electron 已就绪'

Write-Step '写入本地路径（不会提交到 Git）'
@{
  nodeDir = $nodeDir
  harnessDir = $harness
  sessionRoot = (Join-Path $Root 'data\sessions')
} | ConvertTo-Json | Set-Content -Encoding utf8 (Join-Path $Root '.local.json')

$example = Join-Path $Root 'config.example.json'
$config = Join-Path $Root 'config.json'
if (-not (Test-Path $config)) {
  Copy-Item $example $config
  Write-Ok '已创建空的 config.json'
}

Write-Step '落地破甲合同与中文权限'
$dsh = Join-Path $env:USERPROFILE '.dsh'
New-Item -ItemType Directory -Force -Path $dsh, (Join-Path $dsh 'profiles\web'), (Join-Path $dsh 'skills') | Out-Null
$agentsSrc = Join-Path $Root 'templates\AGENTS.md'
$agentsDst = Join-Path $dsh 'AGENTS.md'
if (-not (Test-Path $agentsDst) -or -not ((Get-Content $agentsDst -Raw) -match 'local execution mode')) {
  Copy-Item $agentsSrc $agentsDst -Force
  Write-Ok "已写入 $agentsDst"
} else {
  Write-Ok '已有破甲合同，未覆盖'
}
$patchSrc = Join-Path $Root 'templates\cordis.patch.yml'
$patchDst = Join-Path $dsh 'profiles\web\cordis.patch.yml'
if (-not (Test-Path $patchDst) -or -not ((Get-Content $patchDst -Raw) -match 'includeHarnessIdentity')) {
  Copy-Item $patchSrc $patchDst -Force
  Write-Ok '已写入中文权限 + 人格补丁'
} else {
  Write-Ok '已有 web 配置，未覆盖'
}

Write-Step '创建桌面快捷方式'
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Root 'install-shortcut.ps1')

Write-Host ''
Write-Host '安装完成。' -ForegroundColor Green
Write-Host '1. 双击桌面「DeepSeek Harness」或运行 start.bat'
Write-Host '2. 设置 → 模型，填入 DEEPSEEK_API_KEY'
