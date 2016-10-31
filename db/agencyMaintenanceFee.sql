-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.5.50-0ubuntu0.12.04.1 - (Ubuntu)
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             9.3.0.5116
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table mal_compareBase.agencyMaintainanceFee
DROP TABLE IF EXISTS `agencyMaintainanceFee`;
CREATE TABLE IF NOT EXISTS `agencyMaintainanceFee` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mainteFee` int(10) unsigned NOT NULL,
  `mainteRate` float NOT NULL,
  `updateDatetime` datetime NOT NULL,
  `agency_id` int(10) unsigned NOT NULL,
  `agencyMaintainanceInfo_id` int(10) unsigned NOT NULL,
  `set_method` enum('custom','base') COLLATE utf8_general_ci DEFAULT 'custom',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=271 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
