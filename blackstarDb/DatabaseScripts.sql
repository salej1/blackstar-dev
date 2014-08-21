-- -----------------------------------------------------------------------------
-- File:	blackstarDb_ChangeSchema.sql    
-- Name:	blackstarDb_ChangeSchema
-- Desc:	Cambia el esquema de la bd
-- Auth:	Sergio A Gomez
-- Date:	11/11/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- ---------------------------------------------------------------------------
-- 15	05/05/2014	SAG 	Se agregan serviceContact & serviceContactEmail a scheduledService
-- ---------------------------------------------------------------------------
-- 16	28/04/2014	SAG 	Se incrementa responsible en serviceOrder
-- ---------------------------------------------------------------------------
-- 17	14/05/2014	SAG 	Se agrega unique(serviceOrderNumber) a serviceOrder
-- ---------------------------------------------------------------------------
-- 18	19/05/2014	SAG 	Se agrega serviceDateEnd a serviceOrder
-- ---------------------------------------------------------------------------
-- 19	04/06/2014	SAG 	Se agrega hasPdf a serviceOrder
-- ---------------------------------------------------------------------------
-- 20	15/06/2014	SAG 	Se agrega surveyScore a serviceOrder
--							Se incrementa capacidad de namePerson, email, phone en surveyService		
-- ---------------------------------------------------------------------------
-- 21 	23/06/2014 	SAG 	Se agrega transferOS a openCustomer - auxiliar para transferencia de OpenCustomer
--							Se aumenta taman;o de openCustomer.serialNumber
-- ---------------------------------------------------------------------------
-- 22	05/07/2014	SAG 	Se agrega dueDate a issue
-- ---------------------------------------------------------------------------
-- 23 	08/07/2014 	SAG 	Se agrega bossId a blackstarUser
-- ---------------------------------------------------------------------------
-- 24 	24/04/2014	SAG 	Se agrega tabla policyEquipmentUser
-- ---------------------------------------------------------------------------
-- 25 	31/07/2014	SAG 	Se incremente tamaño de manufacturedDateSeria en upsServiceBatteryBank
-- ---------------------------------------------------------------------------
-- 26 	18/08/2014	SAG 	Se cambian campos numericos de OS por alfa-numericos
-- ---------------------------------------------------------------------------
-- 27 	20/08/2014	SAG 	Se aumenta el tamaño de todos los campos alfanumericos de OS
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.upgradeSchema$$
CREATE PROCEDURE blackstarDb.upgradeSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

-- CAMBIANDO NUMERICOS POR ALFA-NUMERICOS
IF(SELECT character_maximum_length FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'aaService' AND column_name = 'observations') < 1000 THEN
	-- aaService
	ALTER TABLE aaService MODIFY evaDescription VARCHAR(2000) ;
	ALTER TABLE aaService MODIFY evaValTemp VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaValHum VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaSetpointTemp VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaSetpointHum VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectrurePreasureHigh VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectrurePreasureLow VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureTemp VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureOilColor VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureOilLevel VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCoolerColor VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCoolerLevel VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaCheckOperatation VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaCheckNoise VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaCheckIsolated VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureVoltageGroud VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureVoltagePhases VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureVoltageControl VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCurrentMotor1 VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCurrentMotor2 VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCurrentMotor3 VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCurrentCompressor1 VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCurrentCompressor2 VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCurrentCompressor3 VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCurrentHumidifier1 VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCurrentHumidifier2 VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCurrentHumidifier3 VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCurrentHeater1 VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCurrentHeater2 VARCHAR(200) ;
	ALTER TABLE aaService MODIFY evaLectureCurrentHeater3 VARCHAR(200) ;
	ALTER TABLE aaService MODIFY condReview VARCHAR(200) ;
	ALTER TABLE aaService MODIFY condLectureVoltageGroud VARCHAR(200) ;
	ALTER TABLE aaService MODIFY condLectureVoltagePhases VARCHAR(200) ;
	ALTER TABLE aaService MODIFY condLectureVoltageControl VARCHAR(200) ;
	ALTER TABLE aaService MODIFY condLectureMotorCurrent VARCHAR(200) ;
	ALTER TABLE aaService MODIFY condReviewThermostat VARCHAR(200) ;
	ALTER TABLE aaService MODIFY condModel VARCHAR(200) ;
	ALTER TABLE aaService MODIFY condSerialNumber VARCHAR(200) ;
	ALTER TABLE aaService MODIFY condBrand VARCHAR(200) ;
	ALTER TABLE aaService MODIFY observations VARCHAR(2000);
	-- bbCellService;
	ALTER TABLE bbCellService MODIFY floatVoltage VARCHAR(200) ;
	ALTER TABLE bbCellService MODIFY chargeVoltage VARCHAR(200) ;
	-- bbService;
	ALTER TABLE bbService MODIFY plugCleanStatus VARCHAR(200) ;
	ALTER TABLE bbService MODIFY plugCleanComments VARCHAR(200) ;
	ALTER TABLE bbService MODIFY coverCleanStatus VARCHAR(200) ;
	ALTER TABLE bbService MODIFY coverCleanComments VARCHAR(200) ;
	ALTER TABLE bbService MODIFY capCleanStatus VARCHAR(200) ;
	ALTER TABLE bbService MODIFY capCleanComments VARCHAR(200) ;
	ALTER TABLE bbService MODIFY groundCleanStatus VARCHAR(200) ;
	ALTER TABLE bbService MODIFY groundCleanComments VARCHAR(200) ;
	ALTER TABLE bbService MODIFY rackCleanStatus VARCHAR(200) ;
	ALTER TABLE bbService MODIFY rackCleanComments VARCHAR(200) ;
	ALTER TABLE bbService MODIFY serialNoDateManufact VARCHAR(200) ;
	ALTER TABLE bbService MODIFY batteryTemperature VARCHAR(200) ;
	ALTER TABLE bbService MODIFY voltageBus VARCHAR(200) ;
	ALTER TABLE bbService MODIFY temperature VARCHAR(200) ;
	-- epService;
	ALTER TABLE epService MODIFY brandPE VARCHAR(200) ;
	ALTER TABLE epService MODIFY modelPE VARCHAR(200) ;
	ALTER TABLE epService MODIFY serialPE VARCHAR(200) ;
	ALTER TABLE epService MODIFY transferType VARCHAR(200) ;
	ALTER TABLE epService MODIFY modelTransfer VARCHAR(200) ;
	ALTER TABLE epService MODIFY modelControl VARCHAR(200) ;
	ALTER TABLE epService MODIFY modelRegVoltage VARCHAR(200) ;
	ALTER TABLE epService MODIFY modelRegVelocity VARCHAR(200) ;
	ALTER TABLE epService MODIFY modelCharger VARCHAR(200) ;
	ALTER TABLE epService MODIFY brandMotor VARCHAR(200) ;
	ALTER TABLE epService MODIFY modelMotor VARCHAR(200) ;
	ALTER TABLE epService MODIFY serialMotor VARCHAR(200) ;
	ALTER TABLE epService MODIFY cplMotor VARCHAR(200) ;
	ALTER TABLE epService MODIFY brandGenerator VARCHAR(200) ;
	ALTER TABLE epService MODIFY modelGenerator VARCHAR(200) ;
	ALTER TABLE epService MODIFY serialGenerator VARCHAR(200) ;
	ALTER TABLE epService MODIFY powerWattGenerator VARCHAR(200) ;
	ALTER TABLE epService MODIFY tensionGenerator VARCHAR(200) ;
	ALTER TABLE epService MODIFY tankCapacity VARCHAR(200) ;
	ALTER TABLE epService MODIFY pumpFuelModel VARCHAR(200) ;
	ALTER TABLE epService MODIFY brandGear VARCHAR(200) ;
	ALTER TABLE epService MODIFY brandBattery VARCHAR(200) ;
	ALTER TABLE epService MODIFY clockLecture VARCHAR(200) ;
	ALTER TABLE epService MODIFY observations VARCHAR(2000);
	-- epServiceDynamicTest;
	ALTER TABLE epServiceDynamicTest MODIFY vacuumFrequency VARCHAR(200) ;
	ALTER TABLE epServiceDynamicTest MODIFY chargeFrequency VARCHAR(200) ;
	ALTER TABLE epServiceDynamicTest MODIFY bootTryouts VARCHAR(200) ;
	ALTER TABLE epServiceDynamicTest MODIFY vacuumVoltage VARCHAR(200) ;
	ALTER TABLE epServiceDynamicTest MODIFY chargeVoltage VARCHAR(200) ;
	ALTER TABLE epServiceDynamicTest MODIFY qualitySmoke VARCHAR(200) ;
	ALTER TABLE epServiceDynamicTest MODIFY startTime VARCHAR(200) ;
	ALTER TABLE epServiceDynamicTest MODIFY transferTime VARCHAR(200) ;
	ALTER TABLE epServiceDynamicTest MODIFY stopTime VARCHAR(200) ;
	-- epServiceLectures;
	ALTER TABLE epServiceLectures MODIFY voltageABAN VARCHAR(200) ;
	ALTER TABLE epServiceLectures MODIFY voltageACCN VARCHAR(200) ;
	ALTER TABLE epServiceLectures MODIFY voltageBCBN VARCHAR(200) ;
	ALTER TABLE epServiceLectures MODIFY voltageNT VARCHAR(200) ;
	ALTER TABLE epServiceLectures MODIFY currentA VARCHAR(200) ;
	ALTER TABLE epServiceLectures MODIFY currentB VARCHAR(200) ;
	ALTER TABLE epServiceLectures MODIFY currentC VARCHAR(200) ;
	ALTER TABLE epServiceLectures MODIFY frequency VARCHAR(200) ;
	ALTER TABLE epServiceLectures MODIFY oilPreassure VARCHAR(200) ;
	ALTER TABLE epServiceLectures MODIFY temp VARCHAR(200) ;
	-- epServiceParams;
	ALTER TABLE epServiceParams MODIFY adjsutmentTherm VARCHAR(200) ;
	ALTER TABLE epServiceParams MODIFY current VARCHAR(200) ;
	ALTER TABLE epServiceParams MODIFY batteryCurrent VARCHAR(200) ;
	ALTER TABLE epServiceParams MODIFY clockStatus VARCHAR(200) ;
	ALTER TABLE epServiceParams MODIFY trasnferTypeProtection VARCHAR(200) ;
	ALTER TABLE epServiceParams MODIFY generatorTypeProtection VARCHAR(200) ;
	-- epServiceSurvey;
	ALTER TABLE epServiceSurvey MODIFY levelBattery VARCHAR(200) ;
	ALTER TABLE epServiceSurvey MODIFY batteryCap VARCHAR(200) ;
	ALTER TABLE epServiceSurvey MODIFY batterySulfate VARCHAR(200) ;
	ALTER TABLE epServiceSurvey MODIFY levelOil VARCHAR(200) ;
	ALTER TABLE epServiceSurvey MODIFY heatEngine VARCHAR(200) ;
	ALTER TABLE epServiceSurvey MODIFY hoseOil VARCHAR(200) ;
	ALTER TABLE epServiceSurvey MODIFY hoseWater VARCHAR(200) ;
	ALTER TABLE epServiceSurvey MODIFY tubeValve VARCHAR(200) ;
	ALTER TABLE epServiceSurvey MODIFY stripBlades VARCHAR(200) ;
	-- epServiceTestProtection;
	ALTER TABLE epServiceTestProtection MODIFY tempSensor VARCHAR(200) ;
	ALTER TABLE epServiceTestProtection MODIFY oilSensor VARCHAR(200) ;
	ALTER TABLE epServiceTestProtection MODIFY voltageSensor VARCHAR(200) ;
	ALTER TABLE epServiceTestProtection MODIFY overSpeedSensor VARCHAR(200) ;
	ALTER TABLE epServiceTestProtection MODIFY oilPreasureSensor VARCHAR(200) ;
	ALTER TABLE epServiceTestProtection MODIFY waterLevelSensor VARCHAR(200) ;
	-- epServiceTransferSwitch;
	ALTER TABLE epServiceTransferSwitch MODIFY mechanicalStatus VARCHAR(200) ;
	ALTER TABLE epServiceTransferSwitch MODIFY systemMotors VARCHAR(200) ;
	ALTER TABLE epServiceTransferSwitch MODIFY electricInterlock VARCHAR(200) ;
	ALTER TABLE epServiceTransferSwitch MODIFY mechanicalInterlock VARCHAR(200) ;
	ALTER TABLE epServiceTransferSwitch MODIFY capacityAmp VARCHAR(200) ;
	-- upsService;
	ALTER TABLE upsService MODIFY estatusEquipment VARCHAR(200) ;
	ALTER TABLE upsService MODIFY capacitorStatus VARCHAR(200) ;
	ALTER TABLE upsService MODIFY fanStatus VARCHAR(200) ;
	ALTER TABLE upsService MODIFY observations VARCHAR(2000) ;
	-- upsServiceBatteryBank;
	ALTER TABLE upsServiceBatteryBank MODIFY manufacturedDateSerial VARCHAR(2000) ;
	ALTER TABLE upsServiceBatteryBank MODIFY damageBatteries VARCHAR(200) ;
	ALTER TABLE upsServiceBatteryBank MODIFY other VARCHAR(200) ;
	ALTER TABLE upsServiceBatteryBank MODIFY temp VARCHAR(200) ;
	ALTER TABLE upsServiceBatteryBank MODIFY brandModel VARCHAR(200) ;
	ALTER TABLE upsServiceBatteryBank MODIFY batteryVoltage VARCHAR(200) ;
	-- upsServiceGeneralTest;
	ALTER TABLE upsServiceGeneralTest MODIFY trasferLine VARCHAR(200) ;
	ALTER TABLE upsServiceGeneralTest MODIFY transferEmergencyPlant VARCHAR(200) ;
	ALTER TABLE upsServiceGeneralTest MODIFY backupBatteries VARCHAR(200) ;
	ALTER TABLE upsServiceGeneralTest MODIFY verifyVoltage VARCHAR(200) ;
	-- upsServiceParams;
	ALTER TABLE upsServiceParams MODIFY inputVoltagePhase VARCHAR(200) ;
	ALTER TABLE upsServiceParams MODIFY inputVoltageNeutro VARCHAR(200) ;
	ALTER TABLE upsServiceParams MODIFY inputVoltageNeutroGround VARCHAR(200) ;
	ALTER TABLE upsServiceParams MODIFY percentCharge VARCHAR(200) ;
	ALTER TABLE upsServiceParams MODIFY outputVoltagePhase VARCHAR(200) ;
	ALTER TABLE upsServiceParams MODIFY outputVoltageNeutro VARCHAR(200) ;
	ALTER TABLE upsServiceParams MODIFY inOutFrecuency VARCHAR(200) ;
	ALTER TABLE upsServiceParams MODIFY busVoltage VARCHAR(200) ;

END IF;

-- INCREMENTANDO TAMAÑO DE manufacturedDateSerial EN upsService
ALTER TABLE upsServiceBatteryBank MODIFY manufacturedDateSerial VARCHAR(200);

-- AGREGANDO TABLA policyEquipmentUser - Asocia polizas con varios usuarios Cliente
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'policyEquipmentUser') = 0 THEN
		 CREATE TABLE blackstarDb.policyEquipmentUser(
			policyEquipmentUserId INT NOT NULL AUTO_INCREMENT,
			policyId INT NOT NULL,
			equipmentUserId VARCHAR(200),
			PRIMARY KEY (policyEquipmentUserId),
			CONSTRAINT policyEquipmentUser_policy FOREIGN KEY (policyId) REFERENCES policy(policyId),
			UNIQUE UQ_policyEquipmentUser_policyEquipmentUserId(policyEquipmentUserId)
		) ENGINE=INNODB;

		-- Eliminando columna equipmentUser de policy
		ALTER TABLE policy DROP COLUMN equipmentUser;
	END IF;

--	AGREGANDO bossId a blackstarUser
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'blackstarUser' AND COLUMN_NAME = 'bossId') = 0  THEN
		ALTER TABLE blackstarUser ADD bossId INTEGER;

		ALTER TABLE blackstarUser ADD CONSTRAINT FK_blackstarUser_blackstarUser
		FOREIGN KEY (bossId) REFERENCES blackstarUser(blackstarUserId);
	END If;

--	AGREGANDO dueDate a issue
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'issue' AND COLUMN_NAME = 'dueDate') = 0  THEN
		ALTER TABLE issue ADD dueDate DATETIME;
	END If;

--  AUMENTANDO CAPACIDAD DE openCustomer.serialNumber
	ALTER TABLE openCustomer MODIFY serialNumber VARCHAR(255);

--	AGREGANDO transferOS a openCustomer
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'openCustomer' AND COLUMN_NAME = 'transferSo') = 0  THEN
		ALTER TABLE openCustomer ADD transferSo VARCHAR(100);
	END If;

--	INCREMENTANDO CAPACIDAD DE namePerson, email, phone en surveyService
	ALTER TABLE surveyService MODIFY namePerson VARCHAR(255);
	ALTER TABLE surveyService MODIFY email VARCHAR(255);
	ALTER TABLE surveyService MODIFY phone VARCHAR(255);

-- 	AGREGANDO surveyScore A serviceOrder
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'serviceOrder' AND COLUMN_NAME = 'surveyScore') = 0  THEN
		ALTER TABLE serviceOrder ADD surveyScore INT NULL DEFAULT 0;
	END If;

	-- 	AGREGANDO hasPdf A serviceOrder
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'serviceOrder' AND COLUMN_NAME = 'hasPdf') = 0  THEN
		ALTER TABLE serviceOrder ADD hasPdf INT NULL DEFAULT 0;
	END If;

-- 	AGREGANDO serviceDateEnd A serviceOrder
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'serviceOrder' AND COLUMN_NAME = 'serviceEndDate') = 0  THEN
		ALTER TABLE serviceOrder ADD serviceEndDate DATETIME NULL;
	END If;

--	AGREGANDO UNIQUE(serviceOrderNumber) A serviceOrder
	ALTER TABLE serviceOrder ADD UNIQUE(serviceOrderNumber);
	
--	INCREMENTANDO TAMANO DE responsible EN serviceOrder
	ALTER TABLE serviceOrder MODIFY responsible VARCHAR(400);

--	AGREGANDO serviceContact & serviceContactEmail a scheduledService
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'scheduledService' AND COLUMN_NAME = 'serviceContact') = 0  THEN
		ALTER TABLE blackstarDb.scheduledService ADD serviceContact VARCHAR(100) NULL DEFAULT NULL;
	END IF;
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'scheduledService' AND COLUMN_NAME = 'serviceContactEmail') = 0  THEN
		ALTER TABLE blackstarDb.scheduledService ADD serviceContactEmail VARCHAR(100) NULL DEFAULT NULL;
	END IF;

--	AGREGANDO project a openCustomer
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'openCustomer' AND COLUMN_NAME = 'project') = 0  THEN
		ALTER TABLE blackstarDb.openCustomer ADD project VARCHAR(100) NULL DEFAULT NULL;
	END IF;

-- MODIFICANDO plainService
	ALTER TABLE plainService MODIFY troubleDescription TEXT;
	ALTER TABLE plainService MODIFY techParam TEXT;
	ALTER TABLE plainService MODIFY workDone TEXT;
	ALTER TABLE plainService MODIFY materialUsed TEXT;
	ALTER TABLE plainService MODIFY observations TEXT;

-- AGREGANDO TABLA followUpReferenceType - REPRESENTA EL TIPO DE OBJETO DE NEGOCIOS PADRE DEL FOLLOWUP
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'followUpReferenceType') = 0 THEN
		 CREATE TABLE blackstarDb.followUpReferenceType(
			followUpReferenceTypeId CHAR(1) NOT NULL,
			followUpReferenceType VARCHAR(100) NOT NULL,
			PRIMARY KEY (followUpReferenceTypeId),
			UNIQUE UQ_followUpReferenceType_followUpReferenceTypeId(followUpReferenceTypeId)
		) ENGINE=INNODB;
	END IF;

-- AGREGANDO TABLA issueStatus - REPRESENTA LOS ESTATUS DE LOS PENDIENTES
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'issueStatus') = 0 THEN
		 CREATE TABLE blackstarDb.issueStatus(
			issueStatusId CHAR(1) NOT NULL,
			issueStatus VARCHAR(100) NOT NULL,
			PRIMARY KEY (issueStatusId),
			UNIQUE UQ_issueStatus_issueStatusId(issueStatusId)
		) ENGINE=INNODB;
	END IF;

-- AGREGANDO TABLA issue - REPRESENTA LOS PENDIENTES AISLADOS
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'issue') = 0 THEN
		 CREATE TABLE blackstarDb.issue(
			issueId INTEGER NOT NULL AUTO_INCREMENT,
			issueNumber VARCHAR(100) NOT NULL,
			issueStatusId CHAR(1) NOT NULL,
			title VARCHAR(100) NOT NULL,
			detail TEXT NULL,
			project VARCHAR(100) NULL,
			customer VARCHAR(500) NULL,
			asignee VARCHAR(100) NULL,
			created DATETIME NULL,
			createdBy NVARCHAR(50) NULL,
			createdByUsr NVARCHAR(50) NULL,
			modified DATETIME NULL,
			modifiedBy NVARCHAR(50) NULL,
			modifiedByUsr NVARCHAR(50) NULL,
			PRIMARY KEY (issueId),
			KEY(issueStatusId),
			UNIQUE UQ_issue_issueId(issueId)
		) ENGINE=INNODB;

		 ALTER TABLE issue ADD CONSTRAINT FK_issue_issueStatus
		 FOREIGN KEY(issueStatusId) REFERENCES issueStatus(issueStatusId);
		
	END IF;

-- MOFIFICANDO FOLLOW UP -> SE AGREGA DEPENDENCIA A issue Y A followUpReferenceType
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'followUp' AND COLUMN_NAME = 'issueId') = 0  THEN
		ALTER TABLE blackstarDb.followUp ADD issueId INT NULL;

		ALTER TABLE followUp ADD CONSTRAINT FK_followUp_issue
		FOREIGN KEY(issueId) REFERENCES issue(issueId);
	END IF;

	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'followUp' AND COLUMN_NAME = 'followUpReferenceTypeId') = 0  THEN
		ALTER TABLE blackstarDb.followUp ADD followUpReferenceTypeId CHAR(1) NULL;

		ALTER TABLE followUp ADD CONSTRAINT FK_followUp_followUpReferenceType
		FOREIGN KEY(followUpReferenceTypeId) REFERENCES followUpReferenceType(followUpReferenceTypeId);
	END IF;

--  MODIFICANDO serviceDate EN scheduledServiceDate
	ALTER TABLE scheduledServiceDate MODIFY serviceDate DATETIME;

--	AGREGANDO project a openCustomer
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'openCustomer' AND COLUMN_NAME = 'officeId') = 0  THEN
		ALTER TABLE blackstarDb.openCustomer ADD officeId CHAR(1) NULL DEFAULT NULL;

		ALTER TABLE openCustomer ADD CONSTRAINT FK_openCustomer_office
		 FOREIGN KEY(officeId) REFERENCES office(officeId);

	END IF;

--	AGREGANDO project a scheduledService
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'scheduledService' AND COLUMN_NAME = 'project') = 0  THEN
		ALTER TABLE blackstarDb.scheduledService ADD project VARCHAR(100) NULL DEFAULT NULL;
	END IF;

--	AGREGANDO openCustomerId a scheduledService
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'scheduledService' AND COLUMN_NAME = 'openCustomerId') = 0  THEN
		ALTER TABLE blackstarDb.scheduledService ADD openCustomerId INT NULL DEFAULT NULL;

		ALTER TABLE scheduledService ADD CONSTRAINT FK_scheduledService_openCustomer
		 FOREIGN KEY(openCustomerId) REFERENCES openCustomer(openCustomerId);

	END IF;
	
--	AGREGANDO description a scheduledService
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'scheduledService' AND COLUMN_NAME = 'description') = 0  THEN
		ALTER TABLE blackstarDb.scheduledService ADD description VARCHAR(1000) NULL DEFAULT NULL;
	END IF;

--  AUMENTANTO CAPACIDAD DE CAMPOS EN plainService
	ALTER TABLE plainService MODIFY troubleDescription VARCHAR(1000);
	ALTER TABLE plainService MODIFY techParam VARCHAR(1000);
	ALTER TABLE plainService MODIFY workDone VARCHAR(1000);
	ALTER TABLE plainService MODIFY materialUsed VARCHAR(1000);
	ALTER TABLE plainService MODIFY observations VARCHAR(1000);

--	AGREGANDO serviceOrdernNumber a ticket
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'ticket' AND COLUMN_NAME = 'serviceOrderNumber') = 0  THEN
		ALTER TABLE blackstarDb.ticket ADD serviceOrderNumber VARCHAR(50) NULL DEFAULT NULL;
	END IF;

-- AUMENTANDO CAPACIDAD DE CAMPOS EN policy
	ALTER TABLE policy MODIFY serialNumber VARCHAR(200);
	ALTER TABLE policy MODIFY finalUser VARCHAR(200);

-- AUMENTANDO CAPACIDAD DE CAMPOS DE CONTACTO
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'ticket' AND COLUMN_NAME = 'contact') = 0  THEN
		ALTER TABLE blackstarDb.ticket ADD contact VARCHAR(200) NULL DEFAULT NULL;
	END IF;
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'ticket' AND COLUMN_NAME = 'contactPhone') = 0  THEN
		ALTER TABLE blackstarDb.ticket ADD contactPhone VARCHAR(200) NULL DEFAULT NULL;
	END IF;
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'ticket' AND COLUMN_NAME = 'contactEmail') = 0  THEN
		ALTER TABLE blackstarDb.ticket ADD contactEmail VARCHAR(200) NULL DEFAULT NULL;
	END IF;

-- AGREGANDO COLUMNA equipmentUser A policy
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'policy' AND COLUMN_NAME = 'equipmentUser') = 0  THEN
		ALTER TABLE blackstarDb.policy ADD equipmentUser VARCHAR(100) NULL DEFAULT NULL;
	END IF;

-- AGREGANDO TABLA openCustomer - REPRESENTA LOS CLIENTES SIN POLIZA QUE SOLICITAN SERVICIOS ESPORADICOS
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'openCustomer') = 0 THEN
		 CREATE TABLE blackstarDb.openCustomer(
			openCustomerId INTEGER NOT NULL AUTO_INCREMENT,
			customerName VARCHAR(200),
			address VARCHAR(500) NULL,
			phone VARCHAR(100) NULL,
			equipmentTypeId CHAR(1),
			brand VARCHAR(100) NULL,
			model VARCHAR(100) NULL,
			capacity VARCHAR(100) NULL,
			serialNumber VARCHAR(100),
			contactName VARCHAR(100) NULL,
			contactEmail VARCHAR(100) NULL,
			created DATETIME NULL,
			createdBy NVARCHAR(50) NULL,
			createdByUsr NVARCHAR(50) NULL,
			PRIMARY KEY (openCustomerId),
			KEY(equipmentTypeId),
			UNIQUE UQ_openCustomer_openCustomerId(openCustomerId)
		) ENGINE=INNODB;

		 ALTER TABLE openCustomer ADD CONSTRAINT FK_openCustomer_equipmentTypeId
		 FOREIGN KEY(equipmentTypeId) REFERENCES equipmentType(equipmentTypeId);
		
	END IF;
-- AGREGANDO COLUMNA openCustomerId a ServiceOrder -- ESTA COLUMNA ASOCIA LA OS CON UN EQUIPO SIN POLIZA
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'serviceOrder' AND COLUMN_NAME = 'openCustomerId') = 0  THEN
		ALTER TABLE serviceOrder ADD openCustomerId INT NULL;

		ALTER TABLE blackstarDb.serviceOrder ADD CONSTRAINT FK_openCustomer_openCustomerId
		FOREIGN KEY (openCustomerId) REFERENCES openCustomer (openCustomerId);
	END IF;

-- ELIMINANDO TABLA serviceOrderAdditionalEngineer
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'serviceOrderAdditionalEngineer') = 1 THEN
		DROP TABLE serviceOrderAdditionalEngineer;
	END IF;

-- AGREGANDO TABLA serviceOrderEmployee
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'serviceOrderEmployee') = 0 THEN
		  CREATE TABLE blackstarDb.serviceOrderEmployee(
			serviceOrderEmployeeId INTEGER NOT NULL AUTO_INCREMENT,
			serviceOrderId INTEGER NOT NULL,
			employeeId VARCHAR(100) NOT NULL,
			isDefault TINYINT NOT NULL DEFAULT 0,
			created DATETIME NULL,
			createdBy NVARCHAR(50) NULL,
			createdByUsr NVARCHAR(50) NULL,
			PRIMARY KEY (serviceOrderEmployeeId),
			KEY(serviceOrderId),
			UNIQUE UQ_serviceOrderEmployee_serviceOrderEmployeeId(serviceOrderEmployeeId)
		) ENGINE=INNODB;
		
		ALTER TABLE blackstarDb.serviceOrderEmployee ADD CONSTRAINT FK_serviceOrderEmployee_servideOrderId
		FOREIGN KEY (serviceOrderId) REFERENCES serviceOrder (serviceOrderId);
	END IF;

