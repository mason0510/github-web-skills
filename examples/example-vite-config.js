// 示例: Vite + React 项目的正确配置（用于 GitHub Pages）

import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// ✅ 正确配置 - 使用相对路径
export default defineConfig({
  plugins: [react()],
  base: './',  // 关键配置：相对路径，避免白屏

  // 可选：性能优化
  build: {
    rollupOptions: {
      output: {
        // 代码分割：分离第三方库
        manualChunks: {
          vendor: ['react', 'react-dom'],
        }
      }
    }
  }
})

// ❌ 错误配置 1 - 使用绝对路径（会导致白屏）
/*
export default defineConfig({
  plugins: [react()],
  base: '/',  // ❌ 错误：绝对路径在 GitHub Pages 子目录下无法加载资源
})
*/

// ❌ 错误配置 2 - 使用仓库名（不推荐，维护成本高）
/*
export default defineConfig({
  plugins: [react()],
  base: '/your-repo-name/',  // ❌ 不灵活：换仓库名需要改代码
})
*/

// ✅ 推荐：根据环境动态配置
/*
export default defineConfig(({ mode }) => ({
  plugins: [react()],
  base: mode === 'production' ? './' : '/',

  // 生产环境优化
  build: {
    minify: 'terser',
    terserOptions: {
      compress: {
        drop_console: true,  // 移除 console.log
      }
    }
  }
}))
*/
