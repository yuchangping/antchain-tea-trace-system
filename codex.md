下面这份内容你可以直接保存成 `CODEX_茶叶溯源开发流程.md`，然后发给 VSCode 里的 Codex 插件，让它按文档从 0 开始搭建项目。

````md
# Codex 开发任务说明：基于区块链的茶叶全流程溯源系统

## 1. 你的角色

你现在是一个全栈开发代理，请从 0 开始创建一个**可运行、可演示、适合作为课程项目提交**的全栈项目：

**项目名称：基于区块链的茶叶全流程溯源系统设计与实现**

请严格按照本文档的步骤开发，不要擅自更换技术栈，不要过度设计，不要一次性加入太多复杂功能。先完成 MVP，再逐步完善。

---

## 2. 项目目标

实现一个完整的茶叶溯源系统，分为四层：

- **前端展示层**
  - 管理后台网页
  - 消费者扫码查询页
  - 功能包括：登录、批次创建、环节信息录入、图片/文件上传、二维码生成、溯源查询、链上信息展示

- **后端服务层**
  - 提供 REST API
  - 负责用户认证、权限校验、业务数据处理、二维码生成、文件上传、调用区块链接口

- **区块链层**
  - 使用本地以太坊开发链
  - 保存关键溯源摘要信息
  - 保存：批次号、环节类型、操作人、时间戳、数据哈希、交易哈希、区块号

- **数据库 / 文件存储层**
  - MySQL 保存详细业务数据
  - 本地目录保存图片和检测报告
  - 不将大文件上链，只将摘要哈希上链

---

## 3. 业务范围

本项目聚焦茶叶全流程溯源，包含以下 6 个环节：

1. 茶叶批次创建
2. 采摘信息录入
3. 加工信息录入
4. 检测信息录入
5. 包装入库信息录入
6. 物流信息录入
7. 销售上架信息录入
8. 消费者扫码查询

### 系统角色

- 管理员
- 生产方 / 茶园
- 加工厂
- 检测机构
- 物流方
- 销售方
- 消费者

### MVP 要求

先做最小可用版本，必须具备：

- 用户登录
- 批次创建
- 批次列表
- 批次详情
- 溯源环节记录新增
- 文件上传
- 二维码生成
- 消费者扫码查询页
- 区块链上链
- 交易哈希展示

---

## 4. 固定技术栈

请不要擅自修改技术栈：

### 前端
- `Vue 3`
- `Vite`
- `Vue Router`
- `Pinia`
- `Element Plus`
- `Axios`

### 后端
- `Node.js`
- `Express`
- `mysql2`
- `jsonwebtoken`
- `bcryptjs`
- `multer`
- `qrcode`
- `ethers`
- `cors`
- `dotenv`

### 区块链
- `Solidity`
- `Hardhat`
- `ethers`
- 本地开发链使用 `Ganache`

### 数据库
- `MySQL`

### 约束
- 全部使用 `JavaScript`
- 不使用 TypeScript
- 后端尽量使用原生 SQL，不使用 ORM
- 前端使用中文界面
- 优先保证可运行、可演示、代码清晰
- 不要做微服务
- 不要使用 Docker
- 不要接入复杂权限系统，只做基于角色的简单控制

---

## 5. 项目总目录结构

如果当前工作区为空，请直接创建以下目录结构：

