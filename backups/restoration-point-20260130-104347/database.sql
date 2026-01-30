/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.15-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: wms_db
-- ------------------------------------------------------
-- Server version	10.11.15-MariaDB-ubu2204

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `app_settings`
--

DROP TABLE IF EXISTS `app_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_settings_key_unique` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_settings`
--

LOCK TABLES `app_settings` WRITE;
/*!40000 ALTER TABLE `app_settings` DISABLE KEYS */;
INSERT INTO `app_settings` VALUES
(1,'site_name','CRM GIDOMARE','2026-01-19 06:50:09','2026-01-19 06:50:09'),
(2,'site_logo','brand/01KFAG987D18RGE9WXKXY1VYD7.png','2026-01-19 06:50:09','2026-01-19 06:50:09'),
(3,'primary_color','#120887','2026-01-19 06:50:09','2026-01-19 06:50:09'),
(4,'site_logo_dark',NULL,'2026-01-30 08:22:53','2026-01-30 08:22:53'),
(5,'backup_enabled','1','2026-01-30 08:22:53','2026-01-30 08:22:53'),
(6,'backup_frequency','daily','2026-01-30 08:22:53','2026-01-30 08:22:53'),
(7,'backup_time','04:00','2026-01-30 08:22:53','2026-01-30 08:22:53'),
(8,'backup_retention_days','7','2026-01-30 08:22:53','2026-01-30 08:22:53');
/*!40000 ALTER TABLE `app_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backups`
--

DROP TABLE IF EXISTS `backups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `backups` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `disk` varchar(255) NOT NULL DEFAULT 'local',
  `size` bigint(20) NOT NULL DEFAULT 0,
  `type` varchar(255) NOT NULL DEFAULT 'manual',
  `status` varchar(255) NOT NULL DEFAULT 'completed',
  `error_message` text DEFAULT NULL,
  `hash` varchar(255) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `backups_created_at_index` (`created_at`),
  KEY `backups_status_index` (`status`),
  KEY `backups_type_index` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backups`
--

LOCK TABLES `backups` WRITE;
/*!40000 ALTER TABLE `backups` DISABLE KEYS */;
INSERT INTO `backups` VALUES
(2,'backup-2026-01-30-08-28-53.zip','backups/backup-2026-01-30-08-28-53.zip','local',2728030,'manual','completed',NULL,'4da3bf932c778915a0ef23fde4c3949b','{\"laravel_version\":\"11.47.0\",\"php_version\":\"8.3.30\",\"created_by\":\"Admin\"}','2026-01-30 08:28:55','2026-01-30 08:28:53','2026-01-30 08:28:55'),
(3,'backup-2026-01-30-15-42-09.zip','backups/backup-2026-01-30-15-42-09.zip','local',5131859,'manual','completed',NULL,'7ff22473be17dceedf6fcdead32a273b','{\"laravel_version\":\"11.47.0\",\"php_version\":\"8.3.30\",\"created_by\":\"Admin\"}','2026-01-30 15:42:10','2026-01-30 15:42:09','2026-01-30 15:42:10');
/*!40000 ALTER TABLE `backups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bot_knowledge_base`
--

DROP TABLE IF EXISTS `bot_knowledge_base`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bot_knowledge_base` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bot_id` bigint(20) unsigned NOT NULL,
  `question_normalized` varchar(255) NOT NULL,
  `answer` text NOT NULL,
  `usage_count` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bot_knowledge_base_bot_id_question_normalized_index` (`bot_id`,`question_normalized`),
  KEY `bot_knowledge_base_question_normalized_index` (`question_normalized`),
  CONSTRAINT `bot_knowledge_base_bot_id_foreign` FOREIGN KEY (`bot_id`) REFERENCES `bots` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bot_knowledge_base`
--

LOCK TABLES `bot_knowledge_base` WRITE;
/*!40000 ALTER TABLE `bot_knowledge_base` DISABLE KEYS */;
INSERT INTO `bot_knowledge_base` VALUES
(1,1,'precio internet','Nuestros planes de fibra óptica inician desde 00 MXN mensuales.',1,'2026-01-19 23:00:23','2026-01-19 23:00:29'),
(2,1,'precio','Nuestros planes Hogar inician desde $299 MXN mensuales. 🚀',1,'2026-01-20 00:19:48','2026-01-20 00:26:28'),
(3,1,'donde pagan','Puedes pagar en OXXO, transferencia o directamente en sucursal. 💳',0,'2026-01-20 00:19:48','2026-01-20 00:19:48');
/*!40000 ALTER TABLE `bot_knowledge_base` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bot_sessions`
--

DROP TABLE IF EXISTS `bot_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bot_sessions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bot_id` bigint(20) unsigned NOT NULL,
  `phone_number` varchar(255) NOT NULL,
  `current_step_id` bigint(20) unsigned DEFAULT NULL,
  `variables` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`variables`)),
  `last_interaction_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bot_sessions_bot_id_phone_number_index` (`bot_id`,`phone_number`),
  KEY `bot_sessions_phone_number_index` (`phone_number`),
  CONSTRAINT `bot_sessions_bot_id_foreign` FOREIGN KEY (`bot_id`) REFERENCES `bots` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bot_sessions`
--

LOCK TABLES `bot_sessions` WRITE;
/*!40000 ALTER TABLE `bot_sessions` DISABLE KEYS */;
INSERT INTO `bot_sessions` VALUES
(1,1,'5211234567890',3,NULL,'2026-01-19 23:00:40','2026-01-19 22:59:59','2026-01-19 23:00:40'),
(2,1,'5219876543210',8,NULL,'2026-01-20 00:27:08','2026-01-20 00:26:05','2026-01-20 00:27:08'),
(13,1,'999999999',6,NULL,'2026-01-20 00:33:25','2026-01-20 00:33:24','2026-01-20 00:33:25'),
(14,1,'1123456789',6,NULL,'2026-01-20 00:53:37','2026-01-20 00:40:08','2026-01-20 00:53:37'),
(15,1,'1234567890',6,NULL,'2026-01-20 00:50:29','2026-01-20 00:47:40','2026-01-20 00:50:29'),
(16,1,'5650342140',6,NULL,'2026-01-20 00:58:26','2026-01-20 00:53:50','2026-01-20 00:58:26'),
(17,1,'5655038037',6,NULL,'2026-01-20 01:30:58','2026-01-20 01:27:36','2026-01-20 01:30:58');
/*!40000 ALTER TABLE `bot_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bot_steps`
--

DROP TABLE IF EXISTS `bot_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bot_steps` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bot_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` enum('message','menu','input','action','redirect','end') NOT NULL DEFAULT 'message',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`content`)),
  `next_step_id` bigint(20) unsigned DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bot_steps_bot_id_foreign` (`bot_id`),
  CONSTRAINT `bot_steps_bot_id_foreign` FOREIGN KEY (`bot_id`) REFERENCES `bots` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bot_steps`
--

