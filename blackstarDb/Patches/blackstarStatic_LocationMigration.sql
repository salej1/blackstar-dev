CREATE DATABASE IF NOT EXISTS blackstarConst;

use blackstarConst;

CREATE TABLE IF NOT EXISTS blackstarConst.location(
  _id INT NOT NULL AUTO_INCREMENT,
  zipCode VARCHAR(20) NOT NULL,
  country TEXT NOT NULL,
  state TEXT NOT NULL,
  municipality TEXT NOT NULL,
  city TEXT,
  neighborhood TEXT NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

DELIMITER $$

-- -----------------------------------------------------------------------------
  -- blackstarConst.importLocation
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarConst.importLocation$$
CREATE PROCEDURE blackstarConst.importLocation()
BEGIN

	IF(SELECT count(*) FROM blackstarConst.location) < (SELECT count(*) FROM blackstarDb.location) THEN
		TRUNCATE TABLE blackstarConst.location;
	
		INSERT INTO blackstarConst.location
		SELECT 
			_id,
			zipCode,
			country,
			state,
			municipality,
			city,
			neighborhood
		FROM blackstarDb.location;
	END IF;
END$$

CALL importLocation$$

DROP PROCEDURE IF EXISTS blackstarConst.importLocation$$
  
DELIMITER ;
