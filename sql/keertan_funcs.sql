-- MySQL dump 10.17  Distrib 10.3.23-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: khalsa_keertan
-- ------------------------------------------------------
-- Server version	10.3.23-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'khalsa_keertan'
--
/*!50003 DROP FUNCTION IF EXISTS `GEN_KFSID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `GEN_KFSID`(LENGTH INT) RETURNS varchar(100) CHARSET latin1
    NO SQL
BEGIN
	DECLARE SID VARCHAR(100);
	DECLARE IT TINYINT(100);
	DECLARE my_int INT;
	DECLARE my_char CHAR(1);
	SET IT = 0;
	SET SID = '';
	WHILE IT < LENGTH DO
		SET my_int = FLOOR(RAND() * 36);
		IF my_int > 9 THEN
			SET my_char = CHAR(my_int+87);
		ELSE
			SET my_char = my_int;
		END IF;
		SET SID = CONCAT(SID,my_char);
		SET IT = IT + 1;
	END WHILE;
	RETURN SID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `KFID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `KFID`() RETURNS char(32) CHARSET latin1
    NO SQL
RETURN REPLACE(UUID(),'-','') ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `KFSID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE FUNCTION `KFSID`(mytable VARCHAR(255)) RETURNS varchar(6) CHARSET latin1
    READS SQL DATA
BEGIN
	DECLARE ID VARCHAR(6);
	IF mytable = 'album' THEN
		REPEAT
			SET ID = GEN_KFSID(6);
			UNTIL NOT EXISTS(SELECT `sID` FROM `album` WHERE `sID` = ID)
		END REPEAT;
	ELSEIF mytable = 'track' THEN
		REPEAT
			SET ID = GEN_KFSID(6);
			UNTIL NOT EXISTS(SELECT `sID` FROM `track` WHERE `sID` = ID)
		END REPEAT;
	ELSEIF mytable = 'playlist' THEN
		REPEAT
			SET ID = GEN_KFSID(6);
			UNTIL NOT EXISTS(SELECT `sID` FROM `playlist` WHERE `sID` = ID)
		END REPEAT;
	ELSE SET ID = GEN_KFSID(6);
	END IF;
	RETURN ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_trackloop` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE PROCEDURE `sp_trackloop`()
BEGIN
	DECLARE curID BIGINT(21);
	DECLARE curCat TEXT;
	DECLARE occurance INT DEFAULT 0;
	DECLARE i INT DEFAULT 0;
	DECLARE splitted_value INT;
	DECLARE bound CHAR(1) DEFAULT ' ';
	DECLARE done INT DEFAULT FALSE;
	DECLARE cur1 CURSOR FOR SELECT `ID`,`CatID` FROM `khalsa_`.`keertan_links`;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
 DROP TEMPORARY TABLE IF EXISTS temp_track_album;
    CREATE TEMPORARY TABLE temp_track_album(
    `id` INT NOT NULL,
    `value` VARCHAR(255) NOT NULL
    ) ENGINE=Memory;
	OPEN cur1;
		read_loop: LOOP
		FETCH cur1 INTO curID,curCat;
		IF done THEN
		LEAVE read_loop;
		END IF;
			SET occurance = (SELECT LENGTH(curCat) - LENGTH(REPLACE(curCat, bound, ''))	 +1);
				SET i=1;
				WHILE i <= occurance DO
				  SET splitted_value =
				  (SELECT REPLACE(
							SUBSTRING(
								SUBSTRING_INDEX(curCat, bound, i),
								LENGTH(
									SUBSTRING_INDEX(curCat, bound, i - 1)
								)
								+ 1
							),
							bound,
							''
						)
				  );
				  -- INSERT INTO track_album (Track,Album) VALUES (
				  INSERT INTO temp_track_album VALUES (curID, splitted_value);
				  SET i = i + 1;
				END WHILE;
		END LOOP;
		SELECT * FROM temp_track_album;
	CLOSE cur1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-07-24 15:38:06
