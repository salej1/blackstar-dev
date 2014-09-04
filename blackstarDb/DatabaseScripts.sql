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
-- --   --------   -------  ------------------------------------
-- 1    11/11/2013  SAG  	Version inicial. Modificaciones a OS
-- --   --------   -------  ------------------------------------
-- 2    12/11/2013  SAG  	Modificaciones a followUp - isSource
-- --   --------   -------  ------------------------------------
-- 3    13/11/2013  SAG  	Se agrega scheduledService
-- --   --------   -------  ------------------------------------
-- 4    28/11/2013  JAGH  	Se agregan tablas para captura de OS
-- --   --------   -------  ------------------------------------
-- 5    12/12/2013  SAG  	Se agrega sequence y sequenceNumberPool
-- --   --------   -------  ------------------------------------
-- 6    09/02/2014  SAG  	Se cambia serviceOrderAdditionalEngineer por
-- 							serviceOrderEmployee
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.upgradeSchema$$
CREATE PROCEDURE blackstarDb.upgradeSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

-- AGREGANDO COLUMNA description a sequence
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'sequence' AND COLUMN_NAME = 'description') = 0  THEN
		ALTER TABLE sequence ADD description VARCHAR(200) NULL;
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
		plugCleanStatus nvarchar(50) null,
		plugCleanComments nvarchar(50) null,
		coverClean BIT NOT NULL,
		coverCleanStatus nvarchar(50) null,
		coverCleanComments nvarchar(50) null,
		capClean BIT NOT NULL,
		capCleanStatus nvarchar(50) null,
		capCleanComments nvarchar(50) null,
		groundClean BIT NOT NULL,
		groundCleanStatus nvarchar(50) null,
		groundCleanComments nvarchar(50) null,
		rackClean BIT NOT NULL,
		rackCleanStatus nvarchar(50) null,
		rackCleanComments nvarchar(50) null,
		serialNoDateManufact nvarchar(50) null,
		batteryTemperature nvarchar(50) null,
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
		brandPE nvarchar (50) null,
		modelPE nvarchar (50) null,
		serialPE nvarchar (50) null,
		transferType nvarchar(50) null,
		modelTransfer nvarchar(50) null,
		modelControl nvarchar(50) null,
		modelRegVoltage nvarchar(50) null,
		modelRegVelocity nvarchar(50) null,
		modelCharger nvarchar(50) null,
		oilChange date null,
		brandMotor nvarchar(50) null,
		modelMotor nvarchar(50) null,
		serialMotor nvarchar(50) null,
		cplMotor nvarchar(50) null,
		brandGenerator nvarchar(50) null,
		modelGenerator nvarchar(50) null,
		serialGenerator nvarchar(50) null,
		powerWattGenerator integer null,
		tensionGenerator integer null,
		tuningDate date null,
		tankCapacity integer null,
		pumpFuelModel nvarchar(50) null,
		filterFuelFlag bit not null,
		filterOilFlag bit not null,
		filterWaterFlag bit not null,
		filterAirFlag bit not null,
		brandGear nvarchar(50) null,
		brandBattery nvarchar(50) null,
		clockLecture nvarchar(50) null,
		serviceCorrective date null,
		observations nvarchar(50) null,
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
		batteryCap nvarchar(50) null,
		batterySulfate nvarchar(50) null,
		levelOil integer null,
		heatEngine nvarchar(50) null,
		hoseOil nvarchar(50) null,
		hoseWater nvarchar(50) null,
		tubeValve nvarchar(50) null,
		stripBlades nvarchar(50) null,
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
		mechanicalStatus nvarchar(10) not null,
		boardClean bit not null,
		screwAdjust bit not null,
		lampTest bit not null,
		conectionAdjust bit not null,
		systemMotors nvarchar(10) not null,
		electricInterlock nvarchar(10) not null,
		mechanicalInterlock nvarchar(10) not null,
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
		adjsutmentTherm nvarchar(10) not null,
		current nvarchar(10) not null,
		batteryCurrent nvarchar(10) not null,
		clockStatus nvarchar(10) not null,
		trasnferTypeProtection nvarchar(10) not null,
		generatorTypeProtection nvarchar(10) not null,
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
		estatusEquipment nvarchar(50) not null,
		cleaned bit not null,
		hooverClean bit not null,
		verifyConnections bit not null,
		capacitorStatus nvarchar(50) not null,
		verifyFuzz bit not null,
		chargerReview bit not null,
		fanStatus nvarchar(50) not null,
		observations nvarchar(250) not null,
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
		manufacturedDateSerial nvarchar(10) not null,
		damageBatteries nvarchar(50) not null,
		other nvarchar(250) not null,
		temp decimal not null,
		chargeTest bit not null,
		brandModel nvarchar(250) not null,
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
		evaDescription nvarchar(250) not null,
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
		evaLectureOilColor nvarchar(10) not null,
		evaLectureOilLevel decimal not null,
		evaLectureCoolerColor nvarchar(10) not null,
		evaLectureCoolerLevel decimal not null,
		evaCheckOperatation nvarchar(10) not null,
		evaCheckNoise nvarchar(10) not null,
		evaCheckIsolated nvarchar(10)not null,
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
		condReview varchar(50) not null,
		condCleanElectricSystem bit not null,
		condClean bit not null,
		condLectureVoltageGroud decimal not null,
		condLectureVoltagePhases decimal not null,
		condLectureVoltageControl decimal not null,
		condLectureMotorCurrent decimal not null,
		condReviewThermostat nvarchar(50) not null,
		condModel nvarchar(50) not null,
		condSerialNumber nvarchar(50) not null,
		condBrand nvarchar(50) not null,
		observations nvarchar(255) not null,
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
-- 1    03/10/2013	SAG		Se Integran los SP iniciales:
--								blackstarDb.GetServicesScheduleStatus
--								blackstarDb.GetServiceOrders
--								blackstarDb.GetTickets
-- 								blackstarDb.UpdateTicketStatus
-- -----------------------------------------------------------------------------
-- 2    04/10/2013	SAG		Se Integra:evaDescription
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
-- 9   24/10/2013	SAG		Se Integra:
-- 								blackstarDb.AssignServiceOrder
-- 								blackstarDb.GetEquipmentByCustomer
-- -----------------------------------------------------------------------------
-- 10   20/11/2013	JAGH	Se Integra:
-- 								blackstarDb.GetAirCoServiceByIdService
-- 								blackstarDb.GetBatteryServiceByIdService
--                              blackstarDb.GetCellBatteryServiceByIdBatteryService
-- 								blackstarDb.GetEmergencyPlantServiceByIdService
-- 								blackstarDb.GetPlainServiceServiceByIdService
-- 								blackstarDb.GetUPSServiceByIdService
-- -----------------------------------------------------------------------------
-- 11   25/11/2013	JAGH	Se Integra:
-- 								blackstarDb.GetPolicyBySerialNo
-- -----------------------------------------------------------------------------
-- 12   13/11/2013	SAG		Se Integra:
-- 								blackstarDb.GetOfficesList
-- -----------------------------------------------------------------------------
-- 13   13/11/2013	SAG		Se Sustituye:
-- 								blackstarDb.GetEquipmentByCustomer por
-- 								blackstarDb.GetEquipmentList
--							Se Integra:
-- 								blackstarDb.GetProjectList
-- 								blackstarDb.GetDomainEmployeesByGroup
--								blackstarDb.AddScheduledServicePolicy
--								blackstarDb.AddScheduledServiceEmployee
--								blackstarDb.AddScheduledServiceDate
-- 								blackstarDb.GetFutureServicesSchedule
--							Se Reescribe:
-- 								blackstarDb.GetServicesSchedule
-- -----------------------------------------------------------------------------
-- 14   21/11/2013	SAG		Se Integra:
-- 								blackstarDb.GetAllServiceOrders
-- 								blackstarDb.CloseOS
-- -----------------------------------------------------------------------------
-- 15   26/11/2013	JAGH	Se Integra:
-- 								blackstarDb.AddAAservice
-- 								blackstarDb.AddBBcellservice
-- 								blackstarDb.AddBBservice
-- 								blackstarDb.AddepService
--                              blackstarDb.AddepServiceSurvey
--                              blackstarDb.AddepServiceWorkBasic
--                              blackstarDb.AddepServiceDynamicTest
-- 								blackstarDb.AddepServiceTestProtection
-- 								blackstarDb.AddepServiceTransferSwitch
-- 								blackstarDb.AddepServiceLectures
-- 								blackstarDb.AddepServiceParams
-- 								blackstarDb.AddplainService
-- 								blackstarDb.AddupsService
-- 								blackstarDb.AddupsServiceBatteryBank
--								blackstarDb.AddupsServiceGeneralTest
-- 								blackstarDb.AddupsServiceParams
-- 								blackstarDb.AddserviceOrder
-- 								blackstarDb.UpdateServiceOrder
-- -----------------------------------------------------------------------------
-- 16   25/11/2013	SAG		Se Integra:
-- 								blackstarDb.GetUserGroups
-- -----------------------------------------------------------------------------
-- 17   12/12/2013	SAG		Se Integra:
-- 								blackstarDb.GetNextServiceOrderNumber 
-- 								blackstarDb.CommitServiceOrderNumber 
-- 								blackstarDb.LoadNewSequencePoolItems 
-- 								blackstarDb.GetAndIncreaseSequence 
-- 								blackstarDb.GetNextServiceNumberForEquipment 
-- -----------------------------------------------------------------------------
-- 18   26/12/2013	SAG		Se Integra:
-- 								blackstarDb.GetScheduledServices 
-- 								blackstarDb.GetAssignedTickets 
-- -----------------------------------------------------------------------------
-- 19   31/12/2013	SAG		Fix:
-- 								blackstarDb.GetUserData 
-- -----------------------------------------------------------------------------
-- 21   02/01/2014	SAG		Se Integra:
-- 								blackstarDb.GetPersonalServiceOrders 
-- -----------------------------------------------------------------------------
-- 22   03/01/2014	SAG		Se Integra:
-- 								blackstarDb.GetAllServiceOrders 
-- 								blackstarDb.GetEquipmentByType 
-- -----------------------------------------------------------------------------
-- 23   05/01/2014	SAG		Se Integra:
-- 								blackstarDb.GetServiceTypeList
-- 								blackstarDb.GetServiceTypeById
-- 								blackstarDb.GetEquipmentTypeBySOId
-- -----------------------------------------------------------------------------
-- 24   07/01/2014	SAG		Se Integra:
-- 								blackstarDb.GetServiceStatusList
--							Se actualiza:
--								blackstarDb.AddFollowUpToOS
-- -----------------------------------------------------------------------------
-- 25   13/01/2014	SAG		Se Integra:
-- 								blackstarDb.GetNextServiceNumberForTicket
--							Se modifica:
--								blackstarDb.AddserviceOrder
-- -----------------------------------------------------------------------------
-- 26   30/01/2014	SAG		Se Integra:
-- 								blackstarDb.LastError
-- -----------------------------------------------------------------------------
-- 26   09/02/2014	SAG		Se Corrigen:
-- 								blackstarDb.GetServiceOrders
-- 								blackstarDb.GetPersonalServiceOrders
--							Se Integra:
--								blackstarDb.GetServiceOrderById
--								blackstarDb.GetServiceOrderByNumber
--								blackstarDb.GetServiceOrderEmployeeList
--								blackstarDb.AddServiceOrderEmployee
--								blackstarDb.GetAutocompleteEmployeeList
-- -----------------------------------------------------------------------------
-- 26   10/02/2014	SAG		Se Corrigen:
-- 								blackstarDb.GetAirCoServiceByIdService
--								blackstarDb.GetBatteryServiceByIdService
--								blackstarDb.GetEmergencyPlantServiceByIdService
--								blackstarDb.GetUPSServiceByIdService
-- -----------------------------------------------------------------------------


use blackstarDb;

DELIMITER $$


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
	WHERE g.externalId = pUserGroup
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
	-- blackstarDb.GetEquipmentTypeBySOId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentTypeBySOId$$
CREATE PROCEDURE blackstarDb.GetEquipmentTypeBySOId(pServiceOrderId INT)
BEGIN

	SELECT 
		equipmentTypeId AS equipmentTypeId
	FROM serviceOrder so
		INNER JOIN policy p ON so.policyId = p.policyId
	WHERE serviceOrderId = pServiceOrderId;

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
	
	IF(pEquipmentTypeId = 'X') THEN
		SELECT 
			concat_ws(' - ', brand, model, serialNumber) AS label,
			serialNumber AS value
		FROM policy p
		WHERE equipmentTypeId NOT IN('A', 'B', 'P', 'U')
		AND p.startDate < CURDATE() AND p.endDate > CURDATE()
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
		ss.serviceStatus AS serviceStatus
	FROM serviceOrder so 
		INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
		INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
		INNER JOIN policy p ON so.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmenttypeId = et.equipmenttypeId
		INNER JOIN office of on p.officeId = of.officeId
     LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
	ORDER BY so.ServiceOrderId DESC;
	
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
		customer AS customer,
		project AS project,
		serialNumber AS serialNumber,
		officeName AS officeName,
		brand AS brand,
		us.name AS employee
	FROM blackstarDb.scheduledService s
		INNER JOIN blackstarDb.scheduledServicePolicy sp ON sp.scheduledServiceId = s.scheduledServiceId
		INNER JOIN blackstarDb.scheduledServiceDate sd ON sd.scheduledServiceId = s.scheduledServiceId
		INNER JOIN blackstarDb.policy p ON sp.policyId = p.policyId
		INNER JOIN blackstarDb.serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		INNER JOIN blackstarDb.equipmentType et ON et.equipmentTypeId = p.equipmentTypeId
		INNER JOIN blackstarDb.scheduledServiceEmployee em ON em.scheduledServiceId = s.scheduledServiceId AND em.isDefault = 1
		INNER JOIN blackstarDb.blackstarUser us ON us.email = em.employeeId
		INNER JOIN blackstarDb.office o ON o.officeId = p.officeId
	WHERE s.serviceStatusId = 'P'
		AND serviceDate >= pServiceDate
	ORDER BY equipmentType;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddScheduledServiceEmployee
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddScheduledServiceDate$$
CREATE PROCEDURE blackstarDb.AddScheduledServiceDate(pScheduledServiceId INTEGER, pDate DATETIME, pUser VARCHAR(100))
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
		'AddScheduledServiceDate',
		pUser;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetPersonalServiceOrders
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPersonalServiceOrders$$
CREATE PROCEDURE blackstarDb.GetPersonalServiceOrders(pUser VARCHAR(100), pStatus VARCHAR(50))
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
	where serviceStatus = pStatus
	AND (so.asignee = pUser OR so.responsible = pUser)
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
CREATE PROCEDURE blackstarDb.AddScheduledServiceEmployee(pScheduledServiceId INTEGER, pEmployeeId VARCHAR(100), pIsDefault TINYINT, pUser VARCHAR(100))
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
		'AddScheduledServiceEmployee',
		pUser;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddScheduledServicePolicy
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddScheduledServicePolicy$$
CREATE PROCEDURE blackstarDb.AddScheduledServicePolicy(pScheduledServiceId INTEGER, pPolicyId INTEGER, pUser VARCHAR(100))
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
		'AddScheduledServicePolicy',
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
	-- blackstarDb.GetNextServiceNumberForEquipment
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextServiceNumberForEquipment$$
CREATE PROCEDURE blackstarDb.GetNextServiceNumberForEquipment(pPolicyId INTEGER)
BEGIN

	DECLARE eqType VARCHAR(10);
	DECLARE prefix VARCHAR(10);
	DECLARE newNumber INTEGER;

	-- Obteniendo el tipo de equipo
	SELECT equipmentTypeId into eqType FROM policy WHERE policyId = pPolicyId;
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
	WHERE g.externalId = pUserGroup
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
CREATE PROCEDURE blackstarDb.CloseTicket(pTicketId INTEGER, pOsId INTEGER, pModifiedBy VARCHAR(100))
BEGIN
	
	-- ACTUALIZAR EL ESTATUS DEL TICKET Y NUMERO DE ORDEN DE SERVICIO
	UPDATE ticket t 
		INNER JOIN ticket t2 on t.ticketId = t2.ticketId
	SET 
		t.ticketStatusId = IF(t2.ticketStatusId = 'R', 'F', 'C'),
		t.serviceOrderId = pOsId,
		t.modified = NOW(),
		t.modifiedBy = 'CloseTicket',
		t.modifiedByUsr = pModifiedBy
	WHERE t.ticketId = pTicketId;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToOS
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

	UPDATE serviceOrder SET
		serviceStatusId = 'E'
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

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertScheduledService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertScheduledService$$
CREATE PROCEDURE blackstarDb.UpsertScheduledService(pScheduledServiceId INTEGER, pUser VARCHAR(100) )
BEGIN

	IF pScheduledServiceId = 0 THEN
		INSERT INTO scheduledService(
			serviceStatusId,
			created,
			createdBy,
			createdByUsr
		)
		SELECT 
			'P', NOW(), 'UpsertScheduledService', pUser;
			
		SET pScheduledServiceId = LAST_INSERT_ID();
	END IF;
	
	UPDATE scheduledService SET
			serviceStatusId = 'P',
			modified = NOW(),
			modifiedBy = 'UpsertScheduledService',
			modifiedByUsr = pUser
	WHERE scheduledServiceId = pScheduledServiceId;
	
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
		customer AS customer,
		project AS project,
		serialNumber AS serialNumber,
		us.name AS employee
	FROM blackstarDb.scheduledService s
		INNER JOIN blackstarDb.scheduledServicePolicy sp ON sp.scheduledServiceId = s.scheduledServiceId
		INNER JOIN blackstarDb.scheduledServiceDate sd ON sd.scheduledServiceId = s.scheduledServiceId
		INNER JOIN blackstarDb.policy p ON sp.policyId = p.policyId
		INNER JOIN blackstarDb.serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		INNER JOIN blackstarDb.equipmentType et ON et.equipmentTypeId = p.equipmentTypeId
		INNER JOIN blackstarDb.scheduledServiceEmployee em ON em.scheduledServiceId = s.scheduledServiceId AND em.isDefault = 1
		INNER JOIN blackstarDb.blackstarUser us ON us.email = em.employeeId
	WHERE s.serviceStatusId = 'P'
		AND serviceDate = pServiceDate
	ORDER BY equipmentType;
	
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
	WHERE tk.created > '01-01' + YEAR(NOW())
    ORDER BY tk.created DESC;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrders
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrders$$
CREATE PROCEDURE blackstarDb.GetServiceOrders(IN status VARCHAR(200))
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
	WHERE ss.serviceStatus IN(status) 
	ORDER BY serviceDate DESC ;
	
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
  serviceOrderId int(11) ,
  evaDescription varchar(250) ,
  evaValTemp decimal(10,0) ,
  evaValHum decimal(10,0) ,
  evaSetpointTemp decimal(10,0) ,
  evaSetpointHum decimal(10,0) ,
  evaFlagCalibration bit(1) ,
  evaReviewFilter bit(1) ,
  evaReviewStrip bit(1) ,
  evaCleanElectricSystem bit(1) ,
  evaCleanControlCard bit(1) ,
  evaCleanTray bit(1) ,
  evaLectrurePreasureHigh decimal(10,0) ,
  evaLectrurePreasureLow decimal(10,0) ,
  evaLectureTemp decimal(10,0) ,
  evaLectureOilColor varchar(10) ,
  evaLectureOilLevel decimal(10,0) ,
  evaLectureCoolerColor varchar(10) ,
  evaLectureCoolerLevel decimal(10,0) ,
  evaCheckOperatation varchar(10) ,
  evaCheckNoise varchar(10) ,
  evaCheckIsolated varchar(10) ,
  evaLectureVoltageGroud decimal(10,0) ,
  evaLectureVoltagePhases decimal(10,0) ,
  evaLectureVoltageControl decimal(10,0) ,
  evaLectureCurrentMotor1 decimal(10,0) ,
  evaLectureCurrentMotor2 decimal(10,0) ,
  evaLectureCurrentMotor3 decimal(10,0) ,
  evaLectureCurrentCompressor1 decimal(10,0) ,
  evaLectureCurrentCompressor2 decimal(10,0) ,
  evaLectureCurrentCompressor3 decimal(10,0) ,
  evaLectureCurrentHumidifier1 decimal(10,0) ,
  evaLectureCurrentHumidifier2 decimal(10,0) ,
  evaLectureCurrentHumidifier3 decimal(10,0) ,
  evaLectureCurrentHeater1 decimal(10,0) ,
  evaLectureCurrentHeater2 decimal(10,0) ,
  evaLectureCurrentHeater3 decimal(10,0) ,
  evaCheckFluidSensor bit(1) ,
  evaRequirMaintenance bit(1) ,
  condReview varchar(50) ,
  condCleanElectricSystem bit(1) ,
  condClean bit(1) ,
  condLectureVoltageGroud decimal(10,0) ,
  condLectureVoltagePhases decimal(10,0) ,
  condLectureVoltageControl decimal(10,0) ,
  condLectureMotorCurrent decimal(10,0) ,
  condReviewThermostat varchar(50) ,
  condModel varchar(50) ,
  condSerialNumber varchar(50) ,
  condBrand varchar(50) ,
  observations varchar(255) ,
  created datetime ,
  createdBy varchar(50) ,
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
CREATE PROCEDURE blackstarDb.AddBBcellservice (bbServiceId int(11) , cellNumber int(11) , floatVoltage int(11) , chargeVoltage int(11))
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
   voltageBus  int(11)  ,
   temperature  int(11)  ,
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
   transferType  varchar(50)  ,
   modelTransfer  varchar(50)  ,
   modelControl  varchar(50)  ,
   modelRegVoltage  varchar(50)  ,
   modelRegVelocity  varchar(50)  ,
   modelCharger  varchar(50)  ,
   oilChange  date  ,
   brandMotor  varchar(50)  ,
   modelMotor  varchar(50)  ,
   serialMotor  varchar(50)  ,
   cplMotor  varchar(50)  ,
   brandGenerator  varchar(50)  ,
   modelGenerator  varchar(50)  ,
   serialGenerator  varchar(50)  ,
   powerWattGenerator  int(11)  ,
   tensionGenerator  int(11)  ,
   tuningDate  date  ,
   tankCapacity  int(11)  ,
   pumpFuelModel  varchar(50)  ,
   filterFuelFlag  bit(1)  ,
   filterOilFlag  bit(1)  ,
   filterWaterFlag  bit(1)  ,
   filterAirFlag  bit(1)  ,
   brandGear  varchar(50)  ,
   brandBattery  varchar(50)  ,
   clockLecture  varchar(50)  ,
   serviceCorrective  date  ,
   observations  varchar(50)  ,
   created  datetime  ,
   createdBy  varchar(50)  ,
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
   levelBattery  int(11)  ,
   tubeLeak  bit(1)  ,
   batteryCap  varchar(50)  ,
   batterySulfate  varchar(50)  ,
   levelOil  int(11)  ,
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
   vacuumFrequency  decimal(10,0)  ,
   chargeFrequency  decimal(10,0)  ,
   bootTryouts  int(11)  ,
   vacuumVoltage  decimal(10,0)  ,
   chargeVoltage  decimal(10,0)  ,
   qualitySmoke  decimal(10,0)  ,
   startTime  int(11)  ,
   transferTime  int(11)  ,
   stopTime  int(11) 
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
   tempSensor  int(11)  ,
   oilSensor  int(11)  ,
   voltageSensor  int(11)  ,
   overSpeedSensor  int(11)  ,
   oilPreasureSensor  int(11) ,
    waterLevelSensor  int(11) 
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
   mechanicalStatus  varchar(10)  ,
   boardClean  bit(1)  ,
	lampTest  bit(1)  ,
   screwAdjust  bit(1)  ,
   conectionAdjust  bit(1)  ,
   systemMotors  varchar(10)  ,
   electricInterlock  varchar(10)  ,
   mechanicalInterlock  varchar(10)  ,
   capacityAmp  int(11)  
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
   voltageABAN  int(11)  ,
   voltageACCN  int(11)  ,
   voltageBCBN  int(11)  ,
   voltageNT  int(11)  ,
   currentA  int(11)  ,
   currentB  int(11)  ,
   currentC  int(11)  ,
   frequency  int(11)  ,
   oilPreassure  int(11)  ,
   temp  int(11)  
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
   troubleDescription  varchar(255)  ,
   techParam  varchar(255)  ,
   workDone  varchar(255)  ,
   materialUsed  varchar(255)  ,
   observations  varchar(255)  ,
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
  manufacturedDateSerial varchar(10) ,
  damageBatteries varchar(50) ,
  other varchar(250) ,
  temp decimal(10,0) ,
  chargeTest bit(1) ,
  brandModel varchar(250) ,
  batteryVoltage decimal(10,0) 
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
  trasferLine decimal(10,0) ,
  transferEmergencyPlant decimal(10,0) ,
  backupBatteries decimal(10,0) ,
  verifyVoltage decimal(10,0) 
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
  inputVoltagePhase decimal(10,0) ,
  inputVoltageNeutro decimal(10,0) ,
  inputVoltageNeutroGround decimal(10,0) ,
  percentCharge decimal(10,0) ,
  outputVoltagePhase decimal(10,0) ,
  outputVoltageNeutro decimal(10,0) ,
  inOutFrecuency decimal(10,0) ,
  busVoltage decimal(10,0) 
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
  receivedByEmail varchar(100)
)
BEGIN
insert into serviceOrder
(serviceOrderNumber,serviceTypeId,ticketId,policyId,serviceUnit,serviceDate,responsible,additionalEmployees,receivedBy,serviceComments,serviceStatusId,closed,consultant,coordinator,asignee,hasErrors,isWrong,signCreated,signReceivedBy,receivedByPosition,created,createdBy,createdByUsr,receivedByEmail)
values
(serviceOrderNumber,serviceTypeId,ticketId,policyId,serviceUnit,serviceDate,responsible,additionalEmployees,receivedBy,serviceComments,serviceStatusId,closed,consultant,coordinator,asignee,hasErrors,isWrong,signCreated,signReceivedBy,receivedByPosition,created,createdBy,createdByUsr,receivedByEmail);
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
  modifiedByUsr varchar(50) 
)
BEGIN
UPDATE serviceOrder
SET
serviceStatusId = serviceStatusId ,
closed = closed ,
asignee = asignee ,
isWrong = isWrong,
modified = modified ,
modifiedBy = modifiedBy ,
modifiedByUsr = modifiedByUsr 
where serviceOrderId = serviceOrderId;
END$$


