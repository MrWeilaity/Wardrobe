# 智衣橱项目文档中心
# Smart Wardrobe Documentation Hub

欢迎来到智衣橱项目的完整文档中心！本目录包含了项目的所有核心文档，涵盖需求分析、系统设计和用户操作指南。

---

## 📚 文档目录

### 1. 产品需求规格说明书 (PRD)
**文件**: [PRD.md](./PRD.md)  
**适用对象**: 产品经理、项目经理、开发团队、测试团队  
**主要内容**:
- ✅ 项目背景与愿景
- ✅ 目标用户画像与使用场景
- ✅ 完整功能需求（按优先级分级）
- ✅ 非功能需求（性能、安全、兼容性）
- ✅ 业务流程图（Mermaid图表）
- ✅ 用户故事与用例
- ✅ 成功指标与KPI
- ✅ 风险分析与假设

**关键流程图**:
- 用户注册登录流程（时序图）
- 衣物录入流程（流程图）
- 创建旅行清单流程（流程图）
- 穿搭方案创建流程（时序图）

### 2. 系统设计文档 (SDD)
**文件**: [SDD.md](./SDD.md)  
**适用对象**: 系统架构师、后端开发、前端开发、运维团队  
**主要内容**:
- ✅ 系统总体架构（C4模型）
- ✅ 前端架构设计（Vue.js 3）
- ✅ 后端架构设计（Spring Boot）
- ✅ 数据库设计（ER图、表结构）
- ✅ RESTful API接口规范
- ✅ 关键业务流程时序图
- ✅ 安全设计（JWT、加密、权限）
- ✅ 性能优化策略
- ✅ Docker部署架构

**核心技术架构**:
```
前端: Vue.js 3 + Pinia + Vue Router + Element Plus + Vite
后端: Spring Boot 2.7.18 + Spring Security + JWT + JPA
数据库: MySQL 5.7/8.0
部署: Docker + Docker Compose + Nginx
```

**关键设计图**:
- 系统总体架构图
- 前后端架构图
- 数据库ER图
- 用户登录认证时序图
- 衣物录入流程时序图
- 创建穿搭方案时序图
- JWT Token验证流程

### 3. 用户操作手册 (User Manual)
**文件**: [USER_MANUAL.md](./USER_MANUAL.md)  
**适用对象**: 系统管理员、最终用户、运维人员  
**主要内容**:
- ✅ 系统简介与功能概览
- ✅ 环境准备与系统要求
- ✅ **Docker一键部署脚本** (quick-start.sh)
- ✅ Docker Compose完整配置
- ✅ Dockerfile配置（前后端）
- ✅ Nginx配置文件
- ✅ 手动部署详细步骤
- ✅ 用户操作指南（配图说明）
- ✅ 管理员操作指南
- ✅ 常见问题FAQ（15+问题）
- ✅ 故障排查手册
- ✅ 系统监控与维护

**部署方式**:
1. **Docker一键部署**（推荐）- 最简单快捷
2. **手动部署** - 适合开发调试

---

## 🚀 快速开始

### 方式一：Docker一键部署（推荐）

```bash
# 1. 克隆项目
git clone https://github.com/MrWeilaity/Wardrobe.git
cd Wardrobe

# 2. 执行一键启动脚本
chmod +x quick-start.sh
./quick-start.sh

# 3. 访问系统
# 前端: http://localhost
# 后端: http://localhost:8080/api
# 默认账号: admin / admin123
```

### 方式二：查看详细文档

1. **产品经理/项目经理** → 先阅读 [PRD.md](./PRD.md)
2. **开发人员** → 先阅读 [SDD.md](./SDD.md)
3. **运维/用户** → 先阅读 [USER_MANUAL.md](./USER_MANUAL.md)

---

## 📊 文档特色

### ✨ 图文并茂
- **12+ Mermaid图表**: 流程图、时序图、ER图、架构图
- **ASCII艺术图**: 界面布局示意图
- **表格展示**: 清晰的功能列表、技术对比

### 🔧 实用性强
- **完整部署脚本**: 可直接使用的Shell脚本
- **配置文件模板**: Docker、Nginx、application.yml
- **故障排查指南**: 常见问题及解决方案
- **API测试示例**: curl命令示例

### 📖 结构严谨
- **标准化格式**: 遵循Markdown规范
- **层次分明**: 清晰的目录结构
- **版本控制**: 文档版本号和变更历史

---

## 🎯 文档使用指南

### 不同角色的阅读路径

