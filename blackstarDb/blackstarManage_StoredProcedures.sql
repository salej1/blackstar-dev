-- -----------------------------------------------------------------------------
-- File:	blackstarManage_StoredProcedures.sql   
-- Name:	blackstarManage_StoredProcedures
-- Desc:	Crea o actualiza los Stored procedures administrativos de la aplicacion
-- Auth:	Sergio A Gomez
-- Date:	03/10/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    03/10/2013	SAG		Se Integran los SP iniciales:
--								blackstarManage.WriteLog
-- -----------------------------------------------------------------------------
use blackstarManage;


DELIMITER $$

-- -----------------------------------------------------------------------------
	-- blackstarManage.WriteLog
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarManage.WriteLog$$
CREATE PROCEDURE blackstarManage.WriteLog (
	pLevel		VARCHAR(20),
	pError		VARCHAR(400),
	pSender		TEXT,
	pStackTrace	TEXT
)
BEGIN

	INSERT INTO blackstarManage.errorLog(
		severity,		
		created, 	
		error,		
		sender,		
		stackTrace
	)
	SELECT 
		pLevel, CONVERT_TZ(now(),'+00:00','-5:00'), pError, pSender, pStackTrace;
	
END$$


-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;