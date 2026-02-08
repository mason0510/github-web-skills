# GitHub Pages 免费部署前端项目

## 元数据

- **技能名称**: GitHub Pages Deployment
- **类别**: 部署与运维
- **难度**: 中级
- **适用框架**: React, Vue, Vite, Next.js (SSG), 静态网站
- **版本**: 1.0.0
- **创建时间**: 2025-12-19

## 概述

这个技能教你如何将前端项目（特别是 Vite + React）免费部署到 GitHub Pages，实现零服务器成本的线上访问。

## 核心价值

- ✅ **完全免费**: 无需服务器费用
- ✅ **自动部署**: Git push 后自动构建和发布
- ✅ **全球 CDN**: GitHub 提供的全球加速
- ✅ **HTTPS 支持**: 自动启用 HTTPS
- ✅ **简单维护**: 只需维护代码，无需管理服务器

## 适用场景

| 场景 | 是否适用 | 说明 |
|------|---------|------|
| 纯前端应用（SPA） | ✅ | React, Vue, Angular 等 |
| 静态网站 | ✅ | 博客、文档、展示页 |
| 前端 + 第三方 API | ✅ | 调用 CoinGecko、Firebase 等外部 API |
| 需要后端服务器 | ❌ | 需要自己的数据库/API |
| 服务端渲染（SSR） | ❌ | Next.js SSR 不支持，但 SSG 可以 |

## 核心指令

### 1. 项目初始化

对于 Vite + React 项目，必须正确配置 `vite.config.js`：

```javascript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: './',  // ⚠️ 关键：使用相对路径，避免白屏
})
```

**为什么使用 `base: './'`？**

- ❌ `base: '/'` → 生成 `/assets/index.js`（绝对路径）→ GitHub Pages 子目录加载失败
- ✅ `base: './'` → 生成 `./assets/index.js`（相对路径）→ 任何路径都能正确加载

### 2. 配置 GitHub Actions 自动部署

创建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main
  workflow_dispatch:  # 允许手动触发

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm install

      - name: Build
        run: npm run build

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./dist

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### 3. 部署流程

```bash
# 1. 创建 GitHub 仓库
gh repo create your-project --public --source=. --remote=origin --push

# 2. 配置 GitHub Pages（使用 API）
gh api -X PUT /repos/YOUR_USERNAME/your-project/pages \
  -f build_type=workflow

# 3. 推送代码触发自动部署
git add .
git commit -m "Deploy to GitHub Pages"
git push

# 4. 等待 1-2 分钟，访问
# https://YOUR_USERNAME.github.io/your-project/
```

### 4. 常见问题排查

#### 问题 1: 白屏（最常见）

**症状**: 页面加载但内容空白

**原因**: `vite.config.js` 的 `base` 配置错误

**解决**:
```javascript
// ❌ 错误
export default defineConfig({
  base: '/',
})

// ✅ 正确
export default defineConfig({
  base: './',
})
```

**验证**: 查看部署后的 `index.html`，资源路径应该是：
```html
<script src="./assets/index-xxx.js"></script>  <!-- ✅ 相对路径 -->
<!-- 而不是 -->
<script src="/assets/index-xxx.js"></script>   <!-- ❌ 绝对路径 -->
```

#### 问题 2: 404 Not Found

**原因**: GitHub Pages 设置未启用

**解决**:
1. 访问仓库 Settings → Pages
2. Source 选择 "GitHub Actions"
3. 或使用命令：
```bash
gh api -X PUT /repos/YOUR_USERNAME/your-project/pages \
  -f build_type=workflow
```

#### 问题 3: 部署成功但使用旧代码

**原因**: GitHub Pages 缓存

**解决**:
```bash
# 手动触发新部署
gh workflow run deploy.yml --repo YOUR_USERNAME/your-project
```

### 5. 网络访问限制（中国大陆）

**问题**: `github.io` 在中国大陆可能被限制

**解决方案**: 使用自定义域名（如已有域名）

1. 创建 `public/CNAME` 文件：
```
your-domain.com
```

2. 配置 DNS（Cloudflare）：
```
CNAME  @  YOUR_USERNAME.github.io
```

3. GitHub 仓库 Settings → Pages → Custom domain 输入域名

## 技术栈对比

| 工具 | 免费额度 | 自动部署 | 自定义域名 | 适用场景 |
|------|---------|---------|-----------|---------|
| **GitHub Pages** | 100GB流量/月 | ✅ | ✅ | 静态网站、SPA |
| Vercel | 100GB流量/月 | ✅ | ✅ | Next.js、SSR |
| Netlify | 100GB流量/月 | ✅ | ✅ | 静态网站、Serverless |
| Cloudflare Pages | 无限流量 | ✅ | ✅ | 静态网站 |

## 最佳实践

### 1. 项目结构规范

```
your-project/
├── .github/
│   └── workflows/
│       └── deploy.yml       # GitHub Actions 配置
├── public/                  # 静态资源（会直接复制到 dist）
├── src/                     # 源代码
├── package.json
├── vite.config.js           # ⚠️ 必须配置 base: './'
└── README.md
```

### 2. 环境变量管理

GitHub Pages 是纯静态部署，**不能使用服务器端环境变量**。

**解决方案**:
- 使用 Vite 的环境变量（构建时注入）
- 创建 `.env.production`：
```bash
VITE_API_URL=https://api.example.com
```

- 代码中使用：
```javascript
const apiUrl = import.meta.env.VITE_API_URL
```

### 3. 性能优化

```javascript
// vite.config.js
export default defineConfig({
  plugins: [react()],
  base: './',
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],  // 分离第三方库
        }
      }
    }
  }
})
```

## 完整示例项目

参考本目录下的加密货币价格追踪器项目：
- 仓库: https://github.com/mason0510/crypto-price-tracker
- 在线访问: https://mason0510.github.io/crypto-price-tracker/

### 项目特点
- ✅ Vite + React
- ✅ 调用免费 CoinGecko API
- ✅ 实时价格更新（30秒轮询）
- ✅ 响应式设计
- ✅ 完全免费部署

## 相关资源

- [GitHub Pages 官方文档](https://docs.github.com/en/pages)
- [Vite 部署指南](https://vitejs.dev/guide/static-deploy.html#github-pages)
- [GitHub Actions 文档](https://docs.github.com/en/actions)

## 总结

使用 GitHub Pages 部署前端项目的核心要点：

1. ✅ **配置 `base: './'`** - 避免白屏
2. ✅ **使用 GitHub Actions** - 自动化部署
3. ✅ **设置 workflow_dispatch** - 支持手动触发
4. ✅ **验证构建产物** - 检查资源路径是否相对路径
5. ✅ **清除缓存** - 部署后强制刷新浏览器

遇到问题时，按以下顺序排查：
1. 检查 `vite.config.js` 的 `base` 配置
2. 查看 GitHub Actions 构建日志
3. 检查 GitHub Pages 设置（Settings → Pages）
4. 验证部署的 `index.html` 资源路径
5. 清除浏览器缓存并强制刷新
