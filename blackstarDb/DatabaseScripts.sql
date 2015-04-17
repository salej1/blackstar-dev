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
-- 34	01/04/2015	SAG		Se agrega assignedBy a ticket, so, bloomTicket e issue
-- ---------------------------------------------------------------------------
-- 35 	16/04/2015	SAG 	Se agrega isActive a followUp
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.upgradeSchema$$
CREATE PROCEDURE blackstarDb.upgradeSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

-- Agregando isActive a followUp
IF(SELECT count(*) FROM information_schema.columns WHERE  table_schema = 'blackstarDb' AND table_name = 'followUp' AND column_name = 'isActive' ) = 0 THEN
	ALTER TABLE followUp ADD isActive INT NULL DEFAULT NULL;
	ALTER TABLE followUp ADD INDEX (isActive);
END IF;

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
-- -----------------------------------------------------------------------------
-- 61 	03/03/2015	SAG 	Se modifica:
--								GetAllServiceOrders		
--								GetLimitedServiceOrderList		
--								GetPolicyById
--								InsertTicket
--								UpdateTicketData
-- -----------------------------------------------------------------------------
-- 62	15/04/2015	SAG 	Se agrega setActiveFollowUp
-- -----------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

-- -----------------------------------------------------------------------------
	-- blackstarDb.setActiveFollowUp
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.setActiveFollowUp$$
CREATE PROCEDURE blackstarDb.setActiveFollowUp()
BEGIN
	IF(SELECT count(*) FROM followUp WHERE isActive = 1) = 0 THEN
		
		-- Tickets
		UPDATE followUp f
		INNER JOIN (
			SELECT * FROM (
				SELECT ticketId, max(followUpId) AS followUpId
				FROM followUp
				WHERE ticketId IS NOT NULL
				GROUP BY ticketId
			) a
		) b
			ON b.followUpId = f.followUpId
		SET isActive = 1;

		-- Service orders
		UPDATE followUp f
		INNER JOIN (
			SELECT * FROM (
				SELECT serviceOrderId, max(followUpId) AS followUpId
				FROM followUp
				WHERE serviceOrderId IS NOT NULL
				GROUP BY serviceOrderId
			) a
		) b
			ON b.followUpId = f.followUpId
		SET isActive = 1;

		-- BloomTickets
		UPDATE followUp f
		INNER JOIN (
			SELECT * FROM (
				SELECT bloomTicketId, max(followUpId) AS followUpId
				FROM followUp
				WHERE bloomTicketId IS NOT NULL
				GROUP BY bloomTicketId
			) a
		) b
			ON b.followUpId = f.followUpId
		SET isActive = 1;

		-- CodexProjects
		UPDATE followUp f
		INNER JOIN (
			SELECT * FROM (
				SELECT codexProjectId, max(followUpId) AS followUpId
				FROM followUp
				WHERE codexProjectId IS NOT NULL
				GROUP BY codexProjectId
			) a
		) b
			ON b.followUpId = f.followUpId
		SET isActive = 1;

		-- Issues
		UPDATE followUp f
		INNER JOIN (
			SELECT * FROM (
				SELECT issueId, max(followUpId) AS followUpId
				FROM followUp
				WHERE issueId IS NOT NULL
				GROUP BY issueId
			) a
		) b
			ON b.followUpId = f.followUpId
		SET isActive = 1;

	END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetTicketById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetTicketById$$
CREATE PROCEDURE blackstarDb.GetTicketById(pTicketId INT)
BEGIN
	
	SELECT t.*,
		p.officeId,
		p.customer,
		p.project,
		p.cst,
		e.equipmentType,
		p.brand,
		p.model,
		p.serialNumber,
		p.capacity,
		p.equipmentAddress,
		p.equipmentLocation,
		p.contactName,
		p.startDate,
		p.endDate,
		p.responseTimeHR,
		p.solutionTimeHR,
		p.includesParts,
		p.exceptionParts,
		s.serviceCenter,
		s.serviceCenterEmail,
		o.officeEmail
	FROM ticket t 
		INNER JOIN policy p ON p.policyId = t.policyId
		INNER JOIN serviceCenter s ON s.serviceCenterId = p.serviceCenterId
		INNER JOIN equipmentType e ON e.equipmentTypeId = p.equipmentTypeId
		INNER JOIN office o ON o.officeId = p.officeId
	WHERE ticketId = pTicketId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.InsertTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.InsertTicket$$
CREATE PROCEDURE blackstarDb.InsertTicket(pPolicyId INT, pUser VARCHAR(200), pObservations TEXT, pCreated DATETIME, pCreatedBy VARCHAR(200), pCreatedByUsr VARCHAR(200), pContact VARCHAR(200), pContactEmail VARCHAR(200), pContactPhone VARCHAR(200))
BEGIN
	
	SET @year = (select year(curdate()) - 2000);
	SET @num = (select count(*) from ticket where year(created) = 2000 + @year);
	-- desface de tickets en 2015
	IF @year = 15 THEN
		SET @num = @num + 6;
	END IF;

	INSERT INTO ticket(policyId, ticketNumber, user, observations, ticketStatusId, created, createdBy, createdByUsr, contact, contactEmail, contactPhone)
	SELECT pPolicyId, concat_ws('-', @year, @num), pUser, pObservations, 'A', pCreated, pCreatedBy, pCreatedByUsr, pContact, pContactEmail, pContactPhone;

	SELECT LAST_INSERT_ID();

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetPolicyById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPolicyById$$
CREATE PROCEDURE blackstarDb.GetPolicyById(pPolicyId INT)
BEGIN

	SELECT *, if(CURDATE() <= p.endDate, 'Activo', 'Vencido') AS contractState
	FROM policy p
		INNER JOIN serviceCenter s ON s.serviceCenterId = p.serviceCenterId
		INNER JOIN equipmentType e ON e.equipmentTypeId = p.equipmentTypeId
	WHERE policyId = pPolicyId; 

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEquipmentListAll
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentListAll$$
CREATE PROCEDURE blackstarDb.GetEquipmentListAll()
BEGIN

	SELECT 
		concat_ws(' - ', brand, model, serialNumber) AS label,
		p.policyId AS value
	FROM policy p
	WHERE p.startDate < CURDATE() AND CURDATE() < DATE_ADD(p.endDate, INTERVAL 3 MONTH)
	ORDER BY brand, model, serialNumber; 

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEquipmentListByCustomer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentListByCustomer$$
CREATE PROCEDURE blackstarDb.GetEquipmentListByCustomer(customerEmail VARCHAR(200))
BEGIN

	SELECT 
		concat_ws(' - ', brand, model, serialNumber) AS label,
		p.policyId AS value
	FROM policy p
		INNER JOIN policyEquipmentUser e ON e.policyId = p.policyId
	WHERE p.startDate < CURDATE() AND CURDATE() < DATE_ADD(p.endDate, INTERVAL 3 MONTH)
		AND equipmentUserId = customerEmail
	ORDER BY brand, model, serialNumber; 
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEngHourCost
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEngHourCost$$
CREATE PROCEDURE blackstarDb.GetEngHourCost()
BEGIN

	SELECT engHourCost FROM blackstarDb.globalSettings;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.SetEngHourCost
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.SetEngHourCost$$
CREATE PROCEDURE blackstarDb.SetEngHourCost (pEhCost FLOAT(10,2))
BEGIN

	UPDATE blackstarDb.globalSettings SET
		engHourCost = pEhCost;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.FlagSurveySuggestion
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.FlagSurveySuggestion$$
CREATE PROCEDURE blackstarDb.FlagSurveySuggestion (pSurveyId INT, pFlag INT)
BEGIN

	UPDATE blackstarDb.surveyService SET
		suggestionFlag = pFlag
	WHERE surveyServiceId = pSurveyId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.SaveGuid
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.SaveGuid$$
CREATE PROCEDURE blackstarDb.SaveGuid (pGuid VARCHAR(100), pExpires DATETIME)
BEGIN

	INSERT INTO blackstarDb.guid(guid, expires)
	SELECT pGuid, pExpires;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetSupportBloomTicketComments
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetGuid$$
CREATE PROCEDURE blackstarDb.GetGuid (pGuid VARCHAR(100))
BEGIN

	SELECT guid, expires FROM blackstarDb.guid
	WHERE guid = pGuid;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetSupportBloomTicketComments
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetSupportBloomTicketComments$$
CREATE PROCEDURE blackstarDb.GetSupportBloomTicketComments (pTicketNumber VARCHAR(100))
BEGIN

	SELECT
		created,
		createdByUsr,
		followUp,
		followUpId
	FROM
		followUp
	WHERE
		bloomTicketId = (SELECT _id FROM bloomTicket WHERE ticketNumber = pTicketNumber);

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.DeleteBloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.DeleteBloomTicket$$
CREATE PROCEDURE blackstarDb.DeleteBloomTicket (pTicketNumber VARCHAR(100))
BEGIN

	SET @ticketId = (SELECT _id FROM blackstarDb.bloomTicket WHERE ticketNumber = pTicketNumber);

	DELETE FROM blackstarDb.followUp WHERE bloomTicketId = @ticketId;
	DELETE FROM blackstarDb.bloomSurvey WHERE bloomTicketId = @ticketId;
	DELETE FROM blackstarDb.bloomTicketTeam WHERE ticketId = @ticketId;
	DELETE FROM blackstarDb.bloomTicket WHERE _id = @ticketId;
	SELECT 'OK';

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetSupportBloomTicketDetails
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetSupportBloomTicketDetails$$
CREATE PROCEDURE blackstarDb.GetSupportBloomTicketDetails (pTicketNumber VARCHAR(100))
BEGIN

	SELECT
		t.ticketNumber AS ticketNumber,
		y.name AS ticketType,
		t.createdByUsr,
		t.created,
		s.name AS status
	FROM bloomTicket t 
		INNER JOIN bloomServiceType y ON t.serviceTypeId = y._id
		INNER JOIN bloomStatusType s ON t.statusId = s._id
	WHERE ticketNumber = pTicketNumber;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetSupportTicketComments
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetSupportTicketComments$$
CREATE PROCEDURE blackstarDb.GetSupportTicketComments (pTicketNumber VARCHAR(100))
BEGIN

	SELECT
		created,
		createdByUsr,
		followUp,
		followUpId
	FROM
		followUp
	WHERE
		ticketId = (SELECT ticketId FROM ticket WHERE ticketNumber = pTicketNumber);

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.DeleteTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.DeleteTicket$$
CREATE PROCEDURE blackstarDb.DeleteTicket (pTicketNumber VARCHAR(100))
BEGIN

	SET @ticketId = (SELECT ticketId FROM blackstarDb.ticket WHERE ticketNumber = pTicketNumber);

	-- ServiceOrder
	IF(SELECT count(*) FROM blackstarDb.serviceOrder WHERE ticketId = @ticketId) > 0 THEN
		SELECT 'No se puede eliminar el ticket, ya ha sido usado en una OS' AS OK;
	ELSE
		DELETE FROM blackstarDbTransfer.ticket WHERE ticketNumber = pTicketNumber;
		DELETE FROM blackstarDb.followUp WHERE ticketId = @ticketId;
		DELETE FROM blackstarDb.ticket WHERE ticketId = @ticketId;
		SELECT 'OK';
	END IF;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetSupportTicketDetail
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetSupportTicketDetail$$
CREATE PROCEDURE blackstarDb.GetSupportTicketDetail (pTicketNumber VARCHAR(100))
BEGIN

	SELECT
		t.ticketNumber,
		t.contact AS createdByUsr,
		t.created,
		s.ticketStatus AS status
	FROM ticket t 
		INNER JOIN ticketStatus s ON t.ticketStatusId = s.ticketStatusId
	WHERE ticketNumber = pTicketNumber;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.DeleteFollowUp
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.DeleteFollowUp$$
CREATE PROCEDURE blackstarDb.DeleteFollowUp (pFollowUpId INT)
BEGIN

	DELETE FROM followUp WHERE followUpId = pFollowUpId;

	SELECT 'OK';
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.DeleteServiceOrderPDF
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.DeleteServiceOrderPDF$$
CREATE PROCEDURE blackstarDb.DeleteServiceOrderPDF (pServiceOrderNumber VARCHAR(200))
BEGIN

	UPDATE serviceOrder SET
		hasPDF = 0 
	WHERE serviceOrderNumber = pServiceOrderNumber;

	SELECT 'OK';
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.DeleteServiceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.DeleteServiceOrder$$
CREATE PROCEDURE blackstarDb.DeleteServiceOrder (pServiceOrderNumber VARCHAR(200))
BEGIN

	SET @id = (SELECT serviceOrderId FROM blackstarDb.serviceOrder WHERE serviceOrderNumber = pServiceOrderNumber);

	IF(@id IS NOT NULL) THEN
		-- ticket
		UPDATE blackstarDb.ticket SET 
			serviceOrderNumber = NULL, 
			modified = now(), 
			modifiedBy = 'DeleteServiceOrder'
		WHERE serviceOrderNumber = pServiceOrderNumber;

		-- serviceOrderEmployee
		DELETE FROM blackstarDb.serviceOrderEmployee WHERE serviceOrderId = @id;

		-- aa
		IF left(pServiceOrderNumber, 2) = 'AA' THEN
			DELETE FROM blackstarDb.aaService WHERE serviceOrderId = @id;
		END IF;

		-- bb
		IF left(pServiceOrderNumber, 2) = 'BB' THEN
			SET @bbId = (SELECT bbServiceId FROM blackstarDb.bbService WHERE serviceOrderId = @id);

			DELETE FROM blackstarDb.bbCellService WHERE bbServiceId = @bbId;
			DELETE FROM blackstarDb.bbService WHERE bbServiceId = @bbId;
		END IF;

		-- ep
		IF left(pServiceOrderNumber, 2) = 'PE' THEN
			SET @peId = (SELECT epServiceId FROM blackstarDb.epService WHERE serviceOrderId = @id);

			DELETE FROM blackstarDb.epServiceDynamicTest WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epServiceLectures WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epServiceParams WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epServiceSurvey WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epServiceTestProtection WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epServiceTransferSwitch WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epServiceWorkBasic WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epService WHERE epServiceId = @peId;
		END IF;

		-- ups
		IF left(pServiceOrderNumber, 3) = 'UPS' THEN
			SET @upsId = (SELECT upsServiceId FROM blackstarDb.upsService WHERE serviceOrderId = @id);

			DELETE FROM blackstarDb.upsServiceBatteryBank WHERE upsServiceId = @upsId;
			DELETE FROM blackstarDb.upsServiceGeneralTest WHERE upsServiceId = @upsId;
			DELETE FROM blackstarDb.upsServiceParams WHERE upsServiceId = @upsId;
			DELETE FROM blackstarDb.upsService WHERE upsServiceId = @upsId;
		END IF;

		-- plain
		DELETE FROM blackstarDb.plainService WHERE serviceOrderId = @id;
		
		-- followUp
		DELETE FROM blackstarDb.followUp WHERE serviceOrderId = @id;

		-- serviceOrder
		DELETE FROM blackstarDb.serviceOrder WHERE serviceOrderId = @id;
	END IF;

	SELECT 'OK';
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetSupportServiceOrderDetail
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetSupportServiceOrderDetail$$
CREATE PROCEDURE blackstarDb.GetSupportServiceOrderDetail (pServiceOrderNumber VARCHAR(200))
BEGIN

	SELECT
		serviceOrderNumber AS serviceOrderNumber,
		serviceDate AS serviceDate,
		createdByUsr AS createdByUsr,
		created AS created,
		if(ticketId IS NOT NULL, 'SI', 'NO') AS ticket,
		if(policyId IS NOT NULL, 'SI', 'NO') AS policy,
		if(openCustomerId IS NOT NULL, 'SI', 'NO') AS openCustomer,
		if(hasPdf = 1, 'SI', 'NO') AS hasPdf
	FROM
		serviceOrder
	WHERE
		serviceOrderNumber = pServiceOrderNumber;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetSupportServiceOrderComments
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetSupportServiceOrderComments$$
CREATE PROCEDURE blackstarDb.GetSupportServiceOrderComments (pServiceOrderNumber VARCHAR(200))
BEGIN

	SELECT
		created,
		createdByUsr,
		followUp,
		followUpId
	FROM
		followUp
	WHERE
		serviceOrderId = (SELECT serviceOrderId FROM serviceOrder WHERE serviceOrderNumber = pServiceOrderNumber);
	
END$$

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
	SET @engHourCost := (SELECT engHourCost FROM globalSettings);

	SELECT * FROM (
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
				AND if(pProject = 'ALL', 1 = 1, p.project = pProject)
			GROUP BY project
	) data 
		INNER JOIN (
			SELECT 
				coalesce(p.project, c.project) AS project2,
				sum(TIMESTAMPDIFF(HOUR, serviceDate, serviceEndDate)) AS time,
				sum(TIMESTAMPDIFF(HOUR, serviceDate, serviceEndDate)) * @engHourCost AS cost
			FROM serviceOrder o
				INNER JOIN serviceOrderEmployee e ON o.serviceOrderId = e.serviceOrderId
				LEFT OUTER JOIN policy p ON p.policyId = o.policyId
				LEFT OUTER JOIN openCustomer c ON c.openCustomerId = o.openCustomerId
			WHERE serviceDate IS NOT NULL 
				AND serviceEndDate IS NOT NULL
			AND ifnull(employeeId, '') != ''
			GROUP BY project2
		) times ON data.project = times.project2
	ORDER BY officeName, data.project;

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
			followUp,
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

	-- LIMPIAR EL REGISTRO ACTIVE
	UPDATE followUp SET isActive = NULL WHERE issueId = pIssueId AND isActive = 1;

	-- INSERTAR EL REGISTRO DE SEGUIMIENTO
	INSERT INTO blackstarDb.followUp(
		followUpReferenceTypeId,
		issueId,
		asignee,
		followUp,
		created,
		createdBy,
		createdByUsr,
		isActive
	)
	SELECT 
		'I',
		pIssueId,
		ifnull(pAsignee, pCreatedBy),
		pMessage,
		pCreated,
		'AddFollowUpToIssue',
		pCreatedBy,
		1;

	IF ifnull(pAsignee, '') != '' THEN
		UPDATE issue SET
			issueStatusId = 'A',
			asignee = pAsignee,
			assignedBy = pCreatedBy,
			modified = NOW(),
			modifiedBy = 'AddFollowUpToIssue',
			modifiedByUsr = pCreatedBy
		WHERE issueId = pIssueId;
	END IF;
	
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
		followUp AS followUp
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

	SET @myId = (SELECT blackstarUserId FROM blackstarUser WHERE email = pUser);

	-- Health check
	DROP TABLE IF EXISTS usrGroup;
	CREATE TEMPORARY TABLE usrGroup(blackstarUserId INT, email VARCHAR(100), name VARCHAR(200));
	INSERT INTO usrGroup(blackstarUserId, email, name)
	SELECT blackstarUserId, email, name FROM blackstarUser WHERE bossId = @myId;

	SELECT 
		f.followUpReferenceTypeId AS referenceTypeId, 
		r.followUpreferencetype AS referenceType,
		coalesce(t.ticketId, s.serviceOrderId, i.issueId, bt._id) AS referenceId, 
		coalesce(t.ticketNumber, s.serviceOrderNumber, i.issueNumber, bt.ticketNumber) AS referenceNumber,
		coalesce(p.project, c.project, i.project, bt.project) AS project,
		coalesce(p.customer, c.customerName, i.customer, '') AS customer,
		f.created AS created,
		CASE 
			WHEN f.followUpReferenceTypeId = 'T' THEN 'Seguimiento a Ticket'
			WHEN f.followUpReferenceTypeId = 'O' THEN 'Seguimiento a Orden de Servicio'
			WHEN f.followUpReferenceTypeId = 'I' THEN 'Asignacion SAC'
			WHEN f.followUpReferenceTypeId = 'R' THEN 'Requisicion'
		END AS title,
		followUp AS detail,
		coalesce(ts.ticketStatus, ist.issueStatus, bts.name, '') as status,
		ifnull(u1.name, '') AS createdByUsr,
		u2.name AS asignee
	FROM followUp f
		INNER JOIN followUpReferenceType r ON f.followUpReferenceTypeId = r.followUpReferenceTypeId
		LEFT OUTER JOIN ticket t ON f.ticketId = t.ticketId
		LEFT OUTER JOIN serviceOrder s ON s.serviceOrderId = f.serviceOrderId
		LEFT OUTER JOIN issue i ON i.issueId = f.issueId
		LEFT OUTER JOIN policy p ON coalesce(t.policyId, s.policyId) = p.policyId
		LEFT OUTER JOIN openCustomer c ON s.openCustomerId = c.openCustomerId
		LEFT OUTER JOIN ticketStatus ts ON ts.ticketStatusId = t.ticketStatusId
		LEFT OUTER JOIN serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER JOIN issueStatus ist ON ist.issueStatusId = i.issueStatusId
		LEFT OUTER JOIN bloomTicket bt ON f.bloomTicketId = bt._id
		LEFT OUTER JOIN bloomStatusType bts ON bts._id = bt.statusId
		LEFT OUTER JOIN blackstarUser u1 ON f.createdByUsr = u1.email
		LEFT OUTER JOIN blackstarUser u2 ON f.asignee = u2.email
	WHERE isActive = 1
		AND (u2.blackstarUserId IN (SELECT u3.blackstarUserId FROM usrGroup u3) OR u1.blackstarUserId = @myId)
		AND coalesce(t.ticketStatusId, s.serviceStatusId, i.issueStatusId, '') NOT IN ('C', 'F')
		AND ifnull(bt.statusId, 0) NOT IN(6, 4)
	ORDER BY f.created;
	
	DROP TABLE usrGroup;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUserPendingIssues
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserPendingIssues$$
CREATE PROCEDURE blackstarDb.GetUserPendingIssues(pUser VARCHAR(100))
BEGIN

	SELECT 
		f.followUpReferenceTypeId AS referenceTypeId, 
		r.followUpreferencetype AS referenceType,
		coalesce(t.ticketId, s.serviceOrderId, i.issueId, bt._id) AS referenceId, 
		coalesce(t.ticketNumber, s.serviceOrderNumber, i.issueNumber, bt.ticketNumber) AS referenceNumber,
		coalesce(p.project, c.project, i.project, bt.project) AS project,
		coalesce(p.customer, c.customerName, i.customer, '') AS customer,
		f.created AS created,
		CASE 
			WHEN f.followUpReferenceTypeId = 'T' THEN 'Seguimiento a Ticket'
			WHEN f.followUpReferenceTypeId = 'O' THEN 'Seguimiento a Orden de Servicio'
			WHEN f.followUpReferenceTypeId = 'I' THEN 'Asignacion SAC'
			WHEN f.followUpReferenceTypeId = 'R' THEN 'Requisicion'
		END AS title,
		followUp AS detail,
		coalesce(ts.ticketStatus, ist.issueStatus, bts.name, '') as status,
		ifnull(u1.name, '') AS createdByUsr,
		u2.name AS asignee
	FROM followUp f
		INNER JOIN followUpReferenceType r ON f.followUpReferenceTypeId = r.followUpReferenceTypeId
		LEFT OUTER JOIN ticket t ON f.ticketId = t.ticketId
		LEFT OUTER JOIN serviceOrder s ON s.serviceOrderId = f.serviceOrderId
		LEFT OUTER JOIN issue i ON i.issueId = f.issueId
		LEFT OUTER JOIN policy p ON coalesce(t.policyId, s.policyId) = p.policyId
		LEFT OUTER JOIN openCustomer c ON s.openCustomerId = c.openCustomerId
		LEFT OUTER JOIN ticketStatus ts ON ts.ticketStatusId = t.ticketStatusId
		LEFT OUTER JOIN serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER JOIN issueStatus ist ON ist.issueStatusId = i.issueStatusId
		LEFT OUTER JOIN bloomTicket bt ON f.bloomTicketId = bt._id
		LEFT OUTER JOIN bloomStatusType bts ON bts._id = bt.statusId
		LEFT OUTER JOIN blackstarUser u1 ON f.createdByUsr = u1.email
		LEFT OUTER JOIN blackstarUser u2 ON f.asignee = u2.email
	WHERE isActive = 1
		AND f.asignee = pUser
		AND coalesce(t.ticketStatusId, s.serviceStatusId, i.issueStatusId, '') NOT IN ('C', 'F')
		AND ifnull(bt.statusId, 0) NOT IN(6, 4)
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
	-- blackstarDb.UpdateTicketData 
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpdateTicketData$$
CREATE PROCEDURE blackstarDb.UpdateTicketData(pTicketId INT, pArrival DATETIME, pPhoneResolved INT, pModifiedBy VARCHAR(100), pUser VARCHAR(100))
BEGIN

	UPDATE ticket t 
		INNER JOIN policy p ON t.policyId = p.policyId SET
		t.arrival = pArrival,
		t.phoneResolved = pPhoneResolved,
		t.realResponseTime = TIMESTAMPDIFF(HOUR, t.created, pArrival),
		t.responseTimeDeviationHr = CASE WHEN(TIMESTAMPDIFF(HOUR, t.created, pArrival) < responseTimeHR) THEN 0 ELSE (TIMESTAMPDIFF(HOUR, t.created, pArrival) - responseTimeHR) END,
		t.modified = NOW(),
		t.modifiedBy = pModifiedBy,
		t.modifiedByUsr = pUser
	WHERE ticketId = pTicketId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.UpdateTicketArrival -- Obsoleto
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
CREATE PROCEDURE blackstarDb.GetLimitedServiceOrderList(pStartDate DATETIME, pEndDate DATETIME, pUser VARCHAR(100))
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
    	AND serviceDate >= pStartDate AND serviceDate <= pEndDate
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
			ifnull(t2.ticketNumber,'') as lastTicketNumber,
			t2.closed as lastTicketClosed,
			t2.employee as employee,
			ifnull(s.serviceOrderNumber,'') as lastServiceNumber
		FROM ticket t1
		INNER JOIN policy p1 on t1.policyId = p1.policyId
		INNER JOIN equipmentType et ON p1.equipmentTypeId = et.equipmentTypeId
		LEFT OUTER JOIN ticket t2 ON t2.ticketId = (
				SELECT t3.ticketId FROM ticket t3 
				WHERE t3.policyId = p1.policyId 
					AND t3.ticketId < t1.ticketId ORDER BY created DESC LIMIT 1)
			AND DATEDIFF(t1.created, t2.created) <= 15
		LEFT OUTER JOIN serviceOrder s ON s.serviceOrderId = (
			SELECT serviceOrderId FROM serviceOrder s1
			WHERE s1.policyId = t1.policyId 
				AND s1.serviceDate < t1.created 
				AND s1.serviceTypeId != 'C' 
				AND DATEDIFF(t1.created, s1.serviceDate) <= 15
			ORDER BY serviceDate DESC LIMIT 1)
		WHERE t1.created >= startDate and t1.created <= endDate
			AND if(project = 'All', 1=1, p1.project = project)
			AND coalesce(t2.ticketNumber, s.serviceOrderNumber) IS NOT NULL
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
			ifnull(t2.ticketNumber,'') as lastTicketNumber,
			t2.closed as lastTicketClosed,
			t2.employee as employee,
			ifnull(s.serviceOrderNumber,'') as lastServiceNumber
		FROM ticket t1
		INNER JOIN policy p1 on t1.policyId = p1.policyId
		INNER JOIN equipmentType et ON p1.equipmentTypeId = et.equipmentTypeId
		LEFT OUTER JOIN ticket t2 ON t2.ticketId = (
				SELECT t3.ticketId FROM ticket t3 
				WHERE t3.policyId = p1.policyId 
					AND t3.ticketId < t1.ticketId ORDER BY created DESC LIMIT 1)
			AND DATEDIFF(t1.created, t2.created) <= 15
		LEFT OUTER JOIN serviceOrder s ON s.serviceOrderId = (
			SELECT serviceOrderId FROM serviceOrder s1
			WHERE s1.policyId = t1.policyId 
				AND s1.serviceDate < t1.created 
				AND s1.serviceTypeId != 'C' 
				AND DATEDIFF(t1.created, s1.serviceDate) <= 15
			ORDER BY serviceDate DESC LIMIT 1)
		WHERE t1.created >= startDate and t1.created <= endDate
			AND if(project = 'All', 1=1, p1.project = project)
			AND pe.equipmentUserId = user
			AND coalesce(t2.ticketNumber, s.serviceOrderNumber) IS NOT NULL
		ORDER BY t1.created DESC;
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
CREATE PROCEDURE blackstarDb.GetAllServiceOrders(pStartDate DATETIME, pEndDate DATETIME)
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
	     WHERE serviceDate >= pStartDate AND serviceDate <= pEndDate
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
	     WHERE serviceDate >= pStartDate AND serviceDate <= pEndDate
	) A
	ORDER BY A.serviceDate DESC;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFutureServicesSchedule
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFutureServicesSchedule$$
CREATE PROCEDURE blackstarDb.GetFutureServicesSchedule(pServiceDate DATETIME, pOfficeId CHAR(1))
BEGIN

	SELECT DISTINCT
		s.scheduledServiceId AS scheduledServiceId,
		Date(serviceDate) AS scheduledDate,
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
		AND if(pOfficeId = "A", 1 = 1, ifnull(s.officeId, pOfficeId) = pOfficeId)
	ORDER BY serviceDate;
	
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
		INNER JOIN blackstarDb.policy p on p.policyId = t.policyId
	SET 
		t.ticketStatusId = IF(TIMESTAMPDIFF(HOUR, t.created, pClosed) > solutionTimeHR, 'F', 'C'),
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

	-- LIMPIAR REGISTRO ACTIVE
	UPDATE followUp SET isActive = NULL WHERE ServiceOrderId = pOsId AND isActive = 1;

	-- INSERTAR EL REGISTRO DE SEGUIMIENTO
	INSERT INTO blackstarDb.followUp(
		followUpReferenceTypeId,
		serviceOrderId,
		asignee,
		followUp,
		created,
		createdBy,
		createdByUsr,
		isActive
	)
	SELECT 
		'O',
		pOsId,
		pAsignee,
		pMessage,
		pCreated,
		'AddFollowUpToOS',
		pCreatedBy,
		1;

	-- ACTUALIZAR LA OS
	UPDATE serviceOrder SET
		serviceStatusId = 'E',
		asignee = pAsignee,
		assignedBy = pCreatedBy,
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
	-- LIMPIAR REGISTRO ACTIVE
	UPDATE followUp SET isActive = NULL WHERE ticketId = pTicketId AND isActive = 1;

	-- INSERTAR EL REGISTRO DE SEGUIMIENTO
	INSERT INTO blackstarDb.followUp(
		followUpReferenceTypeId,
		ticketId,
		asignee,
		followUp,
		created,
		createdBy,
		createdByUsr,
		isActive
	)
	SELECT 
		'T',
		pTicketId,
		pAsignee,
		pMessage,
		pCreated,
		'AddFollowUpToTicket',
		pCreatedBy,
		1;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertScheduledService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertScheduledService$$
CREATE PROCEDURE blackstarDb.UpsertScheduledService(pScheduledServiceId INTEGER, pDescription VARCHAR(1000), pOpenCustomerId INT, pProject VARCHAR(100), pServiceContact VARCHAR(100), pServiceContactEmail VARCHAR(100), pCreatedBy VARCHAR(100), pUser VARCHAR(100), pOfficeId CHAR(1))
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
			createdByUsr,
			officeId
		)
		SELECT 
			'P', pDescription, pOpenCustomerId, pProject, pServiceContact, pServiceContactEmail, NOW(), pCreatedBy, pUser, pOfficeId;
			
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
				modifiedByUsr = pUser,
				officeId = pOfficeId
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
		followUp AS followUp
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
		followUp AS followUp
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
CREATE PROCEDURE blackstarDb.GetServicesSchedule(pServiceDate DATETIME, pOfficeId CHAR(1))
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
		AND if(pOfficeId = "A", 1 = 1, ifnull(s.officeId, pOfficeId) = pOfficeId)
	ORDER BY equipmentType;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetDomainEmployees
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetDomainEmployees$$
CREATE PROCEDURE blackstarDb.GetDomainEmployees()
BEGIN

	SELECT DISTINCT u.blackstarUserId AS id, u.email AS email, u.name AS name
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

        SELECT u.email AS userEmail, u.name AS userName, g.name AS groupName, u.blackstarUserId AS blackstarUserId
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
		assignedBy = usr,
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
		chargerReview, fanStatus, observations,
		
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
	evaDescription VARCHAR(2000),
	evaValTemp VARCHAR(200),
	evaValHum VARCHAR(200),
	evaSetpointTemp VARCHAR(200),
	evaSetpointHum VARCHAR(200),
	evaFlagCalibration BIT(2),
	evaReviewFilter BIT(2),
	evaReviewStrip BIT(2),
	evaCleanElectricSystem BIT(2),
	evaCleanControlCard BIT(2),
	evaCleanTray BIT(2),
	evaLectrurePreasureHigh VARCHAR(200),
	evaLectrurePreasureLow VARCHAR(200),
	evaLectureTemp VARCHAR(200),
	evaLectureOilColor VARCHAR(200),
	evaLectureOilLevel VARCHAR(200),
	evaLectureCoolerColor VARCHAR(200),
	evaLectureCoolerLevel VARCHAR(200),
	evaCheckOperatation VARCHAR(200),
	evaCheckNoise VARCHAR(200),
	evaCheckIsolated VARCHAR(200),
	evaLectureVoltageGroud VARCHAR(200),
	evaLectureVoltagePhases VARCHAR(200),
	evaLectureVoltageControl VARCHAR(200),
	evaLectureCurrentMotor1 VARCHAR(200),
	evaLectureCurrentMotor2 VARCHAR(200),
	evaLectureCurrentMotor3 VARCHAR(200),
	evaLectureCurrentCompressor1 VARCHAR(200),
	evaLectureCurrentCompressor2 VARCHAR(200),
	evaLectureCurrentCompressor3 VARCHAR(200),
	evaLectureCurrentHumidifier1 VARCHAR(200),
	evaLectureCurrentHumidifier2 VARCHAR(200),
	evaLectureCurrentHumidifier3 VARCHAR(200),
	evaLectureCurrentHeater1 VARCHAR(200),
	evaLectureCurrentHeater2 VARCHAR(200),
	evaLectureCurrentHeater3 VARCHAR(200),
	evaCheckFluidSensor BIT(2),
	evaRequirMaintenance BIT(2),
	condReview VARCHAR(200),
	condCleanElectricSystem BIT(2),
	condClean BIT(2),
	condLectureVoltageGroud VARCHAR(200),
	condLectureVoltagePhases VARCHAR(200),
	condLectureVoltageControl VARCHAR(200),
	condLectureMotorCurrent VARCHAR(200),
	condReviewThermostat VARCHAR(200),
	condModel VARCHAR(200),
	condSerialNumber VARCHAR(200),
	condBrand VARCHAR(200),
	observations varchar(2000),
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
CREATE PROCEDURE blackstarDb.AddBBcellservice (bbServiceId int(11) , cellNumber int(11) , floatVoltage VARCHAR(200) , chargeVoltage VARCHAR(200))
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
   plugClean  BIT(2)  ,
   plugCleanStatus  VARCHAR(200), 
   plugCleanComments  VARCHAR(200), 
   coverClean  BIT(2)  ,
   coverCleanStatus  VARCHAR(200) ,
   coverCleanComments  VARCHAR(200), 
   capClean  BIT(2)  ,
   capCleanStatus  VARCHAR(200) ,
   capCleanComments  VARCHAR(200), 
   groundClean  BIT(2)  ,
   groundCleanStatus  VARCHAR(200), 
   groundCleanComments  VARCHAR(200), 
   rackClean  BIT(2)  ,
   rackCleanStatus  VARCHAR(200), 
   rackCleanComments  VARCHAR(200), 
   serialNoDateManufact  VARCHAR(200) ,
   batteryTemperature  VARCHAR(200) ,
   voltageBus  VARCHAR(200) ,
   temperature  VARCHAR(200) ,
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
   brandPE VARCHAR(200) ,
   modelPE VARCHAR(200) ,
   serialPE VARCHAR(200) ,
   transferType  VARCHAR(200),
   modelTransfer  VARCHAR(200),
   modelControl  VARCHAR(200),
   modelRegVoltage  VARCHAR(200),
   modelRegVelocity  VARCHAR(200),
   modelCharger  VARCHAR(200),
   oilChange  date,
   brandMotor  VARCHAR(200),
   modelMotor  VARCHAR(200),
   serialMotor  VARCHAR(200),
   cplMotor  VARCHAR(200),
   brandGenerator  VARCHAR(200),
   modelGenerator  VARCHAR(200),
   serialGenerator  VARCHAR(200),
   powerWattGenerator  VARCHAR(200),
   tensionGenerator  VARCHAR(200),
   tuningDate  date,
   tankCapacity  VARCHAR(200),
   pumpFuelModel  VARCHAR(200),
   filterFuelFlag  BIT(2),
   filterOilFlag  BIT(2),
   filterWaterFlag  BIT(2),
   filterAirFlag  BIT(2),
   brandGear  VARCHAR(200),
   brandBattery  VARCHAR(200),
   clockLecture  VARCHAR(200),
   serviceCorrective  date,
   observations  VARCHAR(2000),
   created  datetime,
   createdBy  VARCHAR(50),
   createdByUsr  VARCHAR(50)
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
   levelOilFlag  BIT(2)  ,
   levelWaterFlag  BIT(2)  ,
   levelBattery  VARCHAR(200),
   tubeLeak  BIT(2)  ,
   batteryCap  VARCHAR(200),
   batterySulfate  VARCHAR(200),
   levelOil VARCHAR(200),
   heatEngine  VARCHAR(200),
   hoseOil  VARCHAR(200),
   hoseWater  VARCHAR(200),
   tubeValve  VARCHAR(200),
   stripBlades  VARCHAR(200)
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
   washEngine  BIT(2)  ,
   washRadiator  BIT(2)  ,
   cleanWorkArea  BIT(2)  ,
   conectionCheck  BIT(2)  ,
   cleanTransfer  BIT(2)  ,
   cleanCardControl  BIT(2)  ,
   checkConectionControl  BIT(2)  ,
   checkWinding  BIT(2)  ,
   batteryTests  BIT(2)  ,
   checkCharger  BIT(2)  ,
   checkPaint  BIT(2)  ,
   cleanGenerator  BIT(2) 
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
   vacuumFrequency  VARCHAR(200),
   chargeFrequency  VARCHAR(200),
   bootTryouts  VARCHAR(200),
   vacuumVoltage  VARCHAR(200),
   chargeVoltage  VARCHAR(200),
   qualitySmoke  VARCHAR(200),
   startTime  VARCHAR(200),
   transferTime  VARCHAR(200),
   stopTime  VARCHAR(200) 
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
   tempSensor VARCHAR(200),
   oilSensor VARCHAR(200),
   voltageSensor VARCHAR(200),
   overSpeedSensor VARCHAR(200),
   oilPreasureSensor VARCHAR(200),
    waterLevelSensor VARCHAR(200) 
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
   mechanicalStatus  VARCHAR(200),
   boardClean  BIT(2),
   lampTest  BIT(2),
   screwAdjust  BIT(2),
   conectionAdjust  BIT(2),
   systemMotors  VARCHAR(200),
   electricInterlock  VARCHAR(200),
   mechanicalInterlock  VARCHAR(200),
   capacityAmp   VARCHAR(200)
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
   voltageABAN  VARCHAR(200),
   voltageACCN  VARCHAR(200),
   voltageBCBN  VARCHAR(200),
   voltageNT  VARCHAR(200),
   currentA  VARCHAR(200),
   currentB  VARCHAR(200),
   currentC  VARCHAR(200),
   frequency  VARCHAR(200),
   oilPreassure  VARCHAR(200),
   temp  VARCHAR(200) 
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
   adjsutmentTherm  VARCHAR(200),
   current  VARCHAR(200),
   batteryCurrent  VARCHAR(200),
   clockStatus  VARCHAR(200),
   trasnferTypeProtection  VARCHAR(200),
   generatorTypeProtection  VARCHAR(200) 
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
  estatusEquipment varchar(200) ,
  cleaned BIT(2) ,
  hooverClean BIT(2) ,
  verifyConnections BIT(2) ,
  capacitorStatus varchar(200) ,
  verifyFuzz BIT(2) ,
  chargerReview BIT(2) ,
  fanStatus varchar(200) ,
  observations nvarchar(2000),
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
  checkConnectors BIT(2) ,
  cverifyOutflow BIT(2) ,
  numberBatteries int(11) ,
  manufacturedDateSerial varchar(200) ,
  damageBatteries varchar(50) ,
  other varchar(250) ,
  temp varchar(50) ,
  chargeTest BIT(2) ,
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
  responsible varchar(400) ,
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
  hasPdf int,
  signReceivedBy TEXT
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
	s.hasPdf = hasPdf,
	s.signReceivedBy = signReceivedBy
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
		suggestion,
		suggestionFlag
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
-- 11 	22/09/2014	SAG 	Se agrega tabla de transferencia bloom ticket
-- ---------------------------------------------------------------------------
-- 12 	28/01/2014	SAG 	Se aumenta capacidad de brand en policy
-- ---------------------------------------------------------------------------


USE blackstarDbTransfer;


DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDbTransfer.upgradeSchema$$
CREATE PROCEDURE blackstarDbTransfer.upgradeSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

	-- Aumentando capacidad de brand a 200
	ALTER TABLE policy MODIFY brand VARCHAR(200);

	-- Agregando bloomTicket
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'bloomTicket') = 0 THEN
		CREATE TABLE blackstarDbTransfer.bloomTicket(
			bloomTicketId INT AUTO_INCREMENT,
			created DATETIME,
			createdByUsr VARCHAR(100),
			ticketType INT,
			dueDate DATETIME,
			description VARCHAR(4000),
			project VARCHAR(100),
			office VARCHAR(100),
			ticketNumber VARCHAR(100),
			followUp VARCHAR(2000),
			responseTime DATETIME,
			resolved INT,
			status INT(1),
			processed INT,
			KEY(bloomTicketId)
		)ENGINE=INNODB;
	END IF;

	-- Aumentando capacidad de description
	ALTER TABLE bloomTicket MODIFY description VARCHAR(4000);

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
-- 10 	20/08/2014	SAG 	Se incorpora proyecto Bloom
-- -----------------------------------------------------------------------------
-- 11 	22/09/2014	SAG 	Se agrega UpsertbloomTicket
-- -----------------------------------------------------------------------------
-- 12	28/01/2015	SAG 	Se actialuza UpsertPolicy
-- -----------------------------------------------------------------------------
-- 13	05/03/2015	SAG 	Se actialuza UpsertPolicy
-- -----------------------------------------------------------------------------

use blackstarDbTransfer;


DELIMITER $$


-- -----------------------------------------------------------------------------
	-- blackstarDb.upsertbloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS upsertbloomTicket $$
CREATE PROCEDURE upsertbloomTicket(
	pCreated DATETIME,
	pCreatedByUsr VARCHAR(100),
	pTicketType INT,
	pDueDate DATETIME,
	pDescription VARCHAR(4000),
	pProject VARCHAR(100),
	pOffice VARCHAR(100),
	pTicketNumber VARCHAR(100),
	pfollowUp VARCHAR(2000),
	pResponseTime DATETIME,
	pResolved INT,
	pStatus CHAR(1),
	processed INT
)
BEGIN
	IF(SELECT count(*) FROM blackstarDbTransfer.bloomTicket WHERE ticketNumber = pTicketNumber)  = 0 THEN
		INSERT INTO blackstarDbTransfer.bloomTicket(
			created,  createdByUsr,  ticketType,  dueDate,  description,  project,  office,  ticketNumber,  followUp,  responseTime,  resolved,  status, processed )
		SELECT 
			pCreated, pCreatedByUsr, pTicketType, pDueDate, pDescription, pProject, pOffice, pTicketNumber, pfollowUp, pResponseTime, pResolved, pStatus, 0;
	ELSE
		UPDATE blackstarDbTransfer.bloomTicket SET
			created = pCreated,
			createdByUsr = pCreatedByUsr,
			ticketType = pTicketType,
			dueDate = pDueDate,
			description = pDescription,
			project = pProject,
			office = pOffice,
			ticketNumber = pTicketNumber,
			followUp = pfollowUp,
			responseTime = pResponseTime,
			resolved = pResolved,
			status = pStatus,
			processed = 0
		WHERE ticketNumber = pTicketNumber;
	END IF;
END$$

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
	pfollowUp text,
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
			pServiceNumber, pTicketNumber, pServiceUnit, pProject, pCustomer, pCity, pAddress, pServiceTypeId, pServiceDate, pSerialNumber, pResponsible, pReceivedBy, pServiceComments, pClosed, pfollowUp, pSpares, pConsultant, pContractorCompany, pServiceRate, pCustomerComments, pCreated, pCreatedBy, pCreatedByUsr, pEquipmentTypeId, pBrand, pModel, pCapacity, pEmployeeId;
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
	  pCustomer VARCHAR(200),
	  pFinalUser VARCHAR(200),
	  pProject VARCHAR(50),
	  pCst VARCHAR(50),
	  pEquipmentTypeId CHAR(1),
	  pBrand VARCHAR(200),
	  pModel VARCHAR(100),
	  pSerialNumber VARCHAR(100),
	  pCapacity VARCHAR(50),
	  pEquipmentAddress VARCHAR(250),
	  pEquipmentLocation VARCHAR(250),
	  pContact VARCHAR(200),
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
			capacity = pCapacity,
			equipmentTypeId = pEquipmentTypeId,
			brand = pBrand,
			customer = pCustomer,
			finalUser = pFinalUser,
			model = pModel,
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
		bp.contactEmail = p.contactEmail,
		bp.capacity = p.capacity,
		bp.equipmentTypeId = p.equipmentTypeId,
		bp.brand = p.brand,
		bp.model = p.model,
		bp.customer = p.customer,
		bp.finalUser = p.finalUser,
		bp.modified = now(),
		bp.modifiedBy = 'PolicyTransfer',
		bp.modifiedByUsr = 'portal-servicios';

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
		followUp,
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
		followUp,
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

	-- TRANSFERENCIA DE LOS TICKETS BLOOM
	INSERT INTO blackstarDb.bloomTicket(ticketNumber, applicantUserId, officeId, serviceTypeId, statusId, applicantAreaId, dueDate, project, description, created, createdby, createdByUsr)
	SELECT t1.ticketNumber, bu.blackstarUserId, SUBSTRING(t1.office, 1, 1), t1.ticketType, t1.status, st.applicantAreaId, t1.dueDate, t1.project, t1.description, t1.created, 'bloomTicketTransfer', t1.createdByUsr
	FROM blackstarDbTransfer.bloomTicket t1
		INNER JOIN blackstarDb.blackstarUser bu ON t1.createdByUsr = bu.email
		INNER JOIN blackstarDb.bloomServiceType st ON st._id = t1.ticketType
		LEFT OUTER JOIN blackstarDb.bloomTicket t2 ON t1.ticketNumber =t2.ticketNumber
	WHERE t2._id IS NULL
	AND t1.processed = 0;

	-- ACTUALIZACION DE ESTATUS DE LOS TICKETS
	UPDATE blackstarDb.bloomTicket t2
		INNER JOIN blackstarDbTransfer.bloomTicket t1 ON t1.ticketNumber = t2.ticketNumber
		INNER JOIN blackstarDb.blackstarUser bu ON t1.createdByUsr = bu.email
		INNER JOIN blackstarDb.bloomServiceType st ON st._id = t1.ticketType
	SET 
		t2.applicantUserId = bu.blackstarUserId,
		t2.officeId = SUBSTRING(t1.office, 1, 1),
		t2.serviceTypeId = t1.ticketType,
		t2.statusId = t1.status,
		t2.applicantAreaId = st.applicantAreaId,
		t2.dueDate = t1.dueDate,
		t2.project = t1.project,
		t2.description = t1.description,
		t2.responseDate = t1.responseTime,
		t2.createdByUsr = t1.createdByUsr,
		t2.modified = now(),
		t2.modifiedBy = 'bloomTicketTransfer',
		t2.modifiedByUsr = 'portal-servicios@gposac.com.mx',
		t2.created = t1.created
	WHERE t1.processed = 0;

	-- INSERCION DE LOS USUARIOS RESPONSABLES DE CERRAR
	INSERT INTO blackstarDb.bloomTicketTeam(ticketId, workerRoleTypeId, blackstarUserId, userGroup, assignedDate)
	SELECT t._id, a.workerRoleTypeId, bg.blackStarUserId, a.userGroup, now() 
	FROM blackstarDb.bloomTicket t
		INNER JOIN blackstarDb.bloomAdvisedGroup a ON t.serviceTypeId = a.serviceTypeId
		INNER JOIN blackstarDb.userGroup g ON a.userGroup = g.externalId
		INNER JOIN blackstarDb.blackstarUser_userGroup bg ON bg.userGroupId = g.userGroupId
		LEFT OUTER JOIN blackstarDb.bloomTicketTeam tt ON tt.ticketId = t._id
	WHERE tt._id IS NULL;

	-- INSERCION DE followUps de tickets bloom
	INSERT INTO blackstarDb.followUp(followUp, created, createdBy, createdByUsr, isSource, followUpReferenceTypeId, bloomTicketId)
	SELECT  t1.followUp, now(), 'bloomTicketTransfer', 'portal-servicios@gposac.com.mx', 1, 'R', t2._id
	FROM blackstarDbTransfer.bloomTicket t1
		INNER JOIN blackstarDb.bloomTicket t2 ON t1.ticketNumber = t2.ticketNumber
		LEFT OUTER JOIN blackstarDb.followUp f ON t2._id = f.bloomTicketId
	WHERE f.followUpId IS NULL;

	-- INSERCION DE ENCUESTAS DE TICKETS BLOOM
	INSERT INTO blackstarDb.bloomSurvey(bloomTicketId, evaluation, comments, created)
	SELECT t2._id, if(t1.resolved = 1, 10, 5), 'N/A', now()
	FROM blackstarDbTransfer.bloomTicket t1
		INNER JOIN blackstarDb.bloomTicket t2 ON t1.ticketNumber = t2.ticketNumber
		LEFT OUTER JOIN blackstarDb.bloomSurvey s ON t2._id = s.bloomTicketId
	WHERE s._id IS NULL;

	-- ACTUALIZACION DEL ESTATUS
	UPDATE blackstarDb.bloomTicket t2
		INNER JOIN blackstarDb.bloomServiceType ty ON t2.serviceTypeId = ty._id
		INNER JOIN blackstarDbTransfer.bloomTicket t1 ON t1.ticketNumber = t2.ticketNumber
	SET
		reponseInTime = if(ty.responseTime < (TO_DAYS(t2.responseDate) - TO_DAYS(t2.created)), 0, 1),
		desviation = ((TO_DAYS(t2.responseDate) - TO_DAYS(t2.created)) - ty.responseTime),
		t2.modified = now(),
	    t2.modifiedBy = 'bloomTicketTransfer',
	    t2.modifiedByUsr = 'portal-servicios@gposac.com.mx'
	WHERE responseDate IS NOT NULL
		AND statusId = 6;

	-- PROCESSED
	UPDATE blackstarDbTransfer.bloomTicket SET
		processed = 1
	WHERE processed = 0 
		AND ticketNumber IN(SELECT DISTINCT ticketNumber FROM blackstarDb.bloomTicket);


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

-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomUpdateTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDbTransfer.BloomUpdateTickets$$
CREATE PROCEDURE blackstarDbTransfer.BloomUpdateTickets() 
BEGIN

  DECLARE counter INTEGER;
  DECLARE done BOOLEAN DEFAULT 0;

  DECLARE applicantUserId Int(11);
  DECLARE officeL Char(1);
  DECLARE serviceTypeId Int(3);
  DECLARE applicantAreaId Int(11);
  DECLARE createdByUsrId Int(11);
  DECLARE bolResponseInTime Tinyint;

  DECLARE created Varchar(100);
  DECLARE createdByUsr Varchar(100);
  DECLARE applicantArea Varchar(100);
  DECLARE serviceType Varchar(200);
  DECLARE serviceTypeSS Varchar(200);
  DECLARE serviceTypeGeneral Varchar(100);
  DECLARE dueDateStr Varchar(100);
  DECLARE description Text;
  DECLARE serviceTypeManager Varchar(100);
  DECLARE project Varchar(100);
  DECLARE officeStr Varchar(20);
  DECLARE ticketNumber Varchar(20);
  DECLARE responseDateStr Varchar(100);
  DECLARE responseInTime Varchar(100);
  DECLARE evaluation Varchar(2);
  DECLARE responseInHours Varchar(50);
  DECLARE desviation Varchar(50);
  DECLARE observations Text;

  DECLARE dueDate DateTime;
  DECLARE responseDate DateTime;
  DECLARE status Int;

  DECLARE transfer_cursor CURSOR FOR 
    SELECT * FROM bloomTransferTicket;
    
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;

  SET counter = 0;
  OPEN transfer_cursor;

  loop_lbl: LOOP
      FETCH transfer_cursor INTO created, createdByUsr, applicantArea, serviceType, serviceTypeSS
                               , serviceTypeGeneral, dueDateStr, description, serviceTypeManager, project
                               , officeStr, ticketNumber, responseDateStr, responseInTime, evaluation
                               , responseInHours, desviation, observations;
      IF done = 1 THEN 
			   LEAVE loop_lbl;
		  END IF;                           
      SET bolResponseInTime = 0;
      SET createdByUsrId = IFNULL((SELECT blackStarUserId from blackstarDb.blackstaruser where email = 'portal-servicios@gposac.com.mx'), -1);                               
      SET applicantUserId = IFNULL((SELECT blackStarUserId from blackstarDb.blackstaruser where email = createdByUsr), -1);
      SET officeL = IFNULL((SELECT officeId from blackstarDb.office where officeName = officeStr), '?');
      SET serviceTypeId = IFNULL((SELECT _id from blackstarDb.bloomServiceType where name = serviceType), -1);
      SET applicantAreaId = IFNULL((SELECT _id from blackstarDb.bloomApplicantArea where name = applicantArea), -1);
      IF project IS NULL THEN
        SET project = 'UNKNOWN';
      END IF;
      IF responseInTime = 'SI' THEN
        SET bolResponseInTime = 1;
        SET status = 5;
      ELSEIF responseInTime IS NULL THEN
        SET bolResponseInTime = null;
        SET status = 2;
      ELSE SET status = 2;
      END IF;
      IF dueDateStr IS NULL THEN
         SET dueDate = NOW();
      ELSE SET dueDate = STR_TO_DATE(dueDateStr, '%Y-%m-%d %T');
      END IF;
      IF responseDateStr IS NULL THEN
         SET responseDate = NULL;
      ELSE SET responseDate = STR_TO_DATE(responseDateStr, '%Y-%m-%d %T');
      END IF;
      IF evaluation = '' THEN
         SET evaluation = '0';
      END IF;   
      IF desviation = '' THEN
         SET desviation = '0';
      END IF;
      INSERT INTO blackstarDb.bloomTicket(applicantUserId, officeId, serviceTypeId, statusId, applicantAreaId
                  , dueDate, project, ticketNumber, description, reponseInTime, evaluation, desviation
                  , responseDate, created, createdBy, createdByUsr, modified, modifiedBy, modifiedByUsr) 
             VALUES(applicantUserId, officeL, serviceTypeId, status, applicantAreaId, dueDate, project
                    , ticketNumber, description, bolResponseInTime, CAST(evaluation AS UNSIGNED INTEGER) , desviation, responseDate
                    , STR_TO_DATE(created, '%Y-%m-%d %T'), 'BloomDataLoader', createdByUsrId, null, null, null);
      SET counter = counter + 1;
  END LOOP loop_lbl;

  CLOSE transfer_cursor;    
  
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomUpdateTransferFollow
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDbTransfer.BloomUpdateTransferFollow$$
CREATE PROCEDURE blackstarDbTransfer.BloomUpdateTransferFollow()
BEGIN

  DECLARE counter INTEGER;
  DECLARE ticketId Int(11);
  DECLARE ticket Varchar(20);
  DECLARE createdStr Varchar(100);
  DECLARE comment Text;
  DECLARE done BOOLEAN DEFAULT 0;
 
  DECLARE transfer_cursor CURSOR FOR 
    SELECT * FROM bloomTransferFollow;
    
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;

  SET counter = 0;
  OPEN transfer_cursor;
  loop_lbl: LOOP
      FETCH transfer_cursor INTO ticket, createdStr, comment;
      IF done = 1 THEN 
			   LEAVE loop_lbl;
		  END IF;  
      SET ticketId =(SELECT _id from blackstarDb.bloomTicket where ticketNumber = ticket);
      INSERT INTO blackstarDb.followUp(bloomTicketId,followUp, created, createdBy, createdByUsr) 
             VALUES(ticketId, comment, STR_TO_DATE(createdStr, '%y/%m/%d'), 'BloomDataLoader', 'portal-servicios@gposac.com.mx');
      SET counter = counter + 1;
  END LOOP loop_lbl;

  CLOSE transfer_cursor;    
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomUpdateTransferTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDbTransfer.BloomUpdateTransferTeam$$
CREATE PROCEDURE blackstarDbTransfer.BloomUpdateTransferTeam()
BEGIN

  DECLARE counter INTEGER;
  DECLARE ticketId Int(11);
  DECLARE ticket Varchar(20);
  DECLARE userName Varchar(100);
  DECLARE userId Varchar(100);
  DECLARE done BOOLEAN DEFAULT 0;

  DECLARE transfer_cursor CURSOR FOR 
    SELECT * FROM bloomTransferTicketTeam;
    
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;

  SET counter = 0;
  OPEN transfer_cursor;
  loop_lbl: LOOP
      FETCH transfer_cursor INTO ticket, userName;
      IF done = 1 THEN 
			   LEAVE loop_lbl;
		  END IF;
      SET ticketId =(SELECT _id from blackstarDb.bloomTicket where ticketNumber = ticket);
      SET userId = IFNULL((SELECT blackStarUserId from blackstarDb.blackstaruser where name LIKE CONCAT(userName,'%')), -1);
      INSERT INTO blackstarDb.bloomTicketTeam(ticketId,workerRoleTypeId, blackstarUserId, assignedDate) 
             VALUES(ticketId,1, userId, NOW());
      SET counter = counter + 1;
  END LOOP loop_lbl;

  CLOSE transfer_cursor;    
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomUpdateTransferUsers
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDbTransfer.BloomUpdateTransferUsers$$
CREATE PROCEDURE blackstarDbTransfer.BloomUpdateTransferUsers()
BEGIN

  DECLARE done BOOLEAN DEFAULT 0;

  DECLARE bloomCreatedByUsrMail Varchar(100);
  DECLARE bloomCreatedByUsrName Varchar(100);
  DECLARE bloomCreatedByUsrLastName Varchar(100);
  DECLARE iniSplitPos INTEGER;
  DECLARE endSplitPos INTEGER;
  DECLARE splitValue VARCHAR(100);
  DECLARE counter INTEGER;
    
  DECLARE user_cursor CURSOR FOR 
     SELECT DISTINCT createdByUsr FROM bloomTransferTicket
     WHERE createdByUsr NOT IN (SELECT email FROM blackstarDb.blackstaruser);

  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;

  OPEN user_cursor;

  SET counter = 0;
  fill_users: LOOP
      FETCH user_cursor INTO bloomCreatedByUsrMail; 
      IF done = 1 THEN 
			   LEAVE fill_users;
		  END IF;  
      SET endSplitPos = LOCATE('\@', bloomCreatedByUsrMail, 1);
      SET splitValue = SUBSTR(bloomCreatedByUsrMail, 1, endSplitPos -1);
      SET endSplitPos = LOCATE('\.', splitValue, 1);
      SET bloomCreatedByUsrName = SUBSTR(splitValue, 1, endSplitPos -1);
      SET bloomCreatedByUsrName = CONCAT(UCASE(LEFT(bloomCreatedByUsrName, 1)), 
                                         SUBSTRING(bloomCreatedByUsrName, 2));
      SET bloomCreatedByUsrLastName = SUBSTR(splitValue, endSplitPos +1);
      SET bloomCreatedByUsrLastName = CONCAT(UCASE(LEFT(bloomCreatedByUsrLastName, 1)), 
                                              SUBSTRING(bloomCreatedByUsrLastName, 2));                                         
      INSERT INTO blackstarDb.blackstarUser (email, name) VALUES (bloomCreatedByUsrMail, CONCAT(bloomCreatedByUsrName, ' ', bloomCreatedByUsrLastName));
      SET counter = counter + 1;
  END LOOP fill_users;
  CLOSE user_cursor;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomTransfer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDbTransfer.BloomTransfer$$
CREATE PROCEDURE blackstarDbTransfer.BloomTransfer()
BEGIN
	CALL BloomUpdateTransferUsers();
  	CALL BloomUpdateTickets();
  	CALL BloomUpdateTransferTeam();
  	CALL BloomUpdateTransferFollow();
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
		pLevel, CONVERT_TZ(now(),'+00:00','-5:00'), pError, pSender, pStackTrace;
	
END$$


-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;

-- -----------------------------------------------------------------------------
-- Desc:	Cambia el esquema de la bd
-- Auth:	Daniel Castillo B.
-- Date:	19/05/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    19/05/2014  DCB  	Carga de esquema Bloom
--                              * bloomServiceType
--                              * bloomWorkerRoleType
--                              * bloomStatusType
--                              * bloomApplicantArea
--                              * bloomDeliverableType
--                              * bloomRequiredDeliverable
--                              * bloomTicket
--                              * bloomTicketTeam
--                              * bloomDeliverableTrace
-- ---------------------------------------------------------------------------
-- 2    22/06/2014  OMA  	Cambios adicionales para el nuevo manejo de tickets internos
--                              * bloomAdvisedGroup Nueva tabla
--                              * bloomServiceType Actualizacion de campos
--                              * bloomDeliverableType Actualizacion de campos
--                              * bloomTicket Actualizacion de campos
-- ---------------------------------------------------------------------------
-- 3 	10/07/2014	SAG 	Se agrega desiredDate a bloomTicket
--							Se agrega hidden a bloomServiceType
--							Se agrega docId a bloomDeliverableTrace
-- ---------------------------------------------------------------------------
-- 4 	23/07/2014	SAG 	Se agrega autoClose a bloomServiceType
--							Se agrega workerRoleTypeId a bloomAdvisedGroup
--							Se agrega bloomServiceArea
--							Se agrega bloomServiceAreaId a bloomServiceType
-- ---------------------------------------------------------------------------
-- 5 	03/10/2014	SAG 	Se agrega name a bloomDeliverableTrace
-- ---------------------------------------------------------------------------
-- 6 	10/11/2014	SAG 	Se agrega resolverCanClose
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.upgradeBloomSchema$$
CREATE PROCEDURE blackstarDb.upgradeBloomSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

-- Agregando resolverCanClose en bloomServiceType
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceType' AND COLUMN_NAME = 'resolverCanClose') = 0  THEN
		ALTER TABLE bloomServiceType ADD resolverCanClose INT NULL DEFAULT 0;
	END IF;

-- Agregando name a bloomDeliverableTrace
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomDeliverableTrace' AND COLUMN_NAME = 'name') = 0  THEN
		ALTER TABLE bloomDeliverableTrace ADD name VARCHAR(400) NULL;
	END IF;

-- AGREGANDO TABLA bloomServiceArea
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceArea') = 0 THEN
		 CREATE TABLE blackstarDb.bloomServiceArea(
            bloomServiceAreaId CHAR(1) NOT NULL,
            bloomServiceArea VARCHAR(200) NOT NULL,
			PRIMARY KEY (bloomServiceAreaId)
         ) ENGINE=INNODB;
	END IF;

-- AGREGANDO TABLA bloomServiceType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceType') = 0 THEN
		 CREATE TABLE blackstarDb.bloomServiceType(
            _id INT(3) NOT NULL,
            name VARCHAR(150) NOT NULL,
            description VARCHAR(400) NOT NULL,
            responseTime INT(2) NOT NULL,
			applicantAreaId INT(11) NOT NULL,
			PRIMARY KEY (_id)
         ) ENGINE=INNODB;
	END IF;

	
-- Agregando hidden a bloomServiceType
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceType' AND COLUMN_NAME = 'hidden') = 0  THEN
		ALTER TABLE bloomServiceType ADD hidden INT NULL;
	END IF;
	
-- Agregando autoclose a bloomServiceType
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceType' AND COLUMN_NAME = 'autoClose') = 0  THEN
		ALTER TABLE bloomServiceType ADD autoClose INT NULL;
	END IF;

-- Agregando bloomServiceAreaId a bloomServiceType
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceType' AND COLUMN_NAME = 'bloomServiceAreaId') = 0  THEN
		ALTER TABLE bloomServiceType ADD bloomServiceAreaId CHAR(1) NOT NULL DEFAULT 'I';
		ALTER TABLE bloomServiceType ADD CONSTRAINT bloomServiceType_bloomServiceArea FOREIGN KEY (bloomServiceAreaId) REFERENCES bloomServiceArea(bloomServiceAreaId);
		UPDATE bloomServiceType SET bloomServiceAreaId = 'I' WHERE _id >= 1 AND _id <= 14;
		UPDATE bloomServiceType SET bloomServiceAreaId = 'C' WHERE _id = 15;
		UPDATE bloomServiceType SET bloomServiceAreaId = 'H' WHERE _id >= 16 AND _id <= 20;
		UPDATE bloomServiceType SET bloomServiceAreaId = 'A' WHERE _id >= 16 AND _id <= 21;
		UPDATE bloomServiceType SET bloomServiceAreaId = 'R' WHERE _id = 24;
	END IF;

-- AGREGANDO TABLA bloomWorkerRoleType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomWorkerRoleType') = 0 THEN
		 CREATE TABLE blackstarDb.bloomWorkerRoleType(
           _id INT(11) NOT NULL,
           name VARCHAR(150) NOT NULL,
           description VARCHAR(400) NOT NULL,
		   PRIMARY KEY (_id),
		   UNIQUE UQ_bloomWorkerRoleType(name)
         )ENGINE=INNODB;
	END IF;	

-- AGREGANDO TABLA bloomStatusType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomStatusType') = 0 THEN
		 CREATE TABLE blackstarDb.bloomStatusType(
           _id INT(11) NOT NULL,
           name VARCHAR(150) NOT NULL,
           description VARCHAR(400) NOT NULL,
		   PRIMARY KEY (_id),
		   UNIQUE UQ_bloomStatusType(name)
         )ENGINE=INNODB;
	END IF;	

 -- AGREGANDO TABLA bloomApplicantArea
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomApplicantArea') = 0 THEN
		 CREATE TABLE blackstarDb.bloomApplicantArea(
           _id INT(11) NOT NULL,
           name VARCHAR(150) NOT NULL,
           description VARCHAR(400) NOT NULL,
		   PRIMARY KEY (_id),
		   UNIQUE UQ_bloomApplicantArea(name)
         )ENGINE=INNODB;
	END IF;	

 -- AGREGANDO TABLA bloomDeliverableType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomDeliverableType') = 0 THEN
		 CREATE TABLE blackstarDb.bloomDeliverableType(
           _id INT(11) NOT NULL,
           name VARCHAR(150) NOT NULL,
           description VARCHAR(400) NOT NULL,
		   serviceTypeId INT(3) NOT NULL,
		   PRIMARY KEY (_id),
		   FOREIGN KEY (serviceTypeId) REFERENCES bloomServiceType (_id)
         )ENGINE=INNODB;
	END IF;	

 -- AGREGANDO TABLA bloomRequiredDeliverable
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomRequiredDeliverable') = 0 THEN
		 CREATE TABLE blackstarDb.bloomRequiredDeliverable(
           _id INT(11) NOT NULL,
           serviceTypeId INT(3) NOT NULL,
           deliverableTypeId INT(11) NOT NULL,
		   PRIMARY KEY (_id),
		   UNIQUE UQ_bloomRequiredDeliverable(serviceTypeId, deliverableTypeId),
		   FOREIGN KEY (serviceTypeId) REFERENCES bloomServiceType (_id),
           FOREIGN KEY (deliverableTypeId) REFERENCES bloomDeliverableType (_id)
         )ENGINE=INNODB;
	END IF;	

 -- AGREGANDO TABLA bloomTicket
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomTicket') = 0 THEN
		 CREATE TABLE blackstarDb.bloomTicket(
           _id INT(11) NOT NULL AUTO_INCREMENT,
           applicantUserId INT(11) NOT NULL,
           officeId char(1) NOT NULL,
           serviceTypeId INT(3) NOT NULL,
           statusId INT(11) NOT NULL,
           applicantAreaId INT(11) NOT NULL,
           dueDate Date NOT NULL,
           project VARCHAR(50) NOT NULL,
           ticketNumber VARCHAR(15) NOT NULL,
           description Text NOT NULL,
           reponseInTime Tinyint,
           evaluation INT(2),
           desviation Float(30,20),
           responseDate Datetime,
           asignee VARCHAR(100),
           created Datetime NOT NULL,
           createdBy VARCHAR(50) NOT NULL,
           createdByUsr VARCHAR(50) NOT NULL,
           modified Datetime,
           modifiedBy VARCHAR(50),
           modifiedByUsr VARCHAR(50),
			purposeVisitVL TEXT,
			purposeVisitVISAS TEXT,
			draftCopyDiagramVED TEXT,
			formProjectVED TEXT,
			observationsVEPI TEXT,
			draftCopyPlanVEPI TEXT,
			formProjectVEPI TEXT,
			observationsVRCC TEXT,
			checkListVRCC TEXT,
			formProjectVRCC TEXT,
			questionVPT TEXT,
			observationsVSA TEXT,
			formProjectVSA TEXT,
			productInformationVSP TEXT,
			observationsISED TEXT,
			draftCopyPlanISED TEXT,
			observationsISRC TEXT,
			attachmentsISRC TEXT,
			apparatusTraceISSM TEXT,
			observationsISSM TEXT,
			questionISSM TEXT,
			ticketISRPR TEXT,
			modelPartISRPR TEXT,
			observationsISRPR TEXT,
			productInformationISSPC TEXT,
			positionPGCAS TEXT,
			collaboratorPGCAS TEXT,
			justificationPGCAS TEXT,
			salaryPGCAS TEXT,
			positionPGCCP TEXT,
			commentsPGCCP TEXT,
			developmentPlanPGCCP TEXT,
			targetPGCCP TEXT,
			salaryPGCCP TEXT,
			positionPGCNC TEXT,
			developmentPlanPGCNC TEXT,
			targetPGCNC TEXT,
			salaryPGCNC TEXT,
			justificationPGCNC TEXT,
			positionPGCF TEXT,
			collaboratorPGCF TEXT,
			justificationPGCF TEXT,
			positionPGCAA TEXT,
			collaboratorPGCAA TEXT,
			justificationPGCAA TEXT,
			requisitionFormatGRC TEXT,
			linkDocumentGM TEXT,
			suggestionGSM TEXT,
			documentCodeGSM TEXT,
			justificationGSM TEXT,
			problemDescriptionGPTR TEXT,	
			resolvedOnTime INT,	   
	   
           PRIMARY KEY (_id),
           FOREIGN KEY (serviceTypeId) REFERENCES bloomServiceType (_id),
           FOREIGN KEY (statusId) REFERENCES bloomStatusType (_id),
           FOREIGN KEY (applicantUserId) REFERENCES blackstarUser (blackstarUserId),
           FOREIGN KEY (applicantAreaId) REFERENCES bloomApplicantArea (_id),
		   UNIQUE UQ_bloomTicket(ticketNumber)
         )ENGINE=INNODB;

		
	END IF;	

-- Agregando desiredDate a bloomTicket
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomTicket' AND COLUMN_NAME = 'desiredDate') = 0  THEN
		ALTER TABLE bloomTicket ADD desiredDate DATETIME NULL;
	END IF;

-- AGREGANDO TABLA bloomSurvey
IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomSurvey') = 0 THEN
		 CREATE TABLE blackstarDb.bloomSurvey(
           _id INT(11) NOT NULL AUTO_INCREMENT,
           bloomTicketId INT(11) NOT NULL,
           evaluation Tinyint NOT NULL,
           comments Text NOT NULL,
           created Date NOT NULL,
		   PRIMARY KEY (_id),
		   FOREIGN KEY (bloomTicketId) REFERENCES bloomTicket (_id)
         )ENGINE=INNODB;
	END IF;	
	
 -- AGREGANDO TABLA bloomTicketTeam
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomTicketTeam') = 0 THEN
		 CREATE TABLE blackstarDb.bloomTicketTeam(
           _id INT(11) NOT NULL AUTO_INCREMENT,
           ticketId INT(11) NOT NULL,
           workerRoleTypeId INT(11) NOT NULL,
           blackstarUserId INT(11) NOT NULL,
           userGroup VARCHAR(50) NOT NULL,
		   assignedDate Datetime NOT NULL,
           PRIMARY KEY (`_id`),
		   FOREIGN KEY (ticketId) REFERENCES bloomTicket (_id),
           FOREIGN KEY (workerRoleTypeId) REFERENCES bloomWorkerRoleType (_id),
           FOREIGN KEY (blackstarUserId) REFERENCES blackstarUser (blackstarUserId)
         )ENGINE=INNODB;
	END IF;

 -- AGREGANDO TABLA bloomDeliverableTrace
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomDeliverableTrace') = 0 THEN
		 CREATE TABLE blackstarDb.bloomDeliverableTrace(
           _id INT(11) NOT NULL AUTO_INCREMENT,
           bloomTicketId INT(11) NOT NULL,
           deliverableTypeId INT(11) NOT NULL,
           delivered INT(11) DEFAULT 0,
           date Datetime NOT NULL,
		   PRIMARY KEY (_id),
		   FOREIGN KEY (bloomTicketId) REFERENCES bloomTicket (_id),
           FOREIGN KEY (deliverableTypeId) REFERENCES bloomDeliverableType (_id)
         )ENGINE=INNODB;
	END IF;		

-- Agregando docId a bloomDeliverableTrace
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomDeliverableTrace' AND COLUMN_NAME = 'docId') = 0  THEN
		ALTER TABLE bloomDeliverableTrace ADD docId VARCHAR(400) NULL;
	END IF;

