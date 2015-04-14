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
-- 28	09/09/2014	SAG 	Se permiten nulos en boleanos de OS - todos los formatos
-- ---------------------------------------------------------------------------
-- 29	24/10/2014	SAG 	Se incrementa campo contact en policy
-- ---------------------------------------------------------------------------
-- 30	03/11/2014	SAG 	Se agrega guid
-- ---------------------------------------------------------------------------
-- 31 	06/11/2014	SAG 	Se agrega suggestionFlag - 1 Bueno, 0 Malo
-- ---------------------------------------------------------------------------
-- 32 	24/11/2014	SAG 	Se agreta officeId a ScheduledService
-- ---------------------------------------------------------------------------
-- 33	22/01/2015	SAG 	Se agrega Global Settings
-- ---------------------------------------------------------------------------
-- 34	01/04/2015	SAG		Se agrega assignedBy a ticket, so, bloomTicket e issue
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.upgradeSchema$$
CREATE PROCEDURE blackstarDb.upgradeSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

-- AGREGANDO assignedBy
IF(SELECT count(*) FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'ticket' AND column_name = 'assignedBy' ) = 0 THEN
	ALTER TABLE ticket ADD assignedBy VARCHAR(100) NULL DEFAULT NULL;
END IF;

IF(SELECT count(*) FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'serviceOrder' AND column_name = 'assignedBy' ) = 0 THEN
	ALTER TABLE serviceOrder ADD assignedBy VARCHAR(100) NULL DEFAULT NULL;
END IF;

IF(SELECT count(*) FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'bloomTicket' AND column_name = 'assignedBy' ) = 0 THEN
	ALTER TABLE bloomTicket ADD assignedBy VARCHAR(100) NULL DEFAULT NULL;
END IF;

IF(SELECT count(*) FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'issue' AND column_name = 'assignedBy' ) = 0 THEN
	ALTER TABLE issue ADD assignedBy VARCHAR(100) NULL DEFAULT NULL;
END IF;

-- AGREGANDO TABLA globalSettings
IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'globalSettings') = 0 THEN
		 CREATE TABLE blackstarDb.globalSettings(
			globalSettingsId INT NOT NULL,
			engHourCost FLOAT(10,2) NOT NULL,
			PRIMARY KEY (globalSettingsId)
		) ENGINE=INNODB;
END IF;

-- AGREGANDO office a scheduledService
IF(SELECT count(*) FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'scheduledService' AND column_name = 'officeId' ) = 0 THEN
	ALTER TABLE scheduledService ADD officeId CHAR(1) NULL DEFAULT NULL;
	ALTER TABLE scheduledService ADD CONSTRAINT FK_scheduledService_office FOREIGN KEY (officeId) REFERENCES office(officeId);
END IF;

-- AGREGANDO suggestionFlag a surveyService
IF(SELECT count(*) FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'surveyService' AND column_name = 'suggestionFlag' ) = 0 THEN
	ALTER TABLE blackstarDb.surveyService ADD suggestionFlag INT NULL;
END IF;

-- AGREGANDO TABLA guid
IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'guid') = 0 THEN
		 CREATE TABLE blackstarDb.guid(
			guid VARCHAR(100) NOT NULL,
			expires DATETIME NOT NULL,
			PRIMARY KEY (guid)
		) ENGINE=INNODB;

		-- Eliminando columna equipmentUser de policy
		ALTER TABLE policy DROP COLUMN equipmentUser;
END IF;

-- INCREMENTANDO contact en policy
ALTER TABLE policy MODIFY contactName VARCHAR(200);

-- AGREGANDO INDICE asignee a followUp
-- ALTER TABLE followUp ADD INDEX (asignee);

-- AGREGANDO NULLS A BOLEANOS DE OS
-- AA
IF(SELECT DATA_TYPE FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'aaService' AND column_name = 'evaFlagCalibration') != 'INT' THEN
	ALTER TABLE blackstarDb.aaService MODIFY evaFlagCalibration INT;
	ALTER TABLE blackstarDb.aaService MODIFY evaReviewFilter INT;
	ALTER TABLE blackstarDb.aaService MODIFY evaReviewStrip INT;
	ALTER TABLE blackstarDb.aaService MODIFY evaCleanElectricSystem INT;
	ALTER TABLE blackstarDb.aaService MODIFY evaCleanControlCard INT;
	ALTER TABLE blackstarDb.aaService MODIFY evaCleanTray INT;
	ALTER TABLE blackstarDb.aaService MODIFY evaCheckFluidSensor INT;
	ALTER TABLE blackstarDb.aaService MODIFY evaRequirMaintenance INT;
	ALTER TABLE blackstarDb.aaService MODIFY condCleanElectricSystem INT;
	ALTER TABLE blackstarDb.aaService MODIFY condClean INT;
