/*
SQLyog v10.2 
MySQL - 5.5.28 : Database - examxx
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`examxx` /*!40100 DEFAULT CHARACTER SET gbk */;

USE `examxx`;

/*Table structure for table `et_comment` */

DROP TABLE IF EXISTS `et_comment`;

CREATE TABLE `et_comment` (
  `comment_id` int(10) NOT NULL AUTO_INCREMENT,
  `question_id` int(10) NOT NULL,
  `index_id` int(10) NOT NULL,
  `user_id` int(10) NOT NULL,
  `content_msg` mediumtext NOT NULL,
  `quoto_id` int(10) NOT NULL DEFAULT '0',
  `re_id` int(10) NOT NULL DEFAULT '0',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  KEY `fk_q_id` (`question_id`),
  KEY `fk_u_id` (`user_id`),
  CONSTRAINT `fk_q_id` FOREIGN KEY (`question_id`) REFERENCES `et_question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_u_id` FOREIGN KEY (`user_id`) REFERENCES `et_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `et_comment` */

/*Table structure for table `et_exam_paper` */

DROP TABLE IF EXISTS `et_exam_paper`;

CREATE TABLE `et_exam_paper` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `content` mediumtext,
  `duration` int(11) NOT NULL COMMENT '试卷考试时间',
  `total_point` int(11) DEFAULT '0',
  `pass_point` int(11) DEFAULT '0',
  `group_id` int(11) NOT NULL COMMENT '班组ID',
  `is_visible` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否所有用户可见，默认为0',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '试卷状态， 0未完成 -> 1已完成 -> 2已发布 -> 3通过审核 （已发布和通过审核的无法再修改）',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `summary` varchar(100) DEFAULT NULL COMMENT '试卷介绍',
  `is_subjective` tinyint(1) DEFAULT NULL COMMENT '为1表示为包含主观题的试卷，需阅卷',
  `answer_sheet` mediumtext COMMENT '试卷答案，用答题卡的结构保存',
  `creator` varchar(40) DEFAULT NULL COMMENT '创建人的账号',
  `paper_type` varchar(40) NOT NULL DEFAULT '1' COMMENT '0 真题 1 模拟 2 专家',
  `field_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='试卷';

/*Data for the table `et_exam_paper` */

/*Table structure for table `et_field` */

DROP TABLE IF EXISTS `et_field`;

CREATE TABLE `et_field` (
  `field_id` int(5) NOT NULL AUTO_INCREMENT,
  `field_name` varchar(50) NOT NULL,
  `memo` varchar(100) DEFAULT NULL,
  `state` decimal(1,0) NOT NULL DEFAULT '1' COMMENT '1 正常 0 废弃',
  PRIMARY KEY (`field_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `et_field` */

insert  into `et_field`(`field_id`,`field_name`,`memo`,`state`) values (1,'java一阶段','java一阶段','1');

/*Table structure for table `et_group` */

DROP TABLE IF EXISTS `et_group`;

CREATE TABLE `et_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `group_level_id` int(11) NOT NULL COMMENT '班组级别',
  `parent` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_level_id` (`group_level_id`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='班组';

/*Data for the table `et_group` */

/*Table structure for table `et_knowledge_point` */

DROP TABLE IF EXISTS `et_knowledge_point`;

CREATE TABLE `et_knowledge_point` (
  `point_id` int(5) NOT NULL AUTO_INCREMENT,
  `point_name` varchar(100) NOT NULL,
  `field_id` int(5) NOT NULL,
  `memo` varchar(100) DEFAULT NULL,
  `state` decimal(1,0) DEFAULT '1' COMMENT '1:正常 0：废弃',
  PRIMARY KEY (`point_id`),
  KEY `fk_knowledge_field` (`field_id`),
  CONSTRAINT `et_knowledge_point_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `et_field` (`field_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

/*Data for the table `et_knowledge_point` */

insert  into `et_knowledge_point`(`point_id`,`point_name`,`field_id`,`memo`,`state`) values (5,'封装、继承、多态',1,'封装、继承、多态','0'),(12,'java基础',1,'java基础','0');

/*Table structure for table `et_news` */

DROP TABLE IF EXISTS `et_news`;

CREATE TABLE `et_news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titile` varchar(100) NOT NULL,
  `content` varchar(2000) NOT NULL,
  `user_id` int(11) NOT NULL COMMENT '创建人',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_expire` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否过期',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 新闻， 1 系统信息',
  `group_id` int(11) NOT NULL DEFAULT '-1' COMMENT '此系统属于哪个组',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `et_news_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `et_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `et_news` */

/*Table structure for table `et_practice_paper` */

DROP TABLE IF EXISTS `et_practice_paper`;

CREATE TABLE `et_practice_paper` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(40) NOT NULL,
  `content` mediumtext,
  `duration` int(11) NOT NULL COMMENT '试卷考试时间',
  `total_point` int(11) DEFAULT '0',
  `pass_point` int(11) DEFAULT '0',
  `group_id` int(11) NOT NULL COMMENT '班组ID',
  `is_visible` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否所有用户可见，默认为0',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '试卷状态， 0未完成 -> 1已完成 -> 2已发布 -> 3通过审核 （已发布和通过审核的无法再修改）',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `summary` varchar(100) DEFAULT NULL COMMENT '试卷介绍',
  `is_subjective` tinyint(1) DEFAULT NULL COMMENT '为1表示为包含主观题的试卷，需阅卷',
  `answer_sheet` mediumtext COMMENT '试卷答案，用答题卡的结构保存',
  `creator` varchar(40) DEFAULT NULL COMMENT '创建人的账号',
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='试卷';

/*Data for the table `et_practice_paper` */

/*Table structure for table `et_question` */

DROP TABLE IF EXISTS `et_question`;

CREATE TABLE `et_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `content` varchar(2000) NOT NULL,
  `question_type_id` int(11) NOT NULL COMMENT '题型',
  `duration` int(11) DEFAULT NULL COMMENT '试题考试时间',
  `points` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL COMMENT '班组ID',
  `is_visible` tinyint(1) NOT NULL DEFAULT '0' COMMENT '试题可见性',
  `create_time` timestamp NULL DEFAULT NULL,
  `creator` varchar(20) NOT NULL DEFAULT 'admin' COMMENT '创建者',
  `last_modify` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `answer` mediumtext NOT NULL,
  `expose_times` int(11) NOT NULL DEFAULT '2',
  `right_times` int(11) NOT NULL DEFAULT '1',
  `wrong_times` int(11) NOT NULL DEFAULT '1',
  `difficulty` int(5) NOT NULL DEFAULT '1',
  `analysis` mediumtext,
  `reference` varchar(1000) DEFAULT NULL,
  `examing_point` varchar(5000) DEFAULT NULL,
  `keyword` varchar(5000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `question_type_id` (`question_type_id`),
  KEY `et_question_ibfk_5` (`creator`),
  CONSTRAINT `et_question_ibfk_1` FOREIGN KEY (`question_type_id`) REFERENCES `et_question_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='试题';

/*Data for the table `et_question` */

/*Table structure for table `et_question_2_point` */

DROP TABLE IF EXISTS `et_question_2_point`;

CREATE TABLE `et_question_2_point` (
  `question_2_point_id` int(10) NOT NULL AUTO_INCREMENT,
  `question_id` int(10) DEFAULT NULL,
  `point_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`question_2_point_id`),
  KEY `fk_question_111` (`question_id`),
  KEY `fk_point_111` (`point_id`),
  CONSTRAINT `et_question_2_point_ibfk_1` FOREIGN KEY (`point_id`) REFERENCES `et_knowledge_point` (`point_id`),
  CONSTRAINT `et_question_2_point_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `et_question` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `et_question_2_point` */

/*Table structure for table `et_question_2_tag` */

DROP TABLE IF EXISTS `et_question_2_tag`;

CREATE TABLE `et_question_2_tag` (
  `question_tag_id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `creator` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`question_tag_id`),
  KEY `fk_question_tag_tid` (`tag_id`),
  KEY `fk_question_tag_qid` (`question_id`),
  CONSTRAINT `fk_question_tag_qid` FOREIGN KEY (`question_id`) REFERENCES `et_question` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_question_tag_tid` FOREIGN KEY (`tag_id`) REFERENCES `et_tag` (`tag_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `et_question_2_tag` */

/*Table structure for table `et_question_type` */

DROP TABLE IF EXISTS `et_question_type`;

CREATE TABLE `et_question_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `subjective` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='试题类型';

/*Data for the table `et_question_type` */

insert  into `et_question_type`(`id`,`name`,`subjective`) values (1,'单选题',0),(2,'多选题',0),(3,'判断题',0),(4,'填空题',0),(5,'简答题',1),(6,'论述题',1),(7,'分析题',1);

/*Table structure for table `et_r_user_role` */

DROP TABLE IF EXISTS `et_r_user_role`;

CREATE TABLE `et_r_user_role` (
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `role_id` int(11) NOT NULL COMMENT '角色ID',
  KEY `user_id` (`user_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `et_r_user_role_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `et_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户_角色 关联表';

/*Data for the table `et_r_user_role` */

insert  into `et_r_user_role`(`user_id`,`role_id`) values (4,1),(5,3),(6,3),(7,3),(8,3),(9,3),(10,3),(11,3),(12,3),(13,3),(14,3),(15,3),(16,3),(17,3),(18,3),(19,3),(20,3),(22,3),(23,3),(24,3),(25,3),(26,3),(28,3),(29,3);

/*Table structure for table `et_reference` */

DROP TABLE IF EXISTS `et_reference`;

CREATE TABLE `et_reference` (
  `reference_id` int(5) NOT NULL AUTO_INCREMENT,
  `reference_name` varchar(200) NOT NULL,
  `memo` varchar(200) DEFAULT NULL,
  `state` decimal(10,0) NOT NULL DEFAULT '1' COMMENT '1 正常 0 废弃',
  PRIMARY KEY (`reference_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

/*Data for the table `et_reference` */

insert  into `et_reference`(`reference_id`,`reference_name`,`memo`,`state`) values (1,'中华人民共和国电力法','1995年12月28日第八全国人民代表大会常务委员会第十七次会议通过，自1996月1日起施行','1'),(2,'电力供应与使用条例','1996年4月17日国务院令96 号发布，自1996年9月1日起施行','1'),(3,'供电营业区划分及管理办法','1996年5月19日电力部第5号令，自1996年9月1日起施行','1'),(4,'居民用户家用电器损坏处理办法','1996年8月21日电力部第7号令，自1996年9月1日起施行','1'),(5,'供电营业规则','1996年10月8日电力部第8号令发布并施行','1'),(6,'承装（修、试）电力设施许可证管理办法','电监会2009年第28号令','1'),(7,'供电服务规范','GB/T 28583-2012','1'),(8,'国家电网公司供电服务规范','国家电网生〔2003〕477号','1'),(9,'国家电网公司城市供电营业规范化服务窗口标准',NULL,'1'),(10,'国家电网公司供电客户服务提供标准','国家电网科〔2011〕56 号','1'),(11,'关于发布国家电网公司新“三个十条”的通知','国家电网办〔2011〕1493号','1'),(12,'国家电网公司供电服务质量标准','国家电网科〔2010〕341号','1'),(13,'国家电网公司供电营业厅标准化建设手册','2010年','1'),(14,'国家电网公司营销客户档案管理规范（试行）','国家电网办〔2013〕71号','1'),(15,'国家电网公司95598业务管理暂行办法',NULL,'1'),(16,'国家电网公司关于深化“你用电我用心”大力提升优质服务水平的意见','国家电网营销〔2014〕104号','1'),(17,'国家电网公司业扩报装工作规范（试行）和国家电网公司业扩供电方案编制导则','国家电网营销〔2010〕1247号','1'),(18,'水利电力部关于颁发《电、热价格》的通知','水电财字第67号','1'),(19,'功率因数调整电费办法','〔83〕水电财字第 215 号','1'),(20,'国民经济行业用电分类','2004年版','1'),(21,'电能计量装置技术管理规程','DL/T 448-2000','1'),(22,'国家电网公司有序用电管理办法','国家电网营销〔2012〕 38 号','1'),(23,'关于全面深化治理整改工作坚决杜绝“三指定” 问题的意见','国家电网营销〔2011〕 756 号','1'),(24,'国家电网公司关于印发进一步简化业扩报装手续优化流程意见的通知','国家电网营销〔2014〕168号','1'),(25,'国家电网公司关于印发分布式电源并网相关意见和规范（修订版）的通知','国家电网办〔2013〕1781号','1'),(26,'国家电网公司关于印发分布式电源并网服务管理规则的通知','国家电网营销〔2014〕174号','1'),(27,'国家电网公司关于可再生能源电价附加补助资金管理有关意见的通知','国家电网财〔2014〕2044号','1'),(28,'国家电网公司营销服务培训题库','中国电力出版社，国家电网公司营销部编，2013年1月','1'),(29,'国家电网公司企业文化手册','2010年版','1'),(30,'建设和弘扬统一的企业文化宣传手册',NULL,'1');

/*Table structure for table `et_role` */

DROP TABLE IF EXISTS `et_role`;

CREATE TABLE `et_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authority` varchar(20) NOT NULL,
  `name` varchar(20) NOT NULL,
  `code` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='角色表';

/*Data for the table `et_role` */

insert  into `et_role`(`id`,`authority`,`name`,`code`) values (1,'ROLE_ADMIN','超级管理员','admin'),(2,'ROLE_TEACHER','教师','teacher'),(3,'ROLE_STUDENT','学员','student');

/*Table structure for table `et_tag` */

DROP TABLE IF EXISTS `et_tag`;

CREATE TABLE `et_tag` (
  `tag_id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(100) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `creator` int(11) NOT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT '0',
  `memo` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`tag_id`),
  KEY `fk_tag_creator` (`creator`),
  CONSTRAINT `fk_tag_creator` FOREIGN KEY (`creator`) REFERENCES `et_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `et_tag` */

/*Table structure for table `et_user` */

DROP TABLE IF EXISTS `et_user`;

CREATE TABLE `et_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `username` varchar(20) NOT NULL COMMENT '账号',
  `truename` varchar(10) DEFAULT NULL COMMENT '真实姓名',
  `password` char(40) NOT NULL,
  `email` varchar(40) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `add_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expire_date` timestamp NULL DEFAULT NULL,
  `add_by` int(11) DEFAULT NULL COMMENT '创建人',
  `enabled` tinyint(1) DEFAULT '0' COMMENT '激活状态：0-未激活 1-激活',
  `field_id` int(10) NOT NULL,
  `last_login_time` timestamp NULL DEFAULT NULL,
  `login_time` timestamp NULL DEFAULT NULL,
  `province` varchar(20) DEFAULT NULL,
  `company` varchar(40) DEFAULT NULL,
  `department` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COMMENT='用户表';

/*Data for the table `et_user` */

insert  into `et_user`(`id`,`username`,`truename`,`password`,`email`,`phone`,`add_date`,`expire_date`,`add_by`,`enabled`,`field_id`,`last_login_time`,`login_time`,`province`,`company`,`department`) values (4,'admin','管理员','260acbffd3c30786febc29d7dd71a9880a811e77','1@1.1',NULL,'2017-04-03 16:18:14',NULL,NULL,1,1,'2017-04-03 15:32:49','2017-04-03 16:18:14',NULL,'2','3'),(5,'yuyang','于洋','e1f8a1d4ca95628df41389f96d14025935a776a4','yuyang_bj@126.com','','2017-04-03 09:13:42',NULL,NULL,1,1,'2017-04-01 23:16:29','2017-04-03 09:12:26',NULL,NULL,NULL),(6,'zhangkai','张凯','8f92ad3f42c50802968fea0dfa0a4bbb71867a1c','',NULL,'2016-09-21 12:26:41',NULL,NULL,0,2,NULL,'2016-05-30 09:06:57',NULL,'北京理博软件','研发部'),(7,'guowei','郭威','593d9d82f7f0aaef506db412eae527bb6952c730','',NULL,'2016-05-30 09:25:39',NULL,NULL,1,2,'2016-05-30 09:05:50','2016-05-30 09:25:39',NULL,'北京理博软件','研发部'),(8,'hanxuesong','韩雪松','9deaee532c5cde581c2e99b67ca8d8270247c733','',NULL,'2016-05-30 09:06:30',NULL,NULL,1,2,NULL,'2016-05-30 09:06:30',NULL,'北京理博软件','研发部'),(9,'liuwenbiao','刘文彪','1b3a80745279798b9b679c122b85582476e38197','',NULL,'2016-05-30 09:07:05',NULL,NULL,1,2,NULL,'2016-05-30 09:07:05',NULL,'北京理博软件','研发部'),(10,'zhangzhanjie','张占杰','740c881b62c6c0e1d5d7aac5bbfa920eebf7826b','',NULL,'2016-05-30 09:06:00',NULL,NULL,1,2,NULL,'2016-05-30 09:06:00',NULL,'北京理博软件','研发部'),(11,'zhoujiaxing','周家兴','6b2b6e17eca152554ff44d1f61a51b6db940c628','',NULL,'2016-05-30 09:08:19',NULL,NULL,1,2,NULL,'2016-05-30 09:08:19',NULL,'北京理博软件','研发部'),(12,'zhangnan','张楠','6d36636d2e870aebfcd3752e70fba450871172e3','',NULL,'2016-05-30 09:05:04',NULL,NULL,1,2,NULL,'2016-05-30 09:05:04',NULL,'北京理博软件','研发部'),(13,'guopeng','郭鹏','93e60c920c689a0bd7954237d97372303f33c411','',NULL,'2016-05-30 09:06:59',NULL,NULL,1,2,NULL,'2016-05-30 09:06:59',NULL,'北京理博软件','研发部'),(14,'fengrui','冯瑞','59585d17c85229c5ebd6f74d9f13a934a900e4ce','',NULL,'2016-05-30 09:08:48',NULL,NULL,1,2,NULL,'2016-05-30 09:08:48',NULL,'北京理博软件','研发部'),(15,'dimengsha','邸梦莎','d9c0d9c1521308761d57c80dfce6d592d238bf52','',NULL,'2016-05-30 09:08:36',NULL,NULL,1,2,NULL,'2016-05-30 09:08:36',NULL,'北京理博软件','研发部'),(16,'zhanghongjiao','张红娇','aedec8e7e62c8a2e98bbad41ed48e85bec0825a9','',NULL,'2016-05-30 09:08:07',NULL,NULL,1,2,'2016-05-30 09:05:59','2016-05-30 09:08:07',NULL,'北京理博软件','研发部'),(17,'wangxuan','王轩','9bb26aa663a8b2d0ce6e80dd4d2d9666dba3de6c','',NULL,'2016-05-30 09:05:18',NULL,NULL,1,2,NULL,'2016-05-30 09:05:18',NULL,'北京理博软件','研发部'),(18,'liwentao','李文涛','4c0120cba48a9278cb3a0efb2be3f8eec2d92cbf','',NULL,'2016-05-26 16:26:58',NULL,NULL,1,2,NULL,NULL,'四川省','北京理博软件','研发部'),(19,'wenxiaoliang','文小亮','7be147d245a29333dd7b517012b938518a7310ae','',NULL,'2016-05-30 09:06:08',NULL,NULL,1,2,NULL,'2016-05-30 09:06:08',NULL,'北京理博软件','研发部'),(20,'niejinglong','聂静龙','dbca98b49aec6ea3061d52c73e53420ad85ffca7','',NULL,'2016-05-30 09:06:22',NULL,NULL,1,2,NULL,'2016-05-30 09:06:22',NULL,'北京理博软件','研发部'),(21,'',NULL,'','',NULL,'2016-05-26 16:27:06',NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL),(22,'liyongtao',NULL,'27e87bc11d8fb91173ea2ab57d61ff8ecfbaa422','',NULL,'2016-05-30 09:07:39',NULL,NULL,1,2,NULL,'2016-05-30 09:07:39',NULL,'北京理博软件','研发部'),(23,'hahah','我的号','d6bd4660b42caabd485c7e47a555ab2b40cc1b81','wod@126.com',NULL,'2016-09-21 12:06:48',NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL),(24,'hahaha','wode','e598faebe271a5f2aa5f05b7904c28310d611968','wode@126.com',NULL,'2016-09-21 12:08:05',NULL,NULL,1,1,NULL,'2016-09-21 12:08:05',NULL,NULL,NULL),(25,'sdfsdfsdf','sdfsdfsdf','761d352e68c1ad67527eba84bbbfb58dd75c5811','sdfsdfsd@qq.com',NULL,'2017-04-02 21:59:27',NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL),(26,'123123','123123','d9058e1acf673973e880699c1ce15e839eb52746','12323@qq.com',NULL,'2017-04-02 22:00:18',NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL),(28,'1231233','123123','6630b3ecb9a8e4c8f71b76a6d0770508d7082f59','12323@qq.com',NULL,'2017-04-02 22:01:31',NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL),(29,'sdfsdf','士大夫','42c307c06f6f74a0a2e10cee5beee1b7455fabd0','yuyang@cm.com',NULL,'2017-04-02 22:36:57',NULL,NULL,1,1,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `et_user_exam_history` */

DROP TABLE IF EXISTS `et_user_exam_history`;

CREATE TABLE `et_user_exam_history` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) NOT NULL,
  `exam_paper_id` int(10) NOT NULL,
  `content` mediumtext,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `answer_sheet` mediumtext,
  `duration` int(10) NOT NULL,
  `point_get` float(10,1) NOT NULL DEFAULT '0.0',
  `submit_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `et_user_exam_history` */

/*Table structure for table `et_user_question_history_t` */

DROP TABLE IF EXISTS `et_user_question_history_t`;

CREATE TABLE `et_user_question_history_t` (
  `user_question_hist_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `user_question_hist` mediumtext NOT NULL,
  `modify_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_question_hist_id`),
  UNIQUE KEY `idx_u_q_hist_userid` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `et_user_question_history_t` */

/*Table structure for table `t_c3p0` */

DROP TABLE IF EXISTS `t_c3p0`;

CREATE TABLE `t_c3p0` (
  `a` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

/*Data for the table `t_c3p0` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
