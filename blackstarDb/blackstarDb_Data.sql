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
-- ACTUALIZACION DE DATOS
-- -----------------------------------------------------------------------------

-- CAMBIAR LOS EQUIPOS QUE SE VAN A ELIMINAR
UPDATE policy SET equipmentTypeId = 'B' WHERE equipmentTypeId = 'T';
UPDATE policy SET equipmentTypeId = 'M' WHERE equipmentTypeId = 'R';
UPDATE policy SET equipmentTypeId = 'O' WHERE equipmentTypeId = 'H';
UPDATE policy SET equipmentTypeId = 'A' WHERE equipmentTypeId = 'J';
UPDATE policy SET equipmentTypeId = 'A' WHERE equipmentTypeId = 'K';
UPDATE policy SET equipmentTypeId = 'I' WHERE equipmentTypeId = 'W';

-- ELIMINANDO LOS TIPOS DE EQUIPOS INNECESARIOS
UPDATE equipmentType SET equipmentType = 'BB' WHERE equipmentTypeId = 'B';
UPDATE equipmentType SET equipmentType = 'MODULO' WHERE equipmentTypeId = 'O';
UPDATE equipmentType SET equipmentType = 'PISO FALSO' WHERE equipmentTypeId = 'L';

DELETE FROM equipmentType WHERE equipmentTypeId IN('T','R','H','J','K','W');

-- ELIMINANDO LOS TIPOS DE SERVICIO INNECESARIOS
UPDATE serviceOrder SET serviceTypeId = 'I' WHERE serviceTypeId = 'O';
UPDATE serviceOrder SET serviceTypeId = 'A' WHERE serviceTypeId = 'M';
UPDATE serviceOrder SET serviceTypeId = 'D' WHERE serviceTypeId = 'R';
UPDATE serviceOrder SET serviceTypeId = 'P' WHERE serviceTypeId = 'N';
UPDATE serviceOrder SET serviceTypeId = 'P' WHERE serviceTypeId = 'V';

DELETE FROM serviceType
WHERE serviceTypeId IN('O', 'M', 'R', 'N', 'V');

DELETE FROM ticket WHERE ticketId = 434;
DELETE FROM ticket WHERE ticketId = 432;

use blackstarDbTransfer;

CALL ExecuteTransfer();

-- -----------------------------------------------------------------------------
-- FIN - ACTUALIZACION DE DATOS
-- -----------------------------------------------------------------------------