```text
tea-trace-system/
├─ README.md
├─ .gitignore
├─ docs/
│  ├─ architecture.md
│  ├─ api.md
│  ├─ database.md
│  └─ demo-script.md
├─ backend/
│  ├─ package.json
│  ├─ .env.example
│  ├─ app.js
│  ├─ server.js
│  ├─ config/
│  │  ├─ db.js
│  │  ├─ blockchain.js
│  │  └─ multer.js
│  ├─ middleware/
│  │  ├─ auth.js
│  │  └─ errorHandler.js
│  ├─ utils/
│  │  ├─ response.js
│  │  ├─ hash.js
│  │  ├─ qrcode.js
│  │  └─ constants.js
│  ├─ routes/
│  │  ├─ auth.routes.js
│  │  ├─ batch.routes.js
│  │  ├─ trace.routes.js
│  │  ├─ upload.routes.js
│  │  ├─ public.routes.js
│  │  ├─ dashboard.routes.js
│  │  └─ blockchain.routes.js
│  ├─ controllers/
│  │  ├─ auth.controller.js
│  │  ├─ batch.controller.js
│  │  ├─ trace.controller.js
│  │  ├─ upload.controller.js
│  │  ├─ public.controller.js
│  │  ├─ dashboard.controller.js
│  │  └─ blockchain.controller.js
│  ├─ services/
│  │  ├─ auth.service.js
│  │  ├─ batch.service.js
│  │  ├─ trace.service.js
│  │  ├─ upload.service.js
│  │  ├─ blockchain.service.js
│  │  └─ dashboard.service.js
│  ├─ models/
│  │  ├─ user.model.js
│  │  ├─ batch.model.js
│  │  ├─ trace.model.js
│  │  └─ file.model.js
│  ├─ sql/
│  │  ├─ schema.sql
│  │  └─ seed.sql
│  └─ uploads/
│     └─ .gitkeep
├─ blockchain/
│  ├─ package.json
│  ├─ .env.example
│  ├─ hardhat.config.js
│  ├─ contracts/
│  │  └─ TeaTraceability.sol
│  ├─ scripts/
│  │  └─ deploy.js
│  └─ artifacts/
├─ frontend/
│  ├─ package.json
│  ├─ .env.example
│  ├─ index.html
│  ├─ vite.config.js
│  └─ src/
│     ├─ main.js
│     ├─ App.vue
│     ├─ style.css
│     ├─ router/
│     │  └─ index.js
│     ├─ stores/
│     │  └─ user.js
│     ├─ api/
│     │  ├─ request.js
│     │  ├─ auth.js
│     │  ├─ batch.js
│     │  ├─ trace.js
│     │  ├─ upload.js
│     │  ├─ public.js
│     │  ├─ dashboard.js
│     │  └─ blockchain.js
│     ├─ layout/
│     │  └─ AdminLayout.vue
│     ├─ components/
│     │  ├─ PageHeader.vue
│     │  ├─ StatCard.vue
│     │  ├─ ChainStatusTag.vue
│     │  ├─ TraceTimeline.vue
│     │  ├─ QrPreviewDialog.vue
│     │  └─ FileUploader.vue
│     ├─ views/
│     │  ├─ Login.vue
│     │  ├─ Dashboard.vue
│     │  ├─ NotFound.vue
│     │  ├─ batch/
│     │  │  ├─ BatchList.vue
│     │  │  ├─ BatchCreate.vue
│     │  │  └─ BatchDetail.vue
│     │  ├─ trace/
│     │  │  └─ TraceCreate.vue
│     │  ├─ blockchain/
│     │  │  └─ ChainRecordList.vue
│     │  └─ public/
│     │     └─ TraceQuery.vue
````

---

## 6. 开发原则

请严格遵守：

1. 先搭骨架，再写细节
2. 先后端和数据库跑通，再接区块链
3. 先完成后台管理端，再做消费者查询页
4. 所有接口统一返回格式：

   * `code`
   * `message`
   * `data`
5. 所有时间字段统一返回 `YYYY-MM-DD HH:mm:ss`
6. 所有上传文件先保存到本地 `backend/uploads`
7. 所有区块链写入操作由后端统一发起
8. 不让前端直接操作区块链
9. 数据采用“链下存详情、链上存摘要”的模式
10. 代码尽量模块化，但不要过度抽象

---

## 7. 阶段划分总览

请按以下顺序开发，不要跳步：

### 阶段 1：初始化项目骨架

### 阶段 2：设计并创建数据库

### 阶段 3：编写智能合约并部署本地链

### 阶段 4：实现后端基础能力

### 阶段 5：实现后端业务接口

### 阶段 6：实现区块链集成

### 阶段 7：实现前端管理后台

### 阶段 8：实现消费者扫码查询页

### 阶段 9：联调与演示数据

### 阶段 10：补充文档

每完成一个阶段后，请先自查，再继续下一个阶段。

---

## 8. 阶段 1：初始化项目骨架

### 8.1 创建根目录和基础文件

在工作区中创建：

* `tea-trace-system/`
* `README.md`
* `.gitignore`

### 8.2 `.gitignore` 内容应包含

* `node_modules/`
* `.env`
* `dist/`
* `uploads/`
* `artifacts/`
* `cache/`
* `.DS_Store`

### 8.3 根目录 `README.md` 需要包含

* 项目简介
* 技术栈
* 目录结构
* 运行方式
* 演示流程

### 8.4 创建 `docs/` 目录及文档文件

新建：

* `docs/architecture.md`
* `docs/api.md`
* `docs/database.md`
* `docs/demo-script.md`

这些文档先写骨架标题，后续逐步完善。

---

## 9. 阶段 2：数据库设计

### 9.1 数据表设计原则

为了降低复杂度，采用如下核心表：

1. `users`
2. `tea_batches`
3. `trace_records`
4. `file_infos`

不再拆分过多业务子表，所有环节统一进 `trace_records` 表，通过 `stage_type` 区分。

### 9.2 表结构要求

#### 表 1：`users`

字段建议：

* `id` bigint 主键自增
* `username` varchar(50) 唯一
* `password` varchar(255)
* `role` varchar(30)
* `real_name` varchar(50)
* `company_name` varchar(100)
* `status` tinyint 默认 1
* `created_at` datetime
* `updated_at` datetime

#### 表 2：`tea_batches`

字段建议：

* `id` bigint 主键自增
* `batch_no` varchar(64) 唯一
* `tea_name` varchar(100)
* `tea_type` varchar(100)
* `origin` varchar(255)
* `plantation_name` varchar(100)
* `description` text
* `cover_image` varchar(255)
* `qr_code_url` varchar(255)
* `batch_hash` varchar(128)
* `tx_hash` varchar(128)
* `block_number` bigint
* `chain_status` varchar(20)
* `created_by` bigint
* `created_at` datetime
* `updated_at` datetime

#### 表 3：`trace_records`

字段建议：

* `id` bigint 主键自增
* `batch_no` varchar(64)
* `stage_type` varchar(30)
* `title` varchar(100)
* `content` text
* `detail_json` longtext
* `operator_name` varchar(50)
* `operate_time` datetime
* `attachment_url` varchar(255)
* `data_hash` varchar(128)
* `tx_hash` varchar(128)
* `block_number` bigint
* `chain_status` varchar(20)
* `created_by` bigint
* `created_at` datetime
* `updated_at` datetime

#### 表 4：`file_infos`

字段建议：

* `id` bigint 主键自增
* `ref_type` varchar(30)
* `ref_id` bigint
* `file_name` varchar(255)
* `file_url` varchar(255)
* `file_hash` varchar(128)
* `file_type` varchar(50)
* `created_by` bigint
* `created_at` datetime

### 9.3 `stage_type` 固定枚举

必须统一为以下值：

* `harvest` 采摘
* `process` 加工
* `inspection` 检测
* `package` 包装入库
* `logistics` 物流运输
* `sale` 销售上架

### 9.4 新建 SQL 文件

创建：

* `backend/sql/schema.sql`
* `backend/sql/seed.sql`

### 9.5 `schema.sql` 要完成的内容

* 创建数据库（如需要）
* 创建 4 张表
* 建立必要索引
* 保证 `batch_no` 可快速查询
* 给 `trace_records(batch_no, stage_type)` 建联合索引

### 9.6 `seed.sql` 要完成的内容

插入初始用户，至少包括：

* 管理员
* 生产方
* 物流方
* 销售方

默认密码统一先写死为演示密码，但要通过 `bcrypt` 加密后插入。

---

## 10. 阶段 3：区块链合约开发

### 10.1 新建 `blockchain/` 工程

在 `blockchain/` 下初始化 Hardhat 项目。

### 10.2 创建以下文件

* `blockchain/package.json`
* `blockchain/.env.example`
* `blockchain/hardhat.config.js`
* `blockchain/contracts/TeaTraceability.sol`
* `blockchain/scripts/deploy.js`

### 10.3 合约功能要求

合约名固定为：

* `TeaTraceability`

合约应支持：

1. 创建批次上链
2. 新增环节记录上链
3. 查询某批次记录数量
4. 查询某批次的某条链上记录
5. 通过事件返回交易结果

### 10.4 合约数据结构建议

#### 批次结构体

* `batchNo`
* `batchHash`
* `createdAt`
* `creator`
* `exists`

#### 溯源记录结构体

* `stageType`
* `dataHash`
* `operatorName`
* `operateTime`

### 10.5 合约必须包含的函数

* `createBatch(string batchNo, bytes32 batchHash)`
* `addTraceRecord(string batchNo, string stageType, bytes32 dataHash, string operatorName, uint256 operateTime)`
* `getTraceCount(string batchNo)`
* `getTraceRecord(string batchNo, uint256 index)`

### 10.6 合约事件

必须定义：

* `BatchCreated`
* `TraceRecordAdded`

### 10.7 部署脚本要求

`deploy.js` 完成后需要：

* 部署合约
* 在控制台输出合约地址
* 提示用户把合约地址填入后端环境变量

### 10.8 区块链环境变量

`blockchain/.env.example` 包含：

* `RPC_URL`
* `PRIVATE_KEY`

---

## 11. 阶段 4：后端基础能力开发

### 11.1 初始化 `backend/`

创建：

* `backend/package.json`
* `backend/.env.example`
* `backend/app.js`
* `backend/server.js`

### 11.2 后端依赖

需要安装的核心依赖：

* `express`
* `mysql2`
* `cors`
* `dotenv`
* `jsonwebtoken`
* `bcryptjs`
* `multer`
* `qrcode`
* `ethers`
* `dayjs`

### 11.3 后端环境变量

`backend/.env.example` 包含：

* `PORT=3000`
* `DB_HOST=127.0.0.1`
* `DB_PORT=3306`
* `DB_NAME=tea_trace`
* `DB_USER=root`
* `DB_PASSWORD=123456`
* `JWT_SECRET=tea_trace_secret`
* `UPLOAD_DIR=uploads`
* `SERVER_BASE_URL=http://localhost:3000`
* `FRONTEND_TRACE_URL=http://localhost:5173/#/trace`
* `CHAIN_RPC_URL=http://127.0.0.1:7545`
* `CHAIN_PRIVATE_KEY=`
* `CHAIN_CONTRACT_ADDRESS=`
* `CHAIN_ID=1337`

