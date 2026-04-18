SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS tea_trace_system
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE tea_trace_system;

DROP TABLE IF EXISTS file_infos;
DROP TABLE IF EXISTS trace_records;
DROP TABLE IF EXISTS tea_batches;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'user id',
  username VARCHAR(50) NOT NULL COMMENT 'login username',
  password VARCHAR(255) NOT NULL COMMENT 'bcrypt password hash',
  role VARCHAR(30) NOT NULL COMMENT 'role: admin/producer/logistics/seller',
  real_name VARCHAR(50) NOT NULL COMMENT 'real name',
  company_name VARCHAR(100) DEFAULT NULL COMMENT 'company name',
  status TINYINT NOT NULL DEFAULT 1 COMMENT 'status: 1 enabled, 0 disabled',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (id),
  UNIQUE KEY uk_users_username (username),
  KEY idx_users_role (role),
  KEY idx_users_status (status)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='system users';

CREATE TABLE tea_batches (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'batch id',
  batch_no VARCHAR(64) NOT NULL COMMENT 'batch number',
  tea_name VARCHAR(100) NOT NULL COMMENT 'tea name',
  tea_type VARCHAR(100) NOT NULL COMMENT 'tea type',
  origin VARCHAR(255) NOT NULL COMMENT 'origin',
  plantation_name VARCHAR(100) DEFAULT NULL COMMENT 'plantation name',
  description TEXT DEFAULT NULL COMMENT 'batch description',
  cover_image VARCHAR(255) DEFAULT NULL COMMENT 'cover image url',
  qr_code_url VARCHAR(255) DEFAULT NULL COMMENT 'qr code image url',
  batch_hash VARCHAR(128) DEFAULT NULL COMMENT 'batch hash',
  tx_hash VARCHAR(128) DEFAULT NULL COMMENT 'on-chain tx hash',
  block_number BIGINT UNSIGNED DEFAULT NULL COMMENT 'block number',
  chain_status VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'chain status: pending/success/failed',
  created_by BIGINT UNSIGNED DEFAULT NULL COMMENT 'creator user id',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (id),
  UNIQUE KEY uk_tea_batches_batch_no (batch_no),
  KEY idx_tea_batches_chain_status (chain_status),
  KEY idx_tea_batches_created_by (created_by),
  CONSTRAINT fk_tea_batches_created_by FOREIGN KEY (created_by) REFERENCES users (id),
  CONSTRAINT chk_tea_batches_chain_status CHECK (chain_status IN ('pending', 'success', 'failed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tea batches';

CREATE TABLE trace_records (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'trace id',
  batch_no VARCHAR(64) NOT NULL COMMENT 'batch number',
  stage_type VARCHAR(30) NOT NULL COMMENT 'stage type',
  title VARCHAR(100) NOT NULL COMMENT 'record title',
  content TEXT DEFAULT NULL COMMENT 'record content',
  detail_json LONGTEXT DEFAULT NULL COMMENT 'extended json payload',
  operator_name VARCHAR(50) NOT NULL COMMENT 'operator name',
  operate_time DATETIME NOT NULL COMMENT 'operation time',
  attachment_url VARCHAR(255) DEFAULT NULL COMMENT 'attachment url',
  data_hash VARCHAR(128) DEFAULT NULL COMMENT 'record data hash',
  tx_hash VARCHAR(128) DEFAULT NULL COMMENT 'on-chain tx hash',
  block_number BIGINT UNSIGNED DEFAULT NULL COMMENT 'block number',
  chain_status VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'chain status: pending/success/failed',
  created_by BIGINT UNSIGNED DEFAULT NULL COMMENT 'creator user id',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (id),
  KEY idx_trace_records_batch_no (batch_no),
  KEY idx_trace_records_batch_stage (batch_no, stage_type),
  KEY idx_trace_records_operate_time (operate_time),
  KEY idx_trace_records_created_by (created_by),
  CONSTRAINT fk_trace_records_batch_no FOREIGN KEY (batch_no) REFERENCES tea_batches (batch_no),
  CONSTRAINT fk_trace_records_created_by FOREIGN KEY (created_by) REFERENCES users (id),
  CONSTRAINT chk_trace_records_stage_type CHECK (
    stage_type IN ('harvest', 'process', 'inspection', 'package', 'logistics', 'sale')
  ),
  CONSTRAINT chk_trace_records_chain_status CHECK (chain_status IN ('pending', 'success', 'failed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='trace records';

CREATE TABLE file_infos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'file id',
  ref_type VARCHAR(30) NOT NULL COMMENT 'ref type: batch/trace',
  ref_id BIGINT UNSIGNED NOT NULL COMMENT 'referenced record id',
  file_name VARCHAR(255) NOT NULL COMMENT 'original file name',
  file_url VARCHAR(255) NOT NULL COMMENT 'file url',
  file_hash VARCHAR(128) DEFAULT NULL COMMENT 'file hash',
  file_type VARCHAR(50) NOT NULL COMMENT 'file type',
  created_by BIGINT UNSIGNED DEFAULT NULL COMMENT 'uploader user id',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  PRIMARY KEY (id),
  KEY idx_file_infos_ref (ref_type, ref_id),
  KEY idx_file_infos_created_by (created_by),
  CONSTRAINT fk_file_infos_created_by FOREIGN KEY (created_by) REFERENCES users (id),
  CONSTRAINT chk_file_infos_ref_type CHECK (ref_type IN ('batch', 'trace'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='uploaded files';
