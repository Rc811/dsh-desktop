# DSH Desktop

非官方 DeepSeek Harness 桌面端。把官方引擎包进独立窗口：托盘、皮肤、余额、代理、本地插件、识图、全局破甲。

引擎本体来自 [deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness)（MIT）。本仓库只提供桌面壳和本地扩展。

## 一键安装（Windows）

1. 先装 [Node.js 22 LTS](https://nodejs.org/)（22.19 或更高）和 [Git](https://git-scm.com/download/win)
2. 下载本仓库 ZIP，或：

```powershell
git clone https://github.com/Rc811/dsh-desktop.git
cd dsh-desktop
```

3. 双击 `setup.bat`（首次会 clone 并编译官方引擎，需要几分钟到十几分钟）
4. 双击桌面快捷方式 **DeepSeek Harness**，或运行 `start.bat`
5. **设置 → 模型**，填入自己的 DeepSeek API Key

完整图文说明见 [docs/usage.md](docs/usage.md)。

## 填 Key

不要把 Key 写进仓库。任选一种：

- 应用内：设置 → 模型
- 用户目录：`%USERPROFILE%\.dsh\.credentials.yaml`

```yaml
DEEPSEEK_API_KEY: ""
```

模板在 `templates/credentials.example.yaml`。

## 日常使用

|菜单|作用|
|---|---|
|皮肤|主题 / 背景图|
|插件|只开关 `extensions/plugins` 里的本地插件|
|余额|右下角，约 60 秒刷新|
|会话|归档恢复/删除、数据目录|
|语言|中文 / English|
|代理|添加 HTTP / HTTPS / SOCKS5|
|窗口|关闭是进托盘还是退出|

- 工作区文件夹里是项目文件
- 对话记录在本仓库 `data/sessions`（已 gitignore）
- 破甲在安装时写入 `%USERPROFILE%\.dsh\AGENTS.md`，默认开启
- 拖图会先做本地 OCR，再交给模型

## 目录

```
dsh-desktop/
  setup.bat / setup.ps1    一键安装
  start.bat / start.vbs    启动
  extensions/              本地插件、皮肤、skill
  templates/AGENTS.md      破甲合同（安装时拷到 ~/.dsh）
  vendor/                  官方引擎（安装时下载，不提交）
  data/                    本地会话（不提交）
  docs/                    说明和截图
  config.example.json      空配置模板，无本机信息
```

## 可选：识图

不装也能聊天。要认图中文字，自行安装 [Tesseract](https://github.com/tesseract-ocr/tesseract)，把 `tesseract.exe` 放到 `tools/tesseract/`，中文包放同目录 `tessdata/chi_sim.traineddata`。视频抽帧需要 `tools/ffmpeg/ffmpeg.exe`。

## 许可证

本仓库 MIT。`vendor/deepseek-harness` 仍是 DeepSeek 的 MIT。