### 11.4 创建以下配置文件

#### `backend/config/db.js`

负责：

* 创建 MySQL 连接池
* 导出查询方法

#### `backend/config/blockchain.js`

负责：

* 创建 `ethers` provider
* 创建 wallet
* 创建合约实例
* 暴露合约调用方法

#### `backend/config/multer.js`

负责：

* 配置上传目录
* 文件命名规则
* 导出上传中间件

### 11.5 创建中间件

#### `backend/middleware/auth.js`

负责：

* 解析 JWT
* 验证登录状态
* 将用户信息注入 `req.user`

#### `backend/middleware/errorHandler.js`

负责：

* 统一错误响应
* 避免接口直接崩溃

### 11.6 创建工具类

#### `backend/utils/response.js`

统一返回格式：

```json
{
  "code": 0,
  "message": "success",
  "data": {}
}
```

#### `backend/utils/hash.js`

负责：

* 根据对象生成固定格式 JSON
* 再生成 `sha256` 哈希

#### `backend/utils/qrcode.js`

负责：

* 根据批次号生成二维码图片
* 二维码内容指向前端公开查询地址

#### `backend/utils/constants.js`

存放：

* 角色常量
* 环节类型常量
* 链状态常量

---

## 12. 阶段 5：后端业务开发

### 12.1 后端整体架构要求

