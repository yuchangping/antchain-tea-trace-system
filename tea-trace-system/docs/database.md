# 数据库设计文档

## 1. 文档目标

本文件用于固化阶段 2 的数据库设计结果，确保后续后端接口、前端展示、二维码查询和链上哈希都围绕同一套字段命名与数据结构展开。

## 2. 阶段 2 设计结论

- 核心表固定为 `users`、`tea_batches`、`trace_records`、`file_infos`
- 对外查询批次统一使用 `batch_no`
- 所有业务环节统一写入 `trace_records`
- 详细业务数据存 MySQL，链上只存摘要哈希与最小必要信息
- `schema.sql` 支持重复执行，`seed.sql` 支持重复插入演示账户

## 3. 命名与枚举约定

### 3.1 命名约定

- 数据库字段统一使用下划线风格
- 批次主标识统一使用 `batch_no`
- 溯源环节类型统一使用 `stage_type`
- 链状态统一使用 `chain_status`
- 时间字段统一使用 `created_at`、`updated_at`、`operate_time`

### 3.2 固定枚举值

#### `stage_type`

- `harvest`：采摘
- `process`：加工
- `inspection`：检测
- `package`：包装入库
- `logistics`：物流运输
- `sale`：销售上架

#### `chain_status`

- `pending`：待上链或待确认
- `success`：上链成功
- `failed`：上链失败

#### `file_infos.ref_type`

- `batch`：批次附件
- `trace`：溯源记录附件

## 4. 表关系

- `users -> tea_batches`：一个用户可以创建多个批次
- `users -> trace_records`：一个用户可以录入多条溯源记录
- `users -> file_infos`：一个用户可以上传多个文件
- `tea_batches -> trace_records`：一个批次对应多条溯源记录，通过 `batch_no` 关联
- `file_infos`：通过 `ref_type + ref_id` 关联批次或记录附件

## 5. 字段说明

### 5.1 `users`

| 字段 | 类型 | 说明 | 约束 |
| --- | --- | --- | --- |
| `id` | `BIGINT UNSIGNED` | 用户主键 | 主键，自增 |
| `username` | `VARCHAR(50)` | 登录账号 | 非空，唯一 |
| `password` | `VARCHAR(255)` | bcrypt 密码哈希 | 非空 |
| `role` | `VARCHAR(30)` | 角色标识 | 非空 |
| `real_name` | `VARCHAR(50)` | 真实姓名 | 非空 |
| `company_name` | `VARCHAR(100)` | 所属单位 | 可空 |
| `status` | `TINYINT` | 账号状态 | 默认 `1` |
| `created_at` | `DATETIME` | 创建时间 | 默认当前时间 |
| `updated_at` | `DATETIME` | 更新时间 | 默认当前时间，更新时自动刷新 |

### 5.2 `tea_batches`

| 字段 | 类型 | 说明 | 约束 |
| --- | --- | --- | --- |
| `id` | `BIGINT UNSIGNED` | 批次主键 | 主键，自增 |
| `batch_no` | `VARCHAR(64)` | 批次号 | 非空，唯一 |
| `tea_name` | `VARCHAR(100)` | 茶叶名称 | 非空 |
| `tea_type` | `VARCHAR(100)` | 茶叶类别 | 非空 |
| `origin` | `VARCHAR(255)` | 产地 | 非空 |
| `plantation_name` | `VARCHAR(100)` | 茶园名称 | 可空 |
| `description` | `TEXT` | 批次描述 | 可空 |
| `cover_image` | `VARCHAR(255)` | 封面图路径 | 可空 |
| `qr_code_url` | `VARCHAR(255)` | 二维码图片路径 | 可空 |
| `batch_hash` | `VARCHAR(128)` | 批次摘要哈希 | 可空 |
| `tx_hash` | `VARCHAR(128)` | 上链交易哈希 | 可空 |
| `block_number` | `BIGINT UNSIGNED` | 区块号 | 可空 |
| `chain_status` | `VARCHAR(20)` | 上链状态 | 默认 `pending` |
| `created_by` | `BIGINT UNSIGNED` | 创建人用户 ID | 外键到 `users.id` |
| `created_at` | `DATETIME` | 创建时间 | 默认当前时间 |
| `updated_at` | `DATETIME` | 更新时间 | 默认当前时间，更新时自动刷新 |

### 5.3 `trace_records`

