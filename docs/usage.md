# 使用说明

## 1. 安装

已装 Node 22 和 Git 后，在仓库根目录双击 `setup.bat`。

成功后桌面会出现 **DeepSeek Harness**。也可以双击 `start.bat`。

首次编译官方引擎比较慢，属正常。

## 2. 填 API Key

打开应用后进入 **设置 → 模型**，粘贴 DeepSeek API Key。

也可以复制 `templates/credentials.example.yaml` 为 `%USERPROFILE%\.dsh\.credentials.yaml`，只填自己的 Key。不要提交这个文件。

## 3. 选工作区并对话

首页点 **添加工作区**，选一个你要改代码的文件夹。
选权限（完全访问 / 工作区可写 / 只读）和模型，输入问题发送。

## 4. 菜单

顶栏从左到右：皮肤、插件、余额、更新、会话、语言、代理、窗口。

- **皮肤**：换主题或背景图
- **插件**：只开关本仓库 `extensions/plugins`。官方自带插件不要关
- **余额**：右下角实时显示。阈值可在余额菜单改
- **会话**：对话存在 `data/sessions`。归档可恢复或删除
- **代理**：添加自己的 HTTP/SOCKS5，保存后会重启引擎。`127.0.0.1` 不走代理
- **窗口 → 点击关闭时**：缩小到托盘，或直接退出

## 5. 破甲

安装脚本会把 `templates/AGENTS.md` 写到 `%USERPROFILE%\.dsh\AGENTS.md`，本地插件会把它折进人格。

## 6. 识图

把图片拖进对话或粘贴截图。桌面会先做本地 OCR，再让模型根据文字回答。
