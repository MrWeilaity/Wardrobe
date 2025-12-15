# 管理功能说明

## 📋 新增功能概览

### 1. 基于角色的访问控制（RBAC）

#### 后端保护
所有管理员接口都添加了 `@PreAuthorize("hasRole('ADMIN')")` 注解：

```java
@RestController
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")  // 整个控制器需要管理员权限
public class AdminController {
    
    @GetMapping("/users")
    @PreAuthorize("hasRole('ADMIN')")  // 额外保护
    public ResponseEntity<List<UserResponse>> getAllUsers() {
        // ...
    }
}
```

#### 前端控制
- 登录时保存用户角色到 localStorage
- 导航栏根据角色显示/隐藏管理面板链接
- 路由守卫检查权限：

```javascript
// router/index.js
router.beforeEach((to, from, next) => {
  if (to.meta.requiresAdmin) {
    const user = JSON.parse(localStorage.getItem('user'))
    if (user.roles && user.roles.includes('ROLE_ADMIN')) {
      next()  // 管理员，允许访问
    } else {
      next('/')  // 非管理员，重定向首页
    }
  }
})
```

### 2. 用户管理功能

#### 功能列表

| 功能 | 描述 | 操作 |
|------|------|------|
| 查看用户列表 | 显示所有用户及其统计数据 | `GET /admin/users` |
| 查看用户详情 | 查看单个用户的详细信息 | `GET /admin/users/{id}/details` |
| 管理员权限切换 | 授予或移除 ROLE_ADMIN | `PUT /admin/users/{id}/role` |
| 删除用户 | 删除用户及其所有数据 | `DELETE /admin/users/{id}` |
| 查看用户衣物 | 查看特定用户的所有衣物 | `GET /admin/users/{id}/clothing` |

#### 用户表格显示信息

- ID
- 用户名
- 邮箱
- **角色标识**（管理员/用户）
- 注册时间
- 衣物数量
- 穿搭方案数
- 旅行计划数
- 操作按钮

#### 操作按钮

```
👁️  查看详情    - 打开用户详情模态框
⬆️⬇️ 切换权限   - 授予/移除管理员权限
🗑️  删除用户    - 删除用户及其所有数据
```

### 3. 衣物管理功能

#### 全局衣物查看

```javascript
// 查看系统中所有衣物
GET /admin/clothing

// 返回示例
[
  {
    "id": 1,
    "name": "白色衬衫",
    "category": "上衣",
    "color": "白色",
    "userId": 5,
    "imageUrl": "/api/uploads/xxx.png"
  },
  // ...
]
```

#### 衣物卡片显示

- 衣物图片/图标
- 名称
- 类别标签
- 颜色标签
- 所属用户ID

### 4. 统计仪表板

#### 4个核心指标卡片

```
┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│  👥         │ │  👔         │ │  💃         │ │  ✈️         │
│  总用户数   │ │  衣物总数   │ │  穿搭方案   │ │  旅行计划   │
│  125        │ │  1,234      │ │  456        │ │  78         │
└─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘
```

#### 3个数据图表

1. **衣物类别分布**（圆环图）
   - 上衣、裤装、裙装、外套、鞋履、配饰

2. **衣物颜色分布**（柱状图）
   - Top 10 颜色及其数量

3. **季节分布**（圆环图）
   - 春季、夏季、秋季、冬季

### 5. UI/UX 改进

#### 角色徽章

```css
.role-badge.admin {
  background-color: #FFE5E5;
  color: #C4A090;
}

.role-badge.user {
  background-color: #E8F4F8;
  color: #7A6F63;
}
```

显示效果：
- 🔴 **管理员** - 柔和红色背景
- 🔵 **用户** - 柔和蓝色背景

#### 模态框

**用户详情模态框**
```
┌─────────────────────────────────┐
│ 用户详细信息                  ✕ │
├─────────────────────────────────┤
│ 用户名：    zhangsan            │
│ 邮箱：      zhang@example.com   │
│ 注册时间：  2024-01-15          │
│ 衣物数量：  45                  │
│ 穿搭方案：  12                  │
│ 旅行计划：  3                   │
│                                 │
│ [查看该用户的所有衣物]          │
└─────────────────────────────────┘
```

**衣物列表模态框**
```
┌─────────────────────────────────────────────┐
│ 用户衣物列表                              ✕ │
├─────────────────────────────────────────────┤
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐   │
│  │ 👔   │  │ 👕   │  │ 👖   │  │ 👗   │   │
│  │白衬衫│  │T恤   │  │牛仔裤│  │连衣裙│   │
│  │上衣  │  │上衣  │  │裤装  │  │裙装  │   │
│  └──────┘  └──────┘  └──────┘  └──────┘   │
│                                             │
│  更多衣物...                                │
└─────────────────────────────────────────────┘
```

#### 响应式布局

**桌面端**：
- 统计卡片：4列网格
- 图表：3列网格
- 衣物网格：自适应列数

**移动端（≤ 768px）**：
- 统计卡片：2列网格
- 图表：1列堆叠
- 衣物网格：2列
- 操作按钮：自动换行

## 🔐 安全机制