END IF;

-- BB
IF(SELECT DATA_TYPE FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'bbService' AND column_name = 'plugClean') != 'INT' THEN
	ALTER TABLE blackstarDb.bbService MODIFY plugClean INT; 
	ALTER TABLE blackstarDb.bbService MODIFY coverClean INT; 
	ALTER TABLE blackstarDb.bbService MODIFY capClean INT; 
	ALTER TABLE blackstarDb.bbService MODIFY groundClean INT; 
	ALTER TABLE blackstarDb.bbService MODIFY rackClean INT;
END IF;

-- EP - SERVICE
IF(SELECT DATA_TYPE FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'epService' AND column_name = 'filterFuelFlag') != 'INT' THEN
	ALTER TABLE blackstarDb.epService MODIFY filterFuelFlag INT;
	ALTER TABLE blackstarDb.epService MODIFY filterOilFlag INT;
	ALTER TABLE blackstarDb.epService MODIFY filterWaterFlag INT;
	ALTER TABLE blackstarDb.epService MODIFY filterAirFlag INT;
END IF;

-- EP - SURVEY
IF(SELECT DATA_TYPE FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'epServiceSurvey' AND column_name = 'levelOilFlag') != 'INT' THEN
	ALTER TABLE blackstarDb.epServiceSurvey MODIFY levelOilFlag INT; 
	ALTER TABLE blackstarDb.epServiceSurvey MODIFY levelWaterFlag INT; 
	ALTER TABLE blackstarDb.epServiceSurvey MODIFY tubeLeak INT;
END IF;

-- EP - TRANSFER SWITCH
IF(SELECT DATA_TYPE FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'epServiceTransferSwitch' AND column_name = 'boardClean') != 'INT' THEN
	ALTER TABLE blackstarDb.epServiceTransferSwitch MODIFY boardClean INT; 
	ALTER TABLE blackstarDb.epServiceTransferSwitch MODIFY screwAdjust INT; 
	ALTER TABLE blackstarDb.epServiceTransferSwitch MODIFY lampTest INT; 
	ALTER TABLE blackstarDb.epServiceTransferSwitch MODIFY conectionAdjust INT;
END IF;

-- EP - WORKBASIC
IF(SELECT DATA_TYPE FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'epServiceWorkBasic' AND column_name = 'washEngine') != 'INT' THEN
	ALTER TABLE blackstarDb.epServiceWorkBasic MODIFY washEngine INT; 
	ALTER TABLE blackstarDb.epServiceWorkBasic MODIFY washRadiator INT; 
	ALTER TABLE blackstarDb.epServiceWorkBasic MODIFY cleanWorkArea INT; 
	ALTER TABLE blackstarDb.epServiceWorkBasic MODIFY conectionCheck INT; 
	ALTER TABLE blackstarDb.epServiceWorkBasic MODIFY cleanTransfer INT; 
	ALTER TABLE blackstarDb.epServiceWorkBasic MODIFY cleanCardControl INT; 
	ALTER TABLE blackstarDb.epServiceWorkBasic MODIFY checkConectionControl INT; 
	ALTER TABLE blackstarDb.epServiceWorkBasic MODIFY checkWinding INT; 
	ALTER TABLE blackstarDb.epServiceWorkBasic MODIFY batteryTests INT; 
	ALTER TABLE blackstarDb.epServiceWorkBasic MODIFY checkCharger INT; 
	ALTER TABLE blackstarDb.epServiceWorkBasic MODIFY checkPaint INT; 
	ALTER TABLE blackstarDb.epServiceWorkBasic MODIFY cleanGenerator INT;
END IF;

-- UPS - SERVICE
IF(SELECT DATA_TYPE FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'upsService' AND column_name = 'cleaned') != 'INT' THEN
	ALTER TABLE blackstarDb.upsService MODIFY cleaned INT; 
	ALTER TABLE blackstarDb.upsService MODIFY hooverClean INT; 
	ALTER TABLE blackstarDb.upsService MODIFY verifyConnections INT; 
	ALTER TABLE blackstarDb.upsService MODIFY verifyFuzz INT; 
	ALTER TABLE blackstarDb.upsService MODIFY chargerReview INT;
END IF;

-- UPS - BATTERY BANK
IF(SELECT DATA_TYPE FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'upsServiceBatteryBank' AND column_name = 'checkConnectors') != 'INT' THEN
	ALTER TABLE blackstarDb.upsServiceBatteryBank MODIFY checkConnectors INT; 
	ALTER TABLE blackstarDb.upsServiceBatteryBank MODIFY cverifyOutflow INT; 
	ALTER TABLE blackstarDb.upsServiceBatteryBank MODIFY chargeTest INT;
END IF;

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
	-- ALTER TABLE serviceOrder ADD UNIQUE(serviceOrderNumber);
	
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