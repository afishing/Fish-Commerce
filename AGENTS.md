# Fish-Commerce 项目概述

基于 Spring Cloud Alibaba 的分布式电商系统。

- **Language**: Java 17
- **Build tool**: Maven 3.6+
- **Framework**: Spring Boot 3.3.4 + Spring Cloud 2023.0.3 + Spring Cloud Alibaba 2023.0.3.2
- **Testing Framework**: JUnit 5

## 项目架构

采用微服务架构，包含以下服务：

| 服务名 | 端口 | 职责 |
|--------|------|------|
| service-order | 8000 | 订单服务（订单创建、状态管理） |
| service-product | 9000 | 商品服务（商品信息、库存管理） |

## 项目结构
```
Fish-Commerce/ 
├── model/ # 公共实体模块 
├── service/ # 服务模块 
│ ├── service-order/ # 订单服务 
│ └── service-product/ # 商品服务 
└── pom.xml # 父 POM（Spring Cloud Alibaba 依赖管理）

```
## 依赖服务

- **Nacos 2.4.3**: 服务注册与配置中心 (http://127.0.0.1:8848)
- **MySQL 8.0**: 主数据库（待集成）
- **Redis 6.0**: 缓存（待集成）

## 常用命令

## 开发规范
- 
- 前端使用 Vue 3 + Element Plus
- 遵循阿里巴巴 Java 开发手册
- RESTful API 设计
- 数据库表名单数命名（如 `order` 而非 `orders`）
- 

## 待实现功能

- [ ] 用户服务（注册、登录）
- [ ] 购物车服务
- [ ] 支付服务
- [ ] API 网关（Spring Cloud Gateway）
- [ ] 分布式事务（Seata）



