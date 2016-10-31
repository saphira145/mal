/*
Navicat MySQL Data Transfer

Source Server         : vagrant-sagacite
Source Server Version : 50550
Source Host           : 127.0.0.1:3306
Source Database       : mal_compareBase

Target Server Type    : MYSQL
Target Server Version : 50550
File Encoding         : 65001

Date: 2016-10-14 20:15:15
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for agency
-- ----------------------------
DROP TABLE IF EXISTS `agency`;
CREATE TABLE `agency` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `memberID` int(11) DEFAULT NULL,
  `parentNumber` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `agencyName` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `postcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tel` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fax` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `leasingCompany` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `chargingStandard` enum('agency','base') COLLATE utf8_unicode_ci DEFAULT 'base',
  `discount` enum('enable','disable') COLLATE utf8_unicode_ci DEFAULT 'disable',
  `otherCostAjustment` enum('enable','disable') COLLATE utf8_unicode_ci DEFAULT 'disable',
  `otherComponentsCost` enum('enable','disable') COLLATE utf8_unicode_ci DEFAULT 'disable',
  `agencyStandardCommission` decimal(10,0) DEFAULT '0',
  `agencyCommissionAjustment1` decimal(10,0) DEFAULT '0',
  `agencyCommissionAjustment2` decimal(10,0) DEFAULT '0',
  `residualValue` enum('zero','base') COLLATE utf8_unicode_ci DEFAULT 'base',
  `maintenanceFee` enum('agency','base') COLLATE utf8_unicode_ci DEFAULT 'base',
  `interestRate` enum('agency','base') COLLATE utf8_unicode_ci DEFAULT 'base',
  `note` text COLLATE utf8_unicode_ci,
  `contractNote` text COLLATE utf8_unicode_ci,
  `maintenanceNote` text COLLATE utf8_unicode_ci,
  `otherNote` text COLLATE utf8_unicode_ci,
  `createdAt` datetime DEFAULT '1970-01-01 00:00:00',
  `updatedAt` datetime DEFAULT '1970-01-01 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
