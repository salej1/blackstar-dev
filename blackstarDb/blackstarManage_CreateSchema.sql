-- -----------------------------------------------------
-- File:	blackstarManage_createSchema.sql    
-- Name:	blackstarManage_createSchema
-- Desc:	crea una version inicial de la base de datos administrativa
-- Auth:	Sergio A Gomez
-- Date:	18/09/2013
-- -----------------------------------------------------
-- Change History
-- -----------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    18/09/2013  SAG  	Version inicial. Error Log
-- -----------------------------------------------------


-- -----------------------------------------------------

-- Seccion de Administracion

-- -----------------------------------------------------

use blackstarManage;

CREATE TABLE IF NOT EXISTS blackstarManage.errorLog
(
	errorLogId INTEGER NOT NULL AUTO_INCREMENT,
	severity VARCHAR(20),
	created DATETIME,
	error VARCHAR(400),
	sender TEXT,
	stackTrace TEXT,
	PRIMARY KEY (errorLogId)
)ENGINE=INNODB;

-- -----------------------------------------------------

-- FIN Seccion de Administracion

-- -----------------------------------------------------
