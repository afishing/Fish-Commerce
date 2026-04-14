# Fish-Commerce 🐟

基于 **Spring Cloud Alibaba** 的水产品垂直电商平台，采用前后端分离的微服务架构。

## 技术栈

### 后端

| 技术 | 版本 | 说明 |
|------|------|------|
| Java | 17 | 开发语言 |
| Spring Boot | 3.3.4 | 基础框架 |
| Spring Cloud | 2023.0.3 | 微服务框架 |
| Spring Cloud Alibaba | 2023.0.3.2 | 微服务增强组件 |
| Nacos | 2.4.3 | 服务注册与配置中心 |
| MyBatis-Plus | 3.5.5 | ORM 框架 |
| MySQL | 8.0 | 关系型数据库 |
| Redis | 6.0+ | 缓存与限流 |
| RabbitMQ | 3.x | 异步消息队列 |
| Sentinel | - | 熔断降级 |
| OpenFeign | - | 服务间调用 |
| Spring Boot Admin | 3.3.4 | 服务监控 |

### 前端

| 技术 | 版本 | 说明 |
|------|------|------|
| Vue | 3.5.29 | 前端框架 |
| Vue Router | 4.6.4 | 路由管理 |
| Element Plus | 2.13.5 | UI 组件库 |
| Axios | 1.7.0 | HTTP 请求 |
| Vite | 7.3.1 | 构建工具 |
| Marked | 17.0.5 | Markdown 渲染（AI 对话） |

## 项目结构

```
Fish-Commerce/
├── gateway/             # API 网关（端口 5000）
├── monitor/             # 系统监控（端口 8080，Spring Boot Admin）
├── model/               # 公共实体与 DTO 模块
├── service/
│   ├── service-user/    # 用户服务（端口 7000）
│   ├── service-product/ # 商品服务（端口 9000）
│   ├── service-order/   # 订单服务（端口 8000）
│   ├── service-cart/    # 购物车服务（端口 7500）
│   ├── service-pay/     # 支付服务（端口 8500）
│   ├── service-content/ # 内容服务（端口 9200）
│   └── service-ai/      # AI 智能服务（端口 9100，DeepSeek）
├── web-page/            # 前端项目（Vue 3）
├── sql/                 # 数据库脚本
├── uploads/             # 文件上传目录
└── pom.xml              # 父 POM
```

## 功能模块

| 模块 | 功能 |
|------|------|
| 用户体系 | 注册、登录、个人信息管理、收货地址管理、VIP 会员 |
| 商品体系 | 商品浏览、搜索、分类管理、标签管理、库存管理、上下架 |
| 订单体系 | 创建订单、支付、确认、发货、取消、查询 |
| 购物车 | 添加、修改数量、删除、批量操作、清空 |
| 支付体系 | 创建支付、支付确认、支付取消、支付查询 |
| 内容管理 | 公告管理、图库管理、视频管理 |
| AI 智能服务 | 智能对话、流式响应 |
| 系统监控 | 系统信息、内存监控、线程监控、CPU 监控 |
| 管理员后台 | 数据统计、用户/商品/订单管理、公告/图库/视频审核 |

## 数据库设计

数据库采用 MySQL 8.0，字符集 `utf8mb4`，按业务拆分为 8 个独立数据库：

### fish_user（用户库）

| 表名 | 说明 | 关键字段 |
|------|------|----------|
| `user` | 用户表 | username, password, nickname, email, phone, gender, avatar, birthday, level, vip_expire_time, status, role |
| `address` | 收货地址表 | user_id, receiver_name, receiver_phone, province, city, district, detail, is_default |
| `user_coupon` | 用户优惠券表 | user_id, coupon_id, status, receive_time, use_time, order_id |

### fish_product（商品库）