| 字段 | 类型 | 说明 | 约束 |
| --- | --- | --- | --- |
| `id` | `BIGINT UNSIGNED` | 记录主键 | 主键，自增 |
| `batch_no` | `VARCHAR(64)` | 所属批次号 | 非空，外键到 `tea_batches.batch_no` |
| `stage_type` | `VARCHAR(30)` | 环节类型 | 非空，固定枚举 |
| `title` | `VARCHAR(100)` | 记录标题 | 非空 |
| `content` | `TEXT` | 记录摘要内容 | 可空 |
| `detail_json` | `LONGTEXT` | 扩展业务 JSON | 可空 |
| `operator_name` | `VARCHAR(50)` | 操作人 | 非空 |
| `operate_time` | `DATETIME` | 操作时间 | 非空 |
| `attachment_url` | `VARCHAR(255)` | 附件路径 | 可空 |
| `data_hash` | `VARCHAR(128)` | 记录摘要哈希 | 可空 |
| `tx_hash` | `VARCHAR(128)` | 上链交易哈希 | 可空 |
| `block_number` | `BIGINT UNSIGNED` | 区块号 | 可空 |
| `chain_status` | `VARCHAR(20)` | 上链状态 | 默认 `pending` |
| `created_by` | `BIGINT UNSIGNED` | 创建人用户 ID | 外键到 `users.id` |
| `created_at` | `DATETIME` | 创建时间 | 默认当前时间 |
| `updated_at` | `DATETIME` | 更新时间 | 默认当前时间，更新时自动刷新 |

### 5.4 `file_infos`

| 字段 | 类型 | 说明 | 约束 |
| --- | --- | --- | --- |
| `id` | `BIGINT UNSIGNED` | 文件主键 | 主键，自增 |
| `ref_type` | `VARCHAR(30)` | 关联对象类型 | 非空，固定枚举 |
| `ref_id` | `BIGINT UNSIGNED` | 关联对象 ID | 非空 |
| `file_name` | `VARCHAR(255)` | 原始文件名 | 非空 |
| `file_url` | `VARCHAR(255)` | 文件访问路径 | 非空 |
| `file_hash` | `VARCHAR(128)` | 文件摘要哈希 | 可空 |
| `file_type` | `VARCHAR(50)` | 文件 MIME 或业务类型 | 非空 |
| `created_by` | `BIGINT UNSIGNED` | 上传人用户 ID | 外键到 `users.id` |
| `created_at` | `DATETIME` | 上传时间 | 默认当前时间 |

## 6. 索引、约束与一致性规则

### 6.1 索引

- `uk_users_username`：`users.username` 唯一索引
- `uk_tea_batches_batch_no`：`tea_batches.batch_no` 唯一索引
- `idx_trace_records_batch_no`：按批次号查询记录
- `idx_trace_records_batch_stage`：按批次号和环节联合查询
- `idx_file_infos_ref`：按关联对象快速查询附件

### 6.2 外键

- `tea_batches.created_by -> users.id`
- `trace_records.batch_no -> tea_batches.batch_no`
- `trace_records.created_by -> users.id`
- `file_infos.created_by -> users.id`

### 6.3 检查约束

- `tea_batches.chain_status` 只能是 `pending/success/failed`
- `trace_records.stage_type` 只能是六个固定环节值
- `trace_records.chain_status` 只能是 `pending/success/failed`
- `file_infos.ref_type` 只能是 `batch/trace`

## 7. `detail_json` 结构约定

`trace_records.detail_json` 用于保存不同环节的扩展业务字段，统一采用 JSON 字符串。

### 7.1 `harvest`

```json
{
  "gardenName": "西湖龙井一号茶园",
  "weather": "晴",
  "pickerName": "张三",
  "pickTime": "2025-03-25 08:30:00",
  "remark": "采摘嫩芽"
}
```

### 7.2 `process`

```json
{
  "factoryName": "杭州绿茶加工厂",
  "processType": "杀青、揉捻、烘干",
  "temperature": "80C",
  "duration": "30分钟",
  "managerName": "李四",
  "remark": "工艺正常"
}
```

### 7.3 `inspection`

```json
{
  "agencyName": "杭州市茶叶检测中心",
  "reportNo": "JC20250001",
  "result": "合格",
  "conclusion": "符合出厂标准",
  "remark": "农残合格"
}
```

### 7.4 `package`

```json
{
  "packageSpec": "250g/盒",
  "warehouseName": "杭州一号仓",
  "warehouseLocation": "A区1架",
  "packageTime": "2025-03-27 10:00:00",
  "remark": "已入库"
}
```

### 7.5 `logistics`

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

### 7.6 `sale`

```json
{
  "storeName": "上海徐汇旗舰店",
  "salesArea": "华东地区",
  "shelfTime": "2025-03-30 09:30:00",
  "remark": "已上架销售"
}
```

## 8. 初始化数据

`seed.sql` 预置 4 个演示账号：

| 用户名 | 角色 | 真实姓名 | 单位 |
| --- | --- | --- | --- |
| `admin` | `admin` | System Admin | Platform Center |
| `producer01` | `producer` | Tea Producer | High Mountain Tea Farm |
| `logistics01` | `logistics` | Logistics Staff | Tea Logistics Co |
| `seller01` | `seller` | Sales Staff | Tea Store |

- 默认明文演示密码：`abc`
- 数据库存储的是 bcrypt 哈希，不存明文密码

## 9. 相关文件

- `backend/sql/schema.sql`
- `backend/sql/seed.sql`
- `docs/database.md`
