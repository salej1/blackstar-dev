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

use blackstarDb;

DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.upgradeSchema$$
CREATE PROCEDURE blackstarDb.upgradeSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------


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
-- 53	09/09/2014	SAG 	Se modifica:
--								blackstarDb.AddupsService
-- -----------------------------------------------------------------------------
-- 54 	01/11/2014	SAG 	Se agrega:
--								GetSupportServiceOrderDetail
--								GetSupportServiceOrderComments
--								DeleteServiceOrder
--								DeleteServiceOrderPDF
--								GetSupportTicketDetail
--								DeleteFollowUp
--								DeleteTicket
--								GetSupportTicketComments
--								GetSupportBloomTicketDetails
--								DeleteBloomTicket
--								GetSupportBloomTicketComments
-- -----------------------------------------------------------------------------
-- 55	03/11/2014	SAG		Se agrega:
--								GetGuid
--								SaveGuid
-- -----------------------------------------------------------------------------
-- 56	06/11/2014	SAG 	Se agrega:		
--								FlagSurveySuggestion
-- -----------------------------------------------------------------------------
-- 57 	24/11/2014	SAG 	Se modifica:
--								UpsertScheduledService
--								GetFutureServicesSchedule
--								GetServicesSchedule
-- -----------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$


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
				sum(TIMESTAMPDIFF(HOUR, serviceDate, serviceEndDate)) * 20 AS cost
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

	SET @prevRefId = 0;
	SET @rowNumber = 0;
	SET @myId = (SELECT blackstarUserId FROM blackstarUser WHERE email = pUser);

	CREATE TEMPORARY TABLE usrGroup(email VARCHAR(100), name VARCHAR(200));
	INSERT INTO usrGroup(email, name)
	SELECT email, name FROM blackstarUser WHERE email = pUser;

	INSERT INTO usrGroup(email, name)
	SELECT email, name FROM blackstarUser WHERE bossId = (SELECT blackstarUserId FROM blackstarUser WHERE email = pUser);

	CREATE TEMPORARY TABLE followUpCandidates(followUpId INT, asignee VARCHAR(100), followUp TEXT, created DATETIME, createdByUsr VARCHAR(200), ticketId INT, serviceOrderId INT, issueId INT, bloomTicketId INT);
	INSERT INTO followUpCandidates(followUpId, asignee, followUp, created, createdByUsr, ticketId, serviceOrderId, issueId, bloomTicketId)
	SELECT followUpId, asignee, followUp, created, createdByUsr, ticketId, serviceOrderId, issueId, bloomTicketId FROM (
		SELECT @rowNumber := IF(coalesce(ticketId, serviceOrderId, issueId, bloomTicketId) = @prevRefId, @rowNumber + 1, 1) AS RowNum,
			f.*, 
			@prevRefId := coalesce(ticketId, serviceOrderId, issueId, bloomTicketId) AS PrevRef
		FROM followUp f
		ORDER BY followUpReferenceTypeId, coalesce(ticketId, serviceOrderId, issueId, bloomTicketId), created DESC
	) a 
	INNER JOIN usrGroup g ON a.asignee = g.email
	WHERE a.RowNum = 1;

	CREATE TEMPORARY TABLE displayIssues(referenceTypeId CHAR, referenceType VARCHAR(200), referenceId INT, referenceNumber VARCHAR(200), project VARCHAR(100), customer VARCHAR(400), created DATETIME, title VARCHAR(400), detail TEXT, status VARCHAR(200), createdByUsr VARCHAR(200), asignee VARCHAR(200));

	-- Tickets - policies
	INSERT INTO displayIssues(referenceTypeId, referenceType, referenceId, referenceNumber, project, customer, created, title, detail, status, createdByUsr, asignee)
	SELECT 
		'T', 'Ticket', f.ticketId, ticketNumber, project, customer, f.created, 'Seguimiento a Ticket', followUp, ticketStatus, u1.name, u2.name
	FROM followUpCandidates f 
		INNER JOIN ticket t ON t.ticketId = f.ticketId
		INNER JOIN policy p ON t.policyId = p.policyId
		INNER JOIN ticketStatus s ON t.ticketStatusId = s.ticketStatusId
		INNER JOIN usrGroup u1 ON u1.email = f.asignee
		INNER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE f.ticketId IS NOT NULL
		AND t.ticketStatusId IN('A','R');

	-- ServiceOrders - policy
	INSERT INTO displayIssues(referenceTypeId, referenceType, referenceId, referenceNumber, project, customer, created, title, detail, status, createdByUsr, asignee)
	SELECT 
		'O', 'Orden de Servicio', f.serviceOrderId, serviceOrderNumber, project, customer, f.created, 'Seguimiento a Orden de Servicio', followUp, serviceStatus, u1.name, u2.name
	FROM followUpCandidates f 
		INNER JOIN serviceOrder o ON o.serviceOrderId = f.serviceOrderId
		INNER JOIN policy p ON o.policyId = p.policyId
		INNER JOIN serviceStatus s ON o.serviceStatusId = s.serviceStatusId
		INNER JOIN usrGroup u1 ON u1.email = f.asignee
		INNER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE f.serviceOrderId IS NOT NULL
		AND o.serviceStatusId = 'E';

	-- ServiceOrders - openCustomer
	INSERT INTO displayIssues(referenceTypeId, referenceType, referenceId, referenceNumber, project, customer, created, title, detail, status, createdByUsr, asignee)
	SELECT 
		'O', 'Orden de Servicio', f.serviceOrderId, serviceOrderNumber, project, customerName, f.created, 'Seguimiento a Orden de Servicio', followUp, serviceStatus, u1.name, u2.name
	FROM followUpCandidates f 
		INNER JOIN serviceOrder o ON o.serviceOrderId = f.serviceOrderId
		INNER JOIN openCustomer p ON o.openCustomerId = p.openCustomerId
		INNER JOIN serviceStatus s ON o.serviceStatusId = s.serviceStatusId
		INNER JOIN usrGroup u1 ON u1.email = f.asignee
		INNER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE f.serviceOrderId IS NOT NULL
		AND o.serviceStatusId = 'E';

	-- BloomTickets
	INSERT INTO displayIssues(referenceTypeId, referenceType, referenceId, referenceNumber, project, customer, created, title, detail, status, createdByUsr, asignee)
	SELECT 
		'R', 'Requisicion', bloomTicketId, ticketNumber, project, '', f.created, 'Requisicion', followUp, s.name, u1.name, u2.name
	FROM followUpCandidates f 
		INNER JOIN bloomTicket t ON t._id = f.bloomTicketId
		INNER JOIN bloomStatusType s ON t.statusId = s._id
		INNER JOIN usrGroup u1 ON u1.email = f.asignee
		INNER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE f.bloomTicketId IS NOT NULL
		AND t.statusId IN(1,3);

	-- Issues
	INSERT INTO displayIssues(referenceTypeId, referenceType, referenceId, referenceNumber, project, customer, created, title, detail, status, createdByUsr, asignee)
	SELECT 
		'I', 'Asignacion SAC', f.issueId, issueNumber, project, ifnull(customer,''), f.created, 'Asignacion SAC', followUp, s.issueStatus, u1.name, u2.name
	FROM followUpCandidates f 
		INNER JOIN issue i ON i.issueId = f.issueId
		INNER JOIN issueStatus s ON i.issueStatusId = s.issueStatusId
		INNER JOIN usrGroup u1 ON u1.email = f.asignee
		INNER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE f.bloomTicketId IS NOT NULL
		AND i.issueStatusId = 'A';

	SELECT * FROM displayIssues ORDER BY created;

	DROP TABLE usrGroup;
	DROP TABLE followUpCandidates;
	DROP TABLE displayIssues;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUserPendingIssues
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserPendingIssues$$
CREATE PROCEDURE blackstarDb.GetUserPendingIssues(pUser VARCHAR(100))
BEGIN

	SET @prevRefId := 0;
	SET @rowNumber := 0;
	SET @myId:= (SELECT blackstarUserId FROM blackstarUser WHERE email = pUser);

	SELECT 
		f.followUpReferenceTypeId AS referenceTypeId, 
		r.followupreferencetype AS referenceType,
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
	FROM (
		SELECT * FROM (
			SELECT @rowNumber := IF(coalesce(ticketId, serviceOrderId, issueId, bloomTicketId) = @prevRefId, @rowNumber + 1, 1) AS RowNum,
				f.*, 
				@prevRefId := coalesce(ticketId, serviceOrderId, issueId, bloomTicketId) AS PrevRef
			FROM followUp f
			ORDER BY followUpReferenceTypeId, coalesce(ticketId, serviceOrderId, issueId, bloomTicketId), created DESC
		) a WHERE a.RowNum = 1  -- a: todos los followUps asignados por usuario, numerados por id de (ticket, so, issue)
	) f -- f: el ultimo comentario de cada (ticket, so, issue, requisicion) y que esta asignado al usuario
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
	WHERE coalesce(t.asignee, s.asignee, i.asignee, bt.asignee) = pUser
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
CREATE PROCEDURE blackstarDb.GetFutureServicesSchedule(pServiceDate DATETIME, pOfficeId CHAR(1))
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
		AND if(pOfficeId = "A", 1 = 1, ifnull(s.officeId, pOfficeId) = pOfficeId)
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