按照 `route -> controller -> service -> model` 的结构实现。

### 12.2 创建模型文件

#### `backend/models/user.model.js`

负责：

* 按用户名查询用户
* 根据 ID 查询用户信息

#### `backend/models/batch.model.js`

负责：

* 创建批次
* 查询批次列表
* 按 `id` 查询批次
* 按 `batch_no` 查询批次
* 更新批次二维码、链信息

#### `backend/models/trace.model.js`

负责：

* 新增溯源记录
* 按批次号查询全部记录
* 查询单条记录
* 更新链信息

#### `backend/models/file.model.js`

负责：

* 保存文件元数据
* 根据关联信息查询文件

### 12.3 创建服务文件

#### `backend/services/auth.service.js`

负责：

* 登录校验
* 密码比对
* 生成 JWT

#### `backend/services/batch.service.js`

负责：

* 创建茶叶批次
* 生成批次哈希
* 调用区块链创建批次
* 生成二维码
* 保存链信息和二维码路径

#### `backend/services/trace.service.js`

负责：

* 新增环节记录
* 校验 `stage_type`
* 生成记录哈希
* 调用区块链上链
* 保存交易哈希和区块号

#### `backend/services/upload.service.js`

负责：

* 保存上传文件
* 计算文件哈希
* 记录文件元数据

#### `backend/services/blockchain.service.js`

负责：

* 封装合约调用
* `createBatchOnChain`
* `addTraceOnChain`
* `getTraceCountOnChain`

#### `backend/services/dashboard.service.js`

负责：

* 首页统计数据
* 最近新增记录
* 已上链数量统计

### 12.4 创建控制器文件

#### `backend/controllers/auth.controller.js`

接口：

* 登录
* 获取当前用户

#### `backend/controllers/batch.controller.js`

接口：

* 创建批次
* 分页查询批次
* 查询批次详情

#### `backend/controllers/trace.controller.js`

接口：

* 新增溯源记录
* 查询某批次全部溯源记录
* 查询单条记录

#### `backend/controllers/upload.controller.js`

接口：

* 上传文件

#### `backend/controllers/public.controller.js`

接口：

* 对外公开查询某批次的完整溯源信息

#### `backend/controllers/dashboard.controller.js`

接口：

* 首页统计

#### `backend/controllers/blockchain.controller.js`

接口：

* 查询某批次链上摘要信息
* 校验某条记录链上哈希

### 12.5 创建路由文件

#### `backend/routes/auth.routes.js`

接口：

* `POST /api/auth/login`
* `GET /api/auth/profile`

#### `backend/routes/batch.routes.js`

接口：

* `POST /api/batches`
* `GET /api/batches`
* `GET /api/batches/:id`

#### `backend/routes/trace.routes.js`

接口：

* `POST /api/traces`
* `GET /api/batches/:batchNo/traces`
* `GET /api/traces/:id`

#### `backend/routes/upload.routes.js`

接口：

* `POST /api/upload`

#### `backend/routes/public.routes.js`

接口：

* `GET /api/public/trace/:batchNo`

#### `backend/routes/dashboard.routes.js`

接口：

* `GET /api/dashboard/summary`

#### `backend/routes/blockchain.routes.js`

接口：

* `GET /api/blockchain/batch/:batchNo`
* `GET /api/blockchain/trace/:id/verify`

---

## 13. 后端接口字段要求

### 13.1 登录接口

`POST /api/auth/login`

请求体：

```json
{
  "username": "admin",
  "password": "123456"
}
```

返回：

```json
{
  "code": 0,
  "message": "登录成功",
  "data": {
    "token": "jwt-token",
    "userInfo": {
      "id": 1,
      "username": "admin",
      "role": "admin",
      "realName": "管理员"
    }
  }
}
```

### 13.2 创建批次接口

`POST /api/batches`

请求体：

```json
{
  "batchNo": "TEA20250001",
  "teaName": "西湖龙井",
  "teaType": "绿茶",
  "origin": "浙江杭州",
  "plantationName": "龙井一号茶园",
  "description": "2025 年春茶头采"
}
```

业务逻辑必须包含：

1. 参数校验
2. 判断批次号是否重复
3. 写入数据库
4. 生成批次哈希
5. 写入区块链
6. 生成二维码
7. 更新数据库中的 `tx_hash`、`block_number`、`chain_status`、`qr_code_url`

### 13.3 新增溯源记录接口

`POST /api/traces`

请求体：

```json
{
  "batchNo": "TEA20250001",
  "stageType": "harvest",
  "title": "春茶采摘完成",
  "content": "完成第一批春茶采摘",
  "operatorName": "张三",
  "operateTime": "2025-03-25 08:30:00",
  "detailJson": {
    "gardenName": "龙井一号茶园",
    "weather": "晴",
    "pickerName": "张三",
    "remark": "采摘嫩芽"
  },
  "attachmentUrl": "/uploads/xxx.jpg"
}
```

业务逻辑必须包含：

1. 校验批次是否存在
2. 校验 `stageType` 是否合法
3. 存数据库
4. 生成 `data_hash`
5. 调用合约 `addTraceRecord`
6. 保存 `tx_hash`、`block_number`、`chain_status`

### 13.4 对外查询接口

`GET /api/public/trace/:batchNo`

返回内容必须包含：

* 批次基本信息
* 全部环节记录
* 二维码地址
* 批次上链信息
* 每条环节记录的上链信息

---

## 14. `detailJson` 结构要求

为了方便前端动态渲染，不同环节的 `detailJson` 请采用以下结构：

### `harvest`

```json
{
  "gardenName": "龙井一号茶园",
  "weather": "晴",
  "pickerName": "张三",
  "pickTime": "2025-03-25 08:30:00",
  "remark": "采摘嫩芽"
}
```

### `process`

```json
{
  "factoryName": "杭州绿茶加工厂",
  "processType": "杀青、揉捻、烘干",
  "temperature": "80℃",
  "duration": "30分钟",
  "managerName": "李四",
  "remark": "工艺正常"
}
```

### `inspection`

```json
{
  "agencyName": "杭州市茶叶检测中心",
  "reportNo": "JC20250001",
  "result": "合格",
  "conclusion": "符合出厂标准",
  "remark": "农残合格"
}
```

### `package`

```json
{
  "packageSpec": "250g/盒",
  "warehouseName": "杭州一号仓",
  "warehouseLocation": "A区3排",
  "packageTime": "2025-03-27 10:00:00",
  "remark": "已入库"
}
```

### `logistics`

```json
{
  "companyName": "顺丰速运",
  "trackingNo": "SF123456789",
  "departure": "杭州",
  "destination": "上海",
  "shipTime": "2025-03-28 09:00:00",
  "receiveTime": "2025-03-29 12:00:00",
  "status": "已签收"
}
```

