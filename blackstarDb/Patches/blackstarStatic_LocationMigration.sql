CREATE DATABASE IF NOT EXISTS blackstarStatic;

use blackstarStatic;

CREATE TABLE IF NOT EXISTS blackstarStatic.location(
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
  -- blackstarStatic.importLocation
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarStatic.importLocation$$
CREATE PROCEDURE blackstarStatic.importLocation()
BEGIN

	IF(SELECT count(*) FROM blackstarStatic.location) < (SELECT count(*) FROM blackstarDb.location) THEN
		TRUNCATE TABLE blackstarStatic.location;
	
		INSERT INTO blackstarStatic.location
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

DROP PROCEDURE IF EXISTS blackstarStatic.importLocation$$
  
DELIMITER ;
