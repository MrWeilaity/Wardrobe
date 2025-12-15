# Smart Wardrobe - Docker 部署指南

本文档提供完整的Docker部署说明，包括本地开发环境和生产环境部署。

## 📋 前置要求

- Docker 20.10 或更高版本
- Docker Compose 2.0 或更高版本
- 至少 2GB 可用内存
- 至少 5GB 可用磁盘空间

### 安装 Docker 和 Docker Compose

#### Ubuntu/Debian
```bash
# 安装 Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 安装 Docker Compose
sudo apt-get update
sudo apt-get install docker-compose-plugin

# 验证安装
docker --version
docker compose version
```

#### CentOS/RHEL
```bash
# 安装 Docker
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 启动 Docker
sudo systemctl start docker
sudo systemctl enable docker

# 验证安装
docker --version
docker compose version
```

#### macOS
```bash
# 使用 Homebrew
brew install --cask docker

# 或下载 Docker Desktop
# https://www.docker.com/products/docker-desktop
```

#### Windows
下载并安装 Docker Desktop：
https://www.docker.com/products/docker-desktop

## 🚀 快速启动

### 1. 克隆或下载项目
```bash
git clone https://github.com/MrWeilaity/Wardrobe.git
cd Wardrobe
```

### 2. 启动所有服务
```bash
# 构建并启动所有服务（首次运行或代码更新后）
docker compose up -d --build

# 或者只启动服务（不重新构建）
docker compose up -d
```

### 3. 查看服务状态
```bash
# 查看所有容器状态
docker compose ps

# 查看日志
docker compose logs -f

# 查看特定服务的日志
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f mysql
```

### 4. 访问应用
- **前端界面**: http://localhost
- **后端API**: http://localhost:8080/api
- **MySQL数据库**: localhost:3306

## 📦 服务说明

### MySQL 数据库
- **镜像**: mysql:5.7
- **端口**: 3306
- **数据库名**: wardrobe
- **用户名**: root
- **密码**: root
- **数据持久化**: `mysql_data` volume

### 后端服务 (Spring Boot)
- **基础镜像**: openjdk:11-jre-slim
- **端口**: 8080
- **Context Path**: /api
- **上传文件存储**: `upload_data` volume (/app/uploads)
- **健康检查**: /api/actuator/health