-- AGREGANDO COLUMNA receivedByEmail a ServiceOrder -- ESTA COLUMNA DETERMINA EL EMAIL AL QUE SE ENVIARA COPIA DE LA OS
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'serviceOrder' AND COLUMN_NAME = 'receivedByEmail') = 0  THEN
		ALTER TABLE serviceOrder ADD receivedByEmail VARCHAR(100) NULL;
	END IF;

-- AGREGANDO TABLA POOL DE NUMEROS DE ORDEN
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'sequenceNumberPool') = 0 THEN
		CREATE TABLE blackstarDb.sequenceNumberPool(
			sequenceNumberPoolId INTEGER NOT NULL AUTO_INCREMENT, 
			sequenceNumberTypeId CHAR(1), 
			sequenceNumber INTEGER, 
			sequenceNumberStatus CHAR(1), -- U: unlocked, L: locked
			PRIMARY KEY(sequenceNumberPoolId),
			UNIQUE UQ_sequenceNumberPool_sequenceNumberPoolId(sequenceNumberPoolId)
		)ENGINE=INNODB;

	END IF;

-- AGREGANDO TABLA DE SECUENCIAS PARA ORDENES DE SERVICIO
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'sequence') = 0 THEN
		CREATE TABLE blackstarDb.sequence(
			sequenceTypeId CHAR(1), 
			sequenceNumber INTEGER,
			PRIMARY KEY(sequenceTypeId),
			UNIQUE UQ_sequence_sequenceTypeId(sequenceTypeId)
		)ENGINE=INNODB;

		-- INICIALIZANDO FOLIOS EN TABLA DE SECUENCIAS
		INSERT INTO sequence(sequenceTypeId, sequenceNumber)
		SELECT 'A', 1 union
		SELECT 'B', 1 union
		SELECT 'O', 1 union
		SELECT 'P', 1 union
		SELECT 'U', 1 ;
	END IF;

-- AGREGANDO COLUMNA isWrong A serviceOrder
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'serviceOrder' AND COLUMN_NAME = 'isWrong') = 0 THEN
		ALTER TABLE serviceOrder ADD isWrong TINYINT NOT NULL DEFAULT 0;
	END IF;
	
-- AGREGANDO COLUMNA isSource A followUp -- ESTA COLUMN INDICA SI EL FOLLOW UP ES IMPORTADO DE LA HOJA ORIGINAL DE TICKETS
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'followUp' AND COLUMN_NAME = 'isSource') =0  THEN
		ALTER TABLE followUp ADD isSource TINYINT NOT NULL DEFAULT 0;
	END IF;
	
-- CREANDO TABLA scheduledService
	IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'scheduledService') = 0 THEN
		CREATE TABLE blackstarDb.scheduledService(
			scheduledServiceId INTEGER NOT NULL AUTO_INCREMENT,
			serviceStatusId CHAR(1) NOT NULL,
			created DATETIME NULL,
			createdBy NVARCHAR(50) NULL,
			createdByUsr NVARCHAR(50) NULL,
			modified DATETIME NULL,
			modifiedBy NVARCHAR(50) NULL,
			modifiedByUsr NVARCHAR(50) NULL,	
			PRIMARY KEY (scheduledServiceId),
			UNIQUE UQ_scheduledService_scheduledServiceId(scheduledServiceId),
			KEY(serviceStatusId)
		) ENGINE=INNODB;
		
		ALTER TABLE blackstarDb.scheduledService ADD CONSTRAINT FK_scheduledService_serviceStatus
		FOREIGN KEY (serviceStatusId) REFERENCES serviceStatus (serviceStatusId);
	END IF;


-- CREANDO TABLA scheduledServicePolicy
	IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'scheduledServicePolicy') = 0 THEN
		CREATE TABLE blackstarDb.scheduledServicePolicy(
			scheduledServicePolicyId INTEGER NOT NULL AUTO_INCREMENT,
			scheduledServiceId INTEGER NOT NULL,
			policyId INTEGER NOT NULL,
			created DATETIME NULL,
			createdBy NVARCHAR(50) NULL,
			createdByUsr NVARCHAR(50) NULL,
			PRIMARY KEY (scheduledServicePolicyId),
			UNIQUE UQ_scheduledServicePolicy_scheduledServicePolicyId(scheduledServicePolicyId),
			KEY(scheduledServiceId),
			KEY(policyId)
		) ENGINE=INNODB;
		
		ALTER TABLE blackstarDb.scheduledServicePolicy ADD CONSTRAINT FK_scheduledServicePolicy_scheduledService
		FOREIGN KEY (scheduledServiceId) REFERENCES scheduledService (scheduledServiceId);
		
		ALTER TABLE blackstarDb.scheduledServicePolicy ADD CONSTRAINT FK_scheduledServicePolicy_policy
		FOREIGN KEY (policyId) REFERENCES policy (policyId);
	END IF;
	

-- CREANDO TABLA scheduledServiceEmployee
	IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'scheduledServiceEmployee') = 0 THEN
		CREATE TABLE blackstarDb.scheduledServiceEmployee(
			scheduledServiceEmployeeId INTEGER NOT NULL AUTO_INCREMENT,
			scheduledServiceId INTEGER NOT NULL,
			employeeId VARCHAR(100) NOT NULL,
			isDefault TINYINT NOT NULL DEFAULT 0,
			created DATETIME NULL,
			createdBy NVARCHAR(50) NULL,
			createdByUsr NVARCHAR(50) NULL,
			PRIMARY KEY (scheduledServiceEmployeeId),
			KEY(scheduledServiceId),
			UNIQUE UQ_scheduledServiceEmployee_scheduledServiceEmployeeId(scheduledServiceEmployeeId)
		) ENGINE=INNODB;
		
		ALTER TABLE blackstarDb.scheduledServiceEmployee ADD CONSTRAINT FK_scheduledServiceEmployee_scheduledService
		FOREIGN KEY (scheduledServiceId) REFERENCES scheduledService (scheduledServiceId);
	END IF;
	
-- CREANDO TABLA scheduledServiceDate
	IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'scheduledServiceDate') = 0 THEN
		CREATE TABLE blackstarDb.scheduledServiceDate(
			scheduledServiceDateId INTEGER NOT NULL AUTO_INCREMENT,
			scheduledServiceId INTEGER NOT NULL,
			serviceDate DATE NOT NULL,
			created DATETIME NULL,
			createdBy NVARCHAR(50) NULL,
			createdByUsr NVARCHAR(50) NULL,
			PRIMARY KEY (scheduledServiceDateId),
			KEY(scheduledServiceId),
			UNIQUE UQ_scheduledServiceDate_scheduledServiceDateId(scheduledServiceDateId)
		) ENGINE=INNODB;
		
		ALTER TABLE blackstarDb.scheduledServiceDate ADD CONSTRAINT FK_scheduledServiceDate_scheduledService
		FOREIGN KEY (scheduledServiceId) REFERENCES scheduledService (scheduledServiceId);
	END IF;
	
-- CREANDO TABLA plainService
	IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'plainService') = 0 THEN
	CREATE TABLE plainService (
		plainServiceId  INTEGER NOT NULL AUTO_INCREMENT,
		serviceOrderId Integer not null,
		troubleDescription NVARCHAR(255) NULL,
		techParam NVARCHAR(255) NULL,
		workDone NVARCHAR(255) NULL,
		materialUsed NVARCHAR(255) NULL,
		observations NVARCHAR(255) NULL,
		created DATETIME NULL,
		createdBy NVARCHAR(50) NULL,
		createdByUsr NVARCHAR(50) NULL,
		modified DATETIME NULL,
		modifiedBy NVARCHAR(50) NULL,
		modifiedByUsr NVARCHAR(50) NULL,
		PRIMARY KEY (plainServiceId),
			UNIQUE UQ_plainService_plainServiceId(plainServiceId),
			KEY (serviceOrderId),
		FOREIGN KEY (serviceOrderId) REFERENCES serviceOrder (serviceOrderId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA bbService
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bbService') = 0 THEN
	CREATE TABLE  bbService
		(
		bbServiceId INTEGER NOT NULL AUTO_INCREMENT,
		serviceOrderId Integer not null,
		plugClean BIT NOT NULL,
		plugCleanStatus nVARCHAR(50) null,
		plugCleanComments nVARCHAR(50) null,
		coverClean BIT NOT NULL,
		coverCleanStatus nVARCHAR(50) null,
		coverCleanComments nVARCHAR(50) null,
		capClean BIT NOT NULL,
		capCleanStatus nVARCHAR(50) null,
		capCleanComments nVARCHAR(50) null,
		groundClean BIT NOT NULL,
		groundCleanStatus nVARCHAR(50) null,
		groundCleanComments nVARCHAR(50) null,
		rackClean BIT NOT NULL,
		rackCleanStatus nVARCHAR(50) null,
		rackCleanComments nVARCHAR(50) null,
		serialNoDateManufact nVARCHAR(50) null,
		batteryTemperature nVARCHAR(50) null,
		voltageBus integer not null,
		temperature integer not null,
		created DATETIME NULL,
		createdBy NVARCHAR(50) NULL,
		createdByUsr NVARCHAR(50) NULL,
		modified DATETIME NULL,
		modifiedBy NVARCHAR(50) NULL,
		modifiedByUsr NVARCHAR(50) NULL,
		PRIMARY KEY (bbServiceId),
		UNIQUE UQ_bbService_bbServiceId(bbServiceId),
		KEY (serviceOrderId),
		FOREIGN KEY (serviceOrderId) REFERENCES serviceOrder (serviceOrderId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA bbCellService
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bbCellService') = 0 THEN
	CREATE TABLE  bbCellService
	(
		bbCellServiceId INTEGER NOT NULL AUTO_INCREMENT,
		bbServiceId INTEGER NOT NULL ,
		cellNumber integer Not null,
		floatVoltage integer not null,
		chargeVoltage integer not null,
		PRIMARY KEY (bbCellServiceId),
		UNIQUE UQ_bbCellService_bbCellServiceId(bbCellServiceId),
		KEY (bbCellServiceId),
		FOREIGN KEY (bbServiceId) REFERENCES bbService (bbServiceId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA epService
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'epService') = 0 THEN
	CREATE TABLE epService
	(
		epServiceId INTEGER NOT NULL AUTO_INCREMENT,
		serviceOrderId Integer not null,
		brandPE nVARCHAR (50) null,
		modelPE nVARCHAR (50) null,
		serialPE nVARCHAR (50) null,
		transferType nVARCHAR(50) null,
		modelTransfer nVARCHAR(50) null,
		modelControl nVARCHAR(50) null,
		modelRegVoltage nVARCHAR(50) null,
		modelRegVelocity nVARCHAR(50) null,
		modelCharger nVARCHAR(50) null,
		oilChange date null,
		brandMotor nVARCHAR(50) null,
		modelMotor nVARCHAR(50) null,
		serialMotor nVARCHAR(50) null,
		cplMotor nVARCHAR(50) null,
		brandGenerator nVARCHAR(50) null,
		modelGenerator nVARCHAR(50) null,
		serialGenerator nVARCHAR(50) null,
		powerWattGenerator integer null,
		tensionGenerator integer null,
		tuningDate date null,
		tankCapacity integer null,
		pumpFuelModel nVARCHAR(50) null,
		filterFuelFlag bit not null,
		filterOilFlag bit not null,
		filterWaterFlag bit not null,
		filterAirFlag bit not null,
		brandGear nVARCHAR(50) null,
		brandBattery nVARCHAR(50) null,
		clockLecture nVARCHAR(50) null,
		serviceCorrective date null,
		observations nVARCHAR(50) null,
		created DATETIME NULL,
		createdBy NVARCHAR(50) NULL,
		createdByUsr NVARCHAR(50) NULL,
		modified DATETIME NULL,
		modifiedBy NVARCHAR(50) NULL,
		modifiedByUsr NVARCHAR(50) NULL,
		PRIMARY KEY (epServiceId),
		UNIQUE UQ_epService_epServiceId(epServiceId),
		KEY (serviceOrderId),
		FOREIGN KEY (serviceOrderId) REFERENCES serviceOrder (serviceOrderId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA epServiceSurvey
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'epServiceSurvey') = 0 THEN
	CREATE TABLE epServiceSurvey
	(
		epServiceSurveyId INTEGER NOT NULL AUTO_INCREMENT,
		epServiceId INTEGER NOT NULL ,
		levelOilFlag bit not null,
		levelWaterFlag bit not null,
		levelBattery integer not null,
		tubeLeak bit not null,
		batteryCap nVARCHAR(50) null,
		batterySulfate nVARCHAR(50) null,
		levelOil integer null,
		heatEngine nVARCHAR(50) null,
		hoseOil nVARCHAR(50) null,
		hoseWater nVARCHAR(50) null,
		tubeValve nVARCHAR(50) null,
		stripBlades nVARCHAR(50) null,
		PRIMARY KEY (epServiceSurveyId),
		UNIQUE UQ_epServiceSurvey_epServiceSurveyId(epServiceSurveyId),
		KEY (epServiceId),
		FOREIGN KEY (epServiceId) REFERENCES epService (epServiceId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA epServiceWorkBasic
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'epServiceWorkBasic') = 0 THEN
	CREATE TABLE epServiceWorkBasic
	(
		epServiceWorkBasicId INTEGER NOT NULL AUTO_INCREMENT,
		epServiceId INTEGER NOT NULL ,
		washEngine bit null,
		washRadiator bit null,
		cleanWorkArea bit null,
		conectionCheck bit null,
		cleanTransfer bit null,
		cleanCardControl bit null,
		checkConectionControl bit null,
		checkWinding bit null,
		batteryTests bit null,
		checkCharger bit null,
		checkPaint bit null,
		cleanGenerator bit null,
		PRIMARY KEY (epServiceWorkBasicId),
		UNIQUE UQ_epServiceWorkBasic_epServiceWorkBasicId(epServiceWorkBasicId),
		KEY (epServiceId),
		FOREIGN KEY (epServiceId) REFERENCES epService (epServiceId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA epServiceDynamicTest
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'epServiceDynamicTest') = 0 THEN
	CREATE TABLE epServiceDynamicTest
	(
		epServiceDynamicTestId INTEGER NOT NULL AUTO_INCREMENT,
		epServiceId INTEGER NOT NULL ,
		vacuumFrequency decimal not null,
		chargeFrequency decimal not null,
		bootTryouts integer not null,
		vacuumVoltage decimal not null,
		chargeVoltage decimal not null,
		qualitySmoke decimal not null,
		startTime integer not null,
		transferTime integer not null,
		stopTime integer not null,
		PRIMARY KEY (epServiceDynamicTestId),
		UNIQUE UQ_bepServiceDynamicTest_epServiceDynamicTestId(epServiceDynamicTestId),
		KEY (epServiceId),
		FOREIGN KEY (epServiceId) REFERENCES epService (epServiceId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA epServiceTestProtection
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'epServiceTestProtection') = 0 THEN
	CREATE TABLE epServiceTestProtection
	(
		epServiceTestProtectionId INTEGER NOT NULL AUTO_INCREMENT,
		epServiceId INTEGER NOT NULL ,
		tempSensor integer not null,
		oilSensor integer not null,
		voltageSensor integer not null,
		overSpeedSensor integer not null,
		oilPreasureSensor integer not null,
		waterLevelSensor integer not null,
		PRIMARY KEY (epServiceTestProtectionId),
		UNIQUE UQ_epServiceTestProtection_epServiceTestProtectionId(epServiceTestProtectionId),
		KEY (epServiceId),
		FOREIGN KEY (epServiceId) REFERENCES epService (epServiceId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA epServiceTransferSwitch
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'epServiceTransferSwitch') = 0 THEN
	CREATE TABLE epServiceTransferSwitch
	(
		epServiceTransferSwitchId INTEGER NOT NULL AUTO_INCREMENT,
		epServiceId INTEGER NOT NULL ,
		mechanicalStatus nVARCHAR(10) not null,
		boardClean bit not null,
		screwAdjust bit not null,
		lampTest bit not null,
		conectionAdjust bit not null,
		systemMotors nVARCHAR(10) not null,
		electricInterlock nVARCHAR(10) not null,
		mechanicalInterlock nVARCHAR(10) not null,
		capacityAmp integer not null,
		PRIMARY KEY (epServiceTransferSwitchId),
		UNIQUE UQ_epServiceTransferSwitch_epServiceTransferSwitchId(epServiceTransferSwitchId),
		KEY (epServiceId),
		FOREIGN KEY (epServiceId) REFERENCES epService (epServiceId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA epServiceLectures
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'epServiceLectures') = 0 THEN
	CREATE TABLE epServiceLectures
	(
		epServiceLecturesId INTEGER NOT NULL AUTO_INCREMENT,
		epServiceId INTEGER NOT NULL ,
		voltageABAN integer not null,
		voltageACCN integer not null,
		voltageBCBN integer not null,
		voltageNT integer not null,
		currentA integer not null,
		currentB integer not null,
		currentC integer not null,
		frequency integer not null,
		oilPreassure integer not null,
		temp integer not null,
		PRIMARY KEY (epServiceLecturesId),
		UNIQUE UQ_epServiceLectures_epServiceLecturesId(epServiceLecturesId),
		KEY (epServiceId),
		FOREIGN KEY (epServiceId) REFERENCES epService (epServiceId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA epServiceParams
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'epServiceParams') = 0 THEN
	CREATE TABLE epServiceParams
	(
		epServiceParamsId INTEGER NOT NULL AUTO_INCREMENT,
		epServiceId INTEGER NOT NULL ,
		adjsutmentTherm nVARCHAR(10) not null,
		current nVARCHAR(10) not null,
		batteryCurrent nVARCHAR(10) not null,
		clockStatus nVARCHAR(10) not null,
		trasnferTypeProtection nVARCHAR(10) not null,
		generatorTypeProtection nVARCHAR(10) not null,
		PRIMARY KEY (epServiceParamsId),
		UNIQUE UQ_epServiceParams_epServiceParamsId(epServiceParamsId),
		KEY (epServiceId),
		FOREIGN KEY (epServiceId) REFERENCES epService (epServiceId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA upsService
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'upsService') = 0 THEN
	CREATE TABLE upsService
	(
		upsServiceId INTEGER NOT NULL AUTO_INCREMENT,
		serviceOrderId Integer not null,
		estatusEquipment nVARCHAR(50) not null,
		cleaned bit not null,
		hooverClean bit not null,
		verifyConnections bit not null,
		capacitorStatus nVARCHAR(50) not null,
		verifyFuzz bit not null,
		chargerReview bit not null,
		fanStatus nVARCHAR(50) not null,
		observations nVARCHAR(250) not null,
		created DATETIME NULL,
		createdBy NVARCHAR(50) NULL,
		createdByUsr NVARCHAR(50) NULL,
		modified DATETIME NULL,
		modifiedBy NVARCHAR(50) NULL,
		modifiedByUsr NVARCHAR(50) NULL,
		PRIMARY KEY (upsServiceId),
		UNIQUE UQ_upsService_upsServiceId(upsServiceId),
		KEY (serviceOrderId),
		FOREIGN KEY (serviceOrderId) REFERENCES serviceOrder (serviceOrderId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA upsServiceBatteryBank
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'upsServiceBatteryBank') = 0 THEN
	CREATE TABLE upsServiceBatteryBank
	(
		upsServiceBatteryBankId INTEGER NOT NULL AUTO_INCREMENT,
		upsServiceId INTEGER NOT NULL ,
		checkConnectors bit not null,
		cverifyOutflow bit not null,
		numberBatteries integer not null,
		manufacturedDateSerial nVARCHAR(10) not null,
		damageBatteries nVARCHAR(50) not null,
		other nVARCHAR(250) not null,
		temp decimal not null,
		chargeTest bit not null,
		brandModel nVARCHAR(250) not null,
		batteryVoltage decimal not null,
		PRIMARY KEY (upsServiceBatteryBankId),
		UNIQUE UQ_upsServiceBatteryBank_upsServiceBatteryBankId(upsServiceBatteryBankId),
		KEY (upsServiceId),
		FOREIGN KEY (upsServiceId) REFERENCES upsService (upsServiceId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA upsServiceGeneralTest
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'upsServiceGeneralTest') = 0 THEN
	CREATE TABLE upsServiceGeneralTest
	(
		upsServiceGeneralTestId INTEGER NOT NULL AUTO_INCREMENT,
		upsServiceId INTEGER NOT NULL ,
		trasferLine decimal not null,
		transferEmergencyPlant decimal not null,
		backupBatteries decimal not null,
		verifyVoltage decimal not null,
		PRIMARY KEY (upsServiceGeneralTestId),
		UNIQUE UQ_upsServiceGeneralTestId_upsServiceGeneralTestId(upsServiceGeneralTestId),
		KEY (upsServiceId),
		FOREIGN KEY (upsServiceId) REFERENCES upsService (upsServiceId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA upsServiceParams
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'upsServiceParams') = 0 THEN
	CREATE TABLE upsServiceParams
	(
		upsServiceParamsId INTEGER NOT NULL AUTO_INCREMENT,
		upsServiceId INTEGER NOT NULL ,
		inputVoltagePhase decimal not null,
		inputVoltageNeutro decimal not null,
		inputVoltageNeutroGround decimal not null,
		percentCharge decimal not null,
		outputVoltagePhase decimal not null,
		outputVoltageNeutro decimal not null,
		inOutFrecuency decimal not null,
		busVoltage decimal not null,
		PRIMARY KEY (upsServiceParamsId),
		UNIQUE UQ_upsServiceParams_eupsServiceParamsId(upsServiceParamsId),
		KEY (upsServiceId),
		FOREIGN KEY (upsServiceId) REFERENCES upsService (upsServiceId)
	)ENGINE=INNODB; 		
END IF;

-- CREANDO TABLA aaService
IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'aaService') = 0 THEN
	create table aaService
	(
		aaServiceId INTEGER NOT NULL AUTO_INCREMENT,
		serviceOrderId Integer not null,
		evaDescription nVARCHAR(250) not null,
		evaValTemp decimal not null,
		evaValHum decimal not null,
		evaSetpointTemp decimal not null,
		evaSetpointHum decimal not null,
		evaFlagCalibration bit not null,
		evaReviewFilter bit not null,
		evaReviewStrip bit not null,
		evaCleanElectricSystem bit not null,
		evaCleanControlCard bit not null,
		evaCleanTray bit not null,
		evaLectrurePreasureHigh decimal not null,
		evaLectrurePreasureLow decimal not null,
		evaLectureTemp decimal not null,
		evaLectureOilColor nVARCHAR(10) not null,
		evaLectureOilLevel decimal not null,
		evaLectureCoolerColor nVARCHAR(10) not null,
		evaLectureCoolerLevel decimal not null,
		evaCheckOperatation nVARCHAR(10) not null,
		evaCheckNoise nVARCHAR(10) not null,
		evaCheckIsolated nVARCHAR(10)not null,
		evaLectureVoltageGroud decimal not null,
		evaLectureVoltagePhases decimal not null,
		evaLectureVoltageControl decimal not null,
		evaLectureCurrentMotor1 decimal not null,
		evaLectureCurrentMotor2 decimal not null,
		evaLectureCurrentMotor3 decimal not null,
		evaLectureCurrentCompressor1 decimal not null,
		evaLectureCurrentCompressor2 decimal not null,
		evaLectureCurrentCompressor3 decimal not null,
		evaLectureCurrentHumidifier1 decimal not null,
		evaLectureCurrentHumidifier2 decimal not null,
		evaLectureCurrentHumidifier3 decimal not null,
		evaLectureCurrentHeater1 decimal not null,
		evaLectureCurrentHeater2 decimal not null,
		evaLectureCurrentHeater3 decimal not null,
		evaCheckFluidSensor  bit not null,
		evaRequirMaintenance  bit not null,
		condReview VARCHAR(50) not null,
		condCleanElectricSystem bit not null,
		condClean bit not null,
		condLectureVoltageGroud decimal not null,
		condLectureVoltagePhases decimal not null,
		condLectureVoltageControl decimal not null,
		condLectureMotorCurrent decimal not null,
		condReviewThermostat nVARCHAR(50) not null,
		condModel nVARCHAR(50) not null,
		condSerialNumber nVARCHAR(50) not null,
		condBrand nVARCHAR(50) not null,
		observations nVARCHAR(255) not null,
		created DATETIME NULL,
		createdBy NVARCHAR(50) NULL,
		createdByUsr NVARCHAR(50) NULL,
		modified DATETIME NULL,
		modifiedBy NVARCHAR(50) NULL,
		modifiedByUsr NVARCHAR(50) NULL,
		PRIMARY KEY (aaServiceId),
		UNIQUE UQ_aaService_aaServiceId(aaServiceId),
		KEY (serviceOrderId),
		FOREIGN KEY (serviceOrderId) REFERENCES serviceOrder (serviceOrderId)
	)ENGINE=INNODB; 		
END IF;


IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'surveyService') = 0 THEN

	CREATE TABLE blackstarDb.surveyService (
		surveyServiceId INT NOT NULL AUTO_INCREMENT,
		surveyServiceNumber VARCHAR(50),
		company VARCHAR(255),
		namePerson VARCHAR(45) NULL,
		email VARCHAR(45) NULL,
		phone VARCHAR(45) NULL,
		surveyDate DATE NULL,
		questionTreatment VARCHAR(45) NULL,
		reasonTreatment VARCHAR(45) NULL,
		questionIdentificationPersonal VARCHAR(45) NULL,
		questionIdealEquipment VARCHAR(45) NULL,
		surveyServicecol VARCHAR(45) NULL,
		reasonIdealEquipment VARCHAR(45) NULL,
		questionTime VARCHAR(45) NULL,
		reasonTime VARCHAR(45) NULL,
		questionUniform VARCHAR(45) NULL,
		reasonUniform VARCHAR(45) NULL,
		score INT NULL,
		sign TEXT NULL,
		suggestion TEXT NULL,
		created DATETIME NULL,
		createdBy NVARCHAR(50) NULL,
		createdByUsr NVARCHAR(50) NULL,
		modified DATETIME NULL,
		modifiedBy NVARCHAR(50) NULL,
		modifiedByUsr NVARCHAR(50) NULL,
		PRIMARY KEY (surveyServiceId),
		UNIQUE UQ_surveyService_surveyServiceId(surveyServiceId)
	)ENGINE=INNODB; 

END IF;

IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'serviceOrder' AND COLUMN_NAME = 'surveyServiceId') = 0  THEN

	ALTER TABLE blackstarDb.serviceOrder ADD surveyServiceId INT;
	ALTER TABLE blackstarDb.serviceOrder ADD CONSTRAINT FK_serviceOrder_surveyService
		FOREIGN KEY (surveyServiceId) REFERENCES surveyService (surveyServiceId);


END IF;

	
-- -----------------------------------------------------------------------------
-- FIN SECCION DE CAMBIOS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDb.upgradeSchema();

DROP PROCEDURE blackstarDb.upgradeSchema;

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
-- 43	03/06/2014	SAG 	Se modifica:
--                              blackstarDb.GetPoliciesKPI
-- -----------------------------------------------------------------------------
-- 44	04/06/2014	SAG 	Se modifica:
--                              blackstarDb.GetAllServiceOrders
-- -----------------------------------------------------------------------------
-- 45	10/06/2014	SAG 	Se modifica:
--                              blackstarDb.GetTicketsKPI
-- -----------------------------------------------------------------------------
-- 46	13/06/2014	SAG 	Se modifica:
--                              blackstarDb.GetProjectsKPI
-- -----------------------------------------------------------------------------
-- 47	15/06/2014	SAG 	Se modifica:
--                              blackstarDb.GetProjectsKPI
--								blackstarDb.AddSurveyService
-- -----------------------------------------------------------------------------
-- 48	02/07/2014	SAG 	Se modifica:
--								blackstarDb.GetServiceOrders
-- -----------------------------------------------------------------------------
-- 49 	05/07/2014	SAG 	Se modifica:
--								blackstarDb.SaveIssue
-- -----------------------------------------------------------------------------
-- 50 	08/07/2014	SAG 	Se modifica:
--								blackstarDb.UpsertUser
--								blackstarDb.GetUserWatchingIssues
--								blackstarDb.GetAutoCompleteServiceOrdersByDate
-- -----------------------------------------------------------------------------
-- 51	18/07/2014	SAG 	Se modifica:
--								blackstarDb.GetPoliciesKPI
--								blackstarDb.GetTicketsKPI
--								blackstarDb.GetServiceOrders
-- -----------------------------------------------------------------------------
-- 52 	24/07/2014	SAG 	Se implementa relacion 1-n entre polizas y usuarios cliente
-- -----------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAutoCompleteServiceOrdersByDate
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAutoCompleteServiceOrdersByDate$$
CREATE PROCEDURE blackstarDb.GetAutoCompleteServiceOrdersByDate (pStartDate DATETIME)
BEGIN

	SELECT 
		so.serviceOrderId AS value,
		so.serviceOrderNumber AS label
	FROM serviceOrder so 
	WHERE so.serviceDate >= pStartDate
	ORDER BY so.serviceOrderNumber;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetProjectsKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetProjectsKPI$$
CREATE PROCEDURE blackstarDb.GetProjectsKPI (pProject VARCHAR(100), pStartDate DATETIME, pEndDate DATETIME)
BEGIN
	IF pProject = 'All' THEN
		SELECT 
			p.project AS project,
			o.officeName AS officeName,
			pt.policyType AS warranty,
			ifnull(p.customerContract, '') AS contract,
			ifnull(p.customer, '') AS customer,
			ifnull(p.finalUser, '') AS finalUser,
			ifnull(p.cst, '') AS cst,
			p.startDate AS startDate,
			p.endDate AS endDate,
			ifnull(p.contactName, '') AS  contactName,
			ifnull(p.contactPhone, '') AS contactPhone
		FROM policy p 
			INNER JOIN office o ON p.officeId = o.officeId
			INNER JOIN policyType pt ON p.policyTypeId = pt.policyTypeId
		WHERE NOT (p.startDate >= pEndDate OR p.endDate <= pStartDate)
		GROUP BY project
		ORDER BY officeName, project;
	ELSE
		SELECT 
			p.project AS project,
			o.officeName AS officeName,
			pt.policyType AS warranty,
			ifnull(p.customerContract, '') AS contract,
			ifnull(p.customer, '') AS customer,
			ifnull(p.finalUser, '') AS finalUser,
			ifnull(p.cst, '') AS cst,
			p.startDate AS startDate,
			p.endDate AS endDate,
			ifnull(p.contactName, '') AS  contactName,
			ifnull(p.contactPhone, '') AS contactPhone
		FROM policy p 
			INNER JOIN office o ON p.officeId = o.officeId
			INNER JOIN policyType pt ON p.policyTypeId = pt.policyTypeId
		WHERE NOT (p.startDate >= pEndDate OR p.endDate <= pStartDate)
			AND p.project = pProject
		GROUP BY project
		ORDER BY officeName, project;
	END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrderDetails
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrderDetails$$
CREATE PROCEDURE blackstarDb.GetServiceOrderDetails (serviceOrderNumber VARCHAR(100))
BEGIN

	SELECT 
		so.serviceOrderNumber,
		IFNULL(p.customer, c.customerName) AS company,
		so.receivedBy AS name,
		so.receivedByEmail AS email,
		IFNULL(p.contactPhone, c.phone) AS phone,
		so.serviceDate AS serviceDate
	FROM serviceOrder so 
		LEFT OUTER JOIN policy p ON p.policyId = so.policyId
		LEFT OUTER JOIN openCustomer c ON c.openCustomerId = so.openCustomerId
	WHERE so.serviceOrderNumber = serviceOrderNumber;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedFutureServicesSchedule
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedFutureServicesSchedule$$
CREATE PROCEDURE blackstarDb.GetLimitedFutureServicesSchedule (user VARCHAR(100), pServiceDate DATETIME)
BEGIN

	SELECT DISTINCT
		s.scheduledServiceId AS scheduledServiceId,
		serviceDate AS scheduledDate,
		equipmentType AS equipmentType,
		ifnull(p.customer, oc.customerName) AS customer,
		s.project AS project,
		ifnull(p.serialNumber, oc.serialNumber) AS serialNumber,
		officeName AS officeName,
		ifnull(p.brand, oc.brand) AS brand,
		us.name AS employee
	FROM blackstarDb.scheduledService s
		LEFT OUTER JOIN blackstarDb.scheduledServicePolicy sp ON sp.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER JOIN blackstarDb.openCustomer oc ON oc.openCustomerId = s.openCustomerId
		LEFT OUTER JOIN blackstarDb.scheduledServiceDate sd ON sd.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER JOIN blackstarDb.policy p ON sp.policyId = p.policyId
		LEFT OUTER JOIN blackstarDb.serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER JOIN blackstarDb.equipmentType et ON et.equipmentTypeId = ifnull(p.equipmentTypeId, oc.equipmentTypeId)
		LEFT OUTER JOIN blackstarDb.scheduledServiceEmployee em ON em.scheduledServiceId = s.scheduledServiceId AND em.isDefault = 1
		LEFT OUTER JOIN blackstarDb.blackstarUser us ON us.email = em.employeeId
		LEFT OUTER JOIN blackstarDb.office o ON o.officeId = ifnull(p.officeId, oc.officeId)
		LEFT OUTER JOIN blackstarDb.policyEquipmentUser pe ON pe.policyId = p.policyId
	WHERE s.serviceStatusId = 'P'
		AND serviceDate >= pServiceDate
		AND pe.equipmentUserId = user
	ORDER BY equipmentType;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedScheduledServices
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedServicesSchedule$$
CREATE PROCEDURE blackstarDb.GetLimitedServicesSchedule (user VARCHAR(100), pServiceDate DATETIME)
BEGIN

	SELECT DISTINCT
		s.scheduledServiceId AS scheduledServiceId,
		serviceDate AS scheduledDate,
		equipmentType AS equipmentType,
		ifnull(p.customer, oc.customerName) AS customer,
		s.project AS project,
		ifnull(p.serialNumber, oc.serialNumber) AS serialNumber,
		us.name AS defaultEmployee
	FROM blackstarDb.scheduledService s
		LEFT OUTER JOIN blackstarDb.scheduledServicePolicy sp ON sp.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER JOIN blackstarDb.openCustomer oc ON oc.openCustomerId = s.openCustomerId
		LEFT OUTER JOIN blackstarDb.scheduledServiceDate sd ON sd.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER JOIN blackstarDb.policy p ON sp.policyId = p.policyId
		LEFT OUTER JOIN blackstarDb.serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER JOIN blackstarDb.equipmentType et ON et.equipmentTypeId = ifnull(p.equipmentTypeId, oc.equipmentTypeId)
		LEFT OUTER JOIN blackstarDb.scheduledServiceEmployee em ON em.scheduledServiceId = s.scheduledServiceId AND em.isDefault = 1
		LEFT OUTER JOIN blackstarDb.blackstarUser us ON us.email = em.employeeId
		LEFT OUTER JOIN blackstarDb.policyEquipmentUser pe ON pe.policyId = p.policyId
	WHERE s.serviceStatusId = 'P'
		AND serviceDate > pServiceDate AND serviceDate < DATE_ADD(pServiceDate, INTERVAL 1 DAY)
		AND pe.equipmentUserId = user
	ORDER BY equipmentType;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetIssueStatusList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetIssueStatusList$$
CREATE PROCEDURE blackstarDb.GetIssueStatusList ()
BEGIN

	SELECT *
	FROM issueStatus;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextIssueNumber
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextIssueNumber$$
CREATE PROCEDURE blackstarDb.GetNextIssueNumber()
BEGIN

	DECLARE nextId INTEGER;
	DECLARE nextNumber VARCHAR(100);
	SET @seqNumberTypeId := 'I';

	-- Cargar nuevos numeros
	CALL blackstarDb.LoadNewSequencePoolItems(@seqNumberTypeId);
	
	-- Recuperar el siguiente numero en la secuencia y su ID
	SELECT min(sequenceNumber) into nextNumber
	FROM sequenceNumberPool 
	WHERE sequenceNumberTypeId = @seqNumberTypeId
		AND sequenceNumberStatus = 'U';

	SELECT sequenceNumberPoolId into nextId
	FROM sequenceNumberPool 
	WHERE sequenceNumber = nextNumber 
		AND sequenceNumberTypeId = @seqNumberTypeId;

	-- Bloquear el numero
	UPDATE sequenceNumberPool SET sequenceNumberStatus = 'L'
	WHERE sequenceNumberPoolId = nextId;

	SELECT concat('AS-', nextNumber);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AssignIssue
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AssignIssue$$
CREATE PROCEDURE blackstarDb.AssignIssue (pIssueId INTEGER, pEmployee VARCHAR(100), usr VARCHAR(100), proc VARCHAR(100))
BEGIN

	-- Asignacion del empleado responsable
	UPDATE issue i SET
		i.asignee = pEmployee,
		i.modified = NOW(),
		i.modifiedBy = proc,
		i.modifiedByUsr = usr
	WHERE i.issueId = pIssueId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.SaveIssue
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.SaveIssue$$
CREATE PROCEDURE blackstarDb.SaveIssue(issueId INT, issueNumber VARCHAR(100), issueStatusId CHAR(1), title VARCHAR(1000), detail TEXT, project VARCHAR(100),
	customer VARCHAR(1000), asignee VARCHAR(100), created DATETIME, createdBy VARCHAR(100), createdByUsr VARCHAR(100), dueDate DATETIME)
BEGIN

	IF issueId > 0 THEN
		UPDATE issue i SET
			i.issueStatusId = issueStatusId,
			i.detail = detail,
			i.project = project,
			i.customer = customer,
			i.asignee = asignee,
			i.modified = created,
			i.modifiedBy = createdBy,
			i.modifiedByUsr = createdByUsr,
			i.dueDate = dueDate
		WHERE i.issueid = issueid;
	ELSE
		INSERT INTO issue
			(issueId, issueNumber, issueStatusId, title, detail, project, customer, asignee, created, createdBy, createdByUsr, dueDate)
		VALUES
			(issueId, issueNumber, issueStatusId, title, detail, project, customer, asignee, created, createdBy, createdByUsr, dueDate);

		SET issueId = LAST_INSERT_ID();

		-- Agragar el followUp inicial
		INSERT INTO blackstarDb.followUp(
			followUpReferenceTypeId,
			issueId,
			asignee,
			followup,
			created,
			createdBy,
			createdByUsr
		)
		SELECT 
			'I',
			issueid,
			asignee,
			detail,
			created,
			createdBy,
			createdByUsr;
	END IF;

	SELECT issueId;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToIssue
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpToIssue$$
CREATE PROCEDURE blackstarDb.AddFollowUpToIssue(pIssueId INTEGER, pCreated DATETIME, pCreatedBy VARCHAR(100), pAsignee VARCHAR(100), pMessage TEXT)
BEGIN

	-- INSERTAR EL REGISTRO DE SEGUIMIENTO
	INSERT INTO blackstarDb.followUp(
		followUpReferenceTypeId,
		issueId,
		asignee,
		followup,
		created,
		createdBy,
		createdByUsr
	)
	SELECT 
		'I',
		pIssueId,
		pAsignee,
		pMessage,
		pCreated,
		'AddFollowUpToIssue',
		pCreatedBy;

	UPDATE issue SET
		issueStatusId = 'A',
		modified = NOW(),
		modifiedBy = 'AddFollowUpToIssue',
		modifiedByUsr = pCreatedBy
	WHERE issueId = pIssueId;
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFollowUpReferenceTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFollowUpReferenceTypes$$
CREATE PROCEDURE blackstarDb.GetFollowUpReferenceTypes()
BEGIN

	SELECT 
		f.*
	FROM followUpReferenceType f;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFollowUpByIssue
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFollowUpByIssue$$
CREATE PROCEDURE blackstarDb.GetFollowUpByIssue(pIssueId INT)
BEGIN

	SELECT 
		created AS timeStamp,
		u2.name AS createdBy,
		u.name AS asignee,
		followup AS followUp
	FROM followUp f
		LEFT OUTER JOIN blackstarUser u ON f.asignee = u.email
		LEFT OUTER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE issueId = pIssueId
	ORDER BY created;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetIssueById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetIssueById$$
CREATE PROCEDURE blackstarDb.GetIssueById(pIssueId INT)
BEGIN

	SELECT 
		*
	FROM issue
	WHERE issueid = pIssueId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUserWatchingIssues
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserWatchingIssues$$
CREATE PROCEDURE blackstarDb.GetUserWatchingIssues(pUser VARCHAR(100))
BEGIN

	SET @prevRefId := 0;
	SET @rowNumber := 0;
	SET @myId:= (SELECT blackstarUserId FROM blackstarUser WHERE email = pUser);

	SELECT 
		f.followUpReferenceTypeId AS referenceTypeId, 
		r.followupreferencetype AS referenceType,
		coalesce(t.ticketId, s.serviceOrderId, i.issueId) AS referenceId, 
		coalesce(t.ticketNumber, s.serviceOrderNumber, i.issueNumber) AS referenceNumber,
		coalesce(p.project, c.project, i.project) AS project,
		coalesce(p.customer, c.customerName, i.customer) AS customer,
		f.created AS created,
		CASE 
			WHEN f.followUpReferenceTypeId = 'T' THEN 'Seguimiento a Ticket'
			WHEN f.followUpReferenceTypeId = 'O' THEN 'Seguimiento a Orden de Servicio'
			WHEN f.followUpReferenceTypeId = 'I' THEN 'Asignacion SAC'
		END AS title,
		followUp AS detail,
		coalesce(ts.ticketStatus, ist.issueStatus, '') as status,
		ifnull(u1.name, '') AS createdByUsr,
		u2.name AS asignee
	FROM (
		SELECT * FROM (
			SELECT @rowNumber := IF(coalesce(ticketId, serviceOrderId, issueId) = @prevRefId, @rowNumber + 1, 1) AS RowNum,
				f.*, 
				@prevRefId := coalesce(ticketId, serviceOrderId, issueId) AS PrevRef
			FROM followUp f
			ORDER BY followUpReferenceTypeId, coalesce(ticketId, serviceOrderId, issueId), created DESC
		) a WHERE a.RowNum = 1  -- a: todos los followUps asignados por usuario, numerados por id de (ticket, so, issue)
	) f -- f: el ultimo comentario de cada (ticket, so, issue) y que esta asignado al usuario
		INNER JOIN followUpReferenceType r ON f.followUpReferenceTypeId = r.followUpReferenceTypeId
		LEFT OUTER JOIN ticket t ON f.ticketId = t.ticketId
		LEFT OUTER JOIN serviceOrder s ON s.serviceOrderId = f.serviceOrderId
		LEFT OUTER JOIN issue i ON i.issueId = f.issueId
		LEFT OUTER JOIN policy p ON coalesce(t.policyId, s.policyId) = p.policyId
		LEFT OUTER JOIN openCustomer c ON s.openCustomerId = c.openCustomerId
		LEFT OUTER JOIN ticketStatus ts ON ts.ticketStatusId = t.ticketStatusId
		LEFT OUTER JOIN serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER JOIN issueStatus ist ON ist.issueStatusId = i.issueStatusId
		LEFT OUTER JOIN blackstarUser u1 ON f.createdByUsr = u1.email
		LEFT OUTER JOIN blackstarUser u2 ON f.asignee = u2.email
	WHERE (coalesce(t.createdByUsr, s.createdByUsr, i.createdByUsr) = pUser
			OR u2.bossId = @myId)
		AND coalesce(t.ticketStatusId, s.serviceStatusId, i.issueStatusId) NOT IN ('C', 'F')
	ORDER BY f.created;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUserPendingIssues
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserPendingIssues$$
CREATE PROCEDURE blackstarDb.GetUserPendingIssues(pUser VARCHAR(100))
BEGIN

	SET @prevRefId := 0;
	SET @rowNumber := 0;

	SELECT 
		f.followUpReferenceTypeId AS referenceTypeId, 
		r.followupreferencetype AS referenceType,
		coalesce(t.ticketId, s.serviceOrderId, i.issueId) AS referenceId, 
		coalesce(t.ticketNumber, s.serviceOrderNumber, i.issueNumber) AS referenceNumber,
		coalesce(p.project, c.project, i.project) AS project,
		coalesce(p.customer, c.customerName, i.customer) AS customer,
		f.created AS created,
		i.dueDate AS dueDate,
		CASE 
			WHEN f.followUpReferenceTypeId = 'T' THEN 'Seguimiento a Ticket'
			WHEN f.followUpReferenceTypeId = 'O' THEN 'Seguimiento a Orden de Servicio'
			WHEN f.followUpReferenceTypeId = 'I' THEN 'Asignacion SAC'
		END AS title,
		followUp AS detail,
		coalesce(ts.ticketStatus, ist.issueStatus, '') as status,
		u1.name AS createdByUsr,
		u2.name AS asignee
	FROM (
		SELECT * FROM (
			SELECT @rowNumber := IF(coalesce(ticketId, serviceOrderId, issueId) = @prevRefId, @rowNumber + 1, 1) AS RowNum,
				f.*, 
				@prevRefId := coalesce(ticketId, serviceOrderId, issueId) AS PrevRef
			FROM followUp f
			ORDER BY followUpReferenceTypeId, coalesce(ticketId, serviceOrderId, issueId), created DESC
		) a WHERE a.RowNum = 1 AND asignee = pUser -- a: todos los followUps asignados al usuario, numerados por id de (ticket, so, issue)
	) f -- f: el ultimo comentario de cada (ticket, so, issue) y que esta asignado al usuario
		INNER JOIN followUpReferenceType r ON f.followUpReferenceTypeId = r.followUpReferenceTypeId
		LEFT OUTER JOIN ticket t ON f.ticketId = t.ticketId
		LEFT OUTER JOIN serviceOrder s ON s.serviceOrderId = f.serviceOrderId
		LEFT OUTER JOIN issue i ON i.issueId = f.issueId
		LEFT OUTER JOIN policy p ON coalesce(t.policyId, s.policyId) = p.policyId
		LEFT OUTER JOIN openCustomer c ON s.openCustomerId = c.openCustomerId
		LEFT OUTER JOIN ticketStatus ts ON ts.ticketStatusId = t.ticketStatusId
		LEFT OUTER JOIN serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER JOIN issueStatus ist ON ist.issueStatusId = i.issueStatusId
		INNER JOIN blackstarUser u1 ON f.createdByUsr = u1.email
		INNER JOIN blackstarUser u2 ON f.asignee = u2.email
	WHERE coalesce(t.asignee, s.asignee, i.asignee) = pUser
	AND coalesce(t.ticketStatusId, s.serviceStatusId, i.issueStatusId) NOT IN ('C', 'F')
	ORDER BY f.created;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetScheduledServiceDates
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetScheduledServiceDates$$
CREATE PROCEDURE blackstarDb.GetScheduledServiceDates(pScheduledServiceId INT)
BEGIN

	SELECT 
		s.serviceDate as serviceDate
	FROM scheduledServiceDate s 
	WHERE s.scheduledServiceId = pScheduledServiceId
	ORDER BY s.serviceDate;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetScheduledServicePolicies
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetScheduledServicePolicies$$
CREATE PROCEDURE blackstarDb.GetScheduledServicePolicies(pScheduledServiceId INT)
BEGIN

	SELECT 
		s.policyId as policyId
	FROM scheduledServicePolicy s 
	WHERE s.scheduledServiceId = pScheduledServiceId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetScheduledServiceEmployees
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetScheduledServiceEmployees$$
CREATE PROCEDURE blackstarDb.GetScheduledServiceEmployees(pScheduledServiceId INT)
BEGIN

	SELECT 
		e.employeeId as employeeId
	FROM scheduledService s 
		INNER JOIN scheduledServiceEmployee e ON s.scheduledServiceId = e.scheduledServiceId
	WHERE s.scheduledServiceId = pScheduledServiceId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetScheduledServiceById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetScheduledServiceById$$
CREATE PROCEDURE blackstarDb.GetScheduledServiceById(pScheduledServiceId INT)
BEGIN
	
	SELECT * 
	FROM scheduledService 
	WHERE scheduledServiceId = pScheduledServiceId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.UpdateTicketArrival
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpdateTicketArrival$$
CREATE PROCEDURE blackstarDb.UpdateTicketArrival(pTicketId INT, pArrival DATETIME, pModifiedBy VARCHAR(100), pUser VARCHAR(100))
BEGIN

	UPDATE ticket t 
		INNER JOIN policy p ON t.policyId = p.policyId SET
		t.arrival = pArrival,
		t.realResponseTime = TIMESTAMPDIFF(HOUR, t.created, pArrival),
		t.responseTimeDeviationHr = CASE WHEN(TIMESTAMPDIFF(HOUR, t.created, pArrival) < responseTimeHR) THEN 0 ELSE (TIMESTAMPDIFF(HOUR, t.created, pArrival) - responseTimeHR) END,
		t.modified = NOW(),
		t.modifiedBy = pModifiedBy,
		t.modifiedByUsr = pUser
	WHERE ticketId = pTicketId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEquipmentTypeList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentTypeList$$
CREATE PROCEDURE blackstarDb.GetEquipmentTypeList()
BEGIN

	SELECT * 
	FROM equipmentType
	ORDER BY equipmentType;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAvailabilityKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAvailabilityKPI$$
CREATE PROCEDURE blackstarDb.GetAvailabilityKPI(pProject VARCHAR(100), pStartDate DATETIME, pEndDate DATETIME, customer VARCHAR(100))
BEGIN
	-- Variables auxiliares para calculos
	DECLARE elapsedHr INT; 
	DECLARE equipmentNum INT; 
	DECLARE downTimeSum INT; 
	DECLARE equipmentHr INT; 
	DECLARE availability DECIMAL(5,2); 
	DECLARE averageSolutionTime INT;
	DECLARE totalTickets INT;
	DECLARE totalClosedTickets INT;
	DECLARE totalAttendedTickets INT;
	DECLARE onTimeResolvedTickets	DECIMAL(5,2);
	DECLARE onTimeAttendedTickets DECIMAL(5,2);

	-- Tabla temporal con los equipos en scope
	CREATE TEMPORARY TABLE IF NOT EXISTS selectedEquipment(
		policyId INT,
		solutionTimeHR INT,
		responseTimeHR INT,
		timeAlive	INT
	) ENGINE = MEMORY;

	IF customer = '' THEN 
		IF pProject = 'All' THEN
			INSERT INTO selectedEquipment(policyId, solutionTimeHR, responseTimeHR, timeAlive) 
			SELECT policyId, solutionTimeHR, responseTimeHR,
				(DATEDIFF(CASE WHEN (endDate < pEndDate) THEN endDate ELSE pEndDate END, CASE WHEN (pStartDate > startDate) THEN pStartDate ELSE startDate END) * 24)
			FROM policy 
			WHERE NOT (endDate < pStartDate OR startDate > pEndDate);
		ELSE
			INSERT INTO selectedEquipment(policyId, solutionTimeHR, responseTimeHR, timeAlive) 
			SELECT policyId, solutionTimeHR, responseTimeHR,
				(DATEDIFF(CASE WHEN (endDate < pEndDate) THEN endDate ELSE pEndDate END, CASE WHEN (pStartDate > startDate) THEN pStartDate ELSE startDate END) * 24)
			FROM policy 
			WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
				AND project = pProject;
		END IF;
	ELSE
		IF pProject = 'All' THEN
			INSERT INTO selectedEquipment(policyId, solutionTimeHR, responseTimeHR, timeAlive) 
			SELECT p.policyId, solutionTimeHR, responseTimeHR,
				(DATEDIFF(CASE WHEN (endDate < pEndDate) THEN endDate ELSE pEndDate END, CASE WHEN (pStartDate > startDate) THEN pStartDate ELSE startDate END) * 24)
			FROM policy p 
			INNER JOIN policyEquipmentUser pe ON p.policyId = pe.policyId
			WHERE pe.equipmentUserId = customer 
				AND NOT (endDate < pStartDate OR startDate > pEndDate);
		ELSE
			INSERT INTO selectedEquipment(policyId, solutionTimeHR, responseTimeHR, timeAlive) 
			SELECT p.policyId, solutionTimeHR, responseTimeHR,
				(DATEDIFF(CASE WHEN (endDate < pEndDate) THEN endDate ELSE pEndDate END, CASE WHEN (pStartDate > startDate) THEN pStartDate ELSE startDate END) * 24)
			FROM policy p 
			INNER JOIN policyEquipmentUser pe ON p.policyId = pe.policyId
			WHERE pe.equipmentUserId = customer 
				AND NOT (endDate < pStartDate OR startDate > pEndDate)
				AND project = pProject;
		END IF;
	END IF;

	-- CALCULOS DISPONIBILIDAD

	-- tiempo transcurrido en horas
	SELECT sum(timeAlive) FROM selectedEquipment INTO equipmentHr;

	-- sumatoria de horas-equipo fuera
	SELECT sum(solutionTime) INTO downTimeSum
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate;

	-- porcentaje de disponibilidad
	SELECT ((equipmentHr - ifnull(downTimeSum, 0)) / equipmentHr) * 100 INTO availability;

	-- tiempo promedio de solucion
	SELECT avg(solutionTime) INTO averageSolutionTime
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate;

	-- TICKETS SOLUCIONADOS EN TIEMPO

	-- numero total de tickets
	SELECT count(*) INTO totalTickets
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate;

	-- numero de tickets cerrados en scope 
	SELECT count(*) INTO totalClosedTickets
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate
			AND t.solutionTime IS NOT NULL;

	-- numero de tickets atendidos en scope
	SELECT count(*) INTO totalAttendedTickets
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate
			AND t.realResponseTime IS NOT NULL;

	SELECT (count(*) / totalClosedTickets) * 100 INTO onTimeResolvedTickets
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate
			AND t.solutionTime <= e.solutionTimeHR;

	-- tickets atendidos a tiempo
	SELECT (count(*) / totalAttendedTickets) * 100 INTO onTimeAttendedTickets
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate
			AND t.realResponseTime <= e.responseTimeHR;

	-- se elimina la tabla temporal
	DROP TABLE selectedEquipment;
	
	-- datos de retorno
	SELECT 	availability AS availability,
			averageSolutionTime AS solutionAverageTime,
			onTimeResolvedTickets AS onTimeResolvedTickets,
			onTimeAttendedTickets AS onTimeAttendedTickets,
			totalTickets AS totalTickets;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedProjectList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedProjectList$$
CREATE PROCEDURE blackstarDb.GetLimitedProjectList(pUser VARCHAR(100))
BEGIN

	SELECT DISTINCT 
		p.project as project
	FROM blackstarDb.policy p
		INNER JOIN policyEquipmentUser pe ON p.policyId = pe.policyId
	WHERE p.startDate <= NOW() AND NOW() <= p.endDate
	AND pe.equipmentUserId = pUser
	ORDER BY project;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedSurveyServiceList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedSurveyServiceList$$
CREATE PROCEDURE blackstarDb.GetLimitedSurveyServiceList(pUser VARCHAR(100))
BEGIN
	
	SELECT DISTINCT
		s.surveyServiceId AS DT_RowId,
		s.surveyServiceId AS surveyServiceNumber,
		p.customer AS customer,
		p.project AS project,
		s.surveyDate AS surveyDate,
		s.score AS score
	FROM surveyService s
		INNER JOIN serviceOrder o ON o.surveyServiceId = s.surveyServiceId
		INNER JOIN policy p ON o.policyId = p.policyId
		INNER JOIN policyEquipmentUser pe ON p.policyId = pe.policyId
    WHERE pe.equipmentUserId = pUser
	ORDER BY surveyDate DESC;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedServiceOrderList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedServiceOrderList$$
CREATE PROCEDURE blackstarDb.GetLimitedServiceOrderList(pUser VARCHAR(100))
BEGIN
	SELECT 
		so.ServiceOrderId AS DT_RowId,
		so.serviceOrderNumber AS serviceOrderNumber,
		'' AS placeHolder,
		IFNULL(t.ticketNumber, '') AS ticketNumber,
		st.serviceType AS serviceType,
		DATE(so.serviceDate) AS serviceDate,
		p.customer AS customer,
		et.equipmentType AS equipmentType,
		p.project AS project,
		of.officeName AS officeName,
		p.brand AS brand,
		p.serialNumber AS serialNumber,
		ss.serviceStatus AS serviceStatus,
		so.hasPdf AS hasPdf,
		sc.serviceCenter AS serviceCenter
	FROM serviceOrder so 
		INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
		INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
		INNER JOIN policy p ON so.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
		INNER JOIN office of on p.officeId = of.officeId
		INNER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
		INNER JOIN policyEquipmentUser pe ON p.policyId = pe.policyId
    	LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
    WHERE pe.equipmentUserId = pUser
	ORDER BY so.serviceDate DESC;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedServiceOrders
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedServiceOrders$$
CREATE PROCEDURE blackstarDb.GetLimitedServiceOrders(status VARCHAR(200), pUser VARCHAR(100))
BEGIN

	SELECT 
		so.ServiceOrderId AS DT_RowId,
		so.serviceOrderNumber AS serviceOrderNumber,
		'' AS placeHolder,
		IFNULL(t.ticketNumber, '') AS ticketNumber,
		st.serviceType AS serviceType,
		DATE(so.serviceDate) AS created,
		p.customer AS customer,
		et.equipmentType AS equipmentType,
		p.project AS project,
		of.officeName AS officeName,
		p.brand AS brand,
		p.serialNumber AS serialNumber,
		ss.serviceStatus AS serviceStatus,
		so.hasPdf AS hasPdf,
		sc.serviceCenter AS serviceCenter
	FROM serviceOrder so 
		INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
		INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
		INNER JOIN policy p ON so.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
		INNER JOIN office of on p.officeId = of.officeId
		INNER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
		INNER JOIN policyEquipmentUser pe ON p.policyId = pe.policyId
     	LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
	WHERE ss.serviceStatus IN(status) 
	AND pe.equipmentUserId = pUser
	ORDER BY serviceDate DESC ;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedTicketList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedTicketList$$
CREATE PROCEDURE blackstarDb.GetLimitedTicketList(pUser VARCHAR(100))
BEGIN
	SELECT 
		t.ticketId AS DT_RowId,
		t.ticketNumber AS ticketNumber,
		t.created AS created,
		p.contactName AS contactName,
		p.serialNumber AS serialNumber,
		p.customer AS customer,
		e.equipmentType AS equipmentType,
		p.responseTimeHR AS responseTimeHR,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		IFNULL(bu.name, t.employee) AS asignee,
		'' AS asignar,
		IFNULL(t.serviceOrderNumber, '') AS serviceOrderNumber
	FROM ticket t
		INNER JOIN policy p ON p.policyId = t.policyId
		INNER JOIN equipmentType e ON e.equipmentTypeId = p.equipmentTypeId
		INNER JOIN ticketStatus ts ON t.ticketStatusId = ts.ticketStatusId
		INNER JOIN policyEquipmentUser pe ON p.policyId = pe.policyId
		LEFT OUTER JOIN blackstarUser bu ON bu.email = t.asignee
	WHERE pe.equipmentUserId = pUser
	ORDER BY created;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetOpenLimitedTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetOpenLimitedTickets$$
CREATE PROCEDURE blackstarDb.GetOpenLimitedTickets(pUser VARCHAR(100))
BEGIN
	SELECT 
		t.ticketId AS DT_RowId,
		t.ticketNumber AS ticketNumber,
		t.created AS ticketDate,
		p.customer AS customer,
		e.equipmentType AS equipmentType,
		p.responseTimeHR AS responseTime,
		p.project AS project,
		p.serialNumber AS serialNumber,
		ts.ticketStatus AS ticketStatus,
		'' AS placeHolder
	FROM ticket t
		INNER JOIN policy p ON p.policyId = t.policyId
		INNER JOIN equipmentType e ON e.equipmentTypeId = p.equipmentTypeId
		INNER JOIN ticketStatus ts ON t.ticketStatusId = ts.ticketStatusId
		INNER JOIN policyEquipmentUser pe ON p.policyId = pe.policyId
	WHERE pe.equipmentUserId = pUser
	AND t.closed IS NULL
	ORDER BY ticketDate;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetOpenCustomerById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetOpenCustomerById$$
CREATE PROCEDURE blackstarDb.GetOpenCustomerById(pOpenCustomerId INT)
BEGIN
	SELECT *
	FROM blackstarDb.openCustomer
	WHERE openCustomerId = pOpenCustomerId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.SaveOpenCustomer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddOpenCustomer$$
DROP PROCEDURE IF EXISTS blackstarDb.SaveOpenCustomer$$
CREATE PROCEDURE blackstarDb.SaveOpenCustomer(
	openCustomerId INT,
	customerName VARCHAR(200),
	address VARCHAR(500),
	phone VARCHAR(100),
	equipmentTypeId CHAR(1),
	brand VARCHAR(100),
	model VARCHAR(100),
	capacity VARCHAR(100),
	serialNumber VARCHAR(100),
	contactName VARCHAR(100),
	contactEmail VARCHAR(100),
	project VARCHAR(100),
	officeId VARCHAR(1),
	createdBy NVARCHAR(50),
	createdByUsr NVARCHAR(50),
	modifiedBy NVARCHAR(50),
	modifiedByUsr NVARCHAR(50)
)
BEGIN
	IF openCustomerId > 0 THEN
		UPDATE openCustomer c SET
			c.customerName = customerName,
			c.address = address,
			c.phone = phone,
			c.equipmentTypeId = equipmentTypeId,
			c.brand = brand,
			c.model = model,
			c.capacity = capacity,
			c.serialNumber = serialNumber,
			c.contactName = contactName,
			c.contactEmail = contactEmail,
			c.project = project,
			c.officeId = officeId,
			c.modified = NOW(),
			c.modifiedBy = modifiedBy,
			c.modifiedByUsr = modifiedByUsr	
		WHERE c.openCustomerId = openCustomerId;
		SELECT openCustomerId;
	ELSE
		INSERT INTO blackstarDb.openCustomer(
			customerName, address, phone, equipmentTypeId, brand, model, capacity, serialNumber, contactName, contactEmail, project, officeId, created, createdBy, createdByUsr
		)
		VALUES(
			customerName, address, phone, equipmentTypeId, brand, model, capacity, serialNumber, contactName, contactEmail, project, officeId, NOW(), createdBy, createdByUsr
		);
		SELECT LAST_INSERT_ID();
	END IF;
	

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetStatisticsKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetStatisticsKPI$$
CREATE PROCEDURE blackstarDb.GetStatisticsKPI(pProject varchar(100), pStartDate DATETIME, pEndDate DATETIME)
BEGIN

DECLARE totalTickets INT;
DECLARE totalPolicies INT;

IF pProject = 'All' THEN
	SELECT count(DISTINCT serialNumber) FROM policy WHERE NOT (endDate < pStartDate OR startDate > pEndDate) INTO totalPolicies;
	SELECT count(*) FROM ticket WHERE (created >= pStartDate AND created <= pEndDate) INTO totalTickets;

	-- RECUPERACION DE DATOS POR PARTES:
	-- A: polizas por proyecto y su contribucion al total
	-- B: tickets por proyecto y su contribucion al total
	-- C: tickets por oficina

	-- SI NO HAY FILTRO POR PROYECTO
	SELECT officeName, 0 AS isTotal, A.project, customer, policyCount AS pNumber, cast(policyContribution AS decimal(5,2)) AS tPolicies, ifnull(ticketCount, 0) AS nReports, ifnull(cast(ticketContribution AS decimal(5,2)), 0) AS tReports, NULL AS oReports
	FROM(
		SELECT p.officeId, officeName, project, customer, count(DISTINCT serialNumber) AS policyCount, (count(DISTINCT serialNumber)/totalPolicies) * 100 AS policyContribution
		FROM policy p
			INNER JOIN office o ON o.officeId = p.officeId
		WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
		GROUP BY project
	) A
	LEFT OUTER JOIN (
		SELECT project, count(*) AS ticketCount, (count(*) / totalTickets) * 100 AS ticketContribution
		FROM ticket t
			INNER JOIN policy p ON t.policyId = p.policyId
		WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
			AND (t.created >= pStartDate AND t.created <= pEndDate)
		GROUP BY project
	) B ON A.project = B.project
	UNION SELECT officeName, 1 AS isTotal, NULL, NULL, NULL, NULL, NULL, NULL, officeReports AS oReports FROM  (
		SELECT officeName, count(*) AS officeReports
		FROM ticket t
			INNER JOIN policy p ON t.policyId = p.policyId
			INNER JOIN office o ON o.officeId = p.officeId
		WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
			AND (t.created >= pStartDate AND t.created <= pEndDate)
		GROUP BY officeName
	) C
	ORDER BY officeName, isTotal, project;
ELSE
	-- SI EXISTE FILTRO POR PROYECTO
	SELECT count(DISTINCT serialNumber) FROM policy WHERE NOT (endDate < pStartDate OR startDate > pEndDate) INTO totalPolicies;
	SELECT count(*) FROM ticket WHERE (created >= pStartDate AND created <= pEndDate) INTO totalTickets;

	SELECT officeName, 0 AS isTotal, A.project, customer, policyCount AS pNumber, cast(policyContribution AS decimal(5,2)) AS tPolicies, ifnull(ticketCount, 0) AS nReports, ifnull(cast(ticketContribution AS decimal(5,2)), 0) AS tReports, NULL AS oReports
	FROM(
		SELECT p.officeId, officeName, project, customer, count(DISTINCT serialNumber) AS policyCount, (count(DISTINCT serialNumber)/totalPolicies) * 100 AS policyContribution
		FROM policy p
			INNER JOIN office o ON o.officeId = p.officeId
		WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
			AND project = pProject 
		GROUP BY project
	) A
	LEFT OUTER JOIN (
		SELECT project, count(*) AS ticketCount, (count(*) / totalTickets) * 100 AS ticketContribution
		FROM ticket t
			INNER JOIN policy p ON t.policyId = p.policyId
		WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
			AND (t.created >= pStartDate AND t.created <= pEndDate)
			AND project = pProject
		GROUP BY project
	) B ON A.project = B.project
	UNION SELECT officeName, 1 AS isTotal, NULL, NULL, NULL, NULL, NULL, NULL, officeReports AS oReports FROM  (
		SELECT officeName, count(*) AS officeReports
		FROM ticket t
			INNER JOIN policy p ON t.policyId = p.policyId
			INNER JOIN office o ON o.officeId = p.officeId
		WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
			AND (t.created >= pStartDate AND t.created <= pEndDate)
			AND project = pProject 
		GROUP BY officeName
	) C 
	ORDER BY officeName, isTotal, project;
END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetGeneralAverageKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetGeneralAverageKPI$$
CREATE PROCEDURE blackstarDb.`GetGeneralAverageKPI`(pProject varchar(100), pStartDate DATETIME, pEndDate DATETIME)
BEGIN
	IF pProject = 'All' THEN
		SELECT * FROM (
			SELECT 
				IFNULL(sc.serviceCenter, sc2.serviceCenter) as office, 
				count(*) as services,
				IFNULL(AVG(ss.score),0) as average
			FROM serviceOrder so
				INNER JOIN surveyService ss ON so.surveyServiceId = ss.surveyServiceId
				LEFT OUTER JOIN policy p ON p.policyId = so.policyId
				LEFT OUTER JOIN openCustomer c ON c.openCustomerId = so.openCustomerId
				LEFT OUTER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
				LEFT OUTER JOIN serviceCenter sc2 ON sc2.serviceCenterId = c.officeId
			WHERE so.created >= pStartDate and so.created <= pEndDate
				AND (so.openCustomerId IS NOT NULL OR so.policyId IS NOT NULL)
			GROUP BY office
		) A 
		UNION
		SELECT 
			'GENERAL' as office,
			count(*) as services,
			IFNULL(AVG(ss.score),0) as average
		FROM serviceOrder so
			INNER JOIN surveyService ss ON so.surveyServiceId = ss.surveyServiceId
			LEFT OUTER JOIN policy p ON p.policyId = so.policyId
			LEFT OUTER JOIN openCustomer c ON c.openCustomerId = so.openCustomerId
			LEFT OUTER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
			LEFT OUTER JOIN serviceCenter sc2 ON sc2.serviceCenterId = c.officeId
		WHERE so.created >= pStartDate and so.created <= pEndDate
			AND (so.openCustomerId IS NOT NULL OR so.policyId IS NOT NULL);
	ELSE
		SELECT * FROM (
			SELECT 
				IFNULL(sc.serviceCenter, sc2.serviceCenter) as office, 
				count(*) as services,
				IFNULL(AVG(ss.score),0) as average
			FROM serviceOrder so
				INNER JOIN surveyService ss ON so.surveyServiceId = ss.surveyServiceId
				LEFT OUTER JOIN policy p ON p.policyId = so.policyId
				LEFT OUTER JOIN openCustomer c ON c.openCustomerId = so.openCustomerId
				LEFT OUTER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
				LEFT OUTER JOIN serviceCenter sc2 ON sc2.serviceCenterId = c.officeId
			WHERE so.created >= pStartDate and so.created <= pEndDate
				AND p.project = pProject
				AND (so.openCustomerId IS NOT NULL OR so.policyId IS NOT NULL)
			GROUP BY office
		) A 
		UNION
		SELECT 
			'GENERAL' as office,
			count(*) as services,
			IFNULL(AVG(ss.score),0) as average
		FROM serviceOrder so
			INNER JOIN surveyService ss ON so.surveyServiceId = ss.surveyServiceId
			LEFT OUTER JOIN policy p ON p.policyId = so.policyId
			LEFT OUTER JOIN openCustomer c ON c.openCustomerId = so.openCustomerId
			LEFT OUTER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
			LEFT OUTER JOIN serviceCenter sc2 ON sc2.serviceCenterId = c.officeId
		WHERE so.created >= pStartDate and so.created <= pEndDate
			AND p.project = pProject
			AND (so.openCustomerId IS NOT NULL OR so.policyId IS NOT NULL);
	END IF;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUserAverageKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserAverageKPI$$
CREATE PROCEDURE blackstarDb.`GetUserAverageKPI`(pProject varchar(100), pStartDate DATETIME, pEndDate DATETIME)
BEGIN
	IF pProject = 'All' THEN
		SELECT 
			se.employeeId as employeeId, 
			bu.name as name,
			COUNT(*) as services,
			AVG(ss.score) as average, 
			SUM(so.isWrong) as wrongOs,
			ifnull(group_concat(if(so.isWrong, so.serviceOrderNumber, null) separator ','), '') AS wrongOsList,
			((COUNT(*) * 5) - SUM(ss.questionTreatment) - SUM(ss.questionIdentificationPersonal) - SUM(ss.questionIdealEquipment) - SUM(ss.questionTime) - SUM(ss.questionUniform)) AS badComments,
			ifnull(group_concat(DISTINCT if((ss.questionTreatment + ss.questionIdentificationPersonal + ss.questionIdealEquipment + ss.questionTime + ss.questionUniform) < 5, ss.surveyServiceId, null) separator ','), '') AS badCommentsOsList
		FROM serviceOrder so 
			INNER JOIN serviceOrderEmployee se on so.serviceOrderId = se.serviceOrderId
			INNER JOIN surveyService ss ON so.surveyServiceId = ss.surveyServiceId
			INNER JOIN blackstarUser bu ON bu.email = se.employeeId
			WHERE so.created >= pStartDate and so.created <= pEndDate
		GROUP BY se.employeeId;
	ELSE
		SELECT 
			se.employeeId as employeeId, 
			bu.name as name,
			AVG(ss.score) as average, 
			SUM(so.isWrong) as wrongOs,
			COUNT(*) as services,
			((COUNT(*) * 5) - SUM(ss.questionTreatment) - SUM(ss.questionIdentificationPersonal) - SUM(questionIdealEquipment) - SUM(questionTime) - SUM(questionUniform)) AS badComments,
			ifnull(group_concat(DISTINCT if((ss.questionTreatment + ss.questionIdentificationPersonal + ss.questionIdealEquipment + ss.questionTime + ss.questionUniform) < 5, ss.surveyServiceId, null) separator ','), '') AS badCommentsOsList
		FROM serviceOrder so 
			INNER JOIN serviceOrderEmployee se on so.serviceOrderId = se.serviceOrderId
			INNER JOIN surveyService ss ON so.surveyServiceId = ss.surveyServiceId
			INNER JOIN blackstarUser bu ON bu.email = se.employeeId
			LEFT OUTER JOIN policy p ON p.policyId = so.policyId
			LEFT OUTER JOIN openCustomer c ON c.openCustomerId = so.openCustomerId
			WHERE so.created >= pStartDate and so.created <= pEndDate
				AND IFNULL(p.project, c.project) = pProject
		GROUP BY se.employeeId;
	END IF;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetSurveyServiceLinkedServices
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetSurveyServiceLinkedServices$$
CREATE PROCEDURE blackstarDb.GetSurveyServiceLinkedServices(pSurveyServiceId INT)
BEGIN

	SELECT 
		serviceOrderNumber AS serviceOrderNumber,
		serviceOrderId AS serviceOrderId
	FROM serviceOrder
	WHERE surveyServiceId = pSurveyServiceId;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddSurveyToServiceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddSurveyToServiceOrder$$
CREATE PROCEDURE blackstarDb.AddSurveyToServiceOrder(pServiceOrderNumber VARCHAR(100), pSurveyServiceId INT, pModifiedBy VARCHAR(100), user VARCHAR(100))
BEGIN

	UPDATE serviceOrder s 
	INNER JOIN surveyService u ON s.serviceOrderNumber = pServiceOrderNumber AND u.surveyServiceId = pSurveyServiceId
	SET
		s.surveyServiceId = pSurveyServiceId,
		s.surveyScore = score,
		s.modified = NOW(),
		s.modifiedBy = pModifiedBy,
		s.modifiedByUsr = user
	WHERE 
		s.serviceOrderNumber = pServiceOrderNumber;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAllSurveyServiceList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllSurveyServiceList$$
CREATE PROCEDURE blackstarDb.GetAllSurveyServiceList()
BEGIN

	SELECT DISTINCT
		s.surveyServiceId AS DT_RowId,
		s.surveyServiceId AS surveyServiceNumber,
		COALESCE(p.customer, c.customerName, '') AS customer,
		COALESCE(p.project, c.project, '') AS project,
		s.surveyDate AS surveyDate,
		s.score AS score
	FROM surveyService s
		INNER JOIN serviceOrder o ON o.surveyServiceId = s.surveyServiceId
		LEFT OUTER JOIN policy p ON o.policyId = p.policyId
		LEFT OUTER JOIN openCustomer c ON c.openCustomerId = o.openCustomerId
	ORDER BY surveyDate DESC;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetPersonalSurveyServiceList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPersonalSurveyServiceList$$
CREATE PROCEDURE blackstarDb.GetPersonalSurveyServiceList(pUser VARCHAR(100))
BEGIN

	SELECT 
		s.surveyServiceId AS DT_RowId,
		s.surveyServiceId AS surveyServiceNumber,
		ifnull(p.customer, oc.customerName) AS customer,
		ifnull(p.project, oc.project) AS project,
		s.surveyDate AS surveyDate,
		s.score AS score
	FROM surveyService s
		INNER JOIN serviceOrder o ON o.surveyServiceId = s.surveyServiceId
		LEFT OUTER JOIN policy p ON o.policyId = p.policyId
		LEFT OUTER JOIN openCustomer oc ON o.openCustomerId = oc.openCustomerId
		INNER JOIN serviceOrderEmployee e ON e.serviceOrderId = o.serviceOrderId
	WHERE
		e.employeeId = pUser;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAutocompleteEmployeeList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAutocompleteEmployeeList$$
CREATE PROCEDURE blackstarDb.GetAutocompleteEmployeeList(pUserGroup VARCHAR(100))
BEGIN

	SELECT 
		u.name AS label,
		u.email AS value
	FROM blackstarUser_userGroup ug
		INNER JOIN blackstarUser u ON u.blackstarUserId = ug.blackstarUserId
		INNER JOIN userGroup g ON g.userGroupId = ug.userGroupId
	WHERE g.name = pUserGroup
	ORDER BY u.name;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddServiceOrderEmployee
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddServiceOrderEmployee$$
CREATE PROCEDURE blackstarDb.AddServiceOrderEmployee(pSoId INTEGER, pEmployee VARCHAR(100), pCreated DATETIME, pCreatedBy VARCHAR(100), pCreatedByUsr VARCHAR(100))
BEGIN

	INSERT INTO serviceOrderEmployee(
		serviceOrderId,
		employeeId,
		created,
		createdBy,
		createdByUsr
	)
	SELECT
		pSoId,
		pEmployee,
		pCreated,
		pCreatedBy,
		pCreatedByUsr;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrderEmployeeList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrderEmployeeList$$
CREATE PROCEDURE blackstarDb.GetServiceOrderEmployeeList(pSoId INTEGER)
BEGIN

	SELECT 
		email as email,
		name as name
	FROM serviceOrderEmployee s
		INNER JOIN blackstarUser u ON s.employeeId = u.email
	WHERE serviceOrderId = pSoId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrderByNumber
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrderByNumber$$
CREATE PROCEDURE blackstarDb.GetServiceOrderByNumber(pSoNumber VARCHAR(100))
BEGIN

	SELECT *
	FROM serviceOrder s
	WHERE serviceOrderNumber = pSoNumber;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrderById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrderById$$
CREATE PROCEDURE blackstarDb.GetServiceOrderById(pId INTEGER)
BEGIN

	SELECT *
	FROM serviceOrder s
	WHERE serviceOrderId = pId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.LastError
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.LastError$$
CREATE PROCEDURE blackstarDb.LastError()
BEGIN

	SELECT error FROM blackstarManage.errorLog
	ORDER BY errorLogId DESC 
	LIMIT 2;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceCenterIdList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceCenterIdList$$
CREATE PROCEDURE blackstarDb.`GetServiceCenterIdList`()
BEGIN
SELECT *
FROM serviceCenter;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetStatusKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetStatusKPI$$
CREATE PROCEDURE blackstarDb.`GetStatusKPI`(pType CHAR(1), pProject varchar(100), startDate DATETIME, endDate DATETIME, pUser VARCHAR(100))
BEGIN
IF pProject = 'All' THEN
	IF pUser = '' THEN
		SELECT ts.ticketStatus as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND sc.serviceCenterId LIKE pType
		GROUP BY tk.ticketStatusId
		ORDER BY ticketStatus;
	ELSE
		SELECT ts.ticketStatus as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
			INNER JOIN policyEquipmentUser pe ON py.policyId = pe.policyId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND sc.serviceCenterId LIKE pType
			AND pe.equipmentUserId = pUser
		GROUP BY tk.ticketStatusId
		ORDER BY ticketStatus;
	END IF;
ELSE
	IF pUser = '' THEN
		SELECT ts.ticketStatus as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND sc.serviceCenterId LIKE pType
			AND py.project = pProject
		GROUP BY tk.ticketStatusId
		ORDER BY ticketStatus;
	ELSE
		SELECT ts.ticketStatus as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
			INNER JOIN policyEquipmentUser pe ON py.policyId = pe.policyId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND sc.serviceCenterId LIKE pType
			AND py.project = pProject
			AND pe.equipmentUserId = pUser
		GROUP BY tk.ticketStatusId
		ORDER BY ticketStatus;
	END IF;
END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetTicketsByServiceCenterKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetTicketsByServiceCenterKPI$$
CREATE PROCEDURE blackstarDb.GetTicketsByServiceCenterKPI(pProject varchar(100), startDate DATETIME, endDate DATETIME, pUser VARCHAR(100))
BEGIN
IF pProject = 'All' THEN
	IF pUser = '' THEN
		SELECT sc.serviceCenter as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
		WHERE tk.created >= startDate AND tk.created <= endDate
		GROUP BY sc.serviceCenter;
	ELSE
		SELECT sc.serviceCenter as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN policyEquipmentUser pe ON py.policyId = pe.policyId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND pe.equipmentUserId = pUser
		GROUP BY sc.serviceCenter;
	END IF;
ELSE
	IF pUser = '' THEN
		SELECT sc.serviceCenter as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND py.project = pProject
		GROUP BY sc.serviceCenter;
	ELSE
		SELECT sc.serviceCenter as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN policyEquipmentUser pe ON py.policyId = pe.policyId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND py.project = pProject
			AND pe.equipmentUser = pUser
		GROUP BY sc.serviceCenter;
	END IF;
END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetReportsByEquipmentTypeKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetReportsByEquipmentTypeKPI$$
CREATE PROCEDURE blackstarDb.GetReportsByEquipmentTypeKPI(pProject varchar(100), startDate DATETIME, endDate DATETIME, pUser VARCHAR(100))
BEGIN
IF pProject = 'All' THEN
	IF pUser = '' THEN
		SELECT et.equipmentType as name , count(*) as value
		FROM ticket tk
			INNER JOIN policy py on py.policyId = tk.policyId
			INNER JOIN equipmentType et ON et.equipmentTypeId = py.equipmentTypeId
		WHERE tk.created >= startDate AND tk.created <= endDate
		GROUP BY py.equipmentTypeId;
	ELSE
		SELECT et.equipmentType as name , count(*) as value
		FROM ticket tk
		INNER JOIN policy py on py.policyId = tk.policyId
		INNER JOIN equipmentType et ON et.equipmentTypeId = py.equipmentTypeId
		INNER JOIN policyEquipmentUser pe ON py.policyId = pe.policyId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND pe.equipmentUserId = pUser
		GROUP BY py.equipmentTypeId;
	END IF;
ELSE
	IF pUser = '' THEN
		SELECT et.equipmentType as name , count(*) as value
		FROM ticket tk
			INNER JOIN policy py on py.policyId = tk.policyId
			INNER JOIN equipmentType et ON et.equipmentTypeId = py.equipmentTypeId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND py.project = pProject
		GROUP BY py.equipmentTypeId;
	ELSE
		SELECT et.equipmentType as name , count(*) as value
		FROM ticket tk
			INNER JOIN policy py on py.policyId = tk.policyId
			INNER JOIN equipmentType et ON et.equipmentTypeId = py.equipmentTypeId
			INNER JOIN policyEquipmentUser pe ON py.policyId = pe.policyId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND py.project = pProject
			AND pe.equipmentUserId = pUser
		GROUP BY py.equipmentTypeId;
	END IF;
END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetResumeOSKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetResumeOSKPI$$
CREATE PROCEDURE blackstarDb.`GetResumeOSKPI`()
BEGIN
SELECT so.serviceUnit as serviceUnit,
       py.project as project,
       py.customer as customer,
       py.equipmentLocation as equipmentLocation,
       py.equipmentAddress as equipmentAddress,
       so.serviceTypeId as serviceTypeId,
       so.serviceOrderNumber as serviceOrderNumber,
       so.ticketId as ticketId,
       so.created as created,
       py.equipmentTypeId as equipmentTypeId,
       py.brand as brand,
       py.model as model,
       py.serialNumber as serialNumber,
       py.capacity as capacity,
       so.responsible as responsible,
       so.receivedBy as receivedBy,
       so.serviceComments as serviceComments,
       IFNULL(so.closed, '') as closed,
       IFNULL(so.hasErrors, '0') as hasErrors,
       '' as materialUsed,
       py.cst as cst,
       py.finalUser as finalUser,
       ss.qualification as qualification,
       ss.comments as comments
FROM serviceOrder so
INNER JOIN surveyService ss on so.serviceOrderId = ss.serviceOrderId
INNER JOIN policy py on so.policyId = py.policyId
WHERE so.created >= STR_TO_DATE(CONCAT('01-01-',YEAR(NOW())),'%d-%m-%Y');
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetReportOSResumeKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetReportOSResumeKPI$$
CREATE PROCEDURE blackstarDb.`GetReportOSResumeKPI`()
BEGIN
SELECT so.serviceUnit office, count(*) numServiceOrders, survey.obCount numObervations
FROM serviceOrder so
INNER JOIN (SELECT so.serviceUnit, count(*) obCount
            FROM surveyService ss
            INNER JOIN serviceOrder so on so.serviceOrderId = ss.serviceOrderId
            WHERE ss.datePerson >= STR_TO_DATE(CONCAT('01-01-',YEAR(NOW())),'%d-%m-%Y')
            GROUP BY so.serviceUnit) AS survey ON so.serviceUnit = survey.serviceUnit 
WHERE so.closed >= STR_TO_DATE(CONCAT('01-01-',YEAR(NOW())),'%d-%m-%Y')
GROUP BY so.serviceUnit;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetReportOSTableKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetReportOSTableKPI$$
CREATE PROCEDURE blackstarDb.`GetReportOSTableKPI`()
BEGIN
SELECT os.serviceOrderId as serviceOrderId
       , ss.comments as comments
       , ss.serviceComments as serviceComments
       , os.responsible as responsible
       , os.serviceUnit as office
FROM serviceOrder os
INNER JOIN surveyService ss on os.serviceOrderId = ss.serviceOrderId
ORDER BY office ASC;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetMaxReportsByUserKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetMaxReportsByUserKPI$$
CREATE PROCEDURE blackstarDb.GetMaxReportsByUserKPI(project varchar(200), startDate datetime, endDate datetime)
BEGIN
IF(project = 'All') THEN
	SELECT ifnull(tk.contactEmail, 'Sin usuario') as employee,
	       py.customer as customer,
	       tk.created as created,
	       count(*) counter,
	       group_concat(tk.ticketNumber separator ', ') as ticketList
	FROM ticket tk
		INNER JOIN policy py ON tk.policyId = py.policyId
	WHERE tk.employee != ''
		AND tk.created >= startDate AND tk.created <= endDate
	GROUP BY ifnull(tk.contactEmail, 'Sin usuario'), MONTH(tk.created)
	HAVING counter >= 2
	ORDER BY MONTH(tk.created) ASC, counter DESC;
ELSE
	SELECT ifnull(tk.contactEmail, 'Sin usuario') as employee,
	       py.customer as customer,
	       tk.created as created,
	       count(*) counter,
	       group_concat(tk.ticketNumber separator ', ') as ticketList
	FROM ticket tk
		INNER JOIN policy py ON tk.policyId = py.policyId
	WHERE tk.employee != ''
		AND tk.created >= startDate AND tk.created <= endDate
		AND py.project = project
	GROUP BY ifnull(tk.contactEmail, 'Sin usuario'), MONTH(tk.created)
	HAVING counter >= 2
	ORDER BY MONTH(tk.created) ASC, counter DESC;
END IF;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetConcurrentFailuresKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetConcurrentFailuresKPI$$
CREATE PROCEDURE blackstarDb.`GetConcurrentFailuresKPI`(project varchar(200), startDate datetime, endDate datetime, user VARCHAR(100))
BEGIN
	IF project = 'All' THEN
		IF user = '' THEN
			SELECT 
				t1.ticketId, 
				t1.created as created,
				t1.ticketNumber as ticketNumber, 
				p1.customer as customer,
				et.equipmentType as equipmentTypeId,
				p1.brand as brand,
				p1.serialNumber as serialNumber,
				t1.observations as observations,
				t2.ticketNumber as lastTicketNumber,
				t2.closed as lastTicketClosed,
				t2.employee as employee
			FROM ticket t1
			INNER JOIN policy p1 on t1.policyId = p1.policyId
			INNER JOIN equipmentType et ON p1.equipmentTypeId = et.equipmentTypeId
			INNER JOIN policy p2 on p1.equipmentTypeId = p2.equipmentTypeId 
				AND p1.brand = p2.brand 
				AND p1.serialNumber = p2.serialNumber
			INNER JOIN ticket t2  on t2.policyId = p2.policyId 
				AND t2.ticketId = (SELECT t3.ticketId FROM ticket t3 WHERE t3.policyId = p2.policyId AND t3.ticketId < t1.ticketId ORDER BY created DESC LIMIT 1)
				AND DATEDIFF(t1.created, t2.created) <= 15
			WHERE t1.created >= startDate and t1.created <= endDate
			ORDER BY t1.created DESC;
		ELSE
			SELECT
				t1.ticketId, 
				t1.created as created,
				t1.ticketNumber as ticketNumber, 
				p1.customer as customer,
				et.equipmentType as equipmentTypeId,
				p1.brand as brand,
				p1.serialNumber as serialNumber,
				t1.observations as observations,
				t2.ticketNumber as lastTicketNumber,
				t2.closed as lastTicketClosed,
				t2.employee as employee
			FROM ticket t1
			INNER JOIN policy p1 on t1.policyId = p1.policyId
			INNER JOIN equipmentType et ON p1.equipmentTypeId = et.equipmentTypeId
			INNER JOIN policy p2 on p1.equipmentTypeId = p2.equipmentTypeId 
				AND p1.brand = p2.brand 
				AND p1.serialNumber = p2.serialNumber
			INNER JOIN ticket t2  on t2.policyId = p2.policyId 
				AND t2.ticketId = (SELECT t3.ticketId FROM ticket t3 WHERE t3.policyId = p2.policyId AND t3.ticketId < t1.ticketId ORDER BY created DESC LIMIT 1)
				AND DATEDIFF(t1.created, t2.created) <= 15
			INNER JOIN policyEquipmentUser pe ON p1.policyId = pe.policyId
			WHERE t1.created >= startDate and t1.created <= endDate
				AND pe.equipmentUserId = user
			ORDER BY t1.created DESC;
		END IF;
	ELSE
		IF user = '' THEN
			SELECT 
				t1.ticketId, 
				t1.created as created,
				t1.ticketNumber as ticketNumber, 
				p1.customer as customer,
				et.equipmentType as equipmentTypeId,
				p1.brand as brand,
				p1.serialNumber as serialNumber,
				t1.observations as observations,
				t2.ticketNumber as lastTicketNumber,
				t2.closed as lastTicketClosed,
				t2.employee as employee
			FROM ticket t1
			INNER JOIN policy p1 on t1.policyId = p1.policyId
			INNER JOIN equipmentType et ON p1.equipmentTypeId = et.equipmentTypeId
			INNER JOIN policy p2 on p1.equipmentTypeId = p2.equipmentTypeId 
				AND p1.brand = p2.brand 
				AND p1.serialNumber = p2.serialNumber
			INNER JOIN ticket t2  on t2.policyId = p2.policyId 
				AND t2.ticketId = (SELECT t3.ticketId FROM ticket t3 WHERE t3.policyId = p2.policyId AND t3.ticketId < t1.ticketId ORDER BY created DESC LIMIT 1)
				AND DATEDIFF(t1.created, t2.created) <= 15
			WHERE t1.created >= startDate and t1.created <= endDate
			AND p1.project = project
			ORDER BY t1.created DESC;
		ELSE
			SELECT 
				t1.ticketId, 
				t1.created as created,
				t1.ticketNumber as ticketNumber, 
				p1.customer as customer,
				et.equipmentType as equipmentTypeId,
				p1.brand as brand,
				p1.serialNumber as serialNumber,
				t1.observations as observations,
				t2.ticketNumber as lastTicketNumber,
				t2.closed as lastTicketClosed,
				t2.employee as employee
			FROM ticket t1
			INNER JOIN policy p1 on t1.policyId = p1.policyId
			INNER JOIN equipmentType et ON p1.equipmentTypeId = et.equipmentTypeId
			INNER JOIN policy p2 on p1.equipmentTypeId = p2.equipmentTypeId 
				AND p1.brand = p2.brand 
				AND p1.serialNumber = p2.serialNumber
			INNER JOIN ticket t2  on t2.policyId = p2.policyId 
				AND t2.ticketId = (SELECT t3.ticketId FROM ticket t3 WHERE t3.policyId = p2.policyId AND t3.ticketId < t1.ticketId ORDER BY created DESC LIMIT 1)
				AND DATEDIFF(t1.created, t2.created) <= 15
			INNER JOIN policyEquipmentUser pe ON p1.policyId = pe.policyId
			WHERE t1.created >= startDate and t1.created <= endDate
			AND p1.project = project
			AND pe.equipmentUserId = user 
			ORDER BY t1.created DESC;
		END IF;
		
	END IF;
	

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetPoliciesKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPoliciesKPI$$
CREATE PROCEDURE blackstarDb.`GetPoliciesKPI`(search VARCHAR(100), pProject VARCHAR(100), pStartDate DATETIME, pEndDate DATETIME, pUser VARCHAR(100), includeRenewed INTEGER)
BEGIN
	CREATE TEMPORARY TABLE policiesKpi(policyId INTEGER, serialNumber VARCHAR(400), equipmentTypeId CHAR(1), brand VARCHAR(400), model VARCHAR(400));

	IF includeRenewed = 1 THEN
		INSERT INTO policiesKpi(policyId, serialNumber, equipmentTypeId, brand, model)
		SELECT policyId, serialNumber, equipmentTypeId, brand, model FROM policy;
	ELSE
		INSERT INTO policiesKpi(policyId, serialNumber, equipmentTypeId, brand, model)
		SELECT p1.policyId, p1.serialNumber, p1.equipmentTypeId, p1.brand, p1.model
		FROM policy p1 
			LEFT OUTER JOIN policy p2 ON p1.serialNumber = p2.serialNumber 
				AND p1.equipmentTypeId = p2.equipmentTypeId
				AND p1.brand = p2.brand
				AND p1.model = p2.model
				AND p2.endDate > p1.endDate
		WHERE p2.policyId IS NULL;
	END IF;

	IF pProject = 'ALL' THEN
		IF pUser = '' THEN
			SELECT py.policyId as policyId,
		       IFNULL(of.officeName, '') as officeName,
		       IFNULL(py.policyTypeId, '') as  policyTypeId,
		       IFNULL(py.customerContract, '') as customerContract,
		       IFNULL(py.customer, '') as customer,
		       IFNULL(py.finalUser, '') as finalUser,
		       IFNULL(py.project, '') as project,
		       IFNULL(py.cst, '') as cst,
		       IFNULL(eq.equipmentType, '') as equipmentType,
		       IFNULL(py.brand, '') as brand,
		       IFNULL(py.model, '') as model,
		       IFNULL(py.serialNumber, '') as serialNumber,
		       IFNULL(py.capacity, '') as capacity,
		       IFNULL(py.equipmentAddress, '') as equipmentAddress,
		       IFNULL(py.equipmentLocation, '') as equipmentLocation,
		       IFNULL(py.contactName, '') as contactName,
		       IFNULL(py.contactEmail, '') as contactEmail,
		       IFNULL(py.contactPhone, '') as contactPhone,
		       IFNULL(py.startDate, '') as startDate,
		       IFNULL(py.endDate, '') as endDate,
		       IFNULL(py.visitsPerYear, '') as visitsPerYear,
		       IFNULL(py.responseTimeHR, '') as responseTimeHR,
		       IFNULL(py.solutionTimeHR, '') as solutionTimeHR,
		       IFNULL(py.penalty, '') as penalty,
		       IFNULL(py.service, '') as service,
		       IFNULL(py.includesParts, '') as includesParts,
		       IFNULL(py.exceptionParts, '') as exceptionParts,
		       IFNULL(sc.serviceCenter, '') as serviceCenter
			FROM policy py
			INNER JOIN office of ON py.officeId = of.officeId
			INNER JOIN equipmentType eq ON eq.equipmentTypeId = py.equipmentTypeId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN policiesKpi pk ON pk.policyId = py.policyId
			WHERE py.endDate >= DATE_ADD(pStartDate, INTERVAL -2 MONTH) AND py.startDate < pEndDate
				AND (of.officeName LIKE CONCAT('%', search, '%') OR
				py.customerContract LIKE CONCAT('%', search, '%') OR
				py.customer LIKE CONCAT('%', search, '%') OR
				py.project LIKE CONCAT('%', search, '%') OR
				py.cst LIKE CONCAT('%', search, '%') OR
				py.brand LIKE CONCAT('%', search, '%') OR
				py.model LIKE CONCAT('%', search, '%') OR
				py.serialNumber LIKE CONCAT('%', search, '%') OR
				py.contactName LIKE CONCAT('%', search, '%')) 
			ORDER BY py.endDate ASC;
		ELSE
			SELECT py.policyId as policyId,
		       IFNULL(of.officeName, '') as officeName,
		       IFNULL(py.policyTypeId, '') as  policyTypeId,
		       IFNULL(py.customerContract, '') as customerContract,
		       IFNULL(py.customer, '') as customer,
		       IFNULL(py.finalUser, '') as finalUser,
		       IFNULL(py.project, '') as project,
		       IFNULL(py.cst, '') as cst,
		       IFNULL(eq.equipmentType, '') as equipmentType,
		       IFNULL(py.brand, '') as brand,
		       IFNULL(py.model, '') as model,
		       IFNULL(py.serialNumber, '') as serialNumber,
		       IFNULL(py.capacity, '') as capacity,
		       IFNULL(py.equipmentAddress, '') as equipmentAddress,
		       IFNULL(py.equipmentLocation, '') as equipmentLocation,
		       IFNULL(py.contactName, '') as contactName,
		       IFNULL(py.contactEmail, '') as contactEmail,
		       IFNULL(py.contactPhone, '') as contactPhone,
		       IFNULL(py.startDate, '') as startDate,
		       IFNULL(py.endDate, '') as endDate,
		       IFNULL(py.visitsPerYear, '') as visitsPerYear,
		       IFNULL(py.responseTimeHR, '') as responseTimeHR,
		       IFNULL(py.solutionTimeHR, '') as solutionTimeHR,
		       IFNULL(py.penalty, '') as penalty,
		       IFNULL(py.service, '') as service,
		       IFNULL(py.includesParts, '') as includesParts,
		       IFNULL(py.exceptionParts, '') as exceptionParts,
		       IFNULL(sc.serviceCenter, '') as serviceCenter
			FROM policy py
			INNER JOIN office of ON py.officeId = of.officeId
			INNER JOIN equipmentType eq ON eq.equipmentTypeId = py.equipmentTypeId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN policiesKpi pk ON pk.policyId = py.policyId
			INNER JOIN policyEquipmentUser pe ON py.policyId = pe.policyId
			WHERE py.endDate >= DATE_ADD(pStartDate, INTERVAL -2 MONTH) AND py.startDate < pEndDate
				AND (of.officeName LIKE CONCAT('%', search, '%') OR
				py.customerContract LIKE CONCAT('%', search, '%') OR
				py.customer LIKE CONCAT('%', search, '%') OR
				py.project LIKE CONCAT('%', search, '%') OR
				py.cst LIKE CONCAT('%', search, '%') OR
				py.brand LIKE CONCAT('%', search, '%') OR
				py.model LIKE CONCAT('%', search, '%') OR
				py.serialNumber LIKE CONCAT('%', search, '%') OR
				py.contactName LIKE CONCAT('%', search, '%')) 
				AND	pe.equipmentUserId = pUser
			ORDER BY py.endDate ASC;
		END IF;
		
	ELSE
		IF pUser = '' THEN
			SELECT py.policyId as policyId,
			       IFNULL(of.officeName, '') as officeName,
			       IFNULL(py.policyTypeId, '') as  policyTypeId,
			       IFNULL(py.customerContract, '') as customerContract,
			       IFNULL(py.customer, '') as customer,
			       IFNULL(py.finalUser, '') as finalUser,
			       IFNULL(py.project, '') as project,
			       IFNULL(py.cst, '') as cst,
			       IFNULL(eq.equipmentType, '') as equipmentType,
			       IFNULL(py.brand, '') as brand,
			       IFNULL(py.model, '') as model,
			       IFNULL(py.serialNumber, '') as serialNumber,
			       IFNULL(py.capacity, '') as capacity,
			       IFNULL(py.equipmentAddress, '') as equipmentAddress,
			       IFNULL(py.equipmentLocation, '') as equipmentLocation,
			       IFNULL(py.contactName, '') as contactName,
			       IFNULL(py.contactEmail, '') as contactEmail,
			       IFNULL(py.contactPhone, '') as contactPhone,
			       IFNULL(py.startDate, '') as startDate,
			       IFNULL(py.endDate, '') as endDate,
			       IFNULL(py.visitsPerYear, '') as visitsPerYear,
			       IFNULL(py.responseTimeHR, '') as responseTimeHR,
			       IFNULL(py.solutionTimeHR, '') as solutionTimeHR,
			       IFNULL(py.penalty, '') as penalty,
			       IFNULL(py.service, '') as service,
			       IFNULL(py.includesParts, '') as includesParts,
			       IFNULL(py.exceptionParts, '') as exceptionParts,
			       IFNULL(sc.serviceCenter, '') as serviceCenter
			FROM policy py
			INNER JOIN office of ON py.officeId = of.officeId
			INNER JOIN equipmentType eq ON eq.equipmentTypeId = py.equipmentTypeId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN policiesKpi pk ON pk.policyId = py.policyId
			WHERE py.endDate >= DATE_ADD(pStartDate, INTERVAL -2 MONTH) AND py.startDate < pEndDate
			AND (of.officeName LIKE CONCAT('%', search, '%') OR
				py.customerContract LIKE CONCAT('%', search, '%') OR
				py.customer LIKE CONCAT('%', search, '%') OR
				py.project LIKE CONCAT('%', search, '%') OR
				py.cst LIKE CONCAT('%', search, '%') OR
				py.brand LIKE CONCAT('%', search, '%') OR
				py.model LIKE CONCAT('%', search, '%') OR
				py.serialNumber LIKE CONCAT('%', search, '%') OR
				py.contactName LIKE CONCAT('%', search, '%')) 
			AND project = pProject
			ORDER BY py.endDate ASC;
		ELSE
			SELECT py.policyId as policyId,
			       IFNULL(of.officeName, '') as officeName,
			       IFNULL(py.policyTypeId, '') as  policyTypeId,
			       IFNULL(py.customerContract, '') as customerContract,
			       IFNULL(py.customer, '') as customer,
			       IFNULL(py.finalUser, '') as finalUser,
			       IFNULL(py.project, '') as project,
			       IFNULL(py.cst, '') as cst,
			       IFNULL(eq.equipmentType, '') as equipmentType,
			       IFNULL(py.brand, '') as brand,
			       IFNULL(py.model, '') as model,
			       IFNULL(py.serialNumber, '') as serialNumber,
			       IFNULL(py.capacity, '') as capacity,
			       IFNULL(py.equipmentAddress, '') as equipmentAddress,
			       IFNULL(py.equipmentLocation, '') as equipmentLocation,
			       IFNULL(py.contactName, '') as contactName,
			       IFNULL(py.contactEmail, '') as contactEmail,
			       IFNULL(py.contactPhone, '') as contactPhone,
			       IFNULL(py.startDate, '') as startDate,
			       IFNULL(py.endDate, '') as endDate,
			       IFNULL(py.visitsPerYear, '') as visitsPerYear,
			       IFNULL(py.responseTimeHR, '') as responseTimeHR,
			       IFNULL(py.solutionTimeHR, '') as solutionTimeHR,
			       IFNULL(py.penalty, '') as penalty,
			       IFNULL(py.service, '') as service,
			       IFNULL(py.includesParts, '') as includesParts,
			       IFNULL(py.exceptionParts, '') as exceptionParts,
			       IFNULL(sc.serviceCenter, '') as serviceCenter
			FROM policy py
			INNER JOIN office of ON py.officeId = of.officeId
			INNER JOIN equipmentType eq ON eq.equipmentTypeId = py.equipmentTypeId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN policiesKpi pk ON pk.policyId = py.policyId
			INNER JOIN policyEquipmentUser pe ON py.policyId = pe.policyId
			WHERE py.endDate >= DATE_ADD(pStartDate, INTERVAL -2 MONTH) AND py.startDate < pEndDate
			AND (of.officeName LIKE CONCAT('%', search, '%') OR
				py.customerContract LIKE CONCAT('%', search, '%') OR
				py.customer LIKE CONCAT('%', search, '%') OR
				py.project LIKE CONCAT('%', search, '%') OR
				py.cst LIKE CONCAT('%', search, '%') OR
				py.brand LIKE CONCAT('%', search, '%') OR
				py.model LIKE CONCAT('%', search, '%') OR
				py.serialNumber LIKE CONCAT('%', search, '%') OR
				py.contactName LIKE CONCAT('%', search, '%'))
			AND pe.equipmentUserId = pUser
			AND project = pProject
			ORDER BY py.endDate ASC;
		END IF;
		
	END IF;

	DROP TEMPORARY TABLE policiesKpi;
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.GetTicketsKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetTicketsKPI$$
CREATE PROCEDURE blackstarDb.`GetTicketsKPI`(pProject VARCHAR(100), pStartDate DATETIME, pEndDate DATETIME, pUser VARCHAR(100))
BEGIN
	IF pProject = 'ALL' THEN
		IF pUser = '' THEN
			SELECT
			tk.ticketId AS DT_RowId,
			tk.ticketNumber AS ticketNumber,
			tk.created AS created,
			p.customer AS customer,
			et.equipmentType AS equipmentType,
			IFNULL(p.brand, '') AS equipmentBrand,
			p.model AS model,
			p.capacity AS capacity,
			p.serialNumber AS serialNumber,
			IFNULL(p.equipmentLocation, '') AS equipmentLocation,
			IFNULL(p.equipmentAddress, '') AS equipmentAddress,
			IF(p.includesParts = 1, 'SI', 'NO') AS includesParts,
			p.exceptionParts AS exceptionParts,
			of.officeName AS officeName,
			p.project AS project,
			IF(tk.phoneResolved = 1, 'SI', 'NO') AS phoneResolved,
			IFNULL(tk.serviceOrderNumber, '') AS serviceOrderNumber,
			ts.ticketStatus AS ticketStatus,
			tk.observations AS observations,
			IFNULL(bu.name, tk.employee) AS asignee,
			IFNULL(tk.arrival, '') AS arrival,
			IFNULL(tk.closed, '') AS closed,
			tk.contact AS contact,
			tk.contactEmail AS contactEmail,
			tk.contactPhone AS contactPhone,
			IFNULL(tk.solutionTime, '') AS solutionTime,
			IF(tk.solutionTimeDeviationHr < 0, 0, IFNULL(tk.solutionTimeDeviationHr, ''))  AS solutionTimeDeviationHr
			FROM ticket tk
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
			INNER JOIN policy p ON tk.policyId = p.policyId
			INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office of on p.officeId = of.officeId
			LEFT OUTER JOIN blackstarUser bu ON bu.email = tk.employee
			WHERE tk.created >= pStartDate AND tk.created <= pEndDate
			ORDER BY tk.created ASC;
		ELSE
			SELECT
			tk.ticketId AS DT_RowId,
			tk.ticketNumber AS ticketNumber,
			tk.created AS created,
			p.customer AS customer,
			et.equipmentType AS equipmentType,
			IFNULL(p.brand, '') AS equipmentBrand,
			p.model AS model,
			p.capacity AS capacity,
			p.serialNumber AS serialNumber,
			IFNULL(p.equipmentLocation, '') AS equipmentLocation,
			IFNULL(p.equipmentAddress, '') AS equipmentAddress,
			IF(p.includesParts = 1, 'SI', 'NO') AS includesParts,
			p.exceptionParts AS exceptionParts,
			of.officeName AS officeName,
			p.project AS project,
			IF(tk.phoneResolved = 1, 'SI', 'NO') AS phoneResolved,
			IFNULL(tk.serviceOrderNumber, '') AS serviceOrderNumber,
			ts.ticketStatus AS ticketStatus,
			tk.observations AS observations,
			IFNULL(bu.name, tk.employee) AS asignee,
			IFNULL(tk.arrival, '') AS arrival,
			IFNULL(tk.closed, '') AS closed,
			tk.contact AS contact,
			tk.contactEmail AS contactEmail,
			tk.contactPhone AS contactPhone,
			IFNULL(tk.solutionTime, '') AS solutionTime,
			IF(tk.solutionTimeDeviationHr < 0, 0, IFNULL(tk.solutionTimeDeviationHr, ''))  AS solutionTimeDeviationHr
			FROM ticket tk
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
			INNER JOIN policy p ON tk.policyId = p.policyId
			INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office of on p.officeId = of.officeId
			INNER JOIN policyEquipmentUser pe ON p.policyId = pe.policyId
			LEFT OUTER JOIN blackstarUser bu ON bu.email = tk.employee
			WHERE tk.created >= pStartDate AND tk.created <= pEndDate
			AND pe.equipmentUserId = pUser
			ORDER BY tk.created ASC;
		END IF;
	ELSE
		IF pUser = '' THEN
			SELECT
			tk.ticketId AS DT_RowId,
			tk.ticketNumber AS ticketNumber,
			tk.created AS created,
			p.customer AS customer,
			et.equipmentType AS equipmentType,
			IFNULL(p.brand, '') AS equipmentBrand,
			p.model AS model,
			p.capacity AS capacity,
			p.serialNumber AS serialNumber,
			IFNULL(p.equipmentLocation, '') AS equipmentLocation,
			IFNULL(p.equipmentAddress, '') AS equipmentAddress,
			IF(p.includesParts = 1, 'SI', 'NO') AS includesParts,
			p.exceptionParts AS exceptionParts,
			of.officeName AS officeName,
			p.project AS project,
			IF(tk.phoneResolved = 1, 'SI', 'NO') AS phoneResolved,
			IFNULL(tk.serviceOrderNumber, '') AS serviceOrderNumber,
			ts.ticketStatus AS ticketStatus,
			tk.observations AS observations,
			IFNULL(bu.name, tk.employee) AS asignee,
			IFNULL(tk.arrival, '') AS arrival,
			IFNULL(tk.closed, '') AS closed,
			tk.contact AS contact,
			tk.contactEmail AS contactEmail,
			tk.contactPhone AS contactPhone,
			IFNULL(tk.solutionTime, '') AS solutionTime,
			IF(tk.solutionTimeDeviationHr < 0, 0, IFNULL(tk.solutionTimeDeviationHr, ''))  AS solutionTimeDeviationHr
			FROM ticket tk
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
			INNER JOIN policy p ON tk.policyId = p.policyId
			INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office of on p.officeId = of.officeId
			LEFT OUTER JOIN blackstarUser bu ON bu.email = tk.employee
			WHERE tk.created >= pStartDate AND tk.created <= pEndDate
			AND p.project = pProject
			ORDER BY tk.created ASC;
		ELSE
			SELECT
			tk.ticketId AS DT_RowId,
			tk.ticketNumber AS ticketNumber,
			tk.created AS created,
			p.customer AS customer,
			et.equipmentType AS equipmentType,
			IFNULL(p.brand, '') AS equipmentBrand,
			p.model AS model,
			p.capacity AS capacity,
			p.serialNumber AS serialNumber,
			IFNULL(p.equipmentLocation, '') AS equipmentLocation,
			IFNULL(p.equipmentAddress, '') AS equipmentAddress,
			IF(p.includesParts = 1, 'SI', 'NO') AS includesParts,
			p.exceptionParts AS exceptionParts,
			of.officeName AS officeName,
			p.project AS project,
			IF(tk.phoneResolved = 1, 'SI', 'NO') AS phoneResolved,
			IFNULL(tk.serviceOrderNumber, '') AS serviceOrderNumber,
			ts.ticketStatus AS ticketStatus,
			tk.observations AS observations,
			IFNULL(bu.name, tk.employee) AS asignee,
			IFNULL(tk.arrival, '') AS arrival,
			IFNULL(tk.closed, '') AS closed,
			tk.contact AS contact,
			tk.contactEmail AS contactEmail,
			tk.contactPhone AS contactPhone,
			IFNULL(tk.solutionTime, '') AS solutionTime,
			IF(tk.solutionTimeDeviationHr < 0, 0, IFNULL(tk.solutionTimeDeviationHr, ''))  AS solutionTimeDeviationHr
			FROM ticket tk
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
			INNER JOIN policy p ON tk.policyId = p.policyId
			INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office of on p.officeId = of.officeId
			INNER JOIN policyEquipmentUser pe ON p.policyId = pe.policyId
			LEFT OUTER JOIN blackstarUser bu ON bu.email = tk.employee
			WHERE tk.created >= pStartDate AND tk.created <= pEndDate
			AND p.project = pProject
			AND pe.equipmentUserId = pUser
			ORDER BY tk.created ASC;
		END IF;
	END IF;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextServiceNumberForTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextServiceNumberForTicket$$
CREATE PROCEDURE blackstarDb.GetNextServiceNumberForTicket()
BEGIN

	DECLARE newNumber INTEGER;

	-- Obteniendo el numero de folio
	CALL blackstarDb.GetNextServiceOrderNumber('O', newNumber);

	-- Regresando el numero de folio completo
	SELECT CONCAT('OS-', lpad(cast(newNumber AS CHAR(50)), 5, '0'), '-e') AS ServiceNumber;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceStatusList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceStatusList$$
CREATE PROCEDURE blackstarDb.GetServiceStatusList()
BEGIN

	SELECT
		serviceStatusId AS serviceStatusId,
		serviceStatus AS serviceStatus
	FROM serviceStatus
	ORDER BY serviceStatus;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrderTypeBySOId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentTypeBySOId$$
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrderTypeBySOId$$
CREATE PROCEDURE blackstarDb.GetServiceOrderTypeBySOId(pServiceOrderId INT)
BEGIN

	IF(SELECT COUNT(*) FROM aaService WHERE serviceOrderId = pServiceOrderId) > 0 THEN
		SELECT 'A' AS SoTypeId;
	ELSE
		IF(SELECT COUNT(*) FROM bbService WHERE serviceOrderId = pServiceOrderId) > 0 THEN
			SELECT 'B' AS SoTypeId;
		ELSE
			IF(SELECT COUNT(*) FROM epService WHERE serviceOrderId = pServiceOrderId) > 0 THEN
				SELECT 'P' AS SoTypeId;
			ELSE
				IF(SELECT COUNT(*) FROM upsService WHERE serviceOrderId = pServiceOrderId) > 0 THEN
					SELECT 'U' AS SoTypeId;
				ELSE
					SELECT 'X' AS SoTypeId;
				END IF;
			END IF;
		END IF;
	END IF;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceTypeById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceTypeById$$
CREATE PROCEDURE blackstarDb.GetServiceTypeById(pType CHAR(1))
BEGIN

	-- TODO: codigo heredado, revisar SELECT
	SELECT * FROM serviceType WHERE serviceTypeId = pType;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceTypeList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceTypeList$$
CREATE PROCEDURE blackstarDb.GetServiceTypeList()
BEGIN

	SELECT 
		serviceTypeId AS serviceTypeId,
		serviceType AS serviceType
	FROM serviceType
	ORDER BY serviceType;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CloseOS
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CloseOS$$
CREATE PROCEDURE blackstarDb.CloseOS(pServiceOrderId INTEGER, pUser VARCHAR(100))
BEGIN

	UPDATE serviceOrder SET
		serviceStatusId = 'C',
		closed = NOW(),
		modified = NOW(),
		modifiedBy = 'CloseOS',
		modifiedByUsr = pUser
	WHERE
		serviceOrderId = pServiceOrderId;
END$$
	
-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEquipmentByType
	--
	-- Este SP se utiliza especificamente para recuperar valores destinados
	-- a poblar un campo autocomplete. No cambiar las etiquetas
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentByType$$
CREATE PROCEDURE blackstarDb.GetEquipmentByType(pEquipmentTypeId CHAR(1))
BEGIN
	IF(pEquipmentTypeId = 'T' OR pEquipmentTypeId = 'X') THEN
		SELECT 
			concat_ws(' - ', brand, model, serialNumber) AS label,
			serialNumber AS value
		FROM policy p
		WHERE p.startDate < CURDATE() AND p.endDate > CURDATE()
		ORDER BY brand, model, serialNumber;
	ELSE
		SELECT 
			concat_ws(' - ', brand, model, serialNumber) AS label,
			serialNumber AS value
		FROM policy p
		WHERE equipmentTypeId = pEquipmentTypeId
		AND p.startDate < CURDATE() AND p.endDate > CURDATE()
		ORDER BY brand, model, serialNumber;
	END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAllServiceOrders
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllServiceOrders$$
CREATE PROCEDURE blackstarDb.GetAllServiceOrders()
BEGIN

	SELECT * FROM(
		SELECT 
			so.ServiceOrderId AS DT_RowId,
			so.serviceOrderNumber AS serviceOrderNumber,
			'' AS placeHolder,
			IFNULL(t.ticketNumber, '') AS ticketNumber,
			st.serviceType AS serviceType,
			DATE(so.serviceDate) AS serviceDate,
			p.customer AS customer,
			et.equipmentType AS equipmentType,
			p.project AS project,
			of.officeName AS officeName,
			p.brand AS brand,
			p.serialNumber AS serialNumber,
			ss.serviceStatus AS serviceStatus,
			so.hasPdf AS hasPdf,
			IFNULL(sc.serviceCenter, '') AS serviceCenter,
			IFNULL(so.surveyServiceId, '') AS surveyServiceId
		FROM serviceOrder so 
			INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
			INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
			INNER JOIN policy p ON so.policyId = p.policyId
			INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office of on p.officeId = of.officeId
			INNER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
	     LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
	     UNION
	     SELECT 
			so.ServiceOrderId AS DT_RowId,
			so.serviceOrderNumber AS serviceOrderNumber,
			'' AS placeHolder,
			IFNULL(t.ticketNumber, '') AS ticketNumber,
			st.serviceType AS serviceType,
			DATE(so.serviceDate) AS serviceDate,
			oc.customerName AS customer,
			et.equipmentType AS equipmentType,
			oc.project AS project,
			o.officeName AS officeName,
			oc.brand AS brand,
			oc.serialNumber AS serialNumber,
			ss.serviceStatus AS serviceStatus,
			so.hasPdf AS hasPdf,
			IFNULL(o.officeName, '') AS serviceCenter,
			IFNULL(so.surveyServiceId, '') AS surveyServiceId
		FROM serviceOrder so 
			INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
			INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
			INNER JOIN openCustomer oc ON so.openCustomerId = oc.openCustomerId
			INNER JOIN equipmentType et ON oc.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office o ON oc.officeId = o.officeId
	     LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
	) A
	ORDER BY A.serviceDate DESC;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFutureServicesSchedule
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFutureServicesSchedule$$
CREATE PROCEDURE blackstarDb.GetFutureServicesSchedule(pServiceDate DATETIME)
BEGIN

	SELECT DISTINCT
		s.scheduledServiceId AS scheduledServiceId,
		serviceDate AS scheduledDate,
		equipmentType AS equipmentType,
		ifnull(p.customer, oc.customerName) AS customer,
		s.project AS project,
		ifnull(p.serialNumber, oc.serialNumber) AS serialNumber,
		officeName AS officeName,
		ifnull(p.brand, oc.brand) AS brand,
		us.name AS employee
	FROM blackstarDb.scheduledService s
		LEFT OUTER JOIN blackstarDb.scheduledServicePolicy sp ON sp.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER JOIN blackstarDb.openCustomer oc ON oc.openCustomerId = s.openCustomerId
		LEFT OUTER  JOIN blackstarDb.scheduledServiceDate sd ON sd.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER  JOIN blackstarDb.policy p ON sp.policyId = p.policyId
		LEFT OUTER  JOIN blackstarDb.serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER  JOIN blackstarDb.equipmentType et ON et.equipmentTypeId = ifnull(p.equipmentTypeId, oc.equipmentTypeId)
		LEFT OUTER  JOIN blackstarDb.scheduledServiceEmployee em ON em.scheduledServiceId = s.scheduledServiceId AND em.isDefault = 1
		LEFT OUTER  JOIN blackstarDb.blackstarUser us ON us.email = em.employeeId
		LEFT OUTER  JOIN blackstarDb.office o ON o.officeId = ifnull(p.officeId, oc.officeId)
	WHERE s.serviceStatusId = 'P'
		AND serviceDate >= pServiceDate
	ORDER BY equipmentType;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddScheduledServiceDate
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddScheduledServiceDate$$
CREATE PROCEDURE blackstarDb.AddScheduledServiceDate(pScheduledServiceId INTEGER, pDate DATETIME, pCreatedBy VARCHAR(100), pUser VARCHAR(100))
BEGIN

	INSERT INTO scheduledServiceDate(
			scheduledServiceId,
			serviceDate,
			created,
			createdBy,
			createdByUsr
	)
	SELECT 
		pScheduledServiceId,
		pDate,
		NOW(),
		pCreatedBy,
		pUser;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetPersonalServiceOrders
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPersonalServiceOrders$$
CREATE PROCEDURE blackstarDb.GetPersonalServiceOrders(pUser VARCHAR(100))
BEGIN

	SELECT 
		so.serviceOrderId AS DT_RowId,
		so.serviceOrderNumber AS serviceOrderNumber,
		'' AS placeHolder,
		ifnull(t.ticketNumber, '') AS ticketNumber,
		st.serviceType AS serviceType,
		date(so.serviceDate) AS serviceDate,
		p.customer AS customer,
		et.equipmentType AS equipmentType,
		p.project AS project,
		o.officeName AS officeName,
		p.brand AS brand,
		p.serialNumber AS serialNumber
	FROM serviceOrder so
		INNER JOIN serviceStatus ss ON ss.serviceStatusId = so.serviceStatusId
		LEFT OUTER JOIN ticket t ON t.ticketId = so.ticketId
		INNER JOIN serviceType st ON st.serviceTypeId = so.serviceTypeId
		INNER JOIN policy p ON p.policyId = so.policyId
		INNER JOIN equipmentType et ON et.equipmentTypeId = p.equipmentTypeId
		INNER JOIN office o ON p.officeId = o.officeId
		LEFT OUTER JOIN serviceOrderEmployee se ON so.serviceOrderId = se.serviceOrderId
	WHERE serviceStatus IN ('NUEVO', 'PENDIENTE')
	AND (so.asignee = pUser OR se.employeeId = pUser)
	ORDER BY serviceDate DESC;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAssignedTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAssignedTickets$$
CREATE PROCEDURE blackstarDb.GetAssignedTickets(pUser VARCHAR(100))
BEGIN

	SELECT 
		t.ticketId AS DT_RowId,
		t.ticketNumber AS ticketNumber,
		t.created AS ticketDate,
		p.customer AS customer,
		e.equipmentType AS equipmentType,
		p.responseTimeHR AS responseTime,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		'' AS placeHolder
	FROM ticket t
		INNER JOIN policy p ON p.policyId = t.policyId
		INNER JOIN equipmentType e ON e.equipmentTypeId = p.equipmentTypeId
		INNER JOIN ticketStatus ts ON t.ticketStatusId = ts.ticketStatusId
	WHERE t.asignee = pUser
	AND t.closed IS NULL
	ORDER BY ticketDate;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddScheduledServiceEmployee
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddScheduledServiceEmployee$$
CREATE PROCEDURE blackstarDb.AddScheduledServiceEmployee(pScheduledServiceId INTEGER, pEmployeeId VARCHAR(100), pIsDefault INT, pCreatedBy VARCHAR(100), pUser VARCHAR(100))
BEGIN

	INSERT INTO scheduledServiceEmployee(
			scheduledServiceId,
			employeeId,
			isDefault,
			created,
			createdBy,
			createdByUsr
	)
	SELECT 
		pScheduledServiceId,
		pEmployeeId,
		pIsDefault,
		NOW(),
		pCreatedBy,
		pUser;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddScheduledServicePolicy
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddScheduledServicePolicy$$
CREATE PROCEDURE blackstarDb.AddScheduledServicePolicy(pScheduledServiceId INTEGER, pPolicyId INTEGER, pCreatedBy VARCHAR(100), pUser VARCHAR(100))
BEGIN

	INSERT INTO scheduledServicePolicy(
			scheduledServiceId,
			policyId,
			created,
			createdBy,
			createdByUsr
	)
	SELECT 
		pScheduledServiceId,
		pPolicyId,
		NOW(),
		pCreatedBy,
		pUser;
END$$
	
-- -----------------------------------------------------------------------------
	-- blackstarDb.GetScheduledServices
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetScheduledServices$$
CREATE PROCEDURE blackstarDb.GetScheduledServices(pUser VARCHAR(100))
BEGIN

SELECT 
	ss.scheduledServiceId AS DT_RowId,
	sd.serviceDate AS serviceDate,
	p.customer AS customer,
	e.equipmentType AS equipmentType,
	p.project AS project,
	o.officeName AS officeName,
	p.brand AS brand,
	p.serialNumber AS serialNumber
	FROM 
		scheduledService ss
		INNER JOIN scheduledServiceDate sd ON ss.scheduledServiceId = sd.scheduledServiceId
		INNER JOIN scheduledServiceEmployee se ON se.scheduledServiceId = ss.scheduledServiceId
		INNER JOIN scheduledServicePolicy sp ON sp.scheduledServiceId = ss.scheduledServiceId
		INNER JOIN policy p ON p.policyId = sp.policyId
		INNER JOIN equipmentType e ON e.equipmentTypeId = p.equipmentTypeId
		INNER JOIN office o ON o.officeId = p.officeId
	WHERE employeeId = pUser
	ORDER BY serviceDate;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextServiceNumberForType
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextServiceNumberForEquipment$$
DROP PROCEDURE IF EXISTS blackstarDb.GetNextServiceNumberForType$$
CREATE PROCEDURE blackstarDb.GetNextServiceNumberForType(eqType VARCHAR(10))
BEGIN
	DECLARE prefix VARCHAR(10);
	DECLARE newNumber INTEGER;

	-- Cambiando a O por default
	IF eqType NOT IN('A', 'B', 'P', 'U') THEN
		SELECT 'O' into eqType;
	END IF;

	SET prefix = (SELECT CASE 
		WHEN eqType = 'A' THEN 'AA-' 
		WHEN eqType = 'B' THEN 'BB-'
		WHEN eqType = 'P' THEN 'PE-'
		WHEN eqType = 'U' THEN 'UPS-'
		ELSE 'OS-' END);

	-- Obteniendo el numero de folio
	CALL blackstarDb.GetNextServiceOrderNumber(eqType, newNumber);

	-- Regresando el numero de folio completo
	SELECT CONCAT(prefix, lpad(cast(newNumber AS CHAR(50)), 5, '0'), '-e') AS ServiceNumber;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetDomainEmployeesByGroup
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetDomainEmployeesByGroup$$
CREATE PROCEDURE blackstarDb.GetDomainEmployeesByGroup(pUserGroup VARCHAR(100))
BEGIN

	SELECT 
		u.email AS DT_RowId, 
		u.email AS email, 
		u.name AS employee
	FROM blackstarUser_userGroup ug
		INNER JOIN blackstarUser u ON u.blackstarUserId = ug.blackstarUserId
		INNER JOIN userGroup g ON g.userGroupId = ug.userGroupId
	WHERE g.name = pUserGroup
	ORDER BY u.name;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetProjectList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetProjectList$$
CREATE PROCEDURE blackstarDb.GetProjectList()
BEGIN

	SELECT DISTINCT 
		project as project
	FROM blackstarDb.policy
		WHERE startDate <= NOW() AND NOW() <= endDate
	ORDER BY project;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetOfficesList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetOfficesList$$
CREATE PROCEDURE blackstarDb.GetOfficesList()
BEGIN

	SELECT DISTINCT
		officeName as officeName
	FROM blackstarDb.office 
	ORDER BY officeName;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAndIncreaseSequence
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAndIncreaseSequence$$
CREATE PROCEDURE blackstarDb.GetAndIncreaseSequence(pSequenceTypeId CHAR(1), OUT nextNum INTEGER)
BEGIN

	-- Recuperar el numero de secuencia actual
	DECLARE seqNum INTEGER;
	SELECT sequenceNumber into seqNum FROM sequence WHERE sequenceTypeId = pSequenceTypeId;

	-- Incrementar el numero en la BD
	UPDATE sequence SET
		sequenceNumber = (seqNum + 1)
	WHERE sequenceTypeId = pSequenceTypeId;

	-- Regresar el numero actual
	SELECT seqNum into nextNum;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.LoadNewSequencePoolItems
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.LoadNewSequencePoolItems$$
CREATE PROCEDURE blackstarDb.LoadNewSequencePoolItems(pSequenceNumberTypeId CHAR(1))
BEGIN

	-- Verificar cuantos numeros hay actualmente
	DECLARE poolItems INTEGER;
	DECLARE newNumber INTEGER;

	SELECT count(*) into poolItems FROM sequenceNumberPool WHERE sequenceNumberTypeId = pSequenceNumberTypeId AND sequenceNumberStatus = 'U';

	-- Cargar nuevo numero en el pool
	CALL blackstarDb.GetAndIncreaseSequence(pSequenceNumberTypeId, newNumber);

	INSERT INTO sequenceNumberPool(sequenceNumberTypeId, sequenceNumber, sequenceNumberStatus)
	SELECT pSequenceNumberTypeId, newNumber, 'U';

	SELECT count(*) into poolItems FROM sequenceNumberPool WHERE sequenceNumberTypeId = pSequenceNumberTypeId AND sequenceNumberStatus = 'U';

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CommitServiceOrderNumber
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CommitServiceOrderNumber$$
CREATE PROCEDURE blackstarDb.CommitServiceOrderNumber(pSequenceNumber INTEGER, pSequenceNumberTypeId CHAR(1))
BEGIN

	-- Borrar numero del pool
	DELETE FROM sequenceNumberPool WHERE sequenceNumber = pSequenceNumber AND sequenceNumberTypeId = pSequenceNumberTypeId;

	-- Cargar nuevos numeros
	CALL blackstarDb.LoadNewSequencePoolItems(pSequenceNumberTypeId);
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextServiceOrderNumber
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextServiceOrderNumber$$
CREATE PROCEDURE blackstarDb.GetNextServiceOrderNumber(pSequenceNumberTypeId CHAR(1), OUT nextNumber INTEGER)
BEGIN

	DECLARE nextId INTEGER;

	-- Cargar nuevos numeros
	CALL blackstarDb.LoadNewSequencePoolItems(pSequenceNumberTypeId);
	
	-- Recuperar el siguiente numero en la secuencia y su ID
	SELECT min(sequenceNumber) into nextNumber
	FROM sequenceNumberPool 
	WHERE sequenceNumberTypeId = pSequenceNumberTypeId
		AND sequenceNumberStatus = 'U';

	SELECT sequenceNumberPoolId into nextId
	FROM sequenceNumberPool 
	WHERE sequenceNumber = nextNumber 
		AND sequenceNumberTypeId = pSequenceNumberTypeId;

	-- Bloquear el numero
	UPDATE sequenceNumberPool SET sequenceNumberStatus = 'L'
	WHERE sequenceNumberPoolId = nextId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUserGroups
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserGroups$$
CREATE PROCEDURE blackstarDb.GetUserGroups(pEmail VARCHAR(100))
BEGIN

	SELECT g.name AS groupName
	FROM blackstarUser_userGroup ug
		INNER JOIN blackstarUser u ON u.blackstarUserId = ug.blackstarUserId
		LEFT OUTER JOIN userGroup g ON g.userGroupId = ug.userGroupId
	WHERE u.email = pEmail;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEquipmentByCustomer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentByCustomer$$
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentList$$
CREATE PROCEDURE blackstarDb.GetEquipmentList()
BEGIN

	SELECT
		policyId as DT_RowId,
		equipmentType as equipmentType,
		serialNumber as serialNumber,
		project as project
	FROM policy p
		INNER JOIN equipmentType e on e.equipmentTypeId = p.equipmentTypeId
	WHERE 
		NOW() > p.startDate and NOW() < p.endDate
	ORDER BY serialNumber;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AssignServiceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AssignServiceOrder$$
CREATE PROCEDURE blackstarDb.AssignServiceOrder (pOsId INTEGER, pEmployee VARCHAR(100), usr VARCHAR(100), proc VARCHAR(100))
BEGIN

	UPDATE serviceOrder SET
		asignee = pEmployee,
		modified = NOW(),
		modifiedBy = proc,
		modifiedByUsr = usr
	WHERE serviceOrderId = pOsId;
	
END$$

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
		t.ticketStatusId = IF(TIMESTAMPDIFF(HOUR, t.created, NOW()) > p.solutionTimeHR, 'R', 'A'),
		t.modified = NOW(),
		t.modifiedBy = 'ReopenTicket',
		t.modifiedByUsr = pModifiedBy
	WHERE t.ticketId = pTicketId;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.CloseTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CloseTicket$$
CREATE PROCEDURE blackstarDb.CloseTicket(pTicketId INTEGER, pOsId VARCHAR(100), pClosed DATETIME, pModifiedBy VARCHAR(100), pEmployee VARCHAR(200))
BEGIN
	
	-- ACTUALIZAR EL ESTATUS DEL TICKET Y NUMERO DE ORDEN DE SERVICIO
	UPDATE ticket t 
		INNER JOIN ticket t2 on t.ticketId = t2.ticketId
		INNER JOIN blackstarDb.policy p on p.policyId = t.policyId
	SET 
		t.ticketStatusId = IF(t2.ticketStatusId = 'R', 'F', 'C'),
		-- t.serviceOrderId = pOsId,
		t.serviceOrderNumber = pOsId,
		t.closed = pClosed,
		t.solutionTime = TIMESTAMPDIFF(HOUR, t.created, pClosed),
		t.solutionTimeDeviationHr = CASE WHEN(TIMESTAMPDIFF(HOUR, t.created, pClosed) < solutionTimeHR) THEN 0 ELSE (TIMESTAMPDIFF(HOUR, t.created, pClosed) - solutionTimeHR) END,
		t.employee = pEmployee,
		t.modified = NOW(),
		t.modifiedBy = 'CloseTicket',
		t.modifiedByUsr = pModifiedBy
	WHERE t.ticketId = pTicketId;

	-- Poner la OS como correctivo
	UPDATE serviceOrder SET serviceTypeId = 'C'
	WHERE serviceOrderNumber = pOsId;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToOS
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpToOS$$
CREATE PROCEDURE blackstarDb.AddFollowUpToOS(pOsId INTEGER, pCreated DATETIME, pCreatedBy VARCHAR(100), pAsignee VARCHAR(100), pMessage TEXT)
BEGIN

	-- INSERTAR EL REGISTRO DE SEGUIMIENTO
	INSERT INTO blackstarDb.followUp(
		followUpReferenceTypeId,
		serviceOrderId,
		asignee,
		followup,
		created,
		createdBy,
		createdByUsr
	)
	SELECT 
		'O',
		pOsId,
		pAsignee,
		pMessage,
		pCreated,
		'AddFollowUpToOS',
		pCreatedBy;

	-- ACTUALIZAR LA OS
	UPDATE serviceOrder SET
		serviceStatusId = 'E',
		asignee = pAsignee,
		modified = pCreated,
		modifiedBy = 'AddFollowUpToOS',
		modifiedByUsr = pCreatedBy
	WHERE serviceOrderId = pOsId;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpToTicket$$
CREATE PROCEDURE blackstarDb.AddFollowUpToTicket(pTicketId INTEGER, pCreated DATETIME, pCreatedBy VARCHAR(100), pAsignee VARCHAR(100), pMessage TEXT)
BEGIN

	-- INSERTAR EL REGISTRO DE SEGUIMIENTO
	INSERT INTO blackstarDb.followUp(
		followUpReferenceTypeId,
		ticketId,
		asignee,
		followup,
		created,
		createdBy,
		createdByUsr
	)
	SELECT 
		'T',
		pTicketId,
		pAsignee,
		pMessage,
		pCreated,
		'AddFollowUpToTicket',
		pCreatedBy;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertScheduledService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertScheduledService$$
CREATE PROCEDURE blackstarDb.UpsertScheduledService(pScheduledServiceId INTEGER, pDescription VARCHAR(1000), pOpenCustomerId INT, pProject VARCHAR(100), pServiceContact VARCHAR(100), pServiceContactEmail VARCHAR(100), pCreatedBy VARCHAR(100), pUser VARCHAR(100) )
BEGIN

	IF pScheduledServiceId = 0 THEN
		INSERT INTO scheduledService(
			serviceStatusId,
			description,
			openCustomerId,
			project,
			serviceContact,
			serviceContactEmail,
			created,
			createdBy,
			createdByUsr
		)
		SELECT 
			'P', pDescription, pOpenCustomerId, pProject, pServiceContact, pServiceContactEmail, NOW(), pCreatedBy, pUser;
			
		SET pScheduledServiceId = LAST_INSERT_ID();
	ELSE
		UPDATE scheduledService SET
				serviceStatusId = 'P',
				description = pDescription,
				openCustomerId = pOpenCustomerId,
				project = pProject,
				serviceContact = pServiceContact,
				serviceContactEmail = pServiceContactEmail,
				modified = NOW(),
				modifiedBy = pCreatedBy,
				modifiedByUsr = pUser
		WHERE scheduledServiceId = pScheduledServiceId;
	END IF;
	
	
	-- Se eliminan los hijos del scheduledService. Se asume que se actualizaran equipos y empleados usando:
	-- AddScheduledServicePolicy y AddScheduledServiceEmployee
	DELETE FROM scheduledServiceEmployee WHERE scheduledServiceId = pScheduledServiceId;
	
	DELETE FROM scheduledServicePolicy WHERE scheduledServiceId = pScheduledServiceId;
	
	DELETE FROM scheduledServiceDate WHERE scheduledServiceId = pScheduledServiceId;
	
	SELECT pScheduledServiceId as scheduledServiceId;
		
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFollowUpByServiceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFollowUpByServiceOrder$$
CREATE PROCEDURE blackstarDb.GetFollowUpByServiceOrder(pServiceOrderId INTEGER)
BEGIN

	SELECT 
		created AS timeStamp,
		u2.name AS createdBy,
		u.name AS asignee,
		followup AS followUp
	FROM followUp f
		LEFT OUTER JOIN blackstarUser u ON f.asignee = u.email
		LEFT OUTER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
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
		t.observations AS observations,
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
		IFNULL(t.employee, '') AS employee,
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
	ORDER BY created DESC;
	
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
		created AS timeStamp,
		u2.name AS createdBy,
		u.name AS asignee,
		followup AS followUp
	FROM followUp f
		LEFT OUTER JOIN blackstarUser u ON f.asignee = u.email
		LEFT OUTER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
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

	SELECT DISTINCT customer
	FROM blackstarDb.policy
		WHERE startDate <= NOW() AND NOW() <= endDate
	ORDER BY customer;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServicesSchedule
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServicesSchedule$$
CREATE PROCEDURE blackstarDb.GetServicesSchedule(pServiceDate DATETIME)
BEGIN

	SELECT DISTINCT
		s.scheduledServiceId AS scheduledServiceId,
		serviceDate AS scheduledDate,
		equipmentType AS equipmentType,
		ifnull(p.customer, oc.customerName) AS customer,
		s.project AS project,
		ifnull(p.serialNumber, oc.serialNumber) AS serialNumber,
		us.name AS defaultEmployee
	FROM blackstarDb.scheduledService s
		LEFT OUTER JOIN blackstarDb.scheduledServicePolicy sp ON sp.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER JOIN blackstarDb.openCustomer oc ON oc.openCustomerId = s.openCustomerId
		LEFT OUTER JOIN blackstarDb.scheduledServiceDate sd ON sd.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER JOIN blackstarDb.policy p ON sp.policyId = p.policyId
		LEFT OUTER JOIN blackstarDb.serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER JOIN blackstarDb.equipmentType et ON et.equipmentTypeId = ifnull(p.equipmentTypeId, oc.equipmentTypeId)
		LEFT OUTER JOIN blackstarDb.scheduledServiceEmployee em ON em.scheduledServiceId = s.scheduledServiceId AND em.isDefault = 1
		LEFT OUTER JOIN blackstarDb.blackstarUser us ON us.email = em.employeeId
	WHERE s.serviceStatusId = 'P'
		AND serviceDate > pServiceDate AND serviceDate < DATE_ADD(pServiceDate, INTERVAL 1 DAY)
	ORDER BY equipmentType;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetDomainEmployees
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetDomainEmployees$$
CREATE PROCEDURE blackstarDb.GetDomainEmployees()
BEGIN

	SELECT DISTINCT u.email AS email, u.name AS name
	FROM blackstarUser u 	
		LEFT OUTER JOIN blackstarUser_userGroup ug ON u.blackstarUserId = ug.blackstarUserId
		LEFT OUTER JOIN userGroup g ON g.userGroupId = ug.userGroupId
	WHERE g.name != 'Cliente'
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
CREATE PROCEDURE blackstarDb.UpsertUser(pEmail VARCHAR(100), pName VARCHAR(100), pBossEmail VARCHAR(100))
BEGIN
	IF(pEmail IS NOT NULL AND pName IS NOT NULL) THEN
		-- Insert the record
		INSERT INTO blackstarDb.blackstarUser(email, name)
		SELECT a.email, a.name
		FROM (
			SELECT pEmail AS email, pName AS name
		) a
			LEFT OUTER JOIN blackstarDb.blackstarUser u ON a.email = u.email
		WHERE u.email IS NULL;

		-- Update the details
		UPDATE blackstarUser u
			LEFT OUTER JOIN blackstarUser b ON u.email = pEmail AND b.email = pBossEmail
		SET 
			u.name = pName,
			u.bossId = b.blackstarUserId	
		WHERE u.email = pEmail;
	END IF;
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
		et.equipmentType AS equipmentType,
		p.responseTimeHR AS responseTimeHR,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		tk.ticketNumber AS Asignar
	FROM ticket tk 
		INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		INNER JOIN policy p ON tk.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
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
		et.equipmentType AS equipmentType,
		p.responseTimeHR AS responseTimeHR,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		IFNULL(bu.name, ifnull(tk.employee, '')) AS asignee,
		tk.ticketNumber AS asignar,
		IFNULL(tk.serviceOrderNumber, '') AS serviceOrderNumber
	FROM ticket tk 
		INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		INNER JOIN policy p ON tk.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
		INNER JOIN office of on p.officeId = of.officeId
		LEFT OUTER JOIN blackstarUser bu ON bu.email = tk.employee
	WHERE tk.created > '01-01' + YEAR(NOW())
    ORDER BY tk.created DESC;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrders
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrders$$
CREATE PROCEDURE blackstarDb.GetServiceOrders(IN status VARCHAR(200))
BEGIN
	
	SELECT * FROM (
		SELECT 
			so.ServiceOrderId AS DT_RowId,
			so.serviceOrderNumber AS serviceOrderNumber,
			'' AS placeHolder,
			IFNULL(t.ticketNumber, '') AS ticketNumber,
			st.serviceType AS serviceType,
			DATE(so.serviceDate) AS created,
			p.customer AS customer,
			et.equipmentType AS equipmentType,
			p.project AS project,
			of.officeName AS officeName,
			p.brand AS brand,
			p.serialNumber AS serialNumber,
			ss.serviceStatus AS serviceStatus,
			so.hasPdf AS hasPdf,
			IFNULL(sc.serviceCenter, '') AS serviceCenter
		FROM serviceOrder so 
			INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
			INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
			INNER JOIN policy p ON so.policyId = p.policyId
			INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office of on p.officeId = of.officeId
			INNER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
	     LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
		WHERE ss.serviceStatus IN(status) 
		UNION
		SELECT 
			so.ServiceOrderId AS DT_RowId,
			so.serviceOrderNumber AS serviceOrderNumber,
			'' AS placeHolder,
			IFNULL(t.ticketNumber, '') AS ticketNumber,
			st.serviceType AS serviceType,
			DATE(so.serviceDate) AS created,
			p.customerName AS customer,
			et.equipmentType AS equipmentType,
			p.project AS project,
			of.officeName AS officeName,
			p.brand AS brand,
			p.serialNumber AS serialNumber,
			ss.serviceStatus AS serviceStatus,
			so.hasPdf AS hasPdf,
			of.officeName AS serviceCenter
		FROM serviceOrder so 
			INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
			INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
			INNER JOIN openCustomer p ON so.openCustomerId = p.openCustomerId
			INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office of on p.officeId = of.officeId
	     LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
		WHERE ss.serviceStatus IN(status)
	) A ORDER BY created DESC ;
	
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
		et.equipmentType AS equipmentType,
		tk.solutionTimeDeviationHr AS solutionTimeDeviationHr,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		'Crear OS' AS OS 
	FROM ticket tk 
		INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		INNER JOIN policy p ON tk.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
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
		AND endDate > NOW()
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
		AND TIMESTAMPDIFF(HOUR, t.created, NOW()) <= p.solutionTimeHR;
			
	-- RETRASADOS
	UPDATE blackstarDb.ticket t
		INNER JOIN policy p on t.policyId = p.policyId
	SET
		ticketStatusId = 'R'
	WHERE closed IS NULL
		AND TIMESTAMPDIFF(HOUR, t.created, NOW()) > p.solutionTimeHR;

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

	-- Asignacion del dueño del ticket
	UPDATE ticket SET
		employee = pEmployee
	WHERE ticketId = pTicketId
		AND IFNULL(employee, '') = '';
		
	-- Asignacion del empleado responsable
	UPDATE ticket SET
		employee = pEmployee,
		asignee = pEmployee,
		modified = NOW(),
		modifiedBy = proc,
		modifiedByUsr = usr
	WHERE ticketId = pTicketId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAirCoServiceByIdService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAirCoServiceByIdService$$
CREATE PROCEDURE blackstarDb.GetAirCoServiceByIdService (idService INTEGER)
BEGIN	
	select 
		aaServiceId, serviceOrderId, evaDescription, evaValTemp, evaValHum, evaSetpointTemp, evaSetpointHum, 
		evaFlagCalibration, evaReviewFilter, evaReviewStrip, evaCleanElectricSystem, evaCleanControlCard, evaCleanTray, 
		evaLectrurePreasureHigh, evaLectrurePreasureLow, evaLectureTemp, evaLectureOilColor, evaLectureOilLevel, evaLectureCoolerColor, 
		evaLectureCoolerLevel, evaCheckOperatation, evaCheckNoise, evaCheckIsolated, evaLectureVoltageGroud, evaLectureVoltagePhases, 
		evaLectureVoltageControl, evaLectureCurrentMotor1, evaLectureCurrentMotor2, evaLectureCurrentMotor3, evaLectureCurrentCompressor1, 
		evaLectureCurrentCompressor2, evaLectureCurrentCompressor3, evaLectureCurrentHumidifier1, evaLectureCurrentHumidifier2, 
		evaLectureCurrentHumidifier3, evaLectureCurrentHeater1, evaLectureCurrentHeater2, evaLectureCurrentHeater3, evaCheckFluidSensor,
		evaRequirMaintenance, condReview, condCleanElectricSystem, condClean, condLectureVoltageGroud, condLectureVoltagePhases,
		condLectureVoltageControl, condLectureMotorCurrent, condReviewThermostat, condModel, condSerialNumber, condBrand, observations
	from aaService 
	where 
		serviceOrderId = idService;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBatteryServiceByIdService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBatteryServiceByIdService$$
CREATE PROCEDURE blackstarDb.GetBatteryServiceByIdService (idService INTEGER)
BEGIN
	select 
		bbServiceId, serviceOrderId, plugClean, plugCleanStatus, plugCleanComments, coverClean, coverCleanStatus, 
		coverCleanComments, capClean, capCleanStatus, capCleanComments, groundClean, groundCleanStatus, groundCleanComments, 
		rackClean, rackCleanStatus, rackCleanComments, serialNoDateManufact, batteryTemperature, voltageBus, temperature
	from bbService 
	where 
		serviceOrderId = idService;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetCellBatteryServiceByIdBatteryService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetCellBatteryServiceByIdBatteryService$$
CREATE PROCEDURE blackstarDb.GetCellBatteryServiceByIdBatteryService (idBatteryService INTEGER)
BEGIN
	select 
		bbCellServiceId, bbServiceId, cellNumber, floatVoltage, chargeVoltage
	from bbCellService 
	where 
		bbServiceId = idBatteryService;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEmergencyPlantServiceByIdService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEmergencyPlantServiceByIdService$$
CREATE PROCEDURE blackstarDb.GetEmergencyPlantServiceByIdService (idService INTEGER)
BEGIN
	select 
		A.epServiceId, serviceOrderId, brandPE,modelPE,serialPE, transferType, modelTransfer, modelControl, modelRegVoltage, modelRegVelocity, 
		modelCharger, oilChange, brandMotor, modelMotor, serialMotor, cplMotor, brandGenerator, modelGenerator, serialGenerator, 
		powerWattGenerator, tensionGenerator, tuningDate, tankCapacity, pumpFuelModel, filterFuelFlag, filterOilFlag, filterWaterFlag, 
		filterAirFlag, brandGear, brandBattery, clockLecture, serviceCorrective, observations, 

		epServiceSurveyId, levelOilFlag, levelWaterFlag, levelBattery, tubeLeak, batteryCap, batterySulfate, levelOil, 
		heatEngine, hoseOil, hoseWater, tubeValve, stripBlades, 

		epServiceWorkBasicId, washEngine, washRadiator, cleanWorkArea, conectionCheck, cleanTransfer, cleanCardControl, 
		checkConectionControl, checkWinding, batteryTests, checkCharger, checkPaint, cleanGenerator, 

		epServiceDynamicTestId, vacuumFrequency, chargeFrequency, bootTryouts, vacuumVoltage, chargeVoltage, qualitySmoke, 
		startTime, transferTime, stopTime, 

		epServiceTestProtectionId, tempSensor, oilSensor, voltageSensor, overSpeedSensor, oilPreasureSensor, waterLevelSensor, 
		
		epServiceTransferSwitchId, mechanicalStatus, boardClean, lampTest, screwAdjust, conectionAdjust, systemMotors, electricInterlock, 
		mechanicalInterlock, capacityAmp, 

		epServiceLecturesId, voltageABAN, voltageACCN, voltageBCBN, voltageNT, currentA, currentB, currentC, frequency, oilPreassure, temp, 

		epServiceParamsId, adjsutmentTherm, current, batteryCurrent, clockStatus, trasnferTypeProtection, generatorTypeProtection

	from epService A
	inner join  epServiceSurvey  B on  A.epServiceId  = B.epServiceId 
	inner join  epServiceWorkBasic  C on  A.epServiceId  = C.epServiceId 
	inner join  epServiceDynamicTest  D on  A.epServiceId  = D.epServiceId 
	inner join  epServiceTestProtection E on  A.epServiceId  = E.epServiceId 
	inner join  epServiceTransferSwitch F on  A.epServiceId  = F.epServiceId 
	inner join  epServiceLectures G on  A.epServiceId  = G.epServiceId 
	inner join  epServiceParams H on  A.epServiceId  = H.epServiceId 
	where 
		A.serviceOrderId  = idService;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetPlainServiceServiceByIdService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPlainServiceServiceByIdService$$
CREATE PROCEDURE blackstarDb.GetPlainServiceServiceByIdService (idService INTEGER)
BEGIN	
	select 
		plainServiceId, serviceOrderId, troubleDescription, techParam, workDone, materialUsed, observations
	from plainService ps
	where 
		serviceOrderId = idService;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUPSServiceByIdService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUPSServiceByIdService$$
CREATE PROCEDURE blackstarDb.GetUPSServiceByIdService (idService INTEGER)
BEGIN

	select 
		A.upsServiceId, serviceOrderId, estatusEquipment, cleaned, hooverClean, verifyConnections, capacitorStatus, verifyFuzz, 
		chargerReview, fanStatus,
		
		upsServiceBatteryBankId, checkConnectors, cverifyOutflow, numberBatteries, manufacturedDateSerial, damageBatteries, 
		other, temp, chargeTest, brandModel, batteryVoltage, 
		
		upsServiceGeneralTestId, trasferLine, transferEmergencyPlant, backupBatteries, verifyVoltage, 
		
		upsServiceParamsId, inputVoltagePhase, inputVoltageNeutro, inputVoltageNeutroGround, percentCharge, outputVoltagePhase, 
		outputVoltageNeutro, inOutFrecuency, busVoltage
	from upsService A
	inner join  upsServiceBatteryBank  B on  A.upsServiceId = B.upsServiceId
	inner join  upsServiceGeneralTest  C on  A.upsServiceId = C.upsServiceId
	inner join  upsServiceParams  D on  A.upsServiceId = D.upsServiceId
	where 
		A.serviceOrderId = idService;

END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.GetPolicyBySerialNo
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPolicyBySerialNo$$
CREATE PROCEDURE blackstarDb.GetPolicyBySerialNo (noSerial VARCHAR(100))
BEGIN
	SELECT * FROM blackstarDb.policy
	WHERE startDate < CURDATE() AND endDate > CURDATE() AND serialNumber = noSerial;
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddAAservice
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddAAservice$$
CREATE PROCEDURE blackstarDb.AddAAservice (  
	serviceOrderId int(11),
	evaDescription varchar(250),
	evaValTemp varchar(50),
	evaValHum varchar(50),
	evaSetpointTemp varchar(50),
	evaSetpointHum varchar(50),
	evaFlagCalibration bit(1),
	evaReviewFilter bit(1),
	evaReviewStrip bit(1),
	evaCleanElectricSystem bit(1),
	evaCleanControlCard bit(1),
	evaCleanTray bit(1),
	evaLectrurePreasureHigh varchar(50),
	evaLectrurePreasureLow varchar(50),
	evaLectureTemp varchar(50),
	evaLectureOilColor varchar(50),
	evaLectureOilLevel varchar(50),
	evaLectureCoolerColor varchar(50),
	evaLectureCoolerLevel varchar(50),
	evaCheckOperatation varchar(50),
	evaCheckNoise varchar(50),
	evaCheckIsolated varchar(50),
	evaLectureVoltageGroud varchar(50),
	evaLectureVoltagePhases varchar(50),
	evaLectureVoltageControl varchar(50),
	evaLectureCurrentMotor1 varchar(50),
	evaLectureCurrentMotor2 varchar(50),
	evaLectureCurrentMotor3 varchar(50),
	evaLectureCurrentCompressor1 varchar(50),
	evaLectureCurrentCompressor2 varchar(50),
	evaLectureCurrentCompressor3 varchar(50),
	evaLectureCurrentHumidifier1 varchar(50),
	evaLectureCurrentHumidifier2 varchar(50),
	evaLectureCurrentHumidifier3 varchar(50),
	evaLectureCurrentHeater1 varchar(50),
	evaLectureCurrentHeater2 varchar(50),
	evaLectureCurrentHeater3 varchar(50),
	evaCheckFluidSensor bit(1),
	evaRequirMaintenance bit(1),
	condReview varchar(50),
	condCleanElectricSystem bit(1),
	condClean bit(1),
	condLectureVoltageGroud varchar(50),
	condLectureVoltagePhases varchar(50),
	condLectureVoltageControl varchar(50),
	condLectureMotorCurrent varchar(50),
	condReviewThermostat varchar(50),
	condModel varchar(50),
	condSerialNumber varchar(50),
	condBrand varchar(50),
	observations varchar(255),
	created datetime ,
	createdBy varchar(50),
	createdByUsr varchar(50))
BEGIN
	INSERT INTO aaService
(serviceOrderId,evaDescription,evaValTemp,evaValHum,evaSetpointTemp,
evaSetpointHum,evaFlagCalibration,evaReviewFilter,evaReviewStrip,evaCleanElectricSystem,
evaCleanControlCard,evaCleanTray,evaLectrurePreasureHigh,evaLectrurePreasureLow,evaLectureTemp,
evaLectureOilColor,evaLectureOilLevel,evaLectureCoolerColor,evaLectureCoolerLevel,
evaCheckOperatation,evaCheckNoise,evaCheckIsolated,evaLectureVoltageGroud,evaLectureVoltagePhases,
evaLectureVoltageControl,evaLectureCurrentMotor1,evaLectureCurrentMotor2,evaLectureCurrentMotor3,
evaLectureCurrentCompressor1,evaLectureCurrentCompressor2,evaLectureCurrentCompressor3,
evaLectureCurrentHumidifier1,evaLectureCurrentHumidifier2,evaLectureCurrentHumidifier3,
evaLectureCurrentHeater1,evaLectureCurrentHeater2,evaLectureCurrentHeater3,evaCheckFluidSensor,
evaRequirMaintenance,condReview,condCleanElectricSystem,condClean,condLectureVoltageGroud,
condLectureVoltagePhases,condLectureVoltageControl,condLectureMotorCurrent,condReviewThermostat,
condModel,condSerialNumber,condBrand,observations,created,createdBy,createdByUsr)
VALUES
(
serviceOrderId,evaDescription,evaValTemp,evaValHum,evaSetpointTemp,
evaSetpointHum,evaFlagCalibration,evaReviewFilter,evaReviewStrip,
evaCleanElectricSystem,evaCleanControlCard,evaCleanTray,evaLectrurePreasureHigh,
evaLectrurePreasureLow,evaLectureTemp,evaLectureOilColor,evaLectureOilLevel,
evaLectureCoolerColor,evaLectureCoolerLevel,evaCheckOperatation,evaCheckNoise,
evaCheckIsolated,evaLectureVoltageGroud,evaLectureVoltagePhases,evaLectureVoltageControl,
evaLectureCurrentMotor1,evaLectureCurrentMotor2,evaLectureCurrentMotor3,evaLectureCurrentCompressor1,
evaLectureCurrentCompressor2,evaLectureCurrentCompressor3,evaLectureCurrentHumidifier1,
evaLectureCurrentHumidifier2,evaLectureCurrentHumidifier3,evaLectureCurrentHeater1,
evaLectureCurrentHeater2,evaLectureCurrentHeater3,evaCheckFluidSensor,
evaRequirMaintenance,condReview,condCleanElectricSystem,condClean,
condLectureVoltageGroud,condLectureVoltagePhases,condLectureVoltageControl,
condLectureMotorCurrent,condReviewThermostat,condModel,condSerialNumber,
condBrand,observations,created,createdBy,createdByUsr
);
select LAST_INSERT_ID();
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddBBcellservice
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddBBcellservice$$
CREATE PROCEDURE blackstarDb.AddBBcellservice (bbServiceId int(11) , cellNumber int(11) , floatVoltage varchar(50) , chargeVoltage varchar(50))
BEGIN
INSERT INTO bbCellService
(bbServiceId,cellNumber,floatVoltage,chargeVoltage)
VALUES
(bbServiceId,cellNumber,floatVoltage,chargeVoltage);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddBBservice
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddBBservice$$
CREATE PROCEDURE blackstarDb.AddBBservice (
   serviceOrderId  int(11)  ,
   plugClean  bit(1)  ,
   plugCleanStatus  varchar(50) , 
   plugCleanComments  varchar(50) , 
   coverClean  bit(1)  ,
   coverCleanStatus  varchar(50)  ,
   coverCleanComments  varchar(50) , 
   capClean  bit(1)  ,
   capCleanStatus  varchar(50)  ,
   capCleanComments  varchar(50) , 
   groundClean  bit(1)  ,
   groundCleanStatus  varchar(50) , 
   groundCleanComments  varchar(50) , 
   rackClean  bit(1)  ,
   rackCleanStatus  varchar(50) , 
   rackCleanComments  varchar(50) , 
   serialNoDateManufact  varchar(50)  ,
   batteryTemperature  varchar(50)  ,
   voltageBus  varchar(50)  ,
   temperature  varchar(50)  ,
   created  datetime , 
   createdBy  varchar(50)  ,
   createdByUsr  varchar(50)
)
BEGIN
INSERT INTO bbService
(serviceOrderId,plugClean,plugCleanStatus,plugCleanComments,coverClean,coverCleanStatus,coverCleanComments,
capClean,capCleanStatus,capCleanComments,groundClean,groundCleanStatus,groundCleanComments,rackClean,
rackCleanStatus,rackCleanComments,serialNoDateManufact,batteryTemperature,voltageBus,temperature,
created,createdBy,createdByUsr)
VALUES
(serviceOrderId ,plugClean ,plugCleanStatus ,plugCleanComments ,coverClean ,coverCleanStatus ,
coverCleanComments ,capClean ,capCleanStatus ,capCleanComments ,groundClean ,groundCleanStatus ,
groundCleanComments ,rackClean ,rackCleanStatus ,rackCleanComments ,serialNoDateManufact ,batteryTemperature ,
voltageBus ,temperature ,created ,createdBy ,createdByUsr );
select LAST_INSERT_ID();
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepService$$
CREATE PROCEDURE blackstarDb.AddepService (
   serviceOrderId  int(11)  ,
   brandPE varchar(50) ,
   modelPE varchar(50) ,
   serialPE varchar(50) ,
   transferType  varchar(50),
   modelTransfer  varchar(50),
   modelControl  varchar(50),
   modelRegVoltage  varchar(50),
   modelRegVelocity  varchar(50),
   modelCharger  varchar(50),
   oilChange  date,
   brandMotor  varchar(50),
   modelMotor  varchar(50),
   serialMotor  varchar(50),
   cplMotor  varchar(50),
   brandGenerator  varchar(50),
   modelGenerator  varchar(50),
   serialGenerator  varchar(50),
   powerWattGenerator  varchar(50),
   tensionGenerator  varchar(50),
   tuningDate  date,
   tankCapacity  varchar(50),
   pumpFuelModel  varchar(50),
   filterFuelFlag  bit(1),
   filterOilFlag  bit(1),
   filterWaterFlag  bit(1),
   filterAirFlag  bit(1),
   brandGear  varchar(50),
   brandBattery  varchar(50),
   clockLecture  varchar(50),
   serviceCorrective  date,
   observations  varchar(1000),
   created  datetime,
   createdBy  varchar(50),
   createdByUsr  varchar(50)
)
BEGIN

insert into epService
(serviceOrderId,brandPE,modelPE,serialPE,transferType,modelTransfer,modelControl,modelRegVoltage,modelRegVelocity,modelCharger,oilChange,brandMotor,modelMotor,serialMotor,cplMotor,brandGenerator,modelGenerator,serialGenerator,powerWattGenerator,tensionGenerator,tuningDate,tankCapacity,pumpFuelModel,filterFuelFlag,filterOilFlag,filterWaterFlag,filterAirFlag,brandGear,brandBattery,clockLecture,serviceCorrective,observations,created,createdBy,createdByUsr)
VALUES
(serviceOrderId,brandPE,modelPE,serialPE,transferType,modelTransfer,modelControl,modelRegVoltage,modelRegVelocity,modelCharger,oilChange,brandMotor,modelMotor,serialMotor,cplMotor,brandGenerator,modelGenerator,serialGenerator,powerWattGenerator,tensionGenerator,tuningDate,tankCapacity,pumpFuelModel,filterFuelFlag,filterOilFlag,filterWaterFlag,filterAirFlag,brandGear,brandBattery,clockLecture,serviceCorrective,observations,created,createdBy,createdByUsr);
select LAST_INSERT_ID();
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceSurvey
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceSurvey$$
CREATE PROCEDURE blackstarDb.AddepServiceSurvey (
	epServiceId  int(11)  ,
   levelOilFlag  bit(1)  ,
   levelWaterFlag  bit(1)  ,
   levelBattery  varchar(50)  ,
   tubeLeak  bit(1)  ,
   batteryCap  varchar(50)  ,
   batterySulfate  varchar(50)  ,
   levelOil varchar(50)  ,
   heatEngine  varchar(50)  ,
   hoseOil  varchar(50)  ,
   hoseWater  varchar(50)  ,
   tubeValve  varchar(50)  ,
   stripBlades  varchar(50) 
)
BEGIN
insert into epServiceSurvey
(epServiceId,levelOilFlag,levelWaterFlag,levelBattery,tubeLeak,batteryCap,batterySulfate,levelOil,heatEngine,hoseOil,hoseWater,tubeValve,stripBlades)
values
(epServiceId,levelOilFlag,levelWaterFlag,levelBattery,tubeLeak,batteryCap,batterySulfate,levelOil,heatEngine,hoseOil,hoseWater,tubeValve,stripBlades);

END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceWorkBasic
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceWorkBasic$$
CREATE PROCEDURE blackstarDb.AddepServiceWorkBasic (
   epServiceId  int(11)  ,
   washEngine  bit(1)  ,
   washRadiator  bit(1)  ,
   cleanWorkArea  bit(1)  ,
   conectionCheck  bit(1)  ,
   cleanTransfer  bit(1)  ,
   cleanCardControl  bit(1)  ,
   checkConectionControl  bit(1)  ,
   checkWinding  bit(1)  ,
   batteryTests  bit(1)  ,
   checkCharger  bit(1)  ,
   checkPaint  bit(1)  ,
   cleanGenerator  bit(1) 
)
BEGIN
insert into epServiceWorkBasic
(epServiceId,washEngine,washRadiator,cleanWorkArea,conectionCheck,cleanTransfer,cleanCardControl,checkConectionControl,checkWinding,batteryTests,checkCharger,checkPaint,cleanGenerator)
values
(epServiceId,washEngine,washRadiator,cleanWorkArea,conectionCheck,cleanTransfer,cleanCardControl,checkConectionControl,checkWinding,batteryTests,checkCharger,checkPaint,cleanGenerator);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceDynamicTest
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceDynamicTest$$
CREATE PROCEDURE blackstarDb.AddepServiceDynamicTest (
   epServiceId  int(11)  ,
   vacuumFrequency  varchar(50),
   chargeFrequency  varchar(50),
   bootTryouts  varchar(50),
   vacuumVoltage  varchar(50),
   chargeVoltage  varchar(50),
   qualitySmoke  varchar(50),
   startTime  varchar(50),
   transferTime  varchar(50),
   stopTime  varchar(50) 
)
BEGIN
insert into epServiceDynamicTest
(epServiceId,vacuumFrequency,chargeFrequency,bootTryouts,vacuumVoltage,chargeVoltage,qualitySmoke,startTime,transferTime,stopTime)
values
(epServiceId,vacuumFrequency,chargeFrequency,bootTryouts,vacuumVoltage,chargeVoltage,qualitySmoke,startTime,transferTime,stopTime);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceTestProtection
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceTestProtection$$
CREATE PROCEDURE blackstarDb.AddepServiceTestProtection (
   epServiceId  int(11)  ,
   tempSensor  varchar(50),
   oilSensor  varchar(50),
   voltageSensor  varchar(50),
   overSpeedSensor  varchar(50),
   oilPreasureSensor  varchar(50),
    waterLevelSensor  varchar(50) 
)
BEGIN
insert into epServiceTestProtection
(epServiceId,tempSensor,oilSensor,voltageSensor,overSpeedSensor,oilPreasureSensor,waterLevelSensor)
values
(epServiceId,tempSensor,oilSensor,voltageSensor,overSpeedSensor,oilPreasureSensor,waterLevelSensor);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceTransferSwitch
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceTransferSwitch$$
CREATE PROCEDURE blackstarDb.AddepServiceTransferSwitch (
   epServiceId  int(11)  ,
   mechanicalStatus  varchar(10),
   boardClean  bit(1),
	lampTest  bit(1),
   screwAdjust  bit(1),
   conectionAdjust  bit(1),
   systemMotors  varchar(10),
   electricInterlock  varchar(10),
   mechanicalInterlock  varchar(10),
   capacityAmp  varchar(50)  
)
BEGIN
insert into epServiceTransferSwitch
(epServiceId,mechanicalStatus,boardClean,screwAdjust,lampTest,conectionAdjust,systemMotors,electricInterlock,mechanicalInterlock,capacityAmp)
values
(epServiceId,mechanicalStatus,boardClean,screwAdjust,lampTest,conectionAdjust,systemMotors,electricInterlock,mechanicalInterlock,capacityAmp);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceLectures
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceLectures$$
CREATE PROCEDURE blackstarDb.AddepServiceLectures (
   epServiceId  int(11)  ,
   voltageABAN  varchar(50),
   voltageACCN  varchar(50),
   voltageBCBN  varchar(50),
   voltageNT  varchar(50),
   currentA  varchar(50),
   currentB  varchar(50),
   currentC  varchar(50),
   frequency  varchar(50),
   oilPreassure  varchar(50),
   temp  varchar(50)  
)
BEGIN
insert into epServiceLectures
(epServiceId,voltageABAN,voltageACCN,voltageBCBN,voltageNT,currentA,currentB,currentC,frequency,oilPreassure,temp)
values
(epServiceId,voltageABAN,voltageACCN,voltageBCBN,voltageNT,currentA,currentB,currentC,frequency,oilPreassure,temp);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceParams
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceParams$$
CREATE PROCEDURE blackstarDb.AddepServiceParams (
   epServiceId  int(11)  ,
   adjsutmentTherm  varchar(10)  ,
   current  varchar(10)  ,
   batteryCurrent  varchar(10)  ,
   clockStatus  varchar(10)  ,
   trasnferTypeProtection  varchar(10)  ,
   generatorTypeProtection  varchar(10)  
)
BEGIN
insert into epServiceParams
(epServiceId,adjsutmentTherm,current,batteryCurrent,clockStatus,trasnferTypeProtection,generatorTypeProtection)
values
(epServiceId,adjsutmentTherm,current,batteryCurrent,clockStatus,trasnferTypeProtection,generatorTypeProtection);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddplainService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddplainService$$
CREATE PROCEDURE blackstarDb.AddplainService (
   serviceOrderId  int(11)  ,
   troubleDescription  TEXT,
   techParam  TEXT,
   workDone  TEXT,
   materialUsed  TEXT,
   observations  TEXT,
   created  datetime  ,
   createdBy  varchar(50)  ,
   createdByUsr  varchar(50) 
)
BEGIN
insert into plainService
(serviceOrderId,troubleDescription,techParam,workDone,materialUsed,observations,created,createdBy,createdByUsr)
values
(serviceOrderId,troubleDescription,techParam,workDone,materialUsed,observations,created,createdBy,createdByUsr);
select LAST_INSERT_ID();
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddupsService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddupsService$$
CREATE PROCEDURE blackstarDb.AddupsService (
  serviceOrderId int(11) ,
  estatusEquipment varchar(50) ,
  cleaned bit(1) ,
  hooverClean bit(1) ,
  verifyConnections bit(1) ,
  capacitorStatus varchar(50) ,
  verifyFuzz bit(1) ,
  chargerReview bit(1) ,
  fanStatus varchar(50) ,
  observations nvarchar(250),
  created datetime ,
  createdBy varchar(50) ,
  createdByUsr varchar(50) 
)
BEGIN
insert into upsService
(serviceOrderId,estatusEquipment,cleaned,hooverClean,verifyConnections,capacitorStatus,verifyFuzz,chargerReview,fanStatus,observations,created,createdBy,createdByUsr)
values
(serviceOrderId,estatusEquipment,cleaned,hooverClean,verifyConnections,capacitorStatus,verifyFuzz,chargerReview,fanStatus,observations,created,createdBy,createdByUsr);
select LAST_INSERT_ID();
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddupsServiceBatteryBank
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddupsServiceBatteryBank$$
CREATE PROCEDURE blackstarDb.AddupsServiceBatteryBank (
  upsServiceId int(11) ,
  checkConnectors bit(1) ,
  cverifyOutflow bit(1) ,
  numberBatteries int(11) ,
  manufacturedDateSerial varchar(200) ,
  damageBatteries varchar(50) ,
  other varchar(250) ,
  temp varchar(50) ,
  chargeTest bit(1) ,
  brandModel varchar(250) ,
  batteryVoltage varchar(50)
)
BEGIN
insert into upsServiceBatteryBank
(upsServiceId,checkConnectors,cverifyOutflow,numberBatteries,manufacturedDateSerial,damageBatteries,other,temp,chargeTest,brandModel,batteryVoltage)
values
(upsServiceId,checkConnectors,cverifyOutflow,numberBatteries,manufacturedDateSerial,damageBatteries,other,temp,chargeTest,brandModel,batteryVoltage);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddupsServiceGeneralTest
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddupsServiceGeneralTest$$
CREATE PROCEDURE blackstarDb.AddupsServiceGeneralTest (
  upsServiceId int(11) ,
  trasferLine varchar(50) ,
  transferEmergencyPlant varchar(50) ,
  backupBatteries varchar(50) ,
  verifyVoltage varchar(50) 
)
BEGIN
insert into upsServiceGeneralTest
(upsServiceId,trasferLine,transferEmergencyPlant,backupBatteries,verifyVoltage)
values
(upsServiceId,trasferLine,transferEmergencyPlant,backupBatteries,verifyVoltage);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddupsServiceParams
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddupsServiceParams$$
CREATE PROCEDURE blackstarDb.AddupsServiceParams (
  upsServiceId int(11) ,
  inputVoltagePhase varchar(50),
  inputVoltageNeutro varchar(50),
  inputVoltageNeutroGround varchar(50),
  percentCharge varchar(50),
  outputVoltagePhase varchar(50),
  outputVoltageNeutro varchar(50),
  inOutFrecuency varchar(50),
  busVoltage varchar(50) 
)
BEGIN
insert into upsServiceParams
(upsServiceId,inputVoltagePhase,inputVoltageNeutro,inputVoltageNeutroGround,percentCharge,outputVoltagePhase,outputVoltageNeutro,inOutFrecuency,busVoltage)
values
(upsServiceId,inputVoltagePhase,inputVoltageNeutro,inputVoltageNeutroGround,percentCharge,outputVoltagePhase,outputVoltageNeutro,inOutFrecuency,busVoltage);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddserviceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddserviceOrder$$
CREATE PROCEDURE blackstarDb.AddserviceOrder (
  serviceOrderNumber varchar(50) ,
  serviceTypeId char(1) ,
  ticketId int(11) ,
  policyId int(11) ,
  serviceUnit varchar(10) ,
  serviceDate datetime ,
  responsible varchar(100) ,
  additionalEmployees varchar(400) ,
  receivedBy varchar(100) ,
  serviceComments text,
  serviceStatusId char(1) ,
  closed datetime ,
  consultant varchar(100) ,
  coordinator varchar(100) ,
  asignee varchar(50) ,
  hasErrors tinyint(4) ,
  isWrong tinyint(4) ,
  signCreated text,
  signReceivedBy text,
  receivedByPosition varchar(50) ,
  created datetime ,
  createdBy varchar(50) ,
  createdByUsr varchar(50) ,
  receivedByEmail varchar(100),
  openCustomerId int(11),
  serviceEndDate datetime,
  hasPdf int
)
BEGIN
insert into serviceOrder
(serviceOrderNumber,serviceTypeId,ticketId,policyId,serviceUnit,serviceDate,responsible,additionalEmployees,receivedBy,serviceComments,serviceStatusId,closed,consultant,coordinator,asignee,hasErrors,isWrong,signCreated,signReceivedBy,receivedByPosition,created,createdBy,createdByUsr,receivedByEmail,openCustomerId,serviceEndDate,hasPdf)
values
(serviceOrderNumber,serviceTypeId,ticketId,policyId,serviceUnit,serviceDate,responsible,additionalEmployees,receivedBy,serviceComments,serviceStatusId,closed,consultant,coordinator,asignee,hasErrors,isWrong,signCreated,signReceivedBy,receivedByPosition,created,createdBy,createdByUsr,receivedByEmail,openCustomerId,serviceEndDate,hasPdf);
select LAST_INSERT_ID();

END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.UpdateServiceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpdateServiceOrder$$
CREATE PROCEDURE blackstarDb.UpdateServiceOrder (
  serviceOrderId int(11),
  serviceStatusId char(1) ,
  closed datetime ,
  asignee varchar(50) ,
  isWrong tinyint(4) ,
  modified datetime ,
  modifiedBy varchar(50) ,
  modifiedByUsr varchar(50),
  hasPdf int
)
BEGIN
	UPDATE serviceOrder s SET
	s.serviceStatusId = serviceStatusId ,
	s.closed = closed ,
	s.asignee = asignee ,
	s.isWrong = isWrong,
	s.modified = modified ,
	s.modifiedBy = modifiedBy ,
	s.modifiedByUsr = modifiedByUsr,
	s.hasPdf = hasPdf
	WHERE s.serviceOrderId = serviceOrderId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrderByUser
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrderByUser$$
CREATE PROCEDURE blackstarDb.GetServiceOrderByUser ()
BEGIN

	SELECT 
		serviceOrderId,
		serviceOrderNumber 
	FROM serviceOrder 
	WHERE created >= CURDATE() 
	ORDER BY createdByUsr;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddSurveyService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddSurveyService$$
CREATE PROCEDURE blackstarDb.AddSurveyService(
	company varchar(255),
	namePerson varchar(255),
	email varchar(255),
	phone varchar(255),
	surveyDate datetime,
	questiontreatment varchar(255),
	reasontreatment varchar(255),
	questionIdentificationPersonal varchar(255),
	questionIdealEquipment varchar(255),
	reasonIdealEquipment varchar(255),
	questionTime varchar(255),
	reasonTime varchar(255),
	questionUniform varchar(255),
	reasonUniform varchar(255),
	score int,
	sign text,
	suggestion varchar(255),
	created datetime,
	createdBy varchar(100),
	createdByUsr varchar(100)
)
BEGIN 
	INSERT INTO surveyService 
		(company,namePerson,email,phone,surveyDate,questiontreatment,reasontreatment,questionIdentificationPersonal,questionIdealEquipment,reasonIdealEquipment,questionTime,reasonTime,questionUniform,reasonUniform,score,sign,suggestion,created,createdBy,createdByUsr)
	VALUES
		(company,namePerson,email,phone,surveyDate,questiontreatment,reasontreatment,questionIdentificationPersonal,questionIdealEquipment,reasonIdealEquipment,questionTime,reasonTime,questionUniform,reasonUniform,score,sign,suggestion,created,createdBy,createdByUsr);
select LAST_INSERT_ID();
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetsurveyServiceById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetsurveyServiceById$$
CREATE PROCEDURE blackstarDb.GetsurveyServiceById(pSurveyServiceId INTEGER)
BEGIN
	SELECT 
		surveyServiceId,
		company,
		namePerson as name,
		email,
		phone,
		surveyDate as date,
		questionTreatment,
		reasonTreatment,
		questionIdentificationPersonal,
		questionIdealEquipment,
		reasonIdealEquipment,
		questionTime,
		reasonTime,
		questionUniform,
		reasonUniform,
		score,
		sign,
		suggestion
	FROM surveyService 
	WHERE surveyServiceId = pSurveyServiceId;
END$$
-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;

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
-- ---------------------------------------------------------------------------
-- 1    08/08/2013  SAG  	Se aumenta el tamaño de ticket.serialNumber
-- ---------------------------------------------------------------------------
-- 2    04/03/2014  SAG  	Se agregan columnas de portal
-- ---------------------------------------------------------------------------
-- 3    19/03/2014  SAG  	Se agrega tabla equipmentUserSync
-- ---------------------------------------------------------------------------
-- 4	01/04/2014	SAG		Se agrega processed a ticket 
-- ---------------------------------------------------------------------------
-- 5 	03/04/2014	SAG 	Se incrementa tamaño de campos de contacto
-- ---------------------------------------------------------------------------
-- 6 	10/04/2014	SAG 	Se incrementa tamaño de numero de serie
--							Se incrementa tamaño de finalUser
-- ---------------------------------------------------------------------------
-- 7	26/02/2014	SAG 	Se incremeta tamaño de numero de serie (serviceTx)
-- ---------------------------------------------------------------------------
-- 8	28/05/2014	SAG 	Se incremeta tamaño de customer (serviceTx)
-- ---------------------------------------------------------------------------
-- 9	23/06/2014	SAG		Se agregan campos de detalle del equipo a serviceTx
-- ---------------------------------------------------------------------------
-- 10	30/06/2014	SAG		Se incrementa tamaño de equipmentUser y contact en policy
-- ---------------------------------------------------------------------------


USE blackstarDbTransfer;


DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDbTransfer.upgradeSchema$$
CREATE PROCEDURE blackstarDbTransfer.upgradeSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

	-- Aumentando capacidad de equipmentUser de policy
	ALTER TABLE policy MODIFY equipmentUser VARCHAR(400);
	ALTER TABLE policy MODIFY contact VARCHAR(200);

	-- Agregando detalle del equipo a serviceTx
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'serviceTx' AND COLUMN_NAME = 'equipmentTypeId') = 0  THEN
		ALTER TABLE serviceTx ADD equipmentTypeId CHAR(1);
	END IF;
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'serviceTx' AND COLUMN_NAME = 'brand') = 0  THEN
		ALTER TABLE serviceTx ADD brand VARCHAR(100);
	END IF;
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'serviceTx' AND COLUMN_NAME = 'model') = 0  THEN
		ALTER TABLE serviceTx ADD model VARCHAR(100);
	END IF;
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'serviceTx' AND COLUMN_NAME = 'capacity') = 0  THEN
		ALTER TABLE serviceTx ADD capacity VARCHAR(100);
	END IF;
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'serviceTx' AND COLUMN_NAME = 'employeeId') = 0  THEN
		ALTER TABLE serviceTx ADD employeeId VARCHAR(400);
	END IF;

	-- Aumentando capacidad de campos de serviceTx
	ALTER TABLE serviceTx MODIFY customer VARCHAR(200);

	-- Aumentando capacidad de campos de serviceTx
	ALTER TABLE serviceTx MODIFY serialNumber VARCHAR(200);

	-- Aumentando capacidad de campos de policy
	ALTER TABLE policy MODIFY serialNumber VARCHAR(200);
	ALTER TABLE policy MODIFY finalUser VARCHAR(200);

	-- Aumentando capacidad de campos de contacto
	ALTER TABLE ticket MODIFY contact VARCHAR(200);
	ALTER TABLE ticket MODIFY contactPhone VARCHAR(200);
	ALTER TABLE ticket MODIFY contactEmail VARCHAR(200);
	
	-- Agregando ticket.processed
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'ticket' AND COLUMN_NAME = 'processed') = 0  THEN
		ALTER TABLE blackstarDbTransfer.ticket ADD processed INT NULL DEFAULT 1;
	END IF;

	-- Agregando equipmentUserSync
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'equipmentUserSync') = 0 THEN
		 CREATE TABLE blackstarDbTransfer.equipmentUserSync(
			equipmentUserSyncId INTEGER NOT NULL AUTO_INCREMENT,
			customerName VARCHAR(500),
			equipmentUser VARCHAR(100) NULL,
			KEY(equipmentUserSyncId)
		) ENGINE=INNODB;

	END IF;

	ALTER TABLE blackstarDbTransfer.ticket MODIFY serialNumber VARCHAR(100) NULL DEFAULT NULL;

	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'policy' AND COLUMN_NAME = 'equipmentUser') = 0  THEN
		ALTER TABLE blackstarDbTransfer.policy ADD equipmentUser VARCHAR(100) NULL DEFAULT NULL;
	END IF;

	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'ticket' AND COLUMN_NAME = 'project') = 0  THEN
		ALTER TABLE blackstarDbTransfer.ticket ADD project  VARCHAR(100) NULL DEFAULT NULL;
	END IF;


-- -----------------------------------------------------------------------------
-- FIN SECCION DE CAMBIOS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDbTransfer.upgradeSchema();

DROP PROCEDURE blackstarDbTransfer.upgradeSchema;

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
-- 2    08/11/2013  SAG  	Se convierte a SP
-- -----------------------------------------------------------------------------
-- 3    13/03/2014  SAG  	Soporte para un equipo en mas de una poliza
-- -----------------------------------------------------------------------------
-- 4	01/04/2014	SAG		Se implementa modelo STTP para tickets
-- -----------------------------------------------------------------------------
-- 5	28/05/2014	SAG		Correcciones de duplicacion en OS
-- -----------------------------------------------------------------------------
-- 6	23/06/2014	SAG		Se agrega referencia a open customer para OS importadas
-- -----------------------------------------------------------------------------
-- 7 	24/07/2014	SAG 	Se implementa multi usuario cliente de poliza
-- -----------------------------------------------------------------------------
-- 8 	30/07/2014	SAG 	Se implementa UpsertPolicy
-- -----------------------------------------------------------------------------
-- 9 	30/07/2014	SAG 	Se implementa UpsertServiceOrder
-- -----------------------------------------------------------------------------

use blackstarDbTransfer;


DELIMITER $$


-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertServiceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS upsertServiceOrder $$
CREATE PROCEDURE upsertServiceOrder(
	pServiceNumber varchar(50),
	pTicketNumber varchar(50),
	pServiceUnit varchar(10),
	pProject varchar(50),
	pCustomer varchar(200),
	pCity varchar(50),
	pAddress varchar(300),
	pServiceTypeId char(1),
	pServiceDate datetime,
	pSerialNumber varchar(200),
	pResponsible varchar(100),
	pReceivedBy varchar(100),
	pServiceComments text,
	pClosed datetime,
	pFollowUp text,
	pSpares text,
	pConsultant varchar(100),
	pContractorCompany varchar(100),
	pServiceRate int(11),
	pCustomerComments text,
	pCreated datetime,
	pCreatedBy varchar(45),
	pCreatedByUsr varchar(45),
	pEquipmentTypeId char(1),
	pBrand varchar(100),
	pModel varchar(100),
	pCapacity varchar(100),
	pEmployeeId varchar(400)
)
BEGIN
	IF(SELECT count(*) FROM serviceTx WHERE serviceNumber = pServiceNumber) = 0 THEN
		INSERT INTO blackstarDbTransfer.serviceTx(
			serviceNumber,  ticketNumber,  serviceUnit,  project,  customer,  city,  address,  serviceTypeId,  serviceDate,  serialNumber,  responsible,  receivedBy,  serviceComments,  closed,  followUp,  spares,  consultant,  contractorCompany,  serviceRate,  customerComments,  created,  createdBy,  createdByUsr,  equipmentTypeId,  brand,  model,  capacity,  employeeId )
		SELECT
			pServiceNumber, pTicketNumber, pServiceUnit, pProject, pCustomer, pCity, pAddress, pServiceTypeId, pServiceDate, pSerialNumber, pResponsible, pReceivedBy, pServiceComments, pClosed, pFollowUp, pSpares, pConsultant, pContractorCompany, pServiceRate, pCustomerComments, pCreated, pCreatedBy, pCreatedByUsr, pEquipmentTypeId, pBrand, pModel, pCapacity, pEmployeeId;
	ELSE
		UPDATE serviceTx SET
			employeeId = pEmployeeId
		WHERE serviceNumber = pServiceNumber;
	END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.upsertPolicy
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS upsertPolicy $$
CREATE PROCEDURE upsertPolicy(
	  pOffice VARCHAR(50),
	  pPolicyType VARCHAR(50),
	  pCustomerContract VARCHAR(50),
	  pCustomer VARCHAR(100),
	  pFinalUser VARCHAR(200),
	  pProject VARCHAR(50),
	  pCst VARCHAR(50),
	  pEquipmentTypeId CHAR(1),
	  pBrand VARCHAR(50),
	  pModel VARCHAR(100),
	  pSerialNumber VARCHAR(100),
	  pCapacity VARCHAR(50),
	  pEquipmentAddress VARCHAR(250),
	  pEquipmentLocation VARCHAR(250),
	  pContact VARCHAR(100),
	  pContactEmail VARCHAR(200),
	  pContactPhone VARCHAR(200),
	  pStartDate DATETIME,
	  pEndDate DATETIME,
	  pVisitsPerYear INT(11),
	  pResponseTimeHr INT(11),
	  pSolutionTimeHr INT(11),
	  pPenalty TEXT,
	  pService VARCHAR(50),
	  pIncludesParts TINYINT(1),
	  pExceptionParts VARCHAR(100),
	  pServiceCenter VARCHAR(50),
	  pObservations TEXT,
	  pEquipmentUser VARCHAR(200),
	  pCreated DATETIME,
	  pCreatedBy VARCHAR(45),
	  pCreatedByUsr VARCHAR(45))
BEGIN
	IF (SELECT count(*) FROM policy p WHERE p.serialNumber = pSerialNumber AND p.project = pProject) = 0 THEN
		INSERT INTO blackstarDbTransfer.policy(office,  policyType,  customerContract,  customer,  finalUser,  project,  cst,  equipmentTypeId,  brand,  model,  serialNumber,  capacity,  equipmentAddress,  equipmentLocation,  contact,  contactEmail,  contactPhone,  startDate,  endDate,  visitsPerYear,  responseTimeHr,  solutionTimeHr,  penalty,  service,  includesParts,  exceptionParts,  serviceCenter,  observations,  created,  createdBy,  createdByUsr,  equipmentUser)
										SELECT 	pOffice, pPolicyType, pCustomerContract, pCustomer, pFinalUser, pProject, pCst, pEquipmentTypeId, pBrand, pModel, pSerialNumber, pCapacity, pEquipmentAddress, pEquipmentLocation, pContact, pContactEmail, pContactPhone, pStartDate, pEndDate, pVisitsPerYear, pResponseTimeHr, pSolutionTimeHr, pPenalty, pService, pIncludesParts, pExceptionParts, pServiceCenter, pObservations, pCreated, pCreatedBy, pCreatedByUsr, pEquipmentUser;
	ELSE
		UPDATE blackstarDbTransfer.policy SET 
			startDate = pStartDate,
			endDate = pEndDate,
			serviceCenter = pServiceCenter,
			equipmentUser = pEquipmentUser,
			equipmentAddress = equipmentAddress,
			contact = pContact,
			contactEmail = pContactEmail,
			contactPhone = pContactPhone,
			modified = now(),
			modifiedBy = 'UpsertPolicy'
		WHERE serialNumber = pSerialNumber AND project = pProject;
	END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.syncPolicyUsers
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS syncPolicyUsers $$
CREATE PROCEDURE syncPolicyUsers()
BEGIN

    DECLARE id INT DEFAULT 0;
    DECLARE value TEXT;
    DECLARE occurance INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE splitted_value VARCHAR(1000);
    DECLARE done INT DEFAULT 0;
    DECLARE cur1 CURSOR FOR 
    	SELECT p2.policyId, p1.equipmentUser
		FROM blackstarDbTransfer.policy p1
			INNER JOIN blackstarDb.policy p2 ON p1.serialNumber = p2.serialNumber AND p1.brand = p2.brand AND p1.model = p2.model
		WHERE IFNULL(p1.equipmentUser, '') != '';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
   
	CREATE TEMPORARY TABLE rawPolicyEquipment(policyId INT, user VARCHAR(200));

    OPEN cur1;
      read_loop: LOOP
        FETCH cur1 INTO id, value;
        IF done THEN
          LEAVE read_loop;
        END IF;

        SET value = REPLACE(value,' ','');
        SET occurance = (SELECT LENGTH(value)
                                 - LENGTH(REPLACE(value, ',', ''))
                                 +1);
        SET i=1;
        WHILE i <= occurance DO
          SET splitted_value =
          (SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(value, ',', i),
          LENGTH(SUBSTRING_INDEX(value, ',', i - 1)) + 1), ',', ''));

          INSERT INTO rawPolicyEquipment(policyId, user) VALUES (id, splitted_value);
          SET i = i + 1;

        END WHILE;
      END LOOP;

    CLOSE cur1;

    -- Insertando los valores reales
    TRUNCATE TABLE blackstarDb.policyEquipmentUser;

    INSERT INTO blackstarDb.policyEquipmentUser(policyId, equipmentUserId)
    SELECT DISTINCT policyId, user 
    FROM rawPolicyEquipment;

    DROP TEMPORARY TABLE rawPolicyEquipment;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.ExecuteTransfer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDbTransfer.ExecuteTransfer$$
CREATE PROCEDURE blackstarDbTransfer.ExecuteTransfer()
BEGIN
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
		equipmentUser,
		created,
		createdBy,
		crratedByUsr
	)
	SELECT o.officeId, p.policyType, p.customerContract, p.customer, p.finalUser, p.project, p.cst, p.equipmentTypeId, p.brand, p.model,
		p.serialNumber, p.capacity, p.equipmentAddress, p.equipmentLocation, p.contact, p.contactPhone, p.contactEmail, p.startDate, p.endDate, p.visitsPerYear,
		p.responseTimeHR, p.solutionTimeHR, p.penalty, p.service, p.includesParts, p.exceptionParts, s.serviceCenterId, p.observations, p.equipmentUser,
		CURRENT_DATE(), 'PolicyTransfer', 'portal-servicios'
	FROM blackstarDbTransfer.policy p
		INNER JOIN blackstarDb.office o ON p.office = o.officeName
		INNER JOIN blackstarDb.serviceCenter s ON s.serviceCenter = p.serviceCenter
		LEFT OUTER JOIN blackstarDb.policy bp on p.serialNumber = bp.serialNumber AND p.project = bp.project
	WHERE bp.policyId IS NULL;

	-- ACTUALIZAR LAS POLIZAS
	UPDATE blackstarDb.policy bp 
		INNER JOIN blackstarDbTransfer.policy p ON p.serialNumber = bp.serialNumber AND p.project = bp.project
		INNER JOIN blackstarDb.serviceCenter s ON s.serviceCenter = p.serviceCenter
	SET
		bp.startDate = p.startDate,
		bp.endDate = p.endDate,
		bp.serviceCenterId = s.serviceCenterId,
		bp.equipmentAddress = p.equipmentAddress,
		bp.contactName = p.contact,
		bp.contactPhone = p.contactPhone,
		bp.contactEmail = p.contactEmail;

	-- ACTUALIZAR LOS CORREOS DE ACCESO A CLIENTES
	CALL syncPolicyUsers();

-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
	-- INSERTAR TICKETS NUEVOS
	INSERT INTO blackstarDb.ticket(
		policyId,
		ticketNumber,
		createdBy,
		createdByUsr
	)
	SELECT p.policyId, tt.ticketNumber, 'TicketTransfer', 'portal-servicios'
	FROM blackstarDbTransfer.ticket tt
		INNER JOIN blackstarDbTransfer.policy pt ON tt.policyId = pt.policyId	
		INNER JOIN blackstarDb.policy p ON p.serialNumber = pt.serialNumber AND pt.serialNumber != 'NA' AND p.project = pt.project
	WHERE tt.ticketNumber NOT IN (SELECT ticketNumber FROM blackstarDb.ticket);

	-- ACTUALIZAR CERRADO SELECTIVO DE TICKETS
	UPDATE blackstarDb.ticket t 
		INNER JOIN blackstarDbTransfer.ticket tt ON t.ticketNumber = tt.ticketNumber SET
		t.closed = tt.closed
	WHERE tt.processed = 0
	AND t.closed IS NULL AND tt.closed IS NOT NULL;

	-- ACTUALIZACION DEL SERVICE ID DE CIERRE DEL TICKET
	UPDATE blackstarDb.ticket t
		INNER JOIN blackstarDbTransfer.ticket tt ON t.ticketNumber = tt.ticketNumber
		INNER JOIN blackstarDb.serviceOrder so ON tt.serviceOrderNumber = so.serviceOrderNumber	
	SET
		t.serviceOrderId = so.serviceOrderId
	WHERE tt.processed = 0;	

	-- ACTUALIZAR ESTATUS TICKETS EXISTENTES
	UPDATE blackstarDb.ticket t 
		INNER JOIN blackstarDbTransfer.ticket tt ON t.ticketNumber = tt.ticketNumber SET
		t.observations = tt.observations,
		t.phoneResolved = tt.phoneResolved,
		t.arrival = tt.arrival,
		t.employee = tt.employee,
		t.user = tt.user,
		t.created = tt.created,
		t.contact = tt.contact,
		t.contactPhone = tt.contactPhone,
		t.contactEmail = tt.contactEmail,
		tt.processed = 1
	WHERE tt.processed = 0;

	-- ACTUALIZAR TIEMPOS DE RESPUESTA
	UPDATE blackstarDb.ticket SET 
		realResponseTime =  TIMESTAMPDIFF(HOUR, created, arrival)
	WHERE arrival IS NOT NULL;
		
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
		
	-- CAMBIAR OBSERVATIONS POR FOLLOW UPS SOLO EN LOS TICKETS QUE NO TIENEN
	INSERT INTO blackstarDb.followUp(
		ticketId,
		asignee,
		followup,
		isSource,
		created,
		createdBy,
		createdByUsr
	)
	SELECT bt.ticketId, 'marlem.samano@gposac.com.mx', tt.followUp, 1, NOW(), 'TicketTransfer', 'portal-servicios'
	FROM blackstarDbTransfer.ticket tt 
		INNER JOIN blackstarDb.ticket bt ON tt.ticketNumber = bt.ticketNumber
		LEFT OUTER JOIN blackstarDb.followUp f ON bt.ticketId = f.ticketId
	WHERE tt.followUp IS NOT NULL
	AND f.followUpId IS NULL;
	
	-- ACTUALIZAR LOS FOLLOW UPS
	UPDATE blackstarDb.followUp bf
		INNER JOIN blackstarDb.ticket bt ON bt.ticketId = bf.ticketId
		INNER JOIN blackstarDbTransfer.ticket tt ON  tt.ticketNumber = bt.ticketNumber
	SET	
		bf.followUp = tt.followUp
	WHERE bf.isSource = 1;
	
	
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
		ot.serviceComments, ot.closed, ot.consultant, CURRENT_DATE(), 'ServiceOrderTransfer', 'portal-servicios'
	FROM blackstarDbTransfer.serviceTx ot
		LEFT OUTER JOIN blackstarDb.ticket t ON t.ticketNumber = ot.ticketNumber
		LEFT OUTER JOIN blackstarDb.policy p ON p.serialNumber = ot.serialNumber 
			AND ot.serialNumber != 'NA' 
			AND ot.serialNumber != 'XXXXXXXX' 
			AND ot.project = p.project 
			AND ot.serviceDate >= p.startDate 
			AND ot.serviceDate <= p.endDate
	WHERE ot.serviceNumber NOT IN (SELECT serviceOrderNumber FROM blackstarDb.serviceOrder);
		
	-- ACTUALIZACION DEL STATUS
	UPDATE blackstarDb.serviceOrder SET
		serviceStatusId = 'C'
	WHERE closed IS NOT NULL;
		
	-- CAMBIAR OBSERVATIONS POR FOLLOW UPS SOLO EN LOS TICKETS QUE NO TIENEN
	INSERT INTO blackstarDb.followUp(
		serviceOrderId,
		asignee,
		followup,
		isSource,
		created,
		createdBy,
		createdByUsr
	)
	SELECT o.serviceOrderId, 'angeles.avila@gposac.com.mx', st.followUp, 1, NOW(), 'TicketTransfer', 'portal-servicios'
	FROM blackstarDbTransfer.serviceTx st 
		INNER JOIN blackstarDb.serviceOrder o ON st.serviceNumber = o.serviceOrderNumber
		LEFT OUTER JOIN blackstarDb.followUp f ON o.serviceOrderId = f.serviceOrderId
	WHERE st.followUp IS NOT NULL
	AND f.followUpId IS NULL;

	-- ACTUALIZACION DEL ESTADO DE LOS TICKETS
	CALL blackstarDb.UpdateTicketStatus();
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
	
	-- ELIMINACION DE TABS QUE PROVOCAN PROBLEMAS AL CONVERTIR A JSON

	UPDATE blackstarDb.policy SET	
		observations = REPLACE( observations,'\t',' ');
		
	UPDATE blackstarDb.serviceOrder SET	
		serviceComments = REPLACE( serviceComments,'\t',' ');
		
	UPDATE blackstarDb.ticket SET	
		observations = REPLACE( observations,'\t',' ');

	UPDATE blackstarDb.followUp SET	
		followUp = REPLACE( followUp,'\t','');
		
	-- ELIMINACION DE RETORNOS DE CARRO QUE PROVOCAN PROBLEMAS AL CONVERTIR A JSON
	UPDATE blackstarDb.policy SET	
		equipmentAddress = REPLACE( equipmentAddress,'\n','');
		
	UPDATE blackstarDb.policy SET	
		equipmentLocation = REPLACE( equipmentLocation,'\n','');
		
	UPDATE blackstarDb.policy SET	
		penalty = REPLACE( penalty,'\n','');
		
	UPDATE blackstarDb.policy SET	
		observations = REPLACE( observations,'\n','');
		
	UPDATE blackstarDb.policy SET	
		contactPhone = REPLACE( contactPhone,'\n','');
		
	UPDATE blackstarDb.policy SET	
		contactEmail = REPLACE( contactEmail,'\n','');

	UPDATE blackstarDb.serviceOrder SET	
		serviceComments = REPLACE( serviceComments,'\n','');
		
	UPDATE blackstarDb.ticket SET	
		observations = REPLACE( observations,'\n','');
	
	UPDATE blackstarDb.ticket SET	
		employee = REPLACE( employee,'\n','');

	UPDATE blackstarDb.followUp SET	
		followUp = REPLACE( followUp,'\n','');
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
	-- SINCRONIZACION Y ACCESO A USUARIOS DE CLIENTES
	INSERT INTO blackstarDbTransfer.equipmentUserSync (customerName, equipmentUser)
	SELECT DISTINCT customer, equipmentUserId 
	FROM blackstarDb.policy p 
		INNER JOIN blackstarDb.policyEquipmentUser e ON p.policyId = e.policyId
		LEFT OUTER JOIN blackstarDb.blackstarUser u ON e.equipmentUserId = u.email
	WHERE ifnull(equipmentUser, '') != ''
	AND u.blackstarUserId IS NULL;

	IF (SELECT count(*) FROM equipmentUserSync) > 1 THEN
	    SET @c = (SELECT min(equipmentUserSyncId) FROM equipmentUserSync) ;   
	    SET @max = (SELECT max(equipmentUserSyncId) FROM equipmentUserSync) ;   
	    SET @customer = '';
	    SET @access = '';
	    WHILE @c <= @max DO
	    	SET  @customer = (SELECT customerName FROM blackstarDbTransfer.equipmentUserSync WHERE equipmentUserSyncId = @c);
	    	SET  @access = (SELECT equipmentUser FROM blackstarDbTransfer.equipmentUserSync WHERE equipmentUserSyncId = @c);
	    	Call blackstarDb.UpsertUser(@access, @customer, null);
			Call blackstarDb.CreateUserGroup('sysCliente','Cliente',@access);

	      	SET @c = @c + 1 ;
	    END WHILE ;

	    DELETE FROM blackstarDbTransfer.equipmentUserSync;
    END IF;
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
	-- ACTUALIZACION DE OPEN CUSTOMER CON ORDENES DE SERVICIO IMPORTADAS
	INSERT INTO blackstarDb.openCustomer (customerName, address, equipmentTypeId, brand, model, capacity, serialNumber, contactName, officeId, project, transferSo, created, createdBy, createdByUsr)
	SELECT customer, address, equipmentTypeId, brand, model, capacity, serialNumber, receivedBy, officeId, project, serviceNumber, now(), 'ServiceOrderMigrationScript', 'sergio.aga'
	FROM blackstarDbTransfer.serviceTx s
		INNER JOIN blackstarDb.office o ON o.officeName = s.serviceUnit
	WHERE serviceNumber IN (
		SELECT serviceOrderNumber FROM blackstarDb.serviceOrder WHERE policyId is NULL AND openCustomerId is NULL
		AND createdby = 'ServiceOrderTransfer'
	);

	UPDATE blackstarDb.serviceOrder so
		INNER JOIN blackstarDb.openCustomer oc ON oc.transferSo = so.serviceOrderNumber
	SET so.openCustomerId = oc.openCustomerId
	WHERE so.policyId IS NULL AND so.openCustomerId IS NULL;

-- -----------------------------------------------------------------------------
	-- FIN 
-- -----------------------------------------------------------------------------
END$$
DELIMITER ;

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
		pLevel, NOW(), pError, pSender, pStackTrace;
	
END$$


-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;

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
-- -----------------------------------------------------------------------------
-- 2 	03/04/2014	SAG		Reemplazo de oficinas no-estandar
-- -----------------------------------------------------------------------------

use blackstarDbTransfer;

-- -----------------------------------------------------------------------------
-- ACTUALIZACION DE DATOS
-- -----------------------------------------------------------------------------

-- OFICINAS NO ESTANDAR
UPDATE policy SET serviceCenter = 'Villahermosa IS' WHERE serviceCenter = 'ISEC';

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
-- 1    22/10/2013  SAG  	Version inicial. Usuarios basicos de GPO Sac
-- --   --------   -------  ----------------------------------------------------
-- 2    12/11/2013  SAG  	Version 1.1. Se agrega ExecuteTransfer
-- -----------------------------------------------------------------------------
-- 3	24/04/2014	SAG		Se agrega poblacion de datos neceasrios para Issue
-- -----------------------------------------------------------------------------
-- 4	14/06/2014	SAG		Se agrega poblacion de surveyScore en serviceOrder
-- -----------------------------------------------------------------------------
-- 5 	08/07/2014	SAG 	Se actualiza SC Tijuana BK
-- -----------------------------------------------------------------------------
--	6	21/07/2014	SAG 	Se cambia Servicio de Descontaminacion de Data Center 
--								 por: Descontaminacion
-- -----------------------------------------------------------------------------

use blackstarDb;

-- -----------------------------------------------------------------------------
-- ACTUALIZACION DE DATOS
-- -----------------------------------------------------------------------------
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