-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;


-- -----------------------------------------------------
-- File:	blackstarDbTransfer_Schema.sql    
-- Name:	blackstarDbTransfer_Schema
-- Desc:	Implementa cambios en el esquema de la BD blackstarDbTransfer
-- Auth:	Sergio A Gomez
-- Date:	20/12/2013
-- -----------------------------------------------------
-- Change History
-- -----------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    08/08/2013  SAG  	Se aumenta el tamaño de ticket.serialNumber
-- -----------------------------------------------------

USE blackstarDbTransfer;

ALTER TABLE blackstarDbTransfer.ticket MODIFY serialNumber VARCHAR(100) NULL DEFAULT NULL;


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

use blackstarDbTransfer;


DELIMITER $$
-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEquipmentByCustomer
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
	SELECT bt.ticketId, 'marlem.samano@gposac.com.mx', tt.followUp, 1, NOW(), 'TicketTransfer', 'sergio.aga'
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
		ot.serviceComments, ot.closed, ot.consultant, CURRENT_DATE(), 'ServiceOrderTransfer', 'sergio.aga'
	FROM blackstarDbTransfer.serviceTx ot
		LEFT OUTER JOIN blackstarDb.ticket t ON t.ticketNumber = ot.ticketNumber
		LEFT OUTER JOIN blackstarDb.policy p ON p.serialNumber = ot.serialNumber AND ot.serialNumber != 'NA'
	WHERE ot.serviceNumber NOT IN (SELECT serviceOrderNumber FROM blackstarDb.serviceOrder);
		
	-- ACTUALIZACION DEL STATUS
	UPDATE blackstarDb.serviceOrder SET
		serviceStatusId = CASE WHEN (closed IS NULL) THEN 'E' ELSE 'C' END;
		
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
	SELECT o.serviceOrderId, 'angeles.avila@gposac.com.mx', st.followUp, 1, NOW(), 'TicketTransfer', 'sergio.aga'
	FROM blackstarDbTransfer.serviceTx st 
		INNER JOIN blackstarDb.serviceOrder o ON st.serviceNumber = o.serviceOrderNumber
		LEFT OUTER JOIN blackstarDb.followUp f ON o.serviceOrderId = f.serviceOrderId
	WHERE st.followUp IS NOT NULL
	AND f.followUpId IS NULL;
	
	-- ACTUALIZACION DEL SERVICE ID DE CIERRE DEL TICKET
	UPDATE blackstarDb.ticket t
		INNER JOIN blackstarDbTransfer.ticket tt ON t.ticketNumber = tt.ticketNumber
		INNER JOIN blackstarDb.serviceOrder so ON tt.serviceOrderNumber = so.serviceOrderNumber	
	SET
		t.serviceOrderId = so.serviceOrderId;	
	
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

	UPDATE blackstarDb.followUp SET	
		followUp = REPLACE( followUp,'\n','');
-- -----------------------------------------------------------------------------
END$$

-- -----------------------------------------------------------------------------
	-- FIN 
-- -----------------------------------------------------------------------------
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
-- SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------
use blackstarDbTransfer;

UPDATE blackstarDb.sequence SET description = 'Ordenes de servicio tipo AA' WHERE sequenceTypeId = 'A' AND description IS NULL;
UPDATE blackstarDb.sequence SET description = 'Ordenes de servicio tipo BB' WHERE sequenceTypeId = 'B' AND description IS NULL;
UPDATE blackstarDb.sequence SET description = 'Ordenes de servicio tipo General' WHERE sequenceTypeId = 'O' AND description IS NULL;
UPDATE blackstarDb.sequence SET description = 'Ordenes de servicio tipo PE' WHERE sequenceTypeId = 'P' AND description IS NULL;
UPDATE blackstarDb.sequence SET description = 'Ordenes de servicio tipo UPS' WHERE sequenceTypeId = 'U' AND description IS NULL;

CALL ExecuteTransfer();
-- -----------------------------------------------------------------------------
-- FIN - SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- Desc:	Cambia el esquema de la bd
-- Auth:	Daniel Castillo Berm�dez
-- Date:	11/11/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author   	Description
-- --   --------   -------  ------------------------------------
-- 1    20/06/2014  DCB   	Version inicial
-- --   --------   -------  ------------------------------------
-- 2    13/08/2014  SAG     Se agrega blackstarDb.cstOffice
-- --   --------   -------  ------------------------------------
-- 3    01/10/2014  SAG     Se agrega blackstarDb.codexIncoterm
-- ---------------------------------------------------------------------------

USE blackstarDb;

DELIMITER $$

