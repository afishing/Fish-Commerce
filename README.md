# 🐟 Fish-Commerce — 飞鱼商城

> 基于 Spring Cloud Alibaba 的分布式水产品垂直电商系统，采用前后端分离微服务架构。

## 📖 项目简介

Fish-Commerce（飞鱼商城）是一个面向渔业/水产品领域的垂直电商平台，提供从商品浏览、购物车、下单支付到后台管理的完整电商功能，并集成了 AI 智能对话与系统监控模块。

## 🏗️ 系统架构

```
                          ┌──────────────┐
                          │   前端应用    │
                          │  Vue 3 SPA   │
                          └──────┬───────┘
                                 │
                          ┌──────▼───────┐
                          │  API Gateway │
                          │   Port:5000  │
                          └──────┬───────┘
                                 │
              ┌──────────────────┼──────────────────┐
              │                  │                   │
     ┌────────▼──┐     ┌────────▼──┐      ┌────────▼──┐
     │  Nacos    │     │ RabbitMQ  │      │   Redis   │
     │  :8848   │     │  :5672    │      │  :6379    │
     └───────────┘     └───────────┘      └───────────┘
              │
    ┌─────────┼─────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
    │         │         │          │          │          │          │          │
┌───▼──┐ ┌───▼──┐ ┌────▼──┐ ┌────▼──┐ ┌────▼──┐ ┌────▼───┐ ┌───▼───┐ ┌────▼───┐
│ User │ │Product│ │ Order │ │ Cart  │ │  Pay  │ │Content │ │  AI   │ │Monitor │
│:7000 │ │:9000  │ │:8000  │ │:7500  │ │:8500  │ │ :9200  │ │:9100  │ │ :8080  │
└──────┘ └───────┘ └───────┘ └───────┘ └───────┘ └────────┘ └───────┘ └────────┘
```

## 🛠️ 技术栈

### 后端

| 技术 | 版本 | 说明 |
|------|------|------|
| Java | 17 | 开发语言 |
| Spring Boot | 3.3.4 | 基础应用框架 |
| Spring Cloud | 2023.0.3 | 微服务治理 |
| Spring Cloud Alibaba | 2023.0.3.2 | 阿里系微服务集成 |
| Spring Cloud Gateway | — | API 网关、路由、限流 |
| MyBatis-Plus | 3.5.5 | ORM 持久层框架 |
| MySQL | 8.0.33 | 关系型数据库 |
| Redis | 6.0+ | 缓存与限流 |
| RabbitMQ | — | 消息队列（异步支付/订单） |
| Nacos | 2.4.3 | 服务注册与配置中心 |
| OpenFeign | — | 服务间远程调用 |
| Spring Boot Admin | 3.3.4 | 系统监控 |
| Sentinel | — | 流量控制与熔断降级 |
| Lombok | — | 简化代码 |
| DeepSeek API | — | AI 智能对话 |

### 前端

| 技术 | 版本 | 说明 |
|------|------|------|
| Vue | 3.5.29 | 前端框架 |
| Vue Router | 4.6.4 | 路由管理 |
| Element Plus | 2.13.5 | UI 组件库 |
| Axios | 1.7.0 | HTTP 客户端 |
| Vite | 7.3.1 | 前端构建工具 |
| Marked | 17.0.5 | Markdown 渲染（AI 对话） |

## 📁 项目结构

```
Fish-Commerce/
├── gateway/                    # API 网关（Spring Cloud Gateway）
│   └── src/main/
│       ├── java/.../filter/    # 认证过滤器（AuthFilter）
│       └── resources/          # 路由配置
├── monitor/                    # 系统监控（Spring Boot Admin）
│   └── src/main/
│       ├── java/.../           # 监控控制器与配置
│       └── resources/          # 监控配置
├── model/                      # 公共模型模块
│   └── src/main/java/com/afishing/
│       ├── common/             # 通用组件
│       │   ├── result/         # 统一返回结果（Result, PageResult）
│       │   ├── exception/      # 全局异常处理
│       │   ├── config/         # 通用配置
│       │   └── handler/        # 通用处理器
│       ├── dto/                # 数据传输对象（14个 DTO）
│       └── entity/             # 数据库实体类（14个 Entity）
├── service/                    # 业务服务模块
│   ├── service-user/           # 用户服务 :7000
│   ├── service-product/        # 商品服务 :9000
│   ├── service-order/          # 订单服务 :8000
│   ├── service-cart/           # 购物车服务 :7500
│   ├── service-pay/            # 支付服务 :8500
│   ├── service-content/        # 内容管理服务 :9200
│   └── service-ai/             # AI 智能服务 :9100
├── web-page/                   # 前端应用（Vue 3 + Vite）
│   └── src/
│       ├── api/                # API 接口模块（14个）
│       ├── views/              # 页面组件（25个）
│       ├── router/             # 路由配置
│       └── components/         # 公共组件
├── sql/                        # 数据库脚本
│   ├── init.sql                # 初始化脚本（含测试数据）
│   └── ...                     # 增量变更脚本
├── uploads/                    # 文件上传目录
└── pom.xml                     # Maven 父 POM
```

