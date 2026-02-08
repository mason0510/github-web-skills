# 经典有声书播客平台 🎧

> 精选中国经典文学有声书，提供高质量在线收听体验

🎧 **在线访问**: [https://mason0510.github.io/github-web-skills/](https://mason0510.github.io/github-web-skills/)

---

## 📚 播客系列

### 1. 南渡北归
- **作者**: 岳南
- **章节数**: 19章
- **类型**: 历史纪实
- **在线收听**: [南渡北归](https://mason0510.github.io/github-web-skills/nandu-beigui/)
- **简介**: 讲述抗战爆发前后，中国知识分子和民族精英的命运变迁

### 2. 了凡四训
- **作者**: 袁了凡
- **章节数**: 4篇
- **类型**: 国学经典
- **在线收听**: [了凡四训](https://mason0510.github.io/github-web-skills/liaofan-sixun/)
- **简介**: 明代思想家袁了凡的传世名作，阐述改变命运的方法

---

## ✨ 功能特色

### 🎯 核心功能
- ✅ **在线播放** - 无需下载，随时随地收听
- ✅ **进度记忆** - 自动保存播放进度，下次继续播放
- ✅ **响应式设计** - 完美支持手机、平板、电脑
- ✅ **极简UI** - 现代化设计，专注于内容本身

### 🔧 技术实现
- **前端框架**: 原生 HTML5 + CSS3 + JavaScript
- **音频托管**: Cloudflare R2 (全球CDN加速)
- **部署平台**: GitHub Pages (免费托管)
- **进度存储**: localStorage (本地存储，无需服务器)

### 🎨 设计亮点
- **毛玻璃效果** - backdrop-filter 实现现代化视觉
- **渐变配色** - 深色主题，护眼且专业
- **悬停动效** - 流畅的交互体验
- **自适应布局** - 移动端友好设计

---

## 🚀 快速开始

### 在线访问
直接访问 [https://mason0510.github.io/github-web-skills/](https://mason0510.github.io/github-web-skills/) 即可开始收听

### 本地运行
```bash
# 克隆仓库
git clone https://github.com/mason0510/github-web-skills.git

# 进入目录
cd github-web-skills

# 使用任意 HTTP 服务器运行（如 Python）
python3 -m http.server 8000

# 浏览器访问 http://localhost:8000
```

---

## 📂 项目结构

```
github-web-skills/
├── index.html              # 首页（展示所有系列）
├── nandu-beigui/           # 南渡北归系列
│   └── index.html          # 播放页面
├── liaofan-sixun/          # 了凡四训系列
│   └── index.html          # 播放页面
├── scripts/                # 部署脚本（GitHub Pages）
├── examples/               # 配置示例
├── SKILL.md                # GitHub Pages 部署技能文档
└── README.md               # 项目说明
```

---

## 🎯 技术栈

| 技术 | 用途 | 说明 |
|------|------|------|
| **HTML5 Audio** | 音频播放 | 原生支持，无需第三方库 |
| **CSS Grid/Flexbox** | 布局 | 响应式网格和弹性布局 |
| **LocalStorage API** | 进度存储 | 浏览器本地存储，持久化数据 |
| **Cloudflare R2** | 文件托管 | S3兼容对象存储，全球CDN |
| **GitHub Pages** | 网站部署 | 免费静态网站托管服务 |

---

## 🔄 播放进度记忆原理

### 工作流程
```
用户播放音频
    ↓
每5秒自动保存进度到 localStorage
    ↓
    {
      "track-1": {
        "time": 125.3,        // 播放时间（秒）
        "duration": 300,      // 总时长
        "percentage": 42      // 进度百分比
      }
    }
    ↓
下次访问自动恢复到上次位置
```

### 数据存储
- **存储位置**: 浏览器 localStorage
- **数据格式**: JSON
- **存储键**: `nandu-beigui-progress` / `liaofan-sixun-progress`
- **隐私保护**: 数据仅存储在本地，不上传服务器

---

## 🌐 音频托管方案

### Cloudflare R2 优势
- ✅ **全球CDN** - 自动选择最近节点，低延迟
- ✅ **无限流量** - 不限制下载次数和带宽
- ✅ **S3兼容** - 标准对象存储API
- ✅ **免费额度** - 10GB存储 + 每月10M请求

### 音频URL示例
```
https://pub-87cd59069cf0444aad048f7bddec99af.r2.dev/
  └─ audio/
      ├─ liaofan-sixun/
      │   ├─ 01-liminzhixue.mp3
      │   ├─ 02-gaiguozhifa.mp3
      │   ├─ 03-jishanzhifang.mp3
      │   └─ 04-qiandezhixiao.mp3
      └─ 2025-12-28/
          ├─ nandu_beigui_01.mp3
          ├─ nandu_beigui_02.mp3
          └─ ...
```

---

## 📊 项目统计

| 指标 | 数值 |
|------|------|
| 播客系列 | 2 个 |
| 总章节数 | 23 章 |
| 音频文件 | ~5.5 MB (了凡四训) + 多章节 (南渡北归) |
| 代码行数 | ~800 行 (HTML+CSS+JS) |
| 外部依赖 | 0 个 |

---

## 🎓 学习要点

### 前端技能
- ✅ 响应式网页设计
- ✅ HTML5 Audio API 使用
- ✅ LocalStorage 数据持久化
- ✅ CSS 渐变和动画效果
- ✅ 原生 JavaScript 事件处理

### 运维技能
- ✅ Cloudflare R2 对象存储配置
- ✅ GitHub Pages 部署流程
- ✅ CDN 加速原理和应用
- ✅ 静态网站性能优化

---

## 🔮 未来计划

- [ ] 添加播放列表自动连播
- [ ] 支持倍速播放
- [ ] 添加章节书签功能
- [ ] 提供离线下载选项
- [ ] 增加更多经典有声书系列

---

## 📖 相关文档

- **[SKILL.md](./SKILL.md)** - GitHub Pages 部署技能文档
- **[scripts/](./scripts/)** - 自动化部署脚本
- **[examples/](./examples/)** - 配置示例

---

## 📄 许可证

本项目采用 MIT 许可证

---

## 👤 作者

**Mason**
- GitHub: [@mason0510](https://github.com/mason0510)
- 项目链接: [github-web-skills](https://github.com/mason0510/github-web-skills)

---

## 🙏 致谢

- 感谢 Cloudflare 提供免费的 R2 对象存储服务
- 感谢 GitHub 提供免费的 Pages 托管服务
- 感谢所有经典文学作品的作者和传播者

---

<div align="center">

**如果这个项目对你有帮助，请点个 ⭐ Star 支持一下！**

Made with ❤️ by Mason | **版本**: 2.0.0 | **更新时间**: 2026-02-08

</div>
