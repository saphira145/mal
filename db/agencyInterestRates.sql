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

-- Dumping structure for table mal_compareBase.agencyInterestRates
DROP TABLE IF EXISTS `agencyInterestRates`;
CREATE TABLE IF NOT EXISTS `agencyInterestRates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `payNumID` int(10) unsigned NOT NULL,
  `ratesIn` double unsigned NOT NULL,
  `ratesOut` double unsigned NOT NULL,
  `updateDatetime` datetime NOT NULL,
  `agency_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Dumping data for table mal_compareBase.agencyInterestRates: ~9 rows (approximately)
/*!40000 ALTER TABLE `agencyInterestRates` DISABLE KEYS */;
/*!40000 ALTER TABLE `agencyInterestRates` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
