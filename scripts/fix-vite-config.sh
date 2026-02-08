#!/bin/bash
# 修复 Vite 配置以支持 GitHub Pages
# 用途: 自动修改 vite.config.js 设置正确的 base 路径
# 使用: ./fix-vite-config.sh

set -e

VITE_CONFIG="vite.config.js"

if [ ! -f "$VITE_CONFIG" ]; then
    echo "❌ 错误: 找不到 vite.config.js"
    exit 1
fi

echo "🔧 修复 vite.config.js 配置..."

# 备份原文件
cp "$VITE_CONFIG" "${VITE_CONFIG}.backup"
echo "📦 已备份到 ${VITE_CONFIG}.backup"

# 检查当前配置
if grep -q "base: './'," "$VITE_CONFIG"; then
    echo "✅ 配置已正确，无需修改"
    rm "${VITE_CONFIG}.backup"
    exit 0
fi

# 修复配置
if grep -q "base:" "$VITE_CONFIG"; then
    # 已有 base 配置，替换
    sed -i '' "s/base: ['\"].*['\"],/base: '.\/',/" "$VITE_CONFIG"
    echo "✅ 已修改现有 base 配置为 './'"
else
    # 没有 base 配置，添加
    sed -i '' "/plugins: \[.*\],/a\\
  base: './'," "$VITE_CONFIG"
    echo "✅ 已添加 base: './'"
fi

# 显示修改后的配置
echo ""
echo "📄 修改后的配置:"
cat "$VITE_CONFIG"

echo ""
echo "🎉 修复完成！"
echo ""
echo "💡 下一步:"
echo "   1. npm run build  # 重新构建"
echo "   2. git add vite.config.js"
echo "   3. git commit -m 'Fix: Set base to ./ for GitHub Pages'"
echo "   4. git push"
