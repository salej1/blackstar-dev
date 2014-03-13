-- ---------------------------------------------------------------------------
-- File:	blackstarDbTransfer_Schema.sql    
-- Name:	blackstarDbTransfer_Schema
-- Desc:	Implementa cambios en el esquema de la BD blackstarDbTransfer
-- Auth:	Sergio A Gomez
-- Date:	20/12/2013
-- ---------------------------------------------------------------------------
-- Change History
-- ---------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  --------------------------------------------------
-- 1    08/08/2013  SAG  	Se aumenta el tamaño de ticket.serialNumber
-- ---------------------------------------------------------------------------
-- 1    04/03/2014  SAG  	Se agregan columnas de portal
-- ---------------------------------------------------------------------------

USE blackstarDbTransfer;


DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDbTransfer.upgradeSchema$$
CREATE PROCEDURE blackstarDbTransfer.upgradeSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

	ALTER TABLE blackstarDbTransfer.ticket MODIFY serialNumber VARCHAR(100) NULL DEFAULT NULL;

	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'policy' AND COLUMN_NAME = 'equipmentUser') = 0  THEN
		ALTER TABLE blackstarDbTransfer.policy ADD equipmentUser VARCHAR(100) NULL DEFAULT NULL;
	END IF;

	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'ticket' AND COLUMN_NAME = 'project') = 0  THEN
		ALTER TABLE blackstarDbTransfer.ticket ADD project  VARCHAR(100) NULL DEFAULT NULL;
	END IF;


-- -----------------------------------------------------------------------------
-- FIN SECCION DE CAMBIOS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDbTransfer.upgradeSchema();

DROP PROCEDURE blackstarDbTransfer.upgradeSchema;