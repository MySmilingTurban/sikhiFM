
CREATE DATABASE `apidb`;

DROP TABLE IF EXISTS `apidb`.`tracks`;
CREATE TABLE `tracks` (
  `track_id` int(11) NOT NULL AUTO_INCREMENT,
  `shabad_id` int(11) NOT NULL,
  `track_url` varchar(255) NOT NULL,
  `track_artist` varchar(255) NOT NULL,
  PRIMARY KEY (`track_id`),
  KEY `shabad_id` (`shabad_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7158 DEFAULT CHARSET=utf8mb4;

-- the following command is used to put data from .csv file into the tracks table in our table.
LOAD DATA INFILE '~/Desktop/Khalis/AudioURLsnew.csv'
INTO TABLE tracks
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
