-- ---------------------------------------------------------------------------
-- Desc:	Cambia el esquema de la bd
-- Auth:	SAG
-- Date:	25/03/2015
-- ---------------------------------------------------------------------------
-- Change History
-- ---------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- ---------------------------------------------------------------------------
-- 1	25/03/2015	SAG 	Version Inicial
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.upgradeCodexSchema$$
CREATE PROCEDURE blackstarDb.upgradeCodexSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

-- AGREGANDO COLUMNA codexProjectId a followUp
IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'followUp' AND COLUMN_NAME = 'codexProjectId') = 0  THEN
	ALTER TABLE blackstarDb.followUp ADD codexProjectId INT(11) NULL;
	ALTER TABLE blackstarDb.followUp ADD CONSTRAINT R121 FOREIGN KEY (codexProjectId) REFERENCES codexProject (_id);
END IF;  

-- AGREGANDO COLUMNA description a sequence
IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'sequence' AND COLUMN_NAME = 'description') = 0  THEN
	ALTER TABLE sequence ADD description VARCHAR(200) NULL;
END IF;
-- -----------------------------------------------------------------------------
-- FIN SECCION DE CAMBIOS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDb.upgradeCodexSchema();

DROP PROCEDURE blackstarDb.upgradeCodexSchema;