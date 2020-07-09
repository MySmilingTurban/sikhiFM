--album sql query

--basic:
SELECT * FROM sikhifm_db.Album
WHERE Parent IS NULL;

--with join:
SELECT * FROM `sikhifm_db`.`Album`
LEFT JOIN `TrackAlbum` ON `Album`.`ID`=`TrackAlbum`.`Album`
WHERE `Parent` IS NULL;

--by album id
SELECT * FROM `sikhifm_db`.`Album`
WHERE `ID` = 2;

--add join later 

-- track in album
SELECT * FROM `sikhifm_db`.`TrackAlbum`
LEFT JOIN `sikhifm_db`.`Track`
ON `TrackAlbum`.`Album` = `Track`.`ID`
WHERE `TrackAlbum`.`Album` = 1;
