/*
 Navicat Premium Dump SQL

 Source Server         : 192.168.17.128
 Source Server Type    : MySQL
 Source Server Version : 50744 (5.7.44-log)
 Source Host           : 192.168.17.128:3306
 Source Schema         : jiangchen_blog

 Target Server Type    : MySQL
 Target Server Version : 50744 (5.7.44-log)
 File Encoding         : 65001

 Date: 15/01/2026 10:25:43
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for blog
-- ----------------------------
DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '博客内容（Markdown格式）',
  `summary` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `category_id` bigint(20) NULL DEFAULT NULL COMMENT '关联分类表',
  `is_recommend` int(11) NULL DEFAULT NULL,
  `status` int(11) NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `category_id`(`category_id`) USING BTREE,
  CONSTRAINT `blog_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of blog
-- ----------------------------
INSERT INTO `blog` VALUES (1, 'linux基础', 'Linux 是一种自由和开放源码的类 UNIX 操作系统。\r\nLinux 英文解释为 Linux is not Unix。\r\nLinux 是在 1991 由林纳斯·托瓦兹在赫尔辛基大学上学时创立的，主要受到 Minix 和 Unix 思想的启发。', 'Linux 是一种自由和开放源码的类 UNIX 操作系统。\r\nLinux 英文解释为 Linux is not Unix。\r\nLinux 是在 1991 由林纳斯·托瓦兹在赫尔辛基大学上学时创立的，主要受到 Minix 和 Unix 思想的启发。', 1, 1, 1, '2026-01-15 10:24:28', '2026-01-15 10:24:31');
INSERT INTO `blog` VALUES (2, 'java基础', 'java基础\r\n一、java概念\r\n1.什么是程序？\r\n程序： 程序是一组计算机能识别和执行的指令，用于指导计算机执行特定任务或解决特定问题。程序通常由程序员使用某种程序设计语言编写，这些语言包括但不限于Java、C/C++、C#等。编写程序的过程涉及到将算法和数据处理逻辑转换为计算机能够理解的指令序列。这些指令被存储在计算机的存储介质上，如硬盘或内存中，当程序被执行时，计算机会按照这些指令的顺序执行，从而完成特定的功能或任务。\r\n\r\n2.什么是java？\r\nJava是一门面向对象的编程语言，不仅吸收了C++语言的各种优点，还摒弃了C++里难以理解的多继承、指针等概念，因此Java语言具有功能强大和简单易用两个特征。Java语言作为静态面向对象编程语言的代表，极好地实现了面向对象理论，允许程序员以优雅的思维方式进行复杂的编程。\r\n\r\nJava具有简单性、面向对象、分布式、健壮性、安全性、平台独立与可移植性、多线程、动态性等特点。Java可以编写桌面应用程序、Web应用程序、分布式系统和嵌入式系统应用程序等。\r\n\r\n3.java三大版本\r\njavaSE:标准版（桌面程序，控制台开发....）\r\n\r\njavaME:嵌入式开发（手机小家电....）\r\n\r\njavaEE:E企业级开发（web端，服务器开发....）\r\n\r\n4.java软件介绍\r\n1.Java 核心机制-Java 虚拟机 [JVM java virtual machine]\r\nJVM： JVM 是一个虚拟的计算机， 具有指令集并使用不同的存储区域。 负责执行指令， 管理数据、 内存、 寄存器， 包含在JDK 中 。Java 虚拟机机制屏蔽了底层运行平台的差别， 实现了“一次编译， 到处运行” 。\r\n\r\n2. JDK和JRE\r\nJDK： JDK 的全称(Java Development Kit Java 开发工具包) ，JDK = JRE+java的开发工具[java,javac,javadoc,javap 等] 。JDK 是提供给 Java 开发人员使用的， 其中包含了 java 的开发工具， 也包括了 JRE。 所以安装了 JDK， 就不用在单独安装 JRE 了。\r\n\r\nJRE： JRE(Java Runtime Environment Java 运行环境) JRE = JVM + Java 的核心类库[类] 包括 Java 虚拟机(JVM Java Virtual Machine)和 Java 程序所需的核心类库等， 如果想要运行一个开发好的 Java 程序，计算机中只需要安装 JRE 即可。', '一、java概念\r\n1.什么是程序？\r\n程序： 程序是一组计算机能识别和执行的指令，用于指导计算机执行特定任务或解决特定问题。程序通常由程序员使用某种程序设计语言编写，这些语言包括但不限于Java、C/C++', 2, 1, 1, '2026-01-15 10:24:33', '2026-01-15 10:24:36');

-- ----------------------------
-- Table structure for blog_tag
-- ----------------------------
DROP TABLE IF EXISTS `blog_tag`;
CREATE TABLE `blog_tag`  (
  `blog_id` bigint(20) NOT NULL,
  `tag_id` bigint(20) NOT NULL,
  PRIMARY KEY (`blog_id`, `tag_id`) USING BTREE,
  INDEX `tag_id`(`tag_id`) USING BTREE,
  CONSTRAINT `blog_tag_ibfk_1` FOREIGN KEY (`blog_id`) REFERENCES `blog` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `blog_tag_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of blog_tag
-- ----------------------------
INSERT INTO `blog_tag` VALUES (1, 1);

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (2, '开发类');
INSERT INTO `category` VALUES (1, '运维类');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2a$10$Ab8Dt0MA1c5dS0aeJp1nBukOA3Yhn5Jt2lX8D9bs2M8sWI5Jp.Fvq', 'blog', NULL, '2026-01-13 23:20:04');

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tag
-- ----------------------------
INSERT INTO `tag` VALUES (4, 'docker');
INSERT INTO `tag` VALUES (2, 'java');
INSERT INTO `tag` VALUES (1, 'linux');
INSERT INTO `tag` VALUES (3, 'python');

SET FOREIGN_KEY_CHECKS = 1;