#### 👨‍💼 产品经理
```
PRD.md (完整阅读)
  ↓
SDD.md (浏览架构部分)
  ↓
USER_MANUAL.md (了解用户体验)
```

#### 👨‍💻 后端开发
```
PRD.md (了解需求)
  ↓
SDD.md (重点阅读后端架构、数据库、API)
  ↓
USER_MANUAL.md (部署测试)
```

#### 🎨 前端开发
```
PRD.md (了解需求和用户流程)
  ↓
SDD.md (重点阅读前端架构、API接口)
  ↓
USER_MANUAL.md (界面操作流程)
```

#### 🔧 运维工程师
```
USER_MANUAL.md (完整阅读，重点部署和故障排查)
  ↓
SDD.md (了解系统架构)
  ↓
PRD.md (了解业务逻辑)
```

#### 🧪 测试工程师
```
PRD.md (了解功能需求和用户故事)
  ↓
USER_MANUAL.md (编写测试用例)
  ↓
SDD.md (理解技术实现)
```

---

## 📝 文档更新日志

| 版本 | 日期 | 更新内容 | 作者 |
|------|------|---------|------|
| V2.0 | 2025-12-15 | 创建完整文档体系（PRD + SDD + USER_MANUAL） | 系统架构师 |
| V1.0 | 2025-12 | 初始需求分析文档 | 产品团队 |

---

## 🔗 相关资源

### 项目仓库
- 📦 GitHub: https://github.com/MrWeilaity/Wardrobe
- 🌿 主分支: `main`
- 🔧 开发分支: `develop`

### 在线访问（如已部署）
- 🌐 生产环境: http://your-domain.com (待配置)
- 🧪 测试环境: http://test.your-domain.com (待配置)
- 📚 API文档: http://your-domain.com:8080/swagger-ui.html (待配置)

### 技术文档
- [Spring Boot 文档](https://spring.io/projects/spring-boot)
- [Vue.js 3 文档](https://vuejs.org/)
- [Docker 文档](https://docs.docker.com/)
- [MySQL 文档](https://dev.mysql.com/doc/)

---

## 💡 文档使用建议

### 首次接触项目
1. 先快速浏览 PRD.md 了解项目背景和目标
2. 查看 SDD.md 中的系统架构图，建立整体认知
3. 使用 USER_MANUAL.md 快速部署系统，亲身体验

### 开发阶段
1. PRD.md - 明确功能需求和优先级
2. SDD.md - 技术选型和架构设计的参考
3. USER_MANUAL.md - 测试和验证功能

### 运维阶段
1. USER_MANUAL.md - 部署、监控、故障排查
2. SDD.md - 理解系统架构，定位问题
3. 建立运维文档和监控告警

---

## 🤝 贡献指南

如需更新文档，请遵循以下规范：

1. **Markdown格式**: 使用标准Markdown语法
2. **Mermaid图表**: 使用Mermaid代码块绘制图表
3. **版本控制**: 更新版本号和变更历史
4. **代码示例**: 提供完整可运行的代码
5. **截图说明**: 使用ASCII艺术图或实际截图

### 文档更新流程
```bash
# 1. 创建分支
git checkout -b docs/update-xxx

# 2. 修改文档
# 编辑对应的.md文件

# 3. 提交更改
git add docs/
git commit -m "docs: Update xxx documentation"

# 4. 推送并创建PR
git push origin docs/update-xxx
```

---

## ❓ 获取帮助

### 文档相关问题
- 📧 Email: docs@smartwardrobe.com (示例)
- 💬 讨论区: GitHub Discussions

### 技术支持
- 🐛 Bug报告: [GitHub Issues](https://github.com/MrWeilaity/Wardrobe/issues)
- 💡 功能建议: [GitHub Discussions](https://github.com/MrWeilaity/Wardrobe/discussions)

---

## 📄 许可证

本项目文档遵循 MIT License。

---

## ⭐ 文档质量承诺

我们承诺提供：
- ✅ **完整性**: 涵盖项目全生命周期
- ✅ **准确性**: 与代码实现保持同步
- ✅ **实用性**: 提供可执行的脚本和示例
- ✅ **可维护性**: 结构清晰，易于更新
- ✅ **图文并茂**: Mermaid图表 + 文字说明

---

**文档维护团队**: 智衣橱技术团队  
**最后更新**: 2025-12-15  
**文档状态**: ✅ 已完成并经过审核  

---

*感谢您阅读智衣橱项目文档！如有任何问题或建议，欢迎反馈。*
