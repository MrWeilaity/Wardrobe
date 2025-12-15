#!/bin/bash

# Smart Wardrobe 快速启动脚本

echo "========================================="
echo "Smart Wardrobe - 快速启动"
echo "========================================="
echo ""

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装"
    echo "请访问 https://docs.docker.com/get-docker/ 安装Docker"
    exit 1
fi

# 检查Docker Compose是否安装
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose 未安装"
    echo "请访问 https://docs.docker.com/compose/install/ 安装Docker Compose"
    exit 1
fi

echo "✅ Docker 和 Docker Compose 已安装"
echo ""

# 检查Docker是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker 守护进程未运行"
    echo "请启动Docker服务"
    exit 1
fi

echo "✅ Docker 服务正在运行"
echo ""

# 询问用户是否重新构建
read -p "是否重新构建镜像？(首次运行或代码更新后选择 y) [y/N]: " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "开始构建并启动服务..."
    docker compose up -d --build
else
    echo "启动服务（不重新构建）..."
    docker compose up -d
fi

# 等待服务启动
echo ""
echo "等待服务启动..."
sleep 5

# 检查服务状态
echo ""
echo "========================================="
echo "服务状态"
echo "========================================="
docker compose ps

# 等待后端健康检查
echo ""
echo "等待后端服务健康检查..."
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -sf http://localhost:8080/api/actuator/health > /dev/null 2>&1; then
        echo "✅ 后端服务已就绪"
        break
    fi
    RETRY_COUNT=$((RETRY_COUNT+1))
    echo "等待后端服务启动... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "⚠️  后端服务启动超时，请检查日志: docker compose logs backend"
fi

# 显示访问信息
echo ""
echo "========================================="
echo "✅ Smart Wardrobe 已启动"
echo "========================================="
echo ""
echo "访问地址:"
echo "  📱 前端界面: http://localhost"
echo "  🔧 后端API:  http://localhost:8080/api"
echo "  🗄️  MySQL:    localhost:3306"
echo ""
echo "默认登录信息:"
echo "  需要先注册账号，系统支持用户注册"
echo ""
echo "常用命令:"
echo "  查看日志:   docker compose logs -f"
echo "  停止服务:   docker compose down"
echo "  重启服务:   docker compose restart"
echo "  查看状态:   docker compose ps"
echo ""
echo "测试图片上传:"
echo "  运行测试:   ./test-image-access.sh"
echo ""
echo "完整文档: 查看 DOCKER_DEPLOYMENT.md"
echo "========================================="
