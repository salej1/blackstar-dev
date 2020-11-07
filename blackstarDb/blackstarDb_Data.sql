-- -----------------------------------------------------------------------------
-- File:blackstarDb_startupData.sql
-- Name:blackstarDb_startupData
-- Desc:Hace una carga inicial de usuarios para poder operar el sistema
-- Auth:Sergio A Gomez
-- Date:22/10/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    AuthorDescription
-- --   --------   -------  ------------------------------------
-- 1    22/10/2013  SAG  	Version inicial. Usuarios basicos de GPO Sac
-- --   --------   -------  ------------------------------------
-- 2    12/11/2013  SAG  	Version 1.1. Se agrega ExecuteTransfer
-- ---------------------------------------------------------------------------
use blackstarDb;


-- -----------------------------------------------------------------------------
-- SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------
use blackstarDbTransfer;

UPDATE blackstarDb.sequence SET description = 'Ordenes de servicio tipo AA' WHERE sequenceTypeId = 'A' AND description IS NULL;
UPDATE blackstarDb.sequence SET description = 'Ordenes de servicio tipo BB' WHERE sequenceTypeId = 'B' AND description IS NULL;
UPDATE blackstarDb.sequence SET description = 'Ordenes de servicio tipo General' WHERE sequenceTypeId = 'O' AND description IS NULL;
UPDATE blackstarDb.sequence SET description = 'Ordenes de servicio tipo PE' WHERE sequenceTypeId = 'P' AND description IS NULL;
UPDATE blackstarDb.sequence SET description = 'Ordenes de servicio tipo UPS' WHERE sequenceTypeId = 'U' AND description IS NULL;

CALL ExecuteTransfer();
-- -----------------------------------------------------------------------------
-- FIN - SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------
