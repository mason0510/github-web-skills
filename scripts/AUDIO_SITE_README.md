# 音频网站一键生成脚本

自动创建音频播放网站并部署到 GitHub Pages。

## 功能

- 一键生成带音频播放器的静态网站
- 自动部署到 GitHub Pages（免费托管）
- 深色主题，响应式设计
- 支持批量导入音频 URL

## 使用方法

### 方式一：自动生成（推荐）

创建一个文本文件（如 `urls.txt`），每行一个音频 URL：

```bash
./create-audio-site.sh 我的有声书 urls.txt
```

`urls.txt` 格式：
```
https://example.com/audio_01.mp3
https://example.com/audio_02.mp3
https://example.com/audio_03.mp3
```

### 方式二：手动编辑模板

```bash
./create-audio-site.sh 我的网站
```

生成基础模板后，手动编辑 `index.html` 添加音频。

## 依赖

- `gh` - GitHub CLI
- `git` - 版本控制

安装 GitHub CLI：
```bash
brew install gh  # macOS
```

首次使用需要登录：
```bash
gh auth login
```

## 生成的网站结构

```
项目名/
├── index.html      # 主页面（包含所有播放器）
└── .git/          # Git 仓库
```

## 自动化流程

1. 创建项目目录
2. 生成 `index.html`（含所有音频播放器）
3. 初始化 Git 仓库
4. 创建 GitHub 仓库
5. 启用 GitHub Pages
6. 部署完成

## 输出

脚本会输出部署后的网站地址，例如：

```
https://yourname.github.io/项目名/
```

## 示例

```bash
# 创建南渡北归有声书网站
./create-audio-site.sh 南渡北归 nandu_urls.txt

# 输出：
# ✓ 生成 index.html (18 个音频)
# ✓ 初始化 Git 仓库...
# ✓ 创建 GitHub 仓库...
# ✓ 启用 GitHub Pages...
# ✓ 部署成功！
# https://yourname.github.io/南渡北归/
```