### `sale`

```json
{
  "storeName": "上海徐汇旗舰店",
  "salesArea": "华东地区",
  "shelfTime": "2025-03-30 09:30:00",
  "remark": "已上架销售"
}
```

---

## 15. 阶段 6：区块链集成细则

### 15.1 上链原则

* 详细数据存在 MySQL
* 链上只存哈希摘要和最小必要字段
* 所有写链操作由后端完成

### 15.2 哈希生成规则

后端需要将关键字段组装为固定顺序对象，再进行 JSON 序列化，再进行 `sha256` 计算。

### 15.3 批次哈希字段

批次哈希至少包含：

* `batchNo`
* `teaName`
* `teaType`
* `origin`
* `plantationName`

### 15.4 溯源记录哈希字段

记录哈希至少包含：

* `batchNo`
* `stageType`
* `title`
* `content`
* `operatorName`
* `operateTime`
* `detailJson`

### 15.5 链状态字段约定

统一使用以下值：

* `pending`
* `success`
* `failed`

### 15.6 上链异常处理

如果链上调用失败：

* 数据库记录仍然保留
* `chain_status` 标记为 `failed`
* 返回给前端提示“业务保存成功，但上链失败”

不要因为链上失败导致整个业务数据丢失。

---

## 16. 阶段 7：前端开发

### 16.1 初始化前端项目

在 `frontend/` 下创建 Vue3 + Vite 项目。

### 16.2 前端依赖

需要：

* `vue`
* `vue-router`
* `pinia`
* `axios`
* `element-plus`
* `@element-plus/icons-vue`

### 16.3 前端环境变量

`frontend/.env.example`

```env
VITE_API_BASE_URL=http://localhost:3000/api
VITE_SERVER_BASE_URL=http://localhost:3000
```

### 16.4 路由模式

使用 `hash` 路由，避免部署时服务端额外配置。

### 16.5 必须创建的前端文件

#### `frontend/src/main.js`

负责：

* 挂载 Vue
* 引入 Element Plus
* 引入 Pinia
* 引入 Router

#### `frontend/src/App.vue`

负责：

* 路由出口

#### `frontend/src/router/index.js`

定义路由：

* `/login`
* `/`
* `/dashboard`
* `/batches`
* `/batches/create`
* `/batches/:id`
* `/traces/create`
* `/blockchain/records`
* `/trace/:batchNo`
* `/:pathMatch(.*)*`

#### `frontend/src/stores/user.js`

负责：

* 保存 token
* 保存用户信息
* 登录、退出登录

#### `frontend/src/api/request.js`

负责：

* 封装 axios
* 注入 token
* 统一响应拦截

#### 其他 `api/` 文件

分别封装各模块接口。

---

## 17. 前端页面开发要求

### 17.1 `Login.vue`

功能：

* 用户名密码登录
* 登录成功跳转首页

### 17.2 `AdminLayout.vue`

功能：

* 左侧菜单
* 顶部栏
* 用户信息
* 退出登录

菜单包含：

* 首页
* 批次管理
* 新增批次
* 新增溯源记录
* 链上记录

### 17.3 `Dashboard.vue`

展示：

* 批次数量
* 溯源记录数量
* 已上链记录数量
* 最近新增记录

### 17.4 `views/batch/BatchList.vue`

功能：

* 表格展示批次
* 按批次号搜索
* 查看详情
* 查看二维码

### 17.5 `views/batch/BatchCreate.vue`

功能：

* 创建茶叶批次表单
* 提交后跳转详情页

字段：

* 批次号
* 茶叶名称
* 茶类
* 产地
* 茶园名称
* 描述

### 17.6 `views/batch/BatchDetail.vue`

功能：

* 展示批次基础信息
* 展示二维码
* 展示链上状态
* 展示全部溯源记录时间轴
* 提供“新增环节记录”按钮

### 17.7 `views/trace/TraceCreate.vue`

功能：

* 根据 `stageType` 选择不同环节
* 动态展示表单
* 支持上传图片/检测报告
* 提交后写入数据库并上链

### 17.8 `views/blockchain/ChainRecordList.vue`

功能：

* 列出已有链上记录
* 展示：

  * 批次号
  * 环节类型
  * 交易哈希
  * 区块号
  * 链状态

### 17.9 `views/public/TraceQuery.vue`

这是最重要的手机端页面，必须：

* 移动端友好
* 顶部展示茶叶基础信息
* 中间展示完整时间轴
* 底部展示链上凭证信息
* 展示二维码对应的批次号
* 样式简洁，适合演示

### 17.10 `views/NotFound.vue`

简单 404 页面。

---

## 18. 前端组件要求

### `PageHeader.vue`

通用页头组件。

### `StatCard.vue`

仪表盘统计卡片。

### `ChainStatusTag.vue`

用于展示：

* 已上链
* 上链中
* 上链失败

### `TraceTimeline.vue`

用于展示时间轴记录。

### `QrPreviewDialog.vue`

用于弹窗展示二维码图片。

### `FileUploader.vue`

封装文件上传组件，上传后返回文件地址。

---

## 19. 前端页面交互要求

### 批次列表页

* 支持点击查看详情
* 支持弹窗查看二维码
* 支持查看链状态

### 批次详情页

* 以卡片 + 时间轴展示
* 显示批次链上交易哈希
* 若某条记录上链失败，明显标红

### 新增记录页

* 第一步选择批次
* 第二步选择环节类型
* 第三步填写动态表单
* 第四步上传附件
* 第五步提交

### 对外查询页

* 只读
* 不显示后台编辑功能
* 支持直接通过 URL 中的 `batchNo` 查询

---

## 20. 阶段 8：二维码与公开查询

### 20.1 二维码规则

每创建一个批次后，后端自动生成二维码图片。

二维码内容为：

```text
http://localhost:5173/#/trace/{batchNo}
```

### 20.2 二维码保存位置

建议保存在：

* `backend/uploads/qrcode/`

并把相对访问地址保存到 `tea_batches.qr_code_url`

### 20.3 公开查询页逻辑

前端访问：

* `/#/trace/TEA20250001`

然后调用后端：

* `GET /api/public/trace/TEA20250001`

---

## 21. 阶段 9：联调与演示数据

### 21.1 必须准备的演示数据

至少准备 1 个完整批次：

* 西湖龙井
* 批次号：`TEA20250001`

该批次需要完整 6 条记录：

1. 采摘
2. 加工
3. 检测
4. 包装
5. 物流
6. 销售

### 21.2 每条记录要有真实展示内容

例如：

* 采摘：茶园图片
* 检测：检测报告图片或 PDF
* 物流：物流单号
* 销售：门店信息

### 21.3 联调重点

必须验证：

* 登录成功
* 创建批次成功
* 新增记录成功
* 文件上传成功
* 上链成功
* 能看到 `tx_hash`
* 扫码页能显示全部流程

---

## 22. 阶段 10：文档补充

### `docs/architecture.md`

应包含：

* 四层架构图
* 链上链下数据划分
* 模块说明

### `docs/api.md`

应包含：

* 主要接口列表
* 请求参数
* 返回参数
* 示例 JSON

### `docs/database.md`

应包含：

* 表结构说明
* 字段说明
* 索引说明

### `docs/demo-script.md`

应包含：

* 上课演示步骤
* 演示账号
* 演示批次号
* 讲解词提纲

---

## 23. 代码实现顺序要求

请严格按以下顺序写代码：

### 第一步

创建项目目录结构和空文件

### 第二步

编写 `backend/sql/schema.sql` 和 `seed.sql`

### 第三步

实现后端基础框架：

* `app.js`
* `server.js`
* `db.js`
* `response.js`
* `auth.js`

### 第四步

实现登录接口：

* `auth.model`
* `auth.service`
* `auth.controller`
* `auth.routes`

### 第五步

实现批次模块：

* `batch.model`
* `batch.service`
* `batch.controller`
* `batch.routes`

### 第六步

实现上传模块：

* `multer.js`
* `upload.service`
* `upload.controller`
* `upload.routes`

### 第七步

实现区块链工程：

* 合约
* 部署脚本
* 部署成功后回填地址到后端

### 第八步

实现溯源记录模块：

* `trace.model`
* `trace.service`
* `trace.controller`
* `trace.routes`

### 第九步

实现公开查询和仪表盘接口：

* `public.controller`
* `dashboard.controller`
* 路由

### 第十步

实现前端基础工程：

* `main.js`
* `router`
* `store`
* `request.js`
* `layout`

### 第十一步

实现前端登录页和后台框架

### 第十二步

实现批次页面

### 第十三步

实现新增溯源记录页面

### 第十四步

实现消费者查询页

### 第十五步

实现链记录列表页与二维码弹窗

### 第十六步

补充 README 和 docs 文档

---

## 24. 关键文件的实现说明

下面这些文件是重点，请优先认真实现。

### 后端重点文件

#### `backend/app.js`

职责：

* 创建 express 实例
* 注册中间件
* 注册静态目录 `/uploads`
* 注册所有路由
* 注册全局错误处理中间件