USE blackstarDbTransfer;


DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDbTransfer.upgradeSchema$$
CREATE PROCEDURE blackstarDbTransfer.upgradeSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

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
	  pBrand VARCHAR(50),
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
-- 1    20/03/2014	DCB		Se Integran los SP iniciales:
--								blackstarDb.BloomUpdateTickets
--								blackstarDb.BloomUpdateTransferFollow
--								blackstarDb.BloomUpdateTransferTeam
-- 								blackstarDb.BloomUpdateTransferUsers
-- 								blackstarDb.BloomTransfer
-- 2    24/03/2014	DCB		Se Integra blackstarDb.GetbloomTicketDetail
-- 3    24/03/2014	DCB		Se Integra blackstarDb.GetbloomTicketTeam
-- 4    28/03/2014	DCB		Se Integra blackstarDb.AddFollowUpTobloomTicket
--                          Se Integra blackstarDb.UpsertbloomTicketTeam
--                          Se Integra blackstarDb.GetBloomFollowUpByTicket
-- 5    31/03/2014  DCB     Se integra blackstarDb.GetBloomDeliverableType  
--                  DCB     Se integra blackstarDb.AddBloomDelivarable  
-- 5    02/04/2014  DCB     Se integra blackstarDb.GetbloomTicketResponsible
--                  DCB     Se integra blackstarDb.GetUserById
-- 6    03/04/2014  DCB     Se integra blackstarDb.ClosebloomTicket