CREATE TABLE IF NOT EXISTS blackstarDb.location(
  _id INT NOT NULL AUTO_INCREMENT,
  zipCode VARCHAR(20) NOT NULL,
  country TEXT NOT NULL,
  state TEXT NOT NULL,
  municipality TEXT NOT NULL,
  city TEXT,
  neighborhood TEXT NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexClientType(
  _id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexClientOrigin(
  _id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexClient(
  _id INT NOT NULL AUTO_INCREMENT,
  clientTypeId INT,
  clientOriginId INT,
  sellerId INT(100),
  sellerName VARCHAR(200),
  isProspect Tinyint,
  rfc VARCHAR(100),
  corporateName TEXT,
  tradeName TEXT,
  phoneArea VARCHAR(50),
  phoneNumber VARCHAR(100),
  phoneExtension VARCHAR(50),
  phoneAreaAlt VARCHAR(50),
  phoneNumberAlt VARCHAR(50),
  phoneExtensionAlt VARCHAR(50),
  email VARCHAR(200),
  emailAlt VARCHAR(200),
  street TEXT,
  intNumber VARCHAR(100),
  extNumber VARCHAR(100),
  zipCode INT(100),
  country TEXT,
  state VARCHAR(100),
  municipality TEXT,
  city TEXT,
  neighborhood TEXT,
  contactName TEXT,
  curp VARCHAR(100),
  retention VARCHAR(100),
  PRIMARY KEY (_id),
  FOREIGN KEY (clientTypeId) REFERENCES codexClientType (_id),
  FOREIGN KEY (clientOriginId) REFERENCES codexClientOrigin (_id),
  FOREIGN KEY (sellerId) REFERENCES blackstaruser (blackstarUserId)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexStatusType( 
  _id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexPaymentType(
  _id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexCurrencyType(
  _id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexTaxesTypes(
  _id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  value DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexCostCenter(
  _id INT NOT NULL AUTO_INCREMENT,
  costCenter VARCHAR(200),
  created DATETIME NULL,
  createdBy NVARCHAR(100) NULL,
  createdByUsr INT NULL,
  modified DATETIME NULL,
  modifiedBy NVARCHAR(100) NULL,
  modifiedByUsr INT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexProject(
  _id INT NOT NULL AUTO_INCREMENT,
  clientId INT NOT NULL,
  taxesTypeId INT NOT NULL,
  statusId INT NOT NULL,
  paymentTypeId INT NOT NULL,
  currencyTypeId INT NOT NULL,
  projectNumber VARCHAR(100) NOT NULL,
  costCenterId INT NOT NULL,
  changeType Float NOT NULL,
  contactName TEXT NOT NULL,
  location VARCHAR(400),
  advance Float(7,2),
  timeLimit INT,
  settlementTimeLimit INT,
  deliveryTime INT,
  incoterm VARCHAR(50),
  productsNumber INT,
  financesNumber INT,
  servicesNumber INT,
  totalProjectNumber INT,
  created DATETIME NULL,
  createdBy NVARCHAR(100) NULL,
  createdByUsr INT NULL,
  modified DATETIME NULL,
  modifiedBy NVARCHAR(100) NULL,
  modifiedByUsr INT NULL,
  PRIMARY KEY (_id),
  FOREIGN KEY (statusId) REFERENCES codexStatusType (_id),
  FOREIGN KEY (paymentTypeId) REFERENCES codexPaymentType (_id),
  FOREIGN KEY (currencyTypeId) REFERENCES codexCurrencyType (_id),
  FOREIGN KEY (taxesTypeId) REFERENCES codexTaxesTypes (_id),
  FOREIGN KEY (clientId) REFERENCES codexClient (_id),
  FOREIGN KEY (createdByUsr) REFERENCES blackstarUser (blackstarUserId),
  FOREIGN KEY (modifiedByUsr) REFERENCES blackstarUser (blackstarUserId),
  FOREIGN KEY (costCenterId) REFERENCES codexCostCenter (_id)
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS blackstarDb.codexProjectEntryTypes(
  _id INT NOT NULL,
  name VARCHAR(200) NOT NULL,
  productType CHAR(1) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexProjectEntry(
  _id INT NOT NULL AUTO_INCREMENT,
  projectId INT NOT NULL,
  entryTypeId INT NOT NULL,
  description TEXT NOT NULL,
  discount Float(6,2) NOT NULL,
  totalPrice Float(9,2) NOT NULL,
  comments TEXT NOT NULL,
  PRIMARY KEY (_id),
  FOREIGN KEY (projectId) REFERENCES codexProject (_id),
  FOREIGN KEY (entryTypeId) REFERENCES codexProjectEntryTypes (_id)
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS blackstarDb.codexProjectItemTypes(
  _id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(200) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexEntryItem(
  _id INT NOT NULL AUTO_INCREMENT,
  entryId INT NOT NULL,
  itemTypeId INT NOT NULL,
  reference TEXT ,
  description TEXT NOT NULL,
  quantity INT NOT NULL,
  priceByUnit Float(10,2) NOT NULL,
  discount Float(10,2) NOT NULL,
  totalPrice Float(10,2) NOT NULL,
  comments TEXT,
  PRIMARY KEY (_id),
  FOREIGN KEY (entryId) REFERENCES codexProjectEntry (_id),
  FOREIGN KEY (itemTypeId) REFERENCES codexProjectItemTypes (_id)
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS blackstarDb.codexPriceList(
  _id INT NOT NULL AUTO_INCREMENT,
  code VARCHAR(200) NOT NULL,
  name VARCHAR(400) NOT NULL,
  price Float(10,2) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.workTeam(
  _id INT NOT NULL AUTO_INCREMENT,
  ticketId INT,
  codexProjectId INT,
  workerRoleTypeId INT NOT NULL,
  blackstarUserId INT NOT NULL,
	assignedDate Datetime NOT NULL,
  PRIMARY KEY (`_id`),
  -- FOREIGN KEY (ticketId) REFERENCES bloomTicket (_id),
  -- FOREIGN KEY (workerRoleTypeId) REFERENCES bloomWorkerRoleType (_id),
  FOREIGN KEY (blackstarUserId) REFERENCES blackstarUser (blackstarUserId),
  FOREIGN KEY (codexProjectId) REFERENCES codexProject (_id)
)ENGINE=INNODB;
		 
CREATE TABLE IF NOT EXISTS blackstarDb.codexDeliverableType(
    _id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(400) NOT NULL,
    PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexDeliverableTrace(
    _id INT NOT NULL AUTO_INCREMENT,
	codexProjectId INT NOT NULL,
    deliverableTypeId INT NOT NULL,
	created Date NOT NULL,
	userId INT NOT NULL,
	PRIMARY KEY (_id),
    FOREIGN KEY (deliverableTypeId) REFERENCES codexDeliverableType (_id),
	FOREIGN KEY (codexProjectId) REFERENCES codexProject (_id)
)ENGINE=INNODB;
		 
CREATE TABLE IF NOT EXISTS blackstarDb.codexPriceProposal(
  _id INT NOT NULL AUTO_INCREMENT,
  projectId INT NOT NULL,
  priceProposalNumber VARCHAR(11) NOT NULL,
  clientId INT NOT NULL,
  taxesTypeId INT NOT NULL,
  paymentTypeId INT NOT NULL,
  currencyTypeId INT NOT NULL,
  costCenter VARCHAR(50) NOT NULL,
  changeType Float NOT NULL,
  contactName TEXT NOT NULL,
  location VARCHAR(400) NOT NULL,
  advance Float(10,2) NOT NULL,
  timeLimit INT NOT NULL,
  settlementTimeLimit INT NOT NULL,
  deliveryTime INT NOT NULL,
  incoterm VARCHAR(5) NOT NULL,
  productsNumber INT NOT NULL,
  financesNumber INT NOT NULL,
  servicesNumber INT NOT NULL,
  totalProjectNumber INT NOT NULL,
  created DATETIME NOT NULL,
  PRIMARY KEY (_id),
  FOREIGN KEY (projectId) REFERENCES codexProject (_id),
  FOREIGN KEY (paymentTypeId) REFERENCES codexPaymentType (_id),
  FOREIGN KEY (currencyTypeId) REFERENCES codexCurrencyType (_id),
  FOREIGN KEY (taxesTypeId) REFERENCES codexTaxesTypes (_id),
  FOREIGN KEY (clientId) REFERENCES codexClient (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexPriceProposalEntry(
  _id INT NOT NULL,
  priceProposalId INT NOT NULL,
  entryTypeId INT NOT NULL,
  description TEXT NOT NULL,
  discount Float(6,2) NOT NULL,
  totalPrice Float(9,2) NOT NULL,
  comments TEXT NOT NULL,
  PRIMARY KEY (_id),
  FOREIGN KEY (priceProposalId) REFERENCES codexPriceProposal (_id),
  FOREIGN KEY (entryTypeId) REFERENCES codexProjectEntryTypes (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexPriceProposalItem(
  _id INT NOT NULL AUTO_INCREMENT,
  priceProposalEntryId INT NOT NULL,
  itemTypeId INT NOT NULL,
  reference TEXT ,
  description TEXT NOT NULL,
  quantity INT NOT NULL,
  priceByUnit Float(8,2) NOT NULL,
  discount Float(6,2) NOT NULL,
  totalPrice Float(10,2) NOT NULL,
  comments TEXT,
  PRIMARY KEY (_id),
  FOREIGN KEY (priceProposalEntryId) REFERENCES codexPriceProposalEntry (_id),
  FOREIGN KEY (itemTypeId) REFERENCES codexProjectItemTypes (_id)
)ENGINE=INNODB;		 

CREATE TABLE IF NOT EXISTS blackstarDb.cstOffice(
  _id INT NOT NULL AUTO_INCREMENT,
  cstId VARCHAR(200) NOT NULL,
  officeId CHAR(1) NOT NULL,
  PRIMARY KEY (_id),
  UNIQUE (cstId)
  -- FOREIGN KEY (officeId) REFERENCES office (officeId)
)ENGINE=INNODB;

$$

DELIMITER ;


-- ---------------------------------------------------------------------------
-- Desc:	Cambia el esquema de la bd
-- Auth:	Daniel Castillo Berm�dez
-- Date:	11/11/2013
-- ---------------------------------------------------------------------------
-- Change History
-- ---------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- ---------------------------------------------------------------------------
-- 1    20/06/2014  DCB  	Version inicial
-- ---------------------------------------------------------------------------
-- 2    13/08/2014  SAG  	Separacion CreateSchema y Schema
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
-- 1    24/06/2014  DCB		  Se Integran los SP iniciales:
--								              blackstarDb.GetCodexAllStates
-- --   --------   -------  ------------------------------------
-- 2    13/08/2014  SAG     Se agrega:
--                              blackstarDb.GetCostCenterList
--                              blackstarDb.GetCSTOffice
-- -----------------------------------------------------------------------------
-- 3    01/09/2014  SAG     Se modifica:
--                              blackstarDb.CodexGetProjectsByStatusAndUser
--                              blackstarDb.CodexGetAllProjectsByUsr
--                              blackstarDb.CodexGetProjectsByStatus
--                              blackstarDb.CodexUpsertProject
--                              blackstarDb.CodexUpsertProjectEntry
--                          Se agrega: 
--                              blackstarDb.UpsertCodexCostCenter
--                              blackstarDb.GetCodexPriceList
--                          Se elimina:
--                              blackstarDb.GetNextEntryId
-- -----------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$



-- -----------------------------------------------------------------------------
  -- blackstarDb.GetCodexPriceList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetCodexPriceList$$
CREATE PROCEDURE blackstarDb.GetCodexPriceList()
BEGIN

  SELECT 
    _id AS id,
    code AS model,
    name AS name,
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

  SELECT officeId FROM blackstarDb.cstOffice WHERE cstId = pCst LIMIT 1;
  
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
  FROM location loc 
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
   FROM location
   WHERE zipCode = pZipCode;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertClient
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexInsertClient$$
CREATE PROCEDURE blackstarDb.`CodexInsertClient`(pClientTypeId int(2), pClientOriginId int(2), pSellerId int(11)
                                                 , pIsProspect tinyint(4), pRfc varchar(13), pCorporateName text, pTradeName text, pPhoneArea varchar(3), pPhoneNumber varchar(10)
                                                 , pPhoneExtension varchar(6), pPhoneAreaAlt varchar(3), pPhoneNumberAlt varchar(10), pPhoneExtensionAlt varchar(6)
                                                 , pEmail varchar(60), pEmailAlt varchar(60), pStreet text, pIntNumber varchar(5), pExtNumber varchar(5)
                                                 , pZipCode int(5), pCountry text, pState varchar(20), pMunicipality text, pCity text, pNeighborhood text
                                                 , pContactName text, pCurp varchar(18), pRetention varchar(20))
BEGIN

	INSERT INTO codexClient (clientTypeId, clientOriginId, sellerId, isProspect, rfc, corporateName,
              tradeName, phoneArea, phoneNumber, phoneExtension, phoneAreaAlt, phoneNumberAlt,
              phoneExtensionAlt, email, emailAlt, street, intNumber, extNumber, zipCode, country,
              state, municipality, city, neighborhood, contactName, curp, retention)
              VALUES
              (pClientTypeId, pClientOriginId, pSellerId, pIsProspect, pRfc, pCorporateName,
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

  SELECT IFNULL(MAX(_ID)  + 1, 1) FROM codexClient;
	
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
	-- blackstarDb.CodexGetEntryTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetEntryTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetEntryTypes`()
BEGIN

  SELECT  _id AS id, 
          name AS name, 
          productType AS productType
  FROM codexProjectEntryTypes;
	
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
CREATE PROCEDURE blackstarDb.`AddFollowUpToCodexProject`(pProjectId INTEGER, pCreatedByUsrId INTEGER, pAssignedUsrId INTEGER, pMessage TEXT)
BEGIN
  DECLARE pCreatedByUsrMail VARCHAR(100);
  DECLARE pAsigneeUsrMail VARCHAR(100);
  
  SET pCreatedByUsrMail = (SELECT email FROM blackstarUser WHERE blackstarUserId = pCreatedByUsrId);
  SET pAsigneeUsrMail = (SELECT email FROM blackstarUser WHERE blackstarUserId = pAssignedUsrId);
	INSERT INTO blackstarDb.followUp(codexProjectId, followup, created, createdBy, createdByUsr, asignee)
	VALUES(pProjectId, pMessage, NOW(), 'AddFollowUpToCodexProject', pCreatedByUsrMail, pAsigneeUsrMail);
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
      , cc.tradeName clientDescription, ccc.costCenter costCenter, cp.changeType changeType, cp.created created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.incoterm incoterm
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber, cp.createdBy createdBy, cp.createdByUsr createdByUsr
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr
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
CREATE PROCEDURE blackstarDb.`CodexInsertDeliverableTrace`(pProjectId int(11), pDeliverableId int(2), pUserId int(11))
BEGIN
	INSERT INTO codexDeliverableTrace (codexProjectId, deliverableTypeId, created, userId)
  VALUES (pProjectId, pDeliverableId, NOW(), pUserId);
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetReferenceTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetReferenceTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetReferenceTypes`(pItemTypeId int(2))
BEGIN
  IF (pItemTypeId = 1) THEN
      SELECT _id AS id, CONCAT_WS('-', code, name) AS name FROM codexPriceList;
  END IF;
  IF (pItemTypeId = 2) THEN
     SELECT bt._id as id, bt.ticketNumber as name FROM bloomTicket bt;
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
CREATE PROCEDURE blackstarDb.`CodexUpsertProjectEntry`(pEntryId int(11), pProjectId int(11), pEntryTypeId int(11), pDescription TEXT, pDiscount FLOAT(6,2), pTotalPrice FLOAT(9,2), pComments TEXT)
BEGIN
  DECLARE isUpdate INTEGER;
  SET isUpdate = (SELECT COUNT(*) FROM codexProjectEntry WHERE _id = pEntryId);
  
  IF(isUpdate = 0) THEN
    INSERT INTO codexProjectEntry (projectId, entryTypeId, description, discount, totalPrice, comments)
    VALUES (pProjectId, pEntryTypeId, pDescription, pDiscount, pTotalPrice, pComments);
    
    SELECT LAST_INSERT_ID();
  ELSE
    UPDATE  codexProjectEntry SET comments = pComments
    WHERE _id = pEntryId;

    SELECT pEntryId;
  END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexUpsertProjectEntryItem
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexUpsertProjectEntryItem$$
CREATE PROCEDURE blackstarDb.`CodexUpsertProjectEntryItem`(pItemId int(11),pEntryId int(11), pItemTypeId int(11), pReference TEXT, pDescription TEXT, pQuantity int(11), pPriceByUnit float(8,2), pDiscount float(6,2), pTotalPrice float(10,2), pComments TEXT)
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
CREATE PROCEDURE blackstarDb.`CodexUpsertProject`(pProjectId int(11), pClientId int(11), pTaxesTypeId int(1), pStatusId int(1), pPaymentTypeId int(1),pCurrencyTypeId int(2), pProjectNumber varchar(8), pCostCenter varchar(8), pChangeType float, pCreated varchar(40), pContactName text, pLocation varchar(400), pAdvance float(7,2), pTimeLimit int(3), pSettlementTimeLimit int(3), pDeliveryTime int(3), pincoterm varchar(5), pProductsNumber int(7), pFinancesNumber int(7), pServicesNumber int(7), pTotalProjectNumber int(8), pCreatedByUsr int(11), pModifiedByUsr int(11))
BEGIN
  DECLARE isUpdate INTEGER;
  SET isUpdate = (SELECT COUNT(*) FROM codexProject WHERE _id = pProjectId);

  IF(isUpdate = 0) THEN
     CALL UpsertCodexCostCenter(pCostCenter, pCreatedByUsr);
     SET @ccId = (SELECT _id FROM codexCostCenter WHERE costCenter = pCostCenter);

     INSERT INTO codexProject (clientId , taxesTypeId , statusId , paymentTypeId ,currencyTypeId , projectNumber , costCenterId , changeType , created , contactName , location , advance , timeLimit , settlementTimeLimit , deliveryTime , incoterm , productsNumber , financesNumber , servicesNumber , totalProjectNumber, createdByUsr)
     VALUES (pClientId , pTaxesTypeId , pStatusId , pPaymentTypeId ,pCurrencyTypeId , pProjectNumber , @ccId , pChangeType , pCreated , pContactName , pLocation , pAdvance , pTimeLimit , pSettlementTimeLimit , pDeliveryTime , pincoterm , pProductsNumber , pFinancesNumber , pServicesNumber , pTotalProjectNumber, pCreatedByUsr);

     SELECT LAST_INSERT_ID();
  ELSE
     UPDATE codexProject
     SET clientId = pClientId, taxesTypeId = pTaxesTypeId, statusId = pStatusId, paymentTypeId = pPaymentTypeId
         , currencyTypeId = pCurrencyTypeId, projectNumber = pProjectNumber, costCenterId = @ccId
         , changeType = pChangeType, created = pCreated, contactName = pContactName, location = pLocation
         , advance = pAdvance, timeLimit = pTimeLimit, settlementTimeLimit = pSettlementTimeLimit
         , deliveryTime = pDeliveryTime, incoterm = pincoterm, productsNumber = pProductsNumber
         , financesNumber = pFinancesNumber, servicesNumber = pServicesNumber, totalProjectNumber = pTotalProjectNumber
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

   SELECT * 
   FROM location
   WHERE zipCode = pZipCode;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexUpsertProspect
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexUpsertProspect$$
CREATE PROCEDURE blackstarDb.`CodexUpsertProspect`(pClientTypeId int(2), pClientOriginId int(2), pSellerId int(11)
                                                 , pIsProspect tinyint(4), pRfc varchar(13), pCorporateName text, pTradeName text, pPhoneArea varchar(3), pPhoneNumber varchar(10)
                                                 , pPhoneExtension varchar(6), pPhoneAreaAlt varchar(3), pPhoneNumberAlt varchar(10), pPhoneExtensionAlt varchar(6)
                                                 , pEmail varchar(60), pEmailAlt varchar(60), pStreet text, pIntNumber varchar(5), pExtNumber varchar(5)
                                                 , pZipCode int(5), pCountry text, pState varchar(20), pMunicipality text, pCity text, pNeighborhood text
                                                 , pContactName text, pCurp varchar(18), pRetention varchar(20))
BEGIN
  DECLARE existsId INTEGER;
  
  SET existsId = (SELECT COUNT(*) FROM codexClient WHERE _id = pClientId);
  IF (existsId = 0) THEN
     INSERT INTO codexClient (_id, clientTypeId, clientOriginId, sellerId, isProspect, rfc, corporateName,
                 tradeName, phoneArea, phoneNumber, phoneExtension, phoneAreaAlt, phoneNumberAlt,
                 phoneExtensionAlt, email, emailAlt, street, intNumber, extNumber, zipCode, country,
                 state, municipality, city, neighborhood, contactName, curp, retention)
                 VALUES
                 (pClientId, pClientTypeId, pClientOriginId, pSellerId, pIsProspect, pRfc, pCorporateName,
                 pTradeName, pPhoneArea, pPhoneNumber, pPhoneExtension, pPhoneAreaAlt, pPhoneNumberAlt,
                 pPhoneExtensionAlt, pEmail, pEmailAlt, pStreet, pIntNumber, pExtNumber, pZipCode, pCountry,
                 pState, pMunicipality, pCity, pNeighborhood, pContactName, pCurp, pRetention);
  END IF;
  IF (existsId > 0) THEN
      UPDATE codexClient SET _id = pClientId, clientTypeId = pClientTypeId, clientOriginId = pClientOriginId
           , sellerId = pSellerId, isProspect = pIsProspect, rfc = pRfc, corporateName = pCorporateName
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
  SELECT _id id, clientTypeId clientTypeId, clientOriginId clientOriginId, sellerId sellerId
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
  SELECT _id id, clientTypeId clientTypeId, clientOriginId clientOriginId, sellerId sellerId
         , isProspect isProspect, rfc rfc, corporateName corporateName, tradeName tradeName
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
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, cst.name statusDescription
      , cc.tradeName clientDescription, ccc.costCenter costCenter, cp.changeType changeType, cp.created created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.incoterm incoterm
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber, cp.createdBy createdBy, cp.createdByUsr createdByUsr
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr
FROM codexProject cp, codexClient cc, codexStatusType cst, codexPaymentType cpt, codexCurrencyType cct, codexCostCenter ccc
WHERE cp.statusId = cst._id
      AND cp.clientId = cc._id
      AND cp.paymentTypeId = cpt._id
      AND cp.currencyTypeId = cct._id
      AND cp.costCenterId = ccc._id
      AND cp.createdByUsr = pUserId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetProjectsByStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetProjectsByStatus$$
CREATE PROCEDURE blackstarDb.`CodexGetProjectsByStatus`(pStatusId INT(2))
BEGIN
SELECT cp._id id, cp.projectNumber projectNumber, cp.clientId clientId, cp.taxesTypeId taxesTypeId, cp.statusId statusId
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, cst.name statusDescription
      , cc.tradeName clientDescription, ccc.costCenter costCenter, cp.changeType changeType, cp.created created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.incoterm incoterm
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber, cp.createdBy createdBy, cp.createdByUsr createdByUsr
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr
FROM codexProject cp, codexClient cc, codexStatusType cst, codexPaymentType cpt, codexCurrencyType cct, codexCostCenter ccc
WHERE cp.statusId = cst._id
      AND cp.clientId = cc._id
      AND cp.paymentTypeId = cpt._id
      AND cp.currencyTypeId = cct._id
      AND cp.costCenterId = ccc._id
      AND cp.statusId = pStatusId;
END$$ 

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetProjectsByStatusAndUser
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetProjectsByStatusAndUser$$
CREATE PROCEDURE blackstarDb.`CodexGetProjectsByStatusAndUser`(pStatusId INT(2), pCreatedByUsr INT(11))
BEGIN
SELECT cp._id id, cp.projectNumber projectNumber, cp.clientId clientId, cp.taxesTypeId taxesTypeId, cp.statusId statusId
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, cst.name statusDescription
      , cc.tradeName clientDescription, ccc.costCenter costCenter, cp.changeType changeType, cp.created created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.incoterm incoterm
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber, cp.createdBy createdBy, cp.createdByUsr createdByUsr
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr
FROM codexProject cp, codexClient cc, codexStatusType cst, codexPaymentType cpt, codexCurrencyType cct, codexCostCenter ccc
WHERE cp.statusId = cst._id
      AND cp.clientId = cc._id
      AND cp.paymentTypeId = cpt._id
      AND cp.currencyTypeId = cct._id
      AND cp.costCenterId = ccc._id
      AND cp.statusId = pStatusId
	  AND cp.createdByUsr = pCreatedByUsr;
END$$ 

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetEntriesByProject
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetEntriesByProject$$
CREATE PROCEDURE blackstarDb.`CodexGetEntriesByProject`(pProjectId int(11))
BEGIN
	SELECT cpe._id id, cpe.projectId projectId, cpe.entryTypeId entryTypeId, cpe.description description
         , cpe.discount discount, cpe.totalPrice totalPrice, cpe.comments comments, cpet.name entryTypeDescription
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
  SELECT cdt._id id, cdt.codexProjectId projectId, cp.projectNumber projectNumber
        ,cdt.deliverableTypeId deliverableTypeId, cdty.name deliverableTypeDescription
        , cdt.created created, cdt.userId userId, bu.name userName
	FROM codexDeliverableTrace	cdt, codexProject cp, codexDeliverableType cdty, blackstarUser bu
  WHERE cdt.codexProjectId = pProjectId
        AND cdt.codexProjectId = cp._id
        AND cdt.deliverableTypeId = cdty._id
        AND cdt.userId = bu.blackstarUserId;
END$$  

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexAdvanceStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexAdvanceStatus$$
CREATE PROCEDURE blackstarDb.`CodexAdvanceStatus`(pProjectId int(11))
BEGIN

  DECLARE status INTEGER;
  SET status = (SELECT cp.statusId FROM codexProject cp WHERE cp._id =  pProjectId);
  UPDATE codexProject SET statusId = (status + 1) WHERE _id = pProjectId;
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
CREATE PROCEDURE blackstarDb.`CodexInsertPriceProposal`(pProposalId int(11), pProjectId int(11),pPriceProposalNumber varchar(50), pClientId int(11), pTaxesTypeId int(1), pPaymentTypeId int(1),pCurrencyTypeId int(2), pCostCenter varchar(8), pChangeType float, pCreated varchar(40), pContactName text, pLocation varchar(400), pAdvance float(10,2), pTimeLimit int(3), pSettlementTimeLimit int(3), pDeliveryTime int(3), pincoterm varchar(5), pProductsNumber int(20), pFinancesNumber int(20), pServicesNumber int(20), pTotalProjectNumber int(20))
BEGIN
     INSERT INTO codexPriceProposal (_id, projectId, priceProposalNumber, clientId , taxesTypeId , paymentTypeId ,currencyTypeId  , costCenter , changeType , created , contactName , location , advance , timeLimit , settlementTimeLimit , deliveryTime , incoterm , productsNumber , financesNumber , servicesNumber , totalProjectNumber)
     VALUES (pProposalId, pProjectId, pPriceProposalNumber, pClientId , pTaxesTypeId , pPaymentTypeId ,pCurrencyTypeId , pCostCenter , pChangeType , pCreated , pContactName , pLocation , pAdvance , pTimeLimit , pSettlementTimeLimit , pDeliveryTime , pincoterm , pProductsNumber , pFinancesNumber , pServicesNumber , pTotalProjectNumber);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertPriceProposalEntryItem
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexInsertPriceProposalEntryItem$$
CREATE PROCEDURE blackstarDb.`CodexInsertPriceProposalEntryItem`(pPriceProposalEntryId int(11), pItemTypeId int(11), pReference TEXT, pDescription TEXT, pQuantity int(11), pPriceByUnit float(8,2), pDiscount float(6,2), pTotalPrice float(10,2), pComments TEXT)
BEGIN
    INSERT INTO codexPriceProposalItem (priceProposalEntryId, itemTypeId, reference, description, quantity, priceByUnit, discount, totalPrice, comments)
    VALUES (pPriceProposalEntryId, pItemTypeId, pReference, pDescription, pQuantity, pPriceByUnit, pDiscount, pTotalPrice, pComments);  
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertPriceProposalEntry
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexInsertPriceProposalEntry$$
CREATE PROCEDURE blackstarDb.`CodexInsertPriceProposalEntry`(pProposalEntryId int(11), pPriceProposalId int(11), pEntryTypeId int(11), pDescription TEXT, pDiscount FLOAT(6,2), pTotalPrice FLOAT(9,2), pComments TEXT)
BEGIN
    INSERT INTO codexPriceProposalEntry (_id, priceProposalId, entryTypeId, description, discount, totalPrice, comments)
     VALUES (pProposalEntryId, pPriceProposalId, pEntryTypeId, pDescription, pDiscount, pTotalPrice, pComments);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextPriceProposalId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextPriceProposalId$$
CREATE PROCEDURE blackstarDb.`GetNextPriceProposalId`()
BEGIN
	DECLARE newNumber INTEGER;
	CALL blackstarDb.GetNextServiceOrderNumber('P', newNumber);
	SELECT newNumber projectNumber;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextProposalEntryId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextProposalEntryId$$
CREATE PROCEDURE blackstarDb.`GetNextProposalEntryId`()
BEGIN

	DECLARE newNumber INTEGER;

	CALL blackstarDb.GetNextServiceOrderNumber('E', newNumber);
	SELECT newNumber projectNumber;
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
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;


-- -----------------------------------------------------------------------------
-- File:blackstarDb_startupData.sql
-- Name:blackstarDb_startupData
-- Desc:Hace una carga inicial de usuarios para poder operar el sistema
-- Auth:Sergio A Gomez
-- Date:13/08/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author 	Description
-- --   --------   -------  ------------------------------------
-- 1    13/08/2014  SAG  	Version inicial.
-- --   --------   -------  ------------------------------------
-- 2    01/10/2014  SAG  	Se agregan listas
-- ---------------------------------------------------------------------------
use blackstarDb;

DELIMITER $$

-- -----------------------------------------------------------------------------
-- SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS blackstarDb.updateCodexData$$
CREATE PROCEDURE blackstarDb.updateCodexData()
BEGIN

	-- Lista de proyectos
	IF(SELECT count(*) FROM blackstarDb.codexCostCenter) = 0 THEN
		INSERT INTO blackstarDb.codexCostCenter(costCenter, created, createdBy)
		SELECT 'CG170', NOW(), 'init' UNION
		SELECT 'CG183', NOW(), 'init' UNION
		SELECT 'CG187', NOW(), 'init' UNION
		SELECT 'CG205', NOW(), 'init' UNION
		SELECT 'CG209', NOW(), 'init' UNION
		SELECT 'CG317', NOW(), 'init' UNION
		SELECT 'CG343', NOW(), 'init' UNION
		SELECT 'CG344', NOW(), 'init' UNION
		SELECT 'CG350', NOW(), 'init' UNION
		SELECT 'CG356', NOW(), 'init' UNION
		SELECT 'CG358', NOW(), 'init' UNION
		SELECT 'CG363', NOW(), 'init' UNION
		SELECT 'CG382', NOW(), 'init' UNION
		SELECT 'CG386', NOW(), 'init' UNION
		SELECT 'CG390', NOW(), 'init' UNION
		SELECT 'CG402', NOW(), 'init' UNION
		SELECT 'CG404', NOW(), 'init' UNION
		SELECT 'CG409', NOW(), 'init' UNION
		SELECT 'CG425', NOW(), 'init' UNION
		SELECT 'CG455', NOW(), 'init' UNION
		SELECT 'CG471', NOW(), 'init' UNION
		SELECT 'CG475', NOW(), 'init' UNION
		SELECT 'CG478', NOW(), 'init' UNION
		SELECT 'CG482', NOW(), 'init' UNION
		SELECT 'CG483', NOW(), 'init' UNION
		SELECT 'CG490', NOW(), 'init' UNION
		SELECT 'CG495', NOW(), 'init' UNION
		SELECT 'CG498', NOW(), 'init' UNION
		SELECT 'CG499', NOW(), 'init' UNION
		SELECT 'CG501', NOW(), 'init' UNION
		SELECT 'CG503', NOW(), 'init' UNION
		SELECT 'CG523', NOW(), 'init' UNION
		SELECT 'CG525', NOW(), 'init' UNION
		SELECT 'CG533', NOW(), 'init' UNION
		SELECT 'CG558', NOW(), 'init' UNION
		SELECT 'CM118', NOW(), 'init' UNION
		SELECT 'CM122', NOW(), 'init' UNION
		SELECT 'CM130', NOW(), 'init' UNION
		SELECT 'CM150', NOW(), 'init' UNION
		SELECT 'CM168', NOW(), 'init' UNION
		SELECT 'CM179', NOW(), 'init' UNION
		SELECT 'CM181', NOW(), 'init' UNION
		SELECT 'CM183', NOW(), 'init' UNION
		SELECT 'CM203', NOW(), 'init' UNION
		SELECT 'CM206', NOW(), 'init' UNION
		SELECT 'CM220', NOW(), 'init' UNION
		SELECT 'CM224', NOW(), 'init' UNION
		SELECT 'CM229', NOW(), 'init' UNION
		SELECT 'CM23', NOW(), 'init' UNION
		SELECT 'CM237', NOW(), 'init' UNION
		SELECT 'CM239', NOW(), 'init' UNION
		SELECT 'CM241', NOW(), 'init' UNION
		SELECT 'CM242', NOW(), 'init' UNION
		SELECT 'CM247', NOW(), 'init' UNION
		SELECT 'CM253', NOW(), 'init' UNION
		SELECT 'CM260', NOW(), 'init' UNION
		SELECT 'CM264', NOW(), 'init' UNION
		SELECT 'CM267', NOW(), 'init' UNION
		SELECT 'CM292', NOW(), 'init' UNION
		SELECT 'CM293', NOW(), 'init' UNION
		SELECT 'CM294', NOW(), 'init' UNION
		SELECT 'CM296', NOW(), 'init' UNION
		SELECT 'CM310', NOW(), 'init' UNION
		SELECT 'CM313', NOW(), 'init' UNION
		SELECT 'CM318', NOW(), 'init' UNION
		SELECT 'CM321', NOW(), 'init' UNION
		SELECT 'CM351', NOW(), 'init' UNION
		SELECT 'CM36', NOW(), 'init' UNION
		SELECT 'CM361', NOW(), 'init' UNION
		SELECT 'CM367', NOW(), 'init' UNION
		SELECT 'CM376', NOW(), 'init' UNION
		SELECT 'CM389', NOW(), 'init' UNION
		SELECT 'CM390', NOW(), 'init' UNION
		SELECT 'CM392', NOW(), 'init' UNION
		SELECT 'CM395', NOW(), 'init' UNION
		SELECT 'CM411', NOW(), 'init' UNION
		SELECT 'CM422', NOW(), 'init' UNION
		SELECT 'CM425', NOW(), 'init' UNION
		SELECT 'CM435', NOW(), 'init' UNION
		SELECT 'CM465', NOW(), 'init' UNION
		SELECT 'CM476', NOW(), 'init' UNION
		SELECT 'CM495', NOW(), 'init' UNION
		SELECT 'CM50', NOW(), 'init' UNION
		SELECT 'CM503', NOW(), 'init' UNION
		SELECT 'CM505', NOW(), 'init' UNION
		SELECT 'CM508', NOW(), 'init' UNION
		SELECT 'CM519', NOW(), 'init' UNION
		SELECT 'CM524', NOW(), 'init' UNION
		SELECT 'CM542', NOW(), 'init' UNION
		SELECT 'CM619', NOW(), 'init' UNION
		SELECT 'CM633', NOW(), 'init' UNION
		SELECT 'CM88', NOW(), 'init' UNION
		SELECT 'CQ101', NOW(), 'init' UNION
		SELECT 'CQ149', NOW(), 'init' UNION
		SELECT 'CQ154', NOW(), 'init' UNION
		SELECT 'CQ166', NOW(), 'init' UNION
		SELECT 'CQ169', NOW(), 'init' UNION
		SELECT 'CQ191', NOW(), 'init' UNION
		SELECT 'CQ219', NOW(), 'init' UNION
		SELECT 'CQ243', NOW(), 'init' UNION
		SELECT 'CQ244', NOW(), 'init' UNION
		SELECT 'CQ256', NOW(), 'init' UNION
		SELECT 'CQ267', NOW(), 'init' UNION
		SELECT 'CQ310', NOW(), 'init' UNION
		SELECT 'CQ323', NOW(), 'init' UNION
		SELECT 'CQ327', NOW(), 'init' UNION
		SELECT 'CQ328', NOW(), 'init' UNION
		SELECT 'CQ336', NOW(), 'init' UNION
		SELECT 'CQ345', NOW(), 'init' UNION
		SELECT 'CQ346', NOW(), 'init' UNION
		SELECT 'CQ371', NOW(), 'init' UNION
		SELECT 'CQ436', NOW(), 'init' UNION
		SELECT 'CQ443', NOW(), 'init' UNION
		SELECT 'CQ449', NOW(), 'init' UNION
		SELECT 'CQ454', NOW(), 'init' UNION
		SELECT 'CQ455', NOW(), 'init' UNION
		SELECT 'CQ456', NOW(), 'init' UNION
		SELECT 'CQ462', NOW(), 'init' UNION
		SELECT 'CQ475', NOW(), 'init' UNION
		SELECT 'CQ497', NOW(), 'init' UNION
		SELECT 'CQ527', NOW(), 'init' UNION
		SELECT 'CQ534', NOW(), 'init' UNION
		SELECT 'CQ539', NOW(), 'init' UNION
		SELECT 'CQ552', NOW(), 'init' UNION
		SELECT 'CQ556', NOW(), 'init' UNION
		SELECT 'CQ613', NOW(), 'init' UNION
		SELECT 'CQ622', NOW(), 'init' UNION
		SELECT 'CQ626', NOW(), 'init' UNION
		SELECT 'CQ628', NOW(), 'init' UNION
		SELECT 'CQ628-2014', NOW(), 'init' UNION
		SELECT 'CQ638', NOW(), 'init' UNION
		SELECT 'CQ652', NOW(), 'init' UNION
		SELECT 'CQ655', NOW(), 'init' UNION
		SELECT 'CQ660', NOW(), 'init' UNION
		SELECT 'CQ665', NOW(), 'init' UNION
		SELECT 'CQ704', NOW(), 'init' UNION
		SELECT 'CQ707', NOW(), 'init' UNION
		SELECT 'CQ708', NOW(), 'init' UNION
		SELECT 'CQ709', NOW(), 'init' UNION
		SELECT 'CQ710', NOW(), 'init' UNION
		SELECT 'CQ726', NOW(), 'init' UNION
		SELECT 'CQ760', NOW(), 'init' UNION
		SELECT 'CQ764', NOW(), 'init' UNION
		SELECT 'CQ81', NOW(), 'init' UNION
		SELECT 'MX10-0035', NOW(), 'init' UNION
		SELECT 'MX11-0026', NOW(), 'init' UNION
		SELECT 'PG28', NOW(), 'init' UNION
		SELECT 'PQ10', NOW(), 'init' ;

	END IF;
	-- Lista de status
	IF(SELECT count(*) FROM blackstarDb.codexStatusType) = 0 THEN
		INSERT INTO blackstarDb.codexStatusType(name, description)
		SELECT 'Nuevo', 'Nuevo' UNION
		SELECT 'Por autorizar', 'Por autorizar' UNION
		SELECT 'Autorizada', 'Autorizada' UNION
		SELECT 'En cotizacion', 'En cotizacion' ;
	END IF;
	
	-- Lista de tipos de cliente
	IF(SELECT count(*) FROM blackstarDb.codexClientType) = 0 THEN
		INSERT INTO blackstarDb.codexClientType(_id, name, description)
		SELECT 1, 'IP', 'IP' UNION
		SELECT 2, 'Gobierno', 'Gobierno' UNION
		SELECT 3, 'Integrador', 'Integrador' UNION
		SELECT 4, 'No Definido', 'No Definido' ;
	END IF;

	-- Lista de origenes de clientes
	IF(SELECT count(*) FROM blackstarDb.codexClientOrigin) = 0 THEN
		INSERT INTO blackstarDb.codexClientOrigin(name, description)
		SELECT 'Consultor', 'Consultor' UNION
		SELECT 'Medios Electronicos', 'Medios Electronicos' UNION
		SELECT 'Referidos', 'Referidos' UNION
		SELECT 'Cliente', 'Cliente' UNION
		SELECT 'Otros', 'Otros';
	END IF;

	-- Lista inicial de Clientes
	IF(SELECT count(*) FROM blackstarDb.codexClient) = 0 THEN
		INSERT INTO blackstarDb.codexClient(corporateName, tradeName, contactName, sellerName, clientTypeId, email, street, extNumber, neighborhood, city, state, country, zipCode, phoneArea, phoneNumber, rfc, isProspect )
		SELECT 'ACTINVER CASA DE BOLSA SA DE CV', 'ACTINVER CASA DE BOLSA SA DE CV', '', 'JORGE ALBERTO MARTINEZ',1,'', 'GUILLERMO GONZALEZ CAMARENA', '1200', 'SANTA FE', 'MEXICO', 'Distrito Federal', 'México', '1210', '155', '11036600', 'ACB7609076M2', 1 UNION
SELECT 'ACUBICA ARQUITECTURA SA DE CV', 'ACUBICA ARQUITECTURA SA DE CV', '', 'SAUL ANDRADE',3,'', 'INDEPENDENCIA', '17', 'TIZAPAN SAN ANGEL', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '1090', '55', '30993728', 'AAR100125F75', 1 UNION
SELECT 'ADMINISTRADORA DE CAJA BIENESTAR SA DE CV SFP', 'ADMINISTRADORA DE CAJA BIENESTAR SA DE CV SFP', '', 'RUFINO MOCTEZUMA',1,'gcastillo@ahorrosbienestar.com', 'EZEQUIEL MONTES SUR', '50', 'CENTRO', 'QUERETARO', 'QUERÉTARO', 'MEXICO', '76000', '442', '2519300', 'ABC950109JZ9', 1 UNION
SELECT 'AFORE XXI BANORTE SA DE CV', 'AFORE XXI BANORTE SA DE CV', 'MARCO ANTONIO GUTIERREZ', 'IVAN RAMIREZ',1,'', 'AV INSURGENTES SUR', '1228', 'DEL VALLE', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '3100', '155', '54885538', 'AXX970225GL0', 1 UNION
SELECT 'AGUSTIN SALAS GALLEGOS', 'AGUSTIN SALAS GALLEGOS', '', 'DIRECTO',1,'', 'MONZA', '119', 'FRACC VILLAS DE SAN ANTONIO', 'AGUASCALIENTES', 'AGUASCALIENTES', 'MEXICO', '20286', '', '', '', 1 UNION
SELECT 'ALEJANDRO EQUIHUA RAMIREZ', 'ALEJANDRO EQUIHUA RAMIREZ', '', 'DIRECTO',4,'', 'CAZAREZ', '171', 'CENTRO', 'ZAMORA', 'MICHOACÁN', 'MEXICO', '59600', '', '', 'EURA780518F5A', 1 UNION
SELECT 'APIESA SA DE CV', 'APIESA SA DE CV', 'MARIANO RAFAEL JIMENEZ', 'JUAN JOSE ESPINOZA BRAVO',3,'apiesags@yahoo.com', 'AV INDEPENDENCIA', '814', 'CIRCUNVALACION NORTE', 'AGUASCALIENTES', 'AGUASCALIENTES', 'MEXICO', '20020', '449', '9147068', 'API010625F53', 1 UNION
SELECT 'ARNESES ELECTRICOS AUTOMOTRICES S.A. DE C.V.', 'ARNESES ELECTRICOS AUTOMOTRICES S.A. DE C.V.', 'ULISES SALAZAR', 'JOSE IVAN MARTIN',1,'usalazar@condumex.com.mx', 'CARR. PANAMERICANA KM 146.5 TRAMO IRAPUATO-SILAO', '', '', 'SILAO', 'GUANAJUATO', 'MEXICO', '36100', '472', '7229400', 'AEA9111014S3', 1 UNION
SELECT 'AUDITORIA SUPERIOR DE LA FEDERACION', 'AUDITORIA SUPERIOR DE LA FEDERACION', '', 'JORGE ALBERTO MARTINEZ',2,'', 'AV COYOACAN', '1501', 'DEL VALLE', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '0', '155', '52001500', 'ASF001230TS2', 1 UNION
SELECT 'AXTEL SAB DE CV', 'AXTEL SAB DE CV', '', 'FRANCISCO UREÑA',3,'', 'BLVD DIAZ ORDAZ KM 3.33 L-1', '', 'UNIDAD SAN PEDRO', 'SAN PEDRO GARZA GARCIA', 'NUEVO LEON', 'MEXICO', '66215', '181', '81141231', 'AXT940727FP8', 1 UNION
SELECT 'BANCO INVEX SA INSTITUCION DE BANCA MULTIPLE', 'BANCO INVEX SA INSTITUCION DE BANCA MULTIPLE', 'ARMANDO CORONA', 'MICHELLE GALICIA',1,'ACORONA@invex.com', 'BOULEVAD MANUEL AVILA CAMACHO', '40', 'LOMAS DE CHAPULTEPEC', 'MIGUEL HIDALGO', 'DISTRITO FEDERAL', 'MEXICO', '11000', '155', '53503346', 'BIN940223KE0', 1 UNION
SELECT 'BAXTER SA DE CV', 'BAXTER SA DE CV', 'RUDYARD IVAN GUIZA', 'MICHELLE GALICIA',1,'Rudyard_Ivan_Guiza@baxter.com', 'AV DE LOS 50 METROS', '2', 'CIVAC JUITEPEC', 'CUERNAVACA', 'MORELOS', 'MEXICO', '62578', '1777', '3296000', 'BAX871207MN3', 1 UNION
SELECT 'BESCO SERVICIO SA DE CV', 'BESCO SERVICIO SA DE CV', '', 'DIRECTO',3,'', 'DIAGONAL PATRIOTISMO', '4', 'HIPODROMO CONDESA', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '6170', '', '', 'BSE8704273W5', 1 UNION
SELECT 'CABLEMAS TELECOMUNICACIONES SA DE CV', 'CABLEMAS TELECOMUNICACIONES SA DE CV', 'DANIEL MORALES Y/O JOSE LUIS GONZALEZ', 'JOSE IVAN MARTIN',1,'dmorales@cablemas.com.mx / jgonzalezr@cablemas.com.mx', 'SEVILLA', '4', 'JUAREZ', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '6600', '', '', 'TCI770922C22', 1 UNION
SELECT 'CAJA DE AHORRO DE LOS TELEFONISTAS SC DE AP DE RL DE CV', 'CAJA DE AHORRO DE LOS TELEFONISTAS SC DE AP DE RL DE CV', 'HOMERO AMBRIZ', 'JOSE IVAN MARTIN',1,'homero.abriz@hotmail.com', 'MIGUEL E. SCHULTZ', '140', 'SAN RAFAEL', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '6470', '55', '51409688', 'CAT9505192V1', 1 UNION
SELECT 'CAJA MORELIA VALLADOLID SC DE AP DE RL DE CV', 'CAJA MORELIA VALLADOLID SC DE AP DE RL DE CV', 'ROGER TUN ALDAN', 'JOSE IVAN MARTIN',1,'roger.tun@cajamorelia.com', 'ACATITA DE BAJAN', '222', 'LOMAS DE HIDALGO', 'MORELIA', 'MICHOACAN', 'MEXICO', '58240', '', '', 'CMV980925LQ7', 1 UNION
SELECT 'CENEXIS SA DE CV', 'CENEXIS SA DE CV', 'RAMON SERNA', 'JUAN JOSE ESPINOZA BRAVO',1,'geraldo.gomez@gmodelo.com.mx', 'BOULEVARD A ZACATECAS', '701', 'LAS HADAS', 'AGUASCALIENTES', 'AGUASCALIENTES', 'MEXICO', '20140', '449', '139 3300', 'CEN0605083U9', 1 UNION
SELECT 'CENTRO DE EVALUACION Y CONTROL DE CONFIANZA DEL ESTADO DE GUANAJUATO', 'CENTRO DE EVALUACION Y CONTROL DE CONFIANZA DEL ESTADO DE GUANAJUATO', 'SERGIO VELAZQUEZ URZUA', 'JOSE IVAN MARTIN',4,'svelazquezq@juanaguato.org.mx', 'BLVD. JUAN JOSE TORRES LANDA', '3005', 'SAN ISIDRO', 'LEON', 'GUANAJUATO', 'MEXICO', '37510', '', '', 'CEC090101MGA', 1 UNION
SELECT 'CENTRO DE INVESTIGACIÓN Y DE ESTUDIOS AVANZADOS DEL INSTITUTO POLITECNICO NACIONAL', 'CENTRO DE INVESTIGACIÓN Y DE ESTUDIOS AVANZADOS DEL INSTITUTO POLITECNICO NACIONAL', 'ING ELVIA LOPEZ', 'JUAN JOSE ESPINOZA BRAVO',2,'elvial@cts-desing.com', 'AV. DEL BOSQUE', '1145', 'EL BAJIO', 'ZAPOPAN', 'JALISCO', 'MEXICO', '45019', '33', '37773600', 'CIE6010281U2', 1 UNION
SELECT 'CENTRO REGIONAL DE COMPETITIVIDAD EMPRESARIAL SC', 'CENTRO REGIONAL DE COMPETITIVIDAD EMPRESARIAL SC', 'MARIA JOSE OLIVA', 'DIRECTO',1,'enlace@certificaciondepymes.org.mx', 'AVENIDA REPUBLICA', '44', 'SANTA ANA', 'CAMPECHE', 'CAMPECHE', 'MEXICO', '24050', '', '', 'CRC0702132N9', 1 UNION
SELECT 'UNI', 'UNI', 'JESUS CAMPA', 'JUAN JOSE ESPINOZA BRAVO',1,'jesus.campa@gmodelo.com.mx', 'CALLE 37 NORTE', '300', 'NUEVO TORREON', 'TORREON', 'TORREON', 'COAHUILA', '27040', '55', '22660000', 'CMT801204CZ4', 1 UNION
SELECT 'CEURAC SA DE CV', 'CEURAC SA DE CV', 'GERMINAL OCAÑA', 'MICHELLE GALICIA',1,'', 'OAXACA', '81', 'COL ROMA', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '6700', '', '', 'CEU980706GL7', 1 UNION
SELECT 'CGGVERITAS SERVICES DE MEXICO SA DE CV', 'CGGVERITAS SERVICES DE MEXICO SA DE CV', '', 'PILAR PAZ',1,'', 'LAGO VICTORIA', '74', 'GRANADA', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11520', '01 993', '31047570', 'CSM8803244U7', 1 UNION
SELECT 'CLIMAS SA DE CV', 'CLIMAS SA DE CV', 'CESAR CHAVE', 'FRANCISCO UREÑA',3,'cchavez@climas.com', 'VALLE ESCONDIDO', '5700', 'JARDINES DEL SAUCITO', 'CHIHUAHUA', 'CHIHUAHUA', 'MEXICO', '31125', '614', '4393999', 'CLI580701CU9', 1 UNION
SELECT 'COLEGIO DE EDUCACION PROFESIONAL TECNICA DEL ESTADO DE GUANAJUATO', 'COLEGIO DE EDUCACION PROFESIONAL TECNICA DEL ESTADO DE GUANAJUATO', 'RITO MACIAS NEGRETE', 'JOSE IVAN MARTIN',1,'jorge.alvarezt@conalepgto.edu.mx /', 'AV. MARQUEZ', 'S/N', 'REAL PROVIDENCIA', 'LEON', 'GUANAJUATO', 'MEXICO', '37234', '477', '7762622', 'CEP991019RR6', 1 UNION
SELECT 'COMERCIALIZADORA DE VALOR AGREGADO SA DE CV', 'COMERCIALIZADORA DE VALOR AGREGADO SA DE CV', '', '',3,'eramirez@grupocva.com', 'MARIANO OTERO', '2489', 'JARDINES DE LA VICTORIA', 'GUADALAJARA', 'JALISCO', 'MEXICO', '44900', '33', '30121413', 'CVA9904266T9', 1 UNION
SELECT 'COMERCIALIZADORA ELORO SA', 'COMERCIALIZADORA ELORO SA', '', 'MICHELLE GALICIA',1,'', 'KM 12.5 ANTIGUA CARRETERA MEXICO PACHUCA', '', 'RUSTICA XALOSTIC', '', 'ESTADO DE MEXICO', 'MEXICO', '55340', '', '', 'CEL470228G64', 1 UNION
SELECT 'COMISION FEDERAL DE ELECTRICIDAD', 'COMISION FEDERAL DE ELECTRICIDAD', 'CARLOS CRUZ', 'JUAN JOSE ESPINOZA BRAVO',2,'carlos.cruz01@cfe.gob.mx', 'AV PASEO DE LA REFORMA', '164', 'JUAREZ', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '6600', '', '', 'CFE370814QI0', 1 UNION
SELECT 'COMPAÑIA CERVECERA DE ZACATECAS S.A. DE C.V.', 'COMPAÑIA CERVECERA DE ZACATECAS S.A. DE C.V.', 'MARTHA MARINA GONZALEZ PEDRAZA', 'JUAN JOSE ESPINOZA BRAVO',1,'', 'BOULEVARD ANTONINO FERNANDEZ RODRIGUEZ', '100', 'CALERA DE VICTOR ROSALES', '', 'ZACATECAS', 'MEXICO', '98500', '478', '9854-040', 'CZA890112KS6', 1 UNION
SELECT 'CONSEJO DE LA JUDICATURA FEDERAL', 'CONSEJO DE LA JUDICATURA FEDERAL', 'OSCAR ZAPATA', 'JUAN JOSE ESPINOZA BRAVO',2,'oscar.zapata.alvarez@correo.cjf.gob.mx', 'INSURGENTES SUR', '2417', 'SAN ANGEL', 'DF', 'DF', 'MEXICO', '1000', '44', '3312415264', 'CJF950204TL0', 1 UNION
SELECT 'CONSTRUCTORA ARECHIGA SA DE CV', 'CONSTRUCTORA ARECHIGA SA DE CV', '', 'PILAR PAZ',3,'', 'KM 10 + 100 CARRETERA BOSQUES DE SALOYA- EL CEDRO', 'S/N', 'R/a EL CEDRO 3RA. SECCION', 'VILLAHERMOSA', 'TABASCO', 'MÉXICO', '86220', '', '', 'CAR851022AB6', 1 UNION
SELECT 'CONTECON MANZANILLO SA DE CV', 'CONTECON MANZANILLO SA DE CV', '', 'JOSE IVAN MARTIN',4,'shernandez@contecon.mx', 'AV COYOACAN', '1878', 'DEL VALLE', 'MEXICO', 'DELEEGACION BENITO JUAREZ', 'DISTRITO FEDERAL', '3100', '314', '1382009', 'CMA100106AH8', 1 UNION
SELECT 'COORDINACION DE SERVICIOS EN INFORMATICA SA DE CV', 'COORDINACION DE SERVICIOS EN INFORMATICA SA DE CV', 'EDUARDO NAVA', 'JORGE ALBERTO MARTINEZ',3,'enava@coservicios.com.mx', 'AUDITORES', '83', 'SIFON', 'DISTRITO FEDERAL', 'DISTRITO FEDERAL', 'MEXICO', '9400', '55', '56338282', 'CSI980907QN7', 1 UNION
SELECT 'CORPORACION DE OCCIDENTE, S.A. DE C.V.', 'CORPORACION DE OCCIDENTE, S.A. DE C.V.', 'LIC. CHRISTIAN ALEJANDRO VALADEZ VARGAS', 'FRANCISCO UREÑA',1,'c.valadez@coocsa.com', 'KM 3.5 CARR. A EL SALTO VIA LA CAPILLA', 'S/N', 'LA RESERVA', 'EL SALTO', 'JALISCO', 'MEXICO', '45680', '33', '37935550', 'COC050126PI7', 1 UNION
SELECT 'COTEMAR SA DE CV', 'COTEMAR SA DE CV', '', 'PILAR PAZ',3,'', 'PASEO DE LAS PALMAS', '735', 'LOMAS DE CHAPULTEPEC', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11000', '', '', 'COT790201P28', 1 UNION
SELECT 'DAIMLER VEHICULOS COMERCIALES MEXICO S DE RL DE CV', 'DAIMLER VEHICULOS COMERCIALES MEXICO S DE RL DE CV', 'LEONARDO GUTIERREZ', 'MICHELLE GALICIA',1,'juan.gutierrez@daimler.com', 'AV. PASEO DE LOS TAMARINDOS', '90', 'BOSQUES DE LAS LOMAS', 'DISTRITO FEDERAL', 'DISTRITO FEDERAL', 'MEXICO', '5120', '722', '2767530', 'DVC910102VDA', 1 UNION
SELECT 'DATA AIR ELECTRIC SA DE CV', 'DATA AIR ELECTRIC SA DE CV', 'DANTE REYNOSO', 'DIRECTO GUADALAJARA',4,'dante.reynoso@dataairelectric.com', 'PASEO DE LAS GALIAS', '223', 'LOMAS ESTRELLA SEGUNDA SECCION', 'DELEGACION IZTAPALAPA', 'DITRITO FEDERAL', 'MEXICO', '9890', '', '', 'DAE060823RW0', 1 UNION
SELECT 'DATA AIRE INC', 'DATA AIRE INC', '', 'DIRECTO',4,'asotelo@pqglobal.com', 'WEST BLUERIDGE AVENUE', '230', '', '', 'CA', 'ESTADOS UNIDOS DE AMERICA', '92865', '001 858', '2715996', 'WEXX010101000', 1 UNION
SELECT 'DATA NETWORKS S.A. DE C.V.', 'DATA NETWORKS S.A. DE C.V.', '', 'JORGE ALBERTO MARTINEZ',3,'', 'ALONDRA', '46', 'EL ROSEDAL', 'MEXICO', 'DISTRITO FEDERAL', 'MÉXICO', '4330', '', '', 'DNE960819MM6', 1 UNION
SELECT 'DATACENTER DYNAMICS SPAIN SLU', 'DATACENTER DYNAMICS SPAIN SLU', 'ANTONIO RODRIGUEZ', 'DIRECTO',4,'antonio.rodriguez@datacenterdynamics.com', 'ALCALA', '4', 'CIF B85733038 DUNS 462049563', '', 'MADRID', 'ESPAÑA', '28014', '34', '911332796', 'XEXX010101000', 1 UNION
SELECT 'DEMOLOGISTICA SA DE CV', 'DEMOLOGISTICA SA DE CV', 'JUAN JOSE LOERA', 'JOSE IVAN MARTIN',3,'', 'BOULEVARD ANTONIO MADRAZO', '1025', 'LAS TROJES', 'LEON', 'GUANAJUATO', 'MEXICO', '37227', '477', '7134422', 'DEM040901T83', 1 UNION
SELECT 'DESARROLLO CORPORATIVO IDESA SA DE CV', 'DESARROLLO CORPORATIVO IDESA SA DE CV', 'EDGAR SANVICENTE', 'JORGE ALBERTO MARTINEZ',1,'erico@idesa.com.mx', 'BOSQUE DE RADIATAS', '34', 'BOSQUES DE LAS LOMAS', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '5120', '', '', 'DCI8307266G6', 1 UNION
SELECT 'DESARROLLOS Y SOLUCIONES EN TI SA DE CV', 'DESARROLLOS Y SOLUCIONES EN TI SA DE CV', 'SEBASTIAN VELAZQUEZ', 'JOSE IVAN MARTIN',1,'', 'BLVD MARIANO ESCOBEDO', '4218', 'SAN ISIDRO', 'LEON', 'GUANAJUATO', 'MEXICO', '0', '', '', 'DST1010185B7', 1 UNION
SELECT 'DIAZ IGA EDIFICACIONES URBANAS E INDUSTRIALES SA DE CV', 'DIAZ IGA EDIFICACIONES URBANAS E INDUSTRIALES SA DE CV', '', 'PILAR PAZ',3,'', 'CARR COATZACOALCOS-MINATITLAN KM 7.5', '', 'TIERRA NUEVA', 'COATZACOALCOS', 'VERACRUZ', 'MEXICO', '96496', '', '', 'DIE850517B64', 1 UNION
SELECT 'DIBLO CORPORATIVO SA DE CV', 'DIBLO CORPORATIVO SA DE CV', 'MARTHA MARINA GONZALEZ PEDRAZA', 'JORGE ALBERTO MARTINEZ',1,'rserna@gmodelo.com.mx', 'JAVIER BARROS SIERRA', '555', 'ZEDEC SANTA FE', 'MEXICO DF', 'MEXICO DF', 'MEXICO', '1210', '', '', 'DCO8009185Y9', 1 UNION
SELECT 'DISTRIBUIDORA YAKULT GUADALAJARA SA DE CV', 'DISTRIBUIDORA YAKULT GUADALAJARA SA DE CV', 'JESUS ALBERTO URIBE', 'FRANCISCO UREÑA',1,'juribe@yakult.com.mx', 'AV PERIFERICO PONIENTE', '7425', 'FRACC VALLARTA PARQUE INDUSTRIAL', 'ZAPOPAN', 'JALISCO', 'MÉXICO', '45010', '33', '31345300', 'DYG840702JI1', 1 UNION
SELECT 'DOWELL SCHLUMBERGER DE MEXICO SA DE CV', 'DOWELL SCHLUMBERGER DE MEXICO SA DE CV', '', 'PILAR PAZ',3,'', 'AV EJERCITO NACIONAL', '425', 'GRANADA', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11520', '155', '52633224', 'DSM830824Y6', 1 UNION
SELECT 'ELTEKENERGY INTERNATIONAL DE MEXICO S DE RL DE CV', 'ELTEKENERGY INTERNATIONAL DE MEXICO S DE RL DE CV', 'ALEJANDRO ALCALA', 'DIRECTO',4,'Alejandro.alcala@eltek.com', 'CIRCUITO DE CIRCUNVALACION ORIENTE', '10', 'CIUDAD SAELITE', 'NAUCALPAN', 'ESTADO DE MÉXICO', 'MEXICO', '53100', '55', '52206455', 'EIM970416HM1', 1 UNION
SELECT 'ENERGIA REGULADA SA DE CV', 'ENERGIA REGULADA SA DE CV', 'CARLOS BORUNDA DÍAZ', 'DIRECTO',1,'cborunda@energiaregulada.com', 'PINO', '511', 'LAS GRANJAS', 'CHIHUAHUA', 'CHIHUAHUA', 'MEXICO', '31100', '614', '4171532', 'ERE060601798', 1 UNION
SELECT 'EPSILON & GAMMA SA DE CV', 'EPSILON & GAMMA SA DE CV', '', 'DIRECTO',4,'', 'VIDRIO', '2335', 'AMERICANA', 'ZAPOPAN', 'JALISCO', 'MEXICO', '44160', '447', '2935050', 'EAG090907CF5', 1 UNION
SELECT 'ERIC GUZMAN NAVARRO', 'ERIC GUZMAN NAVARRO', 'ERIC GUZMAN NAVARRO', 'DIRECTO',4,'eric_guzmannavarro@yahoo.com.mx', 'ISLA CANDIA', '3046', 'JARDINES DE LA CRUZ', 'GUADALAJARA', 'JALISCO', 'MEXICO', '44950', '', '38324215', 'GUNE741024PQA', 1 UNION
SELECT 'ESTACIONES DE SERVICIO AUTO SA DE CV', 'ESTACIONES DE SERVICIO AUTO SA DE CV', 'Javier Silva', 'PILAR PAZ',4,'', 'AV. ADOLFO RUIZ CORTINES', '1418', 'ATASTA', 'VILLAHERMOSA', 'TABASCO', 'MEXICO', '86100', '993', '310 4505', 'ESA930602UV1', 1 UNION
SELECT 'FERROSUR SA DE CV', 'FERROSUR SA DE CV', '', 'PILAR PAZ',2,'julorovzrm@ferrrosur.com.mx', 'MONTESINOS # 1 ESQ MARINA MERCANTE', '', 'CENTRO', 'VERACRUZ', 'VERACRUZ', 'MEXICO', '91700', '229', '9895964', 'FER980731NW5', 1 UNION
SELECT 'FEZACON INGENIERIA Y CONSULTORIA EMPRESARIAL SA DE CV', 'FEZACON INGENIERIA Y CONSULTORIA EMPRESARIAL SA DE CV', 'OMAR BARRERA', 'IVAN RAMIREZ',1,'ingarqbaro@gmail.com', 'AV MIGUEL ALEMAN', '1304', 'ALVARO OBREGON', 'MEXICO', 'ESTADO DE MÉXICO', 'MEXICO', '52105', '55', '52641269', 'FIC1112016Q9', 1 UNION
SELECT 'FLEZA, S.A. DE C.V.', 'FLEZA, S.A. DE C.V.', '', 'DIRECTO',1,'', 'BOULEVARD ANTONINO FERNANDEZ RODRIGUEZ', '115', 'CALERA DE VICTOR ROSALES', 'ZACATECAS', 'ZACATECAS', 'MEXICO', '98500', '', '', 'FLE951229IN2', 1 UNION
SELECT 'FLOR DE KARINA RANGEL ROSAS', 'FLOR DE KARINA RANGEL ROSAS', '', 'DIRECTO',4,'', 'TORRES QUINTERO', '636', 'ALCALDE BARRANQUITAS', 'GUADALAJARA', 'JALISCO', 'MEXICO', '44270', '', '', 'RARF8112072W3', 1 UNION
SELECT 'FONDO JALISCO DE FOMENTO EMPRESARIAL', 'FONDO JALISCO DE FOMENTO EMPRESARIAL', 'CECILIA DIAZ', 'JUAN JOSE ESPINOZA BRAVO',4,'cecilia.diaz@jalisco.gob.mx', 'ADOLFO LOPEZ MATEOS NORTE', '1135', 'ITALIA PROVIDENCIA', 'GUADALAJARA', 'GUADALAJARA', 'JALISCO', '44648', '33', '3652574', 'FJF850618K35', 1 UNION
SELECT 'GOBIERNO DEL ESTADO DE GUANAJUATO', 'GOBIERNO DEL ESTADO DE GUANAJUATO', 'DAVID HUERTA', 'JOSE IVAN MARTIN',2,'david.huerta@guanajuato.gob.mx', 'PASEO DE LA PRESA', '103', 'ZONA CENTRO', 'GUANAJUATO', 'GUANAJUATO', 'MEXICO', '36000', '147', '37351500', 'GEG850101FQ2', 1 UNION
SELECT 'GRACIELA ANDRADE CARRILLO', 'GRACIELA ANDRADE CARRILLO', '', 'DIRECTO',4,'', 'AV. MEXICO JAPON', '206', 'CD INDUSTRIAL', 'CELAYA', 'GUANAJUATO', 'MEXICO', '38010', '', '', 'AACG610502QN1', 1 UNION
SELECT 'GRANITE CHIEF SA DE CV', 'GRANITE CHIEF SA DE CV', '', 'JUAN RAMOS',1,'', 'PASEO DE LA REFORMA', '389', 'CUAHUTEMOC', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '6500', '', '', 'GCI0707058Q7', 1 UNION
SELECT 'GREEN CONTINUITY DATA CENTERS SA DE CV', 'GREEN CONTINUITY DATA CENTERS SA DE CV', 'MIGUEL ESCOBEDO', 'DIRECTO',1,'mescobedo@greencontinuity.com', 'FRANCISCO NEGRETE', 'B 1', 'AURIS', 'LERMA', 'MEXICO', 'MEXICO', '52004', '55', '12091791', 'GCD120706B91', 1 UNION
SELECT 'GRUPO VKW INGENERIA SA DE CV', 'GRUPO VKW INGENERIA SA DE CV', 'Ing. Emma A Puebla Cruz', 'DIRECTO',1,'epuebla@vkw-ingenieria.com, compras@vkw-ingenieria', 'AMERICA', '81', 'PARQUE SAN ANDRES', 'MEXICO DF', 'DISTRITO FEDERAL', 'MEXICO', '4040', '55', '5336-4943', 'GVI021218RG4', 1 UNION
SELECT 'GRUPO ANTOLIN-SILAO SA DE CV', 'GRUPO ANTOLIN-SILAO SA DE CV', '', 'JOSE IVAN MARTIN',1,'', 'AV INGENIEROS', '51', 'PARQUE INDUSTRIAL SILAO APDO 238', 'SILAO', 'GUANAJUATO', 'MEXICO', '36101', '472', '7227400', 'GAS9403186J1', 1 UNION
SELECT 'GRUPO ASOCIADO DEL SURESTE INGENIERÍA Y SERVICIOS SA DE CV', 'GRUPO ASOCIADO DEL SURESTE INGENIERÍA Y SERVICIOS SA DE CV', 'Marcos Jimenez', 'DIRECTO',1,'fernando-1707@hotmail.com', 'CARRETERA ESTATAL ANACLETO CANABAL PRIMERA A ANACLETO CANABAL SEGUNDA KM 3.55', 'S/N', 'ANACLETO CANABAL 1ERA SECCIÓN CENTRO', 'VILLAHERMOSA', 'TABASCO', 'MÉXICO', '86280', '938', '153 1521', 'GAS050114BF7', 1 UNION
SELECT 'GRUPO LAMESA SA DE CV', 'GRUPO LAMESA SA DE CV', 'MARTHA ANDRADE', 'JOSE IVAN MARTIN',1,'martha.andrade@grupolamesa.com', 'AV MEXICO JAPON', '206', 'CIUDAD INDUSTRIAL', 'CELAYA', 'GUANAJUATO', 'MEXICO', '38010', '461', '6118717', 'GLA011113LX4', 1 UNION
SELECT 'GUSTAVO ROSAS CASTILLO', 'GUSTAVO ROSAS CASTILLO', 'GUSTAVO ROSAS', 'JUAN JOSE ESPINOZA BRAVO',3,'gustavo.rosas@arnet.com.mx', 'AV ALCALDE', '2344', 'SANTA MONICA', 'GUADALAJARA', 'JALISCO', 'MEXICO', '44220', '133', '35850120', 'ROCG620507FW4', 1 UNION
SELECT 'HALLIBURTON DE MEXICO S DE RL DE CV', 'HALLIBURTON DE MEXICO S DE RL DE CV', '', 'JUAN RAMOS',3,'samantha.fuentes@halliburton.com', 'AV PASEO LA CHOCA', '5', 'FRACCIONAMIENTO LA CHOCA', 'VILLAHERMOSA', 'TABASCO', 'MEXICO', '86037', '993', '3151387', 'HME560113VAA', 1 UNION
SELECT 'HDI SEGUROS SA DE CV', 'HDI SEGUROS SA DE CV', 'MARCELO RAMIREZ', 'JOSE IVAN MARTIN',1,'marcelo.ramirez@hdi.com.mx', 'AV PASEO DE LOS INSURGENTES', '1701', 'GRANADA INFONAVIT GUANAJUATO', 'LEON', 'GUANAJUATO', 'MEXICO', '0', '', '', 'HSE701218532', 1 UNION
SELECT 'HECTOR ALEJANDRO DELGADO BARRERA', 'HECTOR ALEJANDRO DELGADO BARRERA', 'ALEJANDRO DELGADO', 'DIRECTO',3,'alexdelgado22@hotmail.com', 'AV. DE LA CULTURA', '81', 'FRACC. CIUDAD DEL VALLE', 'TEPIC', 'NAYARIT', 'MEXICO', '63157', '311', '1608182', 'DEBH770411PHA', 1 UNION
SELECT 'HECTOR EFRAIN GONZALEZ ALVAREZ', 'HECTOR EFRAIN GONZALEZ ALVAREZ', '', 'DIRECTO',3,'', 'PRIVADA DE CORREGIDORA', '228', 'FRACCIONAMIENTO MORELOS', 'AGUASCALIENTES', 'AGUASCALIENTES', 'MEXICO', '20298', '', '', 'GOAH590330P66', 1 UNION
SELECT 'HEWLETT-PACKARD MEXICO S DE RL DE CV', 'HEWLETT-PACKARD MEXICO S DE RL DE CV', '', 'DIRECTO',3,'', 'PROLONGACION REFORMA', '700', 'LOMAS DE SANTA FE', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '1210', '', '', 'HME871101RG3', 1 UNION
SELECT 'IC VICTOR MANUEL POZO VAZQUEZ', 'IC VICTOR MANUEL POZO VAZQUEZ', 'VICTOR MANUEL POZO VAZQUEZ', 'DIRECTO',3,'icvictorpozo@gmail.com', 'PEDRO PARGA', '401', 'ZONA CENTRO', 'AGUASCALIENTES', 'AGUASCALIENTES', 'MEXICO', '20000', '449', '9185795', 'POVV570101K71', 1 UNION
SELECT 'INDUSTRIAS DERIVADAS DEL ETILENO SA DE CV', 'INDUSTRIAS DERIVADAS DEL ETILENO SA DE CV', '', 'JORGE ALBERTO MARTINEZ',1,'', 'BOSQUE DE RADIATAS', '34', 'BOSQUES DE LAS LOMAS', 'MEXICO', 'DISTRITO FEDEERAL', 'MEXICO', '5120', '', '', 'IDE811214RH3', 1 UNION
SELECT 'INDUSTRIAS TRICON DE MEXICO SA DE CV', 'INDUSTRIAS TRICON DE MEXICO SA DE CV', '', 'DIRECTO',1,'', 'AV ANZURES', '930', 'LOS FRESNOS', 'NUEVO LAREDO', 'TAMAULIPAS', 'MEXICO', '88290', '1867', '7111420', 'ITM8604119K7', 1 UNION
SELECT 'INFRA SA DE CV', 'INFRA SA DE CV', 'ULISES TENORIO', 'JORGE ALBERTO MARTINEZ',1,'', 'FELIX GUZMAN', '16', 'EL PARQUE', 'NAUCALPAN DE JUAREZ', 'ESTADO DE MÉXICO', 'MEXICO', '53398', '01 55', '5484-4400', 'SER031016TF9', 1 UNION
SELECT 'INGENIERIA ELECTRICA Y CONTROL INSTRUMENTAL S.A. DE C.V.', 'INGENIERIA ELECTRICA Y CONTROL INSTRUMENTAL S.A. DE C.V.', 'EDUARDO ZAPATA', 'JOSE IVAN MARTIN',3,'iecinstr@prodigy.net.mx / eduardo.zapata@iec-ptd.com', 'CONDESA', '325', 'REAL PROVIDENCIA II', 'LEON', 'GUANAJUATO', 'MEXICO', '37231', '1447', '7724600', 'IEC941110IT5', 1 UNION
SELECT 'INGENIERIA Y DESARROLLO ELECTRONICO APLICADA AL LABORATORIO SA DE CV', 'INGENIERIA Y DESARROLLO ELECTRONICO APLICADA AL LABORATORIO SA DE CV', 'ALINE R', 'JORGE ALBERTO MARTINEZ',1,'coordinacion@idealsadecv.com', 'CALLE VERACRUZ', '3', 'COL BENITO JUAREZ', 'MINATITLAN', 'VERACRUZ', 'MEXICO', '96720', '', '', 'IDE100226QX4', 1 UNION
SELECT 'INGENIERIA Y SERVICIOS ELECTRICOS ZAPATA SA DE CV', 'INGENIERIA Y SERVICIOS ELECTRICOS ZAPATA SA DE CV', '', 'DIRECTO',1,'', 'BLVD. EMILIANO ZAPATA PONIENTE', '1320', 'LOS PINOS', 'CULIACAN', 'SINALOA', 'MÉXICO', '80128', '', '', 'ISE070220BM9', 1 UNION
SELECT 'INSTITUTO DE INVESTIGACIONES ELECTRICAS SA DE CV', 'INSTITUTO DE INVESTIGACIONES ELECTRICAS SA DE CV', 'GERARDO RUIZ', 'IVAN RAMIREZ',2,'', 'REFORMA', '13', 'PALMIRA', 'CUERNAVACA', 'MORELOS', 'MEXICO', '62490', '1777', '3623811', 'IIE751125JEA', 1 UNION
SELECT 'INSTITUTO NACIONAL DE ESTADISTICA Y GEOGRAFIA', 'INSTITUTO NACIONAL DE ESTADISTICA Y GEOGRAFIA', '', 'JUAN JOSE ESPINOZA BRAVO',2,'', 'AV HEROE DE NACOZARI SUR', '2301', 'FRACCIONAMIENTO JARDINES DEL PARQUE', 'AGUASCALIENTES', 'AGUASCALIENTES', 'MEXICO', '20276', '449', '9105300', 'INE0804164Z7', 1 UNION
SELECT 'INSTITUTO NACIONAL DE INVESTIGACIONES NUCLERAES', 'INSTITUTO NACIONAL DE INVESTIGACIONES NUCLERAES', 'JUAN MANUEL PEREZ', 'JORGE ALBERTO MARTINEZ',2,'juanmanuel.perez@inin.gob.mx', 'CARRETERA MÉXICO TOLUCA', 'S/N', 'LA MARQUESA', '', 'MEXICO', 'MEXICO', '52750', '', '', 'INI7901272S2', 1 UNION
SELECT 'INTERCABLE SA DE CV', 'INTERCABLE SA DE CV', 'ING. VICTOR BELTRAN', 'JORGE ALBERTO MARTINEZ',1,'vbeltran@interkable.com', 'PRESA TEPUXTEPEC', '40', 'LOMAS HERMOSA', 'MIGUEL HIDALGO', 'DISTRITO FEDERAL', 'MEXICO', '11200', '155', '53501711', 'INT9703267Q4', 1 UNION
SELECT 'JAVIER GARCIA CHAVEZ', 'JAVIER GARCIA CHAVEZ', '', 'SIN DEFINIR',4,'', 'C. ECONOMOS', '5675', 'ARCOS DE GUADALUPE', 'ZAPOPAN', 'JALISCO', 'MEXICO', '45030', '', '', 'CAGJ6508243Q7', 1 UNION
SELECT 'JESUS MONTALVO RAMOS', 'JESUS MONTALVO RAMOS', '', 'DIRECTO',4,'', 'PRIV INDEPENDENCIA', '2323', 'MODERNA', 'MONTERREY', 'NUEVO LEÓN', 'MEXICO', '64530', '', '', 'MORJ720919MI1', 1 UNION
SELECT 'JOHNSON CONTROLS AUTOMOTRIZ MEXICO S DE RL DE CV', 'JOHNSON CONTROLS AUTOMOTRIZ MEXICO S DE RL DE CV', 'JORGE LUIS TORT', 'MICHELLE GALICIA',1,'', 'DAVID ALFARO SIQUEIROS', '104', 'VALLE ORIENTE', 'SAN PEDRO GARZA', 'NUEVO LEON', 'MEXICO', '66269', '181', '81006199', 'JCA9402097Y6', 1 UNION
SELECT 'JORGE LUIS RIOS', 'JORGE LUIS RIOS', '', 'DIRECTO',3,'', 'BLVD MARIANO ESCOBEDO', '4218', 'SAN ISIDRO II', 'LEON', 'GUANAJUATO', 'MEXICO', '37530', '', '', 'RIJO690508TC1', 1 UNION
SELECT 'JOSE HECTOR LOERA QUEZADA', 'JOSE HECTOR LOERA QUEZADA', 'HECTOR LOERA', 'DIRECTO',3,'jhloera@prodigy.net.mx', 'FEDERICO CHOPIN', '5644', 'LA ESTANCIA', 'ZAPOPAN', 'JALISCO', 'MEXICO', '45030', '', '', 'LOQH520808430', 1 UNION
SELECT 'JOSE LUIS BRAVO QUIROZ', 'JOSE LUIS BRAVO QUIROZ', '', 'DIRECTO',3,'', 'CIRCUITO DEL OBRADOR', '228', 'FCC VILLA DE NTRA SRA DE LA ASUNC', 'AGUASCALIENTES', 'AGUASCALIENTES', 'MEXICO', '20126', '', '', 'BAQL470324LD6', 1 UNION
SELECT 'JOSE LUIS LEYVA ESPINOSA', 'JOSE LUIS LEYVA ESPINOSA', 'KARINA LIZBETH E', 'IVAN RAMIREZ',1,'karina.lizbeth@maintekch.com', 'AVENIDA PLAZAS DE ARAGON MANZZNA 5 LOTE 4', '19C 1', 'PLAZAS DE ARAGON MEXICO', 'NAUCALPAN', 'MEXICO', 'MEXICO', '57139', '55', '59483245', 'LEEL860706646', 1 UNION
SELECT 'LAMPARAS GENERAL ELECTRIC S DE RL DE CV', 'LAMPARAS GENERAL ELECTRIC S DE RL DE CV', 'LIC.CINTHYA PINEDA GLZ', 'FRANCISCO UREÑA',3,'cinthya.gonzalez1@ge.com', 'AVENIDA VEINTE DE NOVIEMBRE', '1200', 'TLAXCALA', 'SAN LUIS POTOSI', 'SAN LUIS POTOSÍ', 'MEXICO', '78038', '33', '5000 7249', 'LGE8610247A0', 1 UNION
SELECT 'LAS CERVEZAS MODELO EN MICHOACAN S.A. DE C.V.', 'LAS CERVEZAS MODELO EN MICHOACAN S.A. DE C.V.', '', 'DIRECTO',1,'', 'AV. MADERO PONIENTE', '3283', 'GUADALUPE MORELIA DECIMA Y DOCEAVA', 'MORELIA', 'MICHOACÁN', 'MEXICO', '58140', '', '', 'CMM850709522', 1 UNION
SELECT 'LAURA ARVIZU ESTRADA', 'LAURA ARVIZU ESTRADA', '', 'DIRECTO',1,'', 'JOSE MARIA CANAL', '5144', 'LOMAS DEL PARAISO', 'GUADALAJARA', 'JALISCO', 'MEXICO', '44250', '', '', 'AIEL721205NL7', 1 UNION
SELECT 'MABE SA DE CV', 'MABE SA DE CV', 'ALBINO GARCIA', 'JOSE IVAN MARTIN',1,'albino.garcia@mabe.com.mx', 'ACCESO B', '406', 'PARQUE INDUSTRIAL JURICA', 'PARQUE INDUSTRIAL JURICA', 'QUERETARO', 'MEXICO', '76100', '442', '2114800', 'MAB911203RR7', 1 UNION
SELECT 'MANUFACTURA AVANZADA DE COLIMA SA DE CV', 'MANUFACTURA AVANZADA DE COLIMA SA DE CV', 'RODRIGO GARCIA', 'FRANCISCO UREÑA',1,'rodrigo.garcia@mx.yazaki.com', 'AVENIDA DE LA INDUSTRIA', '4250', 'PARQUE INDUSTRIAL', 'CD JUAREZ', 'CHIHUAHUA', 'MEXICO', '32630', '312', '3163007', 'MAC840626KA3', 1 UNION
SELECT 'MAPFRE TEPEYAC SA DE CV', 'MAPFRE TEPEYAC SA DE CV', 'ROSALBA ALVAREZ ALVAREZ', 'DIRECTO',4,'roalvare@mapfre.com.mx', 'BLVD MANOCENTRO', '5', 'CENTRO URBANO INTERLOMAS', 'HUIXQUILUCAN', 'ESTADO DE MEXICO', 'MEXICO', '52760', '33', '36691948', 'MTE440316E54', 1 UNION
SELECT 'MARIA DE LOS REMEDIOS RUBIO CAPETILLO', 'MARIA DE LOS REMEDIOS RUBIO CAPETILLO', '', 'DIRECTO',4,'', 'CALLE REAL', '11', 'SAN ANTONIO DE LA PUNTA', 'QUERETARO', 'QUERÉTARO', 'MEXICO', '76135', '', '', 'RUCR730714UC4', 1 UNION
SELECT 'MEGACOMPUTER DE MEXICO SA DE CV', 'MEGACOMPUTER DE MEXICO SA DE CV', 'IRVING AGUIRRE', 'JUAN JOSE ESPINOZA BRAVO',3,'irving.systems@hotmail.com', 'AV. AVILA CAMACHO', '2382', 'JARDINES DEL COUNTRY', 'GUADALAJARA', 'JALISCO', 'MEXICO', '44210', '', '', 'MME041220957', 1 UNION
SELECT 'MERIAL DE MEXICO SA DE CV', 'MERIAL DE MEXICO SA DE CV', 'HUGO DIAZ', 'JUAN RAMOS',1,'', 'AV. DE LAS FUENTES', '66', 'PARQUE INDUSTRIAL FINSA', 'EL MARQUEZ', 'QUERÉTARO', 'MEXICO', '76240', '442', '', 'MME9707311V5', 1 UNION
SELECT 'MIDORI VALERIA AGUIRRE VILLA', 'MIDORI VALERIA AGUIRRE VILLA', 'IRVING AGUIRRE VILLA', 'JUAN JOSE ESPINOZA BRAVO',3,'irving.systems@hotmail.com', 'SAN NICOLAS DE BARI', '614', 'RESIDENCIAL SANTA MARGARITA', 'ZAPOPAN', 'JALISCO', 'MEXICO', '45130', '33', '31654509', 'AUVM8901224I7', 1 UNION
SELECT 'MIGUEL GARDUÑO CORREA', 'MIGUEL GARDUÑO CORREA', 'MIGUEL GARDUÑO', 'DIRECTO',1,'manuel@brujulaestrategia.com', '20 DE NOVIEMBRE', '256', 'COL CENTRO', 'MORELIA', 'MICHOACÁN', 'MEXICO', '58000', '', '', 'GACM810129M61', 1 UNION
SELECT 'MINERA FRESNILLO SA DE CV', 'MINERA FRESNILLO SA DE CV', 'HECTOR PEREZ', 'JUAN JOSE ESPINOZA BRAVO',1,'hector_perez@fresnilloplc.com', 'AV HIDALGO', '451', 'CENTRO', 'FRESNILLO', 'ZACATECAS', 'MEXICO', '99000', '1493', '9839000', 'MFR971117KU1', 1 UNION
SELECT 'MOTOROLA SOLUTIONS DE MEXICO SA', 'MOTOROLA SOLUTIONS DE MEXICO SA', 'OLIVIA DELGADO', 'IVAN RAMIREZ',3,'Olivia.delgado@motorolasolutions.com', 'BOSQUE DE ALISOS', '125', 'BOSQUES DE LAS LOMAS', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '5120', '155', '55741359', 'MME781231A76', 1 UNION
SELECT 'MUNICIPIO DE QUERETARO', 'MUNICIPIO DE QUERETARO', '', 'JOSE IVAN MARTIN',2,'', 'BLVD BERNARDO QUINTANA', '10000', 'FRACCIONAMIENTO CENTRO SUR', 'QUERETARO', 'QUERETARO', 'MEXICO', '76090', '.', '.', 'MQU220926DZA', 1 UNION
SELECT 'MXES S DE RL DE CV', 'MXES S DE RL DE CV', '', 'DIRECTO',1,'', 'LAZARO CARDENAS', '3430', 'JARDINES DE SAN IGNACIO', 'ZAPOPAN', 'JALISCO', 'MEXICO', '45040', '33', '36474517', 'MXE010921473', 1 UNION
SELECT 'NAVTEQ SOLUTIONS S DE RL DE CV', 'NAVTEQ SOLUTIONS S DE RL DE CV', 'NAYELI CAMPOS', 'JOSE IVAN MARTIN',1,'nayeli.campos@navteq.com', 'BOULEVARD MANUEL AVILA CAMACHO', '76', 'LOMAS DE CHAPULTEPEC', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11000', '477', '7198703', 'NSO0511229KA', 1 UNION
SELECT 'NESTLE SERVICIOS CORPORATIVOS SA DE CV', 'NESTLE SERVICIOS CORPORATIVOS SA DE CV', '', 'DIRECTO',1,'', 'AV EJERCITO NACIONAL', '453', 'GRANADA', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11520', '155', '52625000', 'NSC040922598', 1 UNION
SELECT 'NEW SYSTEMS DISEÑO Y CONSTRUCCION S.A. DE C.V.', 'NEW SYSTEMS DISEÑO Y CONSTRUCCION S.A. DE C.V.', 'GUSTAVO GARCIA', 'JORGE ALBERTO MARTINEZ',1,'compras@sicisa.net', 'GRAL.FRANCISCO MURGUIA', '120', 'SAN JUAN TLIHUACA', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '2400', '55', '5393 6592', 'NSD110106214', 1 UNION
SELECT 'NIPOJAL SA DE CV', 'NIPOJAL SA DE CV', '', 'DIRECTO',1,'', 'CIRCUNVALACION AGUSTIN YAÑEZ', '2494', 'ARCOS SUR', 'GUADALAJARA', 'JALISCO', 'MEXICO', '44100', '', '', 'NIP890206RS3', 1 UNION
SELECT 'NORGREN MANUFACTURING DE MEXICO SA DE CV', 'NORGREN MANUFACTURING DE MEXICO SA DE CV', 'OSCAR SANCHEZ', 'JUAN RAMOS',1,'osanchez@norgren-mexico.com', 'AVENIDA DE LA MONTAÑA', '120', 'PARQUE INDUSTRIAL QUERETARO SANTA ROSA DE JAUREGUI', 'SANTIAGO DE QUERETARO', 'QUERETARO', 'MEXICO', '76220', '442', '2295000', 'NMM0308145E9', 1 UNION
SELECT 'OTTOMOTORES COMERCIALIZADORA SA DE CV', 'OTTOMOTORES COMERCIALIZADORA SA DE CV', 'Nayelli Zamora', 'DIRECTO',3,'', 'CALZADA SAN LORENZO', '1150', 'CERRO DE LA ESTRELLA', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '9860', '155', '56245676', 'OCO110315Q99', 1 UNION
SELECT 'PEMEX EXPLORACION Y PRODUCCION', 'PEMEX EXPLORACION Y PRODUCCION', '', 'DIRECTO',2,'', 'AV MARINA NACIONAL', '324', 'HUASTECA', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11311', '', '', 'PEP920716XPA', 1 UNION
SELECT 'PEMEX GAS Y PETROQUIMICA BASICA', 'PEMEX GAS Y PETROQUIMICA BASICA', '', 'DIRECTO',2,'', 'AV MARINA NACIONAL', '329', 'PETROLEOS MEXICANOS', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11311', '', '', 'PGP920716MT6', 1 UNION
SELECT 'PEMEX REFINACION', 'PEMEX REFINACION', '', 'DIRECTO',2,'', 'AVENIDA MARINA NACIONAL', '329', 'PETROLEOS MEXICANOS', 'DISTRITO FEDERAL', 'DISTRITO FEDERAL', 'MEXICO', '11311', '', '', 'PRE9207163T7', 1 UNION
SELECT 'PETROLEOS MEXICANOS', 'PETROLEOS MEXICANOS', '', 'DIRECTO',2,'', 'AV MARINA NACIONAL', '329', 'PETROLEOS MEXICANOS', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11311', '', '', 'PME380607P35', 1 UNION
SELECT 'PREMIER FRUTOS DE CALIDAD SA DE CV', 'PREMIER FRUTOS DE CALIDAD SA DE CV', 'EMANUEL UZUETA SALCEDO', 'JUAN JOSE ESPINOZA BRAVO',1,'euzueta@grupopremier.com.mx', 'PRIVADA DE CHICALOTE', '2625', 'MERCADO DE ABASTOS', 'GUADALAJARA', 'JALISCO', 'MEXICO', '44530', '667', '718-2333', 'PFC1101194K5', 1 UNION
SELECT 'PROCESA ALIMENTOS SA DE CV', 'PROCESA ALIMENTOS SA DE CV', 'JESUS PORTOS', 'RUFINO MOCTEZUMA',1,'jportos@dgari.com.mx', 'AV LAS MISIONES', '7', 'PARQUE IND B QUINTANA', 'EL MARQUES', 'QUERETARO', 'MEXICO', '76246', '442', '1924300', 'PAL030325K92', 1 UNION
SELECT 'Promocion de la Cultura y la Educacion Superior del Bajio A.C.', 'Promocion de la Cultura y la Educacion Superior del Bajio A.C.', 'JUAN PABLO AREAS', 'JOSE IVAN MARTIN',4,'', 'Blvd. Jorge Vertiz Campero', '1640', 'Cañada de Alfaro', 'Leon', 'GUANAJUATO', 'MEXICO', '37238', '', '', 'PCE-820712-PP4', 1 UNION
SELECT 'PROSER EMPRESARIAL SA DE CV', 'PROSER EMPRESARIAL SA DE CV', 'MIGUEL GARCIA', 'DIRECTO',1,'frangelproser@gmail.com', 'SIERRA NEVADA', '308', 'LAS ARBOLEDAS 1A SECCION', 'CELAYA', 'GUANAJUATO', 'MEXICO', '38060', '133', '3330038069', 'PEM100910NM5', 1 UNION
SELECT 'RA INGENIERIA Y SERVICIOS INTEGRALES SA DE CV', 'RA INGENIERIA Y SERVICIOS INTEGRALES SA DE CV', 'RUBEN RAMIREZ', 'JORGE ALBERTO MARTINEZ',3,'raingenieria@live.com.mx', 'SUR 67A', '3117', 'VIADUCTO PIEDAD', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '8200', '55', '1735 3189', 'RIS100610SJ5', 1 UNION
SELECT 'RADIO RED FM, S.A. DE C.V.', 'RADIO RED FM, S.A. DE C.V.', 'HECTOR MARTINEZ', 'JORGE ALBERTO MARTINEZ',1,'hmartinz@grc.com.mx', 'AV. CONSTITUYENTES', '1154', 'LOMAS ALTAS C.', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11950', '01 55', '5728-4827', 'RRF940627DR5', 1 UNION
SELECT 'REINMEX SA DE CV', 'REINMEX SA DE CV', 'EDMUNDO HERNANDEZ', 'FRANCISCO UREÑA',3,'EHERNANDEZ@REINMEX.NET', 'INDUSTRIA GALLETERA', '129', 'INDUSTRIAL', 'ZAPOPAN NORTE', 'JALISCO', 'MEXICO', '45130', '33', '36991410', 'REI0311149H6', 1 UNION
SELECT 'RESORT CONDOMINIUMS INTERNATIONAL DE MEXICO S DE RL DE CV', 'RESORT CONDOMINIUMS INTERNATIONAL DE MEXICO S DE RL DE CV', 'SALVADOR RODRIGUEZ', 'MICHELLE GALICIA',1,'salvador.rodriguez@latam.rci.com', 'HORACIO', '1855', 'MORALES POLANCO', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11510', '155', '52831015', 'RCI930401GV1', 1 UNION
SELECT 'SAC ENERGIA SA DE CV', 'SAC ENERGIA SA DE CV', '', 'DIRECTO',3,'', 'CIRCUITO EDUCADORES', '40', 'CIUDAD SATELITE', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '53100', '55', '53654821', 'SEN0012153V1', 1 UNION
SELECT 'SANMINA-SCI SYSTEMS DE MEXICO SA DE CV', 'SANMINA-SCI SYSTEMS DE MEXICO SA DE CV', 'NESTOR LOMELI', 'JUAN JOSE ESPINOZA BRAVO',1,'nestor.lomeli@sanmina-sci.com', 'AV SOLIDARIDAD IBEROAMERICANA', '7020', 'CLUB DE GOLF ATLAS', 'GUADALAJARA', 'JALISCO', 'MEXICO', '45680', '', '', 'SSM950412Q42', 1 UNION
SELECT 'SAUL CARMONA SANCHEZ', 'SAUL CARMONA SANCHEZ', 'SAUL CARMONA SANCHEZ', 'IVAN RAMIREZ',3,'saul.carmonasanchez@yahoo.com.mx', 'AV TAMAULIPAS', '53', 'SANTA LUCIA', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '1500', '55', '56378192', 'CASS730305Q17', 1 UNION
SELECT 'SCHNEIDER ELECTRIC IT MEXICO SA DE CV', 'SCHNEIDER ELECTRIC IT MEXICO SA DE CV', '', 'DIRECTO',3,'', 'BLVD MANUEL AVILA CAMACHO', '40', 'LOMAS DE CHAPULTEPEC', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11000', '155', '91380200', 'SEI980917M87', 1 UNION
SELECT 'SECRETARIA DE COMUNICACIONES Y TRANSPORTES', 'SECRETARIA DE COMUNICACIONES Y TRANSPORTES', '', 'RUFINO MOCTEZUMA',1,'', 'KM 12 CARRETERA QUERETARO GALINDO', 'S/N', 'SANFANDILA', '', 'QUERÉTARO', 'MEXICO', '76703', '', '', 'SCT060601G50', 1 UNION
SELECT 'SECRETARIADO EJECUTIVO DEL SISTEMA ESTATAL DE SEGURIDAD PUBLICA', 'SECRETARIADO EJECUTIVO DEL SISTEMA ESTATAL DE SEGURIDAD PUBLICA', '', 'JOSE IVAN MARTIN',2,'', 'SAN MATIAS', '18', 'SAN JAVIER', 'GUANAJUATO', 'GUANAJUATO', 'MEXICO', '36020', '', '', 'SES100713RF8', 1 UNION
SELECT 'SEGUROS EL POTOSI SA', 'SEGUROS EL POTOSI SA', 'PEDRO LUIS TELLO GONZALEZ', 'JUAN RAMOS',1,'pltello@elpotosi.com.mx', 'AV V CARRANZA', '426', 'CENTRO', 'SAN LUIS POTOSI', 'SAN LUIS POTOSI', 'MEXICO', '78000', '444', '834 90 00', 'SPO830427DQ1', 1 UNION
SELECT 'SERVICIO ARROS S.A. DE C.V.', 'SERVICIO ARROS S.A. DE C.V.', '', 'JUAN RAMOS',4,'', 'PASEO DE LA REFORMA', '389', 'CUAUHTEMOC', 'MEXICO D.F.', 'DISTRITO FEDERAL', 'MEXICO', '6500', '55', '5980 2933', 'SAR8407032U7', 1 UNION
SELECT 'SERVICIO GEOLOGICO MEXICANO', 'SERVICIO GEOLOGICO MEXICANO', '', 'JUAN RAMOS',1,'emarquez@sgm.gob.mx', 'BLVD. FELIPE ANGELES', 'KM 93.50-4', 'VENTA PRIETA', 'PACHUCA', 'HIDALGO', 'MEXICO', '42080', '771', '7114266', 'SGM7602222H2', 1 UNION
SELECT 'SERVICIOS VISTAMEX SA DE CV', 'SERVICIOS VISTAMEX SA DE CV', 'ADRIANA ORTEGA', 'JUAN RAMOS',1,'aortega@serviciosvistamex.com', 'AUTOPISTA QUERETARO IRAPUATO KM 36', 'S/N', 'ZONA INDUSTRIAL', 'APASEO EL GRANDE', 'GUANAJUATO', 'MEXICO', '38160', '461', '618 6193', 'SVI071129N14', 1 UNION
SELECT 'SERVICIOS Y PROVEDURIA INDUSTRIAL SA DE CV', 'SERVICIOS Y PROVEDURIA INDUSTRIAL SA DE CV', 'ING. JAVIER PEREZ ESCOBAR', 'DIRECTO',3,'ventas@sepinsa.com.mx', 'CALLE 53 ENTRE 38-A Y 38-B', '414', 'CALETA', 'CD. DEL CARMEN', 'CAMPECHE', 'MEXICO', '24110', '938', '153 1082', 'SPI0905093C8', 1 UNION
SELECT 'SIEMENS SERVICIOS SA DE CV', 'SIEMENS SERVICIOS SA DE CV', 'ANTONIO NUÑEZ', 'JOSE IVAN MARTIN',1,'inv.central.mx@siemens.com', 'EJERCITO NACIONAL', '350', 'POLANCO V SECCION', 'MIGUEL HIDALGO', 'DISTRITO FEDERAL', 'MEXICO', '11560', '', '', 'SIE931112PA1', 1 UNION
SELECT 'SINERPOL ENERGIA S.A. de C.V.', 'SINERPOL ENERGIA S.A. de C.V.', '', 'DIRECTO',1,'sinerpol@gmail.com', 'PIRENEOS', '500', 'ZONA INDUSTRIAL BENITO JUAREZ', 'QUERETARO', 'QUERÉTARO', 'MEXICO', '76120', '442', '148-07-83', 'SIN060717GE7', 1 UNION
SELECT 'SISTEMAS ELECTRONICOS Y DE RADIOCOMUNICACION SA DE CV', 'SISTEMAS ELECTRONICOS Y DE RADIOCOMUNICACION SA DE CV', 'OLGA CORTINA', 'JORGE ALBERTO MARTINEZ',3,'sersa1603@prodigy.net.mx', 'ARAGON', '87 PISO 1', 'ALAMOS', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '3400', '01 55', '55380565', 'SER031016TF9', 1 UNION
SELECT 'SISTEMAS Y COMPUTADORES DEL SURESTE, S.A. DE C.V.', 'SISTEMAS Y COMPUTADORES DEL SURESTE, S.A. DE C.V.', '', 'DIRECTO',4,'', 'ALMENDROS', '320', 'FRACC. LAGO ILUSIONES', 'VILLAHERMOSA CENTRO', 'TABASCO', 'MEXICO', '86040', '', '', 'SCS9807287V8', 1 UNION
SELECT 'SISTEMUNDO NEOTECNOLOGICO S.A. DE C.V.', 'SISTEMUNDO NEOTECNOLOGICO S.A. DE C.V.', '', 'JORGE ALBERTO MARTINEZ',4,'', 'GRAL. FRANCISCO MURGUIA', '120-A', 'SAN JUAN TLIHUACA', 'AZCAPOTZALCO', 'AZCAPOTZALCO', 'ESTADO DE MÉXICO', '2400', '', 'GOBIERNO', 'SNE080702GSA', 1 UNION
SELECT 'SITE SERVICIO Y MANTENIMIENTO SA DE CV', 'SITE SERVICIO Y MANTENIMIENTO SA DE CV', 'ANA MARIA OLVERA', 'DIRECTO',1,'anamaria.olvera@site-servicio.com', 'CIRCUITO INTERIOR JOSE VASCONCELOS', '148', 'CONDESA', 'CUAUHTEMOC', 'DISTRITO FEDERAL', 'MEXICO', '6140', '', '', 'SSM0401221I0', 1 UNION
SELECT 'SOLUCIONES EN CONTROL ELECTRICO SA DE CV', 'SOLUCIONES EN CONTROL ELECTRICO SA DE CV', 'LILIANA RENTERIA', 'JUAN RAMOS',1,'lrenteria@scesamexico.com.mx', 'EJE 8', '93', 'SAN RAFAEL', 'MEXICO', 'ESTADO DE MÉXICO', 'MEXICO', '55719', '55', '2644 0021', 'SCE0106221P3', 1 UNION
SELECT 'SOPORTE TERMICO Y MECANICO SA DE CV', 'SOPORTE TERMICO Y MECANICO SA DE CV', 'CARLOS MARTINEZ', 'JUAN JOSE ESPINOZA BRAVO',3,'c.martinez@soportetermico.com', 'J ROMO', '1032', 'MODERNA', 'GUADALAJARA', 'JALISCO', 'MEXICO', '44190', '33', '3650 0911', 'STM0402125F4', 1 UNION
SELECT 'ST SOLUCIONES EMPRESARIALES SA DE CV', 'ST SOLUCIONES EMPRESARIALES SA DE CV', 'JORGE SANCHEZ', 'JUAN JOSE ESPINOZA BRAVO',1,'soluciones@stse.com.mx', 'TUXPAN', '89', 'ROMA SUR', 'CUAUHTEMOC', 'DISTRITO FEDERAL', 'MEXICO', '6760', '55', '35 39 58 43', 'SSE0410296W6', 1 UNION
SELECT 'STT SOLUCIONES TOTALES EN TELECOMUNICACIONES SA DE CV', 'STT SOLUCIONES TOTALES EN TELECOMUNICACIONES SA DE CV', 'OMAR MARTINEZ', 'IVAN RAMIREZ',3,'omartinez@sttsoluciones.com.mx', 'COPERNICO', '172', 'ANZURES', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11590', '', '', 'SST961021DB2', 1 UNION
SELECT 'TECNOLOGIA PARA AHORRO DE ENERGIA,S.A. DE C.V.', 'TECNOLOGIA PARA AHORRO DE ENERGIA,S.A. DE C.V.', 'LILIBET FRANCO', 'JUAN JOSE ESPINOZA BRAVO',1,'tec_ahorro_energia@prodigy.net.mx', 'AV. LOPEZ MATEOS SUR', '1290-4', 'CHAPALITA ORIENTE', 'GUADALAJARA', 'JALISCO', 'MEXICO', '44510', '33', '36 47 14 25', 'TAE9301144N6', 1 UNION
SELECT 'TEL.IND.MEXICANA DE TELECOMUNICACIONES SA DE CV', 'TEL.IND.MEXICANA DE TELECOMUNICACIONES SA DE CV', 'AGUSTIN TOPETE', 'JUAN JOSE ESPINOZA BRAVO',1,'hpartida@mtnet.com.mx', 'PERIFERICO SUR', '7980', 'CAMINO REAL A SANTA ANITA', 'GUADALAJARA', 'JALISCO', 'MEXICO', '45600', '33', '3884-1553', 'TIM9006293D6', 1 UNION
SELECT 'TELEFONIA Y CONECTIVIDAD EN INFORMATICA SA', 'TELEFONIA Y CONECTIVIDAD EN INFORMATICA SA', 'RODRIGO TOLENTINO', 'DIRECTO',3,'info@tycsa.info', 'AQUILES SERDAN', '1624', 'CENTRO', 'VERACRUZ', 'VERACRUZ', 'MEXICO', '91700', '229', '9310087', 'TCI000523DD6', 1 UNION
SELECT 'TELVENT MEXICO SA DE CV', 'TELVENT MEXICO SA DE CV', '', 'DIRECTO',3,'', 'BAHIA DE SANTA BARBARA', '174', 'VERONICA ANZURES', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11300', '155', '55260738', 'TME9006203Q6', 1 UNION
SELECT 'TERMINAL INTERNACIONAL DE MANZANILLO SA DE CV', 'TERMINAL INTERNACIONAL DE MANZANILLO SA DE CV', '', 'DIRECTO',1,'', 'AV. TENIENTE AZUETA', '29', 'BUROCRATA', 'MANZANILLO', 'COLIMA', 'MEXICO', '28250', '314', '3312701', 'TIM980730NK3', 1 UNION
SELECT 'TETRA PAK QUERETARO SA DE CV', 'TETRA PAK QUERETARO SA DE CV', 'JORGE RIVERA', 'JOSE IVAN MARTIN',1,'Jorge.Rivera@tetrapak.com', 'AV. EJERCITO NACIONAL', '843-B ACC', 'GRANADA', 'MEXICO DF', 'MEXICO DF', 'MEXICO', '11520', '', '', 'TPQ9112231K3', 1 UNION
SELECT 'TETRA PAK SA DE CV', 'TETRA PAK SA DE CV', 'JORGE RIVERA', 'JOSE IVAN MARTIN',1,'Jorge.rivera@tetrapak.com', 'AV EJERCITO NACIONAL', '843-B ACC', 'GRANADA', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11520', '442', '2112000', 'TPA920117QJ3', 1 UNION
SELECT 'THE CAPITA CORPORATION DE MEXICO SA DE CV SOFOM ENR', 'THE CAPITA CORPORATION DE MEXICO SA DE CV SOFOM ENR', 'MARIA LOPEZ CAMPICHE', 'JOSE IVAN MARTIN',1,'Maria.LopezCampiche@cit.com', 'BOULEVARD ADOLFO LOPEZ MATEOS', '2009', 'LOS ALPES DELEGACION ALVARO OBREGON', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '1010', '', '', 'CCM9508284K3', 1 UNION
SELECT 'THYSSENKRUPP SYSTEM ENGINEERING SA DE CV', 'THYSSENKRUPP SYSTEM ENGINEERING SA DE CV', 'DANIEL RAMIREZ', 'JUAN RAMOS',1,'daniel.ramirez@thyssenkrupp.com', 'AV DEL MARQUEZ', '36', 'PARQUE INDUSTRIAL BERNARDO QUINTANA', 'EL COLORADO', 'QUERETARO', 'MEXICO', '76246', '442', '1924000', 'TSE990609LW2', 1 UNION
SELECT 'TIENDAS CHEDRAUI SA DE CV', 'TIENDAS CHEDRAUI SA DE CV', 'EULOJIO MEJIA', 'IVAN RAMIREZ',1,'emejia@chedraui.com.mx', 'AV CONSTITUYENTES', '1150', 'LOMAS ALTAS', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11950', '228', '8 42 11 00', 'TCH850701RM1', 1 UNION
SELECT 'TODITO CARD SA DE CV', 'TODITO CARD SA DE CV', '', 'DIRECTO',1,'', 'FRANCISCO FERNANDEZ TREVIÑO', '211', 'LEONES', 'MONTERREY', 'NUEVO LEÓN', 'MEXICO', '64600', '81', '82328096', 'TCA050929BM8', 1 UNION
SELECT 'TRUPER SA DE CV', 'TRUPER SA DE CV', 'JAVIER REYES', 'MICHELLE GALICIA',1,'jreyes@truper.com', 'PARQUE INDUSTRIAL', '1', 'JILOTEPEC', 'JILOTEPEC', 'ESTADO DE MEXICO', 'MEXICO', '54240', '155', '53876691', 'THE791105HP2', 1 UNION
SELECT 'TUBOS DE ACERO DE MEXICO SA', 'TUBOS DE ACERO DE MEXICO SA', '', 'JORGE ALBERTO MARTINEZ',1,'', 'CARRETERA MEXICO VERACRUZ', '', 'DELFINO VALENZUELA', 'VERACRUZ', 'VERACRUZ', 'MEXICO', '91697', '', '', 'TAM520130D49', 1 UNION
SELECT 'UNIFRIO SA DE CV', 'UNIFRIO SA DE CV', 'ING. JORGE IVAN LUNA MARTINEZ', 'DIRECTO',3,'', 'CARRETERA GUADALAJARA A MORELIA', '7783', 'BONANZA RESIDENCIAL', 'ZAPOPAN', 'JALISCO', 'MEXICO', '45645', '', '', 'UNI070201N38', 1 UNION
SELECT 'UNIVERSIDAD AUTONOMA DE QUERETARO', 'UNIVERSIDAD AUTONOMA DE QUERETARO', '', 'JUAN RAMOS',1,'', 'CERRO DE LAS CAMPANAS', '', 'LAS CAMPANAS', 'QUERETARO', 'QUERETARO', 'MEXICO', '76010', '', '', 'UAQ510111MQ9', 1 UNION
SELECT 'UNIVERSIDAD DE GUADALAJARA', 'UNIVERSIDAD DE GUADALAJARA', '', 'JUAN JOSE ESPINOZA BRAVO',2,'jose.morales@cucei.udg.mx', 'AV JUAREZ', '975', 'CENTRO', 'GUADALAJARA', 'JALISCO', 'MEXICO', '44100', '33', '31342222', 'UGU250907MH5', 1 UNION
SELECT 'UNIVERSIDAD JUAREZ AUTONOMA DE TABASCO', 'UNIVERSIDAD JUAREZ AUTONOMA DE TABASCO', '', 'MICHELLE GALICIA',1,'', 'AVENIDA UNIVERSIDAD ZONA DE LA CULTURA', '', 'MAGISTERIAL', 'VILLAHERMOSA', 'TABASCO', 'MEXICO', '86040', '993', '38581500', 'UJA5801014N3', 1 UNION
SELECT 'UREBLOCK SA DE CV', 'UREBLOCK SA DE CV', 'ALEJANDRO VILLANUEVA', 'FRANCISCO UREÑA',1,'avillanueva@ureblock.com.mx', 'CALLE 4', '300', 'FRACC. LOS ROBLES', 'ZAPOPAN', 'JALISCO', 'MEXICO', '45134', '33', '3836 4000', 'URE780612C48', 1 UNION
SELECT 'VALSI AGRICOLA INDUSTRIAL SA DE CV', 'VALSI AGRICOLA INDUSTRIAL SA DE CV', 'MOISES VALENCIA', 'DIRECTO',1,'mvalencia@valsi.mx', 'CALLE 22', '2795', 'ZONA INDUSTRIAL', 'GUADALAJARA', 'JALISCO', 'MEXICO', '0', '33', '3001 1038', 'VAI 991008 KW1', 1 UNION
SELECT 'VANGUARDIA AUTOMOTRIZ SA DE CV', 'VANGUARDIA AUTOMOTRIZ SA DE CV', '', 'DIRECTO',1,'', 'AV VALLARTA', '5424', 'JARDINES VALLARTA', 'ZAPOPAN', 'JALISCO', 'MEXICO', '45027', '', '', 'VAU970623SS3', 1 UNION
SELECT 'VENTA DE BOLETOS POR COMPUTADORA S.A. DE C.V.', 'VENTA DE BOLETOS POR COMPUTADORA S.A. DE C.V.', 'ING. JUAN MANUEL OROZCO', 'JORGE ALBERTO MARTINEZ',1,'jmorozco@ticketmaster.com', 'LEIBNITZ', '1', 'ANZURES', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11590', '55', '53259050', 'VBC910617SR1', 1 UNION
SELECT 'VENTILACION Y AIRE ACONDICIONADO S.A.', 'VENTILACION Y AIRE ACONDICIONADO S.A.', '', 'DIRECTO',3,'ventair@hotmail.com', 'AV. ORGANIZACION', '1038', 'TEPEYAC CASINO', 'GUADALAJARA', 'JALISCO', 'MEXICO', '45050', '', '', 'VAA810306FNA', 1 UNION
SELECT 'XEDKR AM SA DE CV', 'XEDKR AM SA DE CV', 'ING. HECTOR MARTINEZ', 'JORGE ALBERTO MARTINEZ',1,'hmartinz@grc.com.mx', 'AV CONSTITUYENTES', '1154', 'LOMAS ALTAS', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11950', '01 55', '57-28-48-27', 'XAM841205KY4', 1 UNION
SELECT 'XEQR-FM SA DE CV', 'XEQR-FM SA DE CV', '', 'JORGE ALBERTO MARTINEZ',1,'', 'AV CONSTITUYENTES', '1154', 'LOMAS ALTAS', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11950', '155', '57284827', 'XFM901003397', 1 UNION
SELECT 'XERC-FM S.A. DE C.V.', 'XERC-FM S.A. DE C.V.', '', 'JORGE ALBERTO MARTINEZ',1,'', 'AV. CONSTITUYENTES', '1154', 'LOMAS ALTAS', 'MEXICO', 'DISTRITO FEDERAL', 'MEXICO', '11950', '', '', 'XFM901003Q32', 1 UNION
SELECT 'YAMADA-VISTAMEX SA DE CV', 'YAMADA-VISTAMEX SA DE CV', 'JESUS TORRES RICO', 'JUAN RAMOS',1,'jtorres@yvmex.com', 'AUTOPISTA QUERETARO IRAPUATO KM 36', '', 'ZONA INDUSTRIAL', 'APASEO EL GRANDE', 'GUANAJUATO', 'MEXICO', '38160', '461', '175 1011', 'YAM111101AZ8', 1 ;

	END IF;

	-- Lista de precions - Inicial'
	IF(SELECT count(*) FROM blackstarDb.codexPriceList) = 0 THEN
		INSERT INTO blackstarDb.codexPriceList(code, name, price)
		SELECT 'M1100A-B-10-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 10KVA EXP. 50KVA (SIN BATERIAS)',16725 UNION
		SELECT 'M1100A-B-20-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 20KVA EXP. 50KVA (SIN BATERIAS)',20412 UNION
		SELECT 'M1100A-B-30-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 30KVA EXP. 50KVA (SIN BATERIAS)',23150 UNION
		SELECT 'M1100A-B-40-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 40KVA EXP. 50KVA (SIN BATERIAS)',27588 UNION
		SELECT 'M1100A-B-50-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 50KVA EXP. 50KVA (SIN BATERIAS)',30978 UNION
		SELECT 'M1100A-A-10-208-208-1B','UPS MODULAR 1100 MARCA MITSUBISHI 10KVA EXP. 20KVA (CON BATERIAS PARA 18 MIN)',16661 UNION
		SELECT 'M1100A-A-20-208-208-1B','UPS MODULAR 1100 MARCA MITSUBISHI 20KVA EXP. 20KVA (CON BATERIAS PARA 5 MIN)',20484 UNION
		SELECT 'NETCOM-1100','TARJETA DE MONITOREO',1403 UNION
		SELECT 'PMAU-02','MODULO DE PODER PARA EQUIPOS MITSUBISHI (10KVA)',8961 UNION
		SELECT 'BB1217-1100-01','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 (UN ANILLO) Marca:CSB Dimensión: ',3566 UNION
		SELECT 'BB1217-1100-02','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 (DOS ANILLOS en el mismo gabinete)',5781 UNION
		SELECT 'BB1217-1100-03','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 (TRES ANILLOS en el mismo gabinete)',7996 UNION
		SELECT 'BB1217-1100-04','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 (CUATRO ANILLOS en el mismo gabinete)',10545 UNION
		SELECT 'M1100B-A-10-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 10KVA EXP. 80KVA (SIN BATERIAS)',23329 UNION
		SELECT 'M1100B-A-20-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 20KVA EXP. 80KVA (SIN BATERIAS)',28109 UNION
		SELECT 'M1100B-A-30-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 30KVA EXP. 80KVA (SIN BATERIAS)',32889 UNION
		SELECT 'M1100B-A-40-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 40KVA EXP. 80KVA (SIN BATERIAS)',37669 UNION
		SELECT 'M1100B-A-50-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 50KVA EXP. 80KVA (SIN BATERIAS)',42449 UNION
		SELECT 'M1100B-A-60-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 60KVA EXP. 80KVA (SIN BATERIAS)',45899 UNION
		SELECT 'M1100B-A-70-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 70KVA EXP. 80KVA (SIN BATERIAS)',50541 UNION
		SELECT 'M1100B-A-80-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 80KVA EXP. 80KVA (SIN BATERIAS)',55182 UNION
		SELECT 'NETCOM-1100','TARJETA DE MONITOREO',1447 UNION
		SELECT 'PMAU-02','MODULO DE PODER PARA EQUIPOS MITSUBISHI (10KVA)',10698 UNION
		SELECT 'BB-80-1217-1100-01','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 DE HASTA 80KVA (UN ANILLO)',4188 UNION
		SELECT 'BB-80-1217-1100-02','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 DE HASTA 80KVA (DOS ANILLO)',6498 UNION
		SELECT 'BB-80-1217-1100-03','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 DE HASTA 80KVA (TRES ANILLO)',8809 UNION
		SELECT 'BB-80-1217-1100-04','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 DE HASTA 80KVA (CUATRO ANILLO)',11119 UNION
		SELECT 'BB-80-1217-1100-05','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 DE HASTA 80KVA (CINCO ANILLO)',13430 UNION
		SELECT 'M9900A-A-080-480-480','UPS MARCA MITSUBISHI 9900A 80KVA (SIN BATERIAS)',43207 UNION
		SELECT 'M9900A-A-100-480-480 ','UPS MARCA MITSUBISHI 9900A 100KVA (SIN BATERIAS)',44583 UNION
		SELECT 'M9900A-A-150-480-480 ','UPS MARCA MITSUBISHI 9900A 150KVA (SIN BATERIAS)',52429 UNION
		SELECT 'M9900A-A-225-480-480 ','UPS MARCA MITSUBISHI 9900A 225KVA (SIN BATERIAS)',69279 UNION
		SELECT 'M9900B-A-300-480-480-MSC','UPS MARCA MITSUBISHI 9900B 300KVA (SIN BATERIAS)',89682 UNION
		SELECT 'M9900B-A-500-480-480-4','UPS MARCA MITSUBISHI 9900B 500KVA (SIN BATERIAS)',122786 UNION
		SELECT 'M9900B-A-750-480-480-4','UPS MARCA MITSUBISHI 9900B 750KVA (SIN BATERIAS)',176844 UNION
		SELECT 'BB1255-9900','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 9900 Marca: Dynasty 12V 55AH',10694 UNION
		SELECT 'BB1275-9900','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 9900 Marca: Dynasty 12V 75AH',11506 UNION
		SELECT 'BB1285-9900','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 9900 Marca: Dynasty 12V 85AH',12562 UNION
		SELECT 'BB12100-9900','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 9900 Marca: Dynasty 12V 100AH',17728 UNION
		SELECT 'LINKS-INT-80','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 80KVA',508 UNION
		SELECT 'LINKS-INT-100','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 100KVA',508 UNION
		SELECT 'LINKS-INT-150','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 150KVA',761 UNION
		SELECT 'LINKS-INT-225','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 225KVA POR ANILLO',888 UNION
		SELECT 'LINKS-INT-300','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 300KVA',1142 UNION
		SELECT 'LINKS-INT-500','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 500KVA',2030 UNION
		SELECT 'LINKS-INT-750','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 750KVA',2157 UNION
		SELECT '7011A-60','7011A UPS MODULES 6KVA',10227 UNION
		SELECT '7011A-80','7011A UPS MODULES 8KVA',16034 UNION
		SELECT '7011A-100','7011A UPS MODULES 10KVA',16388 UNION
		SELECT '7011A-12.0','7011A UPS MODULES 12KVA',16830 UNION
		SELECT 'MBS-7011A-3','7011A Maintenance Bypass Switches 6 8 or 10kva',1299 UNION
		SELECT 'MBS-7011A-4','7011A Maintenance Bypass Switches 12kva',1743 UNION
		SELECT 'BC7-18/2P007-006-40','7011A Battery Cabinets (17.9"x32.8"x27.7") con un tiempo de respaldo de 38 minutos para un UPS de 6kVA',3242 UNION
		SELECT 'BC7-18P007-006-40','7011A Battery Cabinets (17.9"x32.8"x27.7") con un tiempo de respaldo de 22 minutos para un UPS de 6kVA',2151 UNION
		SELECT 'BC7-18P080-006-40','7011A Battery Cabinets (17.9"x32.8"x27.7") con un tiempo de respaldo de 53 minutos para un UPS de 6kVA',2758 UNION
		SELECT 'BC11-18/2P007-008-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 38 minutos para un UPS de 6kVA y 39 para un UPS de 8kVA',3748 UNION
		SELECT 'BC11-18/2P007-010-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 28 minutos para un UPS de 10kVA',3748 UNION
		SELECT 'BC11-18/2P007-012-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 22 minutos para un UPS de 12kVA',3748 UNION
		SELECT 'BC11-18/2P080-010-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 65 minutos para un UPS de 10kVA',4967 UNION
		SELECT 'BC11-18/2P080-012-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 53 minutos para un UPS de 12kVA',4967 UNION
		SELECT 'BC11-18/3P007-008-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 55 minutos para un UPS de 6kVA y 53 para un UPS de 8kVA',4840 UNION
		SELECT 'BC11-18/3P007-010-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 38 minutos para un UPS de 10kVA',4840 UNION
		SELECT 'BC11-18/3P007-012-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 29 minutos para un UPS de 12kVA',4840 UNION
		SELECT 'BC11-18P007-008-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 22 minutos para un UPS de 6kVA y 27 para un UPS de 8kVA',2660 UNION
		SELECT 'BC11-18P007-010-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 19 minutos para un UPS de 10kVA',2660 UNION
		SELECT 'BC11-18P007-012-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 15 minutos para un UPS de 12kVA',2660 UNION
		SELECT 'BC11-18P080-008-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 53 minutos para un UPS de 6kVA y 51 minutos para un UPS de 8kVA',3268 UNION
		SELECT 'BC11-18P080-010-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 36 minutos para un UPS de 10kVA',3268 UNION
		SELECT 'BC11-18P080-012-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 28 minutos para un UPS de 12kVA',3268 UNION
		SELECT 'BC11-18P100-008-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 58 minutos para un UPS de 8kVA',4098 UNION
		SELECT 'BC11-18P100-010-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 42 minutos para un UPS de 10kVA',4098 UNION
		SELECT 'BC11-18P100-012-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 33 minutos para un UPS de 12kVA',4098 UNION
		SELECT 'BC25-U200-6UL','Battery Cabinets 6kva battery cabinet',8270 UNION
		SELECT 'BC25-U200-8UL','Battery Cabinets 8kva battery cabinet',8270 UNION
		SELECT 'BC25-U300-10UL','Battery Cabinets 10kva battery cabinet',9239 UNION
		SELECT 'BC25-U350-12UL','Battery Cabinets 12kva battery cabinet',9977 UNION
		SELECT 'MCP-104-S','MUCM without DC power supply',1718 UNION
		SELECT 'MCP-104-10004-S','MUCM with DC power supply',2289 UNION
		SELECT 'NETCOM2-SEC-10004-S','Netcom with DC power supply',1353 UNION
		SELECT 'NETCOM-SD','Netcom shutdown codes (price per code) MUST be purchased in increments of (10)',19;

	END IF;

	-- Tipos de formas de pago
	IF(SELECT count(*) FROM blackstarDb.codexPaymentType) = 0 THEN
		INSERT INTO blackstarDb.codexPaymentType(_id, name, description)
		SELECT 1, 'Contado', 'Pago de contado' UNION
		SELECT 2, 'Credito', 'Credito';
	END IF;

	-- Tipos de moneda
	IF(SELECT count(*) FROM blackstarDb.codexCurrencyType) = 0 THEN
		INSERT INTO blackstarDb.codexCurrencyType(_id, name, description)
		SELECT 1, 'USD', 'Dolares' UNION
		SELECT 2, 'MXN', 'Pesos mexicanos';
	END IF;

	-- Tipos de IVA
	IF(SELECT count(*) FROM blackstarDb.codexTaxesTypes) = 0 THEN
		INSERT INTO blackstarDb.codexTaxesTypes(_id, name, description, value)
		SELECT 1, 'IVA Generalizado', 'IVA Generalizado', 16.00;
	END IF;

	-- Tipos de proyecto (partidas)
	IF(SELECT count(*) FROM blackstarDb.codexProjectEntryTypes) = 0 THEN
		INSERT INTO blackstarDb.codexProjectEntryTypes(_id, name, productType)
		SELECT 9005, 'INSTALACIONES DIVERSAS', 'S' UNION
		SELECT 9023, 'SERVICIOS DE ESTUDIO DE CALIDAD ELECTRICA', 'S' UNION
		SELECT 9016, 'SERVICIOS DE ESTUDIO TERMOGRAFICO', 'S' UNION
		SELECT 9011, 'SERVICIOS EVENTUALES', 'S' UNION
		SELECT 40001, 'POLIZA DE MANTENIMIENTO PREVENTIVO/CORRECTIVO P/UPS', 'S' UNION
		SELECT 40002, 'POLIZA DE MANTENIMIENTO PREVENTIVO/CORRECTIVO P/AIRE', 'S' UNION
		SELECT 40003, 'POLIZA DE MANTENIMIENTO PREVENTIVO/CORRECTIVO P/PLANTA', 'S' UNION
		SELECT 40010, 'POLIZA MANTTO PREVENTIVO/CORRECTIVO P/CA Y VV', 'S' UNION
		SELECT 9006, 'POLIZA DE MANTENIMIENTOS VARIOS', 'S' UNION
		SELECT 9090, 'POLIZA DE MANTENIMIENTO PREVENTIVO/CORRECTIVO P/DETECCION Y SUPRESION DE INCENDIOS', 'S' UNION
		SELECT 9032, 'PROYECTO DE UPS', 'P' UNION
		SELECT 9033, 'PROYECTO DE PLANTA', 'P' UNION
		SELECT 9034, 'PROYECTO DE MONITOREO', 'S' UNION
		SELECT 9035, 'PROYECTO DE AIRE', 'P' UNION
		SELECT 9037, 'PROYECTO DE CALIDAD DE ENERGIA', 'S' UNION
		SELECT 9038, 'PROYECTO DE BATERIAS', 'P' UNION
		SELECT 9041, 'PROYECTO DE RACK', 'P' UNION
		SELECT 9049, 'PROYECTO DE SEGURIDAD FISICA', 'S';
	END IF;

	-- Tipos de item (detalle partida)
	IF(SELECT count(*) FROM blackstarDb.codexProjectItemTypes) = 0 THEN
		INSERT INTO blackstarDb.codexProjectItemTypes(name)
		SELECT 'Lista de precios' UNION	
		SELECT 'Requisicion' UNION
		SELECT 'Abierto';
	END IF;

	IF(SELECT count(*) FROM blackstarDb.cstOffice) = 0 THEN
		INSERT INTO blackstarDb.cstOffice(cstId, officeId)
			SELECT 'portal-servicios@gposac.com.mx', 'Q' UNION
			SELECT 'liliana.diaz@gposac.com.mx','G' UNION
			SELECT 'saul.andrade@gposac.com.mx', 'G';
	END IF;

	IF(SELECT count(*) FROM blackstarDb.sequence WHERE sequenceTypeId IN ('Q','M','G')) = 0 THEN
		INSERT INTO blackstarDb.sequence (sequenceTypeId, sequenceNumber)
			SELECT 'Q', 500 UNION
			SELECT 'M', 500 UNION
			SELECT 'G', 500;
	END IF;
	
	UPDATE blackstarDb.sequence SET description = 'Cedulas de proyecto QRO' WHERE sequenceTypeId = 'Q' AND description IS NULL;
	UPDATE blackstarDb.sequence SET description = 'Cedulas de proyecto MXO' WHERE sequenceTypeId = 'M' AND description IS NULL;
	UPDATE blackstarDb.sequence SET description = 'Cedulas de proyecto GDL' WHERE sequenceTypeId = 'G' AND description IS NULL;

	Call blackstarDb.UpsertUser('saul.andrade@gposac.com.mx','Saul Andrade');
	Call blackstarDb.CreateuserGroup('sysSalesManager','Gerente comercial','saul.andrade@gposac.com.mx');

-- -----------------------------------------------------------------------------
-- FIN SECCION DE DATPS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDb.updateCodexData();

DROP PROCEDURE blackstarDb.updateCodexData;



