# 基于区块链的茶叶全流程溯源系统

## 项目简介

这是一个面向课程项目演示的茶叶全流程溯源系统，采用前后端分离加本地区块链的方式实现。

项目聚焦 MVP 范围，优先完成以下核心能力：

- 用户登录
- 批次创建、列表、详情
- 溯源环节记录新增
- 文件上传
- 二维码生成
- 消费者扫码查询
- 上链结果展示

## 技术栈

- 前端：`Vue 3`、`Vite`、`Vue Router`、`Pinia`、`Element Plus`、`Axios`
- 后端：`Node.js`、`Express`、`mysql2`、`jsonwebtoken`、`bcryptjs`、`multer`、`qrcode`、`ethers`
- 区块链：`Solidity`、`Hardhat`、`ethers`、`Ganache`
- 数据库：`MySQL`

## 目录结构

```text
tea-trace-system/
├─ docs/               项目文档骨架
├─ backend/            后端服务骨架
├─ blockchain/         智能合约与部署脚本骨架
└─ frontend/           管理后台与扫码查询前端骨架
```

## 运行方式

当前已完成阶段 1 项目骨架、阶段 2 数据库设计与落库、阶段 3 智能合约与本地链部署。

### 区块链阶段命令

在 `blockchain/` 目录下执行：

1. 安装依赖：`npm install`
2. 启动 Ganache：`npm run start:ganache`
3. 编译合约：`npm run compile`
4. 部署合约：`npm run deploy`
5. 自检调用：`npm run smoke:test`

阶段 3 的部署记录会写入：

- `blockchain/deployments/ganache.json`
- `blockchain/deployments/latest.json`

建议后续按下面顺序推进：

1. 先完成后端基础能力
2. 再完成后端业务接口
3. 再接入合约地址与链服务
4. 最后完成前端管理后台与扫码查询页

## 演示流程

1. 管理员登录系统
2. 创建茶叶批次
3. 录入采摘、加工、检测、包装、物流、销售等溯源记录
4. 上传图片或检测报告
5. 生成二维码并展示批次信息
6. 消费者扫码查看完整溯源链路
7. 展示链上交易哈希和区块信息

## 当前进度

- 已完成：阶段 1 初始化项目骨架
- 已完成：阶段 2 数据库设计、建表与默认账号落库
- 已完成：阶段 3 智能合约、本地链部署与链上自检
- 下一步：进入阶段 4，实现后端基础能力
