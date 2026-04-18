-- MySQL dump 10.13  Distrib 8.4.8, for Win64 (x86_64)
--
-- Host: localhost    Database: tea_trace_system
-- ------------------------------------------------------
-- Server version	8.4.8

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `tea_trace_system`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tea_trace_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tea_trace_system`;

--
-- Table structure for table `file_infos`
--

DROP TABLE IF EXISTS `file_infos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `file_infos` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'file id',
  `ref_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ref type: batch/trace',
  `ref_id` bigint unsigned NOT NULL COMMENT 'referenced record id',
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'original file name',
  `file_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'file url',
  `file_hash` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'file hash',
  `file_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'file type',
  `created_by` bigint unsigned DEFAULT NULL COMMENT 'uploader user id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  PRIMARY KEY (`id`),
  KEY `idx_file_infos_ref` (`ref_type`,`ref_id`),
  KEY `idx_file_infos_created_by` (`created_by`),
  CONSTRAINT `fk_file_infos_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_file_infos_ref_type` CHECK ((`ref_type` in (_utf8mb4'batch',_utf8mb4'trace')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='uploaded files';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_infos`
--

LOCK TABLES `file_infos` WRITE;
/*!40000 ALTER TABLE `file_infos` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_infos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tea_batches`
--

DROP TABLE IF EXISTS `tea_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tea_batches` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'batch id',
  `batch_no` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'batch number',
  `tea_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'tea name',
  `tea_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'tea type',
  `origin` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'origin',
  `plantation_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'plantation name',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'batch description',
  `cover_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'cover image url',
  `qr_code_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'qr code image url',
  `batch_hash` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'batch hash',
  `tx_hash` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'on-chain tx hash',
  `block_number` bigint unsigned DEFAULT NULL COMMENT 'block number',
  `chain_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT 'chain status: pending/success/failed',
  `created_by` bigint unsigned DEFAULT NULL COMMENT 'creator user id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tea_batches_batch_no` (`batch_no`),
  KEY `idx_tea_batches_chain_status` (`chain_status`),
  KEY `idx_tea_batches_created_by` (`created_by`),
  CONSTRAINT `fk_tea_batches_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_tea_batches_chain_status` CHECK ((`chain_status` in (_utf8mb4'pending',_utf8mb4'success',_utf8mb4'failed')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tea batches';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tea_batches`
--

LOCK TABLES `tea_batches` WRITE;
/*!40000 ALTER TABLE `tea_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `tea_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trace_records`
--

DROP TABLE IF EXISTS `trace_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trace_records` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'trace id',
  `batch_no` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'batch number',
  `stage_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'stage type',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'record title',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT 'record content',
  `detail_json` longtext COLLATE utf8mb4_unicode_ci COMMENT 'extended json payload',
  `operator_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'operator name',
  `operate_time` datetime NOT NULL COMMENT 'operation time',
  `attachment_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'attachment url',
  `data_hash` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'record data hash',
  `tx_hash` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'on-chain tx hash',
  `block_number` bigint unsigned DEFAULT NULL COMMENT 'block number',
  `chain_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT 'chain status: pending/success/failed',
  `created_by` bigint unsigned DEFAULT NULL COMMENT 'creator user id',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (`id`),
  KEY `idx_trace_records_batch_no` (`batch_no`),
  KEY `idx_trace_records_batch_stage` (`batch_no`,`stage_type`),
  KEY `idx_trace_records_operate_time` (`operate_time`),
  KEY `idx_trace_records_created_by` (`created_by`),
  CONSTRAINT `fk_trace_records_batch_no` FOREIGN KEY (`batch_no`) REFERENCES `tea_batches` (`batch_no`),
  CONSTRAINT `fk_trace_records_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_trace_records_chain_status` CHECK ((`chain_status` in (_utf8mb4'pending',_utf8mb4'success',_utf8mb4'failed'))),
  CONSTRAINT `chk_trace_records_stage_type` CHECK ((`stage_type` in (_utf8mb4'harvest',_utf8mb4'process',_utf8mb4'inspection',_utf8mb4'package',_utf8mb4'logistics',_utf8mb4'sale')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='trace records';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trace_records`
--

LOCK TABLES `trace_records` WRITE;
/*!40000 ALTER TABLE `trace_records` DISABLE KEYS */;
/*!40000 ALTER TABLE `trace_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'user id',
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'login username',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'bcrypt password hash',
  `role` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'role: admin/producer/logistics/seller',
  `real_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'real name',
  `company_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'company name',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT 'status: 1 enabled, 0 disabled',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_username` (`username`),
  KEY `idx_users_role` (`role`),
  KEY `idx_users_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='system users';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','$2a$10$OrKdcWORLL8Gorhy9XR3UOY8Sebzq92m7r02XPitzoazPdO7tmsEO','admin','System Admin','Platform Center',1,'2026-04-16 21:05:45','2026-04-16 21:05:45'),(2,'producer01','$2a$10$OrKdcWORLL8Gorhy9XR3UOY8Sebzq92m7r02XPitzoazPdO7tmsEO','producer','Tea Producer','High Mountain Tea Farm',1,'2026-04-16 21:05:45','2026-04-16 21:05:45'),(3,'logistics01','$2a$10$OrKdcWORLL8Gorhy9XR3UOY8Sebzq92m7r02XPitzoazPdO7tmsEO','logistics','Logistics Staff','Tea Logistics Co',1,'2026-04-16 21:05:45','2026-04-16 21:05:45'),(4,'seller01','$2a$10$OrKdcWORLL8Gorhy9XR3UOY8Sebzq92m7r02XPitzoazPdO7tmsEO','seller','Sales Staff','Tea Store',1,'2026-04-16 21:05:45','2026-04-16 21:05:45');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'tea_trace_system'
--

--
-- Dumping routines for database 'tea_trace_system'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-16 21:45:13