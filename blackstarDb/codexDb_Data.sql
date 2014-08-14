-- -----------------------------------------------------------------------------
-- File:blackstarDb_startupData.sql
-- Name:blackstarDb_startupData
-- Desc:Hace una carga inicial de usuarios para poder operar el sistema
-- Auth:Sergio A Gomez
-- Date:13/08/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author 	Description
-- --   --------   -------  ------------------------------------
-- 1    13/08/2014  SAG  	Version inicial. 
-- ---------------------------------------------------------------------------
use blackstarDb;

DELIMITER $$

-- -----------------------------------------------------------------------------
-- SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS blackstarDb.updateCodexData$$
CREATE PROCEDURE blackstarDb.updateCodexData()
BEGIN

	IF(SELECT count(*) FROM blackstarDb.cstOffice) = 0 THEN
		INSERT INTO blackstarDb.cstOffice(cstId, officeId)
			SELECT 'portal-servicios@gposac.com.mx', 'Q' UNION
			SELECT 'liliana.diaz@gposac.com.mx','G' UNION
			SELECT 'saul.andrade@gposac.com.mx', 'G';
	END IF;

	IF(SELECT count(*) FROM blackstarDb.sequence WHERE sequenceTypeId IN ('Q','M','G')) = 0 THEN
		INSERT INTO blackstarDb.sequence (sequenceTypeId, sequenceNumber)
			SELECT 'Q', 500 UNION
			SELECT 'M', 500 UNION
			SELECT 'G', 500;
	END IF;
	
	UPDATE blackstarDb.sequence SET description = 'Cedulas de proyecto QRO' WHERE sequenceTypeId = 'Q' AND description IS NULL;
	UPDATE blackstarDb.sequence SET description = 'Cedulas de proyecto MXO' WHERE sequenceTypeId = 'M' AND description IS NULL;
	UPDATE blackstarDb.sequence SET description = 'Cedulas de proyecto GDL' WHERE sequenceTypeId = 'G' AND description IS NULL;

-- -----------------------------------------------------------------------------
-- FIN SECCION DE DATPS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDb.updateCodexData();

DROP PROCEDURE blackstarDb.updateCodexData;