#### `backend/server.js`

职责：

* 读取环境变量
* 启动服务

#### `backend/services/batch.service.js`

职责：

* 创建批次
* 调区块链
* 生成二维码
* 保证即使上链失败也能创建批次

#### `backend/services/trace.service.js`

职责：

* 统一处理所有环节记录
* 通过 `stageType` 区分业务
* 上链失败也保留数据库数据

#### `backend/utils/hash.js`

职责：

* 固定 JSON 字段排序
* 生成可重复的哈希结果

#### `backend/config/blockchain.js`

职责：

* 读取 ABI 和合约地址
* 创建合约实例
* 供 service 调用

### 前端重点文件

#### `frontend/src/views/batch/BatchDetail.vue`

必须展示：

* 茶叶信息
* 区块链信息
* 时间轴
* 附件
* 二维码

#### `frontend/src/views/trace/TraceCreate.vue`

必须支持：

* 环节类型切换
* 动态表单
* 提交校验
* 附件上传

#### `frontend/src/views/public/TraceQuery.vue`

必须优先保证演示效果：

* 页面好看
* 手机端正常
* 信息清晰
* 时间轴直观

---

## 25. API 返回格式统一要求

所有成功返回：

```json
{
  "code": 0,
  "message": "success",
  "data": {}
}
```

所有失败返回：

```json
{
  "code": 1,
  "message": "错误信息",
  "data": null
}
```

分页接口建议返回：

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "list": [],
    "total": 0,
    "page": 1,
    "pageSize": 10
  }
}
```

---

## 26. UI 风格要求

前端风格要求：

* 管理后台：简洁企业风格
* 消费者查询页：卡片 + 时间轴
* 主色调建议：

  * 绿色
  * 白色
  * 浅灰
* 页面中文化
* 不要过度花哨
* 适合课堂演示

---

## 27. 完成标准

当以下条件全部满足时，项目算完成：

* 能登录后台
* 能创建茶叶批次
* 能新增不同环节的溯源记录
* 能上传图片或报告
* 批次创建时自动生成二维码
* 扫码页能显示完整信息
* 能看到区块链交易哈希
* 至少 1 个完整批次具备 6 条环节记录
* 文档齐全
* 项目可以本地启动并演示

---

## 28. 你开发时的注意事项

1. 不要一次性把所有页面写完再调试
2. 每完成一个模块就要保证能跑
3. 前后端字段命名保持一致
4. `batchNo` 一律作为外部查询主键
5. `detailJson` 一律存 JSON 字符串
6. 文件上传后返回标准 URL
7. 区块链异常必须捕获
8. 页面必须有基础表单校验
9. 所有列表都按时间倒序展示
10. 对外查询页不需要登录

---

## 29. 建议你给用户的默认演示账号

请在 `seed.sql` 中准备：

### 管理员

* 用户名：`admin`
* 密码：`123456`

### 生产方

* 用户名：`farmer`
* 密码：`123456`

### 物流方

* 用户名：`logistics`
* 密码：`123456`

### 销售方

* 用户名：`seller`
* 密码：`123456`

---

## 30. 如果需要分阶段执行，请按以下 8 次任务推进

### 任务 1

先创建完整目录结构、空文件、README、docs 文档骨架和 `.env.example` 文件。

### 任务 2

实现数据库设计，写好 `schema.sql` 和 `seed.sql`。

### 任务 3

实现后端基础框架、登录接口、JWT 鉴权、统一响应结构。

### 任务 4

实现批次创建、批次列表、批次详情、二维码生成功能。

### 任务 5

实现区块链合约、部署脚本，并接入后端区块链服务。

### 任务 6

实现溯源记录新增、记录查询、公开查询接口。

### 任务 7

实现前端后台：登录、首页、批次列表、新增批次、批次详情、新增记录。

### 任务 8

实现前端公开查询页、链记录展示页、演示数据与文档补充。

---

## 31. 对 Codex 的最后要求

请你现在开始按本文档执行开发任务，要求：

* 优先生成项目骨架
* 再逐步写实现代码
* 每完成一个阶段后进行自检
* 保持代码结构清晰
* 不要跳过文档中的目录和文件
* 不要擅自更换技术栈
* 不要删除任何关键模块
* 以“可运行、可演示、适合作业提交”为第一目标

```

如果你愿意，我下一条可以继续直接给你两份能马上喂给 Codex 的内容：
- `第一阶段初始化提示词`
- `第二阶段后端+数据库代码生成提示词`

这样你就可以分阶段让插件直接开始写。
```
