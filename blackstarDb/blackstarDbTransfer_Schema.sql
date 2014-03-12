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

ALTER TABLE blackstarDbTransfer.ticket MODIFY serialNumber VARCHAR(100) NULL DEFAULT NULL;

ALTER TABLE blackstarDbTransfer.policy ADD equipmentUser VARCHAR(100) NULL DEFAULT NULL;

ALTER TABLE blackstarDbTransfer.ticket ADD project  VARCHAR(100) NULL DEFAULT NULL;
