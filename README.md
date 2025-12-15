# 智衣橱 (Smart Wardrobe) - 个人数字化衣橱管理系统

一个简洁、实用的个人衣橱管理系统，采用前后端分离架构，具有优雅的女性化设计风格。

## 项目简介

智衣橱是一个帮助您管理个人衣物、规划穿搭、准备旅行行李的数字化工具。系统倡导"断舍离"理念，支持理性消费和低碳生活方式。

## 技术栈

### 后端
- **框架**: Spring Boot 2.7.18
- **数据库**: MySQL 5.7
- **安全**: Spring Security + JWT
- **ORM**: Spring Data JPA
- **语言**: Java 11

### 前端
- **框架**: Vue.js 3
- **路由**: Vue Router 4
- **HTTP客户端**: Axios
- **构建工具**: Vite
- **设计风格**: 女性化配色，柔和的玫瑰粉、暖色调

## 主要功能

### 1. 👗 我的衣橱
- 衣物录入：添加、编辑、删除衣物
- 智能筛选：按类别（上衣、裤装、裙装、外套、鞋履、配饰）和季节筛选
- 详细属性：记录颜色、品牌、价格、尺寸、材质等信息

### 2. 💃 穿搭方案
- 创建穿搭组合
- 按场合分类（日常、工作、约会、运动、正式、休闲）
- 记录穿搭备注和搭配灵感

### 3. ✈️ 旅行计划
- 创建旅行打包清单
- 设置目的地和旅行日期
- 选择旅行类型（度假休闲、商务出差、探险运动）
- 添加衣物到行李清单

## 设计特色

### 🎨 女性化配色方案
系统采用温柔、优雅的色彩搭配，营造舒适的使用体验：

- **主色调**: 柔和玫瑰粉 (#E8A0A0)
- **辅助色**: 淡粉色 (#F5C7C7)、柔和玫瑰灰 (#D4A5A5)
- **背景色**: 极淡粉白 (#FFF5F5)
- **文字色**: 温暖棕色 (#5A3A3A)

这些颜色**自然、柔和、不刺眼**，符合女性审美，远离"AI生成"的过度饱和感。

## 快速开始

### 环境要求
- Java 11+
- Node.js 16+
- Maven 3.6+
- **MySQL 5.7**

### 数据库准备

1. 安装 MySQL 5.7
2. 创建数据库：
```bash
mysql -u root -p
CREATE DATABASE wardrobe CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

或运行提供的脚本：
```bash
mysql -u root -p < backend/src/main/resources/schema.sql
```

详细配置说明：`backend/数据库配置说明.md`

### 启动后端

```bash
cd backend
mvn spring-boot:run
```

后端服务将在 `http://localhost:8080` 启动

### 启动前端

```bash
cd frontend
npm install
npm run dev
```

前端应用将在 `http://localhost:5173` 启动

## API 端点

### 认证
- `POST /api/auth/signup` - 用户注册
- `POST /api/auth/login` - 用户登录

### 衣物管理
- `GET /api/clothing` - 获取所有衣物
- `POST /api/clothing` - 添加衣物
- `PUT /api/clothing/{id}` - 更新衣物
- `DELETE /api/clothing/{id}` - 删除衣物
- `GET /api/clothing/category/{category}` - 按类别查询

### 穿搭方案
- `GET /api/outfits` - 获取所有穿搭
- `POST /api/outfits` - 创建穿搭
- `PUT /api/outfits/{id}` - 更新穿搭
- `DELETE /api/outfits/{id}` - 删除穿搭

### 旅行计划
- `GET /api/travel-plans` - 获取所有旅行计划
- `POST /api/travel-plans` - 创建旅行计划
- `PUT /api/travel-plans/{id}` - 更新旅行计划
- `DELETE /api/travel-plans/{id}` - 删除旅行计划

## 项目结构

```
Wardrobe/
├── backend/                 # Spring Boot 后端
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/wardrobe/
│   │   │   │   ├── model/          # 实体类
│   │   │   │   ├── repository/     # 数据访问层
│   │   │   │   ├── controller/     # 控制器
│   │   │   │   ├── security/       # 安全配置
│   │   │   │   ├── config/         # 配置类
│   │   │   │   └── dto/            # 数据传输对象
│   │   │   └── resources/
│   │   │       └── application.yml
│   │   └── test/
│   └── pom.xml
├── frontend/                # Vue.js 前端
│   ├── src/
│   │   ├── api/             # API 配置
│   │   ├── components/      # 组件
│   │   ├── router/          # 路由
│   │   ├── views/           # 页面
│   │   ├── App.vue
│   │   └── main.js
│   └── package.json
├── 项目需求分析书.md        # 详细需求文档
└── README.md
```

## 未来功能规划

- [ ] 图片上传功能
- [ ] Canvas 拖拽穿搭面板
- [ ] 天气API集成，智能推荐穿搭
- [ ] 数据统计和可视化
- [ ] 衣物使用频率分析
- [ ] 环保回收功能
- [ ] 移动端适配优化

## 作者

本项目基于《项目需求分析书》开发，旨在提供一个简洁实用的个人衣橱管理工具。

## 许可

MIT License
