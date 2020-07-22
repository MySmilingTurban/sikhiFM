-- -------------------------------------------------------------
-- TablePlus 3.6.2(322)
--
-- https://tableplus.com/
--
-- Database: sikhifm_db
-- Generation Time: 2020-07-06 11:14:21.9310
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE `sikhifm_db`;

DROP TABLE IF EXISTS `sikhifm_db`.`Album`;
CREATE TABLE `sikhifm_db`.`Album` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `sID` char(6) COLLATE utf8_bin DEFAULT NULL,
  `Seq` int(11) NOT NULL DEFAULT 0,
  `Title` varchar(256) COLLATE utf8_bin NOT NULL,
  `Parent` char(32) COLLATE utf8_bin DEFAULT NULL,
  `Art` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `ReleaseDate` date DEFAULT NULL,
  `SmartQuery` varchar(512) COLLATE utf8_bin DEFAULT NULL,
  `SmartSubQuery` varchar(512) COLLATE utf8_bin DEFAULT NULL,
  `Tags` varchar(1024) COLLATE utf8_bin DEFAULT '',
  `Keywords` varchar(256) COLLATE utf8_bin DEFAULT '',
  `Artists` varchar(256) COLLATE utf8_bin DEFAULT '[]' COMMENT 'JSON Array of keertani id',
  `Created` datetime DEFAULT current_timestamp(),
  `Updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID`),
  UNIQUE KEY `sID` (`sID`),
  FULLTEXT KEY `Title` (`Title`),
  CONSTRAINT `CONSTRAINT_1` CHECK (json_valid(`Artists`)),
  CONSTRAINT `CONSTRAINT_2` CHECK (json_valid(`Art`))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `sikhifm_db`.`Artist`;
CREATE TABLE `sikhifm_db`.`Artist` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Prefix` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `Name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `NameGurmukhi` varchar(512) COLLATE utf8_bin DEFAULT NULL,
  `Detail` varchar(255) COLLATE utf8_bin NOT NULL,
  `DetailGurmukhi` varchar(512) COLLATE utf8_bin DEFAULT NULL,
  `Image` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `ActiveStart` year(4) DEFAULT NULL,
  `ActiveEnd` year(4) DEFAULT NULL,
  `Location` int(11) DEFAULT NULL,
  `Description` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `Tags` varchar(1024) COLLATE utf8_bin DEFAULT '',
  `Keywords` varchar(256) COLLATE utf8_bin DEFAULT '',
  `Hidden` tinyint(1) NOT NULL DEFAULT 0,
  `Created` datetime DEFAULT current_timestamp(),
  `Updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID`),
  KEY `Prefix` (`Prefix`),
  KEY `Location` (`Location`),
  FULLTEXT KEY `Name` (`Name`),
  CONSTRAINT `Artist_ibfk_1` FOREIGN KEY (`Prefix`) REFERENCES `Options` (`Name`),
  CONSTRAINT `Artist_ibfk_2` FOREIGN KEY (`Location`) REFERENCES `Location` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `sikhifm_db`.`ConversionQueue`;
CREATE TABLE `sikhifm_db`.`ConversionQueue` (
  `ID` bigint(21) NOT NULL AUTO_INCREMENT,
  `Track` int(11) NOT NULL,
  `Status` tinyint(4) NOT NULL DEFAULT 0,
  `Created` datetime DEFAULT current_timestamp(),
  `Updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID`),
  KEY `Track` (`Track`),
  CONSTRAINT `ConversionQueue_ibfk_1` FOREIGN KEY (`Track`) REFERENCES `Track` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `sikhifm_db`.`Location`;
CREATE TABLE `sikhifm_db`.`Location` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `City` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `State` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `Country` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `Nickname` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `NickNameGurmukhi` varchar(512) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID`),
  FULLTEXT KEY `City` (`City`,`State`,`Country`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `sikhifm_db`.`Options`;
CREATE TABLE `sikhifm_db`.`Options` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Type` varchar(256) COLLATE utf8_bin NOT NULL,
  `Name` varchar(256) COLLATE utf8_bin NOT NULL,
  `Value` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Type` (`Type`,`Name`),
  KEY `Name` (`Name`),
  KEY `Type_2` (`Type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `sikhifm_db`.`Playlist`;
