# Fish-Commerce Docker 一键构建部署脚本
# 用法: .\build.ps1 [build|up|down|restart|logs]

param(
    [Parameter(Position=0)]
    [ValidateSet("build", "up", "down", "restart", "logs", "clean")]
    [string]$Action = "build"
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Fish-Commerce Docker 部署工具" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

function Build-All {
    Write-Host "`n[1/3] Maven 构建所有 Java 模块..." -ForegroundColor Yellow
    mvn clean package -DskipTests -q
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Maven 构建失败!" -ForegroundColor Red
        exit 1
    }
    Write-Host "Maven 构建完成!" -ForegroundColor Green

    Write-Host "`n[2/3] 构建 Docker 镜像..." -ForegroundColor Yellow
    docker-compose build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Docker 镜像构建失败!" -ForegroundColor Red
        exit 1
    }
    Write-Host "Docker 镜像构建完成!" -ForegroundColor Green

    Write-Host "`n[3/3] 启动所有服务..." -ForegroundColor Yellow
    docker-compose up -d
    if ($LASTEXITCODE -ne 0) {
        Write-Host "服务启动失败!" -ForegroundColor Red
        exit 1
    }
    Write-Host "`n所有服务已启动!" -ForegroundColor Green
    Write-Host "前端访问: http://localhost" -ForegroundColor Cyan
    Write-Host "网关地址: http://localhost:5000" -ForegroundColor Cyan
    Write-Host "Nacos:    http://localhost:8848/nacos" -ForegroundColor Cyan
    Write-Host "RabbitMQ: http://localhost:15672" -ForegroundColor Cyan
}

function Start-Services {
    Write-Host "启动所有服务..." -ForegroundColor Yellow
    docker-compose up -d
    Write-Host "所有服务已启动!" -ForegroundColor Green
}

function Stop-Services {
    Write-Host "停止所有服务..." -ForegroundColor Yellow
    docker-compose down
    Write-Host "所有服务已停止!" -ForegroundColor Green
}

function Restart-Services {
    Write-Host "重启所有服务..." -ForegroundColor Yellow
    docker-compose down
    docker-compose up -d
    Write-Host "所有服务已重启!" -ForegroundColor Green
}

function Show-Logs {
    docker-compose logs -f --tail=100
}

function Clean-All {
    Write-Host "清理所有容器和镜像..." -ForegroundColor Yellow
    docker-compose down -v --rmi local
    Write-Host "清理完成!" -ForegroundColor Green
}

switch ($Action) {
    "build"   { Build-All }
    "up"      { Start-Services }
    "down"    { Stop-Services }
    "restart" { Restart-Services }
    "logs"    { Show-Logs }
    "clean"   { Clean-All }
}
