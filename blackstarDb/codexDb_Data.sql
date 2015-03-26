-- -----------------------------------------------------------------------------
-- File: codesDb_Data.sql
-- Name: codesDb_Data
-- Desc: Corre Actualizaciones de datos
-- Auth: Sergio A Gomez
-- Date: 13/08/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author 	Description
-- --   --------   -------  ------------------------------------
-- 1    03/25/2015  SAG  	Version inicial.
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

-- -----------------------------------------------------------------------------
-- SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS blackstarDb.updateCodexData$$
CREATE PROCEDURE blackstarDb.updateCodexData()
BEGIN
	
-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

IF(SELECT COUNT(*) FROM blackstarDb.sequence WHERE description IS NOT NULL) = 0 THEN
	UPDATE sequence SET description = 'Ordenes de servicio tipo AA' WHERE sequenceTypeId = 'A';
	UPDATE sequence SET description = 'Ordenes de servicio tipo BB' WHERE sequenceTypeId = 'B';
	UPDATE sequence SET description = 'Pendientes' WHERE sequenceTypeId = 'I';
	UPDATE sequence SET description = 'Ordenes de servicio tipo General' WHERE sequenceTypeId = 'O';
	UPDATE sequence SET description = 'Ordenes de servicio tipo PE' WHERE sequenceTypeId = 'P';
	UPDATE sequence SET description = 'Ordenes de servicio tipo UPS' WHERE sequenceTypeId = 'U';
END IF;

IF(SELECT COUNT(*) FROM blackstarDb.sequence WHERE sequenceTypeId IN('C','G','M','Q')) = 0 THEN
	INSERT INTO sequence(sequenceTypeId, sequenceNumber, description)
	VALUES('C','336','Secuencia para numero de clientes'),
			('G','683','Cedulas de proyecto GDL'),
			('M','849','Cedulas de proyecto MXO'),
			('Q','868','Cedulas de proyecto QRO');
END IF;
-- -----------------------------------------------------------------------------
-- FIN SECCION DE DATPS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDb.updateCodexData();

DROP PROCEDURE blackstarDb.updateCodexData;