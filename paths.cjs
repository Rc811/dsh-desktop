const fs = require('node:fs')
const os = require('node:os')
const path = require('node:path')
const { execFileSync } = require('node:child_process')

const ROOT = path.resolve(__dirname)
const LOCAL_FILE = path.join(ROOT, '.local.json')

function readLocal() {
  try {
    return JSON.parse(fs.readFileSync(LOCAL_FILE, 'utf8'))
  } catch {
    return {}
  }
}

function writeLocal(patch) {
  const next = { ...readLocal(), ...patch }
  fs.writeFileSync(LOCAL_FILE, `${JSON.stringify(next, null, 2)}\n`, 'utf8')
  return next
}

function whichNodeDir() {
  const local = readLocal()
  if (local.nodeDir && fs.existsSync(path.join(local.nodeDir, 'node.exe'))) return local.nodeDir
  const candidates = [
    process.env.DSH_NODE_DIR,
    process.env.NODE_HOME,
    'C:\\Program Files\\nodejs',
    'C:\\Program Files (x86)\\nodejs',
  ].filter(Boolean)
  for (const dir of candidates) {
    if (fs.existsSync(path.join(dir, 'node.exe'))) return dir
  }
  try {
    const out = execFileSync('where.exe', ['node'], { windowsHide: true, encoding: 'utf8' })
    const first = String(out).split(/\r?\n/).map((line) => line.trim()).find(Boolean)
    if (first && fs.existsSync(first)) return path.dirname(first)
  } catch {}
  return 'C:\\Program Files\\nodejs'
}

function harnessDir() {
  return process.env.DSH_HOME_SRC
    || readLocal().harnessDir
    || path.join(ROOT, 'vendor', 'deepseek-harness')
}

function dsRoot() {
  return process.env.DSH_DS_ROOT || path.join(ROOT, 'extensions')
}

function sessionRoot() {
  return process.env.DSH_SESSION_ROOT
    || readLocal().sessionRoot
    || path.join(ROOT, 'data', 'sessions')
}

function skinDir() {
  return process.env.DSH_SKIN_DIR || path.join(dsRoot(), 'skins')
}

function mediaInbox() {
  return process.env.DSH_MEDIA_INBOX || path.join(ROOT, 'data', 'media-inbox')
}

function corepackHome() {
  return process.env.COREPACK_HOME || path.join(ROOT, 'data', 'corepack')
}

function dshHome() {
  return process.env.DSH_HOME || path.join(os.homedir(), '.dsh')
}

function nodeDir() {
  return process.env.DSH_NODE_DIR || whichNodeDir()
}

function nodeExe() {
  return path.join(nodeDir(), process.platform === 'win32' ? 'node.exe' : 'node')
}

function dshBin() {
  return path.join(harnessDir(), 'apps', 'cli', 'lib', 'bin.js')
}

module.exports = {
  ROOT,
  LOCAL_FILE,
  readLocal,
  writeLocal,
  harnessDir,
  dsRoot,
  sessionRoot,
  skinDir,
  mediaInbox,
  corepackHome,
  dshHome,
  nodeDir,
  nodeExe,
  dshBin,
}
