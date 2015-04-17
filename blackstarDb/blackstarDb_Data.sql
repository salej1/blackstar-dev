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
-- --   --------   -------  ----------------------------------------------------
-- 7 	22/01/2015	SAG 	Se agrega el registro de costo hora-ingeniero en global settings
-- -----------------------------------------------------------------------------
-- 8 	15/04/2015	SAG 	Se establece isActive en followUp
-- -----------------------------------------------------------------------------

use blackstarDb;

-- -----------------------------------------------------------------------------
-- ACTUALIZACION DE DATOS
-- -----------------------------------------------------------------------------

-- Estableciendo isActive iniciales en followUp
CALL setActiveFollowUp;

-- Estableciendo Global settings inicial
INSERT INTO globalSettings(globalSettingsId, engHourCost)
SELECT a.globalSettingsId, a.engHourCost FROM (
	SELECT 1 AS globalSettingsId, 20 engHourCost
) a
LEFT OUTER JOIN globalSettings g ON g.globalSettingsId = a.globalSettingsId
WHERE g.globalSettingsId IS NULL;

-- Actualizando Descontaminacino de Data Center
UPDATE equipmentType SET equipmentType = 'DESCONTAMINACION' WHERE equipmentTypeId = 'S';

-- Actualizando Tijuana BK
UPDATE serviceCenter SET serviceCenter = 'Tijuana BK' WHERE serviceCenter = 'Tijuana CS';

-- POBLACION DE surveyScore en serviceOrder
UPDATE serviceOrder s
	INNER JOIN surveyService u ON s.surveyServiceId = u.surveyServiceId
SET s.surveyScore = u.score;

-- HOT FIX PARA USUARIOS QUE SE REGISTRARON CON NULL
DELETE FROM blackstarUser WHERE email IS NULL;

-- INSERCION DE NUMEROS DE SECUENCIA PARA issue
INSERT INTO sequence(sequenceTypeId, sequenceNumber)
SELECT a, b FROM (
	SELECT 'I' AS a, 1 AS b
) c WHERE a NOT IN (SELECT sequenceTypeId FROM sequence);

--	INSERCION DE REGISTROS asociados a followUp
INSERT INTO followUpReferenceType(followUpReferenceTypeId, followUpReferenceType)
SELECT a , b  FROM (
	SELECT 'T' AS a, 'Ticket' AS b union
	SELECT 'O' AS a, 'Orden de Servicio' AS b union
	SELECT 'I' AS a, 'Asignacion SAC' AS b
) c WHERE a NOT IN (SELECT followUpReferenceTypeId FROM followUpReferenceType);

--	INSERCION DE REGISTROS asociados a Issue
INSERT INTO issueStatus(issueStatusId, issueStatus)
SELECT a , b  FROM (
	SELECT 'A' AS a, 'ABIERTO' AS b union
	SELECT 'R' AS a, 'RESUELTO' AS b union
	SELECT 'C' AS a, 'CERRADO' AS b 
) c WHERE a NOT IN (SELECT issueStatusId FROM issueStatus);

-- ACTUALIZACION DE followUpReferenceType EN FOLLOWUPS
UPDATE followUp SET
	followUpReferenceTypeId = CASE WHEN ticketId IS NOT NULL THEN 'T' WHEN serviceOrderId IS NOT NULL THEN 'O' WHEN issueId IS NOT NULL THEN 'I' END
WHERE followUpReferenceTypeId IS NULL;

-- ACTUALIZACION DE PROJECT EN scheduledService
UPDATE scheduledService s
	INNER JOIN scheduledServicePolicy sp ON sp.scheduledServiceId = s.scheduledServiceId
	INNER JOIN policy p ON sp.policyId = p.policyId
SET
	s.project = p.project
WHERE s.project IS NULL;

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
DELETE FROM equipmentType WHERE equipmentTypeId IN('T','R','H','J','K','W');

-- AGREGANDO NUEVOS TIPOS DE EQUIPO
INSERT INTO blackstarDb.equipmentType(equipmentTypeId, equipmentType)
SELECT 'L', 'PISO FALSO' FROM blackstarDb.equipmentType
WHERE (SELECT count(*) FROM blackstarDb.equipmentType WHERE equipmentTypeId = 'L') = 0
LIMIT 1;

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

DELETE FROM equipmentUserSync;

SELECT '------------------- EXECUTING TRANSFER -------------------' AS Action;
CALL ExecuteTransfer();

-- -----------------------------------------------------------------------------
-- FIN - ACTUALIZACION DE DATOS
-- -----------------------------------------------------------------------------
