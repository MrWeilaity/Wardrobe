# 相对路径配置说明

## 问题：为什么之前的相对路径不工作？

### 原始代码（有问题）
```java
registry.addResourceHandler("/uploads/**")
        .addResourceLocations("file:" + "uploads/");
```

### 问题分析

#### 1. Spring ResourceLoader 的协议要求
Spring 的 `ResourceLoader` 支持多种资源协议：
- `classpath:` - 从 classpath 加载资源
- `file:` - 从文件系统加载资源  
- `http:` / `https:` - 从网络加载资源

当使用 `file:` 协议时，Spring 期望：
- **绝对路径**：`file:/absolute/path/to/uploads/`
- **明确的相对路径**：`file:./relative/path/`

#### 2. 为什么 `file:uploads/` 不工作？

```java
// ❌ 错误：Spring 无法正确解析
"file:uploads/"

// 问题：
// 1. 没有 ./ 前缀，Spring 不知道从哪里开始解析
// 2. 不同环境下工作目录不同，导致行为不一致
// 3. Spring 的 ResourceLoader 可能将其视为无效路径
```

#### 3. 工作目录的不确定性

不同执行方式，工作目录不同：

| 执行方式 | 工作目录 | `uploads/` 解析为 |
|---------|---------|------------------|
| `mvn spring-boot:run` | `/path/to/backend` | `/path/to/backend/uploads/` |
| `java -jar app.jar` | 执行命令的目录 | 取决于在哪执行 |
| Docker | `/app` | `/app/uploads/` |
| IDE 运行 | 项目根目录 | 取决于IDE配置 |

## 解决方案：正确使用相对路径

### 方案一：使用 `file:./` 前缀（推荐）

```java
// ✅ 正确：明确相对于当前工作目录
String resourceLocation = "file:./uploads/";
registry.addResourceHandler("/uploads/**")
        .addResourceLocations(resourceLocation);
```

**优点**：
- 明确表示相对路径
- Spring 能正确解析
- 代码简洁清晰
- 支持不同环境

**工作原理**：
```
当前工作目录: /home/user/app
相对路径配置: file:./uploads/
实际解析为: /home/user/app/uploads/
```

### 方案二：转换为绝对路径

```java
// ✅ 正确：转换为绝对路径
File uploadDir = new File("uploads/");
String absolutePath = uploadDir.getAbsolutePath();
String resourceLocation = "file:" + absolutePath;
registry.addResourceHandler("/uploads/**")
        .addResourceLocations(resourceLocation);
```

**优点**：
- 绝对路径，Spring 总是能正确处理
- 路径明确，不会产生歧义
- 兼容性最好

**工作原理**：
```
相对路径: uploads/
转换后: /home/user/app/uploads/
配置为: file:/home/user/app/uploads/
```

## 当前实现：智能处理

```java
@Override
public void addResourceHandlers(ResourceHandlerRegistry registry) {
    String resourceLocation;
    
    if (uploadPath.startsWith("/") || uploadPath.matches("^[A-Za-z]:.*")) {
        // 已经是绝对路径（Linux: /xxx 或 Windows: C:\xxx）
        resourceLocation = "file:" + uploadPath;
    } else {
        // 相对路径：添加 file:./ 前缀
        String cleanPath = uploadPath.startsWith("./") ? uploadPath.substring(2) : uploadPath;
        resourceLocation = "file:./" + cleanPath;
    }
    
    // 确保以 / 结尾
    if (!resourceLocation.endsWith("/")) {
        resourceLocation += "/";
    }
    
    registry.addResourceHandler("/uploads/**")
            .addResourceLocations(resourceLocation);
}
```

### 智能处理的好处

1. **自动识别路径类型**
   ```yaml
   # 相对路径 - 自动添加 file:./ 前缀
   file.upload.path: uploads/
   # 结果: file:./uploads/
   
   # 绝对路径（Linux） - 直接使用
   file.upload.path: /var/app/uploads/
   # 结果: file:/var/app/uploads/
   
   # 绝对路径（Windows） - 直接使用
   file.upload.path: C:/app/uploads/
   # 结果: file:C:/app/uploads/
   ```

