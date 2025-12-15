#!/bin/bash

# 图片访问测试脚本
# 用于测试上传的图片是否能正确访问

echo "========================================="
echo "Smart Wardrobe - 图片访问功能测试"
echo "========================================="
echo ""

# 检查Docker是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker 未运行，请先启动 Docker"
    exit 1
fi

echo "✅ Docker 已运行"
echo ""

# 检查服务是否启动
echo "检查服务状态..."
docker compose ps
echo ""

# 检查后端服务
if docker compose ps | grep -q "wardrobe-backend.*Up"; then
    echo "✅ 后端服务已启动"
else
    echo "❌ 后端服务未启动，请运行: docker compose up -d"
    exit 1
fi

# 检查前端服务
if docker compose ps | grep -q "wardrobe-frontend.*Up"; then
    echo "✅ 前端服务已启动"
else
    echo "❌ 前端服务未启动，请运行: docker compose up -d"
    exit 1
fi

echo ""
echo "========================================="
echo "测试 1: 创建测试图片"
echo "========================================="

# 创建测试图片
TEST_IMAGE="test-$(date +%s).txt"
docker compose exec -T backend sh -c "echo 'This is a test image file' > /app/uploads/$TEST_IMAGE"

if [ $? -eq 0 ]; then
    echo "✅ 测试文件创建成功: $TEST_IMAGE"
else
    echo "❌ 测试文件创建失败"
    exit 1
fi

echo ""
echo "========================================="
echo "测试 2: 验证文件存在"
echo "========================================="

# 验证文件存在
docker compose exec backend ls -lh /app/uploads/$TEST_IMAGE

if [ $? -eq 0 ]; then
    echo "✅ 文件在后端容器中存在"
else
    echo "❌ 文件在后端容器中不存在"
    exit 1
fi

echo ""
echo "========================================="
echo "测试 3: 通过HTTP访问文件"
echo "========================================="

# 等待服务完全启动
sleep 2

# 测试通过后端API访问
BACKEND_URL="http://localhost:8080/api/uploads/$TEST_IMAGE"
echo "测试URL: $BACKEND_URL"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL")

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ 通过后端API访问成功 (HTTP $HTTP_CODE)"
    echo ""
    echo "文件内容:"
    curl -s "$BACKEND_URL"
    echo ""
else
    echo "❌ 通过后端API访问失败 (HTTP $HTTP_CODE)"
    echo ""
    echo "调试信息:"
    echo "后端日志:"
    docker compose logs --tail=20 backend
fi

echo ""
echo "========================================="
echo "测试 4: 通过前端代理访问"
echo "========================================="

# 测试通过前端nginx代理访问
FRONTEND_URL="http://localhost/api/uploads/$TEST_IMAGE"
echo "测试URL: $FRONTEND_URL"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$FRONTEND_URL")

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ 通过前端代理访问成功 (HTTP $HTTP_CODE)"
else
    echo "⚠️  通过前端代理访问失败 (HTTP $HTTP_CODE)"
    echo "注意: 如果后端直接访问成功，这可能是nginx配置问题"
fi

echo ""
echo "========================================="
echo "测试 5: 检查绝对路径配置"
echo "========================================="

# 检查后端配置
echo "检查后端使用的上传路径..."
docker compose exec backend sh -c "ls -ld /app/uploads/"

echo ""
echo "显示uploads目录中的所有文件:"
docker compose exec backend ls -lah /app/uploads/

echo ""
echo "========================================="
echo "测试完成"
echo "========================================="
echo ""
echo "总结:"
echo "- 后端API地址: http://localhost:8080/api/uploads/{filename}"
echo "- 前端代理地址: http://localhost/api/uploads/{filename}"
echo "- 上传目录: /app/uploads/ (容器内绝对路径)"
echo ""
echo "如需清理测试文件，运行:"
echo "docker compose exec backend rm /app/uploads/$TEST_IMAGE"
echo ""