CREATE TABLE `sikhifm_db`.`Playlist` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `sID` char(6) COLLATE utf8_bin DEFAULT NULL,
  `UserID` bigint(20) NOT NULL,
  `Name` varchar(255) COLLATE utf8_bin NOT NULL,
  `Description` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `Current` tinyint(1) NOT NULL DEFAULT 0,
  `Tracks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `Created` datetime DEFAULT current_timestamp(),
  `Updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UserID` (`UserID`,`Name`),
  UNIQUE KEY `sID` (`sID`),
  KEY `UserID_2` (`UserID`,`Current`),
  KEY `UserID_3` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `sikhifm_db`.`Track`;
CREATE TABLE `sikhifm_db`.`Track` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `sID` char(6) COLLATE utf8_bin DEFAULT NULL,
  `Artist` int(11) NOT NULL,
  `Type` varchar(256) COLLATE utf8_bin NOT NULL,
  `Title` varchar(512) COLLATE utf8_bin DEFAULT NULL,
  `Media` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'must include mimetype, bitrate, url',
  `Date` date DEFAULT NULL,
  `FuzzyDate` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `Location` int(11) DEFAULT NULL,
  `Seq` int(4) DEFAULT 0,
  `Number` int(4) DEFAULT 0,
  `EventType` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `Length` varchar(50) COLLATE utf8_bin DEFAULT '00h:00m:00s',
  `UserID` int(11) NOT NULL,
  `Created` datetime DEFAULT current_timestamp(),
  `Updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ID`),
  UNIQUE KEY `sID` (`sID`),
  KEY `Artist` (`Artist`),
  KEY `Type` (`Type`),
  KEY `EventType` (`EventType`),
  KEY `Location` (`Location`),
  CONSTRAINT `track_ibfk_1` FOREIGN KEY (`Artist`) REFERENCES `Artist` (`ID`),
  CONSTRAINT `track_ibfk_2` FOREIGN KEY (`Type`) REFERENCES `Options` (`Name`),
  CONSTRAINT `track_ibfk_3` FOREIGN KEY (`EventType`) REFERENCES `Options` (`Name`),
  CONSTRAINT `track_ibfk_4` FOREIGN KEY (`Location`) REFERENCES `Location` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `sikhifm_db`.`TrackAlbum`;
CREATE TABLE `sikhifm_db`.`TrackAlbum` (
  `Track` int(11) NOT NULL,
  `Album` int(11) NOT NULL,
  PRIMARY KEY (`Track`,`Album`),
  KEY `Album` (`Album`,`Track`),
  CONSTRAINT `track_album_ibfk_1` FOREIGN KEY (`Track`) REFERENCES `Track` (`ID`),
  CONSTRAINT `track_album_ibfk_2` FOREIGN KEY (`Album`) REFERENCES `Album` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `sikhifm_db`.`TrackDisplayRules`;
CREATE TABLE `sikhifm_db`.`TrackDisplayRules` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Rule` varchar(1000) COLLATE utf8_bin NOT NULL,
  `Display` varchar(255) COLLATE utf8_bin NOT NULL,
  `Description` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `Seq` int(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

DROP TABLE IF EXISTS `sikhifm_db`.`TrackLyric`;
CREATE TABLE `sikhifm_db`.`TrackLyric` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Track` int(11) NOT NULL,
  `TimeCode` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `ShabadID` bigint(20) NOT NULL,
  `MainLine` int(10) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Track` (`Track`),
  CONSTRAINT `track_lyric_ibfk_1` FOREIGN KEY (`Track`) REFERENCES `Track` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `sikhifm_db`.`Album` (`ID`, `sID`, `Seq`, `Title`, `Parent`, `Art`, `ReleaseDate`, `SmartQuery`, `SmartSubQuery`, `Tags`, `Keywords`, `Artists`, `Created`, `Updated`) VALUES
('1', '11', '0', 'Album Title 1', NULL, NULL, '2010-07-11', 'SQ 1', 'SSQ 1', 'Album Tag A, Album Tag Z', 'Album Keyword 1, Album Keyword 3', '[]', '2010-07-11 12:00:00', '2020-06-27 12:00:00'),
('2', '12', '0', 'Album Title 2', '1', NULL, '2020-06-17', 'SQ 2', 'SSQ 2', 'Album Tag A, Album Tag Z', 'Album Keyword 1, Album Keyword 3', '[]', '2020-06-17 12:00:00', '2020-06-26 12:00:00'),
('3', '13', '0', 'Album Title 3', NULL, NULL, '2020-06-17', 'SQ 3', 'SSQ 3', 'Album Tag C, Album Tag D', 'Album Keyword 2', '[]', '2020-06-17 12:00:00', '2020-06-26 12:00:00'),
('4', '14', '0', 'Album Title 4', '1', NULL, '2020-05-13', 'SQ 4', 'SSQ 4', 'Album Tag A, Album Tag D', 'Album Keyword 7, Album Keyword 1', '[]', '2020-05-13 12:00:00', '2020-06-26 12:00:00'),
('5', '15', '0', 'Album Title 5', '4', NULL, '2020-06-19', 'SQ 5', 'SSQ 5', 'Album Tag C, Album Tag B', 'Album Keyword 3, Album Keyword 4', '[]', '2020-06-19 12:00:00', '2020-06-26 12:00:00');

INSERT INTO `sikhifm_db`.`Artist` (`ID`, `Prefix`, `Name`, `NameGurmukhi`, `Detail`, `DetailGurmukhi`, `Image`, `ActiveStart`, `ActiveEnd`, `Location`, `Description`, `Tags`, `Keywords`, `Hidden`, `Created`, `Updated`) VALUES
('1', 'Name 1', 'AName 1', 'Name Gurmukhi 1', 'Details 1', 'Details Gurmukhi 1', NULL, '2012', '2017', '1', 'Artist Description 1', 'Artist Tag A, Artist Tag Z', 'Artist Keyword 1, Artist Keyword 1.1', '1', '2010-07-11 12:00:00', '2020-06-26 12:00:00'),
('2', 'Name 2', 'AName 1', 'Name Gurmukhi 2', 'Details 2', 'Details Gurmukhi 2', NULL, '2013', '2016', '1', 'Artist Description 2', 'Artist Tag A, Artist Tag B', 'Artist Keyword 1, Artist Keyword 1.1', '2', '2020-06-17 12:00:00', '2020-06-26 12:00:00'),
('3', 'Name 3', 'AName 2', 'Name Gurmukhi 3', 'Details 3', 'Details Gurmukhi 3', NULL, '2014', '2014', '2', 'Artist Description 3', 'Artist Tag C, Artist Tag D', 'Artist Keyword 2', '3', '2020-06-17 12:00:00', '2020-06-26 12:00:00'),
('4', 'Name 4', 'AName 2', 'Name Gurmukhi 4', 'Details 4', 'Details Gurmukhi 4', NULL, '2012', '2014', '3', 'Artist Description 4', 'Artist Tag A, Artist Tag D', 'Artist Keyword 3', '1', '2010-05-13 12:00:00', '2020-06-26 12:00:00'),
('5', 'Name 5', 'AName 2', 'Name Gurmukhi 5', 'Details 5', 'Details Gurmukhi 5', NULL, '2016', '2017', '4', 'Artist Description 5', 'Artist Tag C, Artist Tag M', 'Artist Keyword 4', '4', '2010-06-19 12:00:00', '2020-06-26 12:00:00');

INSERT INTO `sikhifm_db`.`ConversionQueue` (`ID`, `Track`, `Status`, `Created`, `Updated`) VALUES
('1', '1', '0', '2010-07-11 12:00:00', '2020-06-26 12:00:00'),
('2', '2', '1', '2020-06-17 12:00:00', '2020-06-26 12:00:00'),
('3', '3', '0', '2020-06-17 12:00:00', '2020-06-26 12:00:00'),
('4', '4', '21', '2020-05-13 12:00:00', '2020-06-26 12:00:00'),
('5', '5', '1', '2020-06-19 12:00:00', '2020-06-26 12:00:00');

INSERT INTO `sikhifm_db`.`Location` (`ID`, `City`, `State`, `Country`, `Nickname`, `NickNameGurmukhi`) VALUES
('1', 'Santa Fe', 'New Mexico', 'United States', 'SF Nickname', 'SF GNickname'),
('2', 'Palo Alto', 'California', 'United States', 'PA Nickname', 'PA GNickname'),
('3', 'Berlin', 'Brandenburg', 'Germany', 'B Nickname', 'SF GNickname'),
('4', 'San Francisco', 'California', 'United States', 'SFO Nickname', 'SFO GNickname'),
('5', 'Anchorage', 'Alaska', 'United States', 'A Nickname', 'A GNickname');

INSERT INTO `sikhifm_db`.`Options` (`ID`, `Type`, `Name`, `Value`) VALUES
('1', 'A', 'Name 1', 'Value 1'),
('2', 'A', 'Name 2', 'Value 2'),
('3', 'A', 'Name 3', 'Value 3'),
('4', 'A', 'Name 4', 'Value 4'),
('5', 'A', 'Name 5', 'Value 5');

INSERT INTO `sikhifm_db`.`Playlist` (`ID`, `sID`, `UserID`, `Name`, `Description`, `Current`, `Tracks`, `Created`, `Updated`) VALUES
('1', '11', '1010', 'First Album', 'First Album Description', '0', '10', '2010-07-11 12:00:00', '2020-06-26 12:00:00'),
('2', '12', '2020', 'First Album', 'First Album Description', '0', '10', '2020-06-17 12:00:00', '2020-06-26 12:00:00'),
('3', '13', '3030', 'Second+Third Album', 'Second+Third Album Description', '0', '4', '2020-06-17 12:00:00', '2020-06-26 12:00:00'),
('4', '14', '4040', 'First+Third Album', 'First+Third Album Description', '0', '13', '2020-05-13 12:00:00', '2020-06-26 12:00:00'),
('5', '15', '5050', 'Fourth Album', 'Fourth Album Description', '0', '6', '2020-06-19 12:00:00', '2020-06-26 12:00:00');

INSERT INTO `sikhifm_db`.`Track` (`ID`, `sID`, `Artist`, `Type`, `Title`, `Media`, `Date`, `FuzzyDate`, `Location`, `Seq`, `Number`, `EventType`, `Length`, `UserID`, `Created`, `Updated`) VALUES
('1', '11', '1', 'Name 1', 'Track Title 1', NULL, '2010-07-11', NULL, '1', '1', '10', 'Name 1', '00h:09m:00s', '101', '2010-07-11 12:00:00', '2020-06-26 12:00:00'),
('2', '12', '1', 'Name 2', 'Track Title 2', NULL, '2020-06-17', NULL, '1', '2', '10', 'Name 2', '00h:05m:00s', '202', '2020-06-17 12:00:00', '2020-06-26 12:00:00'),
('3', '13', '2', 'Name 3', 'Track Title 3', NULL, '2020-06-17', NULL, '3', '1', '1', 'Name 3', '01h:00m:00s', '303', '2020-06-17 12:00:00', '2020-06-26 12:00:00'),
('4', '14', '4', 'Name 4', 'Track Title 4', NULL, '2020-05-13', NULL, '4', '1', '3', 'Name 4', '00h:22m:33s', '404', '2010-05-13 12:00:00', '2020-06-26 12:00:00'),
('5', '15', '5', 'Name 5', 'Track Title 5', NULL, '2020-06-19', NULL, '5', '3', '6', 'Name 5', '00h:22m:13s', '505', '2020-06-19 12:00:00', '2020-06-26 12:00:00');

INSERT INTO `sikhifm_db`.`TrackAlbum` (`Track`, `Album`) VALUES
('1', '1'),
('2', '2'),
('3', '3'),
('4', '4'),
('5', '5');

INSERT INTO `sikhifm_db`.`TrackDisplayRules` (`ID`, `Rule`, `Display`, `Description`, `Seq`) VALUES
('1', 'Rule 1', 'Display 1', 'TrackDisplayRules Description 1', '0'),
('2', 'Rule 2', 'Display 2', 'TrackDisplayRules Description 2', '0'),
('3', 'Rule 3', 'Display 3', 'TrackDisplayRules Description 3', '0'),
('4', 'Rule 4', 'Display 4', 'TrackDisplayRules Description 4', '0'),
('5', 'Rule 5', 'Display 5', 'TrackDisplayRules Description 5', '0');

INSERT INTO `sikhifm_db`.`TrackLyric` (`ID`, `Track`, `TimeCode`, `ShabadID`, `MainLine`) VALUES
('1', '1', NULL, '11', NULL),
('2', '2', NULL, '12', NULL),
('3', '3', NULL, '13', NULL),
('4', '4', NULL, '14', NULL),
('5', '5', NULL, '15', NULL);



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;