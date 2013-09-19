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
) ;


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
) ;


CREATE TABLE office
(
	officeId CHAR(1) NOT NULL,
	officeName NVARCHAR(50) NULL,
	PRIMARY KEY (officeId),
	UNIQUE UQ_office_officeId(officeId)
) ;


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
	brand VARCHAR(50) NULL,
	model VARCHAR(50) NULL,
	serialNumber VARCHAR(100) NULL,
	capacity NVARCHAR(50) NULL,
	equipmentAddress TEXT NULL,
	equipmentLocation TEXT NULL,
	policyContactId INTEGER NULL,
	startDate DATE NULL,
	endDate DATE NULL,
	visitsPerYear INTEGER NULL,
	responseTimeHR TINYINT NULL,
	solutionTimeHR SMALLINT NULL,
	penalty TEXT NULL,
	service NVARCHAR(50) NULL,
	includesParts TINYINT NOT NULL,
	exceptionParts NVARCHAR(50) NULL,
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
	KEY (policyContactId),
	KEY (policyTypeId),
	KEY (serviceCenterId),
	KEY (policyContactId),
	KEY (customer),
	KEY (officeId),
	KEY (policyTypeId),
	INDEX IX_serialNumber (serialNumber ASC)
) ;


CREATE TABLE policyContact
(
	policyContactId INTEGER NOT NULL,
	name NVARCHAR(50) NOT NULL,
	phone NVARCHAR(20) NULL,
	email NVARCHAR(10) NULL,
	created DATETIME NULL,
	createdBy NVARCHAR(50) NULL,
	createdByUsr NVARCHAR(50) NULL,
	modified DATETIME NULL,
	modifiedBy NVARCHAR(50) NULL,
	modifiedByUsr NVARCHAR(50) NULL,
	PRIMARY KEY (policyContactId),
	UNIQUE UQ_policyContact_policyContactId(policyContactId)
) ;


CREATE TABLE policyType
(
	policyTypeId CHAR(1) NOT NULL,
	policyType NVARCHAR(50) NOT NULL,
	PRIMARY KEY (policyTypeId),
	UNIQUE UQ_policyType_policyTypeId(policyTypeId)
) ;


CREATE TABLE serviceCenter
(
	serviceCenterId CHAR(1) NOT NULL,
	serviceCenter VARCHAR(100) NOT NULL,
	PRIMARY KEY (serviceCenterId),
	UNIQUE UQ_serviceCenter_serviceCenterId(serviceCenterId)
) ;


CREATE TABLE serviceOrder
(
	serviceOrderId INTEGER NOT NULL AUTO_INCREMENT,
	serviceTypeId CHAR(1) NULL,
	ticketId INTEGER NULL,
	policyId SMALLINT NULL,
	serviceUnit NVARCHAR(10) NULL,
	serviceDate DATETIME NULL,
	responsible NVARCHAR(100) NULL,
	receivedBy NVARCHAR(100) NULL,
	serviceComments TEXT NULL,
	statusId TINYINT NULL,
	closed DATETIME NULL,
	consultant NVARCHAR(100) NULL,
	coordinator NVARCHAR(100) NULL,
	asignee NVARCHAR(50) NULL,
	created DATETIME NULL,
	createdBy NVARCHAR(50) NULL,
	createdByUsr NVARCHAR(50) NULL,
	modified DATETIME NULL,
	modifiedBy NVARCHAR(50) NULL,
	modifiedByUsr NVARCHAR(50) NULL,
	PRIMARY KEY (serviceOrderId),
	UNIQUE UQ_serviceOrder_serviceOrderId(serviceOrderId),
	KEY (serviceTypeId),
	KEY (ticketId),
	KEY (serviceTypeId),
	KEY (statusId)
) ;


CREATE TABLE serviceType
(
	serviceTypeId CHAR(1) NOT NULL,
	serviceType NVARCHAR(50) NULL,
	PRIMARY KEY (serviceTypeId),
	UNIQUE UQ_serviceType_serviceTypeId(serviceTypeId)
) ;


CREATE TABLE ticket
(
	ticketId INTEGER ZEROFILL NOT NULL AUTO_INCREMENT,
	policyId INTEGER NULL,
	serviceId SMALLINT NULL,
	user NVARCHAR(8) NULL,
	observations TEXT NULL,
	ticketStatusId CHAR(1) NULL,
	realResponseTime SMALLINT NULL,
	arrival DATETIME NULL,
	employee BIGINT NULL,
	asignee NVARCHAR(8) NULL,
	closed DATETIME NULL,
	solutionTime DATETIME NULL,
	solutionTimeDeviationHr SMALLINT NULL,
	created DATETIME NULL,
	createdBy NVARCHAR(8) NULL,
	createdByUsr NVARCHAR(50) NULL,
	modified DATETIME NULL,
	modifiedBy NVARCHAR(8) NULL,
	modifiedByUsr NVARCHAR(50) NULL,
	PRIMARY KEY (ticketId),
	UNIQUE UQ_ticket_ticketId(ticketId),
	KEY (policyId),
	KEY (ticketStatusId),
	KEY (serviceId),
	KEY (ticketStatusId)
) ;


CREATE TABLE ticketStatus
(
	ticketStatusId CHAR(1) NOT NULL,
	ticketStatus NVARCHAR(50) NULL,
	PRIMARY KEY (ticketStatusId),
	UNIQUE UQ_ticketStatus_ticketStatusId(ticketStatusId)
) ;



SET FOREIGN_KEY_CHECKS=1;


ALTER TABLE followUp ADD CONSTRAINT FK_followUp_serviceOrder 
	FOREIGN KEY (serviceOrderId) REFERENCES serviceOrder (serviceOrderId);

ALTER TABLE policy ADD CONSTRAINT FK_policy_equipmentType 
	FOREIGN KEY (equipmentTypeId) REFERENCES equipmentType (equipmentTypeId);

ALTER TABLE policy ADD CONSTRAINT FK_policy_office 
	FOREIGN KEY (officeId) REFERENCES office (officeId);

ALTER TABLE policy ADD CONSTRAINT FK_policy_policyContact 
	FOREIGN KEY (policyContactId) REFERENCES policyContact (policyContactId);

ALTER TABLE policy ADD CONSTRAINT FK_policy_policyType 
	FOREIGN KEY (policyTypeId) REFERENCES policyType (policyTypeId);

ALTER TABLE policy ADD CONSTRAINT FK_policy_serviceCenter 
	FOREIGN KEY (serviceCenterId) REFERENCES serviceCenter (serviceCenterId);

ALTER TABLE serviceOrder ADD CONSTRAINT FK_serviceOrder_serviceType 
	FOREIGN KEY (serviceTypeId) REFERENCES serviceType (serviceTypeId);

ALTER TABLE serviceOrder ADD CONSTRAINT FK_serviceOrder_ticket 
	FOREIGN KEY (ticketId) REFERENCES ticket (ticketId);

ALTER TABLE ticket ADD CONSTRAINT FK_ticket_policy 
	FOREIGN KEY (policyId) REFERENCES policy (policyId);

ALTER TABLE ticket ADD CONSTRAINT FK_ticket_ticketStatus 
	FOREIGN KEY (ticketStatusId) REFERENCES ticketStatus (ticketStatusId);

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

INSERT INTO `blackstarDb`.`servicetype` (`serviceTypeId`, `serviceType`) VALUES ( 'C', 'CORRECTIVO' ); 
INSERT INTO `blackstarDb`.`servicetype` (`serviceTypeId`, `serviceType`) VALUES ( 'I', 'INSPECCION' ); 
INSERT INTO `blackstarDb`.`servicetype` (`serviceTypeId`, `serviceType`) VALUES ( 'T', 'INSTALACION' ); 
INSERT INTO `blackstarDb`.`servicetype` (`serviceTypeId`, `serviceType`) VALUES ( 'A', 'INSTALACION Y ARRANQUE' ); 
INSERT INTO `blackstarDb`.`servicetype` (`serviceTypeId`, `serviceType`) VALUES ( 'L', 'LEVANTAMIENTO' ); 
INSERT INTO `blackstarDb`.`servicetype` (`serviceTypeId`, `serviceType`) VALUES ( 'P', 'PREVENTIVO' ); 
INSERT INTO `blackstarDb`.`servicetype` (`serviceTypeId`, `serviceType`) VALUES ( 'R', 'REVISION' ); 

select * from equipmentType;
select * from office;
select * from serviceCenter;
select * from policyType;
select * from ticketStatus;
select * from serviceType;
-- -----------------------------------------------------------------------------

-- FIN - Seccion de Datos

-- -----------------------------------------------------------------------------