### 前端服务 (Vue.js + Nginx)
- **基础镜像**: nginx:alpine
- **端口**: 80
- **反向代理**: /api/* -> backend:8080/api/*

## 🔧 配置说明

### 环境变量配置

可以通过修改 `docker-compose.yml` 中的环境变量来配置应用：

```yaml
backend:
  environment:
    # 数据库连接
    SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/wardrobe?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai
    SPRING_DATASOURCE_USERNAME: root
    SPRING_DATASOURCE_PASSWORD: root
    
    # JPA 配置
    SPRING_JPA_HIBERNATE_DDL_AUTO: update
    
    # 文件上传路径
    FILE_UPLOAD_PATH: /app/uploads/
    
    # JWT 密钥（生产环境务必修改）
    JWT_SECRET: your-secret-key-here
```

### 修改数据库密码

生产环境建议修改默认密码：

```yaml
mysql:
  environment:
    MYSQL_ROOT_PASSWORD: your-secure-password
    MYSQL_DATABASE: wardrobe
    MYSQL_USER: wardrobe_user
    MYSQL_PASSWORD: your-db-password

backend:
  environment:
    SPRING_DATASOURCE_USERNAME: wardrobe_user
    SPRING_DATASOURCE_PASSWORD: your-db-password
```

## 📝 常用命令

### 启动和停止

```bash
# 启动所有服务
docker compose up -d

# 停止所有服务
docker compose down

# 停止并删除所有数据（包括数据库数据）
docker compose down -v

# 重启特定服务
docker compose restart backend
```

### 查看日志

```bash
# 查看所有日志
docker compose logs

# 实时跟踪日志
docker compose logs -f

# 查看最近100行日志
docker compose logs --tail=100

# 查看特定服务日志
docker compose logs -f backend
```

### 进入容器

```bash
# 进入后端容器
docker compose exec backend bash

# 进入MySQL容器
docker compose exec mysql mysql -u root -p wardrobe

# 进入前端容器
docker compose exec frontend sh
```

### 数据备份和恢复

```bash
# 备份数据库
docker compose exec mysql mysqldump -u root -proot wardrobe > backup.sql

# 恢复数据库
docker compose exec -T mysql mysql -u root -proot wardrobe < backup.sql

# 备份上传的文件
docker compose cp backend:/app/uploads ./uploads_backup
```

## 🔍 故障排查

### 1. 服务启动失败

```bash
# 查看详细日志
docker compose logs backend

# 检查容器状态
docker compose ps

# 重新构建并启动
docker compose up -d --build --force-recreate
```

### 2. 数据库连接失败

```bash
# 检查MySQL是否启动
docker compose ps mysql

# 查看MySQL日志
docker compose logs mysql

# 测试数据库连接
docker compose exec mysql mysql -u root -proot -e "SELECT 1"
```

### 3. 前端无法访问后端API

```bash
# 检查nginx配置
docker compose exec frontend cat /etc/nginx/conf.d/default.conf

# 检查后端健康状态
curl http://localhost:8080/api/actuator/health

# 重启前端服务
docker compose restart frontend
```

### 4. 图片上传失败

```bash
# 检查上传目录权限
docker compose exec backend ls -la /app/uploads

# 查看后端日志中的错误
docker compose logs backend | grep -i upload

# 检查磁盘空间
docker compose exec backend df -h
```

### 5. 清理和重置

```bash
# 停止所有服务
docker compose down

# 删除所有容器和卷
docker compose down -v

# 删除所有镜像
docker compose down --rmi all

# 清理Docker系统
docker system prune -a --volumes
```

## 🌐 生产环境部署

### 1. 使用外部MySQL

```yaml
# 注释掉mysql服务
# mysql:
#   ...

backend:
  environment:
    SPRING_DATASOURCE_URL: jdbc:mysql://your-mysql-server:3306/wardrobe?useSSL=true&serverTimezone=Asia/Shanghai
    SPRING_DATASOURCE_USERNAME: your-username
    SPRING_DATASOURCE_PASSWORD: your-password
```

### 2. 使用HTTPS（需要配置SSL证书）

修改 `frontend/nginx.conf`：

```nginx
server {
    listen 443 ssl http2;
    server_name your-domain.com;
    
    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    
    # ... 其他配置
}

server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}
```

更新 `docker-compose.yml`：

```yaml
frontend:
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./ssl:/etc/nginx/ssl:ro
```

### 3. 性能优化

```yaml
backend:
  environment:
    JAVA_OPTS: "-Xms512m -Xmx1024m -XX:+UseG1GC"
  deploy:
    resources:
      limits:
        cpus: '1.0'
        memory: 1G
      reservations:
        cpus: '0.5'
        memory: 512M

mysql:
  command: --max-connections=200 --innodb-buffer-pool-size=256M
```

## 📊 监控和日志

### 日志配置

后端日志存储在容器的 `/app/logs/application.log`，可以挂载到宿主机：

```yaml
backend:
  volumes:
    - upload_data:/app/uploads
    - ./logs:/app/logs
```

### 健康检查

所有服务都配置了健康检查：

```bash
# 查看健康状态
docker compose ps

# 手动检查后端健康
curl http://localhost:8080/api/actuator/health
```

## 🔐 安全建议

1. **修改默认密码**: 修改MySQL root密码和JWT密钥
2. **使用环境变量文件**: 创建 `.env` 文件存储敏感信息
3. **启用HTTPS**: 生产环境使用SSL证书
4. **限制端口暴露**: 不要将MySQL端口暴露到公网
5. **定期备份**: 定期备份数据库和上传文件
6. **更新镜像**: 定期更新Docker镜像以修复安全漏洞

## 📱 示例：创建 .env 文件

```bash
# .env
MYSQL_ROOT_PASSWORD=your-secure-root-password
MYSQL_DATABASE=wardrobe
MYSQL_USER=wardrobe_user
MYSQL_PASSWORD=your-secure-db-password

JWT_SECRET=your-very-long-and-secure-jwt-secret-key-here

SPRING_PROFILES_ACTIVE=prod
```

然后在 `docker-compose.yml` 中使用：

```yaml
services:
  mysql:
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
  
  backend:
    environment:
      SPRING_DATASOURCE_USERNAME: ${MYSQL_USER}
      SPRING_DATASOURCE_PASSWORD: ${MYSQL_PASSWORD}
      JWT_SECRET: ${JWT_SECRET}
```

## 📞 技术支持

如有问题，请查看：
- GitHub Issues: https://github.com/MrWeilaity/Wardrobe/issues
- 项目文档: README.md

## 🎉 完成

现在您的Smart Wardrobe应用已经通过Docker成功部署！

访问 http://localhost 开始使用应用。

默认可以注册新用户或使用测试数据（如果已导入）。