2. **兼容不同环境**
   - 开发环境：使用相对路径
   - Docker 环境：使用绝对路径
   - 生产环境：灵活配置

3. **调试友好**
   ```java
   System.out.println("Static file serving configured:");
   System.out.println("  Handler pattern: /uploads/**");
   System.out.println("  Resource location: " + resourceLocation);
   System.out.println("  Resolved to: " + Paths.get(uploadPath).toAbsolutePath());
   ```

## 配置示例

### 开发环境（使用相对路径）
```yaml
# application.yml
file:
  upload:
    path: uploads/  # 相对路径，自动解析为 file:./uploads/
```

### Docker 环境（使用绝对路径）
```yaml
# application-prod.yml
file:
  upload:
    path: /app/uploads/  # 绝对路径，使用 file:/app/uploads/
```

### Windows 环境（绝对路径）
```yaml
file:
  upload:
    path: C:/app/uploads/  # Windows 绝对路径
```

## 测试验证

### 测试 1：验证路径解析

```bash
# 启动应用后查看日志
====================================
Static file serving configured:
  Handler pattern: /uploads/**
  Resource location: file:./uploads/
  Resolved to: /home/runner/work/Wardrobe/Wardrobe/uploads
====================================
```

### 测试 2：上传并访问文件

```bash
# 1. 启动应用
mvn spring-boot:run

# 2. 上传文件
curl -F "file=@test.png" http://localhost:8080/api/upload/image

# 3. 获取返回的URL
{"url":"/api/uploads/xxx.png","filename":"xxx.png"}

# 4. 访问图片
curl http://localhost:8080/api/uploads/xxx.png
# 应该返回图片内容
```

### 测试 3：验证不同工作目录

```bash
# 从不同目录启动 jar
cd /tmp
java -jar /path/to/app.jar

# 查看日志确认路径
# Resolved to: /tmp/uploads （因为工作目录是 /tmp）
```

## 常见问题

### Q1: 为什么不能直接用 `file:uploads/`？
**A:** Spring 的 ResourceLoader 需要明确的路径指示。`file:./uploads/` 中的 `./` 明确表示"当前工作目录"，而 `file:uploads/` 没有明确的基准点，Spring 无法可靠地解析。

### Q2: `file:./uploads/` 和绝对路径有什么区别？
**A:** 
- `file:./uploads/` - 相对于**当前工作目录**，灵活但依赖启动位置
- `file:/app/uploads/` - 绝对路径，固定位置，不依赖工作目录

### Q3: Docker 中应该用哪种方式？
**A:** Docker 中推荐使用绝对路径（如 `/app/uploads/`），因为：
- 工作目录固定为 `/app`
- 路径明确，易于管理
- 挂载 volume 时更清晰

### Q4: 开发环境推荐哪种方式？
**A:** 开发环境可以使用相对路径（`uploads/`），代码会自动处理为 `file:./uploads/`，方便在不同开发者机器上使用。

## 总结

### 相对路径可以用吗？
**可以！** 但必须正确配置：

✅ **正确的相对路径配置**：
```java
// 方式 1：使用 file:./ 前缀
"file:./uploads/"

// 方式 2：转换为绝对路径
File f = new File("uploads/");
"file:" + f.getAbsolutePath()
```

❌ **错误的相对路径配置**：
```java
// 直接使用，Spring 可能无法解析
"file:uploads/"
```

### 最佳实践

1. **生产环境**：使用绝对路径，明确固定
   ```yaml
   file.upload.path: /app/uploads/
   ```

2. **开发环境**：使用相对路径，灵活方便
   ```yaml
   file.upload.path: uploads/
   ```

3. **代码实现**：智能处理两种情况
   ```java
   // 当前实现已经处理好了
   // 自动识别并添加正确的前缀
   ```

### 关键要点

- ✅ 相对路径**本身没有问题**
- ✅ 问题在于**如何让 Spring 正确解析**
- ✅ `file:./` 前缀是使用相对路径的**正确方式**
- ✅ 当前代码已经**自动处理**，两种方式都支持

---

**现在，相对路径可以正常工作了！** 🎉
