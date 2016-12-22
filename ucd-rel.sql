-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 07, 2016 at 08:48 AM
-- Server version: 5.5.49-0+deb8u1
-- PHP Version: 5.6.23-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mta`
--

-- --------------------------------------------------------

--
-- Table structure for table `accountData`
--

CREATE TABLE IF NOT EXISTS `accountData` (
  `account` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastUsedName` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `x` float(11,4) NOT NULL DEFAULT '1519.6160',
  `y` float(11,4) NOT NULL DEFAULT '-1675.9303',
  `z` float(11,4) NOT NULL DEFAULT '13.5469',
  `rot` smallint(6) NOT NULL DEFAULT '270',
  `dim` mediumint(11) NOT NULL DEFAULT '0',
  `interior` int(4) NOT NULL DEFAULT '0',
  `playtime` bigint(11) NOT NULL DEFAULT '0',
  `team` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Civilians',
  `money` int(11) NOT NULL DEFAULT '25000',
  `model` smallint(6) NOT NULL DEFAULT '0',
  `jobModel` smallint(6) NOT NULL DEFAULT '0',
  `walkstyle` smallint(6) NOT NULL DEFAULT '0',
  `wp` int(10) unsigned NOT NULL DEFAULT '0',
  `health` tinyint(4) unsigned NOT NULL DEFAULT '200',
  `armour` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `occupation` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `nametag` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[ [ 255, 215, 0 ] ]',
  `ownedWeapons` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `weaponString` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `sms_friends` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `aviator` float NOT NULL DEFAULT '0',
  `trucker` float NOT NULL DEFAULT '0',
  `crimXP` int(10) unsigned NOT NULL DEFAULT '0',
  `bankbalance` bigint(20) unsigned NOT NULL DEFAULT '10000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE IF NOT EXISTS `accounts` (
  `account` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `serial` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bankbalance` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- Table structure for table `adminlog`
--

CREATE TABLE IF NOT EXISTS `adminlog` (
`logID` int(10) unsigned NOT NULL,
  `datum` int(11) NOT NULL,
  `name` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `log_` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3305 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE IF NOT EXISTS `admins` (
  `account` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rank` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE IF NOT EXISTS `bans` (
  `val` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `datum` int(255) NOT NULL,
  `duration` int(20) NOT NULL,
  `reason` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `banisher` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `core`
--

CREATE TABLE IF NOT EXISTS `core` (
  `version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `core`
--

INSERT INTO `core` (`version`) VALUES
('Alpha');

-- --------------------------------------------------------

--
-- Table structure for table `friends__`
--

CREATE TABLE IF NOT EXISTS `friends__` (
  `account` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `buddy` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `perms` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `friends__blacklist`
--

CREATE TABLE IF NOT EXISTS `friends__blacklist` (
  `account` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `list` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `friends__requests`
--

CREATE TABLE IF NOT EXISTS `friends__requests` (
  `account` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `by` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `groups_`
--

CREATE TABLE IF NOT EXISTS `groups_` (
  `groupName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `info` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created` datetime NOT NULL,
  `balance` bigint(20) NOT NULL DEFAULT '0',
  `colour` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[ [ 200, 0, 0 ] ]',
  `chatColour` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '[ [ 200, 0, 0 ] ]',
  `gmotd` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `gmotd_setter` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lockInvites` tinyint(4) NOT NULL DEFAULT '0',
  `enableGSC` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- Table structure for table `groups_alliances_`
--

CREATE TABLE IF NOT EXISTS `groups_alliances_` (
  `alliance` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL,
  `info` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `colour` varchar(21) COLLATE utf8mb4_unicode_ci NOT NULL,
  `balance` int(11) NOT NULL,
  `created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `groups_alliances_invites`
--

CREATE TABLE IF NOT EXISTS `groups_alliances_invites` (
  `groupName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alliance` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupBy` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `playerBy` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `groups_alliances_logs`
--

CREATE TABLE IF NOT EXISTS `groups_alliances_logs` (
`logID` bigint(20) NOT NULL,
  `alliance` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `important` tinyint(4) NOT NULL DEFAULT '0',
  `log` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `groups_alliances_members`
--

CREATE TABLE IF NOT EXISTS `groups_alliances_members` (
  `alliance` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rank` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Member'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `groups_blacklist`
--

CREATE TABLE IF NOT EXISTS `groups_blacklist` (
`uniqueID` int(11) NOT NULL,
  `groupName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `serialAccount` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `datum` datetime NOT NULL,
  `by` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `groups_invites`
--

CREATE TABLE IF NOT EXISTS `groups_invites` (
  `account` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `by` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- Table structure for table `groups_logs`
--

CREATE TABLE IF NOT EXISTS `groups_logs` (
`uniqueID` bigint(11) NOT NULL,
  `important` tinyint(4) NOT NULL DEFAULT '0',
  `groupName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `log` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1654 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `groups_members`
--

CREATE TABLE IF NOT EXISTS `groups_members` (
  `account` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rank` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastOnline` int(11) NOT NULL,
  `joined` date NOT NULL,
  `timeOnline` int(11) NOT NULL,
  `warningLevel` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



--
-- Table structure for table `groups_ranks`
--

CREATE TABLE IF NOT EXISTS `groups_ranks` (
  `groupName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rankName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permissions` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `rankIndex` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- Table structure for table `groups_whitelist`
--

CREATE TABLE IF NOT EXISTS `groups_whitelist` (
`uniqueID` int(11) NOT NULL,
  `groupName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `datum` date NOT NULL,
  `by` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `housing`
--

CREATE TABLE IF NOT EXISTS `housing` (
`houseID` int(11) NOT NULL,
  `owner` mediumtext COLLATE utf8mb4_unicode_ci,
  `interiorID` tinyint(4) DEFAULT NULL,
  `x` float DEFAULT '0',
  `y` float DEFAULT '0',
  `z` float DEFAULT '0',
  `houseName` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currentPrice` bigint(20) DEFAULT NULL,
  `boughtForPrice` bigint(20) DEFAULT NULL,
  `initialPrice` int(11) DEFAULT NULL,
  `sale` tinyint(4) DEFAULT NULL,
  `open` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=296 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `housing`
--

INSERT INTO `housing` (`houseID`, `owner`, `interiorID`, `x`, `y`, `z`, `houseName`, `currentPrice`, `boughtForPrice`, `initialPrice`, `sale`, `open`) VALUES
(2, 'UCDhousing', 24, 305.359, -1770.55, 4.5383, 'UCD ~ Housing', 50000, 50000, 50000, 1, 1),
(3, 'UCDhousing', 3, 295.336, -1764.12, 4.8694, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(4, 'UCDhousing', 16, 280.9, -1767.76, 4.5396, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(5, 'UCDhousing', 8, 142.954, -1469.6, 25.2036, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(6, 'UCDhousing', 13, 152.877, -1448.5, 32.845, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(7, 'UCDhousing', 5, 228.252, -1405.04, 51.6094, 'UCD ~ Housing', 250000, 500000, 250000, 0, 0),
(8, 'UCDhousing', 20, 185.749, -1327.38, 70.1069, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(9, 'UCDhousing', 20, 254.827, -1367.04, 53.1094, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(10, 'UCDhousing', 25, 298.448, -1338, 53.4415, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(11, 'UCDhousing', 31, 355.121, -1281.17, 53.7036, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(12, 'UCDhousing', 17, 398.23, -1271.34, 50.0198, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(13, 'UCDhousing', 13, 432.229, -1253.89, 51.5809, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(14, 'UCDhousing', 28, 552.959, -1200.27, 44.8315, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(15, 'UCDhousing', 13, 580.482, -1149.78, 53.1801, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(16, 'UCDhousing', 13, 558.83, -1161.05, 54.4297, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(17, 'UCDhousing', 13, 534.879, -1174.1, 58.8097, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(18, 'UCDhousing', 25, 559.732, -1116.6, 62.8064, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(19, 'UCDhousing', 25, 470.99, -1164.06, 67.2143, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(20, 'UCDhousing', 29, 416.603, -1154.02, 76.6876, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(21, 'UCDhousing', 6, 352.35, -1197.98, 76.5156, 'UCD ~ Housing', 250000, 750000, 250000, 0, 0),
(22, 'UCDhousing', 8, 299.57, -1155.19, 80.9478, 'UCD ~ Housing', 750000, 750000, 750000, 0, 1),
(23, 'UCDhousing', 27, 252.315, -1221.84, 75.3859, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(24, 'UCDhousing', 17, 266.027, -1252.31, 73.8898, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(25, 'UCDhousing', 27, 253.236, -1269.97, 74.4284, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(26, 'UCDhousing', 27, 219.424, -1250, 78.335, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(27, 'UCDhousing', 20, 497.5, -1095.08, 82.3592, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(28, 'UCDhousing', 12, 559.072, -1076.44, 72.922, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(29, 'UCDhousing', 1, 612.18, -1085.88, 58.8267, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(30, 'UCDhousing', 20, 646.071, -1117.34, 44.207, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(31, 'UCDhousing', 29, 700.263, -1060.33, 49.4217, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(32, 'UCDhousing', 20, 648.343, -1058.68, 52.5799, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(33, 'UCDhousing', 20, 673.062, -1020.26, 55.7596, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(34, 'UCDhousing', 13, 724.865, -999.283, 52.7344, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(35, 'UCDhousing', 27, 786.047, -828.566, 70.2896, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(36, 'UCDhousing', 27, 835.942, -894.846, 68.7689, 'UCD ~ Housing', 750000, 500000, 750000, 1, 1),
(37, 'UCDhousing', 28, 827.84, -857.976, 70.3308, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(38, 'UCDhousing', 25, 835.211, -929.185, 55.25, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(39, 'UCDhousing', 8, 874.766, -877.241, 77.8118, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(40, 'UCDhousing', 8, 852.173, -831.676, 89.5017, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(41, 'UCDhousing', 20, 923.902, -853.394, 93.4565, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(42, 'UCDhousing', 25, 910.365, -817.56, 103.126, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(43, 'UCDhousing', 13, 937.874, -848.709, 93.5775, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(44, 'UCDhousing', 29, 966.109, -846.437, 95.5305, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(45, 'UCDhousing', 13, 989.938, -828.582, 95.4686, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(46, 'UCDhousing', 13, 1034.74, -813.212, 101.852, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(47, 'UCDhousing', 29, 1016.92, -763.356, 112.563, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(48, 'UCDhousing', 8, 1093.84, -807.143, 107.42, 'UCD ~ Housing', 750000, 750000, 750000, 0, 1),
(49, 'UCDhousing', 20, 1112.64, -742.073, 100.133, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(51, 'UCDhousing', 8, 1332.08, -633.514, 109.135, 'UCD ~ Housing', 750000, 750000, 750000, 0, 0),
(52, 'UCDhousing', 27, 1442.66, -628.835, 95.7186, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(53, 'UCDhousing', 27, 1496.72, -666.741, 95.6013, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(54, 'UCDhousing', 13, 1527.81, -772.575, 80.5781, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(55, 'UCDhousing', 13, 1535.03, -800.216, 72.8495, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(57, 'UCDhousing', 25, 1535.81, -885.344, 57.6575, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(58, 'UCDhousing', 13, 1468.65, -906.182, 54.8359, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(59, 'UCDhousing', 13, 1421.8, -886.226, 50.6861, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(60, 'UCDhousing', 25, 1410.61, -920.788, 38.4219, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(61, 'UCDhousing', 25, 1440.77, -926.154, 39.6477, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(62, 'UCDhousing', 27, 1094.98, -647.911, 113.648, 'UCD ~ Housing', 750000, 500000, 750000, 0, 0),
(63, 'UCDhousing', 8, 1045.17, -642.933, 120.117, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(64, 'UCDhousing', 27, 980.431, -677.297, 121.976, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(65, 'UCDhousing', 13, 946.267, -710.723, 122.62, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(66, 'UCDhousing', 13, 897.855, -677.226, 116.89, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(67, 'UCDhousing', 29, 867.513, -717.586, 105.68, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(68, 'UCDhousing', 20, 977.378, -771.717, 112.203, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(69, 'UCDhousing', 20, 848.004, -745.526, 94.9693, 'UCD ~ Housing', 500000, 1000000, 500000, 1, 1),
(70, 'UCDhousing', 29, 808.231, -759.27, 76.5314, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(73, 'UCDhousing', 3, 2000.14, -991.711, 32.1314, 'UCD~Housing', 250000, 250000, 250000, 1, 1),
(79, 'UCDhousing', 11, 2495.33, -1691.12, 14.7656, 'CJ House', 1000000, 1000000, 1000000, 1, 1),
(80, 'UCDhousing', 22, 2495.33, -1691.14, 14.7656, 'CJ House', 10000000, 10000000, 10000000, 1, 1),
(81, 'UCDhousing', 22, 1298.52, -798.037, 84.1406, 'Mad Dogs', 10000000, 10000000, 10000000, 1, 1),
(107, 'UCDhousing', 13, 1540.47, -851.208, 64.3361, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(108, 'UCDhousing', 8, 1958.27, -1559.75, 13.6088, 'Secret House ', 1000000, 1000000, 1000000, 1, 1),
(109, 'UCDhousing', 20, -2433.72, 1244.52, 33.6172, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(111, 'UCDhousing', 29, -2433.03, 1264.17, 28.2578, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(112, 'UCDhousing', 20, -2433.99, 1273.88, 25.3093, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(113, 'UCDhousing', 29, -2433.73, 1281.42, 23.7422, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(114, 'UCDhousing', 20, -2433.05, 1301.17, 18.3828, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(115, 'UCDhousing', 29, -2434.02, 1311.02, 15.4172, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(116, 'UCDhousing', 20, -2433.76, 1318.47, 13.8672, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(117, 'UCDhousing', 20, -2433.08, 1338.2, 8.5078, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(118, 'UCDhousing', 20, -2477.24, 1244.42, 33.6094, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(119, 'UCDhousing', 29, -2477.92, 1264.2, 28.25, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(120, 'UCDhousing', 20, -2476.96, 1273.83, 25.3047, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(121, 'UCDhousing', 20, -2477.23, 1281.51, 23.7266, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(122, 'UCDhousing', 29, -2477.75, 1301.04, 18.375, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(123, 'UCDhousing', 20, -2476.84, 1311.36, 15.4426, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(124, 'UCDhousing', 29, -2477.2, 1318.66, 13.8516, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(125, 'UCDhousing', 20, -2477.89, 1338.08, 8.5, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(126, 'UCDhousing', 24, 13.7557, 1210.72, 22.5032, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(127, 'UCDhousing', 24, 13.8881, 1220.05, 22.5032, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(128, 'UCDhousing', 24, 13.8824, 1229.24, 22.5032, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(129, 'UCDhousing', 24, 13.7195, 1229.2, 19.3416, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(130, 'UCDhousing', 24, 13.8883, 1219.99, 19.3387, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(131, 'UCDhousing', 24, 13.8852, 1210.59, 19.3452, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(132, 'UCDhousing', 24, -17.4099, 1215.41, 19.3527, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(133, 'UCDhousing', 24, -26.7087, 1215.41, 19.3523, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(134, 'UCDhousing', 24, -36.0639, 1215.41, 19.3523, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(135, 'UCDhousing', 24, -17.4903, 1215.41, 22.4648, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(136, 'UCDhousing', 24, -26.7704, 1215.41, 22.4648, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(137, 'UCDhousing', 24, -36.0172, 1215.41, 22.4648, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(138, 'UCDhousing', 23, -68.0767, 1221.82, 19.6606, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(139, 'UCDhousing', 23, -68.0838, 1223.43, 19.6513, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(140, 'UCDhousing', 21, -68.0743, 1223.42, 22.4403, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(141, 'UCDhousing', 21, -68.0739, 1221.64, 22.4403, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(142, 'UCDhousing', 23, -88.7802, 1229.74, 19.7422, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(143, 'UCDhousing', 23, -90.6998, 1229.62, 19.7422, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(144, 'UCDhousing', 23, -90.644, 1229.74, 22.4403, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(145, 'UCDhousing', 23, -88.892, 1229.74, 22.4403, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(146, 'UCDhousing', 23, 99.2858, 1179.6, 18.6641, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(147, 'UCDhousing', 23, 99.2841, 1178.15, 18.6641, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(148, 'UCDhousing', 23, 99.2846, 1171.66, 18.6641, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(149, 'UCDhousing', 23, 99.2852, 1170.17, 18.6641, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(150, 'UCDhousing', 23, 99.2849, 1163.6, 18.6641, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(151, 'UCDhousing', 23, 99.285, 1162.15, 18.6565, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(152, 'UCDhousing', 23, 99.2655, 1162.17, 20.9402, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(153, 'UCDhousing', 23, 99.2853, 1163.51, 20.9402, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(154, 'UCDhousing', 23, 99.2847, 1170.21, 20.9402, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(155, 'UCDhousing', 23, 99.2849, 1171.55, 20.9402, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(156, 'UCDhousing', 23, 99.2856, 1178.06, 20.9402, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(157, 'UCDhousing', 23, 99.2841, 1179.58, 20.9402, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(158, 'UCDhousing', 23, 86.2169, 1161.96, 18.6565, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(159, 'UCDhousing', 23, 84.5863, 1161.96, 18.6565, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(160, 'UCDhousing', 23, 78.2674, 1162.07, 18.6641, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(161, 'UCDhousing', 23, 76.6938, 1162.02, 18.6641, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(162, 'UCDhousing', 23, 70.2323, 1162.19, 18.6641, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(163, 'UCDhousing', 23, 68.6554, 1161.96, 18.6641, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(164, 'UCDhousing', 23, 68.7297, 1162.14, 20.9402, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(165, 'UCDhousing', 23, 70.1355, 1161.96, 20.9402, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(166, 'UCDhousing', 23, 76.775, 1161.96, 20.9402, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(167, 'UCDhousing', 23, 78.2619, 1162, 20.9402, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(168, 'UCDhousing', 23, 84.6492, 1161.96, 20.9402, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(169, 'UCDhousing', 23, 86.0228, 1161.97, 20.9402, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(170, 'UCDhousing', 14, 26.18, 1181.57, 19.2556, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(171, 'UCDhousing', 14, 26.1802, 1174.73, 19.3877, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(172, 'UCDhousing', 14, 26.1796, 1167.74, 19.5224, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(173, 'UCDhousing', 14, 26.1792, 1161.08, 19.6388, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(174, 'UCDhousing', 14, -0.7597, 1185.74, 19.4023, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(175, 'UCDhousing', 14, -0.8936, 1178.9, 19.4479, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(176, 'UCDhousing', 14, -0.8889, 1171.93, 19.4973, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(177, 'UCDhousing', 14, -0.8959, 1165.23, 19.5486, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(178, 'UCDhousing', 31, 12.804, 1113.67, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(179, 'UCDhousing', 31, -18.289, 1115.67, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(180, 'UCDhousing', 31, -36.0371, 1115.36, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(181, 'UCDhousing', 31, 1.7525, 1076.03, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(182, 'UCDhousing', 31, -45.0672, 1081.08, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(183, 'UCDhousing', 31, -32.2214, 1038.67, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(184, 'UCDhousing', 27, -207.882, 1119.22, 20.4297, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(185, 'UCDhousing', 27, -176.304, 1112.2, 19.7422, 'UCD ~ Motel', 500000, 500000, 500000, 1, 1),
(186, 'UCDhousing', 27, -206.681, 1086.94, 19.7422, 'UCD ~ Hotel', 500000, 500000, 500000, 1, 1),
(187, 'UCDhousing', 19, -258.247, 1168.87, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(188, 'UCDhousing', 19, -258.247, 1151.18, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(189, 'UCDhousing', 19, -260.239, 1120.05, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(190, 'UCDhousing', 19, -258.837, 1083.07, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(191, 'UCDhousing', 19, -290.846, 1176.68, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(192, 'UCDhousing', 19, -324.354, 1165.67, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(193, 'UCDhousing', 17, -369.822, 1169.5, 20.2719, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(194, 'UCDhousing', 19, -360.846, 1141.75, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(195, 'UCDhousing', 19, -362.839, 1110.82, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(196, 'UCDhousing', 19, -328.247, 1118.88, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(197, 'UCDhousing', 19, -298.325, 1115.67, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(198, 'UCDhousing', 19, -258.252, 1043.82, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(199, 'UCDhousing', 19, -278.878, 1003.07, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(200, 'UCDhousing', 19, -247.948, 1001.08, 20.9399, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(201, 'UCDhousing', 23, -127.134, 974.528, 19.8516, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(202, 'UCDhousing', 24, -92.6643, 970.01, 19.9815, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(203, 'UCDhousing', 23, -67.3017, 971.533, 19.8899, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(204, 'UCDhousing', 23, -37.6833, 962.459, 20.0512, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(205, 'UCDhousing', 23, -12.8432, 974.796, 19.7963, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(206, 'UCDhousing', 23, 22.6703, 968.145, 19.8393, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(207, 'UCDhousing', 23, 70.5415, 973.927, 15.7541, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(208, 'UCDhousing', 23, 64.8977, 1005.23, 13.7598, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(209, 'UCDhousing', 26, 20.5645, 948.836, 20.3168, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(210, 'UCDhousing', 26, -4.1441, 950.994, 19.7031, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(211, 'UCDhousing', 26, -15.3988, 934.293, 21.1059, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(212, 'UCDhousing', 23, 17.7432, 908.966, 23.9583, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(213, 'UCDhousing', 23, 31.5954, 923.903, 23.5995, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(214, 'UCDhousing', 26, -56.5037, 935.28, 21.2074, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(215, 'UCDhousing', 23, -83.0785, 933.127, 20.6929, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(216, 'UCDhousing', 23, -151.142, 933.984, 19.7231, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(217, 'UCDhousing', 23, -123.42, 917.64, 19.9562, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(218, 'UCDhousing', 26, -153.24, 907.11, 19.3012, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(219, 'UCDhousing', 26, -152.525, 881.732, 18.4397, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(220, 'UCDhousing', 26, -123.193, 874.795, 18.7309, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(221, 'UCDhousing', 26, -91.9868, 887.133, 21.2543, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(222, 'UCDhousing', 23, -86.6807, 915.835, 21.0971, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(223, 'UCDhousing', 26, -54.741, 918.716, 22.3715, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(224, 'UCDhousing', 26, -52.946, 894.16, 22.3871, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(225, 'UCDhousing', 24, 21.3937, 1344.14, 9.2811, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(226, 'UCDhousing', 24, 25.753, 1346.04, 9.2811, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(227, 'UCDhousing', 24, 4.6167, 1344.35, 9.2811, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(228, 'UCDhousing', 24, -21.3941, 1348.2, 9.1719, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(229, 'UCDhousing', 24, -29.5413, 1363.35, 9.2811, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(230, 'UCDhousing', 24, 26.7795, 1361.92, 9.1719, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(231, 'UCDhousing', 24, 4.7604, 1380.59, 9.2811, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(232, 'UCDhousing', 24, 9.2512, 1382.32, 9.2811, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(233, 'UCDhousing', 24, -17.1284, 1391.17, 9.2811, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(234, 'UCDhousing', 24, -20.6766, 1388.24, 9.2811, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(235, 'UCDhousing', 24, -1.3142, 1394.68, 9.1719, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(237, 'UCDhousing', 26, 300.124, 1141.26, 9.1375, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(238, 'UCDhousing', 23, -63.1919, 1210.95, 22.4365, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(239, 'UCDhousing', 23, -63.2586, 1234.39, 22.4403, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(240, 'UCDhousing', 23, -63.267, 1210.94, 19.6643, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(241, 'UCDhousing', 23, -78.169, 1234.55, 19.7422, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(242, 'UCDhousing', 23, -101.871, 1234.46, 19.7422, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(243, 'UCDhousing', 23, -78.1704, 1234.63, 22.4403, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(244, 'UCDhousing', 23, -101.611, 1234.47, 22.4403, 'UCD ~ Housing', 100000, 100000, 100000, 1, 1),
(245, 'UCDhousing', 26, 397.285, 1157.57, 8.3481, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(246, 'UCDhousing', 26, 500.845, 1116.38, 15.0356, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(247, 'UCDhousing', 26, 710.381, 1207.88, 13.8481, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(248, 'UCDhousing', 26, 709.928, 1194.86, 13.3964, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(249, 'UCDhousing', 23, 399.83, 2539.56, 16.6796, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(250, 'UCDhousing', 23, 402.179, 2543.62, 16.6796, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(251, 'UCDhousing', 23, 263.534, 2895.42, 10.5314, 'UCD ~ Housing', 75000, 75000, 75000, 1, 1),
(252, 'UCDhousing', 26, -150.102, 2687.78, 62.4297, 'UCD ~ Housing', 150000, 150000, 150000, 1, 1),
(253, 'UCDhousing', 16, 2285.86, 161.726, 28.4416, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(254, 'UCDhousing', 17, 2266.46, 168.335, 28.1536, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(255, 'UCDhousing', 19, 2236.36, 168.303, 28.1535, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(256, 'UCDhousing', 17, 2203.85, 106.085, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(257, 'UCDhousing', 18, 2249.33, 111.771, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(258, 'UCDhousing', 19, 2269.55, 111.768, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(259, 'UCDhousing', 16, 2203.87, 62.2498, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(260, 'UCDhousing', 17, 2323.85, 116.171, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(261, 'UCDhousing', 18, 2363.99, 116.149, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(262, 'UCDhousing', 19, 2323.85, 136.422, 28.4416, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(263, 'UCDhousing', 16, 2364, 141.901, 28.4416, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(264, 'UCDhousing', 16, 2323.85, 162.233, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(265, 'UCDhousing', 17, 2363.99, 166.06, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(266, 'UCDhousing', 19, 2363.99, 187.174, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(267, 'UCDhousing', 16, 2323.85, 191.254, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(268, 'UCDhousing', 16, 2398.3, 111.76, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(269, 'UCDhousing', 17, 2373.87, 71.1912, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(270, 'UCDhousing', 17, 2373.85, 42.3622, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(271, 'UCDhousing', 19, 2373.85, 22.1067, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(273, 'UCDhousing', 19, 2374.12, -8.5745, 28.4416, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(274, 'UCDhousing', 5, 2411.22, -5.5666, 27.6835, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(275, 'UCDhousing', 5, 2411.22, 21.7261, 27.6835, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(276, 'UCDhousing', 19, 2413.74, 61.7629, 28.4416, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(277, 'UCDhousing', 16, 2443.53, 61.7455, 28.4416, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(278, 'UCDhousing', 16, 2446.66, 18.9603, 27.6835, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(280, 'UCDhousing', 29, 2448.51, -11.045, 27.6835, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(281, 'UCDhousing', 16, 2438.71, -54.9635, 28.1535, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(282, 'UCDhousing', 17, 2415.26, -52.2845, 28.1535, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(283, 'UCDhousing', 19, 2383.85, -54.9636, 28.1536, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(284, 'UCDhousing', 18, 2367.28, -49.1258, 28.1535, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(285, 'UCDhousing', 13, 316.013, -1769.44, 4.6244, 'UCD ~ Housing', 750000, 750000, 750000, 1, 1),
(286, 'UCDhousing', 9, 1641.79, 2044.83, 11.3199, 'UCD ~ Housging', 500000, 500000, 500000, 1, 1),
(287, 'UCDhousing', 10, 2389.73, -1346.07, 25.077, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(288, 'UCDhousing', 10, 2383.54, -1366.35, 24.4914, 'UCD ~ Housing', 250000, 250000, 250000, 1, 1),
(289, 'UCDhousing', 22, 1836.93, -1682.46, 13.3272, 'UCD ~ Casino', 50000000, 50000000, 50000000, 1, 1),
(290, 'UCDhousing', 25, 891.235, -783.134, 101.314, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(291, 'UCDhousing', 27, 878.359, -725.706, 106.446, 'UCD ~ Housing', 500000, 500000, 500000, 1, 1),
(292, 'UCDhousing', 22, 1530.21, 751.113, 11.0234, 'UCD ~ Housing', 10000000, 250000, 250000, 1, 1),
(293, 'UCDhousing', 8, -2552.04, 2266.43, 5.4755, 'UCD ~ Housing', 10000000, 100000, 100000, 1, 1),
(295, 'UCDhousing', 22, 1122.71, -2037.01, 69.8943, 'UCD ~ Presidential House', 50000000, 170000, 170000, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `jails`
--

CREATE TABLE IF NOT EXISTS `jails` (
  `account` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration` int(11) NOT NULL,
  `isAdminJail` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL,
  `timeLeft` int(11) NOT NULL,
  `loc` char(2) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `logging`
--

CREATE TABLE IF NOT EXISTS `logging` (
`logID` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type2` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tick` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `serial` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mutes`
--

CREATE TABLE IF NOT EXISTS `mutes` (
  `account` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration` int(11) NOT NULL,
  `timeLeft` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `playerStats`
--

CREATE TABLE IF NOT EXISTS `playerStats` (
  `account` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kills` int(11) NOT NULL DEFAULT '0',
  `deaths` int(11) NOT NULL DEFAULT '0',
  `totalguns` int(11) NOT NULL DEFAULT '0',
  `totalfired` int(11) DEFAULT '0',
  `AP` int(11) NOT NULL DEFAULT '0',
  `arrests` int(11) NOT NULL DEFAULT '0',
  `killArrests` int(11) NOT NULL DEFAULT '0',
  `timesArrested` int(11) NOT NULL,
  `lifetimeWanted` int(11) NOT NULL DEFAULT '0',
  `housesRobbed` int(11) NOT NULL DEFAULT '0',
  `bestDrift` mediumint(8) unsigned DEFAULT '0',
  `totalDrift` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `attemptBR` int(10) unsigned NOT NULL DEFAULT '0',
  `successBR` int(10) unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `punishments`
--

CREATE TABLE IF NOT EXISTS `punishments` (
  `val` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `datum` int(11) NOT NULL DEFAULT '0',
  `serial` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration` int(11) NOT NULL,
  `who` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Console',
  `reason` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `log` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `deleted` enum('0','1') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `punishments`
--
-- --------------------------------------------------------

--
-- Table structure for table `stocks__`
--

CREATE TABLE IF NOT EXISTS `stocks__` (
  `acronym` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int(11) NOT NULL,
  `prev` int(11) NOT NULL,
  `total` int(11) NOT NULL,
  `mininvest` int(11) NOT NULL,
  `minsell` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `stocks__history`
--

CREATE TABLE IF NOT EXISTS `stocks__history` (
  `datum` int(11) NOT NULL,
  `acronym` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- Table structure for table `stocks__holders`
--

CREATE TABLE IF NOT EXISTS `stocks__holders` (
  `account` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `acronym` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- Table structure for table `stocks__transactions`
--

CREATE TABLE IF NOT EXISTS `stocks__transactions` (
`transacID` int(11) NOT NULL,
  `acronym` varchar(11) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int(11) NOT NULL,
  `options` int(11) NOT NULL,
  `action` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1393 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- Table structure for table `turfing`
--

CREATE TABLE IF NOT EXISTS `turfing` (
  `turfID` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `w` float NOT NULL,
  `l` float NOT NULL,
  `h` float NOT NULL,
  `owner` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'group'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `turfing`
--

INSERT INTO `turfing` (`turfID`, `x`, `y`, `z`, `w`, `l`, `h`, `owner`) VALUES
(1, 1377.5, 903, 9, 120, 220, 20, ''),
(2, 1577.7, 883, 9, 180, 240, 20, ''),
(3, 1873, 939, 9, 160, 149, 10, ''),
(4, 1837, 1103, 9, 195, 160, 10, ''),
(5, 2077, 982, 9, 260, 205, 50, ''),
(6, 2082, 1203, 6, 335, 160, 100, ''),
(7, 1014, 985, 5, 154.4, 180, 20, ''),
(8, 1017, 1202, 5, 160.3, 161.1, 20, ''),
(9, 1017, 1383, 0, 160, 321, 17, ''),
(10, 918, 1623, 5, 79.5, 220.3, 12, ''),
(11, 917, 1963.3, 5, 81, 221.3, 20, ''),
(12, 1017.7, 1837, 5, 160, 207, 20, ''),
(13, 1018, 2063.5, 5, 160, 218, 20, ''),
(14, 1398, 2323, 9, 161, 61, 17, ''),
(15, 1577, 2282.5, 9, 180, 130, 18, ''),
(16, 1250, 2516, 9, 350, 113, 20, ''),
(17, 1698, 2720, 9, 215, 165, 16, ''),
(18, 1778, 2564, 9, 200, 120, 15, ''),
(19, 1833, 2282, 9, 95, 190, 16, ''),
(20, 1717, 2063, 2, 200, 100, 23, ''),
(21, 2036, 2348, 9, 180, 102, 70, ''),
(22, 2232.5, 2419, -10, 125, 88, 36, ''),
(23, 2296, 2240, 9, 125, 165, 15, ''),
(24, 2558.8, 2239, 6, 125, 215, 15, ''),
(25, 2354, 903, 9, 185, 168, 20, ''),
(26, 2436, 1080, 9, 165, 285, 20, ''),
(27, 1837, 1284, 8, 195, 163, 20, ''),
(28, 1840, 1464, 6, 195, 240, 22, ''),
(29, 1852, 1722, 6, 222, 304.5, 25, ''),
(30, 2086, 1383, 9, 152, 140, 10, ''),
(31, 2255, 1383, 9, 105, 140, 50, ''),
(32, 2088, 1543, 9, 229, 220, 10, ''),
(33, 2438, 1483, 9, 159, 120, 25, ''),
(34, 2337.2, 1624, 9, 199, 79.5, 20, ''),
(35, 2558, 1624, 9, 119.5, 319, 9, ''),
(36, 2533, 2119, 0, 160, 109, 21, ''),
(37, 2135, 1784, 9, 270, 99, 6, ''),
(38, 2160, 1904, 9, 170, 110, 30, ''),
(39, 2160, 2033, 9, 170, 170, 21, ''),
(40, 2097.5, 903.5, 5, 130, 65, 20, ''),
(41, 2777, 833, 10, 118, 190.5, 20, ''),
(42, 2517, 703, 5, 160.5, 60, 20, ''),
(43, 2157.5, 643, 5, 260, 120, 15, ''),
(44, 2001.1, 633.3, 5, 135.4, 160, 15, ''),
(45, 1877.6, 644, 9, 99.9, 119, 15, ''),
(46, 1577, 663, 5, 180.5, 120, 20, ''),
(47, 2237, 2723, 9, 210, 100, 15, ''),
(48, 2498.68, 2645, 9, 251, 212.2, 32, ''),
(49, 2756, 2312, 9, 140, 290, 8, ''),
(50, 2365, 2061, 9, 152, 165, 10, '');

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE IF NOT EXISTS `vehicles` (
`vehicleID` int(11) NOT NULL,
  `model` int(255) NOT NULL,
  `owner` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `xyz` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `rotation` float(255,0) NOT NULL,
  `colour` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `plates` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `health` int(11) NOT NULL,
  `fuel` int(11) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=270 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `weapon_holders`
--

CREATE TABLE IF NOT EXISTS `weapon_holders` (
`id` int(10) unsigned NOT NULL,
  `account` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `datum` int(10) unsigned NOT NULL,
  `weapons` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3072 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `zones`
--

CREATE TABLE IF NOT EXISTS `zones` (
  `zoneID` int(11) NOT NULL,
  `account` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(22) COLLATE utf8mb4_unicode_ci NOT NULL,
  `authorized` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accountData`
--
ALTER TABLE `accountData`
 ADD PRIMARY KEY (`account`), ADD KEY `account` (`account`), ADD KEY `account_2` (`account`);

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
 ADD PRIMARY KEY (`account`), ADD KEY `accName` (`account`);

--
-- Indexes for table `adminlog`
--
ALTER TABLE `adminlog`
 ADD PRIMARY KEY (`logID`), ADD KEY `logID` (`logID`), ADD KEY `datum` (`datum`);

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
 ADD PRIMARY KEY (`account`);

--
-- Indexes for table `bans`
--
ALTER TABLE `bans`
 ADD PRIMARY KEY (`val`), ADD KEY `val` (`val`);

--
-- Indexes for table `friends__`
--
ALTER TABLE `friends__`
 ADD PRIMARY KEY (`account`,`buddy`), ADD KEY `account` (`account`), ADD KEY `buddy` (`buddy`);

--
-- Indexes for table `friends__blacklist`
--
ALTER TABLE `friends__blacklist`
 ADD PRIMARY KEY (`account`), ADD UNIQUE KEY `account` (`account`), ADD KEY `account_2` (`account`);

--
-- Indexes for table `friends__requests`
--
ALTER TABLE `friends__requests`
 ADD PRIMARY KEY (`account`,`by`), ADD KEY `account` (`account`), ADD KEY `account_2` (`account`);

--
-- Indexes for table `groups_`
--
ALTER TABLE `groups_`
 ADD PRIMARY KEY (`groupName`), ADD KEY `groupName` (`groupName`), ADD KEY `groupName_2` (`groupName`);

--
-- Indexes for table `groups_alliances_`
--
ALTER TABLE `groups_alliances_`
 ADD PRIMARY KEY (`alliance`), ADD UNIQUE KEY `alliance` (`alliance`), ADD KEY `alliance_2` (`alliance`);

--
-- Indexes for table `groups_alliances_invites`
--
ALTER TABLE `groups_alliances_invites`
 ADD PRIMARY KEY (`groupName`,`alliance`), ADD KEY `groupName` (`groupName`), ADD KEY `alliance` (`alliance`);

--
-- Indexes for table `groups_alliances_logs`
--
ALTER TABLE `groups_alliances_logs`
 ADD PRIMARY KEY (`logID`), ADD KEY `logID` (`logID`), ADD KEY `alliance` (`alliance`), ADD KEY `groupName` (`groupName`), ADD KEY `important` (`important`);

--
-- Indexes for table `groups_alliances_members`
--
ALTER TABLE `groups_alliances_members`
 ADD PRIMARY KEY (`alliance`,`groupName`), ADD UNIQUE KEY `alliance` (`alliance`,`groupName`), ADD KEY `alliance_2` (`alliance`,`groupName`);

--
-- Indexes for table `groups_blacklist`
--
ALTER TABLE `groups_blacklist`
 ADD PRIMARY KEY (`uniqueID`);

--
-- Indexes for table `groups_invites`
--
ALTER TABLE `groups_invites`
 ADD PRIMARY KEY (`account`,`groupName`), ADD KEY `account` (`account`,`groupName`);

--
-- Indexes for table `groups_logs`
--
ALTER TABLE `groups_logs`
 ADD PRIMARY KEY (`uniqueID`);

--
-- Indexes for table `groups_members`
--
ALTER TABLE `groups_members`
 ADD PRIMARY KEY (`account`,`groupName`), ADD UNIQUE KEY `account_2` (`account`,`groupName`), ADD KEY `account` (`account`), ADD KEY `account_3` (`account`,`groupName`);

--
-- Indexes for table `groups_ranks`
--
ALTER TABLE `groups_ranks`
 ADD PRIMARY KEY (`groupName`,`rankName`), ADD KEY `groupName` (`groupName`), ADD KEY `groupName_2` (`groupName`,`rankName`);

--
-- Indexes for table `groups_whitelist`
--
ALTER TABLE `groups_whitelist`
 ADD PRIMARY KEY (`uniqueID`);

--
-- Indexes for table `housing`
--
ALTER TABLE `housing`
 ADD PRIMARY KEY (`houseID`);

--
-- Indexes for table `jails`
--
ALTER TABLE `jails`
 ADD PRIMARY KEY (`account`), ADD KEY `account` (`account`);

--
-- Indexes for table `logging`
--
ALTER TABLE `logging`
 ADD PRIMARY KEY (`logID`);

--
-- Indexes for table `mutes`
--
ALTER TABLE `mutes`
 ADD PRIMARY KEY (`account`), ADD KEY `account` (`account`);

--
-- Indexes for table `playerStats`
--
ALTER TABLE `playerStats`
 ADD PRIMARY KEY (`account`), ADD KEY `account` (`account`), ADD KEY `account_2` (`account`);

--
-- Indexes for table `punishments`
--
ALTER TABLE `punishments`
 ADD PRIMARY KEY (`val`,`datum`), ADD KEY `account` (`val`), ADD KEY `serial` (`serial`);

--
-- Indexes for table `stocks__`
--
ALTER TABLE `stocks__`
 ADD UNIQUE KEY `acronym_3` (`acronym`), ADD KEY `acronym` (`acronym`), ADD KEY `acronym_2` (`acronym`);

--
-- Indexes for table `stocks__history`
--
ALTER TABLE `stocks__history`
 ADD PRIMARY KEY (`datum`,`acronym`), ADD KEY `datum` (`datum`), ADD KEY `acronym` (`acronym`);

--
-- Indexes for table `stocks__holders`
--
ALTER TABLE `stocks__holders`
 ADD PRIMARY KEY (`account`,`acronym`), ADD KEY `account` (`account`), ADD KEY `acronym` (`acronym`) USING BTREE;

--
-- Indexes for table `stocks__transactions`
--
ALTER TABLE `stocks__transactions`
 ADD PRIMARY KEY (`transacID`), ADD KEY `acronym` (`acronym`), ADD KEY `account` (`account`);

--
-- Indexes for table `turfing`
--
ALTER TABLE `turfing`
 ADD PRIMARY KEY (`turfID`), ADD KEY `turfID` (`turfID`), ADD KEY `owner` (`owner`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
 ADD PRIMARY KEY (`vehicleID`);

--
-- Indexes for table `weapon_holders`
--
ALTER TABLE `weapon_holders`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `zones`
--
ALTER TABLE `zones`
 ADD PRIMARY KEY (`zoneID`), ADD UNIQUE KEY `zoneID` (`zoneID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `adminlog`
--
ALTER TABLE `adminlog`
MODIFY `logID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3305;
--
-- AUTO_INCREMENT for table `groups_alliances_logs`
--
ALTER TABLE `groups_alliances_logs`
MODIFY `logID` bigint(20) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=30;
--
-- AUTO_INCREMENT for table `groups_blacklist`
--
ALTER TABLE `groups_blacklist`
MODIFY `uniqueID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `groups_logs`
--
ALTER TABLE `groups_logs`
MODIFY `uniqueID` bigint(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1654;
--
-- AUTO_INCREMENT for table `groups_whitelist`
--
ALTER TABLE `groups_whitelist`
MODIFY `uniqueID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `housing`
--
ALTER TABLE `housing`
MODIFY `houseID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=296;
--
-- AUTO_INCREMENT for table `logging`
--
ALTER TABLE `logging`
MODIFY `logID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=122244;
--
-- AUTO_INCREMENT for table `stocks__transactions`
--
ALTER TABLE `stocks__transactions`
MODIFY `transacID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1393;
--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
MODIFY `vehicleID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=270;
--
-- AUTO_INCREMENT for table `weapon_holders`
--
ALTER TABLE `weapon_holders`
MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3072;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
