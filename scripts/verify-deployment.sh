#!/bin/bash
# 验证 GitHub Pages 部署状态
# 用途: 检查部署是否成功，资源路径是否正确
# 使用: ./verify-deployment.sh <github-username> <project-name>

set -e

GITHUB_USER=$1
PROJECT_NAME=$2

if [ -z "$GITHUB_USER" ] || [ -z "$PROJECT_NAME" ]; then
    echo "❌ 用法: ./verify-deployment.sh <github-username> <project-name>"
    echo "示例: ./verify-deployment.sh mason0510 crypto-price-tracker"
    exit 1
fi

URL="https://${GITHUB_USER}.github.io/${PROJECT_NAME}/"

echo "🔍 验证部署: $URL"
echo ""

# 1. 检查 GitHub Actions 状态
echo "📊 检查构建状态..."
gh run list --repo ${GITHUB_USER}/${PROJECT_NAME} --limit 1

# 2. 检查 GitHub Pages 配置
echo ""
echo "⚙️  检查 GitHub Pages 配置..."
gh api /repos/${GITHUB_USER}/${PROJECT_NAME}/pages | jq '{build_type, html_url, status}'

# 3. 获取页面内容
echo ""
echo "📄 获取页面 HTML..."
HTML=$(curl -sL "$URL" 2>/dev/null || echo "Failed to fetch")

if [ "$HTML" = "Failed to fetch" ]; then
    echo "❌ 无法访问页面（可能是网络问题或页面未就绪）"
    echo ""
    echo "💡 可能原因:"
    echo "   1. 页面还在部署中（等待 1-2 分钟）"
    echo "   2. 网络限制（中国大陆访问 github.io 可能受限）"
    echo "   3. GitHub Pages 未正确配置"
    exit 1
fi

echo "✅ 页面可访问"
echo ""

# 4. 检查资源路径
echo "🔍 检查资源路径..."
if echo "$HTML" | grep -q 'src="./assets/'; then
    echo "✅ 使用相对路径（正确）: ./assets/"
elif echo "$HTML" | grep -q 'src="/assets/'; then
    echo "❌ 使用绝对路径（错误）: /assets/"
    echo ""
    echo "💡 解决方案:"
    echo "   1. 修改 vite.config.js: base: './'"
    echo "   2. 运行: ./fix-vite-config.sh"
    echo "   3. 重新部署"
    exit 1
else
    echo "⚠️  未检测到资源引用，可能是非 Vite 项目"
fi

# 5. 显示页面摘要
echo ""
echo "📋 页面信息:"
echo "$HTML" | grep -o '<title>.*</title>' || echo "   未找到 title"
echo ""

# 6. 检查 JS/CSS 文件
echo "🔍 检查资源文件..."
JS_FILES=$(echo "$HTML" | grep -o 'src="[^"]*\.js"' | wc -l | xargs)
CSS_FILES=$(echo "$HTML" | grep -o 'href="[^"]*\.css"' | wc -l | xargs)
echo "   JS 文件: $JS_FILES"
echo "   CSS 文件: $CSS_FILES"

if [ "$JS_FILES" -eq 0 ] && [ "$CSS_FILES" -eq 0 ]; then
    echo "⚠️  警告: 未检测到 JS/CSS 文件引用"
fi

# 7. 最终结果
echo ""
echo "🎉 验证完成！"
echo ""
echo "📍 访问地址: $URL"
echo ""
echo "💡 提示:"
echo "   - 如果页面白屏，请在浏览器按 F12 查看控制台错误"
echo "   - 强制刷新: Ctrl+Shift+R (Windows) 或 Cmd+Shift+R (Mac)"
echo "   - 查看构建日志: gh run view --repo ${GITHUB_USER}/${PROJECT_NAME}"
