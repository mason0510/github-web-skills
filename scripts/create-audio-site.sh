#!/bin/bash

# 创建音频播放网站并部署到 GitHub Pages
# 用法: ./create-audio-site.sh <项目名> <音频URL列表文件>

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 参数检查
if [ $# -lt 1 ]; then
    echo "用法: $0 <项目名> [音频URL列表文件]"
    echo ""
    echo "示例:"
    echo "  $0 my-audiobook urls.txt"
    echo ""
    echo "urls.txt 格式（每行一个URL）:"
    echo "  https://example.com/audio_01.mp3"
    echo "  https://example.com/audio_02.mp3"
    exit 1
fi

PROJECT_NAME="$1"
URLS_FILE="$2"

echo -e "${BLUE}=== 创建音频播放网站 ===${NC}"
echo "项目名: $PROJECT_NAME"

# 创建项目目录
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# 检查是否提供了URL文件
if [ -n "$URLS_FILE" ] && [ -f "$URLS_FILE" ]; then
    echo -e "${GREEN}✓${NC} 从文件读取音频URL: $URLS_FILE"

    # 生成HTML
    cat > index.html <<HTML
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${PROJECT_NAME}</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            color: #e8e8e8;
            padding: 20px;
        }
        .container { max-width: 800px; margin: 0 auto; }
        header { text-align: center; padding: 40px 20px; margin-bottom: 30px; }
        h1 {
            font-size: 2.5rem;
            font-weight: 300;
            letter-spacing: 4px;
            background: linear-gradient(90deg, #eee, #94bbe9);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .subtitle { color: #8892b0; font-size: 1rem; }
        .playlist {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 16px;
            padding: 20px;
            backdrop-filter: blur(10px);
        }
        .track {
            display: flex;
            align-items: center;
            padding: 15px;
            margin-bottom: 10px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        .track:hover { background: rgba(255, 255, 255, 0.08); transform: translateX(5px); }
        .track:last-child { margin-bottom: 0; }
        .track-number {
            width: 40px; height: 40px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: 600; margin-right: 15px; flex-shrink: 0;
        }
        .track-info { flex: 1; min-width: 0; }
        .track-title { font-size: 1rem; margin-bottom: 8px; color: #fff; }
        audio { width: 100%; height: 36px; border-radius: 18px; }
        footer { text-align: center; padding: 40px 20px; color: #5a6a8a; font-size: 0.85rem; }
        @media (max-width: 600px) {
            .track { flex-direction: column; align-items: flex-start; }
            .track-number { margin-bottom: 10px; }
            .track-info { width: 100%; }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>${PROJECT_NAME}</h1>
            <p class="subtitle">音频播放列表</p>
        </header>
        <div class="playlist">
HTML

    # 读取URL并生成播放列表
    index=1
    while IFS= read -r url || [ -n "$url" ]; do
        # 跳过空行和注释
        [[ -z "$url" || "$url" =~ ^[[:space:]]*# ]] && continue

        # 提取文件名作为标题
        filename=$(basename "$url" .mp3)
        filename=$(basename "$filename" .mp3)  # 确保去掉.mp3
        title=${filename//_/ }

        cat >> index.html <<TRACK
            <div class="track">
                <div class="track-number">$(printf "%02d" $index)</div>
                <div class="track-info">
                    <div class="track-title">$title</div>
                    <audio controls preload="none">
                        <source src="$url" type="audio/mpeg">
                    </audio>
                </div>
            </div>
TRACK
        ((index++))
    done < "$URLS_FILE"

    # 结束HTML
    cat >> index.html <<HTML
        </div>
        <footer>
            <p>Hosted on GitHub Pages</p>
        </footer>
    </div>
</body>
</html>
HTML

    echo -e "${GREEN}✓${NC} 生成 index.html ($(grep -c '<source' index.html) 个音频)"
else
    echo -e "${GREEN}创建基础模板${NC}"
    # 创建基础模板
    cat > index.html <<HTML
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${PROJECT_NAME}</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            color: #e8e8e8;
            padding: 20px;
        }
        .container { max-width: 800px; margin: 0 auto; }
        header { text-align: center; padding: 40px 20px; }
        h1 { font-size: 2.5rem; font-weight: 300; letter-spacing: 4px; }
    </style>
</head>
<body>
    <div class="container">
        <header><h1>${PROJECT_NAME}</h1></header>
    </div>
</body>
</html>
HTML
fi

# 初始化仓库
echo -e "${BLUE}初始化 Git 仓库...${NC}"
git init
git commit -m "初始化项目" -m "🤖 Generated with [Claude Code](https://claude.com/claude-code)" -m "Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

# 创建 GitHub 仓库
echo -e "${BLUE}创建 GitHub 仓库...${NC}"
gh repo create "$PROJECT_NAME" --public --source=. --push --description "${PROJECT_NAME} 音频播放网站"

# 启用 GitHub Pages
echo -e "${BLUE}启用 GitHub Pages...${NC}"
gh api repos/:owner/:repo/pages -X POST --input - <<EOF
{
  "build_type": "legacy",
  "source": { "branch": "main", "path": "/" }
}
EOF

# 等待部署
echo -e "${BLUE}等待部署...${NC}"
sleep 15

# 获取状态
status=$(gh api repos/:owner/:repo/pages/builds --jq '.[0].status')

if [ "$status" = "built" ]; then
    echo -e "${GREEN}✓ 部署成功！${NC}"
    gh api repos/:owner/:repo/pages --jq '.html_url'
else
    echo -e "${BLUE}部署中...${NC} 状态: $status"
    gh api repos/:owner/:repo/pages --jq '.html_url'
fi

echo -e "${GREEN}=== 完成 ===${NC}"
