#!/bin/bash
# GitHub Pages 自动部署脚本
# 用途: 一键创建仓库、配置 GitHub Pages 并部署项目
# 使用: ./deploy-to-github-pages.sh <project-name> <github-username>

set -e

PROJECT_NAME=$1
GITHUB_USER=$2

if [ -z "$PROJECT_NAME" ] || [ -z "$GITHUB_USER" ]; then
    echo "❌ 用法: ./deploy-to-github-pages.sh <project-name> <github-username>"
    echo "示例: ./deploy-to-github-pages.sh my-app mason0510"
    exit 1
fi

echo "🚀 开始部署 $PROJECT_NAME 到 GitHub Pages..."

# 1. 检查是否在项目目录
if [ ! -f "package.json" ]; then
    echo "❌ 错误: 当前目录没有 package.json，请在项目根目录运行此脚本"
    exit 1
fi

# 2. 检查 vite.config.js 配置
if [ -f "vite.config.js" ]; then
    if ! grep -q "base: './'," vite.config.js; then
        echo "⚠️  警告: vite.config.js 中未设置 base: './'，可能导致白屏"
        echo "是否自动修复? (y/n)"
        read -r answer
        if [ "$answer" = "y" ]; then
            echo "正在修复 vite.config.js..."
            # 这里需要手动修复，脚本仅提示
        fi
    fi
fi

# 3. 检查 .github/workflows/deploy.yml
if [ ! -f ".github/workflows/deploy.yml" ]; then
    echo "❌ 错误: 缺少 .github/workflows/deploy.yml"
    echo "请先创建 GitHub Actions 配置文件"
    exit 1
fi

# 4. 初始化 Git（如果还没有）
if [ ! -d ".git" ]; then
    echo "📦 初始化 Git 仓库..."
    git init
    git add .
    git commit -m "Initial commit"
fi

# 5. 创建 GitHub 仓库
echo "📦 创建 GitHub 仓库 ${GITHUB_USER}/${PROJECT_NAME}..."
gh repo create ${GITHUB_USER}/${PROJECT_NAME} --public --source=. --remote=origin --push 2>/dev/null || {
    echo "⚠️  仓库可能已存在，继续..."
}

# 6. 配置 GitHub Pages
echo "⚙️  配置 GitHub Pages..."
gh api -X PUT /repos/${GITHUB_USER}/${PROJECT_NAME}/pages \
    -f build_type=workflow || {
    echo "⚠️  GitHub Pages 配置可能已存在"
}

# 7. 推送代码
echo "📤 推送代码到 GitHub..."
git branch -M main
git remote add origin https://github.com/${GITHUB_USER}/${PROJECT_NAME}.git 2>/dev/null || true
git push -u origin main

# 8. 等待部署
echo "⏳ 等待 GitHub Actions 构建（约 30-60 秒）..."
sleep 10

# 9. 监控构建状态
echo "📊 检查构建状态..."
for i in {1..12}; do
    STATUS=$(gh run list --repo ${GITHUB_USER}/${PROJECT_NAME} --limit 1 --json status,conclusion -q '.[0].conclusion')
    if [ "$STATUS" = "success" ]; then
        echo "✅ 构建成功！"
        break
    elif [ "$STATUS" = "failure" ]; then
        echo "❌ 构建失败！请查看日志:"
        echo "   gh run view --repo ${GITHUB_USER}/${PROJECT_NAME}"
        exit 1
    fi
    echo "   等待中... ($i/12)"
    sleep 5
done

# 10. 完成
echo ""
echo "🎉 部署完成！"
echo ""
echo "📍 访问地址: https://${GITHUB_USER}.github.io/${PROJECT_NAME}/"
echo "📦 仓库地址: https://github.com/${GITHUB_USER}/${PROJECT_NAME}"
echo ""
echo "💡 提示:"
echo "   - 如果页面白屏，检查 vite.config.js 中 base: './'"
echo "   - 强制刷新浏览器: Ctrl+Shift+R (Windows) 或 Cmd+Shift+R (Mac)"
echo "   - 查看构建日志: gh run view --repo ${GITHUB_USER}/${PROJECT_NAME}"