## 🔧 微服务模块说明

### Gateway — API 网关 (Port: 5000)

统一入口，负责请求路由、跨域处理、认证鉴权和流量控制。

| 路由规则 | 目标服务 |
|----------|----------|
| `/api/auth/**`, `/api/user/**` | service-user |
| `/api/admin/**` | service-user |
| `/api/address/**` | service-user |
| `/api/product/**` | service-product |
| `/api/category/**`, `/api/tag/**` | service-product |
| `/api/order/**` | service-order |
| `/api/cart/**` | service-cart |
| `/api/payment/**` | service-pay |
| `/api/video/**`, `/api/gallery/**`, `/api/notice/**` | service-content |
| `/api/ai/**` | service-ai |
| `/api/monitor/**` | monitor |
| `/uploads/**` | service-product（静态资源） |

### service-user — 用户服务 (Port: 7000)

- 用户注册与登录认证
- 个人信息管理（昵称、头像、邮箱、手机等）
- 收货地址管理（增删改查、默认地址）
- 管理员后台登录
- VIP 会员等级

### service-product — 商品服务 (Port: 9000)

- 商品信息 CRUD（名称、价格、库存、产地、规格等）
- 商品分类管理
- 商品标签管理
- 图库管理（图片上传/删除）
- 商品上下架与库存管理
- 销量统计
- 静态资源访问

### service-order — 订单服务 (Port: 8000)

- 订单创建与查询
- 订单状态流转（待付款 → 待发货 → 待收货 → 已完成）
- 发货操作 / 确认收货 / 取消订单
- RabbitMQ 异步消息处理
- Redis 缓存

### service-cart — 购物车服务 (Port: 7500)

- 商品加入购物车
- 购物车商品数量修改
- 批量删除 / 选中状态切换
- 调用商品服务获取最新商品信息

### service-pay — 支付服务 (Port: 8500)

- 支付流程处理
- 支付状态管理
- 交易流水记录
- RabbitMQ 异步支付回调
- OpenFeign 调用订单/用户服务

### service-content — 内容管理服务 (Port: 9200)

- 视频管理（上传/列表/删除）
- 图库管理（图片上传/批量删除）
- 公告管理（发布/编辑/删除）
- 支持大文件上传（最大 100MB）

### service-ai — AI 智能服务 (Port: 9100)

- AI 对话服务（集成 DeepSeek API）
- 流式响应输出
- 智能推荐

### Monitor — 系统监控 (Port: 8080)

- 基于 Spring Boot Admin 的应用监控
- 各服务健康检查
- 性能指标采集
- Actuator 端点暴露

## 🗄️ 数据库设计

数据库采用 MySQL 8.0，字符集 `utf8mb4`，包含以下核心表：

| 表名 | 说明 | 关键字段 |
|------|------|----------|
| `user` | 用户表 | username, password, nickname, email, phone, gender, avatar, birthday, level, status |
| `product` | 商品表 | name, category_id, price, original_price, stock, sales, specs, origin, weight, shelf_life |
| `order` | 订单表 | order_no, user_id, receiver_name/phone/address, total_amount, pay_type, status |
| `order_item` | 订单明细表 | order_id, product_id, product_name, price, quantity, total_amount |
| `cart` | 购物车表 | user_id, product_id, quantity, selected |
| `payment` | 支付记录表 | order_id, order_no, pay_amount, pay_type, status, transaction_no |
| `address` | 收货地址表 | user_id, receiver_name/phone, province, city, district, detail, is_default |
| `product_category` | 商品分类表 | — |
| `product_tag` | 商品标签表 | — |
| `review` | 商品评价表 | — |
| `video` | 视频表 | — |
| `gallery_image` | 图库图片表 | — |
| `notice` | 公告表 | — |

> 所有表均包含 `create_time`、`update_time`、`deleted`（逻辑删除）字段。

## 🌐 前端页面

### 用户端