-- AGREGANDO COLUMNA bloomTicketId A followUp
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'followUp' AND COLUMN_NAME = 'bloomTicketId') =0  THEN
		 ALTER TABLE blackstarDb.followUp ADD bloomTicketId INT(11);
		 ALTER TABLE blackstarDb.followUp ADD CONSTRAINT R11 FOREIGN KEY (bloomTicketId) REFERENCES bloomTicket (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
	END IF;


-- AGREGANDO TABLA bloomAdvisedGroup
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomAdvisedGroup') = 0 THEN
			CREATE TABLE blackstarDb.bloomAdvisedGroup
			(
			  advicedGroupId INT(11) NOT NULL AUTO_INCREMENT,
			  applicantAreaId INT(3) NOT NULL,
			  serviceTypeId INT(3) NOT NULL,
			  userGroup VARCHAR(150) NOT NULL,
			  PRIMARY KEY (advicedGroupId)
			);
			ALTER TABLE blackstarDb.bloomAdvisedGroup ADD CONSTRAINT bloomRelationAdvisedGroup UNIQUE(applicantAreaId,serviceTypeId,userGroup);

	END IF;

-- Agregando docId a bloomDeliverableTrace
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomAdvisedGroup' AND COLUMN_NAME = 'workerRoleTypeId') = 0  THEN
		ALTER TABLE bloomAdvisedGroup ADD workerRoleTypeId INT NULL;
		ALTER TABLE blackstarDb.bloomAdvisedGroup ADD CONSTRAINT bloomAdvisedGroup_workerRoleType FOREIGN KEY (workerRoleTypeId) REFERENCES bloomWorkerRoleType (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
	END IF;
	
-- -----------------------------------------------------------------------------
-- FIN SECCION DE CAMBIOS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDb.upgradeBloomSchema();

DROP PROCEDURE blackstarDb.upgradeBloomSchema;

-- -----------------------------------------------------------------------------
-- File:	bloomDb_StoredProcedures.sql   
-- Name:	bloomDb_StoredProcedures
-- Desc:	Crea o actualiza los Stored procedures operativos de la aplicacion
-- Auth:	Oscar Martinez
-- Date:	08/04/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ----------------------------------------------------
-- 35   08/02/2015  SAG   Se modifica:
--                          GetBloomPercentageTimeClosedTickets
--                          GetBloomPercentageEvaluationTickets
--                          GetBloomNumberTicketsByArea
-- ------------------------------------------------------------------------------

use blackstarDb;


DELIMITER $$


-- -----------------------------------------------------------------------------
  -- blackstarDb.bloomGetTicketsServiceOrdersMixed
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.bloomGetTicketsServiceOrdersMixed$$
CREATE PROCEDURE blackstarDb.bloomGetTicketsServiceOrdersMixed()
BEGIN
 
  SELECT * FROM (
    SELECT DISTINCT ticketNumber AS label, ticketNumber AS value FROM ticket UNION
    SELECT DISTINCT serviceOrderNumber AS label, serviceOrderNumber AS value FROM serviceOrder
  ) A ORDER BY label;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.bloomTicketAutoclose
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.bloomTicketAutoclose$$
DROP PROCEDURE IF EXISTS blackstarDb.bloomTicketAutoProcess$$
CREATE PROCEDURE blackstarDb.bloomTicketAutoProcess()
BEGIN
  -- Auto close
  UPDATE bloomTicket SET 
    statusId = 6,
    modified = CONVERT_TZ(now(),'+00:00','-5:00'),
    modifiedBy = 'bloomTicketAutoProcess',
    modifiedByUsr = 'Jobs'
  WHERE serviceTypeId NOT IN (13, 15)
    AND statusId = 5
    AND responseDate < DATE_ADD(now(), INTERVAL -2 DAY);

  -- Auto status - Retrasado
  UPDATE bloomTicket SET 
    statusId = 3,
    modified = CONVERT_TZ(now(),'+00:00','-5:00'),
    modifiedBy = 'bloomTicketAutoProcess',
    modifiedByUsr = 'Jobs'
  WHERE CONVERT_TZ(now(),'+00:00','-5:00') > dueDate
    AND statusId = 1;

END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.UserCanAssignBloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UserCanAssignBloomTicket$$
CREATE PROCEDURE blackstarDb.UserCanAssignBloomTicket(pTicketId INT, pUser VARCHAR(100))
BEGIN
  SELECT count(*) FROM blackstarDb.blackstarUser bu
    INNER JOIN blackstarDb.blackstarUser_userGroup j ON bu.blackstarUserId = j.blackstarUserId
    INNER JOIN blackstarDb.userGroup g ON j.userGroupId = g.userGroupId
    INNER JOIN bloomTicketTeam tt ON tt.userGroup = g.externalId
  WHERE bu.email = pUser
    AND tt.ticketId = pTicketId
  AND tt.workerRoleTypeId = 1;

END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.AssignBloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AssignBloomTicket$$
CREATE PROCEDURE blackstarDb.AssignBloomTicket(pTicketId INT, pAsignee VARCHAR(100), pUser VARCHAR(100))
BEGIN
  UPDATE bloomTicket SET 
    asignee = pAsignee,
    statusId = 1,
    modified = CONVERT_TZ(now(),'+00:00','-5:00'),
    modifiedBy = 'AssignBloomTicket',
    modifiedByUsr = pUser
  WHERE _id = pTicketId;
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetBloomTicketId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomTicketId$$
CREATE PROCEDURE blackstarDb.GetBloomTicketId(pTicketNumber VARCHAR(100))
BEGIN
  SELECT _id FROM bloomTicket WHERE ticketNumber = pTicketNumber;
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetbloomTicketDetail
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketDetail$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketDetail`(ticketId INTEGER)
BEGIN

SELECT *
FROM ((SELECT *
       FROM bloomTicket WHERE _ID = ticketId) AS ticketDetail
       LEFT JOIN (SELECT bu.blackstarUserId refId, bu.name applicantUserName
           FROM blackstarUser bu) AS j1
           ON ticketDetail.applicantUserId = j1.refId
       LEFT JOIN (SELECT of.officeId refId, of.officeName as officeName 
           FROM office of) AS j2
           ON ticketDetail.officeId = j2.refId
       LEFT JOIN (SELECT st._id refId, st.name as serviceTypeName, st.resolverCanClose as resolverCanClose 
           FROM bloomServiceType st) AS j3
           ON ticketDetail.serviceTypeId = j3.refId           
       LEFT JOIN (SELECT sp._id refId, sp.name as statusName 
           FROM bloomStatusType sp) AS j4
           ON ticketDetail.statusId = j4.refId           
       LEFT JOIN (SELECT aa._id refId, aa.name as applicantAreaName 
           FROM bloomApplicantArea aa) AS j5
           ON ticketDetail.applicantAreaId = j5.refId            
       LEFT JOIN (SELECT bu.email refId, bu.name createdByUsrName
           FROM blackstarUser bu) AS j6
           ON ticketDetail.createdByUsr = j6.refId
       LEFT JOIN (SELECT bu.email refId, bu.name modifiedByUsrName
           FROM blackstarUser bu) AS j7
           ON ticketDetail.modifiedByUsr = j7.refId);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetbloomTicketTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketTeam$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketTeam`(ticket INTEGER)
BEGIN

SELECT 
  t._id AS id,
  ticketId AS ticketId,
  workerRoleTypeId AS workerRoleTypeId,
  t.blackstarUserId AS blackstarUserId,
  u.email AS userEmail,
  assignedDate AS assignedDate
FROM bloomTicketTeam t
  INNER JOIN blackstarUser u ON t.blackstarUserId = u.blackstarUserId
  INNER JOIN bloomWorkerRoleType w ON t.workerRoleTypeId = w._id
WHERE t.ticketId = ticket;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpTobloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpTobloomTicket$$
CREATE PROCEDURE blackstarDb.`AddFollowUpTobloomTicket`(pTicketId INTEGER, pAsignee VARCHAR(50), pCreatedByUsrMail VARCHAR(50), pMessage TEXT)
BEGIN
  
  -- LIMPIAR EL REGISTRO ACTIVE
  UPDATE followUp SET isActive = NULL WHERE bloomTicketId = pTicketId AND isActive = 1;

	INSERT INTO blackstarDb.followUp(bloomTicketId, followup, followUpReferenceTypeId, asignee, created, createdBy, createdByUsr, isActive)
	VALUES(pTicketId, pMessage, 'R', ifnull(pAsignee, pCreatedByUsrMail), CONVERT_TZ(now(),'+00:00','-5:00'), 'AddFollowUpTobloomTicket', pCreatedByUsrMail, 1);

  IF ifnull(pAsignee, '') != '' THEN
    UPDATE bloomTicket SET 
    asignee = pAsignee,
    assignedBy = pCreatedByUsrMail,
    modified = now(),
    modifiedBy = 'AddFollowUpTobloomTicket'
  WHERE _id = pTicketId;

  END IF;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertbloomTicketTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertbloomTicketTeam$$
DROP PROCEDURE IF EXISTS blackstarDb.AddMemberTicketTeam$$
CREATE PROCEDURE blackstarDb.`AddMemberTicketTeam`(pTicketId INTEGER, pWorkerRoleTypeId INTEGER, pblackstarUser VARCHAR(50), pUserGroup VARCHAR(50))
BEGIN

SET @blackstarUserId = (SELECT blackstarUserId FROM blackstarDb.blackstarUser WHERE email = pblackstarUser);

IF NOT EXISTS (SELECT * FROM bloomTicketTeam WHERE ticketId = pTicketId AND blackstarUserId = @blackstarUserId) THEN
    INSERT INTO blackstarDb.bloomTicketTeam(ticketId, workerRoleTypeId, blackstarUserId, userGroup, assignedDate)
    VALUES(pTicketId, pWorkerRoleTypeId, @blackstarUserId, pUserGroup, CONVERT_TZ(now(),'+00:00','-5:00'));   
ELSE
   UPDATE blackstarDb.bloomTicketTeam SET 
      assignedDate = CONVERT_TZ(now(),'+00:00','-5:00'), 
      workerRoleTypeId = IF(workerRoleTypeId < pWorkerRoleTypeId, workerRoleTypeId, pWorkerRoleTypeId)
   WHERE ticketId = pTicketId 
    AND blackstarUserId = @blackstarUserId;
END IF;
    
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomFollowUpByTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomFollowUpByTicket$$
CREATE PROCEDURE blackstarDb.`GetBloomFollowUpByTicket`(pTicketId INTEGER)
BEGIN
	SELECT 
    created AS created, 
    u2.name AS createdByUsr, 
    u2.email AS createdByUsrEmail,
    u.name AS asignee, 
    followup AS followup
	FROM followUp f
		   LEFT OUTER JOIN blackstarUser u ON f.asignee = u.email
		   LEFT OUTER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE bloomTicketId = pTicketId
	ORDER BY created;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomDeliverableType
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomDeliverableType$$
CREATE PROCEDURE blackstarDb.`GetBloomDeliverableType`(pServiceTypeId INTEGER)
BEGIN
	SELECT 
    _id id, name name, description description 
  FROM bloomDeliverableType
  WHERE serviceTypeId = pServiceTypeId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddBloomDelivarable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddBloomDelivarable$$
CREATE PROCEDURE blackstarDb.`AddBloomDelivarable`(pTicketId INTEGER, pDeliverableTypeId INTEGER, pDocId VARCHAR(200), pName VARCHAR(400))
BEGIN
DECLARE counter INTEGER;

  SET counter = (SELECT count(*) 
                 FROM bloomDeliverableTrace 
                 WHERE bloomTicketId = pTicketId 
                  AND deliverableTypeId = pDeliverableTypeId
                  AND deliverableTypeId NOT IN(SELECT _id FROM bloomDeliverableType WHERE name = 'Otro'));

  IF (counter > 0) THEN
    UPDATE bloomDeliverableTrace SET delivered = 1, date = CONVERT_TZ(now(),'+00:00','-5:00'), docId = pDocId
    WHERE bloomTicketId = pTicketId 
      AND deliverableTypeId = pDeliverableTypeId;
  ELSE 
	  INSERT INTO bloomDeliverableTrace (bloomTicketId, deliverableTypeId, delivered, date, docId, name)
    VALUES (pTicketId, pDeliverableTypeId, 1, CONVERT_TZ(now(),'+00:00','-5:00'), pDocId, pName);
  END IF;  
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetbloomTicketResponsible
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketResponsible$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketResponsible`(pTicketId INTEGER)
BEGIN

DECLARE responsableId INTEGER;

SET responsableId = (SELECT blackstarUserId 
                     FROM bloomTicketTeam 
                     WHERE ticketId = pTicketId
                           AND workerRoleTypeId = 1
                     LIMIT 1);
SELECT * 
FROM blackstarUser
WHERE blackstarUserId = responsableId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetbloomTicketResponsible
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketUserForResponse$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketUserForResponse`(pTicketId INTEGER)
BEGIN

DECLARE responseUserId INTEGER;

SET responseUserId = (SELECT blackstarUserId 
                     FROM bloomTicketTeam 
                     WHERE ticketId = pTicketId
                           AND workerRoleTypeId = 2
                     ORDER BY assignedDate DESC
                     LIMIT 1);
SELECT * 
FROM blackstarUser
WHERE blackstarUserId = responseUserId;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetbloomTicketResponsible
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserById$$
CREATE PROCEDURE blackstarDb.`GetUserById`(pId INTEGER)
BEGIN

        SELECT u.blackstarUserId blackstarUserId, u.email userEmail, u.name userName
        FROM blackstarUser u
        WHERE u.blackstarUserId = pId;
        
END$$



-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomPendingTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomPendingTickets$$
CREATE PROCEDURE blackstarDb.`getBloomPendingTickets`(UserId INTEGER)
BEGIN
  SELECT DISTINCT
    ti._id as id,
    ti.ticketNumber,
    ti.created,
    ti.applicantAreaId, 
    ti.dueDate, 
    ti.desiredDate, 
    bu.name AS createdUserName,
    ba.name as areaName,
    ti.serviceTypeId,
    st.name as serviceName,
    st.responseTime,
    ti.responseDate,
    ti.project,
    ti.officeId, 
    o.officeName,
    ti.statusId,
    s.name as statusTicket,
    a.bloomServiceArea as serviceArea
  FROM bloomTicket ti
       INNER JOIN bloomTicketTeam tm on (ti._id = tm.ticketId)
       INNER JOIN bloomApplicantArea ba on (ba._id = ti.applicantAreaId)
       INNER JOIN bloomServiceType st on (st._id = ti.serviceTypeId)
       INNER JOIN office o on (o.officeId = ti.officeId)
       INNER JOIN bloomStatusType s on (s._id = ti.statusId)
       INNER JOIN bloomServiceArea a ON a.bloomServiceAreaId = st.bloomServiceAreaId
       INNER JOIN blackstarUser bu ON ti.createdByUsr = bu.email
  WHERE tm.blackstarUserId = UserId 
      AND tm.workerRoleTypeId = 1
      AND ti.statusId < 6 
      AND ti.statusId != 4
  ORDER BY ti.statusId, ti.created;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.getbloomTickets vista para el coordinador.
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getbloomTickets$$
CREATE PROCEDURE blackstarDb.getbloomTickets(UserId INTEGER)
BEGIN

SELECT 
	ti._id as id,
	ti.ticketNumber,
	ti.created,
	ti.applicantAreaId, 
	ba.name as areaName,
	ti.serviceTypeId,
	st.name as serviceName,
	st.responseTime,
	ti.project,
	ti.officeId, 
	o.officeName,
	ti.statusId,
	s.name as statusTicket
FROM bloomTicket ti
INNER JOIN bloomTicketTeam tm on (ti._id = tm.ticketId)
INNER JOIN bloomApplicantArea ba on (ba._id = ti.applicantAreaId)
INNER JOIN bloomServiceType st on (st._id = ti.serviceTypeId)
INNER JOIN office o on (o.officeId = ti.officeId)
INNER JOIN bloomStatusType s on (s._id = ti.statusId)
WHERE tm.blackstarUserId=UserId
ORDER BY ti.statusId,ti.created;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.getCatalogEmployeeByGroup
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCatalogEmployeeByGroup$$
CREATE PROCEDURE blackstarDb.getCatalogEmployeeByGroup(pUserGroup VARCHAR(100))
BEGIN

	SELECT 
		u.blackstarUserId AS id,
		u.name AS name, 
		u.email AS email
	FROM blackstarUser_userGroup ug
		INNER JOIN blackstarUser u ON u.blackstarUserId = ug.blackstarUserId
		INNER JOIN userGroup g ON g.userGroupId = ug.userGroupId
	WHERE g.externalId = pUserGroup
	ORDER BY u.name;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomDocumentsByService, lista de documentos por tipo de servicio
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomDocumentsByService$$
CREATE PROCEDURE blackstarDb.getBloomDocumentsByService(paramServiceTypeId INTEGER)
BEGIN

select a.deliverableTypeId as id, b.name as label from bloomRequiredDeliverable a
INNER JOIN bloomDeliverableType b on (b._id =a.deliverableTypeId)
WHERE a.serviceTypeId =paramServiceTypeId
AND a.deliverableTypeId != -1
ORDER BY a.deliverableTypeId;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomProjects
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomProjects$$
CREATE PROCEDURE blackstarDb.getBloomProjects()
BEGIN

	SELECT DISTINCT project AS id,project label
	FROM blackstarDb.policy
		WHERE startDate <= CONVERT_TZ(now(),'+00:00','-5:00') AND CONVERT_TZ(now(),'+00:00','-5:00') <= endDate
	ORDER BY project;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.getbloomApplicantArea
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getbloomApplicantArea$$
CREATE PROCEDURE blackstarDb.getbloomApplicantArea()
BEGIN
SELECT _ID as id ,NAME AS label FROM bloomApplicantArea
WHERE _ID != -1
ORDER BY _ID;
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomServiceType       SE MODIFICO PARA LA FASE 2
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomServiceType$$
CREATE PROCEDURE blackstarDb.getBloomServiceType(applicantAreaIdParam INTEGER)
BEGIN
SELECT _ID as id ,NAME AS label, responseTime FROM bloomServiceType
WHERE _ID != -1
AND applicantAreaId = applicantAreaIdParam
ORDER BY _ID;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomOffice
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomOffice$$
CREATE PROCEDURE blackstarDb.getBloomOffice()
BEGIN
SELECT officeId as id, officeName AS label from office
WHERE officeId != '?'
ORDER BY officeId;
END$$


-- -----------------------------------------------------------------------------
        -- blackstarDb.GetUserData
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserData$$
CREATE PROCEDURE blackstarDb.GetUserData(pEmail VARCHAR(100))
BEGIN

        SELECT u.email AS userEmail, u.name AS userName, u.blackstarUserId , g.name AS groupName
        FROM blackstarUser_userGroup ug
                INNER JOIN blackstarUser u ON u.blackstarUserId = ug.blackstarUserId
                LEFT OUTER JOIN userGroup g ON g.userGroupId = ug.userGroupId
        WHERE u.email = pEmail;
        
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextInternalTicketNumber
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextInternalTicketNumber$$
CREATE PROCEDURE blackstarDb.GetNextInternalTicketNumber()
BEGIN

	DECLARE newNumber INTEGER;

	-- Obteniendo el numero de folio
	CALL blackstarDb.GetNextServiceOrderNumber('I', newNumber);

	-- Regresando el numero de folio completo
	SELECT CONCAT('SAC', cast(newNumber AS CHAR(50))) AS ServiceNumber;
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddInternalTicket   SE MODIFICO PARA LA FASE 2
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddInternalTicket$$
CREATE PROCEDURE blackstarDb.AddInternalTicket (  

  applicantUserId Int(11),
  officeId Char(1),
  serviceTypeId Int(3),
  statusId Int(11),
  applicantAreaId Int(11),
  dueDate Date,
  project Varchar(50),
  ticketNumber Varchar(15),
  description Text,
  created Datetime,
  createdBy Varchar(50),
  createdByUsr VARCHAR(50),
  reponseInTime Tinyint,
	purposeVisitVL Varchar(2500),
	purposeVisitVISAS Varchar(2500),
	draftCopyDiagramVED Varchar(2500),
	formProjectVED Varchar(2500),
	observationsVEPI Varchar(2500),
	draftCopyPlanVEPI Varchar(2500),
	formProjectVEPI Varchar(2500),
	observationsVRCC Varchar(2500),
	checkListVRCC Varchar(2500),
	formProjectVRCC Varchar(2500),
	questionVPT Varchar(2500),
	observationsVSA Varchar(2500),
	formProjectVSA Varchar(2500),
	productInformationVSP Varchar(2500),
	observationsISED Varchar(2500),
	draftCopyPlanISED Varchar(2500),
	observationsISRC Varchar(2500),
	attachmentsISRC Varchar(2500),
	apparatusTraceISSM Varchar(2500),
	observationsISSM Varchar(2500),
	questionISSM Varchar(2500),
	ticketISRPR Varchar(2500),
	modelPartISRPR Varchar(2500),
	observationsISRPR Varchar(2500),
	productInformationISSPC Varchar(2500),
	positionPGCAS Varchar(2500),
	collaboratorPGCAS Varchar(2500),
	justificationPGCAS Varchar(2500),
	salaryPGCAS Varchar(2500),
	positionPGCCP Varchar(2500),
	commentsPGCCP Varchar(2500),
	developmentPlanPGCCP Varchar(2500),
	targetPGCCP Varchar(2500),
	salaryPGCCP Varchar(2500),
	positionPGCNC Varchar(2500),
	developmentPlanPGCNC Varchar(2500),
	targetPGCNC Varchar(2500),
	salaryPGCNC Varchar(2500),
	justificationPGCNC Varchar(2500),
	positionPGCF Varchar(2500),
	collaboratorPGCF Varchar(2500),
	justificationPGCF Varchar(2500),
	positionPGCAA Varchar(2500),
	collaboratorPGCAA Varchar(2500),
	justificationPGCAA Varchar(2500),
	requisitionFormatGRC Varchar(2500),
	linkDocumentGM Varchar(2500),
	suggestionGSM Varchar(2500),
	documentCodeGSM Varchar(2500),
	justificationGSM Varchar(2500),
	problemDescriptionGPTR Varchar(2500),
  desiredDate DATETIME
  )
BEGIN
	INSERT INTO bloomTicket
(applicantUserId,officeId,serviceTypeId,statusId,
applicantAreaId,dueDate,project,ticketNumber,
description,created,createdBy,createdByUsr,reponseInTime,
purposeVisitVL,purposeVisitVISAS,draftCopyDiagramVED,formProjectVED,observationsVEPI,
draftCopyPlanVEPI,formProjectVEPI,observationsVRCC,checkListVRCC,formProjectVRCC,
questionVPT,observationsVSA,formProjectVSA,productInformationVSP,observationsISED,
draftCopyPlanISED,observationsISRC,attachmentsISRC,apparatusTraceISSM,observationsISSM,
questionISSM,ticketISRPR,modelPartISRPR,observationsISRPR,productInformationISSPC,
positionPGCAS,collaboratorPGCAS,justificationPGCAS,salaryPGCAS,positionPGCCP,
commentsPGCCP,developmentPlanPGCCP,targetPGCCP,salaryPGCCP,positionPGCNC,
developmentPlanPGCNC,targetPGCNC,salaryPGCNC,justificationPGCNC,positionPGCF,
collaboratorPGCF,justificationPGCF,positionPGCAA,collaboratorPGCAA,justificationPGCAA,
requisitionFormatGRC,linkDocumentGM,suggestionGSM,documentCodeGSM,justificationGSM,
problemDescriptionGPTR, desiredDate)
VALUES
(applicantUserId,officeId,serviceTypeId,statusId,
applicantAreaId,dueDate,project,ticketNumber,
description,created,createdBy,createdByUsr,reponseInTime,
purposeVisitVL,purposeVisitVISAS,draftCopyDiagramVED,formProjectVED,observationsVEPI,
draftCopyPlanVEPI,formProjectVEPI,observationsVRCC,checkListVRCC,formProjectVRCC,
questionVPT,observationsVSA,formProjectVSA,productInformationVSP,observationsISED,
draftCopyPlanISED,observationsISRC,attachmentsISRC,apparatusTraceISSM,observationsISSM,
questionISSM,ticketISRPR,modelPartISRPR,observationsISRPR,productInformationISSPC,
positionPGCAS,collaboratorPGCAS,justificationPGCAS,salaryPGCAS,positionPGCCP,
commentsPGCCP,developmentPlanPGCCP,targetPGCCP,salaryPGCCP,positionPGCNC,
developmentPlanPGCNC,targetPGCNC,salaryPGCNC,justificationPGCNC,positionPGCF,
collaboratorPGCF,justificationPGCF,positionPGCAA,collaboratorPGCAA,justificationPGCAA,
requisitionFormatGRC,linkDocumentGM,suggestionGSM,documentCodeGSM,justificationGSM,
problemDescriptionGPTR, desiredDate);
select LAST_INSERT_ID();
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomEstatusTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomEstatusTickets$$
CREATE PROCEDURE blackstarDb.getBloomEstatusTickets()
BEGIN
SELECT _ID as id ,NAME AS label FROM bloomStatusType
WHERE _ID != -1
ORDER BY _ID;
END$$



-- -----------------------------------------------------------------------------
  -- blackstarDb.ClosebloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.ClosebloomTicket$$
CREATE PROCEDURE blackstarDb.`ClosebloomTicket`(pTicketId INTEGER, pUserId INTEGER, pStatusId INTEGER)
BEGIN

  SET @today := (CONVERT_TZ(now(),'+00:00','-5:00'));

  UPDATE blackstarDb.bloomTicket t
    INNER JOIN blackstarDb.bloomServiceType ty ON t.serviceTypeId = ty._id
  SET
    statusId = pStatusId,
    reponseInTime = if(ty.responseTime < (TO_DAYS(@today) - TO_DAYS(t.created)), 0, 1),
    resolvedOnTime = if(ty.responseTime < (TO_DAYS(@today) - TO_DAYS(t.created)), 0, 1),
    desviation = ((TO_DAYS(@today) - TO_DAYS(t.created)) - ty.responseTime),
    responseDate = @today,
    t.modified = now(),
    t.modifiedBy = 'ClosebloomTicket',
    t.modifiedByUsr = (SELECT email FROM blackstarUser WHERE blackstarUserId = pUserId)
  WHERE t._id = pTicketId;

END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketByUserKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByUserKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByUserKPI`()
BEGIN

SELECT 
  bu.name name, 
  bu.email email, 
  count(*) counter
FROM bloomTicket bt, blackstarUser bu, bloomApplicantArea aa
WHERE bt.applicantUserId = bu.blackstarUserId
      AND bt.applicantAreaId = aa._id
GROUP BY bt.applicantUserId
ORDER BY counter desc;

END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketByOfficeKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByOfficeKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByOfficeKPI`()
BEGIN

SELECT of.officeName officeName, count(*) counter
FROM bloomTicket bt, office of
WHERE bt.officeId = of.officeId
GROUP BY bt.officeId
ORDER BY counter desc;

END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketByAreaKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByAreaKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByAreaKPI`()
BEGIN
SELECT aa.name applicantArea, count(*) counter
FROM bloomTicket bt, bloomApplicantArea aa
WHERE  bt.applicantAreaId = aa._id
GROUP BY bt.applicantAreaId
ORDER BY counter desc;
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketByDayKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByDayKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByDayKPI`()
BEGIN

  SELECT 
    DATE(created) AS created,
    DATE_FORMAT(created,'%d/%m/%Y') createdStr, 
    count(*) counter
  FROM bloomTicket
GROUP BY DATE(created)
ORDER BY created;
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketByProjectKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByProjectKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByProjectKPI`()
BEGIN
SELECT bt.project project, count(*) counter
FROM bloomTicket bt
WHERE bt.project IS NOT NULL
      AND bt.project <> ''
      AND bt.project <> 'NA'
      AND bt.project <> 'N/A'
GROUP BY bt.project
ORDER BY counter DESC
LIMIT 5;
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketByServiceAreaKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByServiceAreaKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByServiceAreaKPI`()
BEGIN
SELECT aa.bloomServiceArea applicantArea, count(*) counter
FROM bloomTicket bt, bloomServiceArea aa, bloomServiceType st
WHERE bt.serviceTypeId = st._id
      AND st.bloomServiceAreaId = aa.bloomServiceAreaId
GROUP BY st.bloomServiceAreaId;
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketDeliverable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketDeliverable$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketDeliverable`(pTicketId INTEGER)
BEGIN

  SELECT 
    bdt._id id, 
    bd.name name, 
    IF(bd._id IS NOT NULL, true, false) AS delivered,
    bd.docId docId
  FROM bloomTicket bt
    INNER JOIN bloomDeliverableType bdt ON bt.serviceTypeId = bdt.serviceTypeId
    LEFT OUTER JOIN  bloomDeliverableTrace bd ON bd.bloomTicketId = bt._id AND bd.deliverableTypeId = bdt._id
  WHERE bt._id = pTicketId;

END$$ 


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomSurveyTable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomSurveyTable$$
CREATE PROCEDURE blackstarDb.`GetbloomSurveyTable`(userId INTEGER)
BEGIN
  SELECT 
    bs._id id, 
    bt.ticketNumber ticketNumber, 
    baa.name applicantArea, 
    bt.project project, 
    bs.created created, 
    bs.evaluation evaluation
  FROM bloomSurvey bs
    INNER JOIN bloomTicket bt ON bloomTicketId = bt._id
    INNER JOIN bloomTicketTeam btt ON btt.ticketId = bt._id
    INNER JOIN blackstarUser bu ON bu.blackstarUserId = btt.blackstarUserId
    INNER JOIN bloomApplicantArea baa ON bt.applicantAreaId = baa._id
  WHERE 
    btt.blackstarUserId = userId
    AND workerRoleTypeId = 1;
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetBloomPendingSurveyTable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomPendingSurveyTable$$
CREATE PROCEDURE blackstarDb.`GetBloomPendingSurveyTable`(userId INTEGER)
BEGIN
SELECT DISTINCT 
  bt.ticketNumber ticketNumber, 
  baa.name applicantArea, 
  bt.project project,
  GROUP_CONCAT(DISTINCT bu.name ORDER BY bu.name SEPARATOR ', ') AS risponsableName,
  bt.createdByUsr as createdByUsr
FROM bloomTicket bt
  INNER JOIN bloomApplicantArea baa ON bt.applicantAreaId = baa._id
  INNER JOIN bloomTicketTeam btt ON btt.ticketId = bt._id
  INNER JOIN blackstarUser bu ON btt.blackstarUserId = bu.blackstarUserId
  INNER JOIN blackstarUser bu2 ON bu2.email = bt.createdByUsr
  LEFT OUTER JOIN bloomSurvey bs ON bs.bloomTicketId = bt._id
WHERE bu2.blackstarUserId = userId
      AND btt.workerRoleTypeId = 1
      AND bs._id IS NULL
GROUP BY bt._id;
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.InsertbloomSurvey
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.InsertbloomSurvey$$
CREATE PROCEDURE blackstarDb.`InsertbloomSurvey`(pTicketId INTEGER, pEvaluation INTEGER, pComments TEXT, pCreated DATE)
BEGIN
  INSERT INTO bloomSurvey (bloomTicketId, evaluation, comments, created ) 
  VALUES(pTicketId, pEvaluation, pComments, pCreated);
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetBloomPendingSurveys
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomPendingSurveys$$
CREATE PROCEDURE blackstarDb.`GetBloomPendingSurveys`()
BEGIN

SELECT bt._id id, bt.ticketNumber ticketNumber, bt.description description,
       bt.responseDate responseDate, bu.email email, bu.name name
FROM bloomTicket bt, blackstarUser bu
WHERE bt.statusId = 6
     AND bt.applicantUserId = bu.blackstarUserId
     AND bt.responseDate < DATE_ADD(CONVERT_TZ(now(),'+00:00','-5:00'), INTERVAL -2 DAY);
END$$ 



-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomSupportAreasWithTickets
	-- list of areas with Tickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomSupportAreasWithTickets$$
CREATE PROCEDURE blackstarDb.GetBloomSupportAreasWithTickets(startCreationDate Datetime,endCreationDate Datetime)
BEGIN
	SELECT ug.userGroupId,ug.name FROM followUp f
					INNER JOIN blackstarUser bu ON (f.asignee=bu.email)
					INNER JOIN blackstarUser_userGroup bug ON (bu.blackstarUserId=bug.blackstarUserId)
					INNER JOIN userGroup ug ON (ug.userGroupId=bug.userGroupId)
					INNER JOIN bloomTicket t ON (t._id=f.bloomTicketId)
					INNER JOIN bloomTicketTeam tt ON (tt.ticketId = f.bloomTicketId and tt.blackstarUserId=bu.blackstarUserId) -- que el follow exista en bloomTicketTeam
					WHERE f.bloomTicketId IS NOT NULL
					AND t.statusId IN(5,6)
					AND bu.email <> t.createdByUsr -- que no sea el creador
					AND t.created>= startCreationDate
					AND t.created <= endCreationDate
					GROUP BY ug.userGroupId;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomStatisticsByAreaSupport
	-- Statistics by area support
	-- average, maximum and minimum from time attention	
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomStatisticsByAreaSupport$$
CREATE PROCEDURE blackstarDb.GetBloomStatisticsByAreaSupport(startCreationDate DATETIME, endCreationDate DATETIME)
BEGIN
  SELECT
     bloomServiceArea as area,
     count(*) as total,
     min(respTime) as minRespTime,
     round(avg(respTime), 0) as avgRespTime,
     max(respTime) as maxRespTime,
     sum(onTime) as onTime,
     sum(outTime) as outTime,
     sum(ok) as ok,
     sum(notOk) as notOk
  FROM(
    SELECT 
      a.bloomServiceAreaId, 
      bloomServiceArea, 
      t.created, 
      t.responseDate, 
      @respTime:=TIMESTAMPDIFF(HOUR, if(t.created < t.responseDate, t.created, t.responseDate), t.responseDate) as respTime, 
      if(@respTime <= (responseTime * 24), 1, 0) as onTime, 
      if(@respTime > (responseTime * 24), 1, 0) as outTime, 
      if(ifnull(s.evaluation, 1) > 0, 1, 0) as ok,
      if(s.evaluation < 1, 1, 0) as notOk
    FROM bloomTicket t
      INNER JOIN bloomServiceType y ON y._id = t.serviceTypeId
      INNER JOIN bloomServiceArea a ON y.bloomServiceAreaId = a.bloomServiceAreaId
      LEFT OUTER JOIN bloomSurvey s ON t._id = s.bloomTicketId
    WHERE t.statusId IN(5,6)
      AND responseDate IS NOT NULL
      AND t.created >= startCreationDate
      AND t.created <= endCreationDate
  ) a
  GROUP BY a.bloomServiceArea;

END$$

	 
	 
-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomPercentageTimeClosedTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomPercentageTimeClosedTickets$$
CREATE PROCEDURE blackstarDb.GetBloomPercentageTimeClosedTickets(startCreationDate Datetime,endCreationDate Datetime)
BEGIN


	DECLARE satisfactoryPercentage DECIMAL(8,2) DEFAULT 0;
	DECLARE unsatisfactoryPercentage DECIMAL(8,2) DEFAULT 0;
	DECLARE noTicketsSatisfactory INT DEFAULT 0;
	DECLARE noTicketsUnsatisfactory INT DEFAULT 0;
	DECLARE noTicketsTotal INT DEFAULT 0;



	SET noTicketsSatisfactory = (select count(id) from (
		select t._id as id, t.created ,t.dueDate,t.responseDate,date(t.responseDate),t.statusId from bloomTicket t
		WHERE t.statusId IN(5,6) -- tickets cerrados y resueltos
		AND t.created>= startCreationDate
		AND t.created <= endCreationDate
		and date(t.responseDate) <= t.dueDate) as satisfactory);

	SET noTicketsUnsatisfactory = (select count(id) from (
		select t._id as id, t.created ,t.dueDate,t.responseDate,date(t.responseDate),t.statusId from bloomTicket t
		WHERE t.statusId IN(5,6) -- tickets cerrados y resueltos
		AND t.created>= startCreationDate
		AND t.created <= endCreationDate
		and date(t.responseDate) > t.dueDate) as unatisfactory);

	SET noTicketsTotal=noTicketsSatisfactory+noTicketsUnsatisfactory;

	SET satisfactoryPercentage = (100/noTicketsTotal)*noTicketsSatisfactory;
	SET unsatisfactoryPercentage = (100/noTicketsTotal)*noTicketsUnsatisfactory;

	select satisfactoryPercentage,unsatisfactoryPercentage;


END$$
	 
	 
-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomPercentageEvaluationTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomPercentageEvaluationTickets$$
CREATE PROCEDURE blackstarDb.GetBloomPercentageEvaluationTickets(initEvaluationValue INT,startCreationDate Datetime,endCreationDate Datetime)
BEGIN


	DECLARE satisfactoryPercentage DECIMAL(8,2) DEFAULT 0;
	DECLARE unsatisfactoryPercentage DECIMAL(8,2) DEFAULT 0;
	DECLARE noTicketsEvaluationSatisfactory INT DEFAULT 0;
	DECLARE noTicketsEvaluationUnsatisfactory INT DEFAULT 0;
	DECLARE noTicketsTotal INT DEFAULT 0;


	SET noTicketsEvaluationSatisfactory = (select count(id) from (
		select t._id as id, t.evaluation, t.created ,t.dueDate,t.responseDate,date(t.responseDate),t.statusId from bloomTicket t
		WHERE t.evaluation>=initEvaluationValue
		AND t.statusId IN(5,6) -- tickets cerrados y resueltos
		AND t.created>= startCreationDate
		AND t.created <= endCreationDate
		) as evaluation);

	SET noTicketsEvaluationUnsatisfactory = (select count(id) from (
		select t._id as id, t.evaluation, t.created ,t.dueDate,t.responseDate,date(t.responseDate),t.statusId from bloomTicket t
		WHERE t.evaluation<initEvaluationValue
		AND t.statusId IN(5,6) -- tickets cerrados y resueltos
		AND t.created>= startCreationDate
		AND t.created <= endCreationDate
		) as evaluation);

	SET noTicketsTotal=noTicketsEvaluationSatisfactory+noTicketsEvaluationUnsatisfactory;

	SET satisfactoryPercentage = (100/noTicketsTotal)*noTicketsEvaluationSatisfactory;
	SET unsatisfactoryPercentage = (100/noTicketsTotal)*noTicketsEvaluationUnsatisfactory;

	select satisfactoryPercentage,unsatisfactoryPercentage;


END$$	 


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomNumberTicketsByArea
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomNumberTicketsByArea$$
CREATE PROCEDURE blackstarDb.GetBloomNumberTicketsByArea(startCreationDate Datetime,endCreationDate Datetime)
BEGIN

	SELECT userGroup, COUNT(ticketId) noTickets FROM(
		SELECT f.bloomTicketId AS ticketId, ug.name AS userGroup FROM followUp f
						INNER JOIN blackstarUser bu ON (f.asignee=bu.email)
						INNER JOIN blackstarUser_userGroup bug ON (bu.blackstarUserId=bug.blackstarUserId)
						INNER JOIN userGroup ug ON (ug.userGroupId=bug.userGroupId)
						INNER JOIN bloomTicket t ON (t._id=f.bloomTicketId)
						WHERE f.bloomTicketId IS NOT NULL
						AND t.statusId IN(5,6) -- tickets cerrados y resueltos
						AND t.created>= startCreationDate
						AND t.created <= endCreationDate
						AND bu.email <> t.createdByUsr -- que no sea el creador
						GROUP BY f.bloomTicketId
	) AS ticketsByArea
	GROUP BY userGroup;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomUnsatisfactoryTicketsByUserByArea
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomUnsatisfactoryTicketsByUserByArea$$
CREATE PROCEDURE blackstarDb.GetBloomUnsatisfactoryTicketsByUserByArea(startDate Datetime, endDate Datetime)

BEGIN

	SELECT 
    u.blackstarUserId,
    u.name as name,
    sum(if(s.evaluation < 1, 1, 0)) as notOk,
    count(*) as total,
    round(sum(if(s.evaluation < 1, 1, 0))*100/count(*), 1) as ratio
  FROM bloomSurvey s
    INNER JOIN bloomTicket t ON t._id = s.bloomTicketId
    INNER JOIN bloomTicketTeam tt ON tt.ticketId = t._id
    INNER JOIN blackstarUser u ON u.blackstarUserId = tt.blackstarUserId
  WHERE tt.workerRoleTypeId = 2
    AND userGroup != 'creator' 
  GROUP BY u.blackstarUserId, u.name
  ORDER BY notOk DESC;

END$$



-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomHistoricalTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomHistoricalTickets$$
CREATE PROCEDURE blackstarDb.GetBloomHistoricalTickets(statusTicket INT, startCreationDate DATETIME, endCreationDate DATETIME, showHidden INT, pUser VARCHAR(100))
BEGIN

  IF(statusTicket < 0) THEN
    SELECT 
      ti._id AS id, 
      ti.ticketNumber, 
      ti.created AS created,
      bu.name AS createdUserName,
      ti.applicantAreaId, 
      ba.name AS areaName, 
      ti.serviceTypeId, 
      st.name AS serviceName, 
      st.responseTime, 
      ti.project, 
      ti.officeId, 
      o.officeName,
      ti.statusId, 
      s.name AS statusTicket,
      ti.dueDate AS dueDate,
      ti.desiredDate AS desiredDate,
      a.bloomServiceArea AS serviceArea,
      ti.responseDate as responseDate
    FROM bloomTicket ti 
      INNER JOIN bloomApplicantArea ba on (ba._id = ti.applicantAreaId) 
      INNER JOIN bloomServiceType st on (st._id = ti.serviceTypeId) 
      INNER JOIN office o on (o.officeId = ti.officeId) 
      INNER JOIN bloomStatusType s on (s._id = ti.statusId)
      INNER JOIN bloomServiceArea a ON st.bloomServiceAreaId = a.bloomServiceAreaId 
      INNER JOIN blackstarUser bu ON ti.createdByUsr = bu.email
    WHERE ti.created >= startCreationDate -- AND ti.created <= endCreationDate
      AND (IFNULL(st.hidden, 0) <= showHidden  OR ti.createdBy = pUser)
    ORDER BY ti.created DESC;
  ELSE
    IF (statusTicket = 0) THEN
      SELECT 
        ti._id AS id, 
        ti.ticketNumber, 
        ti.created AS created,
        bu.name AS createdUserName,
        ti.applicantAreaId, 
        ba.name AS areaName, 
        ti.serviceTypeId, 
        st.name AS serviceName, 
        st.responseTime, 
        ti.project, 
        ti.officeId, 
        o.officeName,
        ti.statusId, 
        s.name AS statusTicket,
        ti.dueDate AS dueDate,
        ti.desiredDate AS desiredDate,
        a.bloomServiceArea AS serviceArea,
      ti.responseDate as responseDate
      FROM bloomTicket ti 
        INNER JOIN bloomApplicantArea ba on (ba._id = ti.applicantAreaId) 
        INNER JOIN bloomServiceType st on (st._id = ti.serviceTypeId) 
        INNER JOIN office o on (o.officeId = ti.officeId) 
        INNER JOIN bloomStatusType s on (s._id = ti.statusId) 
        INNER JOIN bloomServiceArea a ON st.bloomServiceAreaId = a.bloomServiceAreaId 
        INNER JOIN blackstarUser bu ON ti.createdByUsr = bu.email
      WHERE ti.created >= startCreationDate -- AND ti.created <= endCreationDate
        AND (IFNULL(st.hidden, 0) <= showHidden  OR ti.createdBy = pUser)
        AND ti.statusId IN(1,3)
      ORDER BY ti.created DESC;
    ELSE
      SELECT 
        ti._id AS id, 
        ti.ticketNumber, 
        ti.created AS created,
        bu.name AS createdUserName,
        ti.applicantAreaId, 
        ba.name AS areaName, 
        ti.serviceTypeId, 
        st.name AS serviceName, 
        st.responseTime, 
        ti.project, 
        ti.officeId, 
        o.officeName,
        ti.statusId, 
        s.name AS statusTicket,
        ti.dueDate AS dueDate,
        ti.desiredDate AS desiredDate,
        a.bloomServiceArea AS serviceArea,
        ti.responseDate as responseDate
      FROM bloomTicket ti 
        INNER JOIN bloomApplicantArea ba on (ba._id = ti.applicantAreaId) 
        INNER JOIN bloomServiceType st on (st._id = ti.serviceTypeId) 
        INNER JOIN office o on (o.officeId = ti.officeId) 
        INNER JOIN bloomStatusType s on (s._id = ti.statusId) 
        INNER JOIN bloomServiceArea a ON st.bloomServiceAreaId = a.bloomServiceAreaId 
        INNER JOIN blackstarUser bu ON ti.createdByUsr = bu.email
      WHERE ti.created >= startCreationDate -- AND ti.created <= endCreationDate
        AND (IFNULL(st.hidden, 0) <= showHidden  OR ti.createdBy = pUser)
        AND ti.statusId = statusTicket
      ORDER BY ti.created DESC;
    END IF;
  END IF;

END$$

-- ---------------------------------------------------------------------------------------------------------------------------------------------
	-- FASE DOS DE TICKETS INTERNOS CAMBIO D ESQUEMA A MANEJO DE 4 CORDIANDORES DONDE SE INCLUYE MESA DE AYUDA.
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomAdvisedUsers
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomAdvisedUsers$$
CREATE PROCEDURE blackstarDb.getBloomAdvisedUsers(applicantAreaIdParam INTEGER,serviceTypeIdParam INTEGER)
BEGIN

SELECT DISTINCT 
    u.blackstarUserId as id,
    u.name name,
    u.email email,
    workerRoleTypeId workerRoleTypeId,
    ag.userGroup 
FROM blackstarUser u
  INNER JOIN blackstarUser_userGroup ug on (u.blackstarUserId=ug.blackstarUserId)
  INNER JOIN userGroup g on (g.userGroupId=ug.userGroupId)
  INNER JOIN bloomAdvisedGroup ag on (ag.userGroup=g.externalId)
WHERE ag.applicantAreaId=applicantAreaIdParam
  AND ag.serviceTypeId=serviceTypeIdParam;
	
END$$

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


-- ---------------------------------------------------------------------------
-- Desc:	Cambia el esquema de la bd
-- Auth:	SAG
-- Date:	25/03/2015
-- ---------------------------------------------------------------------------
-- Change History
-- ---------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- ---------------------------------------------------------------------------
-- 1	25/03/2015	SAG 	Version Inicial
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.upgradeCodexSchema$$
CREATE PROCEDURE blackstarDb.upgradeCodexSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

-- AGREGANDO COLUMNA codexProjectId a followUp
IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'followUp' AND COLUMN_NAME = 'codexProjectId') = 0  THEN
	ALTER TABLE blackstarDb.followUp ADD codexProjectId INT(11) NULL;
	ALTER TABLE blackstarDb.followUp ADD CONSTRAINT R121 FOREIGN KEY (codexProjectId) REFERENCES codexProject (_id);
END IF;  

-- AGREGANDO COLUMNA description a sequence
IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'sequence' AND COLUMN_NAME = 'description') = 0  THEN
	ALTER TABLE sequence ADD description VARCHAR(200) NULL;
END IF;
-- -----------------------------------------------------------------------------
-- FIN SECCION DE CAMBIOS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDb.upgradeCodexSchema();

DROP PROCEDURE blackstarDb.upgradeCodexSchema;

-- ----------------------------------------------------------------------------- 
-- Name:	codexDb_StoredProcedures
-- Desc:	Crea o actualiza los Stored procedures operativos de la aplicacion
-- Auth:	Daniel Castillo B
-- Date:	24/06/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date        Author	 Description
-- --   --------   -------  ------------------------------------
-- 11 12/03/2015  SAG   Se crea:
--                              blackstarDb.UpsertCodexProjectEntryType
--                      Se modifica:
--                              blackstarDb....KPI
-- -----------------------------------------------------------------------------
use blackstarDb;

DELIMITER $$


-- -----------------------------------------------------------------------------
  -- blackstarDb.UpsertCodexProjectEntryType
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertCodexProjectEntryType$$
CREATE PROCEDURE blackstarDb.UpsertCodexProjectEntryType(pTypeId INT, pName VARCHAR(200), pProductType CHAR(1), pActive INT)
BEGIN
   
    IF(SELECT count(*) FROM codexProjectEntryTypes WHERE _id = pTypeId) = 0 THEN
        INSERT INTO codexProjectEntryTypes(_id, name, productType, active)
        SELECT pTypeId, pName, pProductType, pActive;
    ELSE
        UPDATE codexProjectEntryTypes SET
            name = pName,
            productType = pProductType,
            active = pActive
        WHERE _id = pTypeId;
    END IF;

END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getSalesCallRecords
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getSalesCallRecords$$
CREATE PROCEDURE blackstarDb.getSalesCallRecords(startDate DATETIME, endDate DATETIME, cstEmail VARCHAR(500))
BEGIN
  
  SELECT c.name AS cst,
    s.month AS month,
    s.year AS year,
    count(s.codexSalesCallId) AS callCount
  FROM cst c
    LEFT OUTER JOIN codexSalesCall s ON s.cstId = c.cstId
  WHERE if(cstEmail = '', 1=1, c.email = cstEmail)
    AND callDate >= startDate 
    AND callDate <= endDate
  GROUP BY c.name, s.month, s.year;

END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.RecordSalesCall
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.RecordSalesCall$$
CREATE PROCEDURE blackstarDb.RecordSalesCall(cstEmail VARCHAR(500), callDate DATETIME)
BEGIN
  
  INSERT INTO codexSalesCall(cstId, month, year, callDate)
  SELECT cstId, month(callDate), year(callDate), callDate FROM cst
  WHERE email = cstEmail;

END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getAutocompleteClientList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getAutocompleteClientList$$
CREATE PROCEDURE blackstarDb.getAutocompleteClientList()
BEGIN

  SELECT 
    _id AS value,
    corporateName AS label
  FROM codexClient
  ORDER BY corporateName;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexInvoicingKpi
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexInvoicingKpi$$
CREATE PROCEDURE blackstarDb.getCodexInvoicingKpi(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN

    SELECT
        c.name AS cstName,
        sum(p.totalProjectNumber) AS amount,
        if(originId = 0, 'Todos', o.name) AS origin,
        if(yearQuota = 0, 'No disponible', CONVERT((sum(p.totalProjectNumber) / yearQuota) * 100, CHAR)) AS coverage
    FROM codexProject p
        INNER JOIN blackstarUser u ON p.createdByUsr = u.blackstarUserId
        INNER JOIN cst c ON u.email = c.email
        INNER JOIN codexClient cl ON cl._id = p.clientId
        INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
    WHERE p.created >= startDate
        AND p.created <= endDate
        AND if(originId = 0, 1=1, cl.clientOriginId = originId)
        AND p.statusId > 4
        AND if(cst='',1=1,u.email = cst)
    GROUP BY c.name, o.name
    ORDER BY c.name;
  
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexEffectiveness
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexEffectiveness$$
CREATE PROCEDURE blackstarDb.getCodexEffectiveness(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN
  
  DROP TABLE IF EXISTS cstProjects;
  CREATE TEMPORARY TABLE cstProjects(cstEmail VARCHAR(200), origin VARCHAR(300), projectCount INT, soldCount INT);

  INSERT INTO cstProjects(cstEmail, origin, projectCount, soldCount)
  SELECT 
    u.email,
    if(originId = 0, 'Todos', o.name), 
    count(*),
    0
  FROM codexProject p
    INNER JOIN blackstarUser u ON p.createdByUsr = u.blackstarUserId
    INNER JOIN codexClient cl ON p.clientId = cl._id
    INNER JOIN codexClientOrigin o ON cl.clientOriginId = o._id
  WHERE p.created >= startDate
      AND p.created <= endDate
      AND if(cst = '', 1 = 1, u.email = cst)
      AND if(originId = 0, 1 = 1, cl.clientOriginId = originId)
      AND p.statusId >= 4
  GROUP BY createdByUsr;

  UPDATE cstProjects SET
    soldCount = (
      SELECT count(*) FROM codexProject p
        INNER JOIN blackstarUser u ON p.createdByUsr = u.blackstarUserId
        INNER JOIN codexClient cl ON p.clientId = cl._id
      WHERE u.email = cstEmail
        AND p.created >= startDate
        AND p.created <= endDate
        AND if(originId = 0, 1 = 1, cl.clientOriginId = originId)
        AND p.statusId > 4 AND p.statusId < 8);

  SELECT
    c.name AS cstName,
    origin AS origin,
    (soldCount/projectCount) * 100 AS effectiveness
  FROM cstProjects p
    INNER JOIN cst c ON p.cstEmail = c.email
  ORDER BY c.name;

  DROP TABLE cstProjects;
  
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexProposals
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexProposals$$
CREATE PROCEDURE blackstarDb.getCodexProposals(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN

  SELECT
    c.name AS cstName,
    if(originId = 0, 'Todos', o.name) AS origin,
    count(*) as count,
    sum(totalProjectNumber) AS amount
  FROM codexProject p
    INNER JOIN blackstarUser u ON p.createdByUsr = u.blackstarUserId
    INNER JOIN cst c ON u.email = c.email
    INNER JOIN codexClient cl ON p.clientId = cl._id
    INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
    INNER JOIN codexStatusType s ON p.statusId = s._id
  WHERE p.created >= startDate
    AND p.created <= endDate
    AND if(cst = '', 1 = 1, u.email = cst)
    AND if(originId = 0, 1 = 1, cl.clientOriginId = originId) 
    AND p.statusId > 3
  GROUP BY c.name
  ORDER BY c.name;

  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexProjectsByStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexProjectsByStatus$$
CREATE PROCEDURE blackstarDb.getCodexProjectsByStatus(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN

  SET @projectCount = (
    SELECT count(*) 
    FROM codexProject p
    INNER JOIN blackstarUser u ON p.createdByUsr = u.blackstarUserId
    INNER JOIN cst c ON u.email = c.email
    INNER JOIN codexClient cl ON p.clientId = cl._id
    INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
    INNER JOIN codexStatusType s ON p.statusId = s._id
  WHERE p.created >= startDate
    AND p.created <= endDate
    AND if(cst = '', 1 = 1, u.email = cst)
    AND if(originId = 0, 1 = 1, cl.clientOriginId = originId));

  SELECT
    if(cst = '' , 'Todos', c.name) AS cstName,
    if(originId = 0, 'Todos', o.name) AS origin,
    s.name AS status,
    count(*) AS count,
    (count(*) / @projectCount) * 100 AS contribution
  FROM codexProject p
    INNER JOIN blackstarUser u ON p.createdByUsr = u.blackstarUserId
    INNER JOIN cst c ON u.email = c.email
    INNER JOIN codexClient cl ON p.clientId = cl._id
    INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
    INNER JOIN codexStatusType s ON p.statusId = s._id
  WHERE p.created >= startDate
    AND p.created <= endDate
    AND if(cst = '', 1 = 1, u.email = cst)
    AND if(originId = 0, 1 = 1, cl.clientOriginId = originId) 
  GROUP BY s.name
  ORDER BY p.statusId;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexProjectsByOrigin
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexProjectsByOrigin$$
CREATE PROCEDURE blackstarDb.getCodexProjectsByOrigin(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN

  SET @projectTotal = (
    SELECT count(*)
    FROM codexProject p
    INNER JOIN blackstarUser u ON p.createdByUsr = u.blackstarUserId
    INNER JOIN codexClient cl ON p.clientId = cl._id
    INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
  WHERE p.created >= startDate
    AND p.created <= endDate
    AND if(cst = '', 1 = 1, u.email = cst)
    AND if(originId = 0, 1 = 1, cl.clientOriginId = originId));

  SELECT
    o.name AS origin,
    count(*) AS count,
    (count(*) / @projectTotal) * 100 AS contribution
  FROM codexProject p
    INNER JOIN blackstarUser u ON p.createdByUsr = u.blackstarUserId
    INNER JOIN codexClient cl ON p.clientId = cl._id
    INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
  WHERE p.created >= startDate
    AND p.created <= endDate
    AND if(cst = '', 1 = 1, u.email = cst)
    AND if(originId = 0, 1 = 1, cl.clientOriginId = originId) 
  GROUP BY o.name;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexClientVisits
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexClientVisits$$
CREATE PROCEDURE blackstarDb.getCodexClientVisits(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN

  SELECT 
    c.name AS cstName,
    if(originId = 0, 'Todos', o.name) AS origin,
    count(*) AS count
  FROM codexVisit v 
    INNER JOIN cst c ON v.cstId = c.cstId
    LEFT OUTER JOIN codexClient cl ON cl._id = v.codexClientId
    LEFT OUTER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
  WHERE v.created >= startDate
    AND v.created <= endDate
    AND if(cst = '', 1 = 1, c.email = cst)
    AND if(originId = 0, 1 = 1, cl.clientOriginId = originId) 
    AND v.visitStatusId = 'R'
  GROUP BY c.name
  ORDER BY c.name;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexNewCustomers
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexNewCustomers$$
CREATE PROCEDURE blackstarDb.getCodexNewCustomers(startDate DATETIME, endDate DATETIME, cst VARCHAR(200))
BEGIN

  SELECT
    u.name AS cstName,
    count(*) AS count
  FROM codexClient c
    INNER JOIN cst u ON u.cstId = c.cstId
  WHERE turnedCustomerDate >= startDate 
    AND turnedCustomerDate <= endDate
    AND if(cst = '', 1 = 1, u.email = cst)
  GROUP BY u.name;
   
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexProductFamilies
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexProductFamilies$$
CREATE PROCEDURE blackstarDb.getCodexProductFamilies(startDate DATETIME, endDate DATETIME)
BEGIN

  SET @projectTotal = (
      SELECT sum(totalProjectNumber) 
      FROM codexProject p
        INNER JOIN codexProjectEntry e ON e.projectId = p._id
        INNER JOIN codexEntryItem i ON i.entryId = e._id
      WHERE p.created >= startDate AND p.created <= endDate);

  SELECT 
    f.productFamily,
    sum(totalProjectNumber) AS amount,
    (sum(totalProjectNumber) / @projectTotal) * 100 AS contribution
  FROM codexProject p
    INNER JOIN codexProjectEntry e ON e.projectId = p._id
    INNER JOIN codexEntryItem i ON i.entryId = e._id
    INNER JOIN codexPriceList l ON i.priceListId = l._id
    INNER JOIN codexProductFamily f ON f.codexProductFamilyId = l.codexProductFamilyId
  WHERE p.created >= startDate AND p.created <= endDate
  GROUP BY productFamily;

END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexComerceCodes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexComerceCodes$$
CREATE PROCEDURE blackstarDb.getCodexComerceCodes(startDate DATETIME, endDate DATETIME)
BEGIN

  SELECT
    t.name AS code,
    sum(e.totalPrice) AS amount
  FROM codexProject p
    INNER JOIN codexProjectEntry e ON e.projectId = p._id
    INNER JOIN codexEntryItem i ON i.entryId = e._id
    INNER JOIN codexProjectEntryTypes t ON t._id = e.entryTypeId
  WHERE p.created >= startDate AND p.created <= endDate
  GROUP BY t.name;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetVisitById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetVisitById$$
CREATE PROCEDURE blackstarDb.GetVisitById(pVisitId INT)
BEGIN

  SELECT 
      v.codexVisitId,
      v.cstId,
      ifnull(v.codexClientId, 0),
      v.visitDate,
      v.description,
      v.closure,
      v.visitStatusId,
      v.created,
      v.createdBy,
      v.createdByUsr,
      v.modified,
      v.modifiedBy,
      v.modifiedByUsr,
      c.name AS cstName,
      c.email AS cstEmail,
      v.customerName AS customerName,
      s.visitStatus
    FROM blackstarDb.codexVisit v
        INNER JOIN blackstarDb.cst c ON v.cstId = c.cstId
        INNER JOIN blackstarDb.codexVisitStatus s ON s.visitStatusId = v.visitStatusId
  WHERE codexVisitId = pVisitId;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetAllCst
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllCst$$
CREATE PROCEDURE blackstarDb.GetAllCst()
BEGIN

  SELECT * FROM blackstarDb.cst ORDER BY name;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetAllVisitStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetVisitList$$
CREATE PROCEDURE blackstarDb.GetVisitList(pcstEmail VARCHAR(100))
BEGIN

  SELECT 
      v.codexVisitId,
      v.cstId,
      v.codexClientId,
      v.visitDate,
      v.description,
      v.closure,
      v.visitStatusId,
      v.created,
      v.createdBy,
      v.createdByUsr,
      v.modified,
      v.modifiedBy,
      v.modifiedByUsr,
      c.name AS cstName,
      c.email AS cstEmail,
      v.customerName,
      s.visitStatus
    FROM blackstarDb.codexVisit v
        INNER JOIN blackstarDb.cst c ON v.cstId = c.cstId
        INNER JOIN blackstarDb.codexVisitStatus s ON s.visitStatusId = v.visitStatusId
    WHERE v.visitStatusId != 'D'
  AND if(ifnull(pcstEmail, '') != '', c.email = pcstEmail, 1=1 )
  ORDER BY visitStatus, visitDate;

  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetAllVisitStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllVisitStatus$$
CREATE PROCEDURE blackstarDb.GetAllVisitStatus()
BEGIN

  SELECT visitStatusId, visitStatus FROM blackstarDb.codexVisitStatus;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.UpsertCodexVisit
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertCodexVisit$$
CREATE PROCEDURE blackstarDb.UpsertCodexVisit(pCodexVisitId INT, pCstId INT, pCodexClientId INT, pCustomerName VARCHAR(400), pVisitDate DATETIME, pDescription TEXT, pClosure TEXT, pVisitStatusId CHAR(1), pCreated DATETIME, pCreatedBy NVARCHAR(100), pCreatedByUsr VARCHAR(100), pModified DATETIME, pModifiedBy NVARCHAR(100), pModifiedByUsr VARCHAR(100))
BEGIN

  IF(SELECT count(*) FROM codexVisit WHERE codexVisitId = pCodexVisitId) > 0 THEN
    UPDATE blackstarDb.codexVisit SET
      cstId = pCstId,
      codexClientId = if(pCodexClientId = 0, NULL, pCodexClientId),
      customerName = pCustomerName,
      visitDate = pVisitDate,
      description = pDescription,
      closure = pClosure,
      visitStatusId = pVisitStatusId,
      modified = now(),
      modifiedBy = pModifiedBy,
      modifiedByUsr = pModifiedByUsr
    WHERE codexVisitId = pCodexVisitId;
    SELECT pCodexVisitId;
  ELSE
    INSERT INTO blackstarDb.codexVisit(cstId, codexClientId,                                customerName,  visitDate,  description,  closure,  visitStatusId,  created,  createdBy,  createdByUsr) VALUES(
                                      pCstId, if(pCodexClientId = 0, NULL, pCodexClientId), pCustomerName, pVisitDate, pDescription, pClosure, pVisitStatusId, pCreated, pCreatedBy, pCreatedByUsr);

    SELECT LAST_INSERT_ID();
  END IF;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetCstByEmail
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetCstByEmail$$
CREATE PROCEDURE blackstarDb.GetCstByEmail(pcstEmail VARCHAR(400))
BEGIN

  SELECT *
  FROM blackstarDb.cst
  WHERE email = pcstEmail
  LIMIT 1;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetCodexPriceList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetCodexPriceList$$
CREATE PROCEDURE blackstarDb.GetCodexPriceList()
BEGIN

  SELECT 
    _id AS id,
    code AS model,
    REPLACE(name, '''', '') AS name,
    price AS price
  FROM blackstarDb.codexPriceList
  ORDER BY id;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.UpsertCodexCostCenter
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertCodexCostCenter$$
CREATE PROCEDURE blackstarDb.UpsertCodexCostCenter(pCostCenter VARCHAR(200), pUsrId INT)
BEGIN

  IF(SELECT count(*) FROM codexCostCenter WHERE costCenter = pCostCenter) = 0 THEN
    INSERT INTO codexCostCenter(costCenter, created, createdBy, createdByUsr)
    SELECT pCostCenter, now(), 'UpsertCodexCostCenter', pUsrId;
  END IF;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetCSTOffice
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetCSTOffice$$
CREATE PROCEDURE blackstarDb.GetCSTOffice(pCst VARCHAR(200))
BEGIN

  SELECT officeId FROM blackstarDb.cst WHERE email = pCst LIMIT 1;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetCostCenterList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetCostCenterList$$
CREATE PROCEDURE blackstarDb.GetCostCenterList()
BEGIN

  SELECT * 
  FROM codexCostCenter
  ORDER BY costCenter DESC;
  
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetAllStates
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetAllStates$$
CREATE PROCEDURE blackstarDb.CodexGetAllStates()
BEGIN

	SELECT DISTINCT loc.state AS state 
  FROM blackstarConst.location loc 
  ORDER BY state ASC;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetAllClientTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetAllClientTypes$$
CREATE PROCEDURE blackstarDb.CodexGetAllClientTypes()
BEGIN

	SELECT cct._id AS id, cct.name AS name, cct.description AS description
  FROM codexClientType cct;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetAllOriginTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetAllOriginTypes$$
CREATE PROCEDURE blackstarDb.CodexGetAllOriginTypes()
BEGIN

  SELECT ccot._id AS id, ccot.name AS name, ccot.description AS description 
  FROM codexClientOrigin ccot;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUsersByGroup
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUsersByGroup$$
CREATE PROCEDURE blackstarDb.GetUsersByGroup(pUserGroup VARCHAR(100))
BEGIN

	SELECT 
		u.blackstarUserId AS id, 
		u.email AS userEmail, 
		u.name AS userName
	FROM blackstarUser_userGroup ug
		INNER JOIN blackstarUser u ON u.blackstarUserId = ug.blackstarUserId
		INNER JOIN userGroup g ON g.userGroupId = ug.userGroupId
	WHERE g.externalId = pUserGroup
	ORDER BY u.name;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLocationsByState
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLocationsByState$$
CREATE PROCEDURE blackstarDb.GetLocationsByState(pZipCode VARCHAR(5))
BEGIN

   SELECT * 
   FROM blackstarConst.location
   WHERE zipCode = pZipCode;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertClient
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexInsertClient$$
CREATE PROCEDURE blackstarDb.`CodexInsertClient`(pClientTypeId int(2), pClientOriginId int(2), pCstId int(11)
                                                 , pIsProspect tinyint(4), pRfc varchar(13), pCorporateName text, pTradeName text, pPhoneArea varchar(3), pPhoneNumber varchar(10)
                                                 , pPhoneExtension varchar(6), pPhoneAreaAlt varchar(3), pPhoneNumberAlt varchar(10), pPhoneExtensionAlt varchar(6)
                                                 , pEmail varchar(60), pEmailAlt varchar(60), pStreet text, pIntNumber varchar(5), pExtNumber varchar(5)
                                                 , pZipCode int(5), pCountry text, pState varchar(20), pMunicipality text, pCity text, pNeighborhood text
                                                 , pContactName text, pCurp varchar(18), pRetention varchar(20))
BEGIN

	INSERT INTO codexClient (clientTypeId, clientOriginId, cstId, isProspect, rfc, corporateName,
              tradeName, phoneArea, phoneNumber, phoneExtension, phoneAreaAlt, phoneNumberAlt,
              phoneExtensionAlt, email, emailAlt, street, intNumber, extNumber, zipCode, country,
              state, municipality, city, neighborhood, contactName, curp, retention)
              VALUES
              (pClientTypeId, pClientOriginId, pCstId, pIsProspect, pRfc, pCorporateName,
              pTradeName, pPhoneArea, pPhoneNumber, pPhoneExtension, pPhoneAreaAlt, pPhoneNumberAlt,
              pPhoneExtensionAlt, pEmail, pEmailAlt, pStreet, pIntNumber, pExtNumber, pZipCode, pCountry,
              pState, pMunicipality, pCity, pNeighborhood, pContactName, pCurp, pRetention);
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetNextClientId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetNextClientId$$
CREATE PROCEDURE blackstarDb.`CodexGetNextClientId`()
BEGIN

  DECLARE newNumber INTEGER;
  CALL blackstarDb.GetNextServiceOrderNumber('C', newNumber);
  SELECT newNumber clientNumber;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetClientList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetClientList$$
CREATE PROCEDURE blackstarDb.`CodexGetClientList`(pIsProspect tinyint(4))
BEGIN

  SELECT cc._id id, ct.name clientTypeId ,
         IFNULL(corporateName, '') corporateName, 
         IFNULL(city, '') city, IFNULL(contactName, '') contactName
  FROM codexClient cc
    INNER JOIN codexClientType ct ON cc.clientTypeId = ct._id
  WHERE isProspect = pIsProspect;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetEntryTypes -- optimizado para rendereo en html
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetEntryTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetEntryTypes`()
BEGIN

  SELECT  _id AS id, 
          concat_ws('', replace(rpad(_id, 9, ' '), ' ', "&nbsp;"), name) AS name, 
          productType AS productType
  FROM codexProjectEntryTypes
  WHERE active = 1
  ORDER BY _id; 
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetEntryItemTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetEntryItemTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetEntryItemTypes`()
BEGIN

  SELECT _id AS id, 
         name AS name
  FROM codexProjectItemTypes;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetCurrencyTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetCurrencyTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetCurrencyTypes`()
BEGIN

  SELECT _id id, name name, description description 
  FROM codexCurrencyType;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetCurrencyTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetTaxesTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetTaxesTypes`()
BEGIN

  SELECT _id id, name name, description description , value value
  FROM codexTaxesTypes;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFollowUpByProjectId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFollowUpByProjectId$$
CREATE PROCEDURE blackstarDb.GetFollowUpByProjectId(pProjectId INTEGER)
BEGIN

	SELECT 
		created AS created,
		u2.name AS createdByUsr,
		u.name AS asignee,
		followup AS followUp
	FROM followUp f
		LEFT OUTER JOIN blackstarUser u ON f.asignee = u.email
		LEFT OUTER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE codexProjectId = pProjectId
	ORDER BY created;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetWorkTeamByProjectId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetWorkTeamByProjectId$$
CREATE PROCEDURE blackstarDb.`GetWorkTeamByProjectId`(pProjectId INTEGER)
BEGIN

SELECT *
FROM (
  (SELECT _id id, ticketId ticketId, workerRoleTypeId workerRoleTypeId, blackstarUserId blackstarUserId, assignedDate assignedDate
       FROM workTeam WHERE codexProjectId = pProjectId
  ) AS ticketTeam
       LEFT JOIN (SELECT bu.blackstarUserId refId, bu.name blackstarUserName
           FROM blackstarUser bu
        ) AS j1 ON ticketTeam.blackstarUserId = j1.refId
       LEFT JOIN (SELECT wrt._id refId, wrt.name as workerRoleTypeName 
           FROM workerRoleType wrt
        ) AS j2 ON ticketTeam.workerRoleTypeId = j2.refId
);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetResponsibleByProjectId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetResponsibleByProjectId$$
CREATE PROCEDURE blackstarDb.`GetResponsibleByProjectId`(pProjectId INTEGER)
BEGIN

DECLARE responsableId INTEGER;

SET responsableId = (SELECT blackstarUserId 
                     FROM workTeam 
                     WHERE codexProjectId = pProjectId
                           AND workerRoleTypeId = 1
                     LIMIT 1);
SELECT * 
FROM blackstarUser
WHERE blackstarUserId = responsableId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUserForResponseByProjectId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserForResponseByProjectId$$
CREATE PROCEDURE blackstarDb.`GetUserForResponseByProjectId`(pProjectId INTEGER)
BEGIN

DECLARE responseUserId INTEGER;

SET responseUserId = (SELECT blackstarUserId 
                     FROM workTeam 
                     WHERE codexProjectId = pProjectId
                           AND workerRoleTypeId = 2
                     ORDER BY assignedDate DESC
                     LIMIT 1);
SELECT * 
FROM blackstarUser
WHERE blackstarUserId = responseUserId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToCodexProject
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpToCodexProject$$
CREATE PROCEDURE blackstarDb.`AddFollowUpToCodexProject`(pProjectId INTEGER, pCreatedByUsr VARCHAR(200), pAssignedUsr VARCHAR(200), pMessage TEXT)
BEGIN

  -- LIMPIAR EL REGISTRO ACTIVE
  UPDATE followUp SET isActive = NULL WHERE codexProjectId = pProjectId AND isActive = 1;

	INSERT INTO blackstarDb.followUp(codexProjectId, followup, created, createdBy, createdByUsr, asignee, isActive)
	VALUES(pProjectId, pMessage, NOW(), 'AddFollowUpToCodexProject', pCreatedByUsr, pAssignedUsr, 1);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertWorkTeamByCodexProject
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertWorkTeamByCodexProject$$
CREATE PROCEDURE blackstarDb.`UpsertWorkTeamByCodexProject`(pProjectId INTEGER, pWorkerRoleTypeId INTEGER, pblackstarUserId INTEGER)
BEGIN

IF NOT EXISTS (SELECT * FROM workTeam 
               WHERE codexProjectId = pProjectId AND blackstarUserId = pblackstarUserId) THEN
    INSERT INTO blackstarDb.workTeam(codexProjectId, workerRoleTypeId, blackstarUserId, assignedDate)
    VALUES(pProjectId, pWorkerRoleTypeId, pblackstarUserId, NOW());   
ELSE
   UPDATE blackstarDb.workTeam SET assignedDate = NOW(), workerRoleTypeId = pWorkerRoleTypeId
   WHERE codexProjectId = pProjectId AND blackstarUserId = pblackstarUserId;
END IF;
IF (pWorkerRoleTypeId = 1) THEN
    UPDATE blackstarDb.workTeam SET workerRoleTypeId = 2
    WHERE codexProjectId = pProjectId AND blackstarUserId != pblackstarUserId;
END IF;
    
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetProjectById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetProjectById$$
CREATE PROCEDURE blackstarDb.`CodexGetProjectById`(pProjectId int(11))
BEGIN
SELECT cp._id id, cp.projectNumber projectNumber, cp.clientId clientId, cp.taxesTypeId taxesTypeId, cp.statusId statusId
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, cst.name statusDescription
      , cc.corporateName clientDescription, ccc.costCenter costCenter, cp.changeType changeType, cp.created created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.incoterm incoterm
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber, cp.createdBy createdBy, cp.createdByUsr createdByUsr
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr, cp.discountNumber discountNumber
      , cp.paymentConditions paymentConditions, cc.rfc clientRfc
FROM codexProject cp, codexClient cc, codexStatusType cst, codexPaymentType cpt, codexCurrencyType cct, codexCostCenter ccc
WHERE cp.statusId = cst._id
      AND cp.clientId = cc._id
      AND cp.paymentTypeId = cpt._id
      AND cp.currencyTypeId = cct._id
      AND cp.costCenterId = ccc._id
      AND cp._id = pProjectId ;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextProjectId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextProjectId$$
CREATE PROCEDURE blackstarDb.`GetNextProjectId`(pType VARCHAR(10))
BEGIN
	DECLARE newNumber INTEGER;
	CALL blackstarDb.GetNextServiceOrderNumber(pType, newNumber);
	SELECT newNumber projectNumber;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetDeliverableTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetDeliverableTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetDeliverableTypes`()
BEGIN
	SELECT cdt._id id, cdt.name name, cdt.description description 
  FROM codexDeliverableType cdt;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertDeliverableTrace
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexInsertDeliverableTrace$$
CREATE PROCEDURE blackstarDb.`CodexInsertDeliverableTrace`(pCodexProjectId  int(11), pDeliverableTypeId  int(11), pCreated DATETIME, pUserId varchar(1000), pCreatedBy varchar(200), pCreatedByUsr varchar(200), pDocumentId varchar(2000), pDocumentName varchar(2000))
BEGIN
	INSERT INTO codexDeliverableTrace (codexProjectId, deliverableTypeId, created, userId, createdBy, createdByUsr, documentId, documentName)
  VALUES (pCodexProjectId, pDeliverableTypeId, pCreated, pUserId, pCreatedBy, pCreatedByUsr, pDocumentId, pDocumentName);

  -- Conversion del prospecto a cliente
  SET @clientId = (SELECT clientId FROM codexProject WHERE _id = pCodexProjectId);
  IF pDeliverableTypeId = 6 AND (SELECT isProspect FROM codexClient c WHERE c._id = @clientId) = 0 THEN

    UPDATE codexClient SET
      isProspect = 1,
      turnedCustomerDate = CURDATE()
    WHERE _id = @clientId;
  END IF;
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetReferenceTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetReferenceTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetReferenceTypes`(pItemTypeId int(2))
BEGIN
  IF (pItemTypeId = 1) THEN
      SELECT _id AS value, CONCAT_WS(' - ', code, name) AS label FROM codexPriceList;
  END IF;
  IF (pItemTypeId = 2) THEN
     SELECT bt._id as value, bt.ticketNumber as label FROM bloomTicket bt;
  END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetPaymentTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetPaymentTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetPaymentTypes`()
BEGIN
	SELECT cpt._id id, cpt.name name, cpt.description description 
  FROM codexPaymentType cpt;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexUpsertProjectEntry
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexUpsertProjectEntry$$
CREATE PROCEDURE blackstarDb.`CodexUpsertProjectEntry`(pEntryId int(11), pProjectId int(11), pEntryTypeId int(11), pDescription TEXT, pDiscount FLOAT(15,2), pTotalPrice FLOAT(15,2), pComments TEXT, pQty INT, pUnitPrice FLOAT(15,2))
BEGIN
  DECLARE isUpdate INTEGER;
  SET isUpdate = (SELECT COUNT(*) FROM codexProjectEntry WHERE _id = pEntryId);
  
  IF(isUpdate = 0) THEN
    INSERT INTO codexProjectEntry (projectId, entryTypeId, description, discount, totalPrice, comments, qty, unitPrice)
    VALUES (pProjectId, pEntryTypeId, pDescription, pDiscount, pTotalPrice, pComments, pQty, pUnitPrice);
    
    SELECT LAST_INSERT_ID();
  ELSE
    UPDATE  codexProjectEntry SET 
      comments = pComments
    WHERE _id = pEntryId;

    SELECT pEntryId;
  END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexUpsertProjectEntryItem
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexUpsertProjectEntryItem$$
CREATE PROCEDURE blackstarDb.`CodexUpsertProjectEntryItem`(pItemId int(11),pEntryId int(11), pItemTypeId int(11), pReference TEXT, pDescription TEXT, pQuantity FLOAT(10,2), pPriceByUnit FLOAT(15,2), pDiscount FLOAT(15,2), pTotalPrice FLOAT(15,2), pComments TEXT)
BEGIN
  DECLARE isUpdate INTEGER;
  SET isUpdate = (SELECT COUNT(*) FROM codexEntryItem WHERE _id = pItemId);
 
  IF(isUpdate = 0) THEN
    INSERT INTO codexEntryItem (entryId, itemTypeId, reference, description, quantity, priceByUnit, discount, totalPrice, comments)
    VALUES (pEntryId, pItemTypeId, pReference, pDescription, pQuantity, pPriceByUnit, pDiscount, pTotalPrice, pComments);
  ELSE
    UPDATE  codexEntryItem SET comments = pComments
    WHERE _id = pItemId;
  END IF;
  
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexUpsertProject
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexUpsertProject$$
CREATE PROCEDURE blackstarDb.`CodexUpsertProject`(pProjectId int(11), pClientId int(11), pTaxesTypeId int(1), pStatusId int(1), pPaymentTypeId int(1),pCurrencyTypeId int(2), pProjectNumber varchar(8), pCostCenter varchar(8), pChangeType float, pCreated DATETIME, pContactName text, pLocation varchar(400), pAdvance FLOAT(15,2), pTimeLimit int(3), pSettlementTimeLimit int(3), pDeliveryTime int(3), pincoterm varchar(5), pProductsNumber FLOAT(15,2), pFinancesNumber FLOAT(15,2), pServicesNumber FLOAT(15,2), pTotalProjectNumber FLOAT(15,2), pCreatedByUsr int(11), pModifiedByUsr int(11), pDiscountNumber FLOAT(15,2), pPaymentConditions TEXT)
BEGIN
  DECLARE isUpdate INTEGER;
  SET isUpdate = (SELECT COUNT(*) FROM codexProject WHERE _id = pProjectId);

  CALL UpsertCodexCostCenter(pCostCenter, pCreatedByUsr);
  SET @ccId = (SELECT _id FROM codexCostCenter WHERE costCenter = pCostCenter);

  IF(isUpdate = 0) THEN
     INSERT INTO codexProject (clientId , taxesTypeId , statusId , paymentTypeId ,currencyTypeId , projectNumber , costCenterId , changeType , created , contactName , location , advance , timeLimit , settlementTimeLimit , deliveryTime , incoterm , productsNumber , financesNumber , servicesNumber , totalProjectNumber, createdByUsr, discountNumber, paymentConditions)
     VALUES (pClientId , pTaxesTypeId , pStatusId , pPaymentTypeId ,pCurrencyTypeId , pProjectNumber , @ccId , pChangeType , pCreated , pContactName , pLocation , pAdvance , pTimeLimit , pSettlementTimeLimit , pDeliveryTime , pincoterm , pProductsNumber , pFinancesNumber , pServicesNumber , pTotalProjectNumber, pCreatedByUsr, pDiscountNumber, pPaymentConditions);

     SELECT LAST_INSERT_ID();
  ELSE
     UPDATE codexProject
     SET clientId = pClientId, taxesTypeId = pTaxesTypeId, statusId = pStatusId, paymentTypeId = pPaymentTypeId
         , currencyTypeId = pCurrencyTypeId, projectNumber = pProjectNumber, costCenterId = @ccId
         , changeType = pChangeType, created = pCreated, contactName = pContactName, location = pLocation
         , advance = pAdvance, timeLimit = pTimeLimit, settlementTimeLimit = pSettlementTimeLimit
         , deliveryTime = pDeliveryTime, incoterm = pincoterm, productsNumber = pProductsNumber
         , financesNumber = pFinancesNumber, servicesNumber = pServicesNumber, totalProjectNumber = pTotalProjectNumber
         , discountNumber = pDiscountNumber
         , paymentConditions = pPaymentConditions
		 , modifiedByUsr = pModifiedByUsr, modified = NOW()
     WHERE _id = pProjectId;

     SELECT pProjectId;
  END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLocationsByZipCode
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLocationsByZipCode$$
CREATE PROCEDURE blackstarDb.`GetLocationsByZipCode`(pZipCode VARCHAR(5))
BEGIN

   SELECT _id, zipCode, country, state, municipality, IF(city IS NULL OR city = '', municipality, city) AS city, neighborhood
   FROM blackstarConst.location
   WHERE zipCode = pZipCode;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexUpsertProspect
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexUpsertProspect$$
CREATE PROCEDURE blackstarDb.`CodexUpsertProspect`(pClientId INT, pClientTypeId int(2), pClientOriginId int(2), pCstId int(11)
                                                 , pIsProspect tinyint(4), pRfc varchar(13), pCorporateName text, pTradeName text, pPhoneArea varchar(50), pPhoneNumber varchar(100)
                                                 , pPhoneExtension varchar(50), pPhoneAreaAlt varchar(50), pPhoneNumberAlt varchar(100), pPhoneExtensionAlt varchar(50)
                                                 , pEmail varchar(200), pEmailAlt varchar(200), pStreet text, pIntNumber varchar(50), pExtNumber varchar(50)
                                                 , pZipCode int(100), pCountry text, pState varchar(100), pMunicipality text, pCity text, pNeighborhood text
                                                 , pContactName text, pCurp varchar(50), pRetention varchar(100))
BEGIN
  DECLARE existsId INTEGER;
  
  SET existsId = (SELECT COUNT(*) FROM codexClient WHERE _id = pClientId);
  IF (existsId = 0) THEN
     INSERT INTO codexClient (_id, clientTypeId, clientOriginId, cstId, isProspect, rfc, corporateName,
                 tradeName, phoneArea, phoneNumber, phoneExtension, phoneAreaAlt, phoneNumberAlt,
                 phoneExtensionAlt, email, emailAlt, street, intNumber, extNumber, zipCode, country,
                 state, municipality, city, neighborhood, contactName, curp, retention)
                 VALUES
                 (pClientId, pClientTypeId, pClientOriginId, pCstId, pIsProspect, pRfc, pCorporateName,
                 pTradeName, pPhoneArea, pPhoneNumber, pPhoneExtension, pPhoneAreaAlt, pPhoneNumberAlt,
                 pPhoneExtensionAlt, pEmail, pEmailAlt, pStreet, pIntNumber, pExtNumber, pZipCode, pCountry,
                 pState, pMunicipality, pCity, pNeighborhood, pContactName, pCurp, pRetention);
  END IF;
  IF (existsId > 0) THEN
      UPDATE codexClient SET _id = pClientId, clientTypeId = pClientTypeId, clientOriginId = pClientOriginId
           , cstId = pCstId, isProspect = pIsProspect, rfc = pRfc, corporateName = pCorporateName
           , tradeName = pTradeName, phoneArea = pPhoneArea, phoneNumber = pPhoneNumber, phoneExtension = pPhoneExtension
           , phoneAreaAlt = pPhoneAreaAlt, phoneNumberAlt = pPhoneNumberAlt, phoneExtensionAlt = pPhoneExtensionAlt
           , email = pEmail, emailAlt = pEmailAlt, street = pStreet, intNumber = pIntNumber, extNumber = pExtNumber
           , zipCode = pZipCode, country = pCountry, state = pState, municipality = pMunicipality, city = pCity
           , neighborhood = pNeighborhood, contactName = pContactName, curp = pCurp, retention = pRetention
      WHERE _id = pClientId;
  END IF;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetAllClients
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetAllClients$$
CREATE PROCEDURE blackstarDb.`CodexGetAllClients`()
BEGIN
  SELECT _id id, clientTypeId clientTypeId, clientOriginId clientOriginId, cstId cstId
         , isProspect isProspect, rfc rfc, corporateName corporateName, tradeName tradeName
         , phoneArea phoneArea, phoneNumber phoneNumber, phoneExtension phoneExtension
         , phoneAreaAlt phoneAreaAlt, phoneNumberAlt phoneNumberAlt, phoneExtensionAlt phoneExtensionAlt
         , email email, emailAlt emailAlt, street street, intNumber intNumber, extNumber extNumber
         , zipCode zipCode, country country, state state, municipality municipality, city city
         , neighborhood neighborhood, contactName contactName, curp curp, retention retention
  FROM codexClient
  ORDER BY corporateName;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetClientById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetClientById$$
CREATE PROCEDURE blackstarDb.`CodexGetClientById`(pClientId int(11))
BEGIN
  SELECT _id id, clientTypeId clientTypeId, clientOriginId clientOriginId, cstId cstId
         , isProspect prospect, rfc rfc, corporateName corporateName, tradeName tradeName
         , phoneArea phoneArea, phoneNumber phoneNumber, phoneExtension phoneExtension
         , phoneAreaAlt phoneAreaAlt, phoneNumberAlt phoneNumberAlt, phoneExtensionAlt phoneExtensionAlt
         , email email, emailAlt emailAlt, street street, intNumber intNumber, extNumber extNumber
         , zipCode zipCode, country country, state state, municipality municipality, city city
         , neighborhood neighborhood, contactName contactName, curp curp, retention retention
  FROM codexClient
  WHERE _id = pClientId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetAllProjects
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetAllProjectsByUsr$$
CREATE PROCEDURE blackstarDb.`CodexGetAllProjectsByUsr`(pUserId int(11))
BEGIN
SELECT cp._id id, cp.projectNumber projectNumber, cp.clientId clientId, cp.taxesTypeId taxesTypeId, cp.statusId statusId
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, ctt.name statusDescription
      , cc.tradeName clientDescription, ccc.costCenter costCenter, cp.changeType changeType, Date(cp.created) created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.incoterm incoterm
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber, cp.createdBy createdBy, cp.createdByUsr createdByUsr
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr, cst.name cstName
FROM codexProject cp
  INNER JOIN codexClient cc ON cp.clientId = cc._id
  INNER JOIN codexStatusType ctt ON cp.statusId = ctt._id
  INNER JOIN codexPaymentType cpt ON cp.paymentTypeId = cpt._id
  INNER JOIN codexCurrencyType cct ON cp.currencyTypeId = cct._id
  INNER JOIN codexCostCenter ccc ON cp.costCenterId = ccc._id
  INNER JOIN cst cst ON cst.cstId = cc.cstId
WHERE 
      if(pUserId = 0, 1=1, cc.cstId = pUserId);
      
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetProjectsByStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetProjectsByStatus$$
CREATE PROCEDURE blackstarDb.`CodexGetProjectsByStatus`(pStatusId INT(2))
BEGIN
SELECT cp._id id, cp.projectNumber projectNumber, cp.clientId clientId, cp.taxesTypeId taxesTypeId, cp.statusId statusId
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, ctt.name statusDescription
      , cc.tradeName clientDescription, ccc.costCenter costCenter, cp.changeType changeType, Date(cp.created) created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.incoterm incoterm
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber, cp.createdBy createdBy, cp.createdByUsr createdByUsr
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr, cst.name cstName
FROM codexProject cp, codexClient cc, codexStatusType ctt, codexPaymentType cpt, codexCurrencyType cct, codexCostCenter ccc, cst cst
WHERE cp.statusId = ctt._id
      AND cp.clientId = cc._id
      AND cp.paymentTypeId = cpt._id
      AND cp.currencyTypeId = cct._id
      AND cp.costCenterId = ccc._id
      AND cc.cstId = cst.cstId
      AND cp.statusId = pStatusId;
END$$ 

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetProjectsByStatusAndUser
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetProjectsByStatusAndUser$$
CREATE PROCEDURE blackstarDb.`CodexGetProjectsByStatusAndUser`(pStatusId INT(2), pCstId INT(11))
BEGIN
SELECT cp._id id, cp.projectNumber projectNumber, cp.clientId clientId, cp.taxesTypeId taxesTypeId, cp.statusId statusId
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, ctt.name statusDescription
      , cc.tradeName clientDescription, ccc.costCenter costCenter, cp.changeType changeType, cp.created created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.incoterm incoterm
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber, cp.createdBy createdBy, cp.createdByUsr createdByUsr
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr, cst.name cstName
FROM codexProject cp
  INNER JOIN codexClient cc ON cp.clientId = cc._id
  INNER JOIN codexStatusType ctt ON cp.statusId = ctt._id
  INNER JOIN codexPaymentType cpt ON cp.paymentTypeId = cpt._id
  INNER JOIN codexCurrencyType cct ON cp.currencyTypeId = cct._id
  INNER JOIN codexCostCenter ccc ON cp.costCenterId = ccc._id
  INNER JOIN cst cst ON cst.cstId = cc.cstId
WHERE 
      cc.cstId = pCstId
      AND cp.statusId = pStatusId;
END$$ 

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetEntriesByProject
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetEntriesByProject$$
CREATE PROCEDURE blackstarDb.`CodexGetEntriesByProject`(pProjectId int(11))
BEGIN
	SELECT cpe._id id, cpe.projectId projectId, cpe.entryTypeId entryTypeId, cpe.description description, 
         cpe.discount discount, cpe.totalPrice totalPrice, cpe.comments comments, cpet.name entryTypeDescription,
         cpe.qty qty, cpe.unitPrice unitPrice
    FROM codexProjectEntry cpe, codexProjectEntryTypes cpet
    WHERE projectId = pProjectId
          AND  cpe.entryTypeId = cpet._id;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetItemsByEntry
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetItemsByEntry$$
CREATE PROCEDURE blackstarDb.`CodexGetItemsByEntry`(pEntryId int(11))
BEGIN
	SELECT cei._id id, cei.entryId entryId, cei.itemTypeId itemTypeId, cei.reference reference
         , cei.description description, cei.quantity quantity, cei.priceByUnit priceByUnit
         , cei.discount discount, cei.totalPrice totalPrice, cei.comments comments, cpit.name itemTypeDescription
  FROM codexEntryItem cei, codexProjectItemTypes cpit
  WHERE cei.entryId = pEntryId
        AND cei.itemTypeId = cpit._id;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetDeliverables
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetDeliverables$$
CREATE PROCEDURE blackstarDb.CodexGetDeliverables(pProjectId INTEGER)
BEGIN	
  
  SELECT t.*,
    u.name AS userName,
    p.projectNumber AS projectNumber,
    ty.name AS deliverableTypeName,
    ty.description AS deliverableTypeDescription
  FROM codexDeliverableTrace t 
    INNER JOIN codexProject p ON t.codexProjectId = p._id
    INNER JOIN codexDeliverableType ty ON ty._id = t.deliverableTypeId
    INNER JOIN blackstarUser u ON u.email = t.userId
  WHERE t.codexProjectId = pProjectId
  ORDER BY created;
END$$  

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexAdvanceStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexAdvanceStatus$$
CREATE PROCEDURE blackstarDb.`CodexAdvanceStatus`(pProjectId int(11), pStatusId INTEGER)
BEGIN

  DECLARE status INTEGER;
  SET status = (SELECT cp.statusId FROM codexProject cp WHERE cp._id =  pProjectId);
  UPDATE codexProject SET statusId = pStatusId WHERE _id = pProjectId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetsSalesManger
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetSalesManger$$
CREATE PROCEDURE blackstarDb.`CodexGetSalesManger`()
BEGIN

  SELECT bu.blackstarUserId blackstarUserId, bu.email userEmail, bu.name userName
  FROM blackstarUser_userGroup bug
    INNER JOIN userGroup ug ON  bug.userGroupId = ug.userGroupId
    INNER JOIN blackstarUser bu ON bug.blackstarUserId = bu.blackstarUserId
  WHERE ug.externalId = 'sysSalesManager';
       
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetProjectRisponsable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetProjectRisponsable$$
CREATE PROCEDURE blackstarDb.`CodexGetProjectRisponsable`(pProjectId int(11))
BEGIN
SELECT bu.blackstarUserId blackstarUserId, bu.email userEmail, bu.name userName
FROM blackstarUser bu, workTeam wt
WHERE wt.codexProjectId = pProjectId
     AND wt.workerRoleTypeId = 1
     AND bu.blackstarUserId = wt.blackstarUserId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexCleanProjectDependencies
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexCleanProjectDependencies$$
CREATE PROCEDURE blackstarDb.`CodexCleanProjectDependencies`(pProjectId int(11))
BEGIN
   DELETE FROM codexEntryItem
   WHERE entryId IN (SELECT _id FROM codexProjectEntry WHERE projectId = pProjectId);
   DELETE FROM codexProjectEntry WHERE projectId = pProjectId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertPriceProposal
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexInsertPriceProposal$$
CREATE PROCEDURE blackstarDb.`CodexInsertPriceProposal`(pProjectId int(11),pPriceProposalNumber varchar(50), pClientId int(11), pTaxesTypeId int(1), pPaymentTypeId int(1),pCurrencyTypeId int(2), pCostCenter varchar(8), pChangeType float, pCreated varchar(40), pContactName text, pLocation varchar(400), pAdvance FLOAT(15,2), pTimeLimit int(3), pSettlementTimeLimit int(3), pDeliveryTime int(3), pincoterm varchar(5), pProductsNumber FLOAT(15,2), pFinancesNumber FLOAT(15,2), pServicesNumber FLOAT(15,2), pTotalProjectNumber FLOAT(15,2), pDocumentId VARCHAR(2000))
BEGIN
     INSERT INTO codexPriceProposal (projectId, priceProposalNumber, clientId , taxesTypeId , paymentTypeId ,currencyTypeId  , costCenter , changeType , created , contactName , location , advance , timeLimit , settlementTimeLimit , deliveryTime , incoterm , productsNumber , financesNumber , servicesNumber , totalProjectNumber, documentId)
     VALUES (pProjectId, pPriceProposalNumber, pClientId , pTaxesTypeId , pPaymentTypeId ,pCurrencyTypeId , pCostCenter , pChangeType , pCreated , pContactName , pLocation , pAdvance , pTimeLimit , pSettlementTimeLimit , pDeliveryTime , pincoterm , pProductsNumber , pFinancesNumber , pServicesNumber , pTotalProjectNumber, pDocumentId);

     SELECT LAST_INSERT_ID();     
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertPriceProposalEntryItem
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexInsertPriceProposalEntryItem$$
CREATE PROCEDURE blackstarDb.`CodexInsertPriceProposalEntryItem`(pPriceProposalEntryId int(11), pItemTypeId int(11), pReference TEXT, pDescription TEXT, pQuantity FLOAT(10,2), pPriceByUnit FLOAT(15,2), pDiscount FLOAT(15,2), pTotalPrice FLOAT(15,2), pComments TEXT)
BEGIN
    INSERT INTO codexPriceProposalItem (priceProposalEntryId, itemTypeId, reference, description, quantity, priceByUnit, discount, totalPrice, comments)
    VALUES (pPriceProposalEntryId, pItemTypeId, pReference, pDescription, pQuantity, pPriceByUnit, pDiscount, pTotalPrice, pComments);  

    SELECT LAST_INSERT_ID();     
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertPriceProposalEntry
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexInsertPriceProposalEntry$$
CREATE PROCEDURE blackstarDb.`CodexInsertPriceProposalEntry`(pPriceProposalId int(11), pEntryTypeId int(11), pDescription TEXT, pDiscount FLOAT(15,2), pTotalPrice FLOAT(15,2), pComments TEXT)
BEGIN
    INSERT INTO codexPriceProposalEntry (priceProposalId, entryTypeId, description, discount, totalPrice, comments)
     VALUES (pPriceProposalId, pEntryTypeId, pDescription, pDiscount, pTotalPrice, pComments);

    SELECT LAST_INSERT_ID();     
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetProposalNumberForProject
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetProposalNumberForProject$$
CREATE PROCEDURE blackstarDb.`GetProposalNumberForProject`(pProjectId Int(11))
BEGIN
	SELECT COUNT(*) + 1 FROM codexPriceProposal WHERE projectId = pProjectId;
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetPriceProposalList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPriceProposalList$$
CREATE PROCEDURE blackstarDb.`GetPriceProposalList`(pProjectId Int(11))
BEGIN
  SELECT
    p.projectId AS projectId,
    p.priceProposalNumber AS priceProposalNumber,
    Date(p.created) AS created,
    c.corporateName AS name,
    p.contactName AS contactName,
    p.totalProjectNumber AS total,
    p.documentId AS documentId
  FROM codexPriceProposal p
    INNER JOIN codexClient c ON c._id = p.clientId
  WHERE projectId = pProjectId 
    AND documentId IS NOT NULL
  ORDER BY created;

END$$

-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;


-- -----------------------------------------------------------------------------
-- File: codesDb_Data.sql
-- Name: codesDb_Data
-- Desc: Corre Actualizaciones de datos
-- Auth: Sergio A Gomez
-- Date: 13/08/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author 	Description
-- --   --------   -------  ------------------------------------
-- 1    03/25/2015  SAG  	Version inicial.
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

-- -----------------------------------------------------------------------------
-- SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS blackstarDb.updateCodexData$$
CREATE PROCEDURE blackstarDb.updateCodexData()
BEGIN
	
-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

IF(SELECT COUNT(*) FROM blackstarDb.sequence WHERE description IS NOT NULL) = 0 THEN
	UPDATE sequence SET description = 'Ordenes de servicio tipo AA' WHERE sequenceTypeId = 'A';
	UPDATE sequence SET description = 'Ordenes de servicio tipo BB' WHERE sequenceTypeId = 'B';
	UPDATE sequence SET description = 'Pendientes' WHERE sequenceTypeId = 'I';
	UPDATE sequence SET description = 'Ordenes de servicio tipo General' WHERE sequenceTypeId = 'O';
	UPDATE sequence SET description = 'Ordenes de servicio tipo PE' WHERE sequenceTypeId = 'P';
	UPDATE sequence SET description = 'Ordenes de servicio tipo UPS' WHERE sequenceTypeId = 'U';
END IF;

IF(SELECT COUNT(*) FROM blackstarDb.sequence WHERE sequenceTypeId IN('C','G','M','Q')) = 0 THEN
	INSERT INTO sequence(sequenceTypeId, sequenceNumber, description)
	VALUES('C','336','Secuencia para numero de clientes'),
			('G','683','Cedulas de proyecto GDL'),
			('M','849','Cedulas de proyecto MXO'),
			('Q','868','Cedulas de proyecto QRO');
END IF;
-- -----------------------------------------------------------------------------
-- FIN SECCION DE DATPS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDb.updateCodexData();

DROP PROCEDURE blackstarDb.updateCodexData;



