-- -----------------------------------------------------------------------------
-- File:blackstarDbTransfer_startupData.sql
-- Name:blackstarDbTransfer_startupData
-- Desc:Implementa cambios en los datos de la base de datos de transferencia
-- Auth:Sergio A Gomez
-- Date:13/03/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    AuthorDescription
-- --   --------   -------  ------------------------------------
-- 1    13/03/2014  SAG  	Version inicial. 
-- ---------------------------------------------------------------------------

use blackstarDbTransfer;

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
UPDATE serviceTx SET serviceTypeId = 'I' WHERE serviceTypeId = 'O';
UPDATE serviceTx SET serviceTypeId = 'A' WHERE serviceTypeId = 'M';
UPDATE serviceTx SET serviceTypeId = 'D' WHERE serviceTypeId = 'R';
UPDATE serviceTx SET serviceTypeId = 'P' WHERE serviceTypeId = 'N';
UPDATE serviceTx SET serviceTypeId = 'P' WHERE serviceTypeId = 'V';

DELETE FROM serviceType
WHERE serviceTypeId IN('O', 'M', 'R', 'N', 'V');

-- -----------------------------------------------------------------------------
-- FIN - ACTUALIZACION DE DATOS
-- -----------------------------------------------------------------------------
