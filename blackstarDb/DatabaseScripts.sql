drop database blackstarDb;
drop database blackstarManage;

create database blackstarDb;
create database blackstarManage;

-- -----------------------------------------------------------------------------
-- File:	blackstarDb_CreateSchema.sql    
-- Name:	blackstarDb_CreateSchema
-- Desc:	crea una version inicial de la base de datos de produccion
-- Auth:	Sergio A Gomez
-- Date:	18/09/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    18/09/2013  SAG  	Version inicial. Tablas autogeneradas por EA
-- ---------------------------------------------------------------------------
-- --   --------   -------  ------------------------------------
-- 2    8/10/2013  SAG  	Se agrega blackstarUser, userGroup
-- ---------------------------------------------------------------------------

-- -----------------------------------------------------------------------------

-- Seccion autogenerada por EA

-- -----------------------------------------------------------------------------

USE blackstarDb;

SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE blackstarUser_userGroup(
	blackstarUser_userGroupId INTEGER NOT NULL AUTO_INCREMENT,
	blackstarUserId INTEGER NOT NULL,
	userGroupId INTEGER NOT NULL,
	PRIMARY KEY(blackstarUser_userGroupId),
	UNIQUE UQ_blackstarUser_userGroup_blackstarUser_userGroupId(blackstarUser_userGroupId),
	KEY(blackstarUserId),
	KEY(userGroupId)
)ENGINE=INNODB;

CREATE TABLE userGroup
(
	userGroupId INTEGER NOT NULL AUTO_INCREMENT,
	externalId VARCHAR(100) NOT NULL,
	name VARCHAR(100),
	PRIMARY KEY (userGroupId),
	UNIQUE UQ_userGroup_userGroupId(userGroupId)
) ENGINE=INNODB;


CREATE TABLE blackstarUser
(
	blackstarUserId INTEGER NOT NULL AUTO_INCREMENT,
	email VARCHAR(100),
	name VARCHAR(100),
	PRIMARY KEY (blackstarUserId),
	UNIQUE UQ_blackstarUser_blackstarUserId(blackstarUserId)
) ENGINE=INNODB;

CREATE TABLE equipmentType
(
	equipmentTypeId CHAR(1) NOT NULL,
	equipmentType NVARCHAR(50) NOT NULL,
	PRIMARY KEY (equipmentTypeId),
	UNIQUE UQ_equipmentType_equipmentTypeId(equipmentTypeId)
) ENGINE=INNODB;

CREATE TABLE followUp
(
	followUpId INTEGER NOT NULL AUTO_INCREMENT,
	ticketId INTEGER NULL,
	serviceOrderId INTEGER NULL,
	asignee NVARCHAR(50) NULL,
	followup TEXT NULL,
	created DATETIME NULL,
	createdBy NVARCHAR(50) NULL,
	createdByUsr NVARCHAR(50) NULL,
	modified DATETIME NULL,
	modifiedBy NVARCHAR(50) NULL,
	modifiedByUsr NVARCHAR(50) NULL,
	PRIMARY KEY (followUpId),
	UNIQUE UQ_followUp_followUpId(followUpId),
	KEY (ticketId),
	KEY (serviceOrderId)
) ENGINE=INNODB;


CREATE TABLE office
(
	officeId CHAR(1) NOT NULL,
	officeName NVARCHAR(50) NULL,
	officeEmail VARCHAR(100) NULL,
	PRIMARY KEY (officeId),
	UNIQUE UQ_office_officeId(officeId)
) ENGINE=INNODB;


CREATE TABLE policy
(
	policyId INTEGER NOT NULL AUTO_INCREMENT,
	officeId CHAR(1) NOT NULL,
	policyTypeId CHAR(1) NOT NULL,
	customerContract NVARCHAR(50) NULL,
	customer VARCHAR(100) NULL,
	finalUser NVARCHAR(50) NULL,
	project VARCHAR(50) NULL,
	cst NVARCHAR(50) NULL,
	equipmentTypeId CHAR(1) NULL,
	brand VARCHAR(100) NULL,
	model VARCHAR(100) NULL,
	serialNumber VARCHAR(100) NULL,
	capacity NVARCHAR(50) NULL,
	equipmentAddress TEXT NULL,
	equipmentLocation TEXT NULL,
	contactName NVARCHAR(100) NOT NULL,
	contactPhone NVARCHAR(300) NULL,
	contactEmail NVARCHAR(200) NULL,
	startDate DATE NULL,
	endDate DATE NULL,
	visitsPerYear INTEGER NULL,
	responseTimeHR INTEGER NULL,
	solutionTimeHR SMALLINT NULL,
	penalty TEXT NULL,
	service NVARCHAR(50) NULL,
	includesParts TINYINT NOT NULL,
	exceptionParts NVARCHAR(100) NULL,
	serviceCenterId CHAR(1) NULL,
	observations TEXT NULL,
	created DATETIME NULL,
	createdBy NVARCHAR(50) NULL,
	crratedByUsr NVARCHAR(50) NULL,
	modified DATETIME NULL,
	modifiedBy NVARCHAR(50) NULL,
	modifiedByUsr NVARCHAR(50) NULL,
	PRIMARY KEY (policyId),
	UNIQUE UQ_policyHeader_policyId(policyId),
	KEY (equipmentTypeId),
	KEY (officeId),
	KEY (policyTypeId),
	KEY (serviceCenterId),
	KEY (customer),
	KEY (officeId),
	KEY (policyTypeId),
	INDEX IX_serialNumber (serialNumber ASC)
) ENGINE=INNODB;


CREATE TABLE policyType
(
	policyTypeId CHAR(1) NOT NULL,
	policyType NVARCHAR(50) NOT NULL,
	PRIMARY KEY (policyTypeId),
	UNIQUE UQ_policyType_policyTypeId(policyTypeId)
) ENGINE=INNODB;


CREATE TABLE serviceCenter
(
	serviceCenterId CHAR(1) NOT NULL,
	serviceCenter VARCHAR(100) NOT NULL,
	serviceCenterEmail VARCHAR(100) NULL,
	PRIMARY KEY (serviceCenterId),
	UNIQUE UQ_serviceCenter_serviceCenterId(serviceCenterId)
) ENGINE=INNODB;


CREATE TABLE serviceOrder
(
	serviceOrderId INTEGER NOT NULL AUTO_INCREMENT,
	serviceOrderNumber VARCHAR(50),
	serviceTypeId CHAR(1) NULL,
	ticketId INTEGER NULL,
	policyId INTEGER NULL,
	serviceUnit NVARCHAR(10) NULL,
	serviceDate DATETIME NULL,
	responsible NVARCHAR(100) NULL,
	additionalEmployees NVARCHAR(400) NULL,
	receivedBy NVARCHAR(100) NULL,
	serviceComments TEXT NULL,
	serviceStatusId CHAR(1) NULL,
	closed DATETIME NULL,
	consultant NVARCHAR(100) NULL,
	coordinator NVARCHAR(100) NULL,
	asignee NVARCHAR(50) NULL,
	hasErrors TINYINT NULL,
	created DATETIME NULL,
	createdBy NVARCHAR(50) NULL,
	createdByUsr NVARCHAR(50) NULL,
	modified DATETIME NULL,
	modifiedBy NVARCHAR(50) NULL,
	modifiedByUsr NVARCHAR(50) NULL,
	signCreated text,
	signReceivedBy text,
	receivedByPosition NVARCHAR(50) NULL,
	PRIMARY KEY (serviceOrderId),
	UNIQUE UQ_serviceOrder_serviceOrderId(serviceOrderId),
	KEY (serviceTypeId),
	KEY (ticketId),
	KEY (serviceTypeId),
	KEY (serviceStatusId)
) ENGINE=INNODB;


CREATE TABLE serviceOrderAdditionalEngineer(
	serviceOrderAdditionalEngineerId INTEGER NOT NULL AUTO_INCREMENT,
	serviceOrderId INTEGER,
	additionalEngineer VARCHAR(100),
	PRIMARY KEY(serviceOrderAdditionalEngineerId),
	KEY(serviceOrderId)
) ENGINE=INNODB;


CREATE TABLE serviceType
(
	serviceTypeId CHAR(1) NOT NULL,
	serviceType NVARCHAR(50) NULL,
	PRIMARY KEY (serviceTypeId),
	UNIQUE UQ_serviceType_serviceTypeId(serviceTypeId)
) ENGINE=INNODB;


CREATE TABLE ticket
(
	ticketId INTEGER ZEROFILL NOT NULL AUTO_INCREMENT,
	policyId INTEGER NULL,
	serviceOrderId INTEGER NULL,
	ticketNumber  VARCHAR(10) NOT NULL ,
	user NVARCHAR(50) NULL,
	observations TEXT NULL,
	phoneResolved TINYINT(1) NULL DEFAULT NULL ,
	ticketStatusId CHAR(1) NULL,
	realResponseTime SMALLINT NULL,
	responseTimeDeviationHr SMALLINT NULL,
	arrival DATETIME NULL,
	employee NVARCHAR(200) NULL,
	asignee NVARCHAR(50) NULL,
	closed DATETIME NULL,
	solutionTime SMALLINT NULL,
	solutionTimeDeviationHr SMALLINT NULL,
	created DATETIME NULL,
	createdBy NVARCHAR(50) NULL,
	createdByUsr NVARCHAR(50) NULL,
	modified DATETIME NULL,
	modifiedBy NVARCHAR(50) NULL,
	modifiedByUsr NVARCHAR(50) NULL,
	PRIMARY KEY (ticketId),
	UNIQUE UQ_ticket_ticketId(ticketId),
	KEY (policyId),
	KEY (ticketStatusId),
	KEY (serviceOrderId),
	KEY (ticketStatusId)
) ENGINE=INNODB;


CREATE TABLE ticketStatus
(
	ticketStatusId CHAR(1) NOT NULL,
	ticketStatus NVARCHAR(50) NULL,
	PRIMARY KEY (ticketStatusId),
	UNIQUE UQ_ticketStatus_ticketStatusId(ticketStatusId)
) ENGINE=INNODB;

CREATE TABLE serviceStatus
(
	serviceStatusId CHAR(1) NOT NULL,
	serviceStatus NVARCHAR(50) NULL,
	PRIMARY KEY (serviceStatus),
	UNIQUE UQ_serviceStatus_serviceStatusId(serviceStatusId)
) ENGINE=INNODB;



SET FOREIGN_KEY_CHECKS=1;


ALTER TABLE followUp ADD CONSTRAINT FK_followUp_serviceOrder 
	FOREIGN KEY (serviceOrderId) REFERENCES serviceOrder (serviceOrderId);

ALTER TABLE policy ADD CONSTRAINT FK_policy_equipmentType 
	FOREIGN KEY (equipmentTypeId) REFERENCES equipmentType (equipmentTypeId);

ALTER TABLE policy ADD CONSTRAINT FK_policy_office 
	FOREIGN KEY (officeId) REFERENCES office (officeId);

ALTER TABLE policy ADD CONSTRAINT FK_policy_policyType 
	FOREIGN KEY (policyTypeId) REFERENCES policyType (policyTypeId);

ALTER TABLE policy ADD CONSTRAINT FK_policy_serviceCenter 
	FOREIGN KEY (serviceCenterId) REFERENCES serviceCenter (serviceCenterId);

ALTER TABLE serviceOrder ADD CONSTRAINT FK_serviceOrder_serviceType 
	FOREIGN KEY (serviceTypeId) REFERENCES serviceType (serviceTypeId);

ALTER TABLE ticket ADD CONSTRAINT FK_ticket_policy 
	FOREIGN KEY (policyId) REFERENCES policy (policyId);

ALTER TABLE ticket ADD CONSTRAINT FK_ticket_ticketStatus 
	FOREIGN KEY (ticketStatusId) REFERENCES ticketStatus (ticketStatusId);
	
ALTER TABLE ticket ADD CONSTRAINT FK_ticket_serviceOrder
	FOREIGN KEY (serviceOrderId) REFERENCES serviceOrder (serviceOrderId);
	
ALTER TABLE serviceOrder ADD CONSTRAINT FK_serviceOrder_serviceStatus 
	FOREIGN KEY (serviceStatusId) REFERENCES serviceStatus (serviceStatusId);

ALTER TABLE blackstarUser_userGroup ADD CONSTRAINT FK_blackstarUser_userGroup
	FOREIGN KEY (blackstarUserId) REFERENCES blackstarUser (blackstarUserId);
	
ALTER TABLE serviceOrderAdditionalEngineer ADD CONSTRAINT FK_serviceOrderAdditionalEngineer_serviceOrder
	FOREIGN KEY (serviceOrderId) REFERENCES serviceOrder (serviceOrderId);
-- -----------------------------------------------------------------------------

-- FIN - Seccion autogenerada por EA

-- -----------------------------------------------------------------------------




-- -----------------------------------------------------------------------------

-- Seccion de Datos

-- -----------------------------------------------------------------------------
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('U','UPS' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('M','MONITOREO' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('A','AA' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('P','PE' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('C','CA' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('F','FUEGO' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('V','VIDEO' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('D','PDU' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('O','MODULO DE POTENCIA' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('S','SERVICIO DE DESCONTAMINACIÓN DATA CENTER' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('B','BATERIAS' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('E','SUBESTACION' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('T','BATERIAS' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('R','TARJETA ETHERNET' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('Y','BYPASS' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('H','MODULO SWITCH' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('N','TRANSFORMADOR' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('I','SUPRESOR' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('G','TRANSFERENCIA' );   
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('J','CONDENSADORA' );    
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('K','EVAPORADORA' );    

INSERT INTO `blackstarDb`.`ticketStatus` (`ticketStatusId`, `ticketStatus`) VALUES ('A','ABIERTO' );  
INSERT INTO `blackstarDb`.`ticketStatus` (`ticketStatusId`, `ticketStatus`) VALUES ('C','CERRADO' );  
INSERT INTO `blackstarDb`.`ticketStatus` (`ticketStatusId`, `ticketStatus`) VALUES ('R','RETRASADO' );  
INSERT INTO `blackstarDb`.`ticketStatus` (`ticketStatusId`, `ticketStatus`) VALUES ('F','CERRADO FT' ); 

INSERT INTO `blackstarDb`.`office` (`officeId`, `officeName`) VALUES ('M', 'MXO' );  
INSERT INTO `blackstarDb`.`office` (`officeId`, `officeName`) VALUES ('G', 'GDL' );  
INSERT INTO `blackstarDb`.`office` (`officeId`, `officeName`) VALUES ('Q', 'QRO' );  

INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'A', 'Altamira SH'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'P', 'APC'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'C', 'Carmen SI'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'H', 'Chihuahua ER'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'U', 'Culiacan ST'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'G', 'GDL'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'R', 'Merida AS'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'T', 'Monterrey LB'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'Y', 'Monterrey SF'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'M', 'MXO'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'N', 'NA'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'Q', 'QRO'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'J', 'Tijuana CS'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'V', 'Veracruz SA'); 
INSERT INTO `blackstarDb`.`serviceCenter` (`serviceCenterId`, `serviceCenter`) VALUES ( 'L', 'Villahermosa IS'); 

INSERT INTO `blackstarDb`.`policyType` (`policyTypeId`, `policyType`) VALUES ( 'P', 'POLIZA'); 
INSERT INTO `blackstarDb`.`policyType` (`policyTypeId`, `policyType`) VALUES ( 'G', 'GARANTIA'); 

INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('A','ARRANQUE' );  
INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('P','PREVENTIVO' );  
INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('C','CORRECTIVO' );  
INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('I','INSPECCION' );  
INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('T','INSTALACION' );  
INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('L','LIMPIEZA' );  
INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('V','VISITA' );  
INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('D','DIAGNOSTICO' );  
INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('E','LEVANTAMIENTO' );  
INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('O','INSPECCION Y CORRECTIVO' );  
INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('M','PUESTA EN MARCHA' );  
INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('N','MANTENIMIENTO' );  
INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('R','REVISION' );  
INSERT INTO `blackstarDb`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('F','CONFIGURACION' );  

INSERT INTO `blackstarDb`.`serviceStatus` (`serviceStatusId`, `serviceStatus`) VALUES ( 'P', 'PROGRAMADO' ); 
INSERT INTO `blackstarDb`.`serviceStatus` (`serviceStatusId`, `serviceStatus`) VALUES ( 'N', 'NUEVO' ); 
INSERT INTO `blackstarDb`.`serviceStatus` (`serviceStatusId`, `serviceStatus`) VALUES ( 'E', 'PENDIENTE' ); 
INSERT INTO `blackstarDb`.`serviceStatus` (`serviceStatusId`, `serviceStatus`) VALUES ( 'C', 'CERRADO' ); 


select * from equipmentType;
select * from office;
select * from serviceCenter;
select * from policyType;
select * from ticketStatus;
select * from serviceType;
-- -----------------------------------------------------------------------------

-- FIN - Seccion de Datos

-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- File:	blackstarDb_StoredProcedures.sql   
-- Name:	blackstarDb_StoredProcedures
-- Desc:	Crea o actualiza los Stored procedures operativos de la aplicacion
-- Auth:	Sergio A Gomez
-- Date:	03/10/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ----------------------------------------------------
-- 1    03/10/2013	SAG		Se Integran los SP iniciales:
--								blackstarDb.GetServicesScheduleStatus
--								blackstarDb.GetServiceOrders
--								blackstarDb.GetTickets
-- 								blackstarDb.UpdateTicketStatus
-- -----------------------------------------------------------------------------
-- 2    04/10/2013	SAG		Se Integra:
--								blackstarDb.GetUnassignedTickets
-- -----------------------------------------------------------------------------
-- 3    04/10/2013	SAG		Se Integra:
--								blackstarDb.AssignTicket
-- -----------------------------------------------------------------------------
-- 4    08/10/2013	SAG		Se Integra:
--								blackstarDb.GetAllTickets
--								blackstarDb.UpsertUser
--								blackstarDb.CreateUserGroup
-- 								blackstarDb.GetUserData
-- 								blackstarDb.GetDomainEmployees
-- 								blackstarDb.GetCustomerList
-- 								blackstarDb.GetServicesSchedule sustituye a GetServicesScheduleStatus
-- -----------------------------------------------------------------------------
-- 5    14/10/2013	SAG		Se Integra:
-- 								blackstarDb.GetFollowUpByTicket
-- 								blackstarDb.GetBigTicketTable
-- 								blackstarDb.GetTickets se sustituye por GetTicketsByStatus
-- 								blackstarDb.GetTickets
-- 								blackstarDb.GetFollowUpByServiceOrder
-- 								blackstarDb.UpsertScheduledService
-- -----------------------------------------------------------------------------
-- 6    17/10/2013	SAG		Se Integra:
-- 								blackstarDb.AddFollowUpToTicket
-- 								blackstarDb.AddFollowUpToOS
-- -----------------------------------------------------------------------------
-- 7    18/10/2013	SAG		Se Integra:
-- 								blackstarDb.CloseTicket
-- -----------------------------------------------------------------------------
-- 8   19/10/2013	SAG		Se Integra:
-- 								blackstarDb.ReopenTicket
-- -----------------------------------------------------------------------------

use blackstarDb;


DELIMITER $$

-- -----------------------------------------------------------------------------
	-- blackstarDb.ReopenTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.ReopenTicket$$
CREATE PROCEDURE blackstarDb.ReopenTicket(pTicketId INTEGER, pModifiedBy VARCHAR(100))
BEGIN
	
	-- ACTUALIZAR EL ESTATUS DEL TICKET Y NUMERO DE ORDEN DE SERVICIO
	UPDATE ticket t 
		INNER JOIN policy p ON p.policyId = t.policyId
	SET 
		t.ticketStatusId = IF(TIMESTAMPDIFF(HOUR, t.created, CURRENT_DATE()) > p.solutionTimeHR, 'R', 'A'),
		t.modified = CURRENT_DATE(),
		t.modifiedBy = 'ReopenTicket',
		t.modifiedByUsr = pModifiedBy
	WHERE t.ticketId = pTicketId;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.CloseTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CloseTicket$$
CREATE PROCEDURE blackstarDb.CloseTicket(pTicketId INTEGER, pOsId INTEGER, pModifiedBy VARCHAR(100))
BEGIN
	
	-- ACTUALIZAR EL ESTATUS DEL TICKET Y NUMERO DE ORDEN DE SERVICIO
	UPDATE ticket t 
		INNER JOIN ticket t2 on t.ticketId = t2.ticketId
	SET 
		t.ticketStatusId = IF(t2.ticketStatusId = 'R', 'F', 'C'),
		t.serviceOrderId = pOsId,
		t.modified = CURRENT_DATE(),
		t.modifiedBy = 'CloseTicket',
		t.modifiedByUsr = pModifiedBy
	WHERE t.ticketId = pTicketId;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpToOS$$
CREATE PROCEDURE blackstarDb.AddFollowUpToOS(pOsId INTEGER, pCreated DATETIME, pCreatedBy VARCHAR(100), pAsignee VARCHAR(100), pMessage TEXT)
BEGIN

	-- INSERTAR EL REGISTRO DE SEGUIMIENTO
	INSERT INTO blackstarDb.followUp(
		serviceOrderId,
		asignee,
		followup,
		created,
		createdBy,
		createdByUsr
	)
	SELECT 
		pOsId,
		pAsignee,
		pMessage,
		pCreated,
		'AddFollowUpToTicket',
		pCreatedBy;
		
	-- ASIGNAR lA ORDEN DE SERVICIO
	UPDATE serviceOrder SET	
		asignee = pAsignee,
		modified = CURRENT_DATE(),
		modifiedBy = 'AddFollowUpToTicket',
		modifiedByUsr = pCreatedBy
	WHERE ticketId = pOsId;
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpToTicket$$
CREATE PROCEDURE blackstarDb.AddFollowUpToTicket(pTicketId INTEGER, pCreated DATETIME, pCreatedBy VARCHAR(100), pAsignee VARCHAR(100), pMessage TEXT)
BEGIN

	-- INSERTAR EL REGISTRO DE SEGUIMIENTO
	INSERT INTO blackstarDb.followUp(
		ticketId,
		asignee,
		followup,
		created,
		createdBy,
		createdByUsr
	)
	SELECT 
		pTicketId,
		pAsignee,
		pMessage,
		pCreated,
		'AddFollowUpToTicket',
		pCreatedBy;
		
	-- ASIGNAR EL TICKET
	UPDATE ticket SET	
		asignee = pAsignee,
		modified = CURRENT_DATE(),
		modifiedBy = 'AddFollowUpToTicket',
		modifiedByUsr = pCreatedBy
	WHERE ticketId = pTicketId;
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertScheduledService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertScheduledService$$
CREATE PROCEDURE blackstarDb.UpsertScheduledService(pPolicyId INTEGER, pScheduledDate DATETIME, engineer VARCHAR(100), pCreatedByUsr VARCHAR(100))
BEGIN

	INSERT INTO serviceOrder(
		policyId,
		serviceDate,
		responsible,
		asignee,
		serviceStatusId,
		created,
		createdBy,
		createdByUsr
	)
	SELECT
		pPolicyId,
		pScheduledDate,
		engineer,
		engineer,
		'P',
		CURRENT_DATE(),
		'UpsertScheduledService',
		pCreatedByUsr;
		
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFollowUpByServiceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFollowUpByServiceOrder$$
CREATE PROCEDURE blackstarDb.GetFollowUpByServiceOrder(pServiceOrderId INTEGER)
BEGIN

	SELECT 
		created AS created,
		u2.name AS createdBy,
		u.name AS asignee,
		followup AS followUp
	FROM followUp f
		INNER JOIN blackstarUser u ON f.asignee = u.email
		INNER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE serviceOrderId = pServiceOrderId
	ORDER BY f.created;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBigTicketTable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBigTicketTable$$
CREATE PROCEDURE blackstarDb.GetBigTicketTable()
BEGIN

	SELECT 
		'' AS num,
		t.ticketId AS DT_RowId,
		t.created AS created,
		t.user AS createdBy,
		p.contactName AS contactName,
		p.contactPhone AS contactPhone,
		p.contactEmail AS contactEmail,
		p.serialNumber AS serialNumber,
		p.observations AS observations,
		p.customer AS customer,
		et.equipmentType AS equipmentType,
		p.brand AS brand,
		p.model AS model,
		p.capacity AS capacity,
		p.responseTimeHr AS responseTimeHr,
		p.solutionTimeHr AS solutionTimeHr,
		p.equipmentAddress AS equipmentAddress,
		p.equipmentLocation AS equipmentLocation,
		IF(p.includesParts, 'SI', 'NO') AS includesParts,
		p.exceptionParts AS exceptionParts,
		sc.serviceCenter AS serviceCenter,
		o.officeName AS office,
		p.project AS project,
		t.ticketNumber AS ticketNumber,
		IF(t.phoneResolved, 'SI', 'NO') AS phoneResolved,
		IFNULL(t.arrival, '') AS arrival,
		t.responseTimeDeviationHr AS responseTimeDeviationHr,
		'FollowUp' AS followUp,
		IFNULL(t.closed, '') AS closed,
		IFNULL(so.serviceOrderNumber, '') AS serviceOrderNumber,
		t.employee AS employee,
		t.solutionTime AS solutionTime,
		t.solutionTimeDeviationHr AS solutionTimeDeviationHr,
		ts.ticketStatus AS ticketStatus,
		t.ticketNumber AS Cerrar
	FROM ticket t
		INNER JOIN policy p ON p.policyId = t.policyId	
		INNER JOIN ticketStatus ts on ts.ticketStatusId = t.ticketStatusId
		INNER JOIN office o ON p.officeId = o.officeId
		INNER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
		INNER JOIN equipmentType et ON et.equipmentTypeId = p.equipmentTypeId
		LEFT OUTER JOIN serviceOrder so ON so.serviceOrderId = t.serviceOrderId
	ORDER BY created;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFollowUpByOS
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFollowUpByOS$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFollowUpByTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFollowUpByTicket$$
CREATE PROCEDURE blackstarDb.GetFollowUpByTicket(pTicketId INTEGER)
BEGIN

	SELECT 
		created AS created,
		u2.name AS createdBy,
		u.name AS asignee,
		followup AS followUp
	FROM followUp f
		LEFT OUTER JOIN blackstarUser u ON f.asignee = u.email
		LEFT OUTER JOIN blackstarUser u2 ON f.createdBy = u2.email
	WHERE ticketId = pTicketId
	ORDER BY created;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServicesByPolicyId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServicesByPolicyId$$
CREATE PROCEDURE blackstarDb.GetServicesByPolicyId(pPolicyId INTEGER)
BEGIN

	SELECT serviceOrderId AS ServiceOrderId,
		   serviceOrderNumber AS serviceOrderNumber
	FROM blackstarDb.serviceOrder
	WHERE policyId = pPolicyId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetCustomerList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetCustomerList$$
CREATE PROCEDURE blackstarDb.GetCustomerList()
BEGIN

	SELECT customer
	FROM blackstarDb.policy
		WHERE startDate <= CURRENT_DATE() AND CURRENT_DATE <= endDate
	ORDER BY customer;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServicesSchedule
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServicesSchedule$$
CREATE PROCEDURE blackstarDb.GetServicesSchedule()
BEGIN

	SELECT 
		serviceOrderId AS serviceOrderId,
		serviceDate AS scheduledDate,
		equipmentType AS equipmentType,
		customer AS customer,
		serialNumber AS serialNumber,
		responsible AS responsible,
		asignee AS asignee,
		additionalEmployees AS additionalEmployees
	FROM blackstarDb.serviceOrder s
		INNER JOIN blackstarDb.policy p ON s.policyId = p.policyId
		INNER JOIN blackstarDb.equipmentType et ON et.equipmentTypeId = p.equipmentTypeId
	WHERE serviceStatus = 'P'
		AND serviceDate >= CURRENT_DATE()
	ORDER BY serviceDate DESC;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetDomainEmployees
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetDomainEmployees$$
CREATE PROCEDURE blackstarDb.GetDomainEmployees()
BEGIN

	SELECT DISTINCT email AS email, name AS name
	FROM blackstarUser
	ORDER BY name;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUserData
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserData$$
CREATE PROCEDURE blackstarDb.GetUserData(pEmail VARCHAR(100))
BEGIN

	SELECT u.email AS userEmail, u.name AS userName, g.name AS groupName
	FROM blackstarUser_userGroup ug
		INNER JOIN blackstarUser u ON u.blackstarUserId = ug.blackstarUserId
		LEFT OUTER JOIN userGroup g ON g.userGroupId = ug.userGroupId
	WHERE u.email = pEmail;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CreateUserGroup
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CreateUserGroup$$
CREATE PROCEDURE blackstarDb.CreateUserGroup(pGroupId VARCHAR(100), pGroupName VARCHAR(100), pUserEmail VARCHAR(100))
BEGIN

		-- Crear el grupo si no existe
		INSERT INTO blackstarDb.userGroup(externalId, name)
		SELECT a.id, a.name
		FROM (
			SELECT pGroupId AS id, pGroupName AS name
		) a
			LEFT OUTER JOIN blackstarDb.userGroup u ON a.id = u.externalId
		WHERE u.userGroupId IS NULL;
		
		-- Crear la relacion con usuario
		INSERT INTO blackstarUser_userGroup(blackstarUserId, userGroupId)
		SELECT a.blackstarUserId, a.userGroupId
		FROM (
        SELECT
			(SELECT blackstarUserId	FROM blackstarDb.blackstarUser WHERE email = pUserEmail) AS blackstarUserId,
			(SELECT userGroupId FROM blackstarDb.userGroup WHERE externalId = pGroupId) as userGroupId
		) a
			LEFT OUTER JOIN blackstarDb.blackstarUser_userGroup ug ON a.blackstarUserId = ug.blackstarUserId and a.userGroupId = ug.userGroupId
		WHERE ug.blackstarUser_userGroupId IS NULL;
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertUser
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertUser$$
CREATE PROCEDURE blackstarDb.UpsertUser(pEmail VARCHAR(100), pName VARCHAR(100))
BEGIN

	INSERT INTO blackstarDb.blackstarUser(email, name)
	SELECT a.email, a.name
	FROM (
		SELECT pEmail AS email, pName AS name
	) a
		LEFT OUTER JOIN blackstarDb.blackstarUser u ON a.email = u.email
	WHERE u.email IS NULL;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUnassignedTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUnassignedTickets$$
CREATE PROCEDURE blackstarDb.GetUnassignedTickets ()
BEGIN

	SELECT 
		tk.ticketId AS DT_RowId,
		tk.ticketNumber AS ticketNumber,
		tk.created AS created,
		p.contactName AS contactName,
		p.serialNumber AS serialNumber,
		p.customer AS customer,
		et.equipmenttype AS equipmentType,
		p.responseTimeHR AS responseTimeHR,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		tk.ticketNumber AS Asignar
	FROM ticket tk 
		INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		INNER JOIN policy p ON tk.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmenttypeId = et.equipmenttypeId
		INNER JOIN office of on p.officeId = of.officeId
	WHERE IFNULL(employee, '') = ''
		AND closed IS NULL;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAllTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllTickets$$
CREATE PROCEDURE blackstarDb.GetAllTickets ()
BEGIN

	SELECT 
		tk.ticketId AS DT_RowId,
		tk.ticketNumber AS ticketNumber,
		tk.created AS created,
		p.contactName AS contactName,
		p.serialNumber AS serialNumber,
		p.customer AS customer,
		et.equipmenttype AS equipmentType,
		p.responseTimeHR AS responseTimeHR,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		IFNULL(bu.name, '') AS asignee,
		tk.ticketNumber AS asignar
	FROM ticket tk 
		INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		INNER JOIN policy p ON tk.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmenttypeId = et.equipmenttypeId
		INNER JOIN office of on p.officeId = of.officeId
		LEFT OUTER JOIN blackstarUser bu ON bu.email = tk.asignee
	WHERE tk.created > '01-01' + YEAR(CURRENT_DATE())
    ORDER BY tk.created DESC;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrders
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrders$$
CREATE PROCEDURE blackstarDb.GetServiceOrders(IN status VARCHAR(20))
BEGIN

	SELECT 
		so.ServiceOrderId AS DT_RowId,
		so.serviceOrderNumber AS serviceOrderNumber,
		'' AS placeHolder,
		IFNULL(t.ticketNumber, '') AS ticketNumber,
		st.serviceType AS serviceType,
		DATE(so.created) AS created,
		p.customer AS customer,
		et.equipmentType AS equipmentType,
		p.project AS project,
		of.officeName AS officeName,
		p.brand AS brand,
		p.serialNumber AS serialNumber,
		ss.serviceStatus AS serviceStatus
	FROM serviceOrder so 
		INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
		INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
		INNER JOIN policy p ON so.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmenttypeId = et.equipmenttypeId
		INNER JOIN office of on p.officeId = of.officeId
     LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
	WHERE ss.serviceStatus = status
	ORDER BY serviceOrderNumber ;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetTicketsByStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetTicketsByStatus$$
CREATE PROCEDURE blackstarDb.GetTicketsByStatus (IN status VARCHAR(20))
BEGIN

	SELECT 
		tk.ticketId AS DT_RowId,
		tk.ticketNumber AS ticketNumber,
		tk.created AS created,
		p.contactName AS contactName,
		p.serialNumber AS serialNumber,
		p.customer AS customer,
		et.equipmenttype AS equipmentType,
		tk.solutionTimeDeviationHr AS solutionTimeDeviationHr,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		'Crear OS' AS OS 
	FROM ticket tk 
		INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		INNER JOIN policy p ON tk.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmenttypeId = et.equipmenttypeId
		INNER JOIN office of on p.officeId = of.officeId
	WHERE ts.ticketStatus = status;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEquipmentCollectionByCustomer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentCollectionByCustomer$$
CREATE PROCEDURE blackstarDb.GetEquipmentCollectionByCustomer (IN pCustomer VARCHAR(100))
BEGIN

	SELECT serialNumber, brand, model 
	FROM blackstarDb.policy
	WHERE customer = pCustomer
		AND endDate > CURRENT_DATE()
	ORDER BY serialNumber;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.UpdateTicketStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpdateTicketStatus$$
CREATE PROCEDURE blackstarDb.UpdateTicketStatus ()
BEGIN

	-- ACTUALIZACION ESTATUS DEL TICKET
	-- ABIERTOS
	UPDATE blackstarDb.ticket t
		INNER JOIN policy p on t.policyId = p.policyId
	SET
		ticketStatusId = 'A'
	WHERE closed IS NULL
		AND TIMESTAMPDIFF(HOUR, t.created, CURRENT_DATE()) <= p.solutionTimeHR;
			
	-- RETRASADOS
	UPDATE blackstarDb.ticket t
		INNER JOIN policy p on t.policyId = p.policyId
	SET
		ticketStatusId = 'R'
	WHERE closed IS NULL
		AND TIMESTAMPDIFF(HOUR, t.created, CURRENT_DATE()) > p.solutionTimeHR;

	-- CERRADOS
	UPDATE blackstarDb.ticket SET
		ticketStatusId = 'C'
	WHERE closed IS NOT NULL
			AND solutionTimeDeviationHr <= 0;
			
	-- CERRADOS FUERA DE TIEMPO
	UPDATE blackstarDb.ticket SET
		ticketStatusId = 'F'
	WHERE closed IS NOT NULL
		AND solutionTimeDeviationHr > 0;
		
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AssignTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AssignTicket$$
CREATE PROCEDURE blackstarDb.AssignTicket (pTicketId INTEGER, pEmployee VARCHAR(100), usr VARCHAR(100), proc VARCHAR(100))
BEGIN

	UPDATE ticket SET
		employee = pEmployee,
		asignee = pEmployee,
		modified = CURRENT_DATE(),
		modifiedBy = proc,
		modifiedByUsr = usr
	WHERE ticketId = pTicketId;
	
END$$

-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;

-- -----------------------------------------------------------------------------
-- File:	blackstarDbTransfer_LoadTransferData.sql   
-- Name:	blackstarDbTransfer_LoadTransferData
-- Desc:	Transfiere los datos de la BD temporal a la BD de produccion
-- Auth:	Sergio A Gomez
-- Date:	29/09/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    29/09/2013  SAG  	Version inicial: Transfiere los datos de blackstarTransferDb a blackstarDb
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
  -- LLENAR CATALOGO DE POLIZAS
	INSERT INTO blackstarDb.policy(
		officeId,
		policyTypeId,
		customerContract,
		customer,
		finalUser,
		project,
		cst,
		equipmentTypeId,
		brand,
		model,
		serialNumber,
		capacity,
		equipmentAddress,
		equipmentLocation,
		contactName,
		contactPhone,
		contactEmail,
		startDate,
		endDate,
		visitsPerYear,
		responseTimeHR,
		solutionTimeHR,
		penalty,
		service,
		includesParts,
		exceptionParts,
		serviceCenterId,
		observations,
		created,
		createdBy,
		crratedByUsr
	)
	SELECT o.officeId, policyType, customerContract, customer, finalUser, project, cst, equipmentTypeId, brand, model, 
			serialNumber, capacity, equipmentAddress, equipmentLocation, contact, contactPhone, contactEmail, startDate, endDate, visitsPerYear, 
			responseTimeHR, solutionTimeHR, penalty, service, includesParts, exceptionParts, serviceCenterId, observations,
			CURRENT_DATE(), 'PolicyTransfer', 'sergio.aga'
	FROM blackstarDbTransfer.policy p
		INNER JOIN blackstarDb.office o ON p.office = o.officeName
		INNER JOIN blackstarDb.serviceCenter s ON s.serviceCenter = p.serviceCenter
	WHERE p.serialNumber NOT IN (SELECT DISTINCT serialNumber FROM blackstarDb.policy);
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
	-- LLENAR BASE DE DATOS DE TICKETS
	INSERT INTO blackstarDb.ticket(
		policyId,
		ticketNumber,
		user,
		observations,
		phoneResolved,
		arrival,
		employee,
		closed,
		created,
		createdBy,
		createdByUsr
	)
	SELECT p.policyId, tt.ticketNumber, tt.user, tt.observations, phoneResolved, tt.arrival, tt.employee, tt.closed, tt.created, 'TicketTransfer', 'sergio.aga'
	FROM blackstarDbTransfer.ticket tt
		INNER JOIN blackstarDbTransfer.policy pt ON tt.policyId = pt.policyId	
		INNER JOIN blackstarDb.policy p ON p.serialNumber = pt.serialNumber AND pt.serialNumber != 'NA'
	WHERE tt.ticketNumber NOT IN (SELECT ticketNumber FROM blackstarDb.ticket);
	
	-- ACTUALIZAR TIEMPOS DE RESPUESTA
	UPDATE blackstarDb.ticket SET 
		realResponseTime =  TIMESTAMPDIFF(HOUR, created, IFNULL(arrival, CURRENT_DATE()));
		
	-- ACTUALIZAR DESVIACIONES DE TIEMPO DE RESPUESTA
	UPDATE blackstarDb.ticket t 
		INNER JOIN blackstarDb.policy p on p.policyId = t.policyId
	SET 
		responseTimeDeviationHr = CASE WHEN(realResponseTime < responseTimeHR) THEN 0 ELSE (realResponseTime - responseTimeHR) END;

	-- ACTUALIZAR TIEMPOS DE SOLUCION
	UPDATE blackstarDb.ticket SET 
		solutionTime =  CASE WHEN (closed IS NULL) THEN NULL ELSE (TIMESTAMPDIFF(HOUR, created, closed)) END;
		
	-- ACTUALIZAR DESVIACIONES DE TIEMPO DE SOLUCION
	UPDATE blackstarDb.ticket t 
		INNER JOIN blackstarDb.policy p on p.policyId = t.policyId
	SET 
		solutionTimeDeviationHr = CASE WHEN(solutionTime < solutionTimeHR) THEN 0 ELSE (solutionTime - solutionTimeHR) END;
		
	-- CAMBIAR OBSERVATIONS POR FOLLOW UPS
	INSERT INTO blackstarDb.followUp(
		ticketId,
		asignee,
		followup,
		created,
		createdBy,
		createdByUsr
	)
	SELECT ticketId, 'marlem.samano@gposac.com.mx', followUp, CURRENT_DATE(), 'TicketTransfer', 'sergio.aga'
	FROM blackstarDbTransfer.ticket
	WHERE followUp IS NOT NULL;
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
	-- INSERTAR LAS ORDENES DE SERVICIO
	INSERT INTO blackstarDb.serviceOrder(
		serviceOrderNumber,
		serviceTypeId,
		ticketId,
		policyId,
		serviceUnit,
		serviceDate,
		responsible,
		receivedBy,
		serviceComments,
		closed,
		consultant,
		created,
		createdBy,
		createdByUsr
	)
	SELECT ot.serviceNumber, ot.serviceTypeId, t.ticketId, p.policyId, ot.serviceUnit, ot.serviceDate, ot.responsible, ot.receivedBy, 
		ot.serviceComments, ot.closed, ot.consultant, CURRENT_DATE(), 'ServiceOrderTransfer', 'sergio.aga'
	FROM blackstarDbTransfer.serviceTx ot
		LEFT OUTER JOIN blackstarDb.ticket t ON t.ticketNumber = ot.ticketNumber
		LEFT OUTER JOIN blackstarDb.policy p ON p.serialNumber = ot.serialNumber AND ot.serialNumber != 'NA'
	WHERE ot.serviceNumber NOT IN (SELECT serviceOrderNumber FROM blackstarDb.serviceOrder);
		
	-- ACTUALIZACION DEL STATUS
	UPDATE blackstarDb.serviceOrder SET
		serviceStatusId = CASE WHEN (closed IS NULL) THEN 'E' ELSE 'C' END;
		
	-- ACTUALIZACION DEL SERVICE ID DE CIERRE DEL TICKET
	UPDATE blackstarDb.ticket t
		INNER JOIN blackstarDbTransfer.ticket tt ON t.ticketNumber = tt.ticketNumber
		INNER JOIN blackstarDb.serviceOrder so ON tt.serviceOrderNumber = so.serviceOrderNumber	
	SET
		t.serviceOrderId = so.serviceOrderId;	
	
	-- ACTUALIZACION DEL ESTADO DE LOS TICKETS
	use blackstarDb;
	CALL UpdateTicketStatus();
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
	-- ELIMINACION DE COMILLAS QUE PROVOCAN PROBLEMAS AL CONVERTIR A JSON
	UPDATE blackstarDb.policy SET	
		equipmentAddress = REPLACE( equipmentAddress,'"','');
		
	UPDATE blackstarDb.policy SET	
		equipmentLocation = REPLACE( equipmentLocation,'"','');
		
	UPDATE blackstarDb.policy SET	
		penalty = REPLACE( penalty,'"','');
		
	UPDATE blackstarDb.policy SET	
		observations = REPLACE( observations,'"','');
		
	UPDATE blackstarDb.serviceOrder SET	
		serviceComments = REPLACE( serviceComments,'"','');
		
	UPDATE blackstarDb.ticket SET	
		observations = REPLACE( observations,'"','');

	UPDATE blackstarDb.followUp SET	
		followUp = REPLACE( followUp,'"','');
		
	-- ELIMINACION DE RETORNOS DE CARRO QUE PROVOCAN PROBLEMAS AL CONVERTIR A JSON
	UPDATE blackstarDb.policy SET	
		equipmentAddress = REPLACE( equipmentAddress,'\n','');
		
	UPDATE blackstarDb.policy SET	
		equipmentLocation = REPLACE( equipmentLocation,'\n','');
		
	UPDATE blackstarDb.policy SET	
		penalty = REPLACE( penalty,'\n','');
		
	UPDATE blackstarDb.policy SET	
		observations = REPLACE( observations,'\n','');
		
	UPDATE blackstarDb.serviceOrder SET	
		serviceComments = REPLACE( serviceComments,'\n','');
		
	UPDATE blackstarDb.ticket SET	
		observations = REPLACE( observations,'\n','');

	UPDATE blackstarDb.followUp SET	
		followUp = REPLACE( followUp,'\n','');
-- -----------------------------------------------------------------------------


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


-- -----------------------------------------------------------------------------
-- File:	blackstarManage_StoredProcedures.sql   
-- Name:	blackstarManage_StoredProcedures
-- Desc:	Crea o actualiza los Stored procedures administrativos de la aplicacion
-- Auth:	Sergio A Gomez
-- Date:	03/10/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    03/10/2013	SAG		Se Integran los SP iniciales:
--								blackstarManage.WriteLog
-- -----------------------------------------------------------------------------
use blackstarManage;


DELIMITER $$

-- -----------------------------------------------------------------------------
	-- blackstarManage.WriteLog
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarManage.WriteLog$$
CREATE PROCEDURE blackstarManage.WriteLog (
	pLevel		VARCHAR(20),
	pError		VARCHAR(400),
	pSender		TEXT,
	pStackTrace	TEXT
)
BEGIN

	INSERT INTO blackstarManage.errorLog(
		severity,		
		created, 	
		error,		
		sender,		
		stackTrace
	)
	SELECT 
		pLevel, CURRENT_DATE(), pError, pSender, pStackTrace;
	
END$$


-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;

-- -----------------------------------------------------------------------------
-- File:	blackstarDb_startupData.sql
-- Name:	blackstarDb_startupData
-- Desc:	Hace una carga inicial de usuarios para poder operar el sistema
-- Auth:	Sergio A Gomez
-- Date:	22/10/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    22/10/2013  SAG  	Version inicial. Usuarios basicos de GPO Sac
-- ---------------------------------------------------------------------------
use blackstarDb;

Call UpsertUser('alberto.lopez.gomez@gposac.com.mx','Alberto Lopez Gomez');
Call UpsertUser('alejandra.diaz@gposac.com.mx','Alejandra Diaz');
Call UpsertUser('alejandro.monroy@gposac.com.mx','Alejandro Monroy');
Call UpsertUser('marlem.samano@gposac.com.mx','Marlem Samano');
Call UpsertUser('armando.perez.pinto@gposac.com.mx','Armando Perez Pinto');
Call UpsertUser('gonzalo.ramirez@gposac.com.mx','Gonzalo Ramirez');
Call UpsertUser('jose.alberto.jonguitud.gallardo@gposac.com.mx','Jose Alberto Jonguitud Gallardo');
Call UpsertUser('marlem.samano@gposac.com.mx','Marlem Samano');
Call UpsertUser('martin.vazquez@gposac.com.mx','Martin Vazquez');
Call UpsertUser('reynaldo.garcia@gposac.com.mx','Reynaldo Garcia');
Call UpsertUser('sergio.gallegos@gposac.com.mx','Sergio  Gallegos');
Call UpsertUser('angeles.avila@gposac.com.mx','Angeles Avila');
Call UpsertUser('sergio.aga@gmail.com','Sergio A. Gomez');
Call UpsertUser('portal-servicios@gposac.com.mx','Portal Servicios');

Call CreateUserGroup('sysServicio','Implementacion y Servicio','alberto.lopez.gomez@gposac.com.mx');
Call CreateUserGroup('sysCallCenter','Call Center','alejandra.diaz@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','alejandro.monroy@gposac.com.mx');
Call CreateUserGroup('sysCallCenter','Call Center','marlem.samano@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','armando.perez.pinto@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','gonzalo.ramirez@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','jose.alberto.jonguitud.gallardo@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','martin.vazquez@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','reynaldo.garcia@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','sergio.gallegos@gposac.com.mx');
Call CreateUserGroup('sysCoordinador','Coordinador','angeles.avila@gposac.com.mx');
Call CreateUserGroup('sysCallCenter','Call Center','sergio.aga@gmail.com');
Call CreateUserGroup('sysCallCenter','Call Center','portal-servicios@gposac.com.mx');





