-- -----------------------------------------------------------------------------
-- File:	createDatabase.sql    
-- Name:	createDatabase
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

-- -----------------------------------------------------------------------------

-- Seccion autogenerada por EA

-- -----------------------------------------------------------------------------

USE blackstarDb;

SET FOREIGN_KEY_CHECKS=0;


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
	createdBy NVARCHAR(8) NULL,
	createdByUsr NVARCHAR(50) NULL,
	modified DATETIME NULL,
	modifiedBy NVARCHAR(50) NULL,
	modifiedByUsr NVARCHAR(50) NULL,
	PRIMARY KEY (followUpId),
	UNIQUE UQ_followUp_followUpId(followUpId),
	KEY (serviceOrderId),
	KEY (serviceOrderId)
) ENGINE=INNODB;


CREATE TABLE office
(
	officeId CHAR(1) NOT NULL,
	officeName NVARCHAR(50) NULL,
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
	effectiveDate DATETIME,
	created DATETIME NULL,
	createdBy NVARCHAR(50) NULL,
	createdByUsr NVARCHAR(50) NULL,
	modified DATETIME NULL,
	modifiedBy NVARCHAR(50) NULL,
	modifiedByUsr NVARCHAR(50) NULL,
	signCreated NVARCHAR(250) NULL,
	signReceivedBy NVARCHAR(250) NULL,
	receivedByPosition NVARCHAR(50) NULL,
	PRIMARY KEY (serviceOrderId),
	UNIQUE UQ_serviceOrder_serviceOrderId(serviceOrderId),
	KEY (serviceTypeId),
	KEY (ticketId),
	KEY (serviceTypeId),
	KEY (serviceStatusId)
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
	serviceId INTEGER NULL,
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
	KEY (serviceId),
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
	
ALTER TABLE serviceOrder ADD CONSTRAINT FK_serviceOrder_serviceStatus 
	FOREIGN KEY (serviceStatusId) REFERENCES serviceStatus (serviceStatusId);

-- -----------------------------------------------------------------------------

-- FIN - Seccion autogenerada por EA

-- -----------------------------------------------------------------------------



-- -----------------------------------------------------------------------------

-- Seccion de Administracion

-- -----------------------------------------------------------------------------

use blackstarManage;

CREATE TABLE blackstarManage.ErrorLog
(
	errorLogId INTEGER NOT NULL AUTO_INCREMENT,
	severity VARCHAR(20),
	created DATETIME,
	error VARCHAR(400),
	sender TEXT,
	stackTrace TEXT,
	PRIMARY KEY (errorLogId)
)ENGINE=INNODB;

-- -----------------------------------------------------------------------------

-- FIN Seccion de Administracion

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