| 表名 | 说明 | 关键字段 |
|------|------|----------|
| `product` | 商品表 | name, description, category_id, price, original_price, stock, sales, main_image, specs, origin, weight, shelf_life, storage, status, detail_images, detail, is_banner, banner_sort |
| `category` | 商品分类表 | name, icon, sort, status |
| `tag` | 商品标签表 | name, color |
| `product_tag` | 商品标签关联表 | product_id, tag_id |
| `review` | 商品评论表 | product_id, user_id, username, rating, content |
| `specification` | 商品规格表 | name, value, sort_order |
| `spec_group` | 规格组表 | name, sort_order, status |
| `spec_value` | 规格值表 | group_id, value, sort_order |
| `coupon` | 优惠券表 | name, type, value, min_amount, total_count, received_count, limit_per_user, start_time, end_time, status, product_ids, member_levels |
| `gallery_image` | 图库图片表 | filename, original_name, url, size, mime_type, remark |
| `notice` | 公告表 | title, content, type, status, sort_order, start_time, end_time |

### fish_order（订单库）

| 表名 | 说明 | 关键字段 |
|------|------|----------|
| `order` | 订单表 | order_no, user_id, receiver_name, receiver_phone, receiver_address, total_amount, freight, pay_amount, pay_type, pay_time, status, remark |
| `order_item` | 订单明细表 | order_id, product_id, product_name, product_image, product_spec, price, quantity, total_amount |

### fish_cart（购物车库）

| 表名 | 说明 | 关键字段 |
|------|------|----------|
| `cart` | 购物车表 | user_id, product_id, product_name, product_image, product_spec, price, quantity, selected |

### fish_pay（支付库）

| 表名 | 说明 | 关键字段 |
|------|------|----------|
| `payment` | 支付记录表 | order_id, order_no, user_id, pay_amount, pay_type, status, transaction_no, pay_time |

### fish_content（内容库）

| 表名 | 说明 | 关键字段 |
|------|------|----------|
| `gallery_image` | 图库图片表 | filename, original_name, url, size, mime_type, remark |
| `notice` | 公告表 | title, content, type, status, sort_order, start_time, end_time |
| `video` | 视频表 | title, filename, original_name, url, size, duration, mime_type, description, cover_url |

### fish_marketing（营销库）

| 表名 | 说明 | 关键字段 |
|------|------|----------|
| `coupon` | 优惠券表 | name, type, value, min_amount, total_count, received_count, limit_per_user, start_time, end_time, status, product_ids |

### fish_video（视频库）

| 表名 | 说明 | 关键字段 |
|------|------|----------|
| `video` | 视频管理表 | title, filename, original_name, url, size, duration, mime_type, description, cover_url |

## 环境要求

- **JDK** 17+
- **Maven** 3.6+
- **Node.js** 20.19.0 或 22.12.0+
- **MySQL** 8.0+（字符集 utf8mb4）
- **Redis** 6.0+
- **RabbitMQ** 3.x
- **Nacos** 2.4.3

## 快速启动

### 1. 初始化数据库

```bash
mysql -u root -p < sql/init.sql
```

### 2. 启动基础设施

按以下顺序启动中间件：

1. **Nacos**（http://127.0.0.1:8848）
2. **MySQL**、**Redis**、**RabbitMQ**

### 3. 启动后端服务

按以下推荐顺序依次启动微服务：

```
service-user → service-product → service-order → service-cart
→ service-pay → service-content → service-ai → monitor → gateway
```

### 4. 启动前端

```bash
cd web-page
npm install
npm run dev
```

## 服务端口一览

| 服务 | 端口 |
|------|------|
| Gateway（API 网关） | 5000 |
| service-user | 7000 |
| service-cart | 7500 |
| service-order | 8000 |
| Monitor（系统监控） | 8080 |
| service-pay | 8500 |
| service-product | 9000 |
| service-ai | 9100 |
| service-content | 9200 |
| Nacos | 8848 |
| RabbitMQ | 5672 |
| Redis | 6379 |

## 开发规范

- 遵循阿里巴巴 Java 开发手册
- RESTful API 设计
- 数据库表名使用单数命名（如 `order` 而非 `orders`）