-- 7     08/05/2014  OMA	blackstarDb.getBloomPendingTickets
-- 8     08/05/2014  OMA	blackstarDb.getbloomTickets
-- 9     08/05/2014  OMA	blackstarDb.getBloomDocumentsByService
-- 10    08/05/2014  OMA 	blackstarDb.getBloomProjects
-- 11    08/05/2014  OMA 	blackstarDb.getbloomApplicantArea
-- 12    08/05/2014  OMA 	blackstarDb.getBloomServiceType
-- 13    08/05/2014  OMA 	blackstarDb.getBloomOffice
-- 14    08/05/2014  OMA 	blackstarDb.GetNextInternalTicketNumber
-- 15    08/05/2014  OMA 	blackstarDb.AddInternalTicket
-- 16    08/05/2014  OMA 	blackstarDb.AddMemberTicketTeam
-- 17    08/05/2014  OMA 	blackstarDb.AddDeliverableTrace
-- 18    08/05/2014  OMA	blackstarDb.GetUserData (MODIFICADO:Sobrescribimos la version anterior)
-- 19    08/05/2014  OMA	blackstarDb.getBloomEstatusTickets

-- 19    16/05/2014  OMA	blackstarDb.GetBloomSupportAreasWithTickets
-- 20    16/05/2014  OMA	blackstarDb.GetBloomStatisticsByAreaSupport
-- 21    16/05/2014  OMA	blackstarDb.GetBloomPercentageTimeClosedTickets
-- 22    16/05/2014  OMA	blackstarDb.GetBloomPercentageEvaluationTickets
-- 23    16/05/2014  OMA	blackstarDb.GetBloomNumberTicketsByArea
-- 24    16/05/2014  OMA	blackstarDb.GetBloomUnsatisfactoryTicketsByUserByArea
-- 25    16/05/2014  OMA	blackstarDb.GetBloomHistoricalTickets
-- 26    22/06/2014  OMA	blackstarDb.getBloomAdvisedUsers
--
-- ------------------------------------------------------------------------------
-- 27   29/06/2014  SAG   Correcciones de integracion:
--                          blackstarDb.AddMemberTicketTeam
-- ------------------------------------------------------------------------------
-- 28   10/07/2014  SAG   Se modifica:
--                          blackstarDb.AddInternalTicket
-- ------------------------------------------------------------------------------
-- 29   20/08/2014  SAG   Se integra proyecto bloom 
--                        Se agrega AssignBloomTicket
--                        Se agrega UserCanAssignBloomTicket
-- ------------------------------------------------------------------------------
-- 30   16/09/2014  SAG   Se agrega:
--                        Se agrega bloomTicketAutoclose
-- ------------------------------------------------------------------------------
-- 31   06/10/2014  SAG   Se cambia:
--                          bloomTicketAutoclose por bloomTicketAutoProcess
-- ------------------------------------------------------------------------------
-- 32   07/10/2014  SAG   Se modifica:
--                          GetBloomHistoricalTickets - se agrega opcion 0 - Abiertos y retrasados
-- ------------------------------------------------------------------------------
-- 33   17/11/2014  SAG   Se agrega:
--                          bloomGetTicketsServiceOrdersMixed
-- ------------------------------------------------------------------------------
-- 34   17/12/2014  SAG   Se modifica:
--                          GetBloomStatisticsByAreaSupport
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
CREATE PROCEDURE blackstarDb.`AddFollowUpTobloomTicket`(pTicketId INTEGER, asignee VARCHAR(50), pCreatedByUsrMail VARCHAR(50), pMessage TEXT)
BEGIN
  
  IF asignee = '' THEN
    SET asignee = pCreatedByUsrMail;
  END IF;

	INSERT INTO blackstarDb.followUp(bloomTicketId, followup, followUpReferenceTypeId, asignee, created, createdBy, createdByUsr)
	VALUES(pTicketId, pMessage, 'R', asignee, CONVERT_TZ(now(),'+00:00','-5:00'), 'AddFollowUpTobloomTicket', pCreatedByUsrMail);
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
    UPDATE bloomDeliverableTrace SET delivered = 1, date = CONVERT_TZ(now(),'+00:00','-5:00'), docId = pDocId;
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
					AND t.statusId=6
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
    WHERE t.statusId > 5
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
		WHERE t.statusId=6 -- tickets cerrados
		AND t.created>= startCreationDate
		AND t.created <= endCreationDate
		and date(t.responseDate) <= t.dueDate) as satisfactory);

	SET noTicketsUnsatisfactory = (select count(id) from (
		select t._id as id, t.created ,t.dueDate,t.responseDate,date(t.responseDate),t.statusId from bloomTicket t
		WHERE t.statusId=6 -- tickets cerrados 
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
		AND t.statusId=6 -- tickets cerrados
		AND t.created>= startCreationDate
		AND t.created <= endCreationDate
		) as evaluation);

	SET noTicketsEvaluationUnsatisfactory = (select count(id) from (
		select t._id as id, t.evaluation, t.created ,t.dueDate,t.responseDate,date(t.responseDate),t.statusId from bloomTicket t
		WHERE t.evaluation<initEvaluationValue
		AND t.statusId=6 -- tickets cerrados
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
						AND t.statusId=6 -- tickets cerrados
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


-- -----------------------------------------------------------------------------
-- Desc:Carga de datos inicial
-- Auth:oscar martinez
-- Date:22/06/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    AuthorDescription
-- --   --------   -------  ----------------------------------------------------
-- 1    20/03/2014  DCB  	Version inicial. 
-- --   --------   -------  ----------------------------------------------------
-- 2    08/05/2014  OMA  	ID secuencia tickets internos 
-- --   --------   -------  ----------------------------------------------------
-- 3    08/05/2014  OMA  	Perfil Mesa de ayuda
-- --   --------   -------  ----------------------------------------------------
-- 4    22/06/2014  OMA  	nueva actualizacion de perfiles y catalogos
-- --   --------   -------  ----------------------------------------------------
-- 5 	11/07/2014	SAG 	Script para poblar hidden en bloomServiceType
-- --   --------   -------  ----------------------------------------------------
-- 6	09/09/2014	SAG 	Se establece SAC600 como inicio secuencia de requisiciones
-- -----------------------------------------------------------------------------
-- 7	17/09/2014	SAG 	Se establecen tiempos Auto-close
-- -----------------------------------------------------------------------------
-- 8	03/10/2014	SAG 	Se agrega DeliverableType 'Otro'
-- -----------------------------------------------------------------------------
-- 9 	06/10/2014	SAG 	Se elimina status En Proceso
-- -----------------------------------------------------------------------------

use blackstarDb;


DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.updateDataBloom$$
CREATE PROCEDURE blackstarDb.updateDataBloom()
BEGIN

-- ELIMINANDO ESTATUS EN PROCESO
DELETE FROM blackstarDb.bloomStatusType WHERE name ='EN PROCESO';

-- Resolver can close
IF(SELECT count(*) FROM bloomServiceType WHERE resolverCanClose > 0) = 0 THEN
	UPDATE bloomServiceType SET
		resolverCanClose = 1 
	WHERE _id IN(13,15);
END IF;

-- DeliverableType
IF(SELECT count(*) FROM blackstarDb.bloomDeliverableType WHERE name = 'Otro') = 0 THEN
	INSERT INTO blackstarDb.bloomDeliverableType(_id, name, description, serviceTypeId)
	SELECT 46,  'Otro', 'Otro', 1 UNION
	SELECT 47,  'Otro', 'Otro', 2 UNION
	SELECT 48,  'Otro', 'Otro', 3 UNION
	SELECT 49,  'Otro', 'Otro', 4 UNION
	SELECT 50,  'Otro', 'Otro', 5 UNION
	SELECT 51,  'Otro', 'Otro', 6 UNION
	SELECT 52,  'Otro', 'Otro', 7 UNION
	SELECT 53,  'Otro', 'Otro', 8 UNION
	SELECT 54,  'Otro', 'Otro', 9 UNION
	SELECT 55,  'Otro', 'Otro', 10 UNION
	SELECT 56,  'Otro', 'Otro', 11 UNION
	SELECT 57,  'Otro', 'Otro', 12 UNION
	SELECT 58,  'Otro', 'Otro', 13 UNION
	SELECT 59,  'Otro', 'Otro', 14 UNION
	SELECT 60,  'Otro', 'Otro', 15 UNION
	SELECT 61,  'Otro', 'Otro', 16 UNION
	SELECT 62,  'Otro', 'Otro', 17 UNION
	SELECT 63,  'Otro', 'Otro', 18 UNION
	SELECT 64,  'Otro', 'Otro', 19 UNION
	SELECT 65,  'Otro', 'Otro', 20 UNION
	SELECT 66,  'Otro', 'Otro', 21 UNION
	SELECT 67,  'Otro', 'Otro', 22 UNION
	SELECT 68,  'Otro', 'Otro', 23 UNION
	SELECT 69,  'Otro', 'Otro', 24;
END IF;

-- Tiempos auto-close
UPDATE bloomServiceType SET
	autoClose = 2
WHERE _id NOT IN (13, 15);

-- Estableciendo contador inicial para Requisiciones
IF(SELECT sequenceNumber FROM blackstarDb.sequence WHERE sequenceTypeId='I') < 600 THEN
	UPDATE blackstarDb.sequence SET sequenceNumber = 600 WHERE sequenceTypeId='I';
END IF;

-- Agregando FollowUpReferenceType
IF(SELECT count(*) FROM blackstarDb.followUpReferenceType WHERE followUpReferenceTypeId = 'R') = 0 THEN
	INSERT INTO blackstarDb.followUpReferenceType(followUpReferenceTypeId, followUpReferenceType)
	SELECT 'R', 'Requisicion';
END IF;

-- Poblando bloomServiceType.hidden
UPDATE bloomServiceType 
SET
	hidden = 1 
WHERE _id in(16,17,18,19,20,21);

-- -----------------------------------------------------------------------------
	-- SECUENCIA
-- -----------------------------------------------------------------------------
IF(SELECT COUNT(*) FROM blackstarDb.sequence WHERE sequenceTypeId='I') = 0 THEN
	INSERT INTO blackstarDb.sequence (sequenceTypeId,sequenceNumber) values('I',1);	
END IF;	

-- -----------------------------------------------------------------------------
	-- CATALOGOS
-- -----------------------------------------------------------------------------

IF(SELECT count(*) FROM bloomWorkerRoleType) = 0 THEN
	INSERT INTO bloomWorkerRoleType VALUES (1,'Responsable', 'Responsable de dar seguimiento al Ticket');
	INSERT INTO bloomWorkerRoleType VALUES (2,'Colaborador', 'Personal de apoyo');
END IF;

IF(SELECT count(*) FROM bloomStatusType) = 0 THEN
	INSERT INTO bloomStatusType VALUES (1,'Abierto', 'Ingreso de solicitud');
	INSERT INTO bloomStatusType VALUES (2,'En proceso', 'Asignado, en proceso de solucion');
	INSERT INTO bloomStatusType VALUES (3,'Retrasado', 'Retrasado');
	INSERT INTO bloomStatusType VALUES (4,'Cancelado', 'Cancelado');
	INSERT INTO bloomStatusType VALUES (5,'Resuelto', 'Resuelto');
	INSERT INTO bloomStatusType VALUES (6,'Cerrado', 'Cerrado');
END IF;

-- lista solicitantes
IF(SELECT count(*) FROM bloomApplicantArea) = 0 THEN
	INSERT INTO blackstarDb.bloomApplicantArea VALUES (1,'Ventas', 'Ventas');
	INSERT INTO blackstarDb.bloomApplicantArea VALUES (2,'Implementacion y Servicio', 'Implementacion y Servicio');
	INSERT INTO blackstarDb.bloomApplicantArea VALUES (3,'Gerentes o Coordinadoras al Area de Compras', 'Gerentes o Coordinadoras al Area de Compras');
	INSERT INTO blackstarDb.bloomApplicantArea VALUES (4,'Personal con gente a su cargo', 'Personal con gente a su cargo');
	INSERT INTO blackstarDb.bloomApplicantArea VALUES (5,'General', 'General');
END IF;
 
-- Lista de Areas de servicio
IF(SELECT count(*) FROM bloomServiceArea) = 0 THEN
	INSERT INTO blackstarDb.bloomServiceArea(bloomServiceAreaId, bloomServiceArea) VALUES('I','Ingenieria');
	INSERT INTO blackstarDb.bloomServiceArea(bloomServiceAreaId, bloomServiceArea) VALUES('C','Compras');
	INSERT INTO blackstarDb.bloomServiceArea(bloomServiceAreaId, bloomServiceArea) VALUES('R','Redes');
	INSERT INTO blackstarDb.bloomServiceArea(bloomServiceAreaId, bloomServiceArea) VALUES('H','Capital Humano');
	INSERT INTO blackstarDb.bloomServiceArea(bloomServiceAreaId, bloomServiceArea) VALUES('A','Calidad');
END IF;   

-- Solicitante:Ventas, Lista de tipo de servicios
IF(SELECT count(*) FROM bloomServiceType) = 0 THEN
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (1,1,7,'Levantamiento', 'Levantamiento','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (2,1,7,'Apoyo de Ingeniero de Soprte o Apoyo de Servicio', 'Apoyo de Ingeniero de Soprte o Apoyo de Servicio','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (3,1,4,'Elaboracion de Diagrama CAD', 'Elaboracion de Diagrama CAD','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (4,1,4,'Elaboracion de Plano e Imagenes 3D del SITE', 'Elaboracion de Plano e Imagenes 3D del SITE','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (5,1,4,'Realizacion de Cedula de Costos', 'Realizacion de Cedula de Costos','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (6,1,2,'Pregunta tecnica', 'Pregunta tecnica','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (7,1,4,'Solicitud de Aprobacion de Proyectos Mayores a 50KUSD y con minimo 3 lineas diferentes', 'Solicitud de Aprobacion de Proyectos Mayores a 50KUSD y con minimo 3 lineas diferentes','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (8,1,4,'Solicitud de Precio de Lista de algun producto que no se encuentre en lista de precio', 'Solicitud de Precio de Lista de algun producto que no se encuentre en lista de precio','I');

                                                                   
-- Solicitante:Implementacion y Servicio, Lista de tipo de servicios                                  
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (9, 2,4,'Elaboracion de Diagrama CAD o de Plano en 3D', 'Elaboracion de Diagrama CAD o de Plano en 3D','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (10,2,4,'Reporte de Calidad de Energia', 'Reporte de Calidad de Energia','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (11,2,8,'Soporte en Monitoreo y/o desarrollo de mapeo', 'Soporte en Monitoreo y/o desarrollo de mapeo','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (12,2,2,'Pregunta tecnica', 'Pregunta tecnica','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (13,2,8,'Requisicion de Parte o Refaccion', 'Requisicion de Parte o Refaccion','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (14,2,4,'Solicitud de Precio de Costo', 'Solicitud de Precio de Costo','I');
                                                  
                                                  
-- Solicitante:Gerentes o Coordinadoras al Area de Compras, Lista de tipo de servicios                                                   
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (15,3,15,'Requerimiento de Compra de Activos', 'Requerimiento de Compra de Activos','C');
                                                      
-- Solicitante:Personal con gente a su cargo, Lista de tipo de servicios                                                
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (16,4,5,'Aumento de sueldo', 'Aumento de sueldo','H');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (17,4,30,'Contratacion de personal', 'Contratacion de personal','H');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (18,4,5,'Nueva Creacion', 'Nueva Creacion','H');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (19,4,3,'Finiquito', 'Finiquito','H');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (20,4,2,'Acta Adminsitrativa', 'Acta Adminsitrativa','H');
                                                      
                                                      
-- Solicitante:General, Lista de tipo de servicios                                                    
	INSERT INTO blackstarDb.bloomServiceType  (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (21,5,5,'Req. de Curso', 'Req. de Curso','H');
	INSERT INTO blackstarDb.bloomServiceType  (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (22,5,5,'Modificacion del SGC', 'Modificacion del SGC','A');
	INSERT INTO blackstarDb.bloomServiceType  (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (23,5,5,'Sugerencia de Modificacion', 'Sugerencia de Modificacion','A');
	INSERT INTO blackstarDb.bloomServiceType  (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (24,5,1,'Problemas con telefonia o con la red', 'Problemas con telefonia o con la red','R');
END IF;

IF(SELECT count(*) FROM bloomDeliverableType) = 0 THEN
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (1,1,'CheckList de levantamiento', 'CheckList de levantamiento');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (4,3,'Diagrama en CAD', 'Diagrama en CAD');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (5,3,'Diagrama en PDF', 'Diagrama en PDF');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (7,4,'Imagenes de Plano en 3D', 'Imagenes de Plano en 3D');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (9,5,'Cedula de Costos', 'Cedula de Costos');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (11,6,'Respuesta', 'Respuesta');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (13,7,'Aprobacion o retroalimentacion', 'Aprobacion o retroalimentacion');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (15,8,'Precio de Lista y Condiciones comerciales', 'Precio de Lista y Condiciones comerciales');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (17,9,'Diagrama en CAD o Imagenes de Plano en 3D', 'Diagrama en CAD o Imagenes de Plano en 3D');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (18,9,'Diagrama en PDF', 'Diagrama en PDF');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (20,10,'Reporte de Calidad', 'Reporte de Calidad');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (22,11,'Respuesta o desarrollo', 'Respuesta o desarrollo');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (24,12,'Respuesta', 'Respuesta');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (26,13,'Entrega de la parte', 'Entrega de la parte');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (27,13,'Orden de Compra', 'Orden de Compra');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (29,14,'Precio de Costo', 'Precio de Costo');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (31,15,'Entrega de Activos', 'Entrega de Activos');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (33,16,'Respuesta del incremento', 'Respuesta del incremento');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (35,17,'Nuevo personal', 'Nuevo personal');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (37,18,'Respuesta', 'Respuesta');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (39,19,'Baja del colaborador', 'Baja del colaborador');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (41,20,'Acta Administrativa personalizada', 'Acta Administrativa personalizada');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (42,21,'RESPUESTA DEL REQ.', 'RESPUESTA DEL REQ.');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (43,22,'RESPUESTA DEL REQ.', 'RESPUESTA DEL REQ.');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (44,23,'RESPUESTA DEL REQ.', 'RESPUESTA DEL REQ.');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (45,24,'Respuesta', 'Respuesta');
END IF;

IF(SELECT count(*) FROM bloomAdvisedGroup) = 0 THEN
	-- Levantamiento
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,1,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,1,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,1,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,1,'sysSalesManager',2);
	-- Apoyo de Ingeniero de Soprte o Apoyo de Servicio
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,2,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,2,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,2,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,2,'sysSalesManager',2);
	-- Elaboración de Diagrama CAD
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,3,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,3,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,3,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,3,'sysSalesManager',2);
	-- Elaboración de Plano e Imágenes 3D del SITE
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,4,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,4,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,4,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,4,'sysSalesManager',2);
	-- Realización de Cédula de Costos
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,5,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,5,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,5,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,5,'sysSalesManager',2);
	-- Pregunta técnica
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,6,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,6,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,6,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,6,'sysSalesManager',2);
	-- Solicitud de Aprobación de Proyectos Mayores a 50KUSD y con mínimo 3 líneas diferentes
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,7,'sysEngManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,7,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,7,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,7,'sysSalesManager',2);
	-- Solicitud de Precio de Lista de algún producto que no se encuentre en lista de precio 
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,8,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,8,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,8,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,8,'sysSalesManager',2);
	-- Elaboración de Diagrama CAD o de Plano en 3D
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,9,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,9,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,9,'sysHelpDeskGroup',2);
	-- Reporte de Calidad de Energía
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,10,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,10,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,10,'sysHelpDeskGroup',2);
	-- Soporte en Monitoreo y/o desarrollo de mapeo
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,11,'sysNetworkManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,11,'sysHelpDeskGroup',2);
	-- Pregunta técnica
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,12,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,12,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,12,'sysHelpDeskGroup',2);
	-- Requisición de Parte o Refacción
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,13,'sysPurchaseManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,13,'sysPurchase',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,13,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,13,'sysCallCenter',2);
	-- Solicitud de Precio de Costo
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,14,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,14,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,14,'sysHelpDeskGroup',2);
	-- Requerimiento de Compra de Activos
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,15,'sysPurchaseManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,15,'sysPurchase',1);
	-- Aumento de sueldo
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,16,'sysHRManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,16,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,16,'sysHR',2);
	-- Contratación de personal
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,17,'sysHRManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,17,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,17,'sysHR',2);
	-- Nueva Creación
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,18,'sysHRManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,18,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,18,'sysHR',2);
	-- Finiquito
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,19,'sysHRManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,19,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,19,'sysHR',2);
	-- Acta Adminsitrativa
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,20,'sysHRManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,20,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,20,'sysHR',2);
	-- Req. de Curso
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,21,'sysHRManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,21,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,21,'sysHR',2);
	-- Modificación del SGC
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,22,'sysQAManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,22,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,22,'sysQA',2);
	-- Sugerencia de Modificación
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,23,'sysQAManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,23,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,23,'sysQA',2);
	-- Problemas con telefonía o con la red
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,24,'sysPurchaseManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,24,'sysNetworkManager',1);
END IF;

-- Eliminando Encuesta de satisfaccion de salidas requeridas
DELETE FROM bloomDeliverableType WHERE name = 'Encuesta de Satisfaccion';


END$$

DELIMITER ;

CALL blackstarDb.updateDataBloom();

DROP PROCEDURE blackstarDb.updateDataBloom;