### 多层防护

```
用户请求
   ↓
前端路由守卫 (检查本地角色)
   ↓
JWT Token (包含角色信息)
   ↓
Spring Security (验证token)
   ↓
@PreAuthorize (验证角色权限)
   ↓
执行业务逻辑
```

### 防护层级

1. **前端层**
   - 隐藏管理面板链接
   - 路由守卫阻止访问
   - 提供用户体验优化

2. **网络层**
   - JWT Token 携带角色信息
   - 每次请求都验证

3. **后端层**
   - Spring Security 验证 JWT
   - @PreAuthorize 验证角色
   - 即使前端被绕过也无法访问

## 📊 数据流程

### 用户登录流程

```
1. 用户登录
   POST /auth/login
   { username, password }

2. 后端验证并返回
   {
     token: "jwt-token",
     id: 1,
     username: "admin",
     email: "admin@example.com",
     roles: ["ROLE_USER", "ROLE_ADMIN"]  ← 包含角色
   }

3. 前端存储
   localStorage.setItem('token', response.data.token)
   localStorage.setItem('user', JSON.stringify({
     id: response.data.id,
     username: response.data.username,
     email: response.data.email,
     roles: response.data.roles  ← 存储角色
   }))

4. 导航栏更新
   isAdmin = user.roles.includes('ROLE_ADMIN')
   显示/隐藏管理面板链接
```

### 角色切换流程

```
1. 管理员点击"⬆️"按钮
   
2. 确认对话框
   "确定要授予 zhangsan 管理员权限吗？"

3. 发送请求
   PUT /admin/users/{userId}/role
   {
     action: "add",
     role: "ROLE_ADMIN"
   }

4. 后端更新数据库
   user.roles.add("ROLE_ADMIN")
   userRepository.save(user)

5. 前端刷新用户列表
   重新加载所有用户
   徽章自动更新为"管理员"
```

## 🎯 使用场景

### 场景1：创建新管理员

1. 用户自行注册账号（默认为 ROLE_USER）
2. 现有管理员登录系统
3. 进入"管理面板"
4. 在用户列表中找到该用户
5. 点击"⬆️"按钮授予管理员权限
6. 确认操作
7. 该用户下次登录时将拥有管理员权限

### 场景2：查看用户详情

1. 管理员进入管理面板
2. 在用户列表中点击"👁️"按钮
3. 弹出模态框显示详细信息
4. 点击"查看该用户的所有衣物"
5. 打开新模态框显示衣物网格
6. 可以查看每件衣物的图片和详情

### 场景3：系统监控

1. 管理员进入管理面板
2. 顶部统计卡片显示核心指标
3. 下方图表显示数据分布
4. 点击"刷新衣物列表"查看最新数据
5. 滚动查看所有用户信息
6. 发现异常用户可以直接操作

## 🚀 未来扩展

### 计划中的功能

- [ ] 用户活跃度统计
- [ ] 操作日志记录
- [ ] 批量用户管理
- [ ] 数据导出功能
- [ ] 高级搜索和筛选
- [ ] 用户行为分析
- [ ] 系统健康监控
- [ ] 备份和恢复功能

### 可能的优化

- [ ] 分页加载大量数据
- [ ] 虚拟滚动优化性能
- [ ] 实时数据更新（WebSocket）
- [ ] 更丰富的图表类型
- [ ] 自定义仪表板
- [ ] 数据导出（CSV/Excel）
- [ ] 权限细粒度控制

## 📝 技术细节

### 后端技术栈

- Spring Security - 认证和授权
- @PreAuthorize - 方法级权限控制
- JPA - 数据持久化
- JWT - 无状态认证

### 前端技术栈

- Vue.js 3 - 响应式框架
- Vue Router - 路由管理
- Axios - HTTP客户端
- Chart.js - 数据可视化
- 本地存储 - 角色缓存

### 数据模型

```java
@Entity
class User {
    Long id;
    String username;
    String email;
    String password;
    Set<String> roles;  // ["ROLE_USER", "ROLE_ADMIN"]
    LocalDateTime createdAt;
}
```

### API端点总结

| 方法 | 端点 | 描述 | 权限 |
|------|------|------|------|
| GET | /admin/users | 获取所有用户 | ADMIN |
| GET | /admin/users/{id}/details | 获取用户详情 | ADMIN |
| PUT | /admin/users/{id}/role | 更新用户角色 | ADMIN |
| DELETE | /admin/users/{id} | 删除用户 | ADMIN |
| GET | /admin/stats | 获取系统统计 | ADMIN |
| GET | /admin/clothing | 获取所有衣物 | ADMIN |
| GET | /admin/users/{id}/clothing | 获取用户衣物 | ADMIN |

---

## ✅ 总结

通过这次更新，管理功能从"仅删除用户"扩展到：

1. ✅ **完整的角色权限控制**
2. ✅ **丰富的用户管理功能**
3. ✅ **全局衣物查看**
4. ✅ **详细的数据统计**
5. ✅ **友好的用户界面**
6. ✅ **多层安全防护**

现在管理员可以有效地管理整个系统，而普通用户完全无法访问管理功能！🎉