| 页面 | 路由 | 功能 |
|------|------|------|
| 首页 | `/` | 商品推荐、分类展示 |
| 登录 | `/login` | 用户登录 |
| 注册 | `/register` | 用户注册 |
| 商品列表 | `/products` | 商品搜索、分类筛选 |
| 商品详情 | `/products/:id` | 商品信息、规格选择、加入购物车 |
| 购物车 | `/cart` | 购物车管理、结算 |
| 订单列表 | `/orders` | 订单查询、支付、确认收货 |
| 个人中心 | `/profile` | 个人信息、地址管理 |

### 管理端

| 页面 | 路由 | 功能 |
|------|------|------|
| 管理员登录 | `/admin/login` | 管理员认证 |
| 仪表板 | `/admin/dashboard` | 数据统计概览 |
| 用户管理 | `/admin/users` | 用户列表、状态管理 |
| 订单管理 | `/admin/orders` | 订单处理、发货 |
| 商品管理 | `/admin/products` | 商品 CRUD |
| 库存管理 | `/admin/stock` | 库存调整 |
| 分类管理 | `/admin/categories` | 商品分类 CRUD |
| 标签管理 | `/admin/tags` | 商品标签 CRUD |
| 图库管理 | `/admin/gallery` | 图片上传管理 |
| 视频管理 | `/admin/video` | 视频上传管理 |
| 公告管理 | `/admin/notice` | 公告发布管理 |
| 评价管理 | `/admin/reviews` | 用户评价审核 |
| 系统监控 | `/admin/monitor` | 服务健康监控 |

## 🚀 快速开始

### 环境要求

- **JDK** 17+
- **Maven** 3.6+
- **Node.js** 20.19.0 或 22.12.0+
- **MySQL** 8.0+
- **Redis** 6.0+
- **RabbitMQ** 3.x
- **Nacos** 2.4.3

### 1. 初始化数据库

```bash
# 执行初始化脚本
mysql -u root -p < sql/init.sql

# 执行增量变更脚本（按顺序）
mysql -u root -p fish_commerce < sql/alter_user_add_role.sql
mysql -u root -p fish_commerce < sql/alter_user_add_birthday.sql
mysql -u root -p fish_commerce < sql/add_category_tag_tables.sql
mysql -u root -p fish_commerce < sql/add_tag_tables.sql
mysql -u root -p fish_commerce < sql/create_review_table.sql
# ... 其他增量脚本
```

### 2. 启动基础设施

```bash
# 启动 Nacos（单机模式）
sh nacos/bin/startup.sh -m standalone

# 启动 MySQL（确保 3306 端口运行）

# 启动 Redis（确保 6379 端口运行）

# 启动 RabbitMQ（确保 5672 端口运行）
```

### 3. 启动后端服务

```bash
# 编译项目
mvn clean install -DskipTests

# 按顺序启动各微服务（可在 IDE 中分别启动）
# 1. service-user    (7000)
# 2. service-product (9000)
# 3. service-order   (8000)
# 4. service-cart    (7500)
# 5. service-pay     (8500)
# 6. service-content (9200)
# 7. service-ai      (9100)
# 8. monitor         (8080)
# 9. gateway         (5000)
```

### 4. 启动前端

```bash
cd web-page

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

### 5. 访问系统

| 地址 | 说明 |
|------|------|
| http://localhost:5173 | 前端应用 |
| http://localhost:5000 | API 网关 |
| http://localhost:8080 | 系统监控 |
| http://localhost:8848/nacos | Nacos 控制台 |

## 📋 服务端口总览

| 服务 | 端口 | 数据库 |
|------|------|--------|
| Gateway | 5000 | — |
| service-user | 7000 | fish_user |
| service-cart | 7500 | fish_cart |
| service-order | 8000 | fish_order |
| Monitor | 8080 | — |
| service-pay | 8500 | fish_pay |
| service-product | 9000 | fish_product |
| service-ai | 9100 | — |
| service-content | 9200 | fish_content |

## 📡 服务间通信

- **Nacos**：所有微服务注册到 `127.0.0.1:8848`，实现服务发现与配置管理
- **OpenFeign**：`service-user`、`service-pay` 通过 Feign 客户端进行同步远程调用
- **RabbitMQ**：`service-order` 与 `service-pay` 通过消息队列实现异步通信
- **Redis**：`service-order` 与 `gateway` 使用 Redis 进行缓存和限流

## 📝 开发规范

- 遵循 [阿里巴巴 Java 开发手册](https://github.com/alibaba/p3c)
- RESTful API 设计风格
- 数据库表名使用**单数命名**（如 `order` 而非 `orders`）
- 前端使用 Vue 3 Composition API + Element Plus
- 全局统一返回格式 `Result<T>`
- 逻辑删除代替物理删除

## 📄 License

本项目仅供学习交流使用。