LOCK TABLES `bot_steps` WRITE;
/*!40000 ALTER TABLE `bot_steps` DISABLE KEYS */;
INSERT INTO `bot_steps` VALUES
(5,1,'Bienvenida','message','{\"text\":\"\\u00a1Hola! \\ud83e\\udd16 Bienvenido a tu ISP Inteligente. Soy tu asistente virtual.\"}',6,100,'2026-01-20 00:19:48','2026-01-20 00:30:10'),
(6,1,'Menu Principal','menu','{\"text\":\"Selecciona una opci\\u00f3n:\",\"options\":[{\"label\":\"1. Soporte\",\"target_step_id\":7},{\"label\":\"2. Ventas\",\"target_step_id\":9},{\"label\":\"3. Agente Humano\",\"target_step_id\":10}]}',NULL,1,'2026-01-20 00:19:48','2026-01-20 00:19:48'),
(7,1,'Falla Tecnica','input','{\"text\":\"\\ud83d\\udee0\\ufe0f Por favor, escribe tu nombre y el problema que tienes:\",\"variable\":\"falla_reportada\"}',8,2,'2026-01-20 00:19:48','2026-01-20 00:19:48'),
(8,1,'Confirmacion Soporte','message','{\"text\":\"Entendido! Hemos recibido tu reporte. Un t\\u00e9cnico te contactar\\u00e1 pronto.\"}',NULL,3,'2026-01-20 00:19:48','2026-01-20 00:19:48'),
(9,1,'Ventas Planes','menu','{\"text\":\"Planes\",\"options\":[{\"label\":\"Hogar\",\"target_step_id\":8},{\"label\":\"Negocio\",\"target_step_id\":8}]}',NULL,4,'2026-01-20 00:19:48','2026-01-20 00:27:04'),
(10,1,'Transferencia Chatwoot','message','{\"text\":\"\\ud83c\\udf99\\ufe0f Te estoy transfiriendo con un agente humano. Por favor espera un momento...\"}',NULL,5,'2026-01-20 00:19:48','2026-01-20 00:19:48'),
(11,1,'Bienvenida Cliente','message','{\"text\":\"\\u00a1Hola {{nombre}}! \\ud83d\\udc4b Bienvenido de nuevo a tu portal de cliente. \\u00bfQu\\u00e9 deseas hacer hoy?\"}',6,0,'2026-01-20 00:29:41','2026-01-20 00:30:37'),
(12,1,'Bienvenida No Cliente','message','{\"text\":\"\\u00a1Hola! \\ud83e\\udd16 Bienvenido a nuestra empresa. Veo que a\\u00fan no eres cliente. \\u00bfTe gustar\\u00eda conocer nuestros planes?\"}',6,1,'2026-01-20 00:29:41','2026-01-20 00:30:37');
/*!40000 ALTER TABLE `bot_steps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bot_usage_logs`
--

DROP TABLE IF EXISTS `bot_usage_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bot_usage_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bot_id` bigint(20) unsigned NOT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `interaction_type` enum('flow','ia','memory') NOT NULL DEFAULT 'flow',
  `tokens_used` int(11) NOT NULL DEFAULT 0,
  `cost` decimal(10,6) NOT NULL DEFAULT 0.000000,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bot_usage_logs_bot_id_created_at_index` (`bot_id`,`created_at`),
  CONSTRAINT `bot_usage_logs_bot_id_foreign` FOREIGN KEY (`bot_id`) REFERENCES `bots` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bot_usage_logs`
--

LOCK TABLES `bot_usage_logs` WRITE;
/*!40000 ALTER TABLE `bot_usage_logs` DISABLE KEYS */;
INSERT INTO `bot_usage_logs` VALUES
(1,1,'5211234567890','memory',0,0.000000,'{\"q\":\"precio internet\",\"a\":\"Nuestros planes de fibra \\u00f3ptica inician desde 00 MXN mensuales.\"}','2026-01-19 23:00:29','2026-01-19 23:00:29'),
(2,1,'5219876543210','memory',0,0.000000,'{\"q\":\"precio\",\"a\":\"Nuestros planes Hogar inician desde $299 MXN mensuales. \\ud83d\\ude80\"}','2026-01-20 00:26:28','2026-01-20 00:26:28');
/*!40000 ALTER TABLE `bot_usage_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bots`
--

DROP TABLE IF EXISTS `bots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bots` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `test_mode` tinyint(1) NOT NULL DEFAULT 0,
  `whitelist` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`whitelist`)),
  `schedules` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`schedules`)),
  `ai_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `ai_provider` varchar(255) NOT NULL DEFAULT 'openai',
  `ai_api_key` text DEFAULT NULL,
  `ai_model` varchar(255) NOT NULL DEFAULT 'gpt-3.5-turbo',
  `ai_max_tokens` int(11) NOT NULL DEFAULT 150,
  `ai_daily_token_limit` int(11) NOT NULL DEFAULT 10000,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `chatwoot_enabled` tinyint(1) DEFAULT 0,
  `chatwoot_url` varchar(255) DEFAULT NULL,
  `chatwoot_token` text DEFAULT NULL,
  `chatwoot_account_id` varchar(255) DEFAULT NULL,
  `chatwoot_inbox_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bots`
--

LOCK TABLES `bots` WRITE;
/*!40000 ALTER TABLE `bots` DISABLE KEYS */;
INSERT INTO `bots` VALUES
(1,'Bot Test',NULL,1,0,'[\"5650342140\",\"2283060618\",\"5655038037\"]','[]',1,'openai','eyJpdiI6Ik1pMlN6ZVEvUzZZemV3S0FrNTBmZlE9PSIsInZhbHVlIjoic3l0MFJKK0p4QmdzVGtMY2c5TUNaYnB2TVcxVHhvMzNvNzd4ZHdtakFRVT0iLCJtYWMiOiJlYzVmOGQ2NjU5NTRmZWJlZDI2YWQ1NTgxNWU4NzcxNGVmMzhiODliZGNkMzdhNjhiMGVlZGM1ZGEzZTcxZWE5IiwidGFnIjoiIn0=','gpt-3.5-turbo',150,10000,'2026-01-19 22:59:50','2026-01-20 01:30:15',1,'https://wapi-chatwoot.unntkt.easypanel.host','eyJpdiI6IjRCZXpCcndlTUhrMEJaZEtMd3NSc1E9PSIsInZhbHVlIjoiTlhORDQyejdxN3l5ZU5hWStpYmloNWozQzIxQytNd29pajIyMVRjbzIyMD0iLCJtYWMiOiJjNzg5NTIyYjNkMjU5ODkyNDYxNjMyYzY0NTkwOGU0MGQ1YjkxMmE0ZTZmODJmZTk5ZDdmMzI3YWZlNjVkYzBlIiwidGFnIjoiIn0=','1','1');
/*!40000 ALTER TABLE `bots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `installation_date` date DEFAULT NULL,
  `coordinates` varchar(255) DEFAULT NULL,
  `wisphub_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customers_wisphub_id_unique` (`wisphub_id`)
) ENGINE=InnoDB AUTO_INCREMENT=513 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES
(1,'YaquelinZeferinoRom','','',NULL,'2026-01-15','',957,'2026-01-19 05:01:40','2026-01-19 07:27:21'),
(2,'Karina Zepeda Toral','','',NULL,'2026-01-14','',956,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(3,'Beatriz Vazquez Talango','','','Holanda Sur 49814 int5','2026-01-14','',955,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(4,'ClaraSantosDiaz','','',NULL,'2026-01-14','',954,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(5,'NormaMichelDimas','','',NULL,'2026-01-14','',953,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(6,'RodrigoPantojaMoli','','',NULL,'2026-01-13','',952,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(7,'AreliValladaresMunoz','','',NULL,'2026-01-07','',951,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(8,'YeseniaSantiagoCruz','','',NULL,'2026-01-06','',950,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(9,'AdalbertoManuelBello','','',NULL,'2026-01-06','',949,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(10,'MiguelAngelGilEsp','','',NULL,'2026-01-05','',948,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(11,'AngelManuelPeredo','','',NULL,'2025-12-31','',947,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(12,'Blanca Flor Gallardo Lopez','','2291026491','Grecia Sur 32 #6\nLagos de Puente Moreno\nMedellin','2025-12-30','',946,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(13,'PRUEBA-BOCA','','5650342140',NULL,'2025-12-27','',945,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(14,'Alexis Martinez Puga','','2294817783','Hungria Norte 49104 #1\nLagos de Puente Moreno\nMedellin','2025-12-20','',944,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(15,'Delia Montenegro Cobos','','2202330250','Hungria Norte 9 #5\nLagos de Puente Moreno\nMedellin','2025-12-18','',943,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(16,'Carla Karina Navarro Luna','','2299579686','Hungria Norte 49029 #3\nLagos de Puente Moreno\nMedellin','2025-12-17','',942,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(17,'Eliud Garcia Lopez','','2294160558','Hungria Oeste 48930 #6\nLagos de Puente Moreno\nMedellin','2025-12-17','',941,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(18,'Everardo Malaga Martinez','','2294220789','Hungria Norte 49003 #4\nLagos de Puente Moreno\nMedellin','2025-12-17','',940,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(19,'Esmeralda Yepez Castro','','2297644729','Noruega Sur 52611 #1\nLagos de Puente Moreno\nMedellin','2025-12-16','',939,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(20,'Haydee Martinez Gomez','','2293208517','Grecia Sur 34 #3\nLagos de Puente Moreno\nMedellin','2025-12-16','',938,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(21,'Miguel Angel Morales Hernandez','','2291284320','Grecia Sur 48716 #1\nLagos de Puente Moreno\nMedellin','2025-12-15','',937,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(22,'CapiPatracaBoca','','',NULL,'2025-12-13','',936,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(23,'Geraldine Antonio Rodriguez','','2881325756','Hungria Norte 49019 #4\nLagos de Puente Moreno\nMedellin','2025-12-13','',935,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(24,'Emmanuel De Luna Vergara','','2297748775','Hungria Norte 49017 #2\nLagos de Puente Moreno\nMedellin','2025-12-13','',934,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(25,'Maria Del Pilar Cuellar Martinez','','2291463200','Hungria Norte 49011 #4\nLagos de Puente Moreno\nMedellin','2025-12-11','',933,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(26,'Margarita Hernandez Alvarez','','2292881059','CJON Morelos M MZA\nCol. Ricardo Flores Magon\nBoca del Rio','2025-12-10','',932,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(27,'Jose Guadalupe Garcia Canchola','','2201501851','Opalo Sur 23319 #4\nLagos de Puente Moreno\nMedellin','2025-12-10','',931,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(28,'Miriam Alejandra Martinez Luevano','','2291460631','Hungria Norte 49009 #6\nLagos de Puente Moreno\nMedellin','2025-12-09','',929,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(29,'Mario Florencio Vergara','','2294054343','Hungria Norte 49023 #6\nLagos de Puente Moreno\nMedellin','2025-12-09','',928,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(30,'Angelica Velazquez Guzman','','2299505025','Hungria Norte 49110 #3\nLagos de Puente Moreno\nMedellin','2025-12-09','',927,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(31,'Mayra Luz Tello Garcia','','2294607337','Hungria Norte 49015 #3\nLagos de Puente Moreno\nMedellin','2025-12-08','',926,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(32,'Mauro Torres Carrera','','2291388211','Hungria Norte 48930 #4\nLagos de Puente Moreno\nMedellin','2025-12-05','',925,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(33,'Miguel Angel Ramos Gregorio','','2295686336','Irlanda Sur 51510 #5\nLagos de Puente Moreno\nMedellin','2025-12-05','',924,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(34,'Karen Martinez Celis','','2293236054','Hungria Norte 49029 #4\nLagos de Puente Moreno\nMedellin','2025-12-04','',923,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(35,'Sahyra Melissa Alvarez Hernandez','','4425052574','Hungria Norte 49009 #3\nLagos de Puente Moreno\nMedellin','2025-12-03','',922,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(36,'Martha Aurora Cordoba Rojas','','2293902816','Hungria Norte 49007 #4\nLagos de Puente Moreno\nMedellin','2025-12-03','',921,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(37,'Sandra Lizbeth Malaga De Dios','','2297499599','Holanda Centro 49601 #4\nLagos de Puente Moreno\nMedellin','2025-11-29','',920,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(38,'Wendy Soto Rivera','','2291470509','Hungria Norte 49013 #2\nLagos de Puente Moreno\nMedellin','2025-11-29','',919,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(39,'Cynthia Michelle Acevedo Cesar','','2292432347','Holanda Centro 49726 #6\nLagos de Puente Moreno\nMedellin','2025-11-28','',917,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(40,'Rolando Solis Conrado','','2294518877','Holanda Norte 49419 #5\nLagos de Puente Moreno\nMedellin','2025-11-27','',916,'2026-01-19 05:02:56','2026-01-19 07:27:21'),
(41,'Monserrat Grados Herrera','','2298529010','Hungria Norte 49104 #3\nLagos de Puente Moreno\nMedellin','2025-11-27','',915,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(42,'Guadalupe Guerrero Jacome','','2291399441','Hungria Sur 49204 #1\nLagos de Puente Moreno\nMedellin','2025-11-27','',914,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(43,'Silberta Muñoz Hervis','','2294372256','Noruega Norte 52527 #1\nLagos de Puente Moreno\nMedellin','2025-11-26','',913,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(44,'Silvia Edith Toledo Castro','','2291109842','Independencia 8 BIS JO DGUEZ\r\nRuiz Cortinez Lopez Arias\nCol. Ricardo Flores Magon\nBoca del Rio','2025-11-25','',912,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(45,'Jennyfer Tejeda Gutierrez','','2882192439','Hungria Sur 49101 #5\nLagos de Puente Moreno\nMedellin','2025-11-25','',911,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(46,'Judit Juarez Espejo','','2295061782','Holanda Centro 49722 #5\nLagos de Puente Moreno\nMedellin','2025-11-25','',910,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(47,'Francisco Yepez Aguilar','','2971192865','Calzada Del Sol 53009 #2\nLagos de Puente Moreno\nMedellin','2025-11-24','',909,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(48,'RosaLinda Gonzalez Zuñiga','','4427963303','Hungria Oeste 48936 #5\nLagos de Puente Moreno\nMedellin','2025-11-22','',908,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(49,'Jessica Veneroso Montes','','2297003286','Hungria Norte 49015 #5\nLagos de Puente Moreno\nMedellin','2025-11-22','',907,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(50,'SECTOR PUENTE MORENO INGT_PTE_SCTBP1','','','usuario :gidomare\r\ncontraseña: Gidomare121682#','2025-11-22','',906,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(51,'SECTOR PUENTE MORENO INGT_PTE_SCTBP2','','','usuario:gidomare\r\ncontraseña: Gidomare121682#','2025-11-22','',905,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(52,'SECTOR PUENTE MORENO INGT_PTE_SCTAP1','','','usuario: gidomare\r\ncontraseña: Gidomare121683#','2025-11-22','',904,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(53,'SECTOR PUENTE MORENO INGT_PTE_SCTB','','','usuario: gidomare\r\ncontraseña: Gidomare121682#','2025-11-22','',903,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(54,'SECTOR PUENTE MORENO INGT_PTE_SCTA1','','','usuario :gidomare\r\ncontraseña: Gidomare121682#','2025-11-22','',902,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(55,'Jessica Ixba Villaseca','','2941398868','Irlanda NTE 51331 #1\nLagos de Puente Moreno\nMedellin','2025-11-22','',901,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(56,'SECTOR PUENTE MORENO INGT_PTE_SCTA','','','usuario: ubnt\r\ncontraseña: gidomare','2025-11-22','',900,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(57,'PUENTE SECTOR INGT_PTE_SCTC1','','','usuario: gidomare\r\ncontraseña: Gidomare121682#','2025-11-22','',899,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(58,'PUENTE ENLACE 60GHZ','','',NULL,'2025-11-22','',898,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(59,'PUENTE SECTOR ING_PTE_NR','','','usuario: ubnt\r\ncontraseña: Gidomare121682#','2025-11-22','',897,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(60,'PUENTE SECTOR INGT_PTE_SCTC','','','usuario:  gidomare\r\ncontraseña: Gidomare121682#','2025-11-22','',896,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(61,'Saul Ruiz Carranza','','2299784926','Hungria Sur 49127 #5\nLagos de Puente Moreno\nMedellin','2025-11-21','',895,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(62,'Yafed Hernandez Salomon','','2741125636','Holanda Centro #476-70 Int. 2 94274\nLagos de Puente Moreno\nMedellin','2025-11-20','',894,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(63,'Marisol Gonzalez Montejo','','2295257033','Israel Este MZA -559 LT -67\nLagos de Puente Moreno\nMedellin','2025-11-20','',893,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(65,'Carlos Uriel Doblon Flores','','2291521936','Hungria Norte 49009 #4\nLagos de Puente Moreno\nMedellin','2025-11-19','',891,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(66,'Mauricio Aldair Serena Ramirez','','2292919671','Bolivia Centro 43302 #4\nLagos de Puente Moreno\nMedellin','2025-11-19','',890,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(67,'Alma Estela Nuñez Lopez','','2292137146','Hungria Norte 49104 #4\nLagos de Puente Moreno\nMedellin','2025-11-18','',889,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(68,'Carlos Jorge Perez Noble','','9994581302','Bolivia Centro 43324 #5\nLagos de Puente Moreno\nMedellin','2025-11-18','',888,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(69,'Maria Del Carmen Vidaña Dominguez','','2291741217','Hungria Norte 49120 #6\nLagos de Puente Moreno\nMedellin','2025-11-17','',887,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(70,'Diego Alberto Cardenas Ortega','','2299155766','Hungria Norte 49120 #5\nLagos de Puente Moreno\nMedellin','2025-11-17','',886,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(71,'Ana Yareli Baizabal Beristain','','5530078387','Hungria Norte 49114 #1\nLagos de Puente Moreno\nMedellin','2025-11-17','',885,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(72,'Jose Manuel Hernandez Avendaño','','2295212421','Irlanda Norte 51430 #5\nLagos de Puente Moreno\nMedellin','2025-11-17','',884,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(73,'AlanGonzalezLara','','2295244407',NULL,'2025-11-15','',882,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(74,'Kevin Obed Vidal Vidal','','8327388381','Holanda Norte 49427 #1\nLagos de Puente Moreno\nMedellin','2025-11-15','',881,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(75,'Roman Antonio Mendoza Perez','','2298188795','Hungria Sur 49107 #5\nLagos de Puente Moreno\nMedellin','2025-11-15','',880,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(76,'Saul Celestino Pereda Perez','','2295226130','Inglaterra Norte 50019 #1\nLagos de Puente Moreno\nMedellin','2025-11-14','',879,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(77,'Martha Elena Rubio Hernandez','','2291474098','Ribera De La LAG Visur 34\nLagos de Puente Moreno\nMedellin','2025-11-14','',878,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(78,'Samara Vazquez Montiel','','2295482850','Holanda Centro 49605 #6\nLagos de Puente Moreno\nMedellin','2025-11-14','',877,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(79,'Alan Jesus Carrera Avila','','7821020382','Hungria Norte 1 #3\nLagos de Puente Moreno\nMedellin','2025-11-13','',876,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(80,'Diana Laura Chigo Baxin','','2299077029','Hungria Norte 49001 #4\nLagos de Puente Moreno\nMedellin','2025-11-12','',875,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(81,'Gabino Castillo Gonzalez','','2295518212','Hungria Norte 49019 #1\nLagos de Puente Moreno\nMedellin','2025-11-11','',874,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(82,'Jaime Gayosso Ramirez','','2218649302','Holanda Centro 49702 #4\nLagos de Puente Moreno\nMedellin','2025-11-11','',873,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(83,'Christian Valencia Aguilar','','2299265387','AV De Las Americas 43315 #5  Entre CTO Bolivia y Calzada Del Sol\nLagos de Puente Moreno\nMedellin','2025-11-11','',872,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(84,'Abraham Garcia Beranza','','2292230418','Bolivia Centro 43330 #3\nLagos de Puente Moreno\nMedellin','2025-11-11','',871,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(85,'Beatriz Vazquez Vazquez','','2291383294','Hungria Norte 49003 #5\nLagos de Puente Moreno\nMedellin','2025-11-11','',870,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(86,'Martha Guadalupe Gomez Hernandez','','2299035637','Hungria Norte 49007 #1\nLagos de Puente Moreno\nMedellin','2025-11-11','',869,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(87,'Yanet Jazmin Hernandez Jaime','','2294498438','Hungria Norte 49023 #3\nLagos de Puente Moreno\nMedellin','2025-11-10','',868,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(88,'Lizett Jazmin Iriarte Martinez','','2295295330','Inglaterra sur 50216 #6\nLagos de Puente Moreno\nMedellin','2025-11-10','',867,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(89,'Emmanuel Aguirre Hernandez','','2282542176','Hungria Norte 49013 #4\nLagos de Puente Moreno\nMedellin','2025-11-08','',866,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(90,'Jessica Alejandra Flores Fentanes','','2291288487','Holanda Norte 49407 #1\nLagos de Puente Moreno\nMedellin','2025-11-08','',865,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(91,'Ana Lilia Rodriguez Enriquez','','2291421802','Croacia Este 79\nLagos de Puente Moreno\nMedellin','2025-11-07','',864,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(92,'Palapa rio tonto','','',NULL,'2025-11-07','',863,'2026-01-19 05:02:56','2026-01-19 07:27:22'),
(93,'Jessica Morales Zamudio','','2294109578','Hungria Norte 49126 #2\nLagos de Puente Moreno\nMedellin','2025-11-07','',862,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(94,'Leydi Yireth Chaga Copete','','2941273969','Hungria Norte 49108 #1\nLagos de Puente Moreno\nMedellin','2025-11-06','',861,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(95,'Gladys Marquez Garcia','','2297471171','Holanda sur 49810 #3\nLagos de Puente Moreno\nMedellin','2025-11-05','',860,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(96,'Jose Eduardo Avila Sanchez','','2297716185','Independencia 29 #2\nCol. Rio Jamapa\nBoca del Rio','2025-11-05','',859,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(97,'Eduardo Enrique Anel Aguilar','','2293708058','Hungria Norte 491-06-1\nLagos de Puente Moreno\nMedellin','2025-11-04','',858,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(98,'Sergio Cruz Zameza','','5665863967','Col. Ricardo Flores Magon\nCol. Ricardo Flores Magon\nBoca del Rio','2025-11-04','',857,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(99,'Geronima Baizabal Beristain','','2293914541','Hungria Norte 49021 #3\nLagos de Puente Moreno\nMedellin','2025-10-30','',856,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(100,'Fabiola Rodriguez Rodriguez','','2294184277','Turquesa Sur 42123 #3\nLagos de Puente Moreno\nMedellin','2025-10-30','',855,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(101,'Rosa Anahi Nuñez Rosas','','2295232725','Holanda Centro 49609 #4\nLagos de Puente Moreno\nMedellin','2025-10-29','',854,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(102,'Cesar Flores Ramirez','','2293381044','Hungria sur 49125 #4\nLagos de Puente Moreno\nMedellin','2025-10-25','',853,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(103,'Esperanza Araceli Sanchez Aparicio','','5517895444','Hungria sur 49121 #3\nLagos de Puente Moreno\nMedellin','2025-10-25','',852,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(104,'Juana Flores Pacheco','','5634932407','Hungria Norte 49118 #1\nLagos de Puente Moreno\nMedellin','2025-10-24','',851,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(105,'Maria Esther Cozar Valenzuela','','2294362436','Belice Sur 43618 #6\nLagos de Puente Moreno\nMedellin','2025-10-23','',850,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(106,'Gisel Montes Isidoro','','2297693490','Hungria Norte 49108 #3\nLagos de Puente Moreno\nMedellin','2025-10-23','',849,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(107,'Gertrudis Ballado Cortes','','2291327717','Hungria Norte 49009 #2\nLagos de Puente Moreno\nMedellin','2025-10-23','',848,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(108,'Rosa Morales Conde','','2294013076','Hungria Norte 49108 #4\nLagos de Puente Moreno\nMedellin','2025-10-22','',847,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(109,'David Tejeda Lopez','','2294472693','Belice Norte 42315 #2\nLagos de Puente Moreno\nMedellin','2025-10-22','',846,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(110,'Maria Guadalupe Del Campo Villalobos','','2295237807','Hungria Norte 49017 #4\nLagos de Puente Moreno\nMedellin','2025-10-22','',845,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(111,'Alvaro Xolo Velazco','','2941324431','Inglaterra  Sur 50107 #5\nLagos de Puente Moreno\nMedellin','2025-10-22','',844,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(112,'Blanca Peña Ramon','','2294194788','Turquesa Norte 42106 #5\nLagos de Puente Moreno\nMedellin','2025-10-20','',843,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(113,'VakaTurquesa','','',NULL,'2025-10-20','',842,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(114,'Moises Perez Garcia','','2295160602','Hungria Norte 49025 #4\nLagos de Puente Moreno\nMedellin','2025-10-20','',841,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(115,'Victor Jesus Caceres Chavez','','8446095322','Calzada Del Sol 53007 #5\nLagos de Puente Moreno\nMedellin','2025-10-18','',840,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(116,'Marcela Isabel Quiñones Ambrocio','','2291273715','Africa Sur 313 62\nLagos de Puente Moreno\nMedellin','2025-10-18','',839,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(117,'Maria Enriqueta Toral Anell','','2295283675','Hungria Oeste 48930 #5\nLagos de Puente Moreno\nMedellin','2025-10-17','',838,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(118,'Carlos Eduardo Mejia Mata','','2295243793','Calzada Del Sol 53017 #5\nLagos de Puente Moreno\nMedellin','2025-10-17','',837,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(119,'Elizabeth Lara Yepez','','2294055160','Kerps Norte 35 357\nLagos de Puente Moreno\nMedellin','2025-10-17','',836,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(120,'Nancy Andrade Sayago','','2294101485','Belgica Sur 74\nLagos de Puente Moreno\nMedellin','2025-10-16','',835,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(121,'Jose Antonio Arrieta Rodriguez','','2299037959','Hungria Sur 49127 #3\nLagos de Puente Moreno\nMedellin','2025-10-15','',834,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(122,'Rodrigo Hernandez Torres','','2292451281','Calzada Del Sol 53015 #1\nLagos de Puente Moreno\nMedellin','2025-10-15','',833,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(123,'Jairo David Vicente Martinez','','2294588429','Hungria Norte #2 Lote 12 MZA 491\nLagos de Puente Moreno\nMedellin','2025-10-15','',832,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(124,'Cynthia Paola Ortiz Duarte','','2294770491','Granate Norte 22311 #1\nLagos de Puente Moreno\nMedellin','2025-10-15','',831,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(125,'Norma Yamileth Mantilla Medina','','2941027905','Ribera Laguna VI Sur 28\nLagos de Puente Moreno\nMedellin','2025-10-15','',830,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(126,'Gloria Hernandez Zamora','','2291768208','Calz. Del Sol 53033 #6\nLagos de Puente Moreno\nMedellin','2025-10-14','',829,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(127,'Jesus Meza Aguilar','','2299091392','Hungria Norte 49114 #3\nLagos de Puente Moreno\nMedellin','2025-10-14','',828,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(128,'Berenice Jiloteo Hernandez','','2295234955','Hungria Norte 49114 #6\nLagos de Puente Moreno\nMedellin','2025-10-14','',827,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(129,'Javier Velazquez Perez','','2294638982','Luxemburgo Sur 50721 #1\nLagos de Puente Moreno\nMedellin','2025-10-13','',826,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(130,'Ivan Ruiz Salazar','','2292102987','Hungria Oeste 48942 #3\nLagos de Puente Moreno\nMedellin','2025-10-11','',825,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(131,'Alondra Isabel Torres Trinidad','','2293612655','Jardin De San Andres 80\nArboleda San Ramon\nMedellin','2025-10-10','',824,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(132,'Eliseo Lazaro Pascual','','2292111569','Hungria Norte 49128 #2\nLagos de Puente Moreno\nMedellin','2025-10-10','',823,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(133,'Leonardo Ramirez Aguilera','','2293168748','Luxemburgo Norte 50730 #4\nLagos de Puente Moreno\nMedellin','2025-10-10','',822,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(134,'Maria De La Luz Ordaz Ortega','','2292385191','Calzada Del Sol 52969 #5\nLagos de Puente Moreno\nMedellin','2025-10-10','',821,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(135,'Maria Anel Moreno Colorado','','2204839635','Granate Sur 22714  # 6\nLagos de Puente Moreno\nMedellin','2025-10-09','',820,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(136,'Luis Angel Cazarez Ramirez','','2291267012','Holanda Norte 49415 #1\nLagos de Puente Moreno\nMedellin','2025-10-09','',819,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(137,'Jose Carlos Rosado Lagunes','','2281729709','Holanda Norte 49427 #2\nLagos de Puente Moreno\nMedellin','2025-10-09','',818,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(138,'Gilberto Lucho Ricardo','','2291902622','Belgica Sur 13\nLagos de Puente Moreno\nMedellin','2025-10-08','',817,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(139,'Mara Castillo Guzman','','2961029198','Hungria Norte 49108 #6\nLagos de Puente Moreno\nMedellin','2025-10-07','',816,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(140,'JeremiasElectrico','','',NULL,'2025-10-06','',815,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(141,'OscarElectrico','','',NULL,'2025-10-06','',814,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(142,'Mireya Fernandez Peña','','2291845138','Jodguez 38 ESQ INDEP\nCol. Rio Jamapa\nBoca del Rio','2025-10-04','',813,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(143,'Alexander Alvarado Guerra','','2851013762','Granate Sur 22605 #3\nLagos de Puente Moreno\nMedellin','2025-10-03','',812,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(144,'Johana Vazquez Ortega','','7831390859','Hungria Norte 49128 #4\nLagos de Puente Moreno\nMedellin','2025-10-01','',811,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(145,'ARANZA RODRIGUEZ ANSENCION','','2292430249','C10 España Norte 20\nLagos de Puente Moreno\nMedellin','2025-10-01','',810,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(146,'Dana Julia Aleman Gonzalez','','2296050880','Irlanda Norte 51412 #4\nLagos de Puente Moreno\nMedellin','2025-09-30','',809,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(147,'Beatriz Cruz Enriquez','','2292782757','Granate Sur 22606 #1\nLagos de Puente Moreno\nMedellin','2025-09-30','',808,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(148,'Jessica Cruz Hernandez','','2293626199','Hungria Sur,manz.491,transf.E48 y E63\nLagos de Puente Moreno\nMedellin','2025-09-30','',807,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(149,'gidomare2025','','',NULL,'2025-09-29','',806,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(150,'Sheyla Bello Elvira','','2881399013','Hungria Norte 49106 #2\nLagos de Puente Moreno\nMedellin','2025-09-29','',805,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(151,'Jose Antonio Polito Antemate','','2291529012','Hungria Norte 49106 #3\nLagos de Puente Moreno\nMedellin','2025-09-29','',804,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(152,'Ximena Del Carmen Campos Garcia','','2292213743','Hungria Norte 491 #6\nLagos de Puente Moreno\nMedellin','2025-09-29','',803,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(153,'Reina Esperanza Mata Guevara','','2293380476','CTO Granate Sur 22607 #6\nLagos de Puente Moreno\nMedellin','2025-09-27','',802,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(154,'Mayte Herrera Castro','','2292295556','Holanda Norte 49409 #2\nLagos de Puente Moreno\nMedellin','2025-09-26','',801,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(155,'Perrita','','',NULL,'2025-09-25','',800,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(156,'Javier Eduardo Antonio Ortega','','2292258983','Irlanda Sur 55510 #6\nLagos de Puente Moreno\nMedellin','2025-09-25','',799,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(157,'Maribel Rosado Tello','','2295298850','Hungria Norte 49122 #6\nLagos de Puente Moreno\nMedellin','2025-09-24','',798,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(158,'Gustavo Herrera Rodriguez','','2711244771','Hungria Sur 49220 #1\nLagos de Puente Moreno\nMedellin','2025-09-24','',797,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(159,'Christian Alexa Cruz Rojas','','2291848301','Hungria Norte 49126 #1\nLagos de Puente Moreno\nMedellin','2025-09-23','',796,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(160,'Edwin Uriel Erceg Rosales','','2205253392','Calzada Del Sol 52965 #3\nLagos de Puente Moreno\nMedellin','2025-09-22','',795,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(161,'Artemio Romero Torres','','2291287586','Hungria Sur 49121 #1\nLagos de Puente Moreno\nMedellin','2025-09-22','',794,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(162,'Luis Edurardo Morales Montero','','2291769940','Holanda Sur 49820 #2\nLagos de Puente Moreno\nMedellin','2025-09-20','',793,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(163,'Sandra Paola Abrego Rodriguez','','2299285652','Holanda Norte 49407 #4\nLagos de Puente Moreno\nMedellin','2025-09-19','',792,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(164,'Joseline Pacheco Madero','','2294130379','Hungria Sur 49105 #3\nLagos de Puente Moreno\nMedellin','2025-09-19','',791,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(165,'Maria Elena Morales Bravo','','2292691602','Hungria Sur 49208 #1\nLagos de Puente Moreno\nMedellin','2025-09-19','',790,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(166,'Maria Del Pilar Rivera Ortiz','','2293904999','Urio L 1 Nardo Cjon S Nombre\nPaso Colorado\nBoca del Rio','2025-09-18','',789,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(167,'Lucia Lugo del Angel','','7822001888','Hungria Sur 49117 #3\nLagos de Puente Moreno\nMedellin','2025-09-18','',788,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(169,'Esteban Esmediche Campos','','2295496949','Hungria Sur 49119 #1\nLagos de Puente Moreno\nMedellin','2025-09-15','',786,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(170,'Christian Vazquez Chavez','','2291623896','Hungria Sur 49119 #5\nLagos de Puente Moreno\nMedellin','2025-09-15','',785,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(171,'Jose Joaquin Contreras Estrada','','2298188856','Holanda Norte 15 #3\nLagos de Puente Moreno\nMedellin','2025-09-15','',784,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(172,'Fernando Moises Torres Trinidad','','2294813784','Hungria Sur 49121 #6\nLagos de Puente Moreno\nMedellin','2025-09-15','',783,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(174,'Ismael Jimenez Rivas','','2294593788','Hungria Oeste 48942 #5\nLagos de Puente Moreno\nMedellin','2025-09-13','',781,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(175,'Selina Arellano Perez','','2299001916','Hungria Sur 16 #3\nLagos de Puente Moreno\nMedellin','2025-09-13','',780,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(176,'Jose Turincio Rojas','','2292232541','Hungria Sur 49127 #2\nLagos de Puente Moreno\nMedellin','2025-09-12','',779,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(177,'Luis Mario Montes Garcia','','2292462620','Hungria Oeste 38 #4\nLagos de Puente Moreno\nMedellin','2025-09-11','',778,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(178,'Stephanie Alejandra Martinez Inclan','','2292136673','España Norte 35\nLagos de Puente Moreno\nMedellin','2025-09-10','',777,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(179,'Valeria Alvarez Leyva','','2291291321','Hungria Sur 3 #2\nLagos de Puente Moreno\nMedellin','2025-09-09','',776,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(180,'José Antonio Uscanga Hernandez','','2291600175','Oasis De Ombu 91 MZA 55 LTE 96\nArboleda San Ramon\nMedellin','2025-09-09','',775,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(181,'MelanieMorenoAra','','2294779708',NULL,'2025-09-08','',774,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(182,'Jan Carlos Gonzalez Meza','','5649574465','Hungria Sur 49101 #1\nLagos de Puente Moreno\nMedellin','2025-09-08','',773,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(183,'Carlos Javier Torres Urbano','','2203351039','Luxemburgo Sur 50828 #4\nLagos de Puente Moreno\nMedellin','2025-09-06','',772,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(184,'Efren Trujillo Jimenez','','2295254158','Holanda Norte 49417 #4\nLagos de Puente Moreno\nMedellin','2025-09-06','',771,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(185,'Jorge Lorenzo Tejeda Chacon','','2202548367','Holanda Centro 49605 #5\nLagos de Puente Moreno\nMedellin','2025-09-06','',770,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(186,'Felix Camarero Yepez','','2971086171','Holanda Sur 49731 #4\nLagos de Puente Moreno\nMedellin','2025-09-05','',769,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(187,'Jajaira Valerio Castro','','2295297575','Holanda Sur 49814 #4\nLagos de Puente Moreno\nMedellin','2025-09-05','',768,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(188,'Esperanza Cozar Fernandez','','8711241807','Hungria Sur 49212 #1\nLagos de Puente Moreno\nMedellin','2025-09-05','',766,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(189,'Georgina Palacios Zurita','','2296031640','Hungria Sur 49218 #6\nLagos de Puente Moreno\nMedellin','2025-09-05','',765,'2026-01-19 05:02:57','2026-01-19 07:27:22'),
(190,'Miriam Odett Gonzalez Pavon','','2299304304','Hungria Sur 49214 #4\nLagos de Puente Moreno\nMedellin','2025-09-04','',764,'2026-01-19 05:02:58','2026-01-19 07:27:22'),
(191,'Ma. Del Carmen Sanchez Varela','','2298589497','España Norte 42 M-545 L-42\nLagos de Puente Moreno\nMedellin','2025-09-04','',763,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(192,'Jania Del Carmen Tomin Moto','','2296459677','CTO Belice Norte 43422 #5\nLagos de Puente Moreno\nMedellin','2025-09-03','',762,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(193,'María Fernanda Aguirre Perez','','2292438714','Alemania Centro 29\nLagos de Puente Moreno\nMedellin','2025-09-03','',761,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(194,'Gretel Monserrat Guzman Araus','','2292771821','Hungria Sur 12 #6\nLagos de Puente Moreno\nMedellin','2025-09-03','',760,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(195,'Cristian Sosa Granados','','5626224662','Rivera De La Laguna VI Ubicado En El Lote Condominal 1 De La Super-Manzana 384\nLagos de Puente Moreno\nMedellin','2025-09-02','',758,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(196,'Clara Cecilia Lara Barradas','','2299510579','Hungria Sur 49220 #5\nLagos de Puente Moreno\nMedellin','2025-09-01','',757,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(197,'Jazmin Garrido Leal','','2295307807','Holanda Este 49519 #4\nLagos de Puente Moreno\nMedellin','2025-09-01','',756,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(198,'Viridiana Salas Mora','','9212742081','Hungria Sur 23 #4\nLagos de Puente Moreno\nMedellin','2025-09-01','',755,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(199,'Diana Ramon Hernadez','','2297003583','Hungria Sur 49109 #3\nLagos de Puente Moreno\nMedellin','2025-09-01','',754,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(200,'Jeronimo Morales Salgado','','2299135136','Hungria Sur 49117 #5\nLagos de Puente Moreno\nMedellin','2025-09-01','',753,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(201,'DonaIme','','2295298838',NULL,'2025-08-30','',752,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(202,'Fabiola Nava Hernandez','','2299409632','Independ 11 Naranjos Dguez\nCol. Rio Jamapa\nBoca del Rio','2025-08-29','',751,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(203,'Edmon Joseph De Jesus Sixteco Cortez','','2297231876','Inglaterra NTE 50027 #5\nLagos de Puente Moreno\nMedellin','2025-08-29','',750,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(204,'Verenice Espinoza Ultrera','','2292509020','Belice Norte 43410 #2\nLagos de Puente Moreno\nMedellin','2025-08-28','',749,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(205,'Ruben Resendiz Beldaño','','5616637341','Calzada Del Sol 53013 #3\nLagos de Puente Moreno\nMedellin','2025-08-28','',748,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(206,'Dolores Ramirez Brito','','2291081768','Hungria Sur 49214 #3\nLagos de Puente Moreno\nMedellin','2025-08-28','',747,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(207,'Magdalena Correa Perez','','2294201249','Hungria Sur 12 #2\nLagos de Puente Moreno\nMedellin','2025-08-28','',746,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(208,'Juan Carlos Fernandez De Lara Barrera','','5518289246','Hungria Oeste MZ.489 Lt.42 Prototipo Sextuple, Interior 1\nLagos de Puente Moreno\nMedellin','2025-08-27','',745,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(209,'Karina Guadalupe Mora Malpica','','2294026406','Hungria Sur 49111 #5\nLagos de Puente Moreno\nMedellin','2025-08-27','',744,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(210,'Ramon Salazar Pastrana','','2294483043','Hungria Oeste 48838 #2\nLagos de Puente Moreno\nMedellin','2025-08-26','',743,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(211,'Estefany Lizeth Flores Castro','','2299068870','Hungria Sur 3 #1\nLagos de Puente Moreno\nMedellin','2025-08-26','',742,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(212,'Alejandro David Urbano Porras','','2295267700','Hungria Sur 11 #3\nLagos de Puente Moreno\nMedellin','2025-08-26','',740,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(213,'Elvira Landa Lopez','','5518549597','Hungria Oeste 34 #1\nLagos de Puente Moreno\nMedellin','2025-08-26','',739,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(214,'Gabriela Belli Antele','','2941687929','Hungria Sur 25 #2\nLagos de Puente Moreno\nMedellin','2025-08-26','',738,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(215,'Gidomare','','',NULL,'2025-08-26','',737,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(216,'Paloma Morales Palma','','2291528359','Lagos de Puente Moreno\nMedellin','2025-08-26','',736,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(217,'Paloma Morales Palma','','2291528359','Hungria Sur 26 #1\nLagos de Puente Moreno\nMedellin','2025-08-25','',735,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(218,'AlmaDelfinaAma','','2294195291',NULL,'2025-08-23','',734,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(219,'Irving Yahir Trujillo Utrera','','2291178299','Calzada Del Sol 52947 #2\nLagos de Puente Moreno\nMedellin','2025-08-22','',733,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(220,'Rafael Herrera Aldana','','2293313059','Irlanda Norte 51305 #3\nLagos de Puente Moreno\nMedellin','2025-08-22','',732,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(221,'Arturo Alexander Maxil Hernandez','','2223638933','Hungria Oeste 48940 #1\nLagos de Puente Moreno\nMedellin','2025-08-22','',731,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(222,'Graciela Guzman Gomez','','2851105996','Irlanda Norte  51317 #5\nLagos de Puente Moreno\nMedellin','2025-08-21','',730,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(223,'Edwin Moises Romero Altamirano','','2292686830','Hungria Sur 49111 #6\nLagos de Puente Moreno\nMedellin','2025-08-20','',729,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(224,'Martha Lucia Echevarria Betanzo','','2291185073','Noruega Sur 52704 #3\nLagos de Puente Moreno\nMedellin','2025-08-20','',728,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(226,'Elide Martinez Lara','','2293437879','Hungria Sur 21 #4\nLagos de Puente Moreno\nMedellin','2025-08-18','',726,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(227,'Rosa Maria Serrano Ramirez','','2291470150','Hungria Sur 49127 #4\nLagos de Puente Moreno\nMedellin','2025-08-18','',725,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(229,'Ricardo Jair Barragan Rodriguez','','2731272944','Hungria Sur 10 #6\nLagos de Puente Moreno\nMedellin','2025-08-15','',723,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(231,'Alejandra Acosta','','2294468497',NULL,'2025-08-15','',721,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(232,'Itzel Paola ventura Medina','','2294828634','Holanda Norte 49419 #1\nLagos de Puente Moreno\nMedellin','2025-08-14','',720,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(233,'Maria De La Paz Ramirez Carmona','','2294774549','Hungria Sur 1 #2\nLagos de Puente Moreno\nMedellin','2025-08-14','',719,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(234,'Carolina Garcia Monge','','2294386247','Hungria Sur 3 #3\nLagos de Puente Moreno\nMedellin','2025-08-13','',717,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(235,'Rosario Aldeco Rendon','','2297671166','Hungria Sur 49123 #6\nLagos de Puente Moreno\nMedellin','2025-08-12','',716,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(236,'Dafne Pahola Vazquez Chavez','','2299006117','Hungria Sur,manz.492 y 489, transf. E48A y E63A\nLagos de Puente Moreno\nMedellin','2025-08-12','',715,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(237,'Sarai Neri sanchez','','2294122052','Hungria Norte 49210 #5\nLagos de Puente Moreno\nMedellin','2025-08-12','',714,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(238,'Maria Guadalupe Muños Ramirez','','2297161718','Calzada Del Sol 52957 #1\nLagos de Puente Moreno\nMedellin','2025-08-12','',713,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(239,'David Osiris Lazaro Moto','','2841092781','Hungria Sur 49230 #1\nLagos de Puente Moreno\nMedellin','2025-08-11','',712,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(240,'Dayra Melissa Santos Lara','','2293158310','Hungria Sur 49230 #4\nLagos de Puente Moreno\nMedellin','2025-08-11','',711,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(241,'Alexander Chaga Copete','','2297168718','Hungria Sur 49218 #2\nLagos de Puente Moreno\nMedellin','2025-08-09','',710,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(242,'Lorenzo Antonio De La O Andrade','','2291472946','Topacio Norte MZA 418 L 2 N 2\nLagos de Puente Moreno\nMedellin','2025-08-09','',709,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(244,'HamDimasMorro','','',NULL,'2025-08-08','',707,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(245,'Gisela Virgen Catarino','','',NULL,'2025-08-08','',706,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(246,'Daniela Torres Carvajal','','',NULL,'2025-08-08','',705,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(247,'Susana Huerta Reyes','','2295228309',NULL,'2025-08-08','',704,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(248,'YeseniaAbigailFue','','2294370800',NULL,'2025-08-07','',703,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(249,'Tomas Rivera Contreras','','2292597568','Holanda Norte 49427 #5\nLagos de Puente Moreno\nMedellin','2025-08-07','',702,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(250,'GustavoRomamGuz','','2299291286',NULL,'2025-08-06','',701,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(251,'IsabelCruzVel','','2291120917',NULL,'2025-08-06','',700,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(252,'Veronica Soto Cazarin','','2294512692','Hungria Sur 22 #6\nLagos de Puente Moreno\nMedellin','2025-08-05','',699,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(253,'Aracely Temich Tostega','','2949487331','Hungria Sur 49222 #2\nLagos de Puente Moreno\nMedellin','2025-08-05','',698,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(254,'Ivonne Liseth Pineda Morales','','6142404809','Hungria Sur 49208 #2\nLagos de Puente Moreno\nMedellin','2025-08-01','',696,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(255,'Angel De Jesus Muños Peralta','','2291700029','Hungria Sur 12 #5\nLagos de Puente Moreno\nMedellin','2025-08-01','',695,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(256,'Belem Bustamante Barrios','','2941526206','Holanda Norte 3 #5\nLagos de Puente Moreno\nMedellin','2025-07-31','',694,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(257,'Ricardo Adiel Velasco Garcia','','2294490243','Holanda Norte 13 #5\nLagos de Puente Moreno\nMedellin','2025-07-28','',692,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(258,'Laura Irais Medrano Blanco','','2295122613','V Muerta EDIF 2052 101 CP 00 ESQ Goletas\nEl Morro\nBoca del Rio','2025-07-28','',691,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(259,'Leticia Perez Sosa','','2297762752','Holanda Norte 49411 #2\nLagos de Puente Moreno\nMedellin','2025-07-25','',690,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(260,'Eraquia Merida Remigio','','2293238553','Holanda Norte 31 #1\nLagos de Puente Moreno\nMedellin','2025-07-25','',689,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(261,'Karla Ramos Salamanca','','2881029104','Paseo Boca Del Rio 53. Entre Acayucan. Fracc. La Tampiquera\nBoca del Rio, Veracruz\nBoca del Rio','2025-07-24','',688,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(262,'Lady Del Carmen Villalobos Balderas','','5591850059','Holanda Este 49513 #3\nLagos de Puente Moreno\nMedellin','2025-07-23','',687,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(263,'Abigail Luna Antonio','','2291867613','Irlanda Norte 51327 #3\nLagos de Puente Moreno\nMedellin','2025-07-23','',686,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(264,'Jany Lagunes Tellez','','2291046872','Holanda Norte 49433\nLagos de Puente Moreno\nMedellin','2025-07-17','',682,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(265,'Mildreth Mariana Pichardo Herrera','','2294042452','Holanda Norte 33 #3\nLagos de Puente Moreno\nMedellin','2025-07-17','',681,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(266,'Amparo Chavez Martinez','','2299097282','Monaco Norte 52110 #2\nLagos de Puente Moreno\nMedellin','2025-07-16','',680,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(267,'Antonio de Jesus Cabrera Guerrero','','2293646195','Jm Morelos 13 Rio Moreno R COR R Cortinez\nCol. Ricardo Flores Magon\nBoca del Rio','2025-07-12','',679,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(268,'IrwingGut','','2292124576','Col Ricardo flores magon','2025-07-09','',678,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(269,'Rosa Maria Morales Pantoja','','2299587402','Holanda centro 49722 #2\nLagos de Puente Moreno\nMedellin','2025-07-04','',676,'2026-01-19 05:02:58','2026-01-19 07:27:23'),
(270,'Beatriz Perez Gutierrez','','2294025927','Calzada Del Sol 52971 #6\nLagos de Puente Moreno\nMedellin','2025-07-02','',675,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(271,'TomasRodriguez','','',NULL,'2025-07-01','',674,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(272,'Raquel Morales Guatzozon','','2293390013','Horlanda Este 13 #5\nLagos de Puente Moreno\nMedellin','2025-06-28','',673,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(273,'Alexis Jair Hernandez Rodriguez','','2294367739','Holanda Este 13 #6\nLagos de Puente Moreno\nMedellin','2025-06-28','',672,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(274,'John Jairo Guzman Garcia','','2351141615',NULL,'2025-06-25','',671,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(275,'Ingrid Karina Rivera Mendez','','4775767527','Holanda Norte 11 #5\nLagos de Puente Moreno\nMedellin','2025-06-25','',670,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(276,'Rodrigo Rodriguez Cancino','','2299074614','Holanda Este 49521 #6\nLagos de Puente Moreno\nMedellin','2025-06-24','',669,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(277,'Baltazar Alarcon Rios','','2296020263','Holanda Este 49521 #5\nLagos de Puente Moreno\nMedellin','2025-06-24','',668,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(278,'Carlos Daniel Marinero Ponce','','2293462853','Holanda Norte 13 #4\nLagos de Puente Moreno\nMedellin','2025-06-23','',667,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(279,'Candelaria Correa Perez','','2293683107','Holanda Centro 49718 #3\nLagos de Puente Moreno\nMedellin','2025-06-21','',666,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(280,'Oscar Manuel Gomez Diaz','','2294334565','Holanda Norte 49409 #1\nLagos de Puente Moreno\nMedellin','2025-06-20','',665,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(281,'Irwing De Jesus Hernandez Escobar','','2291486257','Holanda Centro 49708 2 M-497 Departamento 2\nLagos de Puente Moreno\nMedellin','2025-06-19','',664,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(282,'Jorge Muñoz Villagrana','','2291314828','Rio Moreno 20 C ESQ J Escutia\nCol. Ricardo Flores Magon\nBoca del Rio','2025-06-18','',663,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(283,'Jose Alfredo Huesca Lopez','','2291051637','Holanda Centro 49718 #4\nLagos de Puente Moreno\nMedellin','2025-06-17','',662,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(284,'Hernan Hermida Uscanga','','2979757477','Holanda Centro 49718 #1\nLagos de Puente Moreno\nMedellin','2025-06-17','',661,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(285,'Enrique Ortega Avila','','2284807980','Holanda Norte 49405 #6\nLagos de Puente Moreno\nMedellin','2025-06-17','',659,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(286,'Zaira Lozano Nava','','2294837279','Holanda Este 49521 #3\nLagos de Puente Moreno\nMedellin','2025-06-17','',658,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(287,'Sheila Ivone Prieto Ortiz','','2293392335','Holanda Centro 49603 #6\nLagos de Puente Moreno\nMedellin','2025-06-16','',657,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(288,'Itzel Carmina Hernandez Vargas','','2294183403','Holanda Centro 49714 #6\nLagos de Puente Moreno\nMedellin','2025-06-14','',656,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(289,'WendyBer','','2293187323',NULL,'2025-06-05','',654,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(290,'YolandaRam','','2741355142',NULL,'2025-06-02','',652,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(291,'Jonathan Arturo Ruiz Vallejo','','2295302558','Holanda Centro 49712 #4\nLagos de Puente Moreno\nMedellin','2025-05-29','',651,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(292,'JorgeP2','','',NULL,'2025-05-28','',650,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(293,'Jobanni Guillen Ochoa','','2291242220','Bulgaria Sur 58\nLagos de Puente Moreno\nMedellin','2025-05-23','',646,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(294,'Torrepc2','','',NULL,'2025-05-21','',645,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(295,'Adayleth Escarpeta Estudillo','','2291487881','Noruega Este 52815 #2\nLagos de Puente Moreno\nMedellin','2025-05-20','',644,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(296,'Jose Eduardo Segovia Carino','','2294394558','Circuito Colombia 44012 #6\nLagos de Puente Moreno\nMedellin','2025-05-20','',643,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(297,'DayanaD','','',NULL,'2025-05-19','',642,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(298,'SusanaTovar','','2941468301',NULL,'2025-05-15','',640,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(299,'LuisEnriqueP','','2299686656',NULL,'2025-05-05','',635,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(300,'Roxana Palacios Flores','','2298701018','Holanda Centro 49710 #4\nLagos de Puente Moreno\nMedellin','2025-05-02','',633,'2026-01-19 05:02:59','2026-01-19 07:27:23'),
(301,'Donjuve','','',NULL,'2025-05-02','',632,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(302,'Leticia Gutierrez Campechano','','2293998431','C Fernando Lopez Arias 38\nCol. Ricardo Flores Magon\nBoca del Rio','2025-05-02','',630,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(303,'WilfridoA','','8993052943',NULL,'2025-04-30','',629,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(304,'Jovana De La Paz Rosaldo Gonzalez','','2296019693','Alemania Centro  53\nLagos de Puente Moreno\nMedellin','2025-04-29','',627,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(305,'Hector Rafael Roaro Reyna','','2294167358','Bulgaria Sur 12\nLagos de Puente Moreno\nMedellin','2025-04-22','',625,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(306,'Martha Berenice Vazquez Rodriguez','','2294504265','Bulgaria Sur 27\nLagos de Puente Moreno\nMedellin','2025-04-21','',622,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(307,'Rosalba Mercado Gonzalez','','2294831499','Bulgaria Sur 34\nLagos de Puente Moreno\nMedellin','2025-04-19','',620,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(308,'Melissa Ascencio Bravo','','2294339720','Bulgaria Sur 47\nLagos de Puente Moreno\nMedellin','2025-04-19','',618,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(309,'Martha Elena Romero Hernandez','','2294142936','Cjon Morelos 2 Cortin PVDA  ABA\nCol. Rio Jamapa\nBoca del Rio','2025-04-17','',617,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(310,'Hugo Toxtega Toxtega','','2293714995','Italia Sur 51017 #3\nLagos de Puente Moreno\nMedellin','2025-04-12','',613,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(311,'Lilibeth Raymundo Lopez','','2291730315','Monaco Sur 52113 #3\nLagos de Puente Moreno\nMedellin','2025-04-09','',610,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(312,'Maile Samantha Uscanga Martinez','','2294502065','Holanda Centro 49714 #2\nLagos de Puente Moreno\nMedellin','2025-04-05','',607,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(313,'Karen Lizbeth Mendez Garcia','','2293930968','Holanda Centro 49704 #6\nLagos de Puente Moreno\nMedellin','2025-04-03','',604,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(314,'Marcos Ramirez Gonzalez','','2293699765','Topacio 42010-5\nLagos de Puente Moreno\nMedellin','2025-04-02','',603,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(315,'Wendy Torre Granate','','',NULL,'2025-04-02','',602,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(316,'Maria Isabel Cruz','','2291418565','Belgica Oeste 32','2025-04-02','',601,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(317,'Aiko Desiree Uscanga Amaya','','2294070164','Holanda Este 49503 #2\nLagos de Puente Moreno\nMedellin','2025-04-01','',600,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(318,'Cristian Del Rocio','','2294529934','Holanda Centro 49702 #2\nLagos de Puente Moreno\nMedellin','2025-04-01','',599,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(319,'Eduardo Duran Rodriguez','','2292212303','Holanda Este 49509 #5\nLagos de Puente Moreno\nMedellin','2025-04-01','',598,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(320,'Guadalupe Ramirez Magaña','','2294110816','Croacia Norte 16 M-542 L-16\nLagos de Puente Moreno\nMedellin','2025-03-31','',596,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(321,'Diner Ricardo Hernandez Mendoza','','2296474430','Holanda Este 49511 #6\nLagos de Puente Moreno\nMedellin','2025-03-31','',594,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(322,'oficina','','',NULL,'2025-03-29','',593,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(323,'TelvisRevolledo','','2293243989',NULL,'2025-03-27','',591,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(324,'Rocio Morales Lara','','2851017700','Holanda Sur 49717 #2\nLagos de Puente Moreno\nMedellin','2025-03-27','',590,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(325,'CapiPatraca','','',NULL,'2025-03-22','',588,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(326,'Ariam Pavon Mayoral','','2217078263','Calz Del Sol 52939 #4\nLagos de Puente Moreno\nMedellin','2025-03-21','',587,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(327,'Jesus Alberto García García','','2218759371','Calzada Del Sol 52969 #3\nLagos de Puente Moreno\nMedellin','2025-03-18','',586,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(328,'MayraRiveraL','','2291853963','Calzada del sol 53003 #2\nLagos de Puente Moreno\nMedellin','2025-03-14','',583,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(329,'Alfonso Vasquez Leal','','2291247326','Holanda Sur 49810 #2\nLagos de Puente Moreno\nMedellin','2025-03-07','',582,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(330,'Ana Alicia Garcia Hernandez','','2293022676','Inglaterra Sur 50212 #6\nLagos de Puente Moreno\nMedellin','2025-03-05','',581,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(331,'Reyna Yadira torres','','2292252115',NULL,'2025-03-03','',580,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(332,'Jair Arteaga Miron','','2294359259','Calzada Del Sol\nLagos de Puente Moreno\nMedellin','2025-03-01','',576,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(333,'Kevin Cesar Guzman Portela','','2295294005','Inglaterra NTE 50017 #6\nLagos de Puente Moreno\nMedellin','2025-02-19','',573,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(334,'Araceli Acosta Gonzalez','','2292703363','Holanda Sur 49717 #3\nLagos de Puente Moreno\nMedellin','2025-02-08','',567,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(335,'Flor Basilia Herrera Castillo','','2295940276','Luxemburgo Norte 50730 #2\nLagos de Puente Moreno\nMedellin','2025-02-06','',564,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(336,'Daniel Hernández Garcia','','2292916498','Luxemburgo Norte 50728 #4\nLagos de Puente Moreno\nMedellin','2025-02-06','',563,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(337,'AstiDom','','',NULL,'2025-02-04','',560,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(338,'David Landa Romero','','2296704995','Calzada Del Sol 53031 #4\nLagos de Puente Moreno\nMedellin','2025-02-03','',559,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(339,'Evelin Yarith Perez Torres','','2291474814','Saturno Oeste 15081 #1','2025-01-29','',558,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(340,'Fabiola Hernandez Ramos','','5951133251','Holanda Sur 49816 #5\nLagos de Puente Moreno\nMedellin','2025-01-29','',556,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(341,'Raymunda Sulamita Lopez Cisneros','','6563489465','Circuito Blegica Oeste Lote-36 MZ 359\nLagos de Puente Moreno\nMedellin','2025-01-28','',554,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(342,'Yuridia Chipuli Chavez','','2294852708','Holanda Sur 49707 #6\nLagos de Puente Moreno\nMedellin','2025-01-23','',551,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(343,'Jose Francisco Tenorio','','2941090247','Holanda Sur 49707 #1\nLagos de Puente Moreno\nMedellin','2025-01-22','',548,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(344,'Lorena Fernandez Garcia','','2292559030','Irlanda Sur 51419 #5\nLagos de Puente Moreno\nMedellin','2025-01-20','',545,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(345,'Claudia Carranza Carreto','','2299097349','Holanda Sur 49709 #4\nLagos de Puente Moreno\nMedellin','2025-01-17','',544,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(346,'Alfonso Iglesias Ambrocio','','2294639007','Holanda Sur 49830 #2\nLagos de Puente Moreno\nMedellin','2025-01-16','',538,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(347,'Aldo Said Cazarin Palacios','','2841065076','Holanda Sur 49711 #2\nLagos de Puente Moreno\nMedellin','2025-01-13','',535,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(348,'Tomas Quintana Ortela','','',NULL,'2025-01-13','',533,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(349,'Mariela Gonzalez Gonzalez','','2292570218','Holanda Sur 49824 #3\nLagos de Puente Moreno\nMedellin','2025-01-07','',528,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(350,'Estrella Garcia Del Valle','','2293114268','Holanda Sur 49719 #4\nLagos de Puente Moreno\nMedellin','2024-12-24','',521,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(351,'Miguel Quintana Perez','','2291819525','Alemania Centro 11 AV Europa Alemania Este\nLagos de Puente Moreno\nMedellin','2024-12-21','',519,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(352,'Nanci Rubi Joachin Aguilar','','2294524807','Diamante Centro 22005 #1\nLagos de Puente Moreno\nMedellin','2024-12-20','',515,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(353,'Yuliana Santiago Santiago','','2888835499','Holanda Sur 49826 #3\nLagos de Puente Moreno\nMedellin','2024-12-20','',514,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(354,'Saira Martinez Hernandez','','2294181437','Monaco Este 52027 #1\nLagos de Puente Moreno\nMedellin','2024-12-18','',512,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(355,'Emmanuel Herrera Barragan','','2292131771','Luxemburgo Sur 50802 #3\nLagos de Puente Moreno\nMedellin','2024-12-13','',508,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(356,'Topacio Shirley Basurto Barcelo','','2292212050','CTO Argentina Sur 43103 #3\nLagos de Puente Moreno\nMedellin','2024-12-10','',507,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(357,'Elizabeth Mercedes Seba Xolo','','2295307797','Holanda Sur 49814 #6','2024-12-07','',506,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(358,'Manuel Martinez Valerio','','2299685153','Inglaterra Sur 50105 #1','2024-12-07','',503,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(359,'Efrain Hernadez Lazaro','','2291079147','Calzada del Sol 53021 #4','2024-12-07','',500,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(360,'Lucia Toro Rodriguez','','2295229581','Calzada Del Sol 52959 #1\nLagos de Puente Moreno\nMedellin','2024-12-06','',494,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(361,'Alfredo Hernández Mendoza','','2281790047','Luxemburgo Sur 50816 #5\nLagos de Puente Moreno\nMedellin','2024-12-04','',492,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(362,'Angelica Dominguez Baxin','','2291591759','Noruega Norte 52625 #1\nLagos de Puente Moreno\nMedellin','2024-12-03','',491,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(363,'Marisol Pacheco Marrero','','2291067286','Noruega Sur 52724 #4\nLagos de Puente Moreno\nMedellin','2024-12-03','',490,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(364,'Mauricio Daniel Perez','','2292435697','calle del rastro casi esquina Ruiz cortinez','2024-12-02','',489,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(365,'Yazmin Alondra Lopez Hernandez','','2295737579','Calzada Del Sol 52965 #5\nLagos de Puente Moreno\nMedellin','2024-12-01','',488,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(366,'Cinthya Saray Sanchez Avila','','2207281481','Luxemburgo Norte 50716 #5\nLagos de Puente Moreno\nMedellin','2024-12-01','',484,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(367,'Ismael Crisanto Ramierz','','2296585892','Noruega Norte 52612#5','2024-12-01','',483,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(368,'Alan Vicente','','2297808864','Luxemburgo Sur 50802 #6','2024-12-01','',481,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(369,'Rosa Maria Marcial Martinez','','2291471850','Luxemburgo Sur 50806 #4\nLagos de Puente Moreno\nMedellin','2024-12-01','',480,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(370,'Marco Antonio Lopez','','2291323346','Noruega Sur 52716 #5','2024-12-01','',478,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(371,'Citlalli De los Angeles HernandezGarcia','','2226778941','Luxemburgo Sur 50826 #2\nLagos de Puente Moreno\nMedellin','2024-12-01','',477,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(372,'Mosheh Segura Ramirez','','',NULL,'2024-11-08','',476,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(373,'Abel Serrano Cruz','','2292280024','Noruega Norte 52509 #4\nLagos de Puente Moreno\nMedellin','2024-11-06','',474,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(374,'IndiraRaquelCasa','','',NULL,'2024-11-03','',473,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(375,'CDominguez','','',NULL,'2024-10-29','',471,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(376,'Luis Reynaldo Zarate','','2297962209','CJON Ignacio Zaragoza 33 Constitucion Y V Guerrero\nCol. Ricardo Flores Magon\nBoca del Rio','2024-10-25','',470,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(377,'Constantino Gutierrez Lara','','',NULL,'2024-10-19','',468,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(378,'Rafael Hernandez Carmona','','2291850627','Ruiz Cortinez 14\nCol. Ricardo Flores Magon\nBoca del Rio','2024-10-16','',467,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(379,'Mariano Rincon Hernandez','','2291469343','Fernando Casas Aleman #17\r\nCasi Esquina Ruiz Cortinez\nCol. Ricardo Flores Magon\nBoca del Rio','2024-10-16','',466,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(380,'Gdominguez','','','Fernando Casas Aleman #12','2024-10-15','',465,'2026-01-19 05:10:58','2026-01-19 07:27:25'),
(381,'casamama','','',NULL,'2024-10-12','',462,'2026-01-19 05:10:58','2026-01-19 07:27:26'),
(382,'autolavado','','',NULL,'2024-10-12','',460,'2026-01-19 05:10:58','2026-01-19 07:27:26'),
(383,'indiraraquel2','','',NULL,'2024-10-12','',459,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(384,'Marlen Pascual Carvajal','','',NULL,'2024-09-18','',443,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(385,'Diana Laura Ramirez Cruz','','',NULL,'2024-09-18','',444,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(386,'Miguel Angel Vazquez Lorenzo','','',NULL,'2024-09-18','',445,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(387,'Leonides Hernandez Gamboa','','',NULL,'2024-09-18','',446,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(388,'Esmirna Acevedo Sanchez','','',NULL,'2024-09-18','',447,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(389,'Adriana Moreno','','',NULL,'2024-09-18','',448,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(390,'Misael Mariano Reyes','','',NULL,'2024-09-18','',449,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(391,'Salon Ejidal Paso Rincon','','',NULL,'2024-09-18','',450,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(392,'Diana Cristal Antonio Ramirez','','',NULL,'2024-09-18','',451,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(393,'Angela Ansures Cipriano','','',NULL,'2024-09-18','',452,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(394,'Gabriela Martinez Catarino','','',NULL,'2024-09-18','',453,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(395,'Casilda Jimenez Ortigoza','','',NULL,'2024-09-18','',454,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(396,'Denisse Angelica Santiago','','',NULL,'2024-09-07','',441,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(397,'Jose Fermin Jimenez Sosa','','2295274035','Independencia 22 #2\nCol. Rio Jamapa\nBoca del Rio','2024-09-04','',440,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(398,'Nancy Yuliana Lazcano Rendon','','2293935846','Flor De Loto Numero Ext.1  Bugambilia Y Alcatraz\nPaso Colorado\nBoca del Rio','2024-08-06','',433,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(399,'Francisco de jesus Cortes Gomez','franciscogomezcc@hotmail.com','2293044406','Cto Alemania Norte #48\nLagos de Puente Moreno\nMedellin','2024-07-31','',429,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(400,'Maritza Isabel Martinez','maritmar150791@gmail.com','2293152283','Amapolas #1 Esq. Bugambilias\npaso colorado\nBoca del Rio','2024-07-30','',428,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(401,'Cinthya De Jesus Hernandez Ferrari','','2293916858','Bulgaria Sur 19\nLagos de Puente Moreno\nMedellin','2024-07-16','',424,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(402,'Ricardo Carmona Perez','','',NULL,'2024-06-11','',420,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(403,'Pedro Vazquez Martinez','','2297643047','Calzada del Sol  #5\nLagos de Puente Moreno\nMedellin','2024-06-10','',417,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(404,'Maria Del Carmen Serrano Perez','','2291580958','Amapolas 19 ESQ CJON S Nombre\nPaso Colorado\nBoca del Rio','2024-05-09','',413,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(405,'Aurora Banda Tejeda','','2294001425','Irlanda Sur 51526 #6\nLagos de Puente Moreno\nMedellin','2024-02-24','',402,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(406,'Nely Malpica','','',NULL,'2024-01-16','',398,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(407,'Indira Vega estetica','','',NULL,'2023-12-28','',396,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(408,'Ana Leticia Pile Tuxtla','','2731291977','Circuito La Parroquia, 336 - Fracc. Hacienda Roal\nHacienda La Parroquia\nVeracruz, Ver','2023-12-20','',395,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(409,'Alexis Cruz Lara','','2299842371','España Norte 5\nLagos de Puente Moreno\nMedellin','2023-12-12','',393,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(410,'Yeniffer Delgado','','2295131546','Luxemburgo 50824 #1\nLagos de Puente Moreno\nBoca del Rio','2023-07-25','',365,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(411,'Itai Tejeda Velarde','','2291744174','Italia Norte 51022 #1\nLagos de Puente Moreno\nboca del rio','2023-07-18','',360,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(412,'Yonathan Yahye Rosado Hernandez','','2295202674','Belgica Sur 78\nlagos de puente moreno\nboca del rio','2023-07-01','',359,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(413,'Zuriel Axel Arteaga Balderas','','2351123376','Inglaterra Sur 50224 #3\r\n19.095225,-96.1698941\nLagos de Puente Moreno\nMedellin','2023-04-21','',346,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(414,'Erika Gonzalez Vidal','','2293915416','Noruega Norte 52632 #6\r\n19.092625,-96.1679069\nLagos de Puente Moreno\nMedellin','2023-04-01','',336,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(415,'Lizeth Franco Vazquez','','2292098028','Ribera Laguna II Norte #37\r\n19.105454,-96.1648542\nLagos de Puente Moreno\nMedellin','2023-03-14','19.105454,-96.1648542',327,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(416,'Aldo Martinez Silvaran','','8115261006','Laguna de Cairel Sur #30\r\n19.101444,-96.1696532\nLagos de Puente Moreno\nMedellin','2023-03-14','19.101444,-96.1696532',326,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(417,'Adriana Hernadez Hernandez','adriianahernnandez5@gmail.com','8991820713','Noruega Norte 52602 #6\r\nGPON0/1:16\r\n19.093456,-96.1689405\nLagos de Puente Moreno\nMedellin','2023-03-14','',324,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(418,'Jose Angel Martinez Martinez','angel.mtz.mtz98@outlook.com','2299579083','Belgica Sur 33\r\n19.099678,-96.1691895\nLagos de Puente Moreno\nMedellin','2023-03-11','',315,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(419,'Gerardo Arellano Martinez','','','calle del trastro\r\n19.1076365,-96.1104738','2023-03-09','',313,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(420,'Antonio Covarrubias Velazquez','','2294161364','Luxemburgo sur 50816 v#3\r\n19.0933535,-96.1681786\nLagos de Puente Moreno\nMedellin','2023-03-07','19.0933535,-96.1681786',306,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(421,'Esmeralda Rojas Filio','esme24rojas@gmail.com','2294126029','Noruega Sur 52728 #2\r\nGPON0/1:24\nLagos de Puente Moreno\nMedellin','2023-03-04','',305,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(422,'Patricia Echeverria Luna','','2291436831','Noruega Sur 52724 #2\r\n19.092708,-96.1683662\nLagos de Puente Moreno\nMedellin','2023-03-04','19.092708,-96.1683662',300,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(423,'Juana Iatzin Muñoz','','2299123350','Luxemburgo Sur 50812 #3\r\nGPON0/1:26\r\n19.093558,-96.1688665\nlagos de puente moreno\nMedellin','2023-03-04','19.093558,-96.1688665',299,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(424,'Elizabeth Juarez Cruz','ellyjuarez03@gmail.com','2293686083','Noruega Norte 52602 #4\r\n19.093441,-96.1689122\nLagos de Puente Moreno\nMedellin','2023-03-02','19.093441,-96.1689122',298,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(425,'Juan Perez Morales','juanpmorales31@gmail.com','229513940','Circuito Diamante Oeste  22101 #4\r\n19.097582,-96.1614102\nLagos de Puente Moreno\nMedellin','2023-03-02','19.097582,-96.1614102',297,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(426,'Valeria Yeid Ponce','valeriayedid@gmail.com','2291023540','Laguna Mandinga Este #63\r\n19.1056543,-96.1675932\nLagos de Puente Moreno\nMedellin','2023-03-02','19.1056543,-96.1675932',293,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(427,'Myleidy Martinez Chontal','','2295528496','Luxemburgo Norte 50603 #5\r\n19.0941313,-96.1685412\nLagos de Puente Moreno\nMedellin','2023-03-01','19.0941313,-96.1685412',283,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(428,'Deysi Lizeth Tegoma Feerman','','2292056637','Noruega Norte 52608 #2\r\n19.093154,-96.1685226\nlagos de puente moreno\nMedellin','2023-03-01','19.093154,-96.1685226',282,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(429,'Martha Ramos Velez','marave8089@hotmail.com','2291570127','Belgica Sur #76\r\n19.099577,-96.1692865\nlagos de puente moreno\nMedellin','2023-03-01','19.099577,-96.1692865',280,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(430,'Jose Armando Bojorquez Perez','','2292284401','Ribera Laguna II Sur #5\r\n19.1054193,-96.1654652,\nlagos de puente moreno\nMedellin','2023-02-28','19.1054193,-96.1654652,',277,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(431,'Yanet Juarez Vazquez','yanetjv@gmail.com','2294160393','España Norte #7\nLagos de Puente Moreno\nMedellin','2023-02-25','',272,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(432,'Griselda Rosales Lopez','','2297788026','Jose Rivero River #416\r\n19.1527293,-96.2193072\nHacienda La Parroquia\nVeracruz','2023-02-24','19.1527293,-96.2193072',276,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(433,'Alma Elizabeth Acevedo','almizacevedo94@gmail.com','2295195871','Noruega Norte 52606 #6\r\nGPON0/1:20\r\n19.0933923,-96.1688322\nLagos de Puente Moreno\nMedellin','2023-02-21','19.0933923,-96.1688322',256,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(434,'Ingrid Michel Ahuja Mendez','','2294201626','Noruega Norte 52626 #5\r\n19.093046,-96.1689919\nLagos de Puente Moreno\nMedellin','2023-02-20','19.093046,-96.1689919',250,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(435,'Maria del Carmen Castro Cruz','more8124@gmail.com','2291530284','Laguna de latania #105\r\n19.0969663,-96.1561762\nArboleda San Ramon\nMedellin','2023-02-20','19.0969663,-96.1561762',248,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(436,'Karla Mildred Ochoa Torres','mantra1617@gmail.com','2217816043','Noruega Norte 52624 #6\r\n19.0930053,-96.1680312\nLagos de Puente Moreno\nMedellin','2023-02-20','19.0930053,-96.1680312',247,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(437,'Arath Yair Lara Rivas','arathyairlara@gmail.com','2851244459','Italia Norte 51024 #4\r\n19.095053,-96.1703653\nlagos de puente moreno\nMedellin','2023-02-20','19.095053,-96.1703653',243,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(438,'Bianca Yaneliy Fuentes Perez','fbi_yanely1@hotmail.com','2292302870','Luxemburgo Sur 50808 #5\r\n19.0933223,-96.1678682\nLagos de Puente Moreno\nMedellin','2023-02-18','19.0933223,-96.1678682',238,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(439,'Maria Fernanda Calderon Vergara','mafer3296@hotmail.com','2291612663','Ribera Laguna II Norte #49\r\n19.10485,-96.1648522\nLagos de Puente Moreno\nMedellin','2023-02-17','19.10485,-96.1648522',234,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(441,'Ana Laura Bautista Solis','maldonadomoraricardojorge@gmail.com','2294650981','Laguna Mandinga Sur #34\r\n19.105261,-96.1681012\nLagos de Puente Moreno\nMedellin','2023-02-16','19.105261,-96.1681012',228,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(442,'Karina Guzman Reyes','','2851154382',NULL,'2023-02-16','19.0935075,-96.1682467',223,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(443,'Alfonso Muñoz Sainos','there5090_@hotmail.com','2292200922','Ribera Laguna III Norte #68\r\n19.1042024,-96.1644649\nLagos de Puente Moreno\nMedellin','2023-02-16','19.1042024,-96.1644649',220,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(444,'Maria Isela Guzman Santiago','','2294587583','Cto. Mandinga Este 80\r\n19.1046098,-96.1671821\nLagos de Puente Moreno\nMedellin','2023-02-16','19.1046098,-96.1671821',219,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(445,'Karina Lizbeth Concha Garcia','','7771754805','Belgica Norte  #38\r\n19.0999693,-96.1688672,\nLagos de Puente Moreno\nMedellin','2023-02-16','19.0999693,-96.1688672,',217,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(446,'Yazmin De Los Angeles Desgarenne Ponce','desgarennesponcejazmin@gmail.com','2294078268','Circuito Aqua #45\r\n19.0917546,-96.1643386\nResidencial Campestre\nMedellin','2023-02-15','19.0917546,-96.1643386',215,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(447,'Geovanni Hernadez Cano','','2461549357','Noruega Norte52632 #3\r\nGPON0/1:15\r\n19.093083,-96.1681822\nLagos de Puente Moreno\nMedellin','2023-02-15','19.093083,-96.1681822',214,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(448,'Concepcion Castillo Bautista','','2293032694','Italia Norte 51010  #2\r\n19.095084,-96.1742797\nLagos de Puente Moreno\nMedellin','2023-02-15','19.095084,-96.1742797',211,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(449,'Alida Sena Villanueva','alidacobos11@gmail.com','2292432726','Ribera Laguna II Sur #14\r\n19.1050595,-96.1657977\nLagos de Puente Moreno\nMedellin','2023-02-14','19.1050595,-96.1657977',201,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(450,'Nidia Pineda Cabriada','','2292090590','Rio Roble #39\nArboleda San Ramon\nMedellin','2023-02-13','19.0952116,-96.1608984',197,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(451,'Gloria Elena Gomez','','2291498696','Cto Urano Sur #56\r\n19.1078312,-96.1539769\nPuente Moreno\nMedellin','2023-02-11','19.1078312,-96.1539769',196,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(452,'Almendra Yamileth Serrano Castro','serranoalmendra9@gmail.com','2294933246','Laguna de Cairel Norte #26\r\n19.101356,-96.1687742\nLagos de puente Moreno\nMedellin','2023-02-11','19.101356,-96.1687742',195,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(453,'Genesis Ferman Chang','fermangenesis2@gmail.com','2293091396','Cto Kerpis Sur #11\nLagos de Puente Moreno\nMedellin','2023-02-07','',183,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(454,'Oscar Dominguez Baxin','baxinoscar8@gmail.com','2294746544','Granate Sur 22708 #6\nlagos de puente moreno\nMedellin','2023-02-06','19.096563,-96.1624425',179,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(455,'Gabriela Martinez Lagunes','','2294336748','Belgica Sur 30\r\n19.099628,-96.1691505\nlagos de puente moreno\nMedellin','2023-02-04','19.099628,-96.1691505',177,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(456,'Luis Alberto Lopez Lazaro','','','Italia Norte 51022 #6','2023-02-04','',172,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(457,'Nely Cortez Rivera','','2292200062','Noruega Norte 52610 #5\r\nGPON0/1:27\nLagos de Puente Moreno\nMedellin','2023-02-04','',167,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(458,'Irwing Gutierrez','igcarrillo1014@gmail.com','2292124576','Ruiz Cortinez\r\n19.1035282,-96.1095593\nCol. Ricardo Flores Magon\nBoca del Rio','2023-02-03','',160,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(459,'Omar Luna','','2291047246','Aquiles Serdan 60\r\nRicardo Flores Magon\r\nBoca del Río, Veracruz CP 94290\r\n19.1039132,-96.1091888','2022-12-01','',50,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(460,'Alejandro Cepero Osorio','ceperojr@gmail.com','2299118270','Perla #36\r\ncamino anton lizardo km 11.5\r\n19.0554314,-96.0145416\nAnton Lizardo\nAlvarado','2022-12-01','',51,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(461,'Yectel Sayani Moctezuma Hernandez','','','carretera boca del rio-playa de vacas\r\n19.0966607,-96.116199\nEjido Primero de la Palma\nMedellin','2022-12-01','',54,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(462,'Yoni Fabian Vazques Hernandez','','2294590329','Margarita Maza de Juarez  11\r\nRicardo Flores Magon\r\nCallejon junto a casa de Frey\r\n19.1030419,-96.1115404','2022-12-01','',57,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(463,'Jorge Jimenez Parian','','2299582546','Ruiz Cortinez 124\nBoca del Río\nBoca del Río','2022-12-01','',59,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(464,'Mara Mercy Ascencio','mercy_1647@hotmail.com','2291358221','Privada Zaragoza 13 a\r\nRicardo Flores Magon\r\nBoca del Río, Veracruz 94290','2022-12-01','',63,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(465,'Gabriela Betancourt Borja','','2297793499','Allende 11\r\nRio Jamapa\r\n19.1009545,-96.1109909','2022-12-01','',64,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(466,'Felix Galdeano','','',NULL,'2022-12-01','',65,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(467,'Silvia Romero Rodriguez','','2299781428','Independencia #4\r\n19.1013427,-96.1113782\nRio Jamapa\nBoca del Rio','2022-12-01','',67,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(468,'Guadalupe Briones','','2291075623','19.1029069,-96.1106115','2022-12-01','',73,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(469,'Ruben Canales Peña','','2291501622','Fdo Lopez Arias  #9\r\n19.1030762,-96.1102692\nRicardo Flores Magon\nBoca del Rio','2022-12-01','',76,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(470,'Guadalupe Gomez Mazaba','regit90@gmail.com','2293985941','Independencia #12\r\n19.1013429,-96.1113833\nRio Jamapa\nBoca del Rio','2022-12-01','',78,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(471,'Yudilma Cruz Villalobos','yudilma.villalobos@hotmail.com','2291060486','Fernando Casas Aleman 226','2022-12-01','',81,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(472,'Sandy Stephani Solis Solis','sanyeonie@gmail.com','2299309462','Independ 22 DGUEZ  Cortinez\nCol. Rio Jamapa\nBoca del Rio','2022-12-01','',83,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(473,'Magdalena Gutierrez Campechano','','2295427111','Josefina Ortiz De Dominguez L11 M4\r\nMAZA De Juarez CJON Moriel\nCol. Ricardo Flores Magon\nBoca del Rio','2022-12-01','',92,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(474,'Elvia Montero Morales 20','','2292075066',NULL,'2022-12-01','',94,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(475,'Ruperto Baez Blasco','','2294275202','Independencia #8\nRio Jamapa\nBoca del Rio','2022-12-01','',98,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(476,'Indira Raquel Vega Alcala','','',NULL,'2022-12-01','',101,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(477,'Yessica Gutierrez Tinoco','tinoco.cobaev@gmail.com','2294120079','Acayucan 4D\r\n19.112135,-96.1110141\nFracc Tampiquera\nBoca del Rio','2022-12-01','',116,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(478,'Dayra Abdali Borbonio','fernando_cojinuda@hotmail.com','2293976036','Allende 32\r\nRio Jamapa\r\n19.1013515,-96.1087015','2022-12-01','',121,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(479,'Abraham Camarillo Reyes','camarilloabraham40@gmail.com','2294138703','Inglaterra Norte 50015 #4\r\n19.1013763,-96.1124402\nRio Jamapa\nBoca del Rio','2022-12-01','',122,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(480,'Georgina Hernandez Ramirez','','',NULL,'2022-12-01','',130,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(481,'Maria Guerrero Perez 20','','2293646195','Morelos  13\r\nRicardo Flores Magon\r\n19.103503,-96.1120465','2022-12-01','',133,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(482,'indira raquel 2','','',NULL,'2022-12-01','',138,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(483,'gidomare','','',NULL,'2022-12-01','',139,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(484,'Isabel Noriega Lara','','2299331742','Calle Constitucion  15C\r\n19.1063264,-96.1077093\nCalle Constitucion\nCalle Constitucion','2022-12-01','',142,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(485,'Graciela Gutierrez Hernandez','','2291267365','Cjon Morelos #5 \r\ncarpinteria\nRio Jamapa\nBoca del Rio','2022-12-01','',145,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(486,'Selene Beatriz Gonzalez','','2292088863','Av. Ruiz Cortinez #6\r\n19.1017819,-96.1115405\nRicardo Flores Magon\nBoca del Rio','2022-12-01','',146,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(487,'Victor Ortega Velazco','','2299528851','Ruiz cortines 125\r\nRicardo Flores Magon\r\n19.1070325,-96.1107829','2022-12-01','',148,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(488,'Marisela Uscanga Sosa','','2295502656','Azucena L11\r\nPaso Colorado\r\nBoca del Río, Veracruz CP 94271\r\n19.061651,-96.1332508','2022-11-10','',48,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(489,'Ricardo Flores Martinez','olivares_8965@hotmail.com','2295317588','Obsidiana #35\r\n19.157248,-96.2226862\nDorado Real\nVeracruz','2022-11-08','',45,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(490,'Jessica Valeria Concha Guzman','','2292561393','Turquesa 7\r\nDorado Real\r\nCP 91697\nVeracruz\nVeracruz','2022-11-08','',46,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(491,'Fabian Lopez Ponce','','229919229','Gardenias  6\r\nPaso Colorado\r\n19.0629323,-96.1336002','2022-10-23','',28,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(492,'Juan Osmar Rosales Garcia','','','O camino X\r\nPaso Colorado\r\nBoca Del Río, Veracruz CP 94291\r\n19.061517,-96.1351667','2022-10-23','',33,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(493,'Licho','','',NULL,'2022-10-22','',17,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(494,'Alejandro Lopez Ponce','alelopezponce1234@gmail.com','2292646409','Bugambilias  Lt7\r\n19.0619613,-96.1328127\nPaso Colorado\nBoca del Rio','2022-10-22','',23,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(495,'Ricardo Santiago Perez','','2291244650','Lirios #34\r\n19.061752,-96.1366935\r\ncasi al fono, casa en lado derecho\nPaso Colorado\nboca del rio','2022-10-22','',24,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(496,'Fermin Martinez Colorado','','2293994665','Rosales L4 Bugambil S Nombre\nPaso Colorado\nBoca del Rio','2022-10-22','',25,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(497,'Sergio Sabino Vergara','','2297797376','Lirio SN\r\nPaso Colorado\r\nBoca del Río, Veracruz 94290\r\n19.0612814,-96.1339363','2022-10-22','',16,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(498,'valentina','','',NULL,'2022-09-20','',12,'2026-01-19 05:10:59','2026-01-19 07:27:26'),
(500,'AlejandraJazminArg','','',NULL,'2026-01-28','',970,'2026-01-28 22:50:37','2026-01-28 22:50:37'),
(501,'Yesenia Marin Perez','','',NULL,'2026-01-28','',969,'2026-01-28 22:50:37','2026-01-28 22:50:37'),
(502,'OliviaBeltranFer','','',NULL,'2026-01-27','',968,'2026-01-28 22:50:37','2026-01-28 22:50:37'),
(503,'ValeriaHerreraGarc','','',NULL,'2026-01-27','',967,'2026-01-28 22:50:37','2026-01-28 22:50:37'),
(504,'LizbethBarradasAma','','',NULL,'2026-01-27','',966,'2026-01-28 22:50:37','2026-01-28 22:50:37'),
(505,'MaribelFloresHern','','',NULL,'2026-01-23','',965,'2026-01-28 22:50:37','2026-01-28 22:50:37'),
(506,'JesusTorresMarti','','',NULL,'2026-01-23','',964,'2026-01-28 22:50:37','2026-01-28 22:50:37'),
(507,'MariaAntoniaCruz','','',NULL,'2026-01-21','',963,'2026-01-28 22:50:37','2026-01-28 22:50:37'),
(508,'CristianArturoRod','','',NULL,'2026-01-21','',962,'2026-01-28 22:50:37','2026-01-28 22:50:37'),
(509,'HectorGenaroPadilla','','',NULL,'2026-01-20','',961,'2026-01-28 22:50:37','2026-01-28 22:50:37'),
(510,'JanetIrazuCornejo','','',NULL,'2026-01-20','',960,'2026-01-28 22:50:37','2026-01-28 22:50:37'),
(511,'DulceElizabethLeon','','',NULL,'2026-01-20','',959,'2026-01-28 22:50:37','2026-01-28 22:50:37'),
(512,'ClaraElenaAlarcon','','',NULL,'2026-01-19','',958,'2026-01-28 22:50:37','2026-01-28 22:50:37');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `integrations`
--

DROP TABLE IF EXISTS `integrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `integrations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`settings`)),
  `auto_sync` tinyint(1) NOT NULL DEFAULT 0,
  `sync_interval_minutes` int(11) NOT NULL DEFAULT 60,
  `last_synced_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `integrations_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `integrations`
--

LOCK TABLES `integrations` WRITE;
/*!40000 ALTER TABLE `integrations` DISABLE KEYS */;
INSERT INTO `integrations` VALUES
(1,'Wisphub','wisphub','{\"url\":\"https:\\/\\/api.wisphub.net\\/api\\/clientes\\/\",\"api_key\":\"IhDcqiCr.bWzHCqKpMS4mSUAtOuFqqRBepFhAwSFU\"}',1,60,NULL,1,'2026-01-19 04:49:57','2026-01-19 05:18:54');
/*!40000 ALTER TABLE `integrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES
(1,'0001_01_01_000000_create_users_table',1),
(2,'0001_01_01_000001_create_cache_table',1),
(3,'0001_01_01_000002_create_jobs_table',1),
(4,'2026_01_19_044029_create_plans_table',2),
(5,'2026_01_19_044029_create_routers_table',2),
(6,'2026_01_19_044030_create_services_table',2),
(7,'2026_01_19_044647_create_integrations_table',3),
(8,'2026_01_19_045343_add_wisphub_ids_to_tables',4),
(9,'2026_01_19_045343_create_customers_table',4),
(10,'2026_01_19_045344_make_services_belong_to_customer',4),
(11,'2026_01_19_051500_add_auto_sync_to_integrations_table',5),
(12,'2026_01_19_060905_add_monitoring_fields_to_routers_table',6),
(13,'2026_01_19_064542_create_app_settings_table',7),
(14,'2026_01_19_072227_add_installation_date_to_customers_table',8),
(15,'2026_01_19_223243_add_advanced_fields_to_routers_table',9),
(16,'2026_01_19_223244_create_router_api_events_table',9),
(17,'2026_01_19_223244_create_router_ip_ranges_table',9),
(18,'2026_01_19_223510_add_scripts_to_routers_table',10),
(19,'2026_01_19_225530_create_bot_tables',11),
(20,'2026_01_19_225531_create_bot_knowledge_base_table',11),
(21,'2026_01_19_225531_create_bot_sessions_table',11),
(22,'2026_01_19_225531_create_bot_steps_table',11),
(23,'2026_01_19_225532_create_bot_usage_logs_table',11),
(24,'2026_01_20_001301_add_chatwoot_to_bots_table',12),
(25,'2026_01_20_001723_make_chatwoot_fields_nullable_in_bots_table',13),
(26,'2026_01_20_003936_create_personal_access_tokens_table',14),
(27,'2026_01_28_224932_add_billing_fields_to_services_table',15),
(28,'2026_01_28_235504_create_vpn_tunnels_table',16),
(29,'2026_01_29_000351_add_validation_fields_to_vpn_tunnels_table',17),
(30,'2026_01_29_001530_add_output_field_to_vpn_tunnels_table',18),
(31,'2026_01_29_043211_create_olts_table',19),
(32,'2026_01_29_070850_create_olt_events_table',20),
(33,'2026_01_29_074111_create_onus_table',21),
(34,'2026_01_30_081612_create_backups_table',22),
(35,'2026_01_30_082331_create_notifications_table',23);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `type` varchar(255) NOT NULL,
  `notifiable_type` varchar(255) NOT NULL,
  `notifiable_id` bigint(20) unsigned NOT NULL,
  `data` text NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES
('cd277164-75fe-4e2d-97bc-e9153e26c434','Filament\\Notifications\\DatabaseNotification','App\\Models\\User',2,'{\"actions\":[],\"body\":\"Backup creado exitosamente: 2.6 MB\",\"color\":null,\"duration\":\"persistent\",\"icon\":\"heroicon-o-check-circle\",\"iconColor\":\"success\",\"status\":\"success\",\"title\":\"Backup Completado\",\"view\":\"filament-notifications::notification\",\"viewData\":[],\"format\":\"filament\"}',NULL,'2026-01-30 08:28:55','2026-01-30 08:28:55'),
('d7dc7e67-8feb-48e5-810a-0e33b3e23e99','Filament\\Notifications\\DatabaseNotification','App\\Models\\User',2,'{\"actions\":[],\"body\":\"Backup creado exitosamente: 4.89 MB\",\"color\":null,\"duration\":\"persistent\",\"icon\":\"heroicon-o-check-circle\",\"iconColor\":\"success\",\"status\":\"success\",\"title\":\"Backup Completado\",\"view\":\"filament-notifications::notification\",\"viewData\":[],\"format\":\"filament\"}',NULL,'2026-01-30 15:42:10','2026-01-30 15:42:10');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `olt_events`
--

DROP TABLE IF EXISTS `olt_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `olt_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `olt_id` bigint(20) unsigned NOT NULL,
  `event_type` varchar(255) NOT NULL,
  `onu_sn` varchar(255) DEFAULT NULL,
  `port` varchar(255) DEFAULT NULL,
  `onu_id` int(11) DEFAULT NULL,
  `severity` varchar(255) NOT NULL DEFAULT 'info',
  `trap_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`trap_data`)),
  `message` text DEFAULT NULL,
  `received_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `olt_events_olt_id_received_at_index` (`olt_id`,`received_at`),
  KEY `olt_events_event_type_index` (`event_type`),
  KEY `olt_events_onu_sn_index` (`onu_sn`),
  CONSTRAINT `olt_events_olt_id_foreign` FOREIGN KEY (`olt_id`) REFERENCES `olts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `olt_events`
--

LOCK TABLES `olt_events` WRITE;
/*!40000 ALTER TABLE `olt_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `olt_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `olts`
--

DROP TABLE IF EXISTS `olts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `olts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `ip_admin` varchar(255) NOT NULL,
  `ip_private` varchar(255) DEFAULT NULL,
  `model` varchar(255) NOT NULL DEFAULT 'VSOL-V1600',
  `pon_type` varchar(255) NOT NULL DEFAULT 'GPON',
  `ssh_port` int(11) NOT NULL DEFAULT 22,
  `telnet_port` int(11) NOT NULL DEFAULT 23,
  `snmp_port` int(11) NOT NULL DEFAULT 161,
  `snmp_community_read` varchar(255) NOT NULL DEFAULT 'public',
  `snmp_community_write` varchar(255) NOT NULL DEFAULT 'private',
  `username` varchar(255) DEFAULT NULL,
  `password` text DEFAULT NULL,
  `admin_olt_script` text DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'unknown',
  `last_check_at` timestamp NULL DEFAULT NULL,
  `last_check_output` text DEFAULT NULL,
  `hardware_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`hardware_info`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `olts`
--

LOCK TABLES `olts` WRITE;
/*!40000 ALTER TABLE `olts` DISABLE KEYS */;
INSERT INTO `olts` VALUES
(1,'puente2','192.168.8.200','192.168.8.200','VSOL-V1600','GPON',22,23,161,'public','private','admin','eyJpdiI6ImdybkMwZEp4QkRUTFFyMXJrVm1kMFE9PSIsInZhbHVlIjoiTlpuM1ZMcHFmOVU1SHVuTXZVOXFsZz09IiwibWFjIjoiZTgzMzRlYTQyMjNiNDdlYjMyYjY2MzRjOTY2YjEzZTNmOWViMWNlZWYwZTE3MTAzYmZjZTc3MGFlZDZkYjYwOSIsInRhZyI6IiJ9',NULL,'online','2026-01-30 05:47:24','ONUs imported: 0 new, 0 updated','{\"banner\":null,\"last_test\":\"2026-01-29 07:03:32\"}','2026-01-29 06:05:57','2026-01-30 05:47:24');
/*!40000 ALTER TABLE `olts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `onus`
--

DROP TABLE IF EXISTS `onus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `onus` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `olt_id` bigint(20) unsigned NOT NULL,
  `serial_number` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `port` varchar(255) NOT NULL,
  `onu_id` int(11) NOT NULL,
  `onu_type` varchar(255) NOT NULL DEFAULT 'default',
  `status` enum('online','offline','los','unknown') NOT NULL DEFAULT 'unknown',
  `auth_state` varchar(255) DEFAULT NULL,
  `last_online_at` timestamp NULL DEFAULT NULL,
  `last_offline_at` timestamp NULL DEFAULT NULL,
  `rx_power` decimal(8,2) DEFAULT NULL,
  `tx_power` decimal(8,2) DEFAULT NULL,
  `olt_rx_power` decimal(8,2) DEFAULT NULL,
  `temperature` decimal(8,2) DEFAULT NULL,
  `voltage` decimal(8,2) DEFAULT NULL,
  `bias_current` decimal(8,2) DEFAULT NULL,
  `distance` decimal(8,2) DEFAULT NULL,
  `vlan` int(11) DEFAULT NULL,
  `line_profile` varchar(255) DEFAULT NULL,
  `service_profile` varchar(255) DEFAULT NULL,
  `dba_profile` varchar(255) DEFAULT NULL,
  `mac_address` varchar(255) DEFAULT NULL,
  `vendor` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `firmware_version` varchar(255) DEFAULT NULL,
  `hardware_version` varchar(255) DEFAULT NULL,
  `bytes_sent` bigint(20) NOT NULL DEFAULT 0,
  `bytes_received` bigint(20) NOT NULL DEFAULT 0,
  `uptime_seconds` int(11) NOT NULL DEFAULT 0,
  `customer_id` bigint(20) unsigned DEFAULT NULL,
  `service_id` bigint(20) unsigned DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `raw_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`raw_data`)),
  `discovered_at` timestamp NULL DEFAULT NULL,
  `provisioned_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `onus_serial_number_unique` (`serial_number`),
  KEY `onus_service_id_foreign` (`service_id`),
  KEY `onus_olt_id_port_onu_id_index` (`olt_id`,`port`,`onu_id`),
  KEY `onus_status_index` (`status`),
  KEY `onus_customer_id_index` (`customer_id`),
  CONSTRAINT `onus_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL,
  CONSTRAINT `onus_olt_id_foreign` FOREIGN KEY (`olt_id`) REFERENCES `olts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `onus_service_id_foreign` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=318 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `onus`
--

LOCK TABLES `onus` WRITE;
/*!40000 ALTER TABLE `onus` DISABLE KEYS */;
INSERT INTO `onus` VALUES
(1,1,'HWTCED556B5E',NULL,'0/1',1,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'default','ser_1',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":1,\"serial_number\":\"HWTCED556B5E\",\"onu_type\":\"default\",\"name\":null,\"vlan\":881,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":\"ser_1\",\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(2,1,'ZXYG152F205E',NULL,'0/6',1,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":1,\"serial_number\":\"ZXYG152F205E\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(3,1,'HWTC0FD608B0','Elizabeth_Mercedez','0/1',3,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-22.38,1.95,NULL,46.00,3.36,8.00,84.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":3,\"serial_number\":\"HWTC0FD608B0\",\"onu_type\":\"HG8141V5\",\"name\":\"Elizabeth_Mercedez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-22.38,\"tx_power\":1.95,\"voltage\":3.36,\"bias_current\":8,\"temperature\":46,\"distance\":849}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(4,1,'HWTCB943ADAE','Aurora_Banda','0/1',4,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-16.88,2.18,NULL,41.00,3.32,13.00,58.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":4,\"serial_number\":\"HWTCB943ADAE\",\"onu_type\":\"HG8141V5\",\"name\":\"Aurora_Banda\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-16.88,\"tx_power\":2.18,\"voltage\":3.32,\"bias_current\":13,\"temperature\":41,\"distance\":586}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(5,1,'HWTCC7718AAE','Esbeidy_Annel','0/1',5,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":5,\"serial_number\":\"HWTCC7718AAE\",\"onu_type\":\"HG8141V5\",\"name\":\"Esbeidy_Annel\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(6,1,'HWTC8F0CE6AF','Wendy_Noem','0/1',6,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":6,\"serial_number\":\"HWTC8F0CE6AF\",\"onu_type\":\"HG8141V5\",\"name\":\"Wendy_Noem\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(7,1,'ZTEG241816B1','Yuliana_Santiago','0/1',7,'HG8010H','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8010H','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":7,\"serial_number\":\"ZTEG241816B1\",\"onu_type\":\"HG8010H\",\"name\":\"Yuliana_Santiago\",\"vlan\":881,\"line_profile\":\"HG8010H\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(8,1,'HWTCA3957EAE','YulianaSan-YulianaSan','0/1',8,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-24.37,2.19,NULL,45.00,3.38,9.00,97.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":8,\"serial_number\":\"HWTCA3957EAE\",\"onu_type\":\"HG8141V5\",\"name\":\"YulianaSan-YulianaSan\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.37,\"tx_power\":2.19,\"voltage\":3.38,\"bias_current\":9,\"temperature\":45,\"distance\":971}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(9,1,'HWTC26D871AE','Jos_Luis_Tejeda','0/1',9,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":9,\"serial_number\":\"HWTC26D871AE\",\"onu_type\":\"HG8141V5\",\"name\":\"Jos_Luis_Tejeda\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(10,1,'HWTC0FD549B0','Olga_alina','0/1',10,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":10,\"serial_number\":\"HWTC0FD549B0\",\"onu_type\":\"HG8141V5\",\"name\":\"Olga_alina\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(11,1,'HWTC0FBC6AB0','Beatriz_Vazquez','0/1',11,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-23.21,2.04,NULL,39.00,3.36,9.00,77.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":11,\"serial_number\":\"HWTC0FBC6AB0\",\"onu_type\":\"HG8141V5\",\"name\":\"Beatriz_Vazquez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.21,\"tx_power\":2.04,\"voltage\":3.36,\"bias_current\":9,\"temperature\":39,\"distance\":779}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(12,1,'HWTC0FC497B0','Lucero_Jcome','0/1',12,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":12,\"serial_number\":\"HWTC0FC497B0\",\"onu_type\":\"HG8141V5\",\"name\":\"Lucero_Jcome\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(13,1,'HWTC0FC952B0','Estrella_Garcia','0/1',13,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-26.12,2.13,NULL,40.00,3.34,8.00,67.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":13,\"serial_number\":\"HWTC0FC952B0\",\"onu_type\":\"HG8141V5\",\"name\":\"Estrella_Garcia\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-26.12,\"tx_power\":2.13,\"voltage\":3.34,\"bias_current\":8,\"temperature\":40,\"distance\":676}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(14,1,'HWTCCE0146AF','VictorDanielVidal-VictorDanielV','0/1',14,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":14,\"serial_number\":\"HWTCCE0146AF\",\"onu_type\":\"HG8141V5\",\"name\":\"VictorDanielVidal-VictorDanielV\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(15,1,'HWTC0FD67EB0','AlejandraGuerrero-AlejandraGuer','0/1',15,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":15,\"serial_number\":\"HWTC0FD67EB0\",\"onu_type\":\"HG8141V5\",\"name\":\"AlejandraGuerrero-AlejandraGuer\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":null,\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(16,1,'HWTC547578AE','MarielaGonzalez-MarielaGonzalez','0/1',16,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-23.26,2.41,NULL,47.00,3.30,10.00,94.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":16,\"serial_number\":\"HWTC547578AE\",\"onu_type\":\"HG8141V5\",\"name\":\"MarielaGonzalez-MarielaGonzalez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.26,\"tx_power\":2.41,\"voltage\":3.3,\"bias_current\":10,\"temperature\":47,\"distance\":941}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(17,1,'HWTCE844B6AE','BernardoCarrillo-BernardoCarril','0/1',17,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":17,\"serial_number\":\"HWTCE844B6AE\",\"onu_type\":\"HG8141V5\",\"name\":\"BernardoCarrillo-BernardoCarril\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(18,1,'HWTCA2B005AE','MGuadalupeD-MGuadalupeD','0/1',18,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":18,\"serial_number\":\"HWTCA2B005AE\",\"onu_type\":\"HG8141V5\",\"name\":\"MGuadalupeD-MGuadalupeD\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(19,1,'ALCLFC62C1BA','AlfonsoIglesias-AlfonsoIglesias','0/1',20,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-23.87,2.42,NULL,43.80,3.32,13.32,91.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":20,\"serial_number\":\"ALCLFC62C1BA\",\"onu_type\":\"HG8141V5\",\"name\":\"AlfonsoIglesias-AlfonsoIglesias\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.87,\"tx_power\":2.42,\"voltage\":3.32,\"bias_current\":13.32,\"temperature\":43.801,\"distance\":911}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(20,1,'HWTCA3A8FCAE','AzucenaMartinez-AzucenaMartinez','0/1',21,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":21,\"serial_number\":\"HWTCA3A8FCAE\",\"onu_type\":\"HG8141V5\",\"name\":\"AzucenaMartinez-AzucenaMartinez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(21,1,'HWTCBC61E8AE','CindyJaqueline-CindyJaqueline','0/1',22,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":22,\"serial_number\":\"HWTCBC61E8AE\",\"onu_type\":\"HG8141V5\",\"name\":\"CindyJaqueline-CindyJaqueline\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(22,1,'HWTC547798AE',NULL,'0/1',23,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":23,\"serial_number\":\"HWTC547798AE\",\"onu_type\":\"HG8141V5\",\"name\":null,\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(23,1,'HWTCBC6735AE','OyukiTorres-OyukiTorres','0/1',24,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":24,\"serial_number\":\"HWTCBC6735AE\",\"onu_type\":\"HG8141V5\",\"name\":\"OyukiTorres-OyukiTorres\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(24,1,'ALCLFC62D625','ClaudiaCarranza-ClaudiaCarranza','0/1',25,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-21.19,2.38,NULL,47.00,3.24,11.66,67.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":25,\"serial_number\":\"ALCLFC62D625\",\"onu_type\":\"HG8141V5\",\"name\":\"ClaudiaCarranza-ClaudiaCarranza\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.19,\"tx_power\":2.38,\"voltage\":3.24,\"bias_current\":11.656,\"temperature\":47,\"distance\":672}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(25,1,'ALCLFC6862C4','LorenaFernandez-LorenaFernandez','0/1',26,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-21.87,2.15,NULL,42.90,3.24,8.88,80.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":26,\"serial_number\":\"ALCLFC6862C4\",\"onu_type\":\"HG8141V5\",\"name\":\"LorenaFernandez-LorenaFernandez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.87,\"tx_power\":2.15,\"voltage\":3.24,\"bias_current\":8.88,\"temperature\":42.898,\"distance\":809}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(26,1,'ZTEG24186825',NULL,'0/6',2,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":2,\"serial_number\":\"ZTEG24186825\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(27,1,'HWTC0FD52CB0','JoseFTenorio-JoseFTenorio','0/1',28,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-21.55,2.31,NULL,49.00,3.36,12.00,67.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":28,\"serial_number\":\"HWTC0FD52CB0\",\"onu_type\":\"HG8141V5\",\"name\":\"JoseFTenorio-JoseFTenorio\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.55,\"tx_power\":2.31,\"voltage\":3.36,\"bias_current\":12,\"temperature\":49,\"distance\":675}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(28,1,'HWTC0FCFE0B0','GladysMarquez-GladysMarquez','0/1',29,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":29,\"serial_number\":\"HWTC0FCFE0B0\",\"onu_type\":\"HG8141V5\",\"name\":\"GladysMarquez-GladysMarquez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(29,1,'ZTEG241727EE','YuridiaChipuli-YuridiaChipuli','0/1',31,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-19.81,2.78,NULL,41.00,3.24,9.00,71.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":31,\"serial_number\":\"ZTEG241727EE\",\"onu_type\":\"HG8141V5\",\"name\":\"YuridiaChipuli-YuridiaChipuli\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-19.81,\"tx_power\":2.78,\"voltage\":3.24,\"bias_current\":9,\"temperature\":41,\"distance\":717}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(30,1,'ALCLFC631E6A','JesusLara-JesusLara','0/1',32,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":32,\"serial_number\":\"ALCLFC631E6A\",\"onu_type\":\"HG8141V5\",\"name\":\"JesusLara-JesusLara\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(31,1,'FHTT9E268378','FabiolaHernandez-FabiolaHernand','0/1',33,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-25.69,2.04,NULL,43.97,3.38,10.96,96.30,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":33,\"serial_number\":\"FHTT9E268378\",\"onu_type\":\"HG8141V5\",\"name\":\"FabiolaHernandez-FabiolaHernand\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.69,\"tx_power\":2.04,\"voltage\":3.38,\"bias_current\":10.96,\"temperature\":43.969,\"distance\":963}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(32,1,'ZTEG23418D8F','FernandoRamosCas-FernandoRamosC','0/1',34,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":34,\"serial_number\":\"ZTEG23418D8F\",\"onu_type\":\"HG8141V5\",\"name\":\"FernandoRamosCas-FernandoRamosC\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(33,1,'ALCLFC39618D','AlbertoHernandezG-AlbertoHernan','0/1',35,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":35,\"serial_number\":\"ALCLFC39618D\",\"onu_type\":\"HG8141V5\",\"name\":\"AlbertoHernandezG-AlbertoHernan\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(34,1,'ZTEG2429996F','AracelyAcosta-AracelyAcosta','0/1',36,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-22.10,2.87,NULL,36.11,3.26,11.05,64.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":36,\"serial_number\":\"ZTEG2429996F\",\"onu_type\":\"HG8141V5\",\"name\":\"AracelyAcosta-AracelyAcosta\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-22.1,\"tx_power\":2.87,\"voltage\":3.26,\"bias_current\":11.05,\"temperature\":36.113,\"distance\":646}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(35,1,'HWTC0E5BCCB1','DanaJuliaAleman-DanaJuliaAleman','0/1',37,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-20.21,2.12,NULL,46.00,3.32,9.00,68.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":37,\"serial_number\":\"HWTC0E5BCCB1\",\"onu_type\":\"HG8141V5\",\"name\":\"DanaJuliaAleman-DanaJuliaAleman\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-20.21,\"tx_power\":2.12,\"voltage\":3.32,\"bias_current\":9,\"temperature\":46,\"distance\":688}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(36,1,'ZTEG24258F03','JuanCarlosSantiago-JuanCarlosSa','0/1',38,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":38,\"serial_number\":\"ZTEG24258F03\",\"onu_type\":\"HG8141V5\",\"name\":\"JuanCarlosSantiago-JuanCarlosSa\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(37,1,'ALCLFC62E88A','AlfonsoVazquez-AlfonsoVazquez','0/1',39,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":39,\"serial_number\":\"ALCLFC62E88A\",\"onu_type\":\"HG8141V5\",\"name\":\"AlfonsoVazquez-AlfonsoVazquez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(38,1,'ZTEG24398C80','RubiselaMorales-RubiselaMorales','0/1',40,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":40,\"serial_number\":\"ZTEG24398C80\",\"onu_type\":\"HG8141V5\",\"name\":\"RubiselaMorales-RubiselaMorales\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(39,1,'ZTEG24397341','RocioMorales-RocioMorales','0/1',41,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-21.76,2.89,NULL,40.65,3.22,10.05,67.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":41,\"serial_number\":\"ZTEG24397341\",\"onu_type\":\"HG8141V5\",\"name\":\"RocioMorales-RocioMorales\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.76,\"tx_power\":2.89,\"voltage\":3.22,\"bias_current\":10.05,\"temperature\":40.645,\"distance\":670}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(40,1,'ALCLFC62C0A3','DinerRicardo-DinerRicardo','0/1',42,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-17.42,2.39,NULL,39.70,3.24,10.99,61.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":42,\"serial_number\":\"ALCLFC62C0A3\",\"onu_type\":\"HG8141V5\",\"name\":\"DinerRicardo-DinerRicardo\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.42,\"tx_power\":2.39,\"voltage\":3.24,\"bias_current\":10.988,\"temperature\":39.699,\"distance\":619}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(41,1,'ZTEG24398BF0','JeniferDelAlba-JeniferDelAlba','0/1',43,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'HG8141V5',NULL,'ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":43,\"serial_number\":\"ZTEG24398BF0\",\"onu_type\":\"HG8141V5\",\"name\":\"JeniferDelAlba-JeniferDelAlba\",\"vlan\":null,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":null,\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(42,1,'ZTEG2439736E','OrlandoChagala-OrlandoChagala','0/1',44,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":44,\"serial_number\":\"ZTEG2439736E\",\"onu_type\":\"HG8141V5\",\"name\":\"OrlandoChagala-OrlandoChagala\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(43,1,'ALCLFC631E68','EduardoDuranR-EduardoDuranR','0/1',45,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-18.04,2.45,NULL,44.80,3.24,12.77,61.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":45,\"serial_number\":\"ALCLFC631E68\",\"onu_type\":\"HG8141V5\",\"name\":\"EduardoDuranR-EduardoDuranR\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.04,\"tx_power\":2.45,\"voltage\":3.24,\"bias_current\":12.766,\"temperature\":44.801,\"distance\":619}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(44,1,'ZTEG222125EB','CristianDelRocio-CristianDelRoc','0/1',46,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-25.69,2.06,NULL,43.59,3.22,13.40,83.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":46,\"serial_number\":\"ZTEG222125EB\",\"onu_type\":\"HG8141V5\",\"name\":\"CristianDelRocio-CristianDelRoc\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.69,\"tx_power\":2.06,\"voltage\":3.22,\"bias_current\":13.4,\"temperature\":43.594,\"distance\":839}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(45,1,'ALCLFCE61818','AikoDesiree-AikoDesiree','0/1',47,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-21.08,2.67,NULL,47.10,3.24,13.99,66.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":47,\"serial_number\":\"ALCLFCE61818\",\"onu_type\":\"HG8141V5\",\"name\":\"AikoDesiree-AikoDesiree\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.08,\"tx_power\":2.67,\"voltage\":3.24,\"bias_current\":13.986,\"temperature\":47.102,\"distance\":668}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(46,1,'HWTC4C8E1BB0','KarenLizbeth-KarenLizbeth','0/1',48,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-26.45,2.03,NULL,47.00,3.36,10.00,68.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":48,\"serial_number\":\"HWTC4C8E1BB0\",\"onu_type\":\"HG8141V5\",\"name\":\"KarenLizbeth-KarenLizbeth\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-26.45,\"tx_power\":2.03,\"voltage\":3.36,\"bias_current\":10,\"temperature\":47,\"distance\":689}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(47,1,'HWTC397983B0','MaileSamantha-MaileSamantha','0/1',49,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":49,\"serial_number\":\"HWTC397983B0\",\"onu_type\":\"HG8141V5\",\"name\":\"MaileSamantha-MaileSamantha\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(48,1,'ALCLFCE49BE5','JoseArmandoVin-JoseArmandoVin','0/1',50,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":50,\"serial_number\":\"ALCLFCE49BE5\",\"onu_type\":\"HG8141V5\",\"name\":\"JoseArmandoVin-JoseArmandoVin\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(49,1,'HWTC0E7D3EB1','JesusAdrianGlez-JesusAdrianGlez','0/1',51,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":51,\"serial_number\":\"HWTC0E7D3EB1\",\"onu_type\":\"HG8141V5\",\"name\":\"JesusAdrianGlez-JesusAdrianGlez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(50,1,'ZTEG24411F50','MaileSamantha-MaileSamantha','0/1',52,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-24.09,1.65,NULL,35.42,3.26,10.20,85.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":52,\"serial_number\":\"ZTEG24411F50\",\"onu_type\":\"HG8141V5\",\"name\":\"MaileSamantha-MaileSamantha\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.09,\"tx_power\":1.65,\"voltage\":3.26,\"bias_current\":10.2,\"temperature\":35.418,\"distance\":850}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(51,1,'ZTEG24411D37','RoxanaPal-RoxanaPal','0/1',53,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-27.04,2.38,NULL,38.56,3.22,9.85,73.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":53,\"serial_number\":\"ZTEG24411D37\",\"onu_type\":\"HG8141V5\",\"name\":\"RoxanaPal-RoxanaPal\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-27.04,\"tx_power\":2.38,\"voltage\":3.22,\"bias_current\":9.85,\"temperature\":38.555,\"distance\":731}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(52,1,'HWTC836DD7AE','DamaryAntonioNuevo-DamaryAntoni','0/1',54,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":54,\"serial_number\":\"HWTC836DD7AE\",\"onu_type\":\"HG8141V5\",\"name\":\"DamaryAntonioNuevo-DamaryAntoni\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(53,1,'ALCLFC62CBC8','AngelOmarR-AngelOmarR','0/1',55,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":55,\"serial_number\":\"ALCLFC62CBC8\",\"onu_type\":\"HG8141V5\",\"name\":\"AngelOmarR-AngelOmarR\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(54,1,'ALCLFCDCAD04','CinthyaMich-CinthyaMich','0/1',56,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-27.45,2.17,NULL,49.00,3.24,10.77,76.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":56,\"serial_number\":\"ALCLFCDCAD04\",\"onu_type\":\"HG8141V5\",\"name\":\"CinthyaMich-CinthyaMich\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-27.45,\"tx_power\":2.17,\"voltage\":3.24,\"bias_current\":10.768,\"temperature\":49,\"distance\":768}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(55,1,'HWTC906CEEB0','SusanaTovar-SusanaTovar','0/1',57,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-24.75,2.28,NULL,44.00,3.40,9.00,77.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":57,\"serial_number\":\"HWTC906CEEB0\",\"onu_type\":\"HG8141V5\",\"name\":\"SusanaTovar-SusanaTovar\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.75,\"tx_power\":2.28,\"voltage\":3.4,\"bias_current\":9,\"temperature\":44,\"distance\":778}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(56,1,'HWTC90767BB0','JhonathanA-JhonathanA','0/1',58,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-25.30,2.33,NULL,47.00,3.36,9.00,68.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":58,\"serial_number\":\"HWTC90767BB0\",\"onu_type\":\"HG8141V5\",\"name\":\"JhonathanA-JhonathanA\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.3,\"tx_power\":2.33,\"voltage\":3.36,\"bias_current\":9,\"temperature\":47,\"distance\":681}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(57,1,'HWTC6E99CEAF','WendySa-WendySa','0/1',59,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":59,\"serial_number\":\"HWTC6E99CEAF\",\"onu_type\":\"HG8141V5\",\"name\":\"WendySa-WendySa\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(58,1,'HWTC4C7CDFB0','ItzelCar-ItzelCar','0/1',60,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-25.72,2.19,NULL,38.00,3.32,10.00,68.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":60,\"serial_number\":\"HWTC4C7CDFB0\",\"onu_type\":\"HG8141V5\",\"name\":\"ItzelCar-ItzelCar\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.72,\"tx_power\":2.19,\"voltage\":3.32,\"bias_current\":10,\"temperature\":38,\"distance\":685}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(59,1,'HWTC104725B2','HernanHermida-HernanHermida','0/1',61,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-26.06,2.15,NULL,47.00,3.26,10.00,74.30,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":61,\"serial_number\":\"HWTC104725B2\",\"onu_type\":\"HG8141V5\",\"name\":\"HernanHermida-HernanHermida\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-26.06,\"tx_power\":2.15,\"voltage\":3.26,\"bias_current\":10,\"temperature\":47,\"distance\":743}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(60,1,'HWTC72EBD2B0','JoseAlfrHues-JoseAlfrHues','0/1',62,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-26.67,2.20,NULL,46.00,3.32,10.00,78.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":62,\"serial_number\":\"HWTC72EBD2B0\",\"onu_type\":\"HG8141V5\",\"name\":\"JoseAlfrHues-JoseAlfrHues\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-26.67,\"tx_power\":2.2,\"voltage\":3.32,\"bias_current\":10,\"temperature\":46,\"distance\":789}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(61,1,'HWTCC49A51B1','IrwingDJHdez-IrwingDJHdez','0/1',63,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-27.36,2.25,NULL,38.00,3.30,10.00,75.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":63,\"serial_number\":\"HWTCC49A51B1\",\"onu_type\":\"HG8141V5\",\"name\":\"IrwingDJHdez-IrwingDJHdez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-27.36,\"tx_power\":2.25,\"voltage\":3.3,\"bias_current\":10,\"temperature\":38,\"distance\":756}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(62,1,'ZTEG24299A67','CandelariaCorrea-CandelariaCorr','0/1',64,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-21.84,2.16,NULL,39.25,3.26,12.05,80.90,881,'HG8141V5','INTERNET',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":64,\"serial_number\":\"ZTEG24299A67\",\"onu_type\":\"HG8141V5\",\"name\":\"CandelariaCorrea-CandelariaCorr\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":null,\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.84,\"tx_power\":2.16,\"voltage\":3.26,\"bias_current\":12.05,\"temperature\":39.25,\"distance\":809}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(63,1,'HWTC0E7405B1','RosaMariaMorales-RosaMariaMoral','0/1',65,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-22.50,2.35,NULL,47.00,3.30,10.00,80.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":65,\"serial_number\":\"HWTC0E7405B1\",\"onu_type\":\"HG8141V5\",\"name\":\"RosaMariaMorales-RosaMariaMoral\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-22.5,\"tx_power\":2.35,\"voltage\":3.3,\"bias_current\":10,\"temperature\":47,\"distance\":800}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(64,1,'HWTC10482BB2','AbigailLunaAn-AbigailLunaAn','0/1',66,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-17.42,1.87,NULL,45.00,3.30,11.00,51.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":66,\"serial_number\":\"HWTC10482BB2\",\"onu_type\":\"HG8141V5\",\"name\":\"AbigailLunaAn-AbigailLunaAn\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.42,\"tx_power\":1.87,\"voltage\":3.3,\"bias_current\":11,\"temperature\":45,\"distance\":515}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(65,1,'HWTC7B5A1FB1','LuisEnriqueP-LuisEnriqueP','0/1',67,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-25.60,2.26,NULL,49.00,3.30,10.00,67.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":67,\"serial_number\":\"HWTC7B5A1FB1\",\"onu_type\":\"HG8141V5\",\"name\":\"LuisEnriqueP-LuisEnriqueP\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.6,\"tx_power\":2.26,\"voltage\":3.3,\"bias_current\":10,\"temperature\":49,\"distance\":670}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(66,1,'HWTC10452EB2','GracielaGuzmazGom-GracielaGuzma','0/1',68,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-26.39,2.25,NULL,42.00,3.26,9.00,69.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":68,\"serial_number\":\"HWTC10452EB2\",\"onu_type\":\"HG8141V5\",\"name\":\"GracielaGuzmazGom-GracielaGuzma\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-26.39,\"tx_power\":2.25,\"voltage\":3.26,\"bias_current\":9,\"temperature\":42,\"distance\":697}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(67,1,'HWTCAEB499AF','JajairaValerioCas-JajairaValeri','0/1',69,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-22.68,2.17,NULL,52.00,3.34,12.00,89.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":69,\"serial_number\":\"HWTCAEB499AF\",\"onu_type\":\"HG8141V5\",\"name\":\"JajairaValerioCas-JajairaValeri\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-22.68,\"tx_power\":2.17,\"voltage\":3.34,\"bias_current\":12,\"temperature\":52,\"distance\":899}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(68,1,'HWTCAEB6CCAF','FelixCamareroYep-FelixCamareroY','0/1',70,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-21.74,2.29,NULL,52.00,3.40,11.00,50.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":70,\"serial_number\":\"HWTCAEB6CCAF\",\"onu_type\":\"HG8141V5\",\"name\":\"FelixCamareroYep-FelixCamareroY\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.74,\"tx_power\":2.29,\"voltage\":3.4,\"bias_current\":11,\"temperature\":52,\"distance\":508}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(69,1,'FHTT9B1448C0',NULL,'0/1',71,'HG8141V5','online',NULL,'2026-01-29 19:00:55',NULL,-23.01,2.67,NULL,41.24,3.30,7.43,90.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":71,\"serial_number\":\"FHTT9B1448C0\",\"onu_type\":\"HG8141V5\",\"name\":null,\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.01,\"tx_power\":2.67,\"voltage\":3.3,\"bias_current\":7.43,\"temperature\":41.238,\"distance\":909}','2026-01-29 19:00:55',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:55'),
(70,1,'FHTT9CC3E078','JavierEduardoAnto-JavierEduardo','0/1',72,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":72,\"serial_number\":\"FHTT9CC3E078\",\"onu_type\":\"HG8141V5\",\"name\":\"JavierEduardoAnto-JavierEduardo\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(71,1,'FHTT9CD6C328','GladysMarquezGarcia-GladysMarqu','0/1',73,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":73,\"serial_number\":\"FHTT9CD6C328\",\"onu_type\":\"HG8141V5\",\"name\":\"GladysMarquezGarcia-GladysMarqu\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(72,1,'FHTT9CD7AE48','JaimeGayossoRamirez-JaimeGayoss','0/1',74,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":74,\"serial_number\":\"FHTT9CD7AE48\",\"onu_type\":\"HG8141V5\",\"name\":\"JaimeGayossoRamirez-JaimeGayoss\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(73,1,'FHTT9EA5FA08','JoseManuelHernandezAve-JoseManu','0/1',75,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-21.94,2.29,NULL,42.75,3.34,9.62,59.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":75,\"serial_number\":\"FHTT9EA5FA08\",\"onu_type\":\"HG8141V5\",\"name\":\"JoseManuelHernandezAve-JoseManu\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.94,\"tx_power\":2.29,\"voltage\":3.34,\"bias_current\":9.62,\"temperature\":42.75,\"distance\":592}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(74,1,'FHTT9CD8E618','JessicaIxbaVillaseca-JessicaIxb','0/1',76,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-16.64,1.99,NULL,42.34,3.32,9.38,61.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":76,\"serial_number\":\"FHTT9CD8E618\",\"onu_type\":\"HG8141V5\",\"name\":\"JessicaIxbaVillaseca-JessicaIxb\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-16.64,\"tx_power\":1.99,\"voltage\":3.32,\"bias_current\":9.38,\"temperature\":42.34,\"distance\":611}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(75,1,'FHTT9D6934C8','Judit_Juarez_Espejo-JudithJuare','0/1',77,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-17.20,2.01,NULL,43.83,3.36,8.35,64.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":77,\"serial_number\":\"FHTT9D6934C8\",\"onu_type\":\"HG8141V5\",\"name\":\"Judit_Juarez_Espejo-JudithJuare\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.2,\"tx_power\":2.01,\"voltage\":3.36,\"bias_current\":8.35,\"temperature\":43.828,\"distance\":649}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(76,1,'FHTT9EB35590','AdalbertoManuelBello-AdalbertoM','0/1',79,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-23.10,2.15,NULL,40.96,3.26,8.14,88.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":79,\"serial_number\":\"FHTT9EB35590\",\"onu_type\":\"HG8141V5\",\"name\":\"AdalbertoManuelBello-AdalbertoM\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.1,\"tx_power\":2.15,\"voltage\":3.26,\"bias_current\":8.14,\"temperature\":40.957,\"distance\":880}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(77,1,'FHTTBAA83230','NormaMichelDimas-NormaMichelDim','0/1',80,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-26.20,2.23,NULL,39.29,3.38,7.57,81.40,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":80,\"serial_number\":\"FHTTBAA83230\",\"onu_type\":\"HG8141V5\",\"name\":\"NormaMichelDimas-NormaMichelDim\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-26.2,\"tx_power\":2.23,\"voltage\":3.38,\"bias_current\":7.57,\"temperature\":39.289,\"distance\":814}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(78,1,'ALCLFC685D4E','LuisEnriqueP-LuisEnriqueP','0/1',128,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-19.67,2.34,NULL,45.20,3.24,11.88,70.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/1\",\"onu_id\":128,\"serial_number\":\"ALCLFC685D4E\",\"onu_type\":\"HG8141V5\",\"name\":\"LuisEnriqueP-LuisEnriqueP\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-19.67,\"tx_power\":2.34,\"voltage\":3.24,\"bias_current\":11.876,\"temperature\":45.199,\"distance\":707}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(79,1,'ZTEG2504C2D5','YolandaRam-YolandaRam','0/2',1,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-21.37,2.14,NULL,37.51,3.24,9.30,65.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":1,\"serial_number\":\"ZTEG2504C2D5\",\"onu_type\":\"HG8141V5\",\"name\":\"YolandaRam-YolandaRam\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.37,\"tx_power\":2.14,\"voltage\":3.24,\"bias_current\":9.3,\"temperature\":37.508,\"distance\":651}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(80,1,'HWTC82BB6FAF','WendyBer-WendyBer','0/2',2,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":2,\"serial_number\":\"HWTC82BB6FAF\",\"onu_type\":\"HG8141V5\",\"name\":\"WendyBer-WendyBer\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(81,1,'HWTC7BD36FB1',NULL,'0/2',3,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-21.63,2.28,NULL,41.00,3.30,9.00,57.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":3,\"serial_number\":\"HWTC7BD36FB1\",\"onu_type\":\"HG8141V5\",\"name\":null,\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.63,\"tx_power\":2.28,\"voltage\":3.3,\"bias_current\":9,\"temperature\":41,\"distance\":571}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(82,1,'ZTEG25014A32','ZairaLozano-ZairaLozano','0/2',4,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-26.74,2.39,NULL,33.32,3.24,9.80,65.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":4,\"serial_number\":\"ZTEG25014A32\",\"onu_type\":\"HG8141V5\",\"name\":\"ZairaLozano-ZairaLozano\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-26.74,\"tx_power\":2.39,\"voltage\":3.24,\"bias_current\":9.8,\"temperature\":33.324,\"distance\":650}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(83,1,'ZTEG2424888D','EnriqueOrtega-EnriqueOrtega','0/2',5,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-25.78,2.82,NULL,35.42,3.26,8.45,84.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":5,\"serial_number\":\"ZTEG2424888D\",\"onu_type\":\"HG8141V5\",\"name\":\"EnriqueOrtega-EnriqueOrtega\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.78,\"tx_power\":2.82,\"voltage\":3.26,\"bias_current\":8.45,\"temperature\":35.418,\"distance\":849}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(84,1,'HWTCA3BCF3AE','OsmarMGomez-OscarMGomez','0/2',7,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-23.09,2.26,NULL,44.00,3.32,11.00,77.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":7,\"serial_number\":\"HWTCA3BCF3AE\",\"onu_type\":\"HG8141V5\",\"name\":\"OsmarMGomez-OscarMGomez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.09,\"tx_power\":2.26,\"voltage\":3.32,\"bias_current\":11,\"temperature\":44,\"distance\":775}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(85,1,'HWTCD825DEAF','CarlosDanielMar-CarlosDanielMar','0/2',8,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-23.84,2.27,NULL,41.00,3.32,8.00,75.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":8,\"serial_number\":\"HWTCD825DEAF\",\"onu_type\":\"HG8141V5\",\"name\":\"CarlosDanielMar-CarlosDanielMar\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.84,\"tx_power\":2.27,\"voltage\":3.32,\"bias_current\":8,\"temperature\":41,\"distance\":757}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(86,1,'HWTCD82652AF','BaltazarAlarcon-BaltazarAlarcon','0/2',9,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-29.80,2.26,NULL,41.00,3.36,10.00,58.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":9,\"serial_number\":\"HWTCD82652AF\",\"onu_type\":\"HG8141V5\",\"name\":\"BaltazarAlarcon-BaltazarAlarcon\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-29.8,\"tx_power\":2.26,\"voltage\":3.36,\"bias_current\":10,\"temperature\":41,\"distance\":589}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(87,1,'HWTCCD3877AF','MildrethMarianaP-MildrethMarian','0/2',10,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-25.48,2.32,NULL,43.00,3.28,8.00,67.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":10,\"serial_number\":\"HWTCCD3877AF\",\"onu_type\":\"HG8141V5\",\"name\":\"MildrethMarianaP-MildrethMarian\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.48,\"tx_power\":2.32,\"voltage\":3.28,\"bias_current\":8,\"temperature\":43,\"distance\":675}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(88,1,'ALCLFC686503','SandraPaolaAbrego-SandraPaolaAb','0/2',12,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-28.24,2.39,NULL,49.90,3.24,11.32,79.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":12,\"serial_number\":\"ALCLFC686503\",\"onu_type\":\"HG8141V5\",\"name\":\"SandraPaolaAbrego-SandraPaolaAb\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-28.24,\"tx_power\":2.39,\"voltage\":3.24,\"bias_current\":11.322,\"temperature\":49.898,\"distance\":798}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(89,1,'ZTEG24511A23','IngridKarinaRiv-IngridKarinaRiv','0/2',13,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-21.76,2.52,NULL,33.67,3.24,9.85,81.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":13,\"serial_number\":\"ZTEG24511A23\",\"onu_type\":\"HG8141V5\",\"name\":\"IngridKarinaRiv-IngridKarinaRiv\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.76,\"tx_power\":2.52,\"voltage\":3.24,\"bias_current\":9.85,\"temperature\":33.672,\"distance\":818}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(90,1,'ZTEG24247485','JohnJiroGuz-JohnJiroGuz','0/2',14,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-33.73,2.20,NULL,39.95,3.24,13.35,86.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":14,\"serial_number\":\"ZTEG24247485\",\"onu_type\":\"HG8141V5\",\"name\":\"JohnJiroGuz-JohnJiroGuz\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-33.73,\"tx_power\":2.2,\"voltage\":3.24,\"bias_current\":13.35,\"temperature\":39.949,\"distance\":868}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(91,1,'HWTC970A97B0','AlexisJairHernan-AlexisJairHern','0/2',15,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-20.71,2.21,NULL,45.00,3.32,8.00,53.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":15,\"serial_number\":\"HWTC970A97B0\",\"onu_type\":\"HG8141V5\",\"name\":\"AlexisJairHernan-AlexisJairHern\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-20.71,\"tx_power\":2.21,\"voltage\":3.32,\"bias_current\":8,\"temperature\":45,\"distance\":539}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(92,1,'ZTEG2429BD6B','RaquelMorales-RaquelMorales','0/2',16,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-21.29,1.59,NULL,39.60,3.24,11.25,60.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":16,\"serial_number\":\"ZTEG2429BD6B\",\"onu_type\":\"HG8141V5\",\"name\":\"RaquelMorales-RaquelMorales\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.29,\"tx_power\":1.59,\"voltage\":3.24,\"bias_current\":11.25,\"temperature\":39.602,\"distance\":600}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(93,1,'HWTCB084AEB1','JacquelineDCSoto-JacquelineDCSo','0/2',17,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":17,\"serial_number\":\"HWTCB084AEB1\",\"onu_type\":\"HG8141V5\",\"name\":\"JacquelineDCSoto-JacquelineDCSo\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(94,1,'ZTEG24500500','JanyLagunes-JanyLagunes','0/2',18,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-23.56,1.61,NULL,38.56,3.26,11.00,74.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":18,\"serial_number\":\"ZTEG24500500\",\"onu_type\":\"HG8141V5\",\"name\":\"JanyLagunes-JanyLagunes\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.56,\"tx_power\":1.61,\"voltage\":3.26,\"bias_current\":11,\"temperature\":38.555,\"distance\":742}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(95,1,'HWTC6E493AAE','LadyDelCarmVi-LadyDelCarmVi','0/2',19,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-24.82,2.12,NULL,46.00,3.32,10.00,54.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":19,\"serial_number\":\"HWTC6E493AAE\",\"onu_type\":\"HG8141V5\",\"name\":\"LadyDelCarmVi-LadyDelCarmVi\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.82,\"tx_power\":2.12,\"voltage\":3.32,\"bias_current\":10,\"temperature\":46,\"distance\":540}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(96,1,'HWTC102CCCB2','EraquiaMerida-EraquiaMerida','0/2',20,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-24.08,1.97,NULL,42.00,3.28,8.00,68.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":20,\"serial_number\":\"HWTC102CCCB2\",\"onu_type\":\"HG8141V5\",\"name\":\"EraquiaMerida-EraquiaMerida\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.08,\"tx_power\":1.97,\"voltage\":3.28,\"bias_current\":8,\"temperature\":42,\"distance\":680}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(97,1,'ZTEG242640D2','LrticiazperezSo-LrticiazperezSo','0/2',21,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-29.47,2.28,NULL,32.63,3.28,11.50,82.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":21,\"serial_number\":\"ZTEG242640D2\",\"onu_type\":\"HG8141V5\",\"name\":\"LrticiazperezSo-LrticiazperezSo\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-29.47,\"tx_power\":2.28,\"voltage\":3.28,\"bias_current\":11.5,\"temperature\":32.629,\"distance\":827}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(98,1,'HWTCA0D64EB1','RicardoAdielVelasco-RicardoAdie','0/2',22,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-24.87,2.33,NULL,45.00,3.32,10.00,76.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":22,\"serial_number\":\"HWTCA0D64EB1\",\"onu_type\":\"HG8141V5\",\"name\":\"RicardoAdielVelasco-RicardoAdie\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.87,\"tx_power\":2.33,\"voltage\":3.32,\"bias_current\":10,\"temperature\":45,\"distance\":760}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(99,1,'FHTT9D751A68','MarisolLopez-MarisolLopez','0/2',23,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":23,\"serial_number\":\"FHTT9D751A68\",\"onu_type\":\"HG8141V5\",\"name\":\"MarisolLopez-MarisolLopez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(100,1,'ZTEG242592E6','BelemBustame-BelemBustame','0/2',24,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-28.50,2.14,NULL,34.72,3.24,9.75,86.00,NULL,'HG8141V5',NULL,'ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":24,\"serial_number\":\"ZTEG242592E6\",\"onu_type\":\"HG8141V5\",\"name\":\"BelemBustame-BelemBustame\",\"vlan\":null,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":null,\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-28.5,\"tx_power\":2.14,\"voltage\":3.24,\"bias_current\":9.75,\"temperature\":34.719,\"distance\":860}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(101,1,'HWTCE0A074B1','TomasRoveraCon-TomasRoveraCon','0/2',25,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-23.26,2.18,NULL,41.00,3.32,8.00,64.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":25,\"serial_number\":\"HWTCE0A074B1\",\"onu_type\":\"HG8141V5\",\"name\":\"TomasRoveraCon-TomasRoveraCon\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.26,\"tx_power\":2.18,\"voltage\":3.32,\"bias_current\":8,\"temperature\":41,\"distance\":647}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(102,1,'HWTCD872AAAF','YeseniaAbigailFue-YeseniaAbigai','0/2',26,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":26,\"serial_number\":\"HWTCD872AAAF\",\"onu_type\":\"HG8141V5\",\"name\":\"YeseniaAbigailFue-YeseniaAbigai\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(103,1,'ZTEG2425760A','ItzelPaolaVentura-ItzelPaolaVen','0/2',27,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-25.99,2.27,NULL,41.00,3.22,12.15,80.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":27,\"serial_number\":\"ZTEG2425760A\",\"onu_type\":\"HG8141V5\",\"name\":\"ItzelPaolaVentura-ItzelPaolaVen\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.99,\"tx_power\":2.27,\"voltage\":3.22,\"bias_current\":12.15,\"temperature\":41,\"distance\":801}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(104,1,'HWTCD8173AAF','JazminGarridoLe-JazminGarridoLe','0/2',28,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-21.09,2.21,NULL,41.00,3.38,10.00,56.40,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":28,\"serial_number\":\"HWTCD8173AAF\",\"onu_type\":\"HG8141V5\",\"name\":\"JazminGarridoLe-JazminGarridoLe\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.09,\"tx_power\":2.21,\"voltage\":3.38,\"bias_current\":10,\"temperature\":41,\"distance\":564}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(105,1,'FHTT9A03F778','SinaiMonserratGo-SinaiMonserrat','0/2',29,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-27.45,2.69,NULL,39.75,3.16,5.00,64.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":29,\"serial_number\":\"FHTT9A03F778\",\"onu_type\":\"HG8141V5\",\"name\":\"SinaiMonserratGo-SinaiMonserrat\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-27.45,\"tx_power\":2.69,\"voltage\":3.16,\"bias_current\":5,\"temperature\":39.75,\"distance\":645}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(106,1,'FHTT9BE794A0','EfrenTrujilloJim-EfrenTrujilloJ','0/2',30,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-24.20,2.64,NULL,41.80,3.26,10.57,81.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":30,\"serial_number\":\"FHTT9BE794A0\",\"onu_type\":\"HG8141V5\",\"name\":\"EfrenTrujilloJim-EfrenTrujilloJ\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.2,\"tx_power\":2.64,\"voltage\":3.26,\"bias_current\":10.57,\"temperature\":41.797,\"distance\":818}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(107,1,'FHTT9ED7BFA8','JoseJoaquinContre-JoseJoaquinCo','0/2',31,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-25.85,2.01,NULL,41.15,3.28,6.28,91.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":31,\"serial_number\":\"FHTT9ED7BFA8\",\"onu_type\":\"HG8141V5\",\"name\":\"JoseJoaquinContre-JoseJoaquinCo\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-25.85,\"tx_power\":2.01,\"voltage\":3.28,\"bias_current\":6.28,\"temperature\":41.148,\"distance\":917}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(108,1,'FHTT9CC3E728','ValeriaHerreraGarc-ValeriaHerre','0/2',32,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-23.77,2.48,NULL,43.56,3.30,11.02,84.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":32,\"serial_number\":\"FHTT9CC3E728\",\"onu_type\":\"HG8141V5\",\"name\":\"ValeriaHerreraGarc-ValeriaHerre\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.77,\"tx_power\":2.48,\"voltage\":3.3,\"bias_current\":11.02,\"temperature\":43.559,\"distance\":840}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(109,1,'FHTT9EB351D0','MayteHerreraCas-MayteHerreraCas','0/2',33,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-26.38,2.04,NULL,40.40,3.30,7.14,83.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":33,\"serial_number\":\"FHTT9EB351D0\",\"onu_type\":\"HG8141V5\",\"name\":\"MayteHerreraCas-MayteHerreraCas\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-26.38,\"tx_power\":2.04,\"voltage\":3.3,\"bias_current\":7.14,\"temperature\":40.398,\"distance\":830}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(110,1,'FHTT9E2AA6C0','JoseCarlosRosado-JoseCarlosRosa','0/2',34,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":34,\"serial_number\":\"FHTT9E2AA6C0\",\"onu_type\":\"HG8141V5\",\"name\":\"JoseCarlosRosado-JoseCarlosRosa\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(111,1,'FHTT9E2BDE70','LuisAngelCazerezRam-LuisAngelCa','0/2',35,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-24.32,2.07,NULL,44.24,3.36,10.61,91.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":35,\"serial_number\":\"FHTT9E2BDE70\",\"onu_type\":\"HG8141V5\",\"name\":\"LuisAngelCazerezRam-LuisAngelCa\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.32,\"tx_power\":2.07,\"voltage\":3.36,\"bias_current\":10.61,\"temperature\":44.238,\"distance\":912}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(112,1,'ZTEG25048A53','RosaAnahiNunez-RosaAnahiNunez','0/2',36,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-25.20,2.34,NULL,38.90,3.24,10.30,68.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":36,\"serial_number\":\"ZTEG25048A53\",\"onu_type\":\"HG8141V5\",\"name\":\"RosaAnahiNunez-RosaAnahiNunez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.2,\"tx_power\":2.34,\"voltage\":3.24,\"bias_current\":10.3,\"temperature\":38.902,\"distance\":682}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(113,1,'FHTT9A13B048','JessicaAlejandraFlores-JessicaA','0/2',37,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-24.69,2.83,NULL,42.55,3.30,8.20,85.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":37,\"serial_number\":\"FHTT9A13B048\",\"onu_type\":\"HG8141V5\",\"name\":\"JessicaAlejandraFlores-JessicaA\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.69,\"tx_power\":2.83,\"voltage\":3.3,\"bias_current\":8.2,\"temperature\":42.547,\"distance\":852}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(114,1,'FHTT9CC055D0','SamaraVazquezMontel-SamaraVazqu','0/2',38,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-28.54,2.04,NULL,43.15,3.34,10.08,68.30,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":38,\"serial_number\":\"FHTT9CC055D0\",\"onu_type\":\"HG8141V5\",\"name\":\"SamaraVazquezMontel-SamaraVazqu\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-28.54,\"tx_power\":2.04,\"voltage\":3.34,\"bias_current\":10.08,\"temperature\":43.148,\"distance\":683}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(115,1,'FHTT9BE800B8','KevinObedVidal-KevinObedVidal','0/2',39,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-23.37,2.62,NULL,43.29,3.30,9.34,76.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":39,\"serial_number\":\"FHTT9BE800B8\",\"onu_type\":\"HG8141V5\",\"name\":\"KevinObedVidal-KevinObedVidal\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.37,\"tx_power\":2.62,\"voltage\":3.3,\"bias_current\":9.34,\"temperature\":43.289,\"distance\":768}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(116,1,'FHTT9CEF79F0','YafedHernandezSalomon-YafedHern','0/2',40,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-25.85,2.04,NULL,40.71,3.32,8.35,62.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":40,\"serial_number\":\"FHTT9CEF79F0\",\"onu_type\":\"HG8141V5\",\"name\":\"YafedHernandezSalomon-YafedHern\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.85,\"tx_power\":2.04,\"voltage\":3.32,\"bias_current\":8.35,\"temperature\":40.707,\"distance\":625}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(117,1,'FHTTBAA41AC0','RolandoSolisConrad-RolandoSolis','0/2',41,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-25.85,2.15,NULL,39.48,3.32,7.43,76.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":41,\"serial_number\":\"FHTTBAA41AC0\",\"onu_type\":\"HG8141V5\",\"name\":\"RolandoSolisConrad-RolandoSolis\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.85,\"tx_power\":2.15,\"voltage\":3.32,\"bias_current\":7.43,\"temperature\":39.477,\"distance\":769}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(118,1,'FHTT9E265858','SandraLizbethMalaga-SandraLizbe','0/2',42,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-26.99,2.02,NULL,42.07,3.36,10.08,68.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":42,\"serial_number\":\"FHTT9E265858\",\"onu_type\":\"HG8141V5\",\"name\":\"SandraLizbethMalaga-SandraLizbe\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-26.99,\"tx_power\":2.02,\"voltage\":3.36,\"bias_current\":10.08,\"temperature\":42.066,\"distance\":686}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(119,1,'FHTTC1877C61','LizbethBarradasAma-LizbethBarra','0/2',43,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-25.85,2.06,NULL,39.29,3.32,10.20,82.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/2\",\"onu_id\":43,\"serial_number\":\"FHTTC1877C61\",\"onu_type\":\"HG8141V5\",\"name\":\"LizbethBarradasAma-LizbethBarra\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.85,\"tx_power\":2.06,\"voltage\":3.32,\"bias_current\":10.2,\"temperature\":39.289,\"distance\":821}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(120,1,'HWTCE5BB4CAC',NULL,'0/3',1,'default','online',NULL,'2026-01-29 19:00:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":1,\"serial_number\":\"HWTCE5BB4CAC\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(121,1,'HWTCB93BBEAE',NULL,'0/3',2,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":2,\"serial_number\":\"HWTCB93BBEAE\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(122,1,'HWTC8EFED5AF',NULL,'0/3',4,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":4,\"serial_number\":\"HWTC8EFED5AF\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(123,1,'HWTC8F16FAAF',NULL,'0/3',5,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":5,\"serial_number\":\"HWTC8F16FAAF\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(124,1,'HWTC0FCAE5B0',NULL,'0/3',6,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":6,\"serial_number\":\"HWTC0FCAE5B0\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(125,1,'HWTCB9480EAE',NULL,'0/3',7,'default','online',NULL,'2026-01-29 19:00:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":7,\"serial_number\":\"HWTCB9480EAE\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(126,1,'HWTC26DE25AE',NULL,'0/3',8,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":8,\"serial_number\":\"HWTC26DE25AE\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(127,1,'HWTC0FAFB8B0',NULL,'0/3',9,'default','online',NULL,'2026-01-29 19:00:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":9,\"serial_number\":\"HWTC0FAFB8B0\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(128,1,'HWTC5474FEAE',NULL,'0/3',10,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":10,\"serial_number\":\"HWTC5474FEAE\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(129,1,'HWTC397379A4',NULL,'0/3',11,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":11,\"serial_number\":\"HWTC397379A4\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(130,1,'HWTC26E81FAE',NULL,'0/3',12,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":12,\"serial_number\":\"HWTC26E81FAE\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(131,1,'ALCLFC62F1AA',NULL,'0/3',13,'default','online',NULL,'2026-01-29 19:00:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":13,\"serial_number\":\"ALCLFC62F1AA\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(132,1,'HWTCD816BEAF',NULL,'0/3',14,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":14,\"serial_number\":\"HWTCD816BEAF\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(133,1,'ALCLFC62C1CF',NULL,'0/3',15,'default','online',NULL,'2026-01-29 19:00:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":15,\"serial_number\":\"ALCLFC62C1CF\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(134,1,'ZTEG24172AEB',NULL,'0/3',16,'default','online',NULL,'2026-01-29 19:00:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":16,\"serial_number\":\"ZTEG24172AEB\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(135,1,'ZXYG152F1694',NULL,'0/3',17,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":17,\"serial_number\":\"ZXYG152F1694\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(136,1,'ALCLFC62C567',NULL,'0/3',18,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":18,\"serial_number\":\"ALCLFC62C567\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(137,1,'ZTEG23382706',NULL,'0/3',19,'default','online',NULL,'2026-01-29 19:00:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":19,\"serial_number\":\"ZTEG23382706\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(138,1,'ALCLFC62C06B',NULL,'0/3',20,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":20,\"serial_number\":\"ALCLFC62C06B\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(139,1,'ZTEG24186848',NULL,'0/3',21,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":21,\"serial_number\":\"ZTEG24186848\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(140,1,'ZTEG25011756','KarinaGuadalupeMora-KarinaGuada','0/6',34,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-20.41,2.15,NULL,48.00,3.34,11.00,132.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":34,\"serial_number\":\"ZTEG25011756\",\"onu_type\":\"HG8141V5\",\"name\":\"KarinaGuadalupeMora-KarinaGuada\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-20.41,\"tx_power\":2.15,\"voltage\":3.34,\"bias_current\":11,\"temperature\":48,\"distance\":1327}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(141,1,'ZTEG24241507',NULL,'0/3',23,'default','online',NULL,'2026-01-29 19:00:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":23,\"serial_number\":\"ZTEG24241507\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(142,1,'ZTEG2449ECC6',NULL,'0/3',24,'default','online',NULL,'2026-01-29 19:00:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":24,\"serial_number\":\"ZTEG2449ECC6\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(143,1,'ALCLFC5FA5C1',NULL,'0/3',25,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":25,\"serial_number\":\"ALCLFC5FA5C1\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(144,1,'ZTEGDA0B734E',NULL,'0/3',26,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":26,\"serial_number\":\"ZTEGDA0B734E\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(145,1,'FHTT9A04A1D0',NULL,'0/3',28,'default','online',NULL,'2026-01-29 19:00:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":28,\"serial_number\":\"FHTT9A04A1D0\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(146,1,'FHTT9A0E88B0','MariaGuadalupeDelCampo-MariaGua','0/6',74,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-14.21,2.90,NULL,48.90,3.32,13.91,147.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":74,\"serial_number\":\"FHTT9A0E88B0\",\"onu_type\":\"HG8141V5\",\"name\":\"MariaGuadalupeDelCampo-MariaGua\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-14.21,\"tx_power\":2.9,\"voltage\":3.32,\"bias_current\":13.91,\"temperature\":48.898,\"distance\":1470}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:57'),
(147,1,'FHTT9A104848',NULL,'0/3',30,'default','online',NULL,'2026-01-29 19:00:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":30,\"serial_number\":\"FHTT9A104848\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(148,1,'FHTTC103FC1F','GeraldineAntonioRodriguez-Geral','0/6',115,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-18.29,2.14,NULL,39.66,3.32,8.57,152.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":115,\"serial_number\":\"FHTTC103FC1F\",\"onu_type\":\"HG8141V5\",\"name\":\"GeraldineAntonioRodriguez-Geral\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.29,\"tx_power\":2.14,\"voltage\":3.32,\"bias_current\":8.57,\"temperature\":39.656,\"distance\":1525}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:57'),
(149,1,'FHTT9EB4A4D0',NULL,'0/3',32,'default','online',NULL,'2026-01-29 19:00:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":32,\"serial_number\":\"FHTT9EB4A4D0\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(150,1,'FHTT9BD05960',NULL,'0/3',33,'default','online',NULL,'2026-01-29 19:00:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/3\",\"onu_id\":33,\"serial_number\":\"FHTT9BD05960\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(151,1,'ARTE13500671','Concepcion','0/4',1,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-20.21,2.05,NULL,46.00,3.30,11.00,144.30,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":1,\"serial_number\":\"ARTE13500671\",\"onu_type\":\"HG8141V5\",\"name\":\"Concepcion\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-20.21,\"tx_power\":2.05,\"voltage\":3.3,\"bias_current\":11,\"temperature\":46,\"distance\":1443}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(152,1,'HWTC8F0DBDAF','Itai','0/4',2,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-18.33,2.30,NULL,49.00,3.30,10.00,159.40,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":2,\"serial_number\":\"HWTC8F0DBDAF\",\"onu_type\":\"HG8141V5\",\"name\":\"Itai\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.33,\"tx_power\":2.3,\"voltage\":3.3,\"bias_current\":10,\"temperature\":49,\"distance\":1594}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(153,1,'HWTC8F117DAF','Pendiente','0/4',3,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-21.88,2.25,NULL,41.00,3.30,7.00,136.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":3,\"serial_number\":\"HWTC8F117DAF\",\"onu_type\":\"HG8141V5\",\"name\":\"Pendiente\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.88,\"tx_power\":2.25,\"voltage\":3.3,\"bias_current\":7,\"temperature\":41,\"distance\":1367}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(154,1,'HWTCA8D370AE','Jonathan_Alexis','0/4',5,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-20.03,2.30,NULL,43.00,3.32,12.00,152.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":5,\"serial_number\":\"HWTCA8D370AE\",\"onu_type\":\"HG8141V5\",\"name\":\"Jonathan_Alexis\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-20.03,\"tx_power\":2.3,\"voltage\":3.32,\"bias_current\":12,\"temperature\":43,\"distance\":1529}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(155,1,'HWTC8F03CDAF',NULL,'0/4',6,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":6,\"serial_number\":\"HWTC8F03CDAF\",\"onu_type\":\"HG8141V5\",\"name\":null,\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(156,1,'HWTC8F084BAF','Valeria_Ramirez_Tenorio','0/4',7,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":7,\"serial_number\":\"HWTC8F084BAF\",\"onu_type\":\"HG8141V5\",\"name\":\"Valeria_Ramirez_Tenorio\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(157,1,'HWTCB94E1EAE','Manuel_Martinez_Martinez','0/4',8,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-17.77,2.24,NULL,41.00,3.30,8.00,154.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":8,\"serial_number\":\"HWTCB94E1EAE\",\"onu_type\":\"HG8141V5\",\"name\":\"Manuel_Martinez_Martinez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.77,\"tx_power\":2.24,\"voltage\":3.3,\"bias_current\":8,\"temperature\":41,\"distance\":1541}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(158,1,'HWTC7D5BCCAE','Joaqun_Cobos','0/4',9,'HG8010H','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8010H','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":9,\"serial_number\":\"HWTC7D5BCCAE\",\"onu_type\":\"HG8010H\",\"name\":\"Joaqun_Cobos\",\"vlan\":881,\"line_profile\":\"HG8010H\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(159,1,'HWTC8F07C4AF','Ignacio_Lopez','0/4',10,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":10,\"serial_number\":\"HWTC8F07C4AF\",\"onu_type\":\"HG8141V5\",\"name\":\"Ignacio_Lopez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(160,1,'HWTC0FDB16B0','AlejandraHuerta-AlejandraHuerta','0/4',11,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":11,\"serial_number\":\"HWTC0FDB16B0\",\"onu_type\":\"HG8141V5\",\"name\":\"AlejandraHuerta-AlejandraHuerta\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:09','2026-01-29 19:00:56'),
(161,1,'HWTCC5950AAE','JuanManuelVar-JuanManuelVar','0/4',12,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":12,\"serial_number\":\"HWTCC5950AAE\",\"onu_type\":\"HG8141V5\",\"name\":\"JuanManuelVar-JuanManuelVar\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(162,1,'HWTCBC5732AE','FernandoDMojica-FernandoDMojica','0/4',13,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":13,\"serial_number\":\"HWTCBC5732AE\",\"onu_type\":\"HG8141V5\",\"name\":\"FernandoDMojica-FernandoDMojica\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(163,1,'HWTC0E58C0B1','RebecaGetcemani-RebecaGetcemani','0/4',14,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":14,\"serial_number\":\"HWTC0E58C0B1\",\"onu_type\":\"HG8141V5\",\"name\":\"RebecaGetcemani-RebecaGetcemani\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(164,1,'ZTEG24398C52','KevinCesarGuz-KevinCesarGuz','0/4',15,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-17.95,2.35,NULL,34.38,3.26,8.65,153.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":15,\"serial_number\":\"ZTEG24398C52\",\"onu_type\":\"HG8141V5\",\"name\":\"KevinCesarGuz-KevinCesarGuz\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.95,\"tx_power\":2.35,\"voltage\":3.26,\"bias_current\":8.65,\"temperature\":34.375,\"distance\":1531}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(165,1,'ALCLFC25AECD','Abraham_Camarillo_Reyes-Abraham','0/4',16,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-17.19,2.54,NULL,43.00,3.24,9.44,145.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":16,\"serial_number\":\"ALCLFC25AECD\",\"onu_type\":\"HG8141V5\",\"name\":\"Abraham_Camarillo_Reyes-Abraham\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.19,\"tx_power\":2.54,\"voltage\":3.24,\"bias_current\":9.436,\"temperature\":43,\"distance\":1450}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(166,1,'ALCLFC6307D1','AnaAliciaGarcia-AnaAliciaGarcia','0/4',17,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":17,\"serial_number\":\"ALCLFC6307D1\",\"onu_type\":\"HG8141V5\",\"name\":\"AnaAliciaGarcia-AnaAliciaGarcia\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(167,1,'HWTC0E51C3B1','EsmeraldaRivas-EsmeraldaRivas','0/4',18,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":18,\"serial_number\":\"HWTC0E51C3B1\",\"onu_type\":\"HG8141V5\",\"name\":\"EsmeraldaRivas-EsmeraldaRivas\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(168,1,'ZTEG24397503','LizettJazmin-LizettJazmin','0/4',19,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'HG8141V5',NULL,'ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":19,\"serial_number\":\"ZTEG24397503\",\"onu_type\":\"HG8141V5\",\"name\":\"LizettJazmin-LizettJazmin\",\"vlan\":null,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":null,\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(169,1,'ZTEG24398C41','Zuriel_Axel_Arteaga_Balderas-Zu','0/4',20,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-28.86,2.07,NULL,35.07,3.20,9.40,162.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":20,\"serial_number\":\"ZTEG24398C41\",\"onu_type\":\"HG8141V5\",\"name\":\"Zuriel_Axel_Arteaga_Balderas-Zu\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-28.86,\"tx_power\":2.07,\"voltage\":3.2,\"bias_current\":9.4,\"temperature\":35.066,\"distance\":1622}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(170,1,'ALCLFC67EBD9','HugoToxtega-HugoToxtega','0/4',21,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-19.39,2.47,NULL,36.80,3.24,12.21,140.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":21,\"serial_number\":\"ALCLFC67EBD9\",\"onu_type\":\"HG8141V5\",\"name\":\"HugoToxtega-HugoToxtega\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-19.39,\"tx_power\":2.47,\"voltage\":3.24,\"bias_current\":12.21,\"temperature\":36.801,\"distance\":1401}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(171,1,'ZTEG24518170','TomasRodriguez-TomasRodriguez','0/4',22,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-18.36,2.97,NULL,39.60,3.24,10.50,153.40,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":22,\"serial_number\":\"ZTEG24518170\",\"onu_type\":\"HG8141V5\",\"name\":\"TomasRodriguez-TomasRodriguez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.36,\"tx_power\":2.97,\"voltage\":3.24,\"bias_current\":10.5,\"temperature\":39.602,\"distance\":1534}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(172,1,'HWTC103C3AB2','EdmonJosephDeJes-EdmonJosephDeJ','0/4',23,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":23,\"serial_number\":\"HWTC103C3AB2\",\"onu_type\":\"HG8141V5\",\"name\":\"EdmonJosephDeJes-EdmonJosephDeJ\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(173,1,'FHTTC1771517','AlvaroXoloVel-AlvaroXoloVel','0/4',24,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-18.27,2.10,NULL,40.22,3.26,10.00,149.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":24,\"serial_number\":\"FHTTC1771517\",\"onu_type\":\"HG8141V5\",\"name\":\"AlvaroXoloVel-AlvaroXoloVel\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.27,\"tx_power\":2.1,\"voltage\":3.26,\"bias_current\":10,\"temperature\":40.219,\"distance\":1490}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(174,1,'FHTTBA9D7240','LizettJazminIriarte-LizettJazmi','0/4',25,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-20.09,2.28,NULL,41.15,3.30,6.85,162.30,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":25,\"serial_number\":\"FHTTBA9D7240\",\"onu_type\":\"HG8141V5\",\"name\":\"LizettJazminIriarte-LizettJazmi\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-20.09,\"tx_power\":2.28,\"voltage\":3.3,\"bias_current\":6.85,\"temperature\":41.148,\"distance\":1623}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(175,1,'FHTT9A124AD0','SaulCelestinoPereda-SaulCelesti','0/4',26,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":26,\"serial_number\":\"FHTT9A124AD0\",\"onu_type\":\"HG8141V5\",\"name\":\"SaulCelestinoPereda-SaulCelesti\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(176,1,'FHTT9E23C850','OliviaBeltranFer-OliviaBeltranF','0/4',27,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-14.93,2.18,NULL,43.97,3.34,9.93,155.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/4\",\"onu_id\":27,\"serial_number\":\"FHTT9E23C850\",\"onu_type\":\"HG8141V5\",\"name\":\"OliviaBeltranFer-OliviaBeltranF\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-14.93,\"tx_power\":2.18,\"voltage\":3.34,\"bias_current\":9.93,\"temperature\":43.969,\"distance\":1550}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(177,1,'ZTEG24186833',NULL,'0/5',1,'default','online',NULL,'2026-01-29 19:00:56',NULL,-14.94,2.44,NULL,42.04,3.26,10.65,66.80,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":1,\"serial_number\":\"ZTEG24186833\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-14.94,\"tx_power\":2.44,\"voltage\":3.26,\"bias_current\":10.65,\"temperature\":42.039,\"distance\":668}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(178,1,'HWTCA37786AE',NULL,'0/5',2,'default','online',NULL,'2026-01-29 19:00:56',NULL,-14.74,2.18,NULL,44.00,3.36,9.00,66.00,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":2,\"serial_number\":\"HWTCA37786AE\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-14.74,\"tx_power\":2.18,\"voltage\":3.36,\"bias_current\":9,\"temperature\":44,\"distance\":660}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(179,1,'HWTCD82AF4AF',NULL,'0/5',3,'default','online',NULL,'2026-01-29 19:00:56',NULL,-13.94,2.29,NULL,49.00,3.32,11.00,73.90,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":3,\"serial_number\":\"HWTCD82AF4AF\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-13.94,\"tx_power\":2.29,\"voltage\":3.32,\"bias_current\":11,\"temperature\":49,\"distance\":739}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(180,1,'HWTCBC6594AE',NULL,'0/5',4,'default','online',NULL,'2026-01-29 19:00:56',NULL,-15.83,2.21,NULL,51.00,3.30,10.00,68.00,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":4,\"serial_number\":\"HWTCBC6594AE\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-15.83,\"tx_power\":2.21,\"voltage\":3.3,\"bias_current\":10,\"temperature\":51,\"distance\":680}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(181,1,'HWTC0E56A2B1',NULL,'0/5',5,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":5,\"serial_number\":\"HWTC0E56A2B1\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(182,1,'ZTEG242640D7',NULL,'0/5',6,'default','online',NULL,'2026-01-29 19:00:56',NULL,-13.79,2.23,NULL,38.90,3.26,11.65,71.20,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":6,\"serial_number\":\"ZTEG242640D7\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-13.79,\"tx_power\":2.23,\"voltage\":3.26,\"bias_current\":11.65,\"temperature\":38.902,\"distance\":712}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(183,1,'ZTEG24264109',NULL,'0/5',7,'default','online',NULL,'2026-01-29 19:00:56',NULL,-17.86,2.71,NULL,41.00,3.24,11.30,62.20,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":7,\"serial_number\":\"ZTEG24264109\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-17.86,\"tx_power\":2.71,\"voltage\":3.24,\"bias_current\":11.3,\"temperature\":41,\"distance\":622}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(184,1,'HWTC104452B2',NULL,'0/5',8,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":8,\"serial_number\":\"HWTC104452B2\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(185,1,'ALCLFCE62F74',NULL,'0/5',9,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":9,\"serial_number\":\"ALCLFCE62F74\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(186,1,'FHTT9E289370','MoisesTorresTrin-MoisesTorresTr','0/6',52,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-22.68,2.10,NULL,43.83,3.34,9.24,150.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":52,\"serial_number\":\"FHTT9E289370\",\"onu_type\":\"HG8141V5\",\"name\":\"MoisesTorresTrin-MoisesTorresTr\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-22.68,\"tx_power\":2.1,\"voltage\":3.34,\"bias_current\":9.24,\"temperature\":43.828,\"distance\":1501}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(187,1,'FHTTC11B2BC8',NULL,'0/5',11,'default','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":11,\"serial_number\":\"FHTTC11B2BC8\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(188,1,'FHTT9E9C3538',NULL,'0/5',12,'default','online',NULL,'2026-01-29 19:00:56',NULL,-14.32,2.14,NULL,41.12,3.34,10.08,68.50,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":12,\"serial_number\":\"FHTT9E9C3538\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-14.32,\"tx_power\":2.14,\"voltage\":3.34,\"bias_current\":10.08,\"temperature\":41.117,\"distance\":685}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(189,1,'FHTTBA9B8FF8',NULL,'0/5',13,'default','online',NULL,'2026-01-29 19:00:56',NULL,-20.04,2.03,NULL,38.91,3.26,6.14,113.10,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":13,\"serial_number\":\"FHTTBA9B8FF8\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-20.04,\"tx_power\":2.03,\"voltage\":3.26,\"bias_current\":6.14,\"temperature\":38.906,\"distance\":1131}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(190,1,'FHTT9A0396F0',NULL,'0/5',14,'default','online',NULL,'2026-01-29 19:00:56',NULL,-23.98,2.72,NULL,39.00,3.24,6.00,115.50,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":14,\"serial_number\":\"FHTT9A0396F0\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-23.98,\"tx_power\":2.72,\"voltage\":3.24,\"bias_current\":6,\"temperature\":39,\"distance\":1155}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(191,1,'FHTT9ED3BCB0',NULL,'0/5',15,'default','online',NULL,'2026-01-29 19:00:56',NULL,-19.24,1.85,NULL,40.40,3.34,7.85,112.70,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":15,\"serial_number\":\"FHTT9ED3BCB0\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-19.24,\"tx_power\":1.85,\"voltage\":3.34,\"bias_current\":7.85,\"temperature\":40.398,\"distance\":1127}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(192,1,'FHTT9CD70EB8',NULL,'0/5',16,'default','online',NULL,'2026-01-29 19:00:56',NULL,-21.25,2.16,NULL,42.34,3.34,8.33,120.70,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":16,\"serial_number\":\"FHTT9CD70EB8\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-21.25,\"tx_power\":2.16,\"voltage\":3.34,\"bias_current\":8.33,\"temperature\":42.34,\"distance\":1207}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(193,1,'FHTT9E2CBB30',NULL,'0/5',17,'default','online',NULL,'2026-01-29 19:00:56',NULL,-19.07,2.23,NULL,43.42,3.36,10.99,107.90,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":17,\"serial_number\":\"FHTT9E2CBB30\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-19.07,\"tx_power\":2.23,\"voltage\":3.36,\"bias_current\":10.99,\"temperature\":43.418,\"distance\":1079}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(194,1,'FHTT9E2671A8',NULL,'0/5',18,'default','online',NULL,'2026-01-29 19:00:56',NULL,-13.63,2.06,NULL,43.56,3.36,10.14,72.00,NULL,'default',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/5\",\"onu_id\":18,\"serial_number\":\"FHTT9E2671A8\",\"onu_type\":\"default\",\"name\":null,\"vlan\":null,\"line_profile\":\"default\",\"dba_profile\":null,\"service_profile\":null,\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-13.63,\"tx_power\":2.06,\"voltage\":3.36,\"bias_current\":10.14,\"temperature\":43.559,\"distance\":720}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(195,1,'HWTC103790B2','AuriaEstelaFl-AuriaEstelaFl','0/6',3,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":3,\"serial_number\":\"HWTC103790B2\",\"onu_type\":\"HG8141V5\",\"name\":\"AuriaEstelaFl-AuriaEstelaFl\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(196,1,'ZTEG23382709','AngelDeJeMun-AngelDeJeMun','0/6',4,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-15.40,2.18,NULL,36.11,3.24,11.55,134.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":4,\"serial_number\":\"ZTEG23382709\",\"onu_type\":\"HG8141V5\",\"name\":\"AngelDeJeMun-AngelDeJeMun\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-15.4,\"tx_power\":2.18,\"voltage\":3.24,\"bias_current\":11.55,\"temperature\":36.113,\"distance\":1346}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(197,1,'ZTEG2504D177','IvonnelisethPin-IvonnelisethPin','0/6',5,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-17.09,2.29,NULL,37.51,3.24,9.30,134.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":5,\"serial_number\":\"ZTEG2504D177\",\"onu_type\":\"HG8141V5\",\"name\":\"IvonnelisethPin-IvonnelisethPin\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.09,\"tx_power\":2.29,\"voltage\":3.24,\"bias_current\":9.3,\"temperature\":37.508,\"distance\":1347}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(198,1,'HWTC906846B0','BrendaUscangaC-BrendaUscangaC','0/6',6,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":6,\"serial_number\":\"HWTC906846B0\",\"onu_type\":\"HG8141V5\",\"name\":\"BrendaUscangaC-BrendaUscangaC\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(199,1,'HWTCA0FF02B1','AraceliTemichTos-AraceliTemichT','0/6',7,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":7,\"serial_number\":\"HWTCA0FF02B1\",\"onu_type\":\"HG8141V5\",\"name\":\"AraceliTemichTos-AraceliTemichT\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(200,1,'HWTCA0CE54B1',NULL,'0/6',8,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-23.07,2.22,NULL,41.00,3.34,8.00,138.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":8,\"serial_number\":\"HWTCA0CE54B1\",\"onu_type\":\"HG8141V5\",\"name\":null,\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.07,\"tx_power\":2.22,\"voltage\":3.34,\"bias_current\":8,\"temperature\":41,\"distance\":1389}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(201,1,'HWTCA0DC63B1','IsabelCruzVel-IsabelCruzVel','0/6',9,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-20.42,2.32,NULL,39.00,3.34,9.00,140.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":9,\"serial_number\":\"HWTCA0DC63B1\",\"onu_type\":\"HG8141V5\",\"name\":\"IsabelCruzVel-IsabelCruzVel\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-20.42,\"tx_power\":2.32,\"voltage\":3.34,\"bias_current\":9,\"temperature\":39,\"distance\":1405}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(202,1,'HWTCF9EBCCB0','AlejanderChagaCop-AlejanderChag','0/6',10,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-20.32,2.22,NULL,49.00,3.32,10.00,133.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":10,\"serial_number\":\"HWTCF9EBCCB0\",\"onu_type\":\"HG8141V5\",\"name\":\"AlejanderChagaCop-AlejanderChag\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-20.32,\"tx_power\":2.22,\"voltage\":3.32,\"bias_current\":10,\"temperature\":49,\"distance\":1337}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(203,1,'HWTC5CD7F8B1','DayraMelissaSan-DayraMelissaSan','0/6',11,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-21.22,2.17,NULL,46.00,3.30,7.00,141.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":11,\"serial_number\":\"HWTC5CD7F8B1\",\"onu_type\":\"HG8141V5\",\"name\":\"DayraMelissaSan-DayraMelissaSan\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.22,\"tx_power\":2.17,\"voltage\":3.3,\"bias_current\":7,\"temperature\":46,\"distance\":1418}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(204,1,'HWTCA0BEE1B1','DavidOsirisLaz-DavidOsirisLaz','0/6',12,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-25.02,2.35,NULL,41.00,3.36,9.00,141.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":12,\"serial_number\":\"HWTCA0BEE1B1\",\"onu_type\":\"HG8141V5\",\"name\":\"DavidOsirisLaz-DavidOsirisLaz\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.02,\"tx_power\":2.35,\"voltage\":3.36,\"bias_current\":9,\"temperature\":41,\"distance\":1416}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(205,1,'ZTEG2431E0DD','SaraiNellySan-SaraiNellySan','0/6',13,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-22.10,2.31,NULL,38.21,3.26,10.65,132.30,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":13,\"serial_number\":\"ZTEG2431E0DD\",\"onu_type\":\"HG8141V5\",\"name\":\"SaraiNellySan-SaraiNellySan\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-22.1,\"tx_power\":2.31,\"voltage\":3.26,\"bias_current\":10.65,\"temperature\":38.207,\"distance\":1323}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(206,1,'ZTEG24281CB8','DafnePaholaVaz-DafnePaholaVaz','0/6',14,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-21.92,2.21,NULL,39.60,3.22,12.10,130.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":14,\"serial_number\":\"ZTEG24281CB8\",\"onu_type\":\"HG8141V5\",\"name\":\"DafnePaholaVaz-DafnePaholaVaz\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.92,\"tx_power\":2.21,\"voltage\":3.22,\"bias_current\":12.1,\"temperature\":39.602,\"distance\":1309}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(207,1,'HWTC7DA504AE','CarolinaGarciaMon-CarolinaGarci','0/6',16,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-19.47,1.97,NULL,52.00,3.30,11.00,133.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":16,\"serial_number\":\"HWTC7DA504AE\",\"onu_type\":\"HG8141V5\",\"name\":\"CarolinaGarciaMon-CarolinaGarci\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-19.47,\"tx_power\":1.97,\"voltage\":3.3,\"bias_current\":11,\"temperature\":52,\"distance\":1331}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(208,1,'ZTEG23334CCD','MariaDeLaPazRamirezCar-MariaDeL','0/6',17,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":17,\"serial_number\":\"ZTEG23334CCD\",\"onu_type\":\"HG8141V5\",\"name\":\"MariaDeLaPazRamirezCar-MariaDeL\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(209,1,'ZTEG24175232','AlejandraAcostaX-AlejandraAcost','0/6',18,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":18,\"serial_number\":\"ZTEG24175232\",\"onu_type\":\"HG8141V5\",\"name\":\"AlejandraAcostaX-AlejandraAcost\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(210,1,'ZTEG2431E11B','OscarGonzalezSantos-OscarGonzal','0/6',19,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":19,\"serial_number\":\"ZTEG2431E11B\",\"onu_type\":\"HG8141V5\",\"name\":\"OscarGonzalezSantos-OscarGonzal\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(211,1,'HWTC6E7D9DAF','RicardoJairBarragan-RicardoJair','0/6',20,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-24.57,2.06,NULL,45.00,3.32,8.00,126.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":20,\"serial_number\":\"HWTC6E7D9DAF\",\"onu_type\":\"HG8141V5\",\"name\":\"RicardoJairBarragan-RicardoJair\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.57,\"tx_power\":2.06,\"voltage\":3.32,\"bias_current\":8,\"temperature\":45,\"distance\":1261}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(212,1,'ZTEG21284CE4','MonicaMonserratCas-MonicaMonser','0/6',21,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":21,\"serial_number\":\"ZTEG21284CE4\",\"onu_type\":\"HG8141V5\",\"name\":\"MonicaMonserratCas-MonicaMonser\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(213,1,'HWTC68BE7EB3','RosaSerranoRa-RosaSerranoRa','0/6',22,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-19.23,2.44,NULL,39.00,3.30,10.00,144.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":22,\"serial_number\":\"HWTC68BE7EB3\",\"onu_type\":\"HG8141V5\",\"name\":\"RosaSerranoRa-RosaSerranoRa\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-19.23,\"tx_power\":2.44,\"voltage\":3.3,\"bias_current\":10,\"temperature\":39,\"distance\":1441}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(214,1,'HWTC68BC02B3','ElideMartinezLa-ElideMartinezLa','0/6',23,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-21.33,2.07,NULL,45.00,3.30,9.00,139.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":23,\"serial_number\":\"HWTC68BC02B3\",\"onu_type\":\"HG8141V5\",\"name\":\"ElideMartinezLa-ElideMartinezLa\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.33,\"tx_power\":2.07,\"voltage\":3.3,\"bias_current\":9,\"temperature\":45,\"distance\":1392}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(215,1,'HWTC68A90BB3','ZarettDeJesusPe-ZarettDeJesusPe','0/6',24,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":24,\"serial_number\":\"HWTC68A90BB3\",\"onu_type\":\"HG8141V5\",\"name\":\"ZarettDeJesusPe-ZarettDeJesusPe\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(216,1,'HWTCB08A3BB1','EdwinMoisesRom-EdwinMoisesRom','0/6',25,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":25,\"serial_number\":\"HWTCB08A3BB1\",\"onu_type\":\"HG8141V5\",\"name\":\"EdwinMoisesRom-EdwinMoisesRom\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(217,1,'HWTC103883B2','AlexanderArturoMax-AlexanderArt','0/6',26,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":26,\"serial_number\":\"HWTC103883B2\",\"onu_type\":\"HG8141V5\",\"name\":\"AlexanderArturoMax-AlexanderArt\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(218,1,'ZTEG2504C2F1','AlmaDelfinaAma-AlmaDelfinaAma','0/6',27,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":27,\"serial_number\":\"ZTEG2504C2F1\",\"onu_type\":\"HG8141V5\",\"name\":\"AlmaDelfinaAma-AlmaDelfinaAma\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(219,1,'ZTEG24258C7F','PaolaMoralesPal-PaolaMoralesPal','0/6',28,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-20.42,2.03,NULL,41.00,3.34,9.00,140.80,NULL,'HG8141V5',NULL,'ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":28,\"serial_number\":\"ZTEG24258C7F\",\"onu_type\":\"HG8141V5\",\"name\":\"PaolaMoralesPal-PaolaMoralesPal\",\"vlan\":null,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":null,\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-20.42,\"tx_power\":2.03,\"voltage\":3.34,\"bias_current\":9,\"temperature\":41,\"distance\":1408}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(220,1,'HWTCB07830B1','GabrielaBelliAn-GabrielaBelliAn','0/6',29,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-19.13,2.28,NULL,42.00,3.28,7.00,141.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":29,\"serial_number\":\"HWTCB07830B1\",\"onu_type\":\"HG8141V5\",\"name\":\"GabrielaBelliAn-GabrielaBelliAn\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-19.13,\"tx_power\":2.28,\"voltage\":3.28,\"bias_current\":7,\"temperature\":42,\"distance\":1411}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(221,1,'HWTCB09ACDB1','ElviraLandaLo-ElviraLandaLo','0/6',30,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-16.58,2.31,NULL,41.00,3.30,9.00,126.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":30,\"serial_number\":\"HWTCB09ACDB1\",\"onu_type\":\"HG8141V5\",\"name\":\"ElviraLandaLo-ElviraLandaLo\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-16.58,\"tx_power\":2.31,\"voltage\":3.3,\"bias_current\":9,\"temperature\":41,\"distance\":1268}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(222,1,'HWTCE2A8A3A3','AlejandroDavidUrb-AlejandroDavi','0/6',31,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-23.77,2.31,NULL,51.00,3.42,10.00,132.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":31,\"serial_number\":\"HWTCE2A8A3A3\",\"onu_type\":\"HG8141V5\",\"name\":\"AlejandroDavidUrb-AlejandroDavi\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.77,\"tx_power\":2.31,\"voltage\":3.42,\"bias_current\":10,\"temperature\":51,\"distance\":1327}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(223,1,'ALCLFC6E1DD6','EstefaniLizethFlo-EstefaniLizet','0/6',32,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-25.53,2.35,NULL,40.60,3.24,9.88,136.30,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":32,\"serial_number\":\"ALCLFC6E1DD6\",\"onu_type\":\"HG8141V5\",\"name\":\"EstefaniLizethFlo-EstefaniLizet\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.53,\"tx_power\":2.35,\"voltage\":3.24,\"bias_current\":9.88,\"temperature\":40.602,\"distance\":1363}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(224,1,'HWTC1037D2B2','RamonZalazarPas-RamonZalazarPas','0/6',33,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-18.30,2.20,NULL,41.00,3.30,8.00,117.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":33,\"serial_number\":\"HWTC1037D2B2\",\"onu_type\":\"HG8141V5\",\"name\":\"RamonZalazarPas-RamonZalazarPas\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.3,\"tx_power\":2.2,\"voltage\":3.3,\"bias_current\":8,\"temperature\":41,\"distance\":1170}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(225,1,'HWTCD81700AF','JuanCarlosFernandezLa-JuanCarlo','0/6',35,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":35,\"serial_number\":\"HWTCD81700AF\",\"onu_type\":\"HG8141V5\",\"name\":\"JuanCarlosFernandezLa-JuanCarlo\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":null,\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(226,1,'ZTEG24500574','MagdalenaCorreaPer-MagdalenaCor','0/6',36,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-16.08,2.80,NULL,37.86,3.22,11.05,134.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":36,\"serial_number\":\"ZTEG24500574\",\"onu_type\":\"HG8141V5\",\"name\":\"MagdalenaCorreaPer-MagdalenaCor\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-16.08,\"tx_power\":2.8,\"voltage\":3.22,\"bias_current\":11.05,\"temperature\":37.855,\"distance\":1346}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(227,1,'HWTCCEA1A2AE','DoloresRamirezBri-DoloresRamire','0/6',37,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":37,\"serial_number\":\"HWTCCEA1A2AE\",\"onu_type\":\"HG8141V5\",\"name\":\"DoloresRamirezBri-DoloresRamire\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(228,1,'ZTEG24285AD9','JeronimoMoralesSal-JeronimoMora','0/6',38,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-18.96,2.17,NULL,39.60,3.22,10.00,142.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":38,\"serial_number\":\"ZTEG24285AD9\",\"onu_type\":\"HG8141V5\",\"name\":\"JeronimoMoralesSal-JeronimoMora\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.96,\"tx_power\":2.17,\"voltage\":3.22,\"bias_current\":10,\"temperature\":39.602,\"distance\":1425}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(229,1,'ZTEG241816E3','DianaRamonHer-DianaRamonHer','0/6',39,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-18.43,2.12,NULL,37.16,3.28,10.40,138.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":39,\"serial_number\":\"ZTEG241816E3\",\"onu_type\":\"HG8141V5\",\"name\":\"DianaRamonHer-DianaRamonHer\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.43,\"tx_power\":2.12,\"voltage\":3.28,\"bias_current\":10.4,\"temperature\":37.16,\"distance\":1389}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(230,1,'HWTCE2B0AFB0','ViridianaSalasMora-ViridianaSal','0/6',40,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-18.93,2.23,NULL,45.00,3.32,9.00,142.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":40,\"serial_number\":\"HWTCE2B0AFB0\",\"onu_type\":\"HG8141V5\",\"name\":\"ViridianaSalasMora-ViridianaSal\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.93,\"tx_power\":2.23,\"voltage\":3.32,\"bias_current\":9,\"temperature\":45,\"distance\":1421}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(231,1,'ZTEG24285AE8','ClaraCeciliaLara-ClaraCeciliaLa','0/6',41,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-19.27,2.48,NULL,39.60,3.24,9.90,145.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":41,\"serial_number\":\"ZTEG24285AE8\",\"onu_type\":\"HG8141V5\",\"name\":\"ClaraCeciliaLara-ClaraCeciliaLa\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-19.27,\"tx_power\":2.48,\"voltage\":3.24,\"bias_current\":9.9,\"temperature\":39.602,\"distance\":1450}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(232,1,'ALCLFC68298E','MirianOdettGonz-MirianOdettGonz','0/6',42,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-18.70,2.38,NULL,41.50,3.24,10.10,140.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":42,\"serial_number\":\"ALCLFC68298E\",\"onu_type\":\"HG8141V5\",\"name\":\"MirianOdettGonz-MirianOdettGonz\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.7,\"tx_power\":2.38,\"voltage\":3.24,\"bias_current\":10.1,\"temperature\":41.5,\"distance\":1401}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(233,1,'HWTCAEBC5AAF','GretelMonseGuz-GretelMonseGuz','0/6',43,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-16.02,2.21,NULL,45.00,3.32,11.00,125.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":43,\"serial_number\":\"HWTCAEBC5AAF\",\"onu_type\":\"HG8141V5\",\"name\":\"GretelMonseGuz-GretelMonseGuz\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-16.02,\"tx_power\":2.21,\"voltage\":3.32,\"bias_current\":11,\"temperature\":45,\"distance\":1251}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(234,1,'ALCLFC67EBEB','GeorginaPalaciosZur-GeorginaPal','0/6',44,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-17.38,2.43,NULL,34.50,3.24,13.10,137.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":44,\"serial_number\":\"ALCLFC67EBEB\",\"onu_type\":\"HG8141V5\",\"name\":\"GeorginaPalaciosZur-GeorginaPal\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.38,\"tx_power\":2.43,\"voltage\":3.24,\"bias_current\":13.098,\"temperature\":34.5,\"distance\":1370}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(235,1,'HWTCAEBE93AF','EsperanzaCozarFer-EsperanzaCoza','0/6',45,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-17.42,2.17,NULL,52.00,3.38,10.00,137.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":45,\"serial_number\":\"HWTCAEBE93AF\",\"onu_type\":\"HG8141V5\",\"name\":\"EsperanzaCozarFer-EsperanzaCoza\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.42,\"tx_power\":2.17,\"voltage\":3.38,\"bias_current\":10,\"temperature\":52,\"distance\":1376}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(236,1,'FHTT9BE641E8','JanCarloGonza-JanCarloGonza','0/6',46,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":46,\"serial_number\":\"FHTT9BE641E8\",\"onu_type\":\"HG8141V5\",\"name\":\"JanCarloGonza-JanCarloGonza\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(237,1,'FHTT9A02C5C8','ValeriaAlvarezLev-ValeriaAlvare','0/6',47,'HG8141V5','online',NULL,'2026-01-29 19:00:56',NULL,-18.95,2.68,NULL,49.83,3.22,10.00,141.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":47,\"serial_number\":\"FHTT9A02C5C8\",\"onu_type\":\"HG8141V5\",\"name\":\"ValeriaAlvarezLev-ValeriaAlvare\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.95,\"tx_power\":2.68,\"voltage\":3.22,\"bias_current\":10,\"temperature\":49.828,\"distance\":1416}','2026-01-29 19:00:56',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:56'),
(238,1,'FHTT9BCA47B0','LuisMarioMontes-LuisMarioMontes','0/6',48,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-17.99,2.51,NULL,51.56,3.34,13.75,126.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":48,\"serial_number\":\"FHTT9BCA47B0\",\"onu_type\":\"HG8141V5\",\"name\":\"LuisMarioMontes-LuisMarioMontes\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.99,\"tx_power\":2.51,\"voltage\":3.34,\"bias_current\":13.75,\"temperature\":51.559,\"distance\":1262}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(239,1,'FHTTC176EFAC','JoseTurincioRo-JoseTurincioRo','0/6',49,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-27.96,1.82,NULL,41.33,3.26,11.22,157.30,881,'HG8141V5','INTERNET',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":49,\"serial_number\":\"FHTTC176EFAC\",\"onu_type\":\"HG8141V5\",\"name\":\"JoseTurincioRo-JoseTurincioRo\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":null,\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-27.96,\"tx_power\":1.82,\"voltage\":3.26,\"bias_current\":11.22,\"temperature\":41.328,\"distance\":1573}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(240,1,'FHTT9D72E898','SelinaArellanoPer-SelinaArellan','0/6',50,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-17.64,1.93,NULL,44.10,3.32,8.68,145.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":50,\"serial_number\":\"FHTT9D72E898\",\"onu_type\":\"HG8141V5\",\"name\":\"SelinaArellanoPer-SelinaArellan\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.64,\"tx_power\":1.93,\"voltage\":3.32,\"bias_current\":8.68,\"temperature\":44.098,\"distance\":1452}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(241,1,'FHTTC17703BC','IsmaelJimenezRiv-IsmaelJimenezR','0/6',51,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-21.61,2.21,NULL,40.22,3.30,9.38,125.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":51,\"serial_number\":\"FHTTC17703BC\",\"onu_type\":\"HG8141V5\",\"name\":\"IsmaelJimenezRiv-IsmaelJimenezR\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.61,\"tx_power\":2.21,\"voltage\":3.3,\"bias_current\":9.38,\"temperature\":40.219,\"distance\":1258}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(242,1,'FHTT9E9CC178','CristianVazquezCha-CristianVazq','0/6',53,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-21.80,2.03,NULL,42.34,3.32,9.52,142.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":53,\"serial_number\":\"FHTT9E9CC178\",\"onu_type\":\"HG8141V5\",\"name\":\"CristianVazquezCha-CristianVazq\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.8,\"tx_power\":2.03,\"voltage\":3.32,\"bias_current\":9.52,\"temperature\":42.34,\"distance\":1420}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(243,1,'FHTT9CC88228','EstebanEsmedicheCa-EstebanEsmed','0/6',54,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-18.24,2.00,NULL,43.42,3.32,8.85,143.40,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":54,\"serial_number\":\"FHTT9CC88228\",\"onu_type\":\"HG8141V5\",\"name\":\"EstebanEsmedicheCa-EstebanEsmed\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.24,\"tx_power\":2,\"voltage\":3.32,\"bias_current\":8.85,\"temperature\":43.418,\"distance\":1434}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(244,1,'FHTTC103C2C8','MariaElenaMoralesBra-MariaElena','0/6',55,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-18.79,2.22,NULL,40.22,3.26,10.00,153.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":55,\"serial_number\":\"FHTTC103C2C8\",\"onu_type\":\"HG8141V5\",\"name\":\"MariaElenaMoralesBra-MariaElena\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.79,\"tx_power\":2.22,\"voltage\":3.26,\"bias_current\":10,\"temperature\":40.219,\"distance\":1535}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(245,1,'FHTT9CE4DD90',NULL,'0/6',56,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-26.58,2.04,NULL,42.34,3.32,8.68,139.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":56,\"serial_number\":\"FHTT9CE4DD90\",\"onu_type\":\"HG8141V5\",\"name\":null,\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-26.58,\"tx_power\":2.04,\"voltage\":3.32,\"bias_current\":8.68,\"temperature\":42.34,\"distance\":1392}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(246,1,'FHTT9E25D4F8','ArtemioRomeroTorres-ArtemioRome','0/6',57,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-19.07,2.08,NULL,44.24,3.38,9.93,148.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":57,\"serial_number\":\"FHTT9E25D4F8\",\"onu_type\":\"HG8141V5\",\"name\":\"ArtemioRomeroTorres-ArtemioRome\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-19.07,\"tx_power\":2.08,\"voltage\":3.38,\"bias_current\":9.93,\"temperature\":44.238,\"distance\":1481}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(247,1,'FHTT9ED7C190','CristianAlexaCruz-CristianAlexa','0/6',58,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-26.38,2.23,NULL,39.84,3.34,6.43,150.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":58,\"serial_number\":\"FHTT9ED7C190\",\"onu_type\":\"HG8141V5\",\"name\":\"CristianAlexaCruz-CristianAlexa\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-26.38,\"tx_power\":2.23,\"voltage\":3.34,\"bias_current\":6.43,\"temperature\":39.84,\"distance\":1509}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(248,1,'FHTT9A098960','GustavoHerreraRod-GustavoHerrer','0/6',59,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":59,\"serial_number\":\"FHTT9A098960\",\"onu_type\":\"HG8141V5\",\"name\":\"GustavoHerreraRod-GustavoHerrer\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(249,1,'ZTEG24181842','MaribelRosadoTello-MaribelRosad','0/6',60,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-25.02,2.74,NULL,40.30,3.22,10.15,148.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":60,\"serial_number\":\"ZTEG24181842\",\"onu_type\":\"HG8141V5\",\"name\":\"MaribelRosadoTello-MaribelRosad\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.02,\"tx_power\":2.74,\"voltage\":3.22,\"bias_current\":10.15,\"temperature\":40.297,\"distance\":1488}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(250,1,'FHTT9EB45C20','XimenaDelCarmenCamp-XimenaDelCa','0/6',61,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-25.53,2.01,NULL,40.03,3.30,7.43,153.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":61,\"serial_number\":\"FHTT9EB45C20\",\"onu_type\":\"HG8141V5\",\"name\":\"XimenaDelCarmenCamp-XimenaDelCa\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-25.53,\"tx_power\":2.01,\"voltage\":3.3,\"bias_current\":7.43,\"temperature\":40.027,\"distance\":1539}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(251,1,'FHTT9CF29588','JoseAntonioPolito-JoseAntonioPo','0/6',62,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-24.56,1.93,NULL,39.90,3.32,8.09,153.40,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":62,\"serial_number\":\"FHTT9CF29588\",\"onu_type\":\"HG8141V5\",\"name\":\"JoseAntonioPolito-JoseAntonioPo\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.56,\"tx_power\":1.93,\"voltage\":3.32,\"bias_current\":8.09,\"temperature\":39.898,\"distance\":1534}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(252,1,'FHTTBA9BF7F0','YesicaCruzHernadez-YesicaCruzHe','0/6',64,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-21.02,2.08,NULL,40.40,3.28,6.43,139.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":64,\"serial_number\":\"FHTTBA9BF7F0\",\"onu_type\":\"HG8141V5\",\"name\":\"YesicaCruzHernadez-YesicaCruzHe\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.02,\"tx_power\":2.08,\"voltage\":3.28,\"bias_current\":6.43,\"temperature\":40.398,\"distance\":1396}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(253,1,'FHTT9EB3AB48','JohanaVazquezOrte-JohanaVazquez','0/6',65,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-23.67,1.99,NULL,41.33,3.30,8.43,151.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":65,\"serial_number\":\"FHTT9EB3AB48\",\"onu_type\":\"HG8141V5\",\"name\":\"JohanaVazquezOrte-JohanaVazquez\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.67,\"tx_power\":1.99,\"voltage\":3.3,\"bias_current\":8.43,\"temperature\":41.328,\"distance\":1516}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(254,1,'ZTEG2339A930','MaraCastilloGuz-MaraCastilloGuz','0/6',66,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-27.04,2.25,NULL,39.95,3.24,12.50,153.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":66,\"serial_number\":\"ZTEG2339A930\",\"onu_type\":\"HG8141V5\",\"name\":\"MaraCastilloGuz-MaraCastilloGuz\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-27.04,\"tx_power\":2.25,\"voltage\":3.24,\"bias_current\":12.5,\"temperature\":39.949,\"distance\":1536}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(255,1,'FHTT9EB44B08','EliseoLazaroPas-EliseoLazaroPas','0/6',67,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-22.52,2.20,NULL,40.59,3.26,7.00,157.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":67,\"serial_number\":\"FHTT9EB44B08\",\"onu_type\":\"HG8141V5\",\"name\":\"EliseoLazaroPas-EliseoLazaroPas\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-22.52,\"tx_power\":2.2,\"voltage\":3.26,\"bias_current\":7,\"temperature\":40.59,\"distance\":1578}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(256,1,'HWTCAEB2BAAF','IvanRuizSalazar-IvanRuizSalazar','0/6',68,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-16.27,2.29,NULL,53.00,3.38,11.00,116.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":68,\"serial_number\":\"HWTCAEB2BAAF\",\"onu_type\":\"HG8141V5\",\"name\":\"IvanRuizSalazar-IvanRuizSalazar\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-16.27,\"tx_power\":2.29,\"voltage\":3.38,\"bias_current\":11,\"temperature\":53,\"distance\":1162}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(257,1,'FHTT9E2B68F8','JesusMezaAguilar-JesusMezaAguil','0/6',69,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-27.70,1.96,NULL,43.15,3.40,9.89,153.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":69,\"serial_number\":\"FHTT9E2B68F8\",\"onu_type\":\"HG8141V5\",\"name\":\"JesusMezaAguilar-JesusMezaAguil\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-27.7,\"tx_power\":1.96,\"voltage\":3.4,\"bias_current\":9.89,\"temperature\":43.148,\"distance\":1536}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(258,1,'FHTT9BE66B40','JairoDavidVicente-JairoDavidVic','0/6',70,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-23.37,2.71,NULL,43.56,3.30,10.39,157.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":70,\"serial_number\":\"FHTT9BE66B40\",\"onu_type\":\"HG8141V5\",\"name\":\"JairoDavidVicente-JairoDavidVic\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.37,\"tx_power\":2.71,\"voltage\":3.3,\"bias_current\":10.39,\"temperature\":43.559,\"distance\":1575}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(259,1,'ZTEG25042D26','JoseAntonioArrieta-JoseAntonioA','0/6',71,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":71,\"serial_number\":\"ZTEG25042D26\",\"onu_type\":\"HG8141V5\",\"name\":\"JoseAntonioArrieta-JoseAntonioA\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(260,1,'ALCLB47DF3D0','MariaEnriquetaToral-MariaEnriqu','0/6',72,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-14.63,2.53,NULL,35.20,3.24,9.32,127.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":72,\"serial_number\":\"ALCLB47DF3D0\",\"onu_type\":\"HG8141V5\",\"name\":\"MariaEnriquetaToral-MariaEnriqu\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-14.63,\"tx_power\":2.53,\"voltage\":3.24,\"bias_current\":9.324,\"temperature\":35.199,\"distance\":1271}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(261,1,'FHTTBAA15730','MoisesPerezGarcia-MoisesPerezGa','0/6',73,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-15.83,2.14,NULL,40.96,3.36,7.14,152.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":73,\"serial_number\":\"FHTTBAA15730\",\"onu_type\":\"HG8141V5\",\"name\":\"MoisesPerezGarcia-MoisesPerezGa\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-15.83,\"tx_power\":2.14,\"voltage\":3.36,\"bias_current\":7.14,\"temperature\":40.957,\"distance\":1522}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(262,1,'FHTTC18B9377','RosaMoralesConde-RosaMoralesCon','0/6',75,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-23.01,2.03,NULL,40.22,3.30,10.61,157.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":75,\"serial_number\":\"FHTTC18B9377\",\"onu_type\":\"HG8141V5\",\"name\":\"RosaMoralesConde-RosaMoralesCon\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.01,\"tx_power\":2.03,\"voltage\":3.3,\"bias_current\":10.61,\"temperature\":40.219,\"distance\":1577}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(263,1,'FHTTC1908269','GertrudisBallardoCor-GertrudisB','0/6',76,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-18.39,2.18,NULL,38.55,3.30,8.97,149.70,NULL,'HG8141V5',NULL,'ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":76,\"serial_number\":\"FHTTC1908269\",\"onu_type\":\"HG8141V5\",\"name\":\"GertrudisBallardoCor-GertrudisB\",\"vlan\":null,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":null,\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.39,\"tx_power\":2.18,\"voltage\":3.3,\"bias_current\":8.97,\"temperature\":38.547,\"distance\":1497}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(264,1,'FHTTC12F963E','GiselMontezIsidoro-GiselMontezI','0/6',77,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-24.56,2.32,NULL,41.15,3.30,11.63,152.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":77,\"serial_number\":\"FHTTC12F963E\",\"onu_type\":\"HG8141V5\",\"name\":\"GiselMontezIsidoro-GiselMontezI\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.56,\"tx_power\":2.32,\"voltage\":3.3,\"bias_current\":11.63,\"temperature\":41.148,\"distance\":1526}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(265,1,'FHTTC17A5B68','JuanaFloresPacheco-JuanaFloresP','0/6',78,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-24.32,1.99,NULL,41.33,3.26,11.02,151.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":78,\"serial_number\":\"FHTTC17A5B68\",\"onu_type\":\"HG8141V5\",\"name\":\"JuanaFloresPacheco-JuanaFloresP\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.32,\"tx_power\":1.99,\"voltage\":3.26,\"bias_current\":11.02,\"temperature\":41.328,\"distance\":1515}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(266,1,'ZTEG2342BE32','EsperanzaAraceliSanchez-Esperan','0/6',79,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":79,\"serial_number\":\"ZTEG2342BE32\",\"onu_type\":\"HG8141V5\",\"name\":\"EsperanzaAraceliSanchez-Esperan\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(267,1,'ZTEG2428305F','CesarFloresRamirez-CesarFloresR','0/6',80,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-18.20,2.32,NULL,37.86,3.26,11.70,145.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":80,\"serial_number\":\"ZTEG2428305F\",\"onu_type\":\"HG8141V5\",\"name\":\"CesarFloresRamirez-CesarFloresR\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.2,\"tx_power\":2.32,\"voltage\":3.26,\"bias_current\":11.7,\"temperature\":37.855,\"distance\":1459}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(268,1,'FHTTBA931800','GeronimaBaizabalBeris-GeronimaB','0/6',81,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-15.50,2.17,NULL,40.22,3.28,6.85,156.40,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":81,\"serial_number\":\"FHTTBA931800\",\"onu_type\":\"HG8141V5\",\"name\":\"GeronimaBaizabalBeris-GeronimaB\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-15.5,\"tx_power\":2.17,\"voltage\":3.28,\"bias_current\":6.85,\"temperature\":40.219,\"distance\":1564}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(269,1,'FHTTC18B9BA8','EduardoEnriqueAnel-EduardoEnriq','0/6',82,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-28.54,2.02,NULL,44.12,3.32,12.24,153.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":82,\"serial_number\":\"FHTTC18B9BA8\",\"onu_type\":\"HG8141V5\",\"name\":\"EduardoEnriqueAnel-EduardoEnriq\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-28.54,\"tx_power\":2.02,\"voltage\":3.32,\"bias_current\":12.24,\"temperature\":44.117,\"distance\":1535}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(270,1,'FHTT999EC6A0','LeydiYirethChaga-LeydiYirethCha','0/6',83,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-25.09,2.86,NULL,40.12,3.22,6.14,156.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":83,\"serial_number\":\"FHTT999EC6A0\",\"onu_type\":\"HG8141V5\",\"name\":\"LeydiYirethChaga-LeydiYirethCha\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":null,\"status\":\"online\",\"rx_power\":-25.09,\"tx_power\":2.86,\"voltage\":3.22,\"bias_current\":6.14,\"temperature\":40.117,\"distance\":1567}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(271,1,'FHTT9BE7AA48','JessicaMoralesZamudio-JessicaMo','0/6',84,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-23.28,2.68,NULL,51.56,3.28,14.20,151.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":84,\"serial_number\":\"FHTT9BE7AA48\",\"onu_type\":\"HG8141V5\",\"name\":\"JessicaMoralesZamudio-JessicaMo\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.28,\"tx_power\":2.68,\"voltage\":3.28,\"bias_current\":14.2,\"temperature\":51.559,\"distance\":1515}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(272,1,'FHTT9CF4F4A8','EmmanuelAguierreHer-EmmanuelAgu','0/6',85,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-17.20,2.10,NULL,44.78,3.30,9.03,145.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":85,\"serial_number\":\"FHTT9CF4F4A8\",\"onu_type\":\"HG8141V5\",\"name\":\"EmmanuelAguierreHer-EmmanuelAgu\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.2,\"tx_power\":2.1,\"voltage\":3.3,\"bias_current\":9.03,\"temperature\":44.777,\"distance\":1457}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(273,1,'FHTT9B0EE190','YanetHernandezJaime-YanetHernan','0/6',86,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-18.36,2.62,NULL,41.24,3.26,7.56,152.40,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":86,\"serial_number\":\"FHTT9B0EE190\",\"onu_type\":\"HG8141V5\",\"name\":\"YanetHernandezJaime-YanetHernan\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.36,\"tx_power\":2.62,\"voltage\":3.26,\"bias_current\":7.56,\"temperature\":41.238,\"distance\":1524}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(274,1,'FHTT9CBACB58','MarthaGomezHerna-MarthaGomezHer','0/6',87,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":87,\"serial_number\":\"FHTT9CBACB58\",\"onu_type\":\"HG8141V5\",\"name\":\"MarthaGomezHerna-MarthaGomezHer\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(275,1,'FHTTBA9AEFD0','BeatrizVazquezVaz-BeatrizVazque','0/6',88,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-20.71,2.16,NULL,39.66,3.26,6.28,145.30,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":88,\"serial_number\":\"FHTTBA9AEFD0\",\"onu_type\":\"HG8141V5\",\"name\":\"BeatrizVazquezVaz-BeatrizVazque\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-20.71,\"tx_power\":2.16,\"voltage\":3.26,\"bias_current\":6.28,\"temperature\":39.656,\"distance\":1453}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(276,1,'FHTT9EB7E7E0','GabinoCastilloGonzalez-GabinoCa','0/6',89,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-16.16,2.09,NULL,40.78,3.28,7.00,152.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":89,\"serial_number\":\"FHTT9EB7E7E0\",\"onu_type\":\"HG8141V5\",\"name\":\"GabinoCastilloGonzalez-GabinoCa\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-16.16,\"tx_power\":2.09,\"voltage\":3.28,\"bias_current\":7,\"temperature\":40.777,\"distance\":1520}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(277,1,'FHTTBAA2FF48','DianaLauraChigoBax-DianaLauraCh','0/6',90,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-17.01,2.08,NULL,40.40,3.34,6.43,145.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":90,\"serial_number\":\"FHTTBAA2FF48\",\"onu_type\":\"HG8141V5\",\"name\":\"DianaLauraChigoBax-DianaLauraCh\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.01,\"tx_power\":2.08,\"voltage\":3.34,\"bias_current\":6.43,\"temperature\":40.398,\"distance\":1456}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(278,1,'FHTT9CC84E48','RomanAntonioMendoza-RomanAntoni','0/6',91,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-19.51,2.03,NULL,43.29,3.30,9.45,136.40,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":91,\"serial_number\":\"FHTT9CC84E48\",\"onu_type\":\"HG8141V5\",\"name\":\"RomanAntonioMendoza-RomanAntoni\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-19.51,\"tx_power\":2.03,\"voltage\":3.3,\"bias_current\":9.45,\"temperature\":43.289,\"distance\":1364}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(279,1,'FHTT9EC24EB8','YeseniaSantiagoCruz-YeseniaSant','0/6',92,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-22.15,2.15,NULL,40.78,3.32,8.28,155.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":92,\"serial_number\":\"FHTT9EC24EB8\",\"onu_type\":\"HG8141V5\",\"name\":\"YeseniaSantiagoCruz-YeseniaSant\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-22.15,\"tx_power\":2.15,\"voltage\":3.32,\"bias_current\":8.28,\"temperature\":40.777,\"distance\":1555}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(280,1,'FHTT9EA44830','AnaYareliBaizabalBer-AnaYareliB','0/6',93,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-21.94,2.26,NULL,43.02,3.28,9.10,151.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":93,\"serial_number\":\"FHTT9EA44830\",\"onu_type\":\"HG8141V5\",\"name\":\"AnaYareliBaizabalBer-AnaYareliB\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.94,\"tx_power\":2.26,\"voltage\":3.28,\"bias_current\":9.1,\"temperature\":43.02,\"distance\":1515}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(281,1,'FHTT9C696C08','DiegoCardenasOrtega-DiegoAlbert','0/6',94,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-21.74,2.36,NULL,42.88,3.32,10.29,146.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":94,\"serial_number\":\"FHTT9C696C08\",\"onu_type\":\"HG8141V5\",\"name\":\"DiegoCardenasOrtega-DiegoAlbert\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.74,\"tx_power\":2.36,\"voltage\":3.32,\"bias_current\":10.29,\"temperature\":42.879,\"distance\":1469}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(282,1,'FHTT99C31638','MariaDelCarmenVidanaDom-MariaDe','0/6',95,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-21.08,2.44,NULL,42.17,3.20,7.14,151.40,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":95,\"serial_number\":\"FHTT99C31638\",\"onu_type\":\"HG8141V5\",\"name\":\"MariaDelCarmenVidanaDom-MariaDe\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.08,\"tx_power\":2.44,\"voltage\":3.2,\"bias_current\":7.14,\"temperature\":42.168,\"distance\":1514}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(283,1,'FHTT9A17F228','AlmaEstelaNunesLo-AlmaEstelaNun','0/6',96,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-22.92,2.86,NULL,40.87,3.30,7.56,157.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":96,\"serial_number\":\"FHTT9A17F228\",\"onu_type\":\"HG8141V5\",\"name\":\"AlmaEstelaNunesLo-AlmaEstelaNun\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-22.92,\"tx_power\":2.86,\"voltage\":3.3,\"bias_current\":7.56,\"temperature\":40.867,\"distance\":1577}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(284,1,'FHTT9CF1C478','CarlosUrielDoblonFlo-CarlosUrie','0/6',97,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-15.70,2.22,NULL,42.88,3.30,9.10,139.40,881,'HG8141V5','INTERNET',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":97,\"serial_number\":\"FHTT9CF1C478\",\"onu_type\":\"HG8141V5\",\"name\":\"CarlosUrielDoblonFlo-CarlosUrie\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":null,\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-15.7,\"tx_power\":2.22,\"voltage\":3.3,\"bias_current\":9.1,\"temperature\":42.879,\"distance\":1394}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(285,1,'FHTT9EBD6888','Sy5W3eWCTGR-SaulRuizCarranza','0/6',98,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-19.46,2.18,NULL,40.78,3.26,5.71,148.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":98,\"serial_number\":\"FHTT9EBD6888\",\"onu_type\":\"HG8141V5\",\"name\":\"Sy5W3eWCTGR-SaulRuizCarranza\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-19.46,\"tx_power\":2.18,\"voltage\":3.26,\"bias_current\":5.71,\"temperature\":40.777,\"distance\":1481}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(286,1,'FHTTBA95F098','JessicaVenerosoMontes-JessicaVe','0/6',99,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-15.47,2.20,NULL,39.09,3.30,6.85,152.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":99,\"serial_number\":\"FHTTBA95F098\",\"onu_type\":\"HG8141V5\",\"name\":\"JessicaVenerosoMontes-JessicaVe\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-15.47,\"tx_power\":2.2,\"voltage\":3.3,\"bias_current\":6.85,\"temperature\":39.09,\"distance\":1521}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(287,1,'FHTT9A17EB78','RosaLindaGonzalezZuniga-RosaLin','0/6',100,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-19.00,2.31,NULL,41.61,3.30,7.94,131.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":100,\"serial_number\":\"FHTT9A17EB78\",\"onu_type\":\"HG8141V5\",\"name\":\"RosaLindaGonzalezZuniga-RosaLin\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-19,\"tx_power\":2.31,\"voltage\":3.3,\"bias_current\":7.94,\"temperature\":41.609,\"distance\":1317}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(288,1,'FHTT999DD930','JennyferTejedaGutierrez-Jennyfe','0/6',101,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-18.48,2.39,NULL,40.31,3.18,7.43,141.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":101,\"serial_number\":\"FHTT999DD930\",\"onu_type\":\"HG8141V5\",\"name\":\"JennyferTejedaGutierrez-Jennyfe\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.48,\"tx_power\":2.39,\"voltage\":3.18,\"bias_current\":7.43,\"temperature\":40.309,\"distance\":1416}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(289,1,'FHTTBA9A4CA0','GuadalupeGuerreroJacome-Guadalu','0/6',102,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":102,\"serial_number\":\"FHTTBA9A4CA0\",\"onu_type\":\"HG8141V5\",\"name\":\"GuadalupeGuerreroJacome-Guadalu\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(290,1,'FHTT9CD8C1F8','MonserratGradosHerrera-Monserra','0/6',103,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-24.20,1.96,NULL,42.48,3.34,8.99,157.30,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":103,\"serial_number\":\"FHTT9CD8C1F8\",\"onu_type\":\"HG8141V5\",\"name\":\"MonserratGradosHerrera-Monserra\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.2,\"tx_power\":1.96,\"voltage\":3.34,\"bias_current\":8.99,\"temperature\":42.477,\"distance\":1573}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(291,1,'FHTT9ED42CD8',NULL,'0/6',104,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":104,\"serial_number\":\"FHTT9ED42CD8\",\"onu_type\":\"HG8141V5\",\"name\":null,\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(292,1,'FHTT9BCFFDF0','WendySotoRivera-WendySotoRivera','0/6',105,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-16.62,2.32,NULL,41.80,3.30,8.50,145.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":105,\"serial_number\":\"FHTT9BCFFDF0\",\"onu_type\":\"HG8141V5\",\"name\":\"WendySotoRivera-WendySotoRivera\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-16.62,\"tx_power\":2.32,\"voltage\":3.3,\"bias_current\":8.5,\"temperature\":41.797,\"distance\":1456}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(293,1,'FHTT9EB0E6F0','SahyraMelissaAlva-SahyraMelissa','0/6',106,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-16.99,2.42,NULL,43.02,3.34,9.21,145.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":106,\"serial_number\":\"FHTT9EB0E6F0\",\"onu_type\":\"HG8141V5\",\"name\":\"SahyraMelissaAlva-SahyraMelissa\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-16.99,\"tx_power\":2.42,\"voltage\":3.34,\"bias_current\":9.21,\"temperature\":43.02,\"distance\":1457}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(294,1,'FHTT9D77EC70','KarenMartinezCelis-KarenMartine','0/6',107,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-15.06,2.14,NULL,43.29,3.34,9.45,152.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":107,\"serial_number\":\"FHTT9D77EC70\",\"onu_type\":\"HG8141V5\",\"name\":\"KarenMartinezCelis-KarenMartine\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-15.06,\"tx_power\":2.14,\"voltage\":3.34,\"bias_current\":9.45,\"temperature\":43.289,\"distance\":1520}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(295,1,'FHTT9EB4ACB8','MauroTorresCarrera-MauroTorresC','0/6',108,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-13.83,2.16,NULL,40.78,3.30,6.71,132.00,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":108,\"serial_number\":\"FHTT9EB4ACB8\",\"onu_type\":\"HG8141V5\",\"name\":\"MauroTorresCarrera-MauroTorresC\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-13.83,\"tx_power\":2.16,\"voltage\":3.3,\"bias_current\":6.71,\"temperature\":40.777,\"distance\":1320}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(296,1,'FHTT9EC0E020','MayraLuzTelloGar-MayraLuzTelloG','0/6',109,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":109,\"serial_number\":\"FHTT9EC0E020\",\"onu_type\":\"HG8141V5\",\"name\":\"MayraLuzTelloGar-MayraLuzTelloG\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(297,1,'FHTT9E9FFD60','AngelicaVelazquezGuzman-Angelic','0/6',110,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-23.37,2.15,NULL,42.20,3.32,9.89,157.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":110,\"serial_number\":\"FHTT9E9FFD60\",\"onu_type\":\"HG8141V5\",\"name\":\"AngelicaVelazquezGuzman-Angelic\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.37,\"tx_power\":2.15,\"voltage\":3.32,\"bias_current\":9.89,\"temperature\":42.199,\"distance\":1576}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(298,1,'FHTTBA9D56A8','MiriamAlejandraMartinezL-Miriam','0/6',112,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":112,\"serial_number\":\"FHTTBA9D56A8\",\"onu_type\":\"HG8141V5\",\"name\":\"MiriamAlejandraMartinezL-Miriam\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(299,1,'FHTT9E1D4FD0','MariaDLPilarCuellar-MariaDLPila','0/6',113,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-16.60,1.87,NULL,41.93,3.38,9.72,145.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":113,\"serial_number\":\"FHTT9E1D4FD0\",\"onu_type\":\"HG8141V5\",\"name\":\"MariaDLPilarCuellar-MariaDLPila\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-16.6,\"tx_power\":1.87,\"voltage\":3.38,\"bias_current\":9.72,\"temperature\":41.93,\"distance\":1457}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(300,1,'FHTT99A173B0','Emmanuel_De_Luna_Vergara-Emmanu','0/6',114,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-18.95,2.54,NULL,40.12,3.18,6.43,151.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":114,\"serial_number\":\"FHTT99A173B0\",\"onu_type\":\"HG8141V5\",\"name\":\"Emmanuel_De_Luna_Vergara-Emmanu\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.95,\"tx_power\":2.54,\"voltage\":3.18,\"bias_current\":6.43,\"temperature\":40.117,\"distance\":1516}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(301,1,'FHTT9CC871B8','EverardoMalagaMartinez-Everardo','0/6',116,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-18.76,2.00,NULL,42.48,3.34,8.96,149.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":116,\"serial_number\":\"FHTT9CC871B8\",\"onu_type\":\"HG8141V5\",\"name\":\"EverardoMalagaMartinez-Everardo\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.76,\"tx_power\":2,\"voltage\":3.34,\"bias_current\":8.96,\"temperature\":42.477,\"distance\":1496}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(302,1,'FHTT9E291108','EliudGarciaLopez-EliudGarciaLop','0/6',117,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-22.29,2.08,NULL,42.88,3.38,9.47,135.30,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":117,\"serial_number\":\"FHTT9E291108\",\"onu_type\":\"HG8141V5\",\"name\":\"EliudGarciaLopez-EliudGarciaLop\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-22.29,\"tx_power\":2.08,\"voltage\":3.38,\"bias_current\":9.47,\"temperature\":42.879,\"distance\":1353}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(303,1,'FHTT9E2AF448','KarlaKarinaNavarroLuna-KarlaKar','0/6',118,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-14.75,2.04,NULL,42.07,3.36,9.66,156.10,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":118,\"serial_number\":\"FHTT9E2AF448\",\"onu_type\":\"HG8141V5\",\"name\":\"KarlaKarinaNavarroLuna-KarlaKar\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-14.75,\"tx_power\":2.04,\"voltage\":3.36,\"bias_current\":9.66,\"temperature\":42.066,\"distance\":1561}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(304,1,'FHTT9CE6D570','DeliaMontenegroCobos-DeliaMonte','0/6',119,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-15.75,2.03,NULL,42.88,3.34,9.45,149.40,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":119,\"serial_number\":\"FHTT9CE6D570\",\"onu_type\":\"HG8141V5\",\"name\":\"DeliaMontenegroCobos-DeliaMonte\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-15.75,\"tx_power\":2.03,\"voltage\":3.34,\"bias_current\":9.45,\"temperature\":42.879,\"distance\":1494}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(305,1,'FHTT9E2CD130','AlexisMartinezPuga-AlexisMartin','0/6',120,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-23.10,2.27,NULL,42.34,3.38,9.87,161.30,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":120,\"serial_number\":\"FHTT9E2CD130\",\"onu_type\":\"HG8141V5\",\"name\":\"AlexisMartinezPuga-AlexisMartin\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.1,\"tx_power\":2.27,\"voltage\":3.38,\"bias_current\":9.87,\"temperature\":42.34,\"distance\":1613}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(306,1,'FHTT9CC11510','Esbeydi_Jaqueline_Delgado_Moral','0/6',121,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-17.26,2.02,NULL,43.02,3.34,8.68,149.70,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":121,\"serial_number\":\"FHTT9CC11510\",\"onu_type\":\"HG8141V5\",\"name\":\"Esbeydi_Jaqueline_Delgado_Moral\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-17.26,\"tx_power\":2.02,\"voltage\":3.34,\"bias_current\":8.68,\"temperature\":43.02,\"distance\":1497}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(307,1,'FHTT9CC83DE8','RodrigoPantojaMoli-RodrigoPanto','0/6',122,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-24.09,2.07,NULL,42.61,3.34,9.17,136.60,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":122,\"serial_number\":\"FHTT9CC83DE8\",\"onu_type\":\"HG8141V5\",\"name\":\"RodrigoPantojaMoli-RodrigoPanto\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.09,\"tx_power\":2.07,\"voltage\":3.34,\"bias_current\":9.17,\"temperature\":42.609,\"distance\":1366}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(308,1,'FHTT9CD656F8','DulceElizabethLeon-DulceElizabe','0/6',123,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-23.67,2.30,NULL,43.56,3.30,9.62,164.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":123,\"serial_number\":\"FHTT9CD656F8\",\"onu_type\":\"HG8141V5\",\"name\":\"DulceElizabethLeon-DulceElizabe\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-23.67,\"tx_power\":2.3,\"voltage\":3.3,\"bias_current\":9.62,\"temperature\":43.559,\"distance\":1645}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(309,1,'FHTT9E28E890','AlejandraJazminArg-AlejandraJaz','0/6',124,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-20.04,2.19,NULL,42.61,3.34,12.39,146.00,NULL,'HG8141V5',NULL,'ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":124,\"serial_number\":\"FHTT9E28E890\",\"onu_type\":\"HG8141V5\",\"name\":\"AlejandraJazminArg-AlejandraJaz\",\"vlan\":null,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":null,\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-20.04,\"tx_power\":2.19,\"voltage\":3.34,\"bias_current\":12.39,\"temperature\":42.609,\"distance\":1460}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(310,1,'FHTTC0FC27A0','LuciaLugoDelAng-LuciaLugoDelAng','0/6',128,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-20.66,1.97,NULL,40.03,3.26,9.38,145.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/6\",\"onu_id\":128,\"serial_number\":\"FHTTC0FC27A0\",\"onu_type\":\"HG8141V5\",\"name\":\"LuciaLugoDelAng-LuciaLugoDelAng\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-20.66,\"tx_power\":1.97,\"voltage\":3.26,\"bias_current\":9.38,\"temperature\":40.027,\"distance\":1455}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(311,1,'FHTT9D741BE0','MiguelAngelMoralesHernandez-Mig','0/8',1,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-18.15,2.19,NULL,43.42,3.38,9.55,84.90,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/8\",\"onu_id\":1,\"serial_number\":\"FHTT9D741BE0\",\"onu_type\":\"HG8141V5\",\"name\":\"MiguelAngelMoralesHernandez-Mig\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.15,\"tx_power\":2.19,\"voltage\":3.38,\"bias_current\":9.55,\"temperature\":43.418,\"distance\":849}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(312,1,'FHTT9CF34EF8','HaydeeMartinezGomez-HaydeeMarti','0/8',2,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-20.92,2.08,NULL,42.48,3.32,11.76,77.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/8\",\"onu_id\":2,\"serial_number\":\"FHTT9CF34EF8\",\"onu_type\":\"HG8141V5\",\"name\":\"HaydeeMartinezGomez-HaydeeMarti\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-20.92,\"tx_power\":2.08,\"voltage\":3.32,\"bias_current\":11.76,\"temperature\":42.477,\"distance\":775}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(313,1,'FHTT9C6C87A0','BlancaFlorGallardoLopez-BlancaF','0/8',3,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-24.69,2.41,NULL,43.97,3.32,10.08,81.50,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/8\",\"onu_id\":3,\"serial_number\":\"FHTT9C6C87A0\",\"onu_type\":\"HG8141V5\",\"name\":\"BlancaFlorGallardoLopez-BlancaF\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-24.69,\"tx_power\":2.41,\"voltage\":3.32,\"bias_current\":10.08,\"temperature\":43.969,\"distance\":815}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(314,1,'FHTT9CEFC878','AngelManuelPeredo-AngelManuelPe','0/8',4,'HG8141V5','offline',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/8\",\"onu_id\":4,\"serial_number\":\"FHTT9CEFC878\",\"onu_type\":\"HG8141V5\",\"name\":\"AngelManuelPeredo-AngelManuelPe\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"offline\",\"rx_power\":null,\"tx_power\":null,\"voltage\":null,\"bias_current\":null,\"temperature\":null,\"distance\":null}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(315,1,'FHTT9EB454B0',NULL,'0/8',5,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-18.66,2.13,NULL,40.78,3.26,8.00,81.30,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/8\",\"onu_id\":5,\"serial_number\":\"FHTT9EB454B0\",\"onu_type\":\"HG8141V5\",\"name\":null,\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.66,\"tx_power\":2.13,\"voltage\":3.26,\"bias_current\":8,\"temperature\":40.777,\"distance\":813}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(316,1,'HWTCA8D204AE','HectorGenaroPadilla-HectorGenar','0/8',6,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-18.57,2.33,NULL,49.00,3.34,11.00,76.20,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/8\",\"onu_id\":6,\"serial_number\":\"HWTCA8D204AE\",\"onu_type\":\"HG8141V5\",\"name\":\"HectorGenaroPadilla-HectorGenar\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-18.57,\"tx_power\":2.33,\"voltage\":3.34,\"bias_current\":11,\"temperature\":49,\"distance\":762}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57'),
(317,1,'FHTTC12FB88F','MaribelFloresHern-MaribelFlores','0/8',7,'HG8141V5','online',NULL,'2026-01-29 19:00:57',NULL,-21.37,2.18,NULL,40.03,3.30,11.22,87.80,881,'HG8141V5','INTERNET','ADMINOLT_TCONT_1G_GPON',NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,NULL,'{\"port\":\"0\\/8\",\"onu_id\":7,\"serial_number\":\"FHTTC12FB88F\",\"onu_type\":\"HG8141V5\",\"name\":\"MaribelFloresHern-MaribelFlores\",\"vlan\":881,\"line_profile\":\"HG8141V5\",\"dba_profile\":\"ADMINOLT_TCONT_1G_GPON\",\"service_profile\":\"INTERNET\",\"traffic_limit_downstream\":\"ADMINOLT-100-MEGAS-DOWN\",\"status\":\"online\",\"rx_power\":-21.37,\"tx_power\":2.18,\"voltage\":3.3,\"bias_current\":11.22,\"temperature\":40.027,\"distance\":878}','2026-01-29 19:00:57',NULL,'2026-01-29 15:39:10','2026-01-29 19:00:57');
/*!40000 ALTER TABLE `onus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plans`
--

DROP TABLE IF EXISTS `plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `plans` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `wisphub_id` bigint(20) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `download_speed_kbps` int(11) NOT NULL,
  `upload_speed_kbps` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plans_wisphub_id_unique` (`wisphub_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plans`
--

LOCK TABLES `plans` WRITE;
/*!40000 ALTER TABLE `plans` DISABLE KEYS */;
INSERT INTO `plans` VALUES
(29,301130,'FIBRA80Mb',0,0,420.00,'2026-01-19 05:48:04','2026-01-19 05:48:04'),
(30,277159,'FOPTE30',0,0,420.00,'2026-01-19 05:48:04','2026-01-19 05:48:04'),
(31,301129,'FIBRA50Mb',0,0,300.00,'2026-01-19 05:48:04','2026-01-19 05:48:04'),
(32,285876,'10M/10M',0,0,50.00,'2026-01-19 05:48:04','2026-01-19 05:48:04'),
(33,285875,'20M/20M',0,0,100.00,'2026-01-19 05:48:05','2026-01-19 05:48:05'),
(34,240287,'10MB',0,0,300.00,'2026-01-19 05:48:05','2026-01-19 05:48:05'),
(35,144906,'ECO 10Mb',0,0,250.00,'2026-01-19 05:48:05','2026-01-19 05:48:05'),
(36,240286,'20MB',0,0,420.00,'2026-01-19 05:48:05','2026-01-19 05:48:05'),
(37,240283,'ECO 20Mb',0,0,350.00,'2026-01-19 05:48:05','2026-01-19 05:48:05'),
(38,292152,'PCFIBRA15',0,0,250.00,'2026-01-19 05:48:05','2026-01-19 05:48:05'),
(39,295111,'FPTES2-15-15Mb',0,0,300.00,'2026-01-19 05:48:05','2026-01-19 05:48:05'),
(40,294823,'FPTES2-30-15Mb',0,0,300.00,'2026-01-19 05:48:05','2026-01-19 05:48:05'),
(41,286911,'BOCAFIBRA15M',0,0,300.00,'2026-01-19 05:48:05','2026-01-19 05:48:05'),
(42,287034,'BOCAFIBRA30M',0,0,420.00,'2026-01-19 05:48:05','2026-01-19 05:48:05'),
(43,289386,'FibraPuente 30M+tv',0,0,500.00,'2026-01-19 05:48:05','2026-01-19 05:48:05'),
(44,289387,'FibraPuente15Mb',0,0,300.00,'2026-01-19 05:48:05','2026-01-19 05:48:05'),
(45,289388,'FibraPuente30Mb',0,0,420.00,'2026-01-19 05:48:06','2026-01-19 05:48:06'),
(46,294824,'FPTES2-30-30Mb',0,0,420.00,'2026-01-19 05:48:06','2026-01-19 05:48:06'),
(47,277158,'FOPTE15',0,0,300.00,'2026-01-19 05:48:08','2026-01-19 05:48:08'),
(48,290542,'DRDFiber30',0,0,420.00,'2026-01-19 05:48:08','2026-01-19 05:48:08'),
(49,292153,'PCFIBRA30',0,0,350.00,'2026-01-19 05:48:08','2026-01-19 05:48:08'),
(50,247093,'VERS10',0,0,500.00,'2026-01-19 05:48:09','2026-01-19 05:48:09'),
(51,243645,'40M/5M',0,0,0.00,'2026-01-19 05:48:09','2026-01-19 05:48:09');
/*!40000 ALTER TABLE `plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `router_api_events`
--

DROP TABLE IF EXISTS `router_api_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `router_api_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `router_id` bigint(20) unsigned NOT NULL,
  `event_name` varchar(255) NOT NULL,
  `event_type` enum('connect','disconnect','suspend','activate') NOT NULL,
  `http_method` varchar(255) NOT NULL DEFAULT 'POST',
  `endpoint_url` text NOT NULL,
  `headers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`headers`)),
  `payload_template` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `router_api_events_router_id_foreign` (`router_id`),
  CONSTRAINT `router_api_events_router_id_foreign` FOREIGN KEY (`router_id`) REFERENCES `routers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `router_api_events`
--

LOCK TABLES `router_api_events` WRITE;
/*!40000 ALTER TABLE `router_api_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `router_api_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `router_ip_ranges`
--

DROP TABLE IF EXISTS `router_ip_ranges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `router_ip_ranges` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `router_id` bigint(20) unsigned NOT NULL,
  `cidr` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `router_ip_ranges_router_id_foreign` (`router_id`),
  CONSTRAINT `router_ip_ranges_router_id_foreign` FOREIGN KEY (`router_id`) REFERENCES `routers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `router_ip_ranges`
--

LOCK TABLES `router_ip_ranges` WRITE;
/*!40000 ALTER TABLE `router_ip_ranges` DISABLE KEYS */;
/*!40000 ALTER TABLE `router_ip_ranges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `routers`
--

DROP TABLE IF EXISTS `routers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `routers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `wisphub_id` bigint(20) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `ip_address` varchar(255) NOT NULL,
  `failover_ip` varchar(255) DEFAULT NULL,
  `api_user` varchar(255) DEFAULT NULL,
  `api_password` varchar(255) DEFAULT NULL,
  `api_port` int(11) NOT NULL DEFAULT 8728,
  `www_port` int(11) NOT NULL DEFAULT 80,
  `lan_interface` varchar(255) DEFAULT NULL,
  `router_os_version` enum('7_or_higher','6_or_lower') NOT NULL DEFAULT '7_or_higher',
  `external_id` varchar(255) DEFAULT NULL,
  `comments` text DEFAULT NULL,
  `on_connect_script` text DEFAULT NULL,
  `on_disconnect_script` text DEFAULT NULL,
  `coordinates` varchar(255) DEFAULT NULL,
  `service_cut_type` enum('ppp_secret','address_list_moroso','simple_queue','hotspot_user') NOT NULL DEFAULT 'ppp_secret',
  `type` enum('mikrotik','olt_vsol','olt_huawei') NOT NULL DEFAULT 'mikrotik',
  `is_online` tinyint(1) NOT NULL DEFAULT 0,
  `routeros_version` varchar(255) DEFAULT NULL,
  `cpu_load` int(11) DEFAULT NULL COMMENT 'Porcentaje de uso de CPU',
  `memory_used_bytes` bigint(20) DEFAULT NULL,
  `memory_total_bytes` bigint(20) DEFAULT NULL,
  `uptime` varchar(255) DEFAULT NULL,
  `last_checked_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `enable_api` tinyint(1) NOT NULL DEFAULT 1,
  `auto_add_client` tinyint(1) NOT NULL DEFAULT 0,
  `system_ip_pool` tinyint(1) NOT NULL DEFAULT 0,
  `traffic_history` tinyint(1) NOT NULL DEFAULT 0,
  `general_failover` tinyint(1) NOT NULL DEFAULT 0,
  `ipv6_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `control_simple_queue` tinyint(1) NOT NULL DEFAULT 0,
  `control_pcq_address_list` tinyint(1) NOT NULL DEFAULT 0,
  `control_hotspot` tinyint(1) NOT NULL DEFAULT 0,
  `control_pppoe` tinyint(1) NOT NULL DEFAULT 0,
  `ip_bindings` tinyint(1) NOT NULL DEFAULT 0,
  `ip_mac_binding` tinyint(1) NOT NULL DEFAULT 0,
  `dhcp_leases` tinyint(1) NOT NULL DEFAULT 0,
  `ppp_speed_control_mode` enum('profile_ppp_dynamic_queue','simple_queue_ppp') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `routers_wisphub_id_unique` (`wisphub_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routers`
--

LOCK TABLES `routers` WRITE;
/*!40000 ALTER TABLE `routers` DISABLE KEYS */;
INSERT INTO `routers` VALUES
(1,62925,'CCR_PTE30','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:11','2026-01-28 23:47:11',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(2,49027,'PUENTE 30','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:11','2026-01-28 23:47:11',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(3,58506,'BOCAFIBRA 25','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:11','2026-01-28 23:47:11',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(4,60786,'FPTES2-15','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:11','2026-01-28 23:47:11',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(5,55712,'FPUENTE15','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:11','2026-01-28 23:47:11',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(6,62923,'CCR_PTE15','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:11','2026-01-28 23:47:11',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(7,60707,'FPTES2-30','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:11','2026-01-28 23:47:11',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(8,58798,'BOCAFIBRA 10','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:11','2026-01-28 23:47:11',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(9,55713,'FPUENTE30','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:11','2026-01-28 23:47:11',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(10,49028,'PUENTE 15','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:11','2026-01-28 23:47:11',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(11,58231,'PASO RINCON 15','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:11','2026-01-28 23:47:11',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(12,60960,'BULGARIA30','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:12','2026-01-28 23:47:12',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(13,62213,'MORRO_TAMP 30','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:12','2026-01-28 23:47:12',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(14,47892,'BOCA30','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:12','2026-01-28 23:47:12',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(15,59964,'PCFIBRA30','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:12','2026-01-28 23:47:12',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(16,59211,'PUENTEFIBRA25','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:12','2026-01-28 23:47:12',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(17,47949,'BOCA15','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:13','2026-01-28 23:47:13',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(18,59963,'PCFIBRA15','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:16','2026-01-28 23:47:16',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(19,59581,'DORADOFIBER25','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:16','2026-01-28 23:47:16',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(20,47303,'PC30','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:16','2026-01-28 23:47:16',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(21,47304,'PC15','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:16','2026-01-28 23:47:16',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(22,47311,'DRD 30','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:16','2026-01-28 23:47:16',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(23,47310,'DRD 15','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:17','2026-01-28 23:47:17',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL),
(24,45821,'RB VEGAS 30','0.0.0.0',NULL,NULL,NULL,8728,80,NULL,'7_or_higher',NULL,NULL,NULL,NULL,NULL,'ppp_secret','mikrotik',0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-28 23:47:17','2026-01-28 23:47:17',1,0,0,0,0,0,0,0,0,0,0,0,0,NULL);
/*!40000 ALTER TABLE `routers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) unsigned NOT NULL,
  `wisphub_servicio_id` bigint(20) unsigned DEFAULT NULL,
  `router_id` bigint(20) unsigned NOT NULL,
  `plan_id` bigint(20) unsigned NOT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `mac_address` varchar(255) DEFAULT NULL,
  `pppoe_user` varchar(255) DEFAULT NULL,
  `pppoe_password` varchar(255) DEFAULT NULL,
  `status` enum('active','suspended','cancelled') NOT NULL DEFAULT 'active',
  `balance` decimal(10,2) NOT NULL DEFAULT 0.00,
  `cut_off_date` varchar(255) DEFAULT NULL,
  `last_payment_date` varchar(255) DEFAULT NULL,
  `billing_day` int(11) DEFAULT NULL,
  `billing_notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `services_wisphub_servicio_id_unique` (`wisphub_servicio_id`),
  KEY `services_router_id_foreign` (`router_id`),
  KEY `services_plan_id_foreign` (`plan_id`),
  KEY `services_customer_id_foreign` (`customer_id`),
  CONSTRAINT `services_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `services_plan_id_foreign` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `services_router_id_foreign` FOREIGN KEY (`router_id`) REFERENCES `routers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES
(612,1,957,4,29,'100.20.5.36',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(613,2,956,5,30,'10.21.5.149',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(614,3,955,1,31,'10.60.11.25',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(615,4,954,4,31,'100.20.5.58',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(616,5,953,6,29,'10.60.11.26',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(617,6,952,6,29,'10.60.11.18',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(618,7,951,7,31,'100.20.5.41',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(619,8,950,1,31,'10.10.21.52',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(620,9,949,1,31,'10.10.21.229',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(621,10,948,1,31,'10.60.11.14',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(622,11,947,1,31,'10.60.11.7',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(623,12,946,1,31,'10.10.21.254',NULL,NULL,NULL,'active',400.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(624,13,945,3,31,'10.60.10.9',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(625,14,944,1,29,'10.10.21.248',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(626,15,943,1,31,'10.10.21.246',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(627,16,942,6,31,'10.10.21.249',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(628,17,941,6,31,'10.10.21.89',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(629,18,940,6,31,'10.10.21.250',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(630,19,939,5,30,'10.21.5.125',NULL,NULL,NULL,'suspended',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(631,20,938,6,31,'10.10.21.247',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(632,21,937,6,31,'10.10.21.243',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(633,22,936,8,29,'10.60.10.50',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(634,23,935,6,31,'10.10.21.244',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(635,24,934,6,29,'10.10.21.241',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(636,25,933,6,31,'10.10.21.239',NULL,NULL,NULL,'suspended',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(637,26,932,8,31,'10.60.10.32',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(638,27,931,4,31,'100.20.5.22',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(639,28,929,6,31,'10.10.21.236',NULL,NULL,NULL,'suspended',400.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(640,29,928,6,31,'10.10.21.240',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(641,30,927,6,29,'10.10.21.58',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(642,31,926,6,29,'10.10.21.238',NULL,NULL,NULL,'suspended',420.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(643,32,925,6,31,'10.10.21.66',NULL,NULL,NULL,'suspended',300.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(644,33,924,6,31,'10.10.21.237',NULL,NULL,NULL,'suspended',400.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(645,34,923,6,29,'10.10.21.242',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(646,35,922,1,31,'10.10.21.62',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(647,36,921,1,31,'10.10.21.136',NULL,NULL,NULL,'suspended',400.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(648,37,920,1,31,'10.10.21.228',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(649,38,919,1,29,'10.10.21.122',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(650,39,917,6,31,'10.10.21.231',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(651,40,916,1,31,'10.10.21.128',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(652,41,915,1,29,'10.10.21.96',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(653,42,914,1,31,'10.10.21.157',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(654,43,913,9,30,'10.21.5.67',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(655,44,912,3,31,'10.60.10.19',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(656,45,911,1,31,'10.10.21.216',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(657,46,910,1,31,'10.10.21.183',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(658,47,909,6,31,'10.10.21.225',NULL,NULL,NULL,'suspended',300.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(659,48,908,1,31,'10.10.21.218',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(660,49,907,1,31,'10.10.21.230',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(661,50,906,2,32,'10.20.5.38',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(662,51,905,2,32,'10.20.5.39',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(663,52,904,2,32,'10.20.5.35',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(664,53,903,2,32,'10.20.5.26',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(665,54,902,2,32,'10.20.5.22',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(666,55,901,1,31,'10.10.21.99',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(667,56,900,2,32,'10.20.5.21',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(668,57,899,2,32,'10.20.5.19',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(669,58,898,2,32,'10.20.5.14',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(670,59,897,2,32,'10.20.5.12',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(671,60,896,2,32,'10.20.5.18',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(672,61,895,1,31,'10.10.21.211',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(673,62,894,1,31,'10.10.21.222',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(674,63,893,2,32,'10.20.4.216',NULL,NULL,NULL,'active',50.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(676,65,891,1,29,'10.10.21.69',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(677,66,890,1,31,'10.10.21.70',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(678,67,889,1,31,'10.10.21.210',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(679,68,888,1,31,'10.10.21.204',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(680,69,887,6,31,'10.10.21.219',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(681,70,886,6,31,'10.10.21.209',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:17','2026-01-28 23:50:10'),
(682,71,885,6,31,'10.10.21.217',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(683,72,884,6,31,'10.10.21.203',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(684,73,882,6,29,'10.10.21.212',NULL,NULL,NULL,'suspended',420.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(685,74,881,6,29,'10.10.21.233',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(686,75,880,6,31,'10.10.21.224',NULL,NULL,NULL,'suspended',300.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(687,76,879,6,31,'10.10.21.221',NULL,NULL,NULL,'suspended',300.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(688,77,878,10,34,'10.20.4.37',NULL,NULL,NULL,'suspended',300.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(689,78,877,6,31,'10.10.21.232',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(690,79,876,1,29,'10.10.21.251',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(691,80,875,6,31,'10.10.21.220',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(692,81,874,6,31,'10.10.21.215',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(693,82,873,6,31,'10.10.21.61',NULL,NULL,NULL,'suspended',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(694,83,872,6,31,'10.10.21.226',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(695,84,871,6,29,'10.10.21.202',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(696,85,870,6,31,'10.10.21.213',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(697,86,869,6,31,'10.10.21.200',NULL,NULL,NULL,'suspended',300.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(698,87,868,6,29,'10.10.21.208',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(699,88,867,6,31,'10.10.21.191',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(700,89,866,6,31,'10.10.21.201',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(701,90,865,6,31,'10.10.21.207',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(702,91,864,10,32,'10.20.4.21',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(703,92,863,11,35,'10.21.5.93',NULL,NULL,NULL,'active',250.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(704,93,862,1,31,'10.10.21.205',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(705,94,861,1,31,'10.10.21.214',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(706,95,860,1,29,'10.10.21.196',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(707,96,859,3,31,'10.60.10.221',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(708,97,858,1,31,'10.10.21.206',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(709,98,857,3,31,'10.60.10.15',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(710,99,856,1,31,'10.10.21.181',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(711,100,855,7,29,'100.20.5.16',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(712,101,854,1,29,'10.10.21.179',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(713,102,853,1,31,'10.60.12.69',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(714,103,852,1,31,'10.60.12.216',NULL,NULL,NULL,'suspended',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(715,104,851,1,29,'10.60.12.246',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(716,105,850,7,31,'100.20.5.121',NULL,NULL,NULL,'suspended',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(717,106,849,1,31,'10.60.13.244',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(718,107,848,1,29,'10.60.13.152',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(719,108,847,1,31,'10.60.13.245',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(720,109,846,7,31,'100.20.5.99',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(721,110,845,1,29,'10.60.12.210',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(722,111,844,1,31,'10.60.13.217',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(723,112,843,7,31,'100.20.5.56',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(724,113,842,7,31,'100.20.5.172',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(725,114,841,1,29,'10.60.12.215',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(726,115,840,6,31,'10.10.21.199',NULL,NULL,NULL,'suspended',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(727,116,839,10,33,'10.20.4.36',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(728,117,838,6,31,'10.10.21.192',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(729,118,837,6,31,'10.10.21.164',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(730,119,836,10,36,'10.20.4.39',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(731,120,835,12,31,'100.22.10.123',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(732,121,834,6,31,'10.10.21.174',NULL,NULL,NULL,'suspended',300.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(733,122,833,6,31,'10.10.21.177',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(734,123,832,6,29,'10.10.21.173',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(735,124,831,4,31,'100.20.5.70',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(736,125,830,10,32,'10.20.4.31',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(737,126,829,6,31,'10.10.21.135',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(738,127,828,6,31,'10.10.21.141',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(739,128,827,6,29,'10.10.21.170',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(740,129,826,5,30,'10.21.5.60',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(741,130,825,6,31,'10.10.21.10',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(742,131,824,6,31,'10.10.21.87',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(743,132,823,6,31,'10.10.21.86',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(744,133,822,5,30,'10.21.5.42',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(745,134,821,6,31,'10.10.21.83',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(746,135,820,4,31,'100.20.5.17',NULL,NULL,NULL,'suspended',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(747,136,819,6,31,'10.10.21.12',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(748,137,818,6,29,'10.10.21.11',NULL,NULL,NULL,'suspended',420.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(749,138,817,12,31,'100.22.11.245',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(750,139,816,1,31,'10.10.21.131',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(751,140,815,3,31,'10.60.10.61',NULL,NULL,NULL,'active',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(752,141,814,3,31,'10.60.10.108',NULL,NULL,NULL,'active',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(753,142,813,3,31,'10.60.10.242',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(754,143,812,7,31,'100.20.5.125',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(755,144,811,1,31,'10.10.21.91',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(756,145,810,2,36,'10.20.7.58',NULL,NULL,NULL,'suspended',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(757,146,809,6,31,'10.10.21.13',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(758,147,808,7,31,'100.20.5.18',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(759,148,807,1,31,'10.10.21.34',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(760,149,806,13,29,'10.22.1.22',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(761,150,805,1,31,'10.10.21.40',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(762,151,804,1,31,'10.10.21.48',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(763,152,803,1,29,'10.10.21.78',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(764,153,802,7,29,'100.20.5.82',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(765,154,801,1,31,'10.10.21.107',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(766,155,800,14,37,'10.10.6.57',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(767,156,799,1,31,'10.10.21.95',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(768,157,798,1,31,'10.10.21.124',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(769,158,797,1,31,'10.10.21.116',NULL,NULL,NULL,'suspended',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(770,159,796,1,29,'10.10.21.14',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(771,160,795,1,29,'10.10.21.118',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(772,161,794,1,31,'10.10.21.142',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(773,162,793,1,31,'10.10.21.15',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(774,163,792,6,31,'10.10.21.16',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(775,164,791,1,31,'10.10.21.102',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(776,165,790,6,31,'10.10.21.17',NULL,NULL,NULL,'suspended',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(777,166,789,15,38,'10.60.50.94',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(778,167,788,6,31,'10.10.21.18',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(780,169,786,6,29,'10.10.21.21',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(781,170,785,6,29,'10.10.21.22',NULL,NULL,NULL,'suspended',420.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(782,171,784,6,31,'10.60.10.245',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(783,172,783,6,29,'10.60.12.166',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(785,174,781,6,31,'10.10.21.23',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(786,175,780,6,29,'10.10.21.24',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(787,176,779,6,31,'10.10.21.25',NULL,NULL,NULL,'suspended',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(788,177,778,6,29,'10.10.21.27',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(789,178,777,10,36,'10.20.5.222',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(790,179,776,6,31,'10.10.21.28',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(791,180,775,10,34,'10.20.5.195',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(792,181,774,4,39,'100.20.5.169',NULL,NULL,NULL,'suspended',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(793,182,773,6,29,'10.10.21.139',NULL,NULL,NULL,'suspended',420.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(794,183,772,9,32,'10.21.5.156',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(795,184,771,1,31,'10.10.21.103',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(796,185,770,1,31,'10.10.21.140',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:18','2026-01-28 23:50:10'),
(797,186,769,6,31,'10.10.21.29',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(798,187,768,1,29,'10.10.21.143',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(799,188,766,1,31,'10.10.21.144',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(800,189,765,1,31,'10.10.21.127',NULL,NULL,NULL,'suspended',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(801,190,764,1,31,'10.10.21.94',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(802,191,763,2,34,'10.20.5.214',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(803,192,762,7,40,'100.20.5.183',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(804,193,761,2,34,'10.20.4.231',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(805,194,760,1,31,'10.10.21.108',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(806,195,758,7,39,'100.20.5.51',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(807,196,757,1,31,'10.10.21.145',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(808,197,756,1,29,'10.10.21.59',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(809,198,755,1,31,'10.10.21.117',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(810,199,754,1,31,'10.10.21.132',NULL,NULL,NULL,'active',400.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(811,200,753,1,31,'10.10.21.98',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(812,201,752,3,41,'10.60.10.85',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(813,202,751,3,42,'10.60.10.167',NULL,NULL,NULL,'active',420.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(814,203,750,1,31,'10.10.21.146',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(815,204,749,7,39,'100.20.5.119',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(816,205,748,1,31,'10.10.21.101',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(817,206,747,16,43,'10.10.21.176',NULL,NULL,NULL,'suspended',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(818,207,746,1,31,'10.10.21.147',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(819,208,745,1,31,'10.10.21.9',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(820,209,744,1,31,'10.10.21.148',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(821,210,743,1,31,'10.10.21.110',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(822,211,742,1,31,'10.10.21.149',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(823,212,740,1,31,'10.10.21.150',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(824,213,739,1,31,'10.10.21.152',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(825,214,738,1,31,'10.10.21.119',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(826,215,737,13,29,'10.22.2.187',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(827,216,736,16,44,'10.60.11.214',NULL,NULL,NULL,'suspended',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(828,217,735,1,31,'10.10.21.166',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(829,218,734,1,31,'10.10.21.129',NULL,NULL,NULL,'suspended',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(830,219,733,16,44,'10.60.11.109',NULL,NULL,NULL,'suspended',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(831,220,732,1,31,'10.10.21.153',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(832,221,731,16,44,'10.60.11.138',NULL,NULL,NULL,'suspended',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(833,222,730,1,29,'10.10.21.155',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(834,223,729,16,44,'10.10.21.227',NULL,NULL,NULL,'suspended',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(835,224,728,1,31,'10.10.21.84',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(837,226,726,6,29,'10.10.21.31',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(838,227,725,6,29,'10.10.21.32',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(840,229,723,6,31,'10.10.21.36',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(842,231,721,6,31,'10.10.21.39',NULL,NULL,NULL,'suspended',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(843,232,720,6,29,'10.10.21.41',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(844,233,719,6,29,'10.10.21.42',NULL,NULL,NULL,'suspended',420.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(845,234,717,6,31,'10.10.21.43',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(846,235,716,6,29,'10.10.21.44',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(847,236,715,6,31,'10.10.21.45',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(848,237,714,6,29,'10.10.21.47',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(849,238,713,6,31,'10.10.21.158',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(850,239,712,6,31,'10.10.21.50',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(851,240,711,6,31,'10.10.21.51',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(852,241,710,1,29,'10.10.21.100',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(853,242,709,4,39,'100.20.5.31',NULL,NULL,NULL,'suspended',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(855,244,707,13,31,'10.22.1.15',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(856,245,706,11,32,'10.21.5.104',NULL,NULL,NULL,'active',50.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(857,246,705,11,32,'10.21.5.105',NULL,NULL,NULL,'active',50.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(858,247,704,2,34,'10.20.4.120',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(859,248,703,16,45,'10.10.21.46',NULL,NULL,NULL,'suspended',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(860,249,702,1,31,'10.10.21.82',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(861,250,701,7,46,'100.20.5.40',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(862,251,700,1,31,'10.10.21.71',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(863,252,699,1,31,'10.10.21.159',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(864,253,698,1,29,'10.10.21.154',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(865,254,696,1,31,'10.10.21.156',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(866,255,695,1,31,'10.10.21.85',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(867,256,694,1,31,'10.10.21.160',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(868,257,692,1,31,'10.10.21.151',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(869,258,691,13,29,'10.22.1.14',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(870,259,690,1,31,'10.10.21.134',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(871,260,689,1,31,'10.10.21.111',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(872,261,688,3,42,'10.60.10.135',NULL,NULL,NULL,'active',420.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(873,262,687,1,31,'10.10.21.105',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(874,263,686,1,31,'10.10.21.130',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(875,264,682,1,29,'10.10.21.161',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(876,265,681,6,29,'10.10.21.49',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(877,266,680,6,31,'10.10.21.163',NULL,NULL,NULL,'suspended',300.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(878,267,679,8,42,'10.60.10.96',NULL,NULL,NULL,'suspended',420.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(879,268,678,8,41,'10.60.10.43',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(880,269,676,1,29,'10.10.21.113',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(881,270,675,1,29,'10.10.21.93',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(882,271,674,1,31,'10.10.21.171',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(883,272,673,1,31,'10.10.21.162',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(884,273,672,1,29,'10.10.21.178',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(885,274,671,1,31,'10.10.21.194',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(886,275,670,1,31,'10.10.21.114',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(887,276,669,1,31,'10.10.21.184',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(888,277,668,1,31,'10.10.21.190',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(889,278,667,1,31,'10.10.21.189',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(890,279,666,1,31,'10.10.21.165',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(891,280,665,16,43,'10.10.21.115',NULL,NULL,NULL,'active',500.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(892,281,664,6,29,'10.10.21.53',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(893,282,663,8,41,'10.60.10.101',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(894,283,662,6,31,'10.10.21.54',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(895,284,661,6,29,'10.10.21.56',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(896,285,659,6,31,'10.10.21.138',NULL,NULL,NULL,'suspended',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(897,286,658,6,29,'10.10.21.133',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(898,287,657,6,31,'10.10.21.57',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(899,288,656,6,31,'10.10.21.60',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(900,289,654,6,29,'10.10.21.63',NULL,NULL,NULL,'suspended',420.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(901,290,652,1,31,'10.10.21.123',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(902,291,651,1,31,'10.10.21.198',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(903,292,650,3,41,'10.60.10.16',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(904,293,646,12,45,'100.22.10.120',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(905,294,645,17,37,'10.10.6.74',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(906,295,644,9,34,'10.21.5.56',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(907,296,643,7,46,'100.20.5.39',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(908,297,642,3,29,'10.60.10.20',NULL,NULL,NULL,'active',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(909,298,640,6,29,'10.10.21.64',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:19','2026-01-28 23:50:10'),
(910,299,635,6,29,'10.10.21.67',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:20','2026-01-28 23:50:10'),
(911,300,633,1,29,'10.10.21.106',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:20','2026-01-28 23:50:10'),
(912,301,632,3,42,'10.60.10.23',NULL,NULL,NULL,'active',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(913,302,630,8,42,'10.60.10.53',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(914,303,629,12,45,'100.22.10.48',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(915,304,627,2,33,'10.20.4.28',NULL,NULL,NULL,'active',100.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(916,305,625,12,45,'100.22.10.38',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(917,306,622,12,45,'100.22.10.33',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(918,307,620,12,45,'100.22.10.29',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(919,308,618,12,45,'100.22.10.25',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(920,309,617,8,41,'10.60.10.120',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(921,310,613,6,31,'10.10.21.33',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(922,311,610,6,31,'10.10.21.97',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(923,312,607,6,31,'10.10.21.68',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(924,313,604,1,31,'10.10.21.186',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(925,314,603,4,39,'100.20.5.11',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(926,315,602,15,40,'100.20.5.12',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(927,316,601,2,34,'10.20.4.100',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(928,317,600,1,29,'10.10.21.104',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(929,318,599,1,31,'10.10.21.185',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(930,319,598,1,29,'10.10.21.121',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(931,320,596,2,36,'10.20.4.34',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(932,321,594,1,31,'10.10.21.81',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(933,322,593,3,42,'10.60.10.22',NULL,NULL,NULL,'active',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(934,323,591,1,31,'10.10.21.109',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(935,324,590,1,29,'10.10.21.88',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(936,325,588,18,38,'10.60.50.18',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(937,326,587,1,31,'10.10.21.112',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(938,327,586,6,31,'10.10.21.80',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(939,328,583,6,31,'10.10.21.168',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(940,329,582,1,31,'10.10.21.182',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(941,330,581,1,31,'10.10.21.169',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(942,331,580,9,47,'10.21.5.61',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(943,332,576,9,47,'10.21.5.66',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(944,333,573,1,31,'10.10.21.120',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(945,334,567,6,31,'10.10.21.72',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(946,335,564,9,47,'10.21.5.100',NULL,NULL,NULL,'suspended',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(947,336,563,9,47,'10.21.5.88',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(948,337,560,19,48,'100.30.5.48',NULL,NULL,NULL,'active',0.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(949,338,559,1,31,'10.10.21.125',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(950,339,558,2,32,'10.20.4.54',NULL,NULL,NULL,'active',50.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(951,340,556,1,31,'10.10.21.197',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(952,341,554,12,45,'100.22.10.47',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(953,342,551,1,31,'10.10.21.172',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(954,343,548,1,31,'10.10.21.223',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(955,344,545,6,31,'10.10.21.73',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:22','2026-01-28 23:50:10'),
(956,345,544,6,31,'10.10.21.74',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(957,346,538,6,31,'10.10.21.75',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(958,347,535,6,29,'10.10.21.76',NULL,NULL,NULL,'suspended',420.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(959,348,533,11,32,'10.21.5.111',NULL,NULL,NULL,'active',50.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(960,349,528,6,31,'10.10.21.77',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(961,350,521,1,29,'10.10.21.126',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(962,351,519,2,33,'10.20.4.27',NULL,NULL,NULL,'active',100.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(963,352,515,9,47,'10.21.5.99',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(964,353,514,1,31,'10.10.21.137',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(965,354,512,6,31,'10.10.21.187',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(966,355,508,5,47,'10.21.5.74',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(967,356,507,5,47,'10.21.5.69',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(968,357,506,1,31,'10.10.21.92',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(969,358,503,1,29,'10.10.21.195',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(970,359,500,1,31,'10.10.21.193',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(971,360,494,1,31,'10.60.11.43',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(972,361,492,9,47,'10.21.5.55',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(973,362,491,9,47,'10.21.5.95',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(974,363,490,9,47,'10.21.5.86',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(975,364,489,3,41,'10.60.10.35',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(976,365,488,9,47,'10.21.5.65',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(977,366,484,9,47,'10.21.5.49',NULL,NULL,NULL,'active',450.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(978,367,483,9,30,'10.21.5.64',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(979,368,481,5,47,'10.21.5.23',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(980,369,480,5,47,'10.21.5.27',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(981,370,478,5,47,'10.21.5.52',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(982,371,477,9,47,'10.21.5.164',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(983,372,476,11,32,'10.21.5.128',NULL,NULL,NULL,'active',50.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(984,373,474,5,47,'10.21.5.114',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(985,374,473,3,41,'10.60.10.36',NULL,NULL,NULL,'active',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(986,375,471,3,41,'10.60.10.33',NULL,NULL,NULL,'active',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(987,376,470,3,41,'10.60.10.31',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(988,377,468,11,32,'10.21.5.139',NULL,NULL,NULL,'active',50.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(989,378,467,8,41,'10.60.10.26',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(990,379,466,8,42,'10.60.10.25',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(991,380,465,3,42,'60.50.30.210',NULL,NULL,NULL,'active',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(992,381,462,3,42,'60.50.30.16',NULL,NULL,NULL,'active',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(993,382,460,3,41,'60.50.30.14',NULL,NULL,NULL,'active',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(994,383,459,3,41,'10.10.21.1',NULL,NULL,NULL,'active',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(995,384,443,11,33,'10.21.5.244',NULL,NULL,NULL,'active',100.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(996,385,444,11,33,'10.21.5.239',NULL,NULL,NULL,'active',100.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(997,386,445,11,33,'10.21.5.236',NULL,NULL,NULL,'active',100.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(998,387,446,11,33,'10.21.5.234',NULL,NULL,NULL,'active',100.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(999,388,447,11,33,'10.21.5.230',NULL,NULL,NULL,'active',100.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1000,389,448,11,33,'10.21.5.243',NULL,NULL,NULL,'active',100.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1001,390,449,11,33,'10.21.5.217',NULL,NULL,NULL,'active',100.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1002,391,450,11,33,'10.21.5.211',NULL,NULL,NULL,'active',100.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1003,392,451,11,32,'10.21.5.205',NULL,NULL,NULL,'active',50.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1004,393,452,11,32,'10.21.5.191',NULL,NULL,NULL,'active',50.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1005,394,453,11,32,'10.21.0.183',NULL,NULL,NULL,'active',50.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1006,395,454,11,32,'10.21.0.181',NULL,NULL,NULL,'active',50.00,'8/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1007,396,441,18,38,'10.60.50.19',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1008,397,440,14,35,'10.10.4.117',NULL,NULL,NULL,'active',250.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1009,398,433,15,38,'10.60.50.20',NULL,NULL,NULL,'active',250.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1010,399,429,2,36,'10.20.4.49',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1011,400,428,20,37,'10.50.6.40',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1012,401,424,12,45,'100.22.10.17',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1013,402,420,5,30,'10.21.5.163',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1014,403,417,9,47,'10.21.5.222',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1015,404,413,18,38,'10.60.50.247',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1016,405,402,1,31,'10.60.11.39',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1017,406,398,21,49,'10.50.6.29',NULL,NULL,NULL,'suspended',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1018,407,396,14,37,'10.10.4.102',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1019,408,395,22,34,'10.30.5.164',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1020,409,393,10,36,'10.20.4.81',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1021,410,365,2,36,'10.20.4.29',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1022,411,360,1,31,'10.10.21.188',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1023,412,359,12,45,'100.22.10.71',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1024,413,346,1,31,'10.10.21.167',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1025,414,336,9,47,'10.21.5.96',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1026,415,327,2,34,'10.20.4.171',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1027,416,326,2,34,'10.20.4.22',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1028,417,324,9,47,'10.21.5.229',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1029,418,315,12,45,'100.22.10.53',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1030,419,313,17,37,'10.10.4.52',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1031,420,306,9,47,'10.21.5.98',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1032,421,305,9,47,'10.21.5.232',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1033,422,300,9,47,'10.21.5.242',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1034,423,299,9,30,'10.21.5.177',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1035,424,298,9,30,'10.21.5.167',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1036,425,297,7,39,'100.20.5.21',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1037,426,293,2,34,'10.20.12.80',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1038,427,283,2,34,'10.20.6.200',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1039,428,282,9,47,'10.21.5.53',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1040,429,280,12,45,'100.22.10.43',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1041,430,277,2,34,'10.20.12.146',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1042,431,272,2,36,'10.20.4.79',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1043,432,276,22,34,'10.30.6.104',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1044,433,256,5,47,'10.21.5.225',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1045,434,250,5,47,'10.21.5.139',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1046,435,248,10,34,'10.20.11.236',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1047,436,247,5,47,'10.21.5.47',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1048,437,243,10,34,'10.20.4.72',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1049,438,238,5,47,'10.21.5.90',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1050,439,234,10,34,'10.20.11.40',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:23','2026-01-28 23:50:10'),
(1052,441,228,10,34,'10.20.11.157',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1053,442,223,5,47,'10.21.5.105',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1054,443,220,10,36,'10.20.12.106',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1055,444,219,10,34,'10.20.4.221',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1056,445,217,10,34,'10.20.11.143',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1057,446,215,10,34,'10.20.11.53',NULL,NULL,NULL,'suspended',300.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1058,447,214,5,47,'10.21.5.228',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1059,448,211,6,31,'10.10.21.180',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1060,449,201,10,34,'10.20.11.149',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1061,450,197,10,34,'10.20.11.139',NULL,NULL,NULL,'active',0.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1062,451,196,2,34,'10.20.5.186',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1063,452,195,10,34,'10.20.4.71',NULL,NULL,NULL,'suspended',300.00,'17/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1064,453,183,2,34,'10.20.6.233',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1065,454,179,2,34,'10.20.4.90',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1066,455,177,2,34,'10.20.4.75',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1067,456,172,1,29,'10.10.21.175',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1068,457,167,5,30,'10.21.5.179',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1069,458,160,3,41,'60.50.30.21',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1070,459,50,14,35,'10.10.8.142',NULL,NULL,NULL,'active',250.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1071,460,51,17,50,'10.10.8.219',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1072,461,54,17,34,'10.10.11.214',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1073,462,57,3,41,'10.60.10.28',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1074,463,59,3,41,'10.60.10.13',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1075,464,63,14,35,'10.10.11.185',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1076,465,64,14,35,'10.10.6.168',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1077,466,65,14,37,'10.10.6.23',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1078,467,67,8,41,'10.60.10.30',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1079,468,73,3,41,'10.60.10.29',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1080,469,76,17,35,'10.10.12.24',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1081,470,78,8,41,'10.60.10.27',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1082,471,81,17,35,'10.10.7.172',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1083,472,83,14,35,'10.10.12.23',NULL,NULL,NULL,'active',250.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1084,473,92,3,41,'10.60.10.38',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1085,474,94,14,37,'10.10.6.156',NULL,NULL,NULL,'suspended',350.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1086,475,98,17,35,'10.10.7.102',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1087,476,101,14,37,'10.10.4.50',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1088,477,116,17,35,'10.10.12.58',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1089,478,121,3,41,'10.60.10.166',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1090,479,122,6,31,'10.10.21.79',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1091,480,130,14,34,'10.10.12.72',NULL,NULL,NULL,'suspended',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1092,481,133,3,31,'10.60.10.34',NULL,NULL,NULL,'active',0.00,'2/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1093,482,138,14,37,'10.10.9.15',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1094,483,139,14,51,'10.10.8.111',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1095,484,142,14,35,'10.10.6.14',NULL,NULL,NULL,'active',250.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1096,485,145,8,41,'10.60.10.170',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1097,486,146,8,41,'10.60.10.37',NULL,NULL,NULL,'suspended',300.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1098,487,148,14,35,'10.10.6.220',NULL,NULL,NULL,'active',250.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1099,488,48,20,35,'10.50.7.152',NULL,NULL,NULL,'active',250.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1100,489,45,22,34,'10.30.5.207',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1101,490,46,23,34,'10.30.7.25',NULL,NULL,NULL,'suspended',300.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1102,491,28,15,38,'10.60.50.14',NULL,NULL,NULL,'active',250.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1103,492,33,15,38,'10.60.50.16',NULL,NULL,NULL,'active',250.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1104,493,17,21,37,'10.50.7.10',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1105,494,23,18,38,'10.60.50.12',NULL,NULL,NULL,'active',0.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1106,495,24,18,38,'10.50.5.20',NULL,NULL,NULL,'suspended',250.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1107,496,25,18,38,'10.60.50.15',NULL,NULL,NULL,'suspended',250.00,'16/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1108,497,16,20,35,'10.50.5.155',NULL,NULL,NULL,'suspended',250.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1109,498,12,24,37,'10.40.8.197',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-19 22:40:24','2026-01-28 23:50:10'),
(1110,500,970,1,31,'10.60.11.56',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-28 22:50:37','2026-01-28 23:50:10'),
(1111,501,969,2,33,'10.20.4.232',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-28 22:50:37','2026-01-28 23:50:10'),
(1112,502,968,1,31,'10.60.11.29',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-28 22:50:37','2026-01-28 23:50:10'),
(1113,503,967,1,31,'10.60.11.66',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-28 22:50:37','2026-01-28 23:50:10'),
(1114,504,966,1,31,'10.60.11.30',NULL,NULL,NULL,'active',0.00,'1/02/2026',NULL,NULL,'','2026-01-28 22:50:37','2026-01-28 23:50:10'),
(1115,505,965,1,31,'10.60.11.51',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-28 22:50:37','2026-01-28 23:50:10'),
(1116,506,964,1,29,'10.60.11.36',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-28 22:50:37','2026-01-28 23:50:10'),
(1117,507,963,1,31,'10.60.11.19',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-28 22:50:37','2026-01-28 23:50:10'),
(1118,508,962,1,29,'10.60.11.34',NULL,NULL,NULL,'active',420.00,'1/02/2026',NULL,NULL,'','2026-01-28 22:50:37','2026-01-28 23:50:10'),
(1119,509,961,1,31,'10.60.11.40',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-28 22:50:37','2026-01-28 23:50:10'),
(1120,510,960,1,31,'10.60.11.38',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-28 22:50:37','2026-01-28 23:50:10'),
(1121,511,959,1,31,'10.60.11.33',NULL,NULL,NULL,'active',300.00,'1/02/2026',NULL,NULL,'','2026-01-28 22:50:37','2026-01-28 23:50:10'),
(1122,512,958,3,31,'10.60.10.56',NULL,NULL,NULL,'active',300.00,'2/02/2026',NULL,NULL,'','2026-01-28 22:50:37','2026-01-28 23:50:10');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'Admin','admin@admin.com',NULL,'$2y$12$1HJ0ivAIDL9dUWC10vf.ZOtDB4Z2WkJLtPn4ha8coikcNqKMl6mFC','5FvAaUg00qoGZcPrc7oy8zTVh6PdWJewV0VV1iGIG6HcvRz0IDQf1SEh1jVH','2026-01-19 04:37:35','2026-01-19 04:37:35'),
(2,'Admin','cironworks@gmail.com',NULL,'$2y$12$3ONZZ6pZlqIjQQXGoL0biu9WNddelTet9.hY6EGThYNTmbQBgLyea','X1ev35uOQX8BUPw5tIwtpW1aVHi5G0GZLXOyERO9gX4fqTGLUsAINQ8zsQbA','2026-01-28 22:44:24','2026-01-28 22:44:24');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vpn_tunnels`
--

DROP TABLE IF EXISTS `vpn_tunnels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `vpn_tunnels` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `config_content` text NOT NULL,
  `test_ip` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `last_latency` int(11) DEFAULT NULL,
  `last_packet_loss` int(11) DEFAULT NULL,
  `last_check_at` timestamp NULL DEFAULT NULL,
  `last_test_output` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vpn_tunnels`
--

LOCK TABLES `vpn_tunnels` WRITE;
/*!40000 ALTER TABLE `vpn_tunnels` DISABLE KEYS */;
INSERT INTO `vpn_tunnels` VALUES
(1,'wg_0','# Name = asistencia\n# ClientPublicKey = uVLnoyV/HR7sIn1sgWJuItvv7M6dF4m9Je/nXgZg9Fg=\n\n[Interface]\nPrivateKey = EJeuE7BN/73RFi4L+FENja8vow1lKijM9p83lQNNmnE=\nAddress = 10.111.0.29/24\nDNS = 1.1.1.1\nMTU = 1420\n\n[Peer]\n# Server public key (MikroTik CHR)\nPublicKey = JpsohwGdt5eCGh/0WdfSubykymGlrzK0E7MVFWmh6Do=\nAllowedIPs = 10.111.0.0/24\nEndpoint = 154.46.30.148:51820\nPersistentKeepalive = 25','10.111.0.1',1,'connected',155,0,'2026-01-30 16:35:44','Reload Output:\n\0\0\0\0\0\0:Warning: `/config/wg_confs/wg_0.conf\' is world accessible\n\0\0\0\0\0\0([#] ip link add dev wg_0 type wireguard\n\0\0\0\0\0\0[#] wg setconf wg_0 /dev/fd/63\n\0\0\0\0\0\0.[#] ip -4 address add 10.111.0.29/24 dev wg_0\n\0\0\0\0\0\0%[#] ip link set mtu 1420 up dev wg_0\n\0\0\0\0\0\0[#] resolvconf -a wg_0 -m 0 -x\n\n\nPing Output:\nPING 10.111.0.1 (10.111.0.1): 56 data bytes\n64 bytes from 10.111.0.1: seq=0 ttl=42 time=156.815 ms\n64 bytes from 10.111.0.1: seq=1 ttl=42 time=154.839 ms\n64 bytes from 10.111.0.1: seq=2 ttl=42 time=155.428 ms\n\n--- 10.111.0.1 ping statistics ---\n3 packets transmitted, 3 packets received, 0% packet loss\nround-trip min/avg/max = 154.839/155.694/156.815 ms','2026-01-29 00:02:42','2026-01-30 16:35:44'),
(2,'Client2','[Interface]\nPrivateKey = MHdWi67c9/TVbkLLxwY5Chj9frvSjDzya6sMXcteuGo=\nAddress = 10.151.0.8/32\nMTU = 1420\nDNS = 1.1.1.1\n\n[Peer]\nPublicKey = rnws4sh1EO25WVjRKNQGeh2dK+dThZWWpZE30dmEcFo=\nAllowedIPs = 10.151.0.0/24\nEndpoint = 64.112.43.234:51825\nPersistentKeepalive = 21','10.151.0.1',1,'disconnected',NULL,100,'2026-01-29 03:20:37','Reload Output:\n\0\0\0\0\0\0=Warning: `/config/wg_confs/Client2.conf\' is world accessible\n\0\0\0\0\0\0+[#] ip link add dev Client2 type wireguard\n\0\0\0\0\0\0\"[#] wg setconf Client2 /dev/fd/63\n\0\0\0\0\0\00[#] ip -4 address add 10.151.0.8/32 dev Client2\n\0\0\0\0\0\0([#] ip link set mtu 1420 up dev Client2\n\0\0\0\0\0\0\"[#] resolvconf -a Client2 -m 0 -x\n\0\0\0\0\0\0.[#] ip -4 route add 10.151.0.0/24 dev Client2\n\0\0\0\0\0\0RTNETLINK answers: File exists\n\0\0\0\0\0\0[#] resolvconf -d Client2 -f\n\0\0\0\0\0\0[#] ip link delete dev Client2\n\n\nPing Output:\nPING 10.151.0.1 (10.151.0.1): 56 data bytes\n\n--- 10.151.0.1 ping statistics ---\n3 packets transmitted, 0 packets received, 100% packet loss','2026-01-29 00:56:16','2026-01-29 03:20:37');
/*!40000 ALTER TABLE `vpn_tunnels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'wms_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-30 16:44:02
