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

	SELECT DISTINCT u.email AS email, u.name AS name
	FROM blackstarUser u
		INNER JOIN blackstarUser_userGroup ug ON u.blackstarUserId = ug.blackstarUserId
		INNER JOIN userGroup g ON g.userGroupId = ug.userGroupId
	WHERE externalId != 'sysCliente'
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
-- 4    24/09/2014  SAG     Se agrega blackstarDb.cst
-- ---------------------------------------------------------------------------

USE blackstarDb;

DELIMITER ;

CREATE TABLE IF NOT EXISTS blackstarDb.cst(
  cstId INTEGER NOT NULL AUTO_INCREMENT ,
  name VARCHAR(400) NOT NULL,
  officeId CHAR(1) NOT NULL,
  phone VARCHAR(200),
  phoneExt VARCHAR(200),
  mobile VARCHAR(200),
  email VARCHAR(400) NOT NULL,
  autoAuthProjects INT,
  PRIMARY KEY(cstId)
  -- FOREIGN KEY(officeId) REFERENCES office(officeId)
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
  cstId INTEGER,
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
  FOREIGN KEY (cstId) REFERENCES cst (cstId)
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
  productsNumber FLOAT(15,2),
  financesNumber FLOAT(15,2),
  servicesNumber FLOAT(15,2),
  totalProjectNumber FLOAT(15,2),
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
  discount FLOAT(15,2) NOT NULL,
  totalPrice FLOAT(15,2) NOT NULL,
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
  priceByUnit FLOAT(15,2) NOT NULL,
  discount FLOAT(15,2) NOT NULL,
  totalPrice FLOAT(15,2) NOT NULL,
  comments TEXT,
  PRIMARY KEY (_id),
  FOREIGN KEY (entryId) REFERENCES codexProjectEntry (_id),
  FOREIGN KEY (itemTypeId) REFERENCES codexProjectItemTypes (_id)
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS blackstarDb.codexPriceList(
  _id INT NOT NULL AUTO_INCREMENT,
  code VARCHAR(200) NOT NULL,
  name VARCHAR(1000) NOT NULL,
  price FLOAT(15,2) NOT NULL,
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
  advance FLOAT(15,2) NOT NULL,
  timeLimit INT NOT NULL,
  settlementTimeLimit INT NOT NULL,
  deliveryTime INT NOT NULL,
  incoterm VARCHAR(5) NOT NULL,
  productsNumber FLOAT(15,2) NOT NULL,
  financesNumber FLOAT(15,2) NOT NULL,
  servicesNumber FLOAT(15,2) NOT NULL,
  totalProjectNumber FLOAT(15,2) NOT NULL,
  created DATETIME NOT NULL,
  PRIMARY KEY (_id),
  FOREIGN KEY (projectId) REFERENCES codexProject (_id),
  FOREIGN KEY (paymentTypeId) REFERENCES codexPaymentType (_id),
  FOREIGN KEY (currencyTypeId) REFERENCES codexCurrencyType (_id),
  FOREIGN KEY (taxesTypeId) REFERENCES codexTaxesTypes (_id),
  FOREIGN KEY (clientId) REFERENCES codexClient (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexPriceProposalEntry(
  _id INT NOT NULL AUTO_INCREMENT,
  priceProposalId INT NOT NULL,
  entryTypeId INT NOT NULL,
  description TEXT NOT NULL,
  discount FLOAT(15,2) NOT NULL,
  totalPrice FLOAT(15,2) NOT NULL,
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
  priceByUnit FLOAT(15,2) NOT NULL,
  discount FLOAT(15,2) NOT NULL,
  totalPrice FLOAT(15,2) NOT NULL,
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
-- 3	21/10/2014	SAG 	Se agrega tabla codexProductFamily
--							Se agrega codexProductFamilyId a codexPriceList
--							Se agrega discountNumber a codexProject
--							Se agrega codexVisit
--							Se agrega codexVisitStatus
-- ---------------------------------------------------------------------------
-- 4	28/10/2014 SAG 		Se agrega yearQuota a cst
--							Se agrega turnedCustomerDate a codexClient
--							Se agrega priceListId a codexEntryItem
-- ---------------------------------------------------------------------------
-- 5 	20/12/2014	SAG 	Se cambia sellerId por cstId en codexClient
-- ---------------------------------------------------------------------------
-- 6 	23/12/2014	SAG 	Se acepta NULL en anticipo y plazo anticipo
-- ---------------------------------------------------------------------------
-- 7	05/01/2015	SAG 	Se agregan qty y unitPrice a codexProjectEntry
--							Se agrega paymentConditions a codexProject
-- ---------------------------------------------------------------------------
-- 8	15/01/2015	SAG 	Se agrega documentId a priceProposal
-- ---------------------------------------------------------------------------
-- 9 	29/01/2015	SAG 	Se agrega scope a cst
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.upgradeCodexSchema$$
CREATE PROCEDURE blackstarDb.upgradeCodexSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

-- AGREGANDO scope a cst
IF(SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'cst' AND COLUMN_NAME = 'scope') = 0 THEN
	ALTER TABLE blackstarDb.cst ADD scope INT NOT NULL DEFAULT 0;
END IF;

-- AGREGANDO documentId a codexPriceProposal
IF(SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexPriceProposal' AND COLUMN_NAME = 'documentId') = 0 THEN
	ALTER TABLE blackstarDb.codexPriceProposal ADD documentId VARCHAR(2000) NULL;
END IF;

-- AGREGANDO paymentConditions a codexProject
IF(SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexProject' AND COLUMN_NAME = 'paymentConditions') = 0 THEN
	ALTER TABLE blackstarDb.codexProject ADD paymentConditions TEXT NULL;
END IF;

-- AGREGANDO qty y unitPrice a codexProjectEntry
IF(SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexProjectEntry' AND COLUMN_NAME = 'qty') = 0 THEN
	ALTER TABLE blackstarDb.codexProjectEntry ADD qty INT NOT NULL DEFAULT 1;
	ALTER TABLE blackstarDb.codexProjectEntry ADD unitPrice FLOAT(15,2) NULL;
END IF;

ALTER TABLE codexPriceProposal MODIFY advance float(15,2) NULL;
ALTER TABLE codexPriceProposal MODIFY timeLimit int NULL;
ALTER TABLE codexPriceProposal MODIFY settlementTimeLimit int NULL;

-- AGREGANDO priceListId a codexEntryItem
IF(SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexEntryItem' AND COLUMN_NAME = 'priceListId') = 0 THEN
	ALTER TABLE blackstarDb.codexEntryItem ADD priceListId INT NULL;
	ALTER TABLE blackstarDb.codexEntryItem ADD CONSTRAINT FK_codexEntyItem_priceList FOREIGN KEY (priceListId) REFERENCES codexPriceList(_id);
END IF;

-- AGREGANDO turnedCustomerDate a codexClient
IF(SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexClient' AND COLUMN_NAME = 'turnedCustomerDate') = 0 THEN
	ALTER TABLE blackstarDb.codexClient ADD turnedCustomerDate DATETIME NULL;
END IF;

-- AGREGANDO yearQuota a cst
IF(SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'cst' AND COLUMN_NAME = 'yearQuota') = 0 THEN
	ALTER TABLE blackstarDb.cst ADD yearQuota INT NOT NULL DEFAULT 0;
END IF;

-- AGREGANDO TABLA codexVisitStatus
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexVisitStatus') = 0 THEN
		CREATE TABLE blackstarDb.codexVisitStatus(
			visitStatusId CHAR(1),
			visitStatus VARCHAR(100),
			PRIMARY KEY(visitStatusId)
		)ENGINE=INNODB;
	END IF;

-- AGREGANDO TABLA codexVisit
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexVisit') = 0 THEN
		CREATE TABLE blackstarDb.codexVisit(
			codexVisitId INTEGER NOT NULL AUTO_INCREMENT,
			cstId INT,
			codexClientId INT NULL,
			customerName VARCHAR(400),
			visitDate DATETIME,
			description TEXT,
			visitStatusId CHAR(1),
			closure TEXT,
			created DATETIME NULL,
			createdBy VARCHAR(100) NULL,
			createdByUsr VARCHAR(100) NULL,
			modified DATETIME NULL,
			modifiedBy VARCHAR(100) NULL,
			modifiedByUsr VARCHAR(100) NULL,
			PRIMARY KEY (codexVisitId)
		) ENGINE=INNODB;

		ALTER TABLE codexVisit ADD CONSTRAINT FK_codexVisit_cst FOREIGN KEY(cstId) REFERENCES cst(cstId);
		ALTER TABLE codexVisit ADD CONSTRAINT FK_codexVisit_codexClient FOREIGN KEY(codexClientId) REFERENCES codexClient(_id);
		ALTER TABLE codexVisit ADD CONSTRAINT FK_codexVisit_codexVisitStatus FOREIGN KEY(visitStatusId) REFERENCES codexVisitStatus(visitStatusId);
	END IF;

-- AGREGANDO COLUMNA discountNumber a codexProject
  IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexProject' AND COLUMN_NAME = 'discountNumber') = 0  THEN
    ALTER TABLE blackstarDb.codexProject ADD discountNumber FLOAT(15,2) NULL;
  END IF;    

-- AGREGANDO TABLA codexProductFamily
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexProductFamily') = 0 THEN
		CREATE TABLE blackstarDb.codexProductFamily(
			codexProductFamilyId INTEGER NOT NULL AUTO_INCREMENT,
			productFamily VARCHAR(100),
			PRIMARY KEY (codexProductFamilyId)
		) ENGINE=INNODB;
	END IF;

-- AGREGANDO COLUMNA codexProductFamilyId a codexPriceList
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexPriceList' AND COLUMN_NAME = 'codexProductFamilyId') = 0  THEN
		ALTER TABLE codexPriceList ADD codexProductFamilyId INT NOT NULL;

		ALTER TABLE blackstarDb.codexPriceList ADD CONSTRAINT FK_codexPriceList_codexProductFamily
		FOREIGN KEY (codexProductFamilyId) REFERENCES codexProductFamily (codexProductFamilyId);
	END IF;

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
-- 4  24/09/2014    SAG     Se agrega:
--                              blackstarDb.GetCstByEmail
--                          Se modifica:
--                              blackstarDb.GetCSTOffice
-- -----------------------------------------------------------------------------
-- 5  22/10/2014    SAG     Se agrega:
--                              blackstarDb.UpsertCodexVisit
--                              blackstarDb.GetAllVisitStatus
--                              blackstarDb.GetVisitList
--                              blackstarDb.GetAllCst
--                              blackstarDb.GetVisitById
-- -----------------------------------------------------------------------------
-- 6  28/10/2014    SAG     Se agrega:
--                              blackstarDb.getCodexInvoicingKpi
--                              blackstarDb.getCodexEffectiveness
--                              blackstarDb.getCodexProposals
--                              blackstarDb.getCodexProjectsByStatus
--                              blackstarDb.getCodexProjectsByOrigin
--                              blackstarDb.getCodexClientVisits
--                              blackstarDb.getCodexNewCustomers
--                              blackstarDb.getCodexProductFamilies
--                              blackstarDb.getCodexComerceCodes
--                              blackstarDb.getAutocompleteClientList
-- -----------------------------------------------------------------------------
-- 7  15/01/2015  SAG     Se agrega:
--                              blackstarDb.GetPriceProposalList
-- -----------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

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

  IF(ifnull(cst, '') != '') THEN
    SELECT
      c.name AS cstName,
      sum(p.totalProjectNumber) AS amount,
      o.name AS origin,
      '0 %' AS coverage
    FROM codexProject p
      INNER JOIN cst c ON p.createdByUsr = c.email
      INNER JOIN codexClient cl ON cl._id = p.clientId
      INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
    WHERE p.created >= startDate
      AND p.created <= endDate
      AND c.email = cst
      AND cl.clientOriginId = originId
    GROUP BY c.name, o.name;
  ELSE
     SELECT
      c.name AS cstName,
      sum(p.totalProjectNumber) AS amount,
      o.name AS origin,
      CONVERT((sum(p.totalProjectNumber) / yearQuota) * 100, CHAR) AS coverage
    FROM codexProject p
      INNER JOIN cst c ON p.createdByUsr = c.email
      INNER JOIN codexClient cl ON cl._id = p.clientId
      INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
    WHERE p.created >= startDate
      AND p.created <= endDate
      AND cl.clientOriginId = originId
    GROUP BY c.name, o.name;
  END IF;
  
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexEffectiveness
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexEffectiveness$$
CREATE PROCEDURE blackstarDb.getCodexEffectiveness(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN
  
  CREATE TEMPORARY TABLE cstProjects(cstEmail VARCHAR(200), originId INT, projectCount INT, soldCount INT);

  INSERT INTO cstProjects(cstEmail, originId, projectCount, soldCount)
  SELECT createdByUsr, cl.clientOriginId, count(*), 0
  FROM codexProject p
    INNER JOIN codexClient cl ON p.clientId = cl._id
  WHERE p.created >= startDate
      AND p.created <= endDate
  GROUP BY createdByUsr, clientOriginId;

  UPDATE cstProjects SET
    soldCount = (
      SELECT count(*) FROM codexProject p
        INNER JOIN codexClient cl ON p.clientId = cl._id
      WHERE createdByUsr = cstEmail
        AND p.created >= startDate
        AND p.created <= endDate
        AND cl.clientOriginId = originId
        AND p.statusId >=4);

  SELECT
    c.name AS cstName,
    o.name AS origin,
    (soldCount/projectCount) * 100 AS effectiveness
  FROM cstProjects p
    INNER JOIN cst c ON p.cstEmail = c.email
    INNER JOIN codexClientOrigin o ON p.originId = o._id;

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
    o.name AS origin,
    s.name AS status,
    sum(totalProjectNumber) AS amount
  FROM codexProject p
    INNER JOIN cst c ON p.createdByUsr = c.email
    INNER JOIN codexClient cl ON p.clientId = cl._id
    INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
    INNER JOIN codexStatusType s ON p.statusId = s._id
  WHERE p.created >= startDate
    AND p.created <= endDate
  GROUP BY c.name, o.name, s.name;

  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexProjectsByStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexProjectsByStatus$$
CREATE PROCEDURE blackstarDb.getCodexProjectsByStatus(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN

  SET @projectCount = (SELECT count(*) FROM codexProject WHERE created >= startDate AND created <= endDate);

  SELECT
    c.name AS cstName,
    o.name AS origin,
    s.name AS status,
    count(*) AS count,
    (count(*) / @projectCount) * 100 AS contribution
  FROM codexProject p
    INNER JOIN cst c ON p.createdByUsr = c.email
    INNER JOIN codexClient cl ON p.clientId = cl._id
    INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
    INNER JOIN codexStatusType s ON p.statusId = s._id
  WHERE p.created >= startDate
    AND p.created <= endDate
  GROUP BY c.name, o.name, s.name;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexProjectsByOrigin
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexProjectsByOrigin$$
CREATE PROCEDURE blackstarDb.getCodexProjectsByOrigin(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN

  SET @projectTotal = (SELECT sum(totalProjectNumber) FROM codexProject WHERE created >= startDate AND created <= endDate);

  SELECT
    o.name AS origin,
    sum(totalProjectNumber) AS amount,
    (sum(totalProjectNumber) / @projectTotal) * 100 AS contribution
  FROM codexProject p
    INNER JOIN codexClient cl ON p.clientId = cl._id
    INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
  WHERE p.created >= startDate
    AND p.created <= endDate
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
    ifnull(o.name, '') AS origin,
    count(*) AS count
  FROM codexVisit v 
    INNER JOIN cst c ON v.cstId = c.cstId
    LEFT OUTER JOIN codexClient cl ON cl._id = v.codexClientId
    LEFT OUTER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
  WHERE v.created >= startDate
    AND v.created <= endDate
    AND v.visitStatusId = 'R'
  GROUP BY c.name, o.name;
  
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
    INNER JOIN blackstarUser u ON u.blackstarUserId = c.cstId
  WHERE turnedCustomerDate >= startDate 
    AND turnedCustomerDate <= endDate
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
    sum(totalProjectNumber) AS totalamount,
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
  AND if(ifnull(pcstEmail, '') != '', c.email = pcstEmail, 1=1 );

  
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

	INSERT INTO blackstarDb.followUp(codexProjectId, followup, created, createdBy, createdByUsr, asignee)
	VALUES(pProjectId, pMessage, NOW(), 'AddFollowUpToCodexProject', pCreatedByUsr, pAssignedUsr);
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
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr, cp.discountNumber discountNumber
      , cp.paymentConditions paymentConditions
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
CREATE PROCEDURE blackstarDb.`CodexUpsertProjectEntryItem`(pItemId int(11),pEntryId int(11), pItemTypeId int(11), pReference TEXT, pDescription TEXT, pQuantity int(11), pPriceByUnit FLOAT(15,2), pDiscount FLOAT(15,2), pTotalPrice FLOAT(15,2), pComments TEXT)
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
                                                 , pIsProspect tinyint(4), pRfc varchar(13), pCorporateName text, pTradeName text, pPhoneArea varchar(3), pPhoneNumber varchar(10)
                                                 , pPhoneExtension varchar(6), pPhoneAreaAlt varchar(3), pPhoneNumberAlt varchar(10), pPhoneExtensionAlt varchar(6)
                                                 , pEmail varchar(60), pEmailAlt varchar(60), pStreet text, pIntNumber varchar(5), pExtNumber varchar(5)
                                                 , pZipCode int(5), pCountry text, pState varchar(20), pMunicipality text, pCity text, pNeighborhood text
                                                 , pContactName text, pCurp varchar(18), pRetention varchar(20))
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
FROM codexProject cp
  INNER JOIN codexClient cc ON cp.clientId = cc._id
  INNER JOIN codexStatusType cst ON cp.statusId = cst._id
  INNER JOIN codexPaymentType cpt ON cp.paymentTypeId = cpt._id
  INNER JOIN codexCurrencyType cct ON cp.currencyTypeId = cct._id
  INNER JOIN codexCostCenter ccc ON cp.costCenterId = ccc._id
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
CREATE PROCEDURE blackstarDb.`CodexGetProjectsByStatusAndUser`(pStatusId INT(2), pUserId INT(11))
BEGIN
SELECT cp._id id, cp.projectNumber projectNumber, cp.clientId clientId, cp.taxesTypeId taxesTypeId, cp.statusId statusId
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, cst.name statusDescription
      , cc.tradeName clientDescription, ccc.costCenter costCenter, cp.changeType changeType, cp.created created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.incoterm incoterm
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber, cp.createdBy createdBy, cp.createdByUsr createdByUsr
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr
FROM codexProject cp
  INNER JOIN codexClient cc ON cp.clientId = cc._id
  INNER JOIN codexStatusType cst ON cp.statusId = cst._id
  INNER JOIN codexPaymentType cpt ON cp.paymentTypeId = cpt._id
  INNER JOIN codexCurrencyType cct ON cp.currencyTypeId = cct._id
  INNER JOIN codexCostCenter ccc ON cp.costCenterId = ccc._id
WHERE 
      cc.cstId = pUserId
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
CREATE PROCEDURE blackstarDb.`CodexInsertPriceProposalEntryItem`(pPriceProposalEntryId int(11), pItemTypeId int(11), pReference TEXT, pDescription TEXT, pQuantity int(11), pPriceByUnit FLOAT(15,2), pDiscount FLOAT(15,2), pTotalPrice FLOAT(15,2), pComments TEXT)
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
    p.created AS created,
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
-- 3 	23/12/2014 	SAG 	Se elimina No Definido de clientType
-- ---------------------------------------------------------------------------
-- 4 	05/01/2014 	SAG 	Se establece unitPrice = totalPrice en Entry
-- ---------------------------------------------------------------------------
-- 5 	15/01/2015	SAG 	Se agregan los valores de secuencia para clientes
-- ---------------------------------------------------------------------------
use blackstarDb;

DELIMITER $$

-- -----------------------------------------------------------------------------
-- SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS blackstarDb.updateCodexData$$
CREATE PROCEDURE blackstarDb.updateCodexData()
BEGIN

	IF(SELECT count(*) FROM cst WHERE scope > 0) = 0 THEN
		UPDATE cst SET scope = 1 WHERE email = 'liliana.diaz@gposac.com.mx';
		UPDATE cst SET scope = 1 WHERE email = 'saul.andrade@gposac.com.mx';
	END IF;

	IF(SELECT count(*) FROM blackstarDb.sequence WHERE sequenceTypeId = 'C') = 0 THEN
		INSERT INTO blackstarDb.sequence(sequenceTypeId, sequenceNumber, description)
		SELECT 'C', max(_id), 'Secuencia para numero de clientes' FROM blackstarDb.codexClient;
	END IF;

	UPDATE codexProjectEntry e SET
		unitPrice = (
			SELECT sum(totalPrice) FROM codexEntryItem i WHERE i.entryId = e._id
		)
	WHERE e.unitPrice IS NULL;

	IF(SELECT max(autoAuthProjects) FROM cst) = 1 THEN
		UPDATE cst SET autoAuthProjects =  30000 WHERE email = 'portal-servicios@gposac.com.mx';
		UPDATE cst SET autoAuthProjects =  30000 WHERE email = 'juanjose.espinoza@gposac.com.mx';
		UPDATE cst SET autoAuthProjects =  10000 WHERE email = 'francisco.urena@gposac.com.mx';
		UPDATE cst SET autoAuthProjects =  30000 WHERE email = 'ivan.martin@gposac.com.mx';
		UPDATE cst SET autoAuthProjects =  0 WHERE email = 'juan.ramos@gposac.com.mx';
		UPDATE cst SET autoAuthProjects =  30000 WHERE email = 'jorge.martinez@gposac.com.mx';
		UPDATE cst SET autoAuthProjects =  0 WHERE email = 'michelle.galicia@gposac.com.mx';
		UPDATE cst SET autoAuthProjects =  1000 WHERE email = 'liliana.diaz@gposac.com.mx';
		UPDATE cst SET autoAuthProjects =  0 WHERE email = 'pilar.paz@gposac.com.mx';
		UPDATE cst SET autoAuthProjects =  50000 WHERE email = 'nicolas.andrade@gposac.com.mx';
		UPDATE cst SET autoAuthProjects =  50000 WHERE email = 'saul.andrade@gposac.com.mx';
	END IF;

	IF(SELECT count(*) FROM codexClientType WHERE name = 'No Definido') > 0 THEN
		UPDATE codexClient SET clientTypeId = 1 WHERE clientTypeId = 4;

		DELETE FROM codexClientType WHERE _id = 4;
	END IF;

	IF(SELECT count(*) FROM codexVisitStatus) = 0 THEN
		INSERT INTO blackstarDb.codexVisitStatus(visitStatusId, visitStatus) 
		SELECT 'P', 'PENDIENTE' UNION
		SELECT 'R', 'REALIZADA' UNION
		SELECT 'D', 'DESCARTADA';
	END IF;

	IF(SELECT count(*) FROM codexProductFamily) = 0 THEN
		INSERT INTO blackstarDb.codexProductFamily(codexProductFamilyId, productFamily) 
		SELECT 1, 'MITSU'	UNION
		SELECT 2, 'PDU 1100'	UNION
		SELECT 3, 'SANYO'	UNION
		SELECT 4, 'DATAAIRE'	UNION
		SELECT 5, 'BATERIAS CSB'	UNION
		SELECT 6, 'PQ GLOBAL'	UNION
		SELECT 7, 'MGM'	UNION
		SELECT 8, 'PE PLANELEC'	UNION
		SELECT 9, 'BATERIAS DINASTY'	UNION
		SELECT 10, 'APC'	UNION
		SELECT 11, 'FARAGAUS'	UNION
		SELECT 12, 'CA'	UNION
		SELECT 13, 'KITRON Y TC'	UNION
		SELECT 14, 'MONITOREO Y ACCESORIOS'	UNION
		SELECT 15, 'AAP SERVICIOS'	UNION
		SELECT 16, 'CALIDAD ENERGIA'	UNION
		SELECT 17, 'UPS SERVICIOS'	UNION
		SELECT 18, 'PE SERVICIOS';
	END IF;

	-- Lista de CST
	IF(SELECT count(*) FROM blackstarDb.cst) = 0 THEN
		INSERT INTO blackstarDb.cst(name, officeId, phone, phoneExt, mobile, email, autoAuthProjects)
		SELECT 'Sergio Alejandro Gomez Avila', 'Q', '(22) 2222-3333', '456', '(22) 4444-5555', 'portal-servicios@gposac.com.mx', 1 UNION
		SELECT 'Juan Jose Espinoza Bravo', 'G', '(33) 3793-0138', '211', '(33) 3129-3377', 'juanjose.espinoza@gposac.com.mx', 1 UNION
		SELECT 'Francisco Ramón Ureña Villanueva', 'G', '(33) 3793-0138', '206', '(33) 3661-1378', 'francisco.urena@gposac.com.mx', 0 UNION
		SELECT 'Jose Ivan Martin Miranda', 'Q', '442 295 24 68', '312', '(44) 2226-7847', 'ivan.martin@gposac.com.mx', 1 UNION
		SELECT 'Juan Ramos Anaya', 'Q', '442 295 24 68', '318', '', 'juan.ramos@gposac.com.mx', 0 UNION
		SELECT 'Jorge Alberto Martinez', 'M', '(55) 5020-2160', '427', '(55) 1452-7626', 'jorge.martinez@gposac.com.mx', 1 UNION
		SELECT 'Michel Galicia Camacho', 'M', '(55) 5020-2160', '429', '(55) 34343570', 'michelle.galicia@gposac.com.mx', 0 UNION
		SELECT 'Liliana Diaz Cuevas', 'M', '(55) 5020-2160', '407', '(55) 1452-7278', 'liliana.diaz@gposac.com.mx', 0 UNION
		SELECT 'Pilar Paz Torres', 'M', '(55) 5020-2160', '428', '(55) 1452-7278', 'pilar.paz@gposac.com.mx', 0 UNION
		SELECT 'Nicolas Andrade Carrillo', 'G', '(33) 3793-0138', '217', '(33) 3191-9226', 'nicolas.andrade@gposac.com.mx', 1 UNION
		SELECT 'Saul Andrade Gonzalez', 'G', '(33) 3793-0138', '220', '(33) 3576-8144', 'saul.andrade@gposac.com.mx', 1 ;
	END IF;

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
		SELECT 'Autorizado', 'Autorizado' UNION
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

	-- Lista inicial de Prospectos
	IF(SELECT count(*) FROM blackstarDb.codexClient WHERE isProspect = 0) = 0 THEN
		INSERT INTO blackstarDb.codexClient(corporateName,tradeName,contactName,cstId,clientOriginId,clientTypeId,email,street,extNumber,intNumber,neighborhood,city,state,country,zipCode,phoneArea,phoneNumber,phoneExtension,phoneNumberAlt,rfc,isProspect)
		SELECT 'INSTALACIONES MECANICAS','INSTALACIONES MECANICAS','BERNARDO RAMIREZ','8','3','3',NULL,'VICENTE GUERRERO','150',NULL,'AGUA BLANCA INDUSTRIAL','GUADALAJARA','JALISCO','MEXICO',NULL,'33','38117660','113',NULL,NULL, 0 UNION
		SELECT 'Mantenimiento y Construcción Stelpitts, S.A. de C.V.','Mantenimiento y Construcción Stelpitts, S.A. de C.V.','Ing. Juan Manuel Valladares','8','3','3',NULL,'Eusebio Rosas de la Rosa','28','301','Col. Presidentes ejidales 1a sección','México','DISTRITO FEDERAL','ANTÁRTICA',NULL,'55','5689-0192',NULL,NULL,NULL, 0 UNION
		SELECT 'SAI CORPORATIVO','SAI CORPORATIVO','HUMBERTO GERONIMO','8','3','3','saicorporativo@gmail.com','Av.21 No.76',NULL,NULL,'Col. Fernando Gutièrrez','Boca del Rìo','Veracruz','MEXICO','94297',NULL,'2291119829',NULL,'2293300727',NULL, 0 UNION
		SELECT 'SERVICIOS ELECTRICOS TECNOLOGICOS DE ALTAMIRA','SERVICIOS ELECTRICOS TECNOLOGICOS DE ALTAMIRA','HECTOR SAUL HERNANDEZ TOVAR','8','3','3','ing.hectorsaulh@hotmail.com','PRIV FLORIDA','156 B',NULL,'FLORIDA II','ALTAMIRA','TAMAULIPAS','MEXICO','89602','833','2645212',NULL,'2878505',NULL, 0 UNION
		SELECT 'ABASTECEDORA DE PINTURAS PRISA. SA DE CV','ABASTECEDORA DE PINTURAS PRISA. SA DE CV','Ing. Luis Vazquez','3','1','1','LVAZQUEZ@PRISA.COM.MX','TABACHIN','1254',NULL,'DEL FRESNO','GUADALAJARA','JALISCO','MEXICO','44900','33','31341995',NULL,NULL,NULL, 0 UNION
		SELECT 'ALEXA CORP','ALEXA CORP','ING. RUBEN MONTAÑO','3','1','1','rmont@alexacorp.com','ANDRES TERAN','1275',NULL,'PLAN DE SAN LUIS','Guadalajara','JALISCO','MEXICO',NULL,'33','35 40 20 20','5115',NULL,NULL, 0 UNION
		SELECT 'EVANGELINA MARTÍNEZ RAMIREZ','EVANGELINA MARTÍNEZ RAMIREZ','EVANGELINA MARTÍNEZ RAMIREZ','3','1','1','JORGELUNA_VENTAS@HOTMAIL.COM','SICILIA','14',NULL,'SAN MIGUEL RESINDENCIAL','GUADALAJARA','JALISCO','MEXICO',NULL,'33',NULL,NULL,NULL,'MARE-841013-EP2', 0 UNION
		SELECT 'FARMACIAS GUADALAJARA','FARMACIAS GUADALAJARA','ING OMAR ESPINOZA','3','1','1','oespinoza@fragua.com.mx','ENRIQUE DIAZ DE LEON',NULL,NULL,'SANTA TERESITA','GUADALAJARA','JALISCO','MEXICO',NULL,'33','3284 4000','4039',NULL,NULL, 0 UNION
		SELECT 'ferromex','ferromex','ING.FERNANDO LUEVANOS','3','1','2','JCGARCIA@FERROMEX.COM.MX','BOSQUE DE CIRUELOS','99',NULL,'BOSQUES DE LAS LOMAS','MEXICO','DISTRITO FEDERAL','MEXICO','11700',NULL,NULL,NULL,NULL,NULL, 0 UNION
		SELECT 'FRUTIQUEKO','FRUTIQUEKO','ING. JORGE BERNACHE','3','1','1','sistemas@frutiqueko.com.mx','Mariano Otero','1333',NULL,'MARIANO OTERO','GUADALAJARA','JALISCO','MEXICO','45067',NULL,NULL,NULL,NULL,NULL, 0 UNION
		SELECT 'JAVIER GUZMAN','JAVIER GUZMAN','JAVIER GUZMAN','3','1','1','jvrguzman@hotmail.com','MATAMOROS 248',NULL,NULL,'SAN SEBASTIAN EL GRANDE','GUADALAJARA','JALISCO',NULL,NULL,NULL,NULL,NULL,NULL,NULL, 0 UNION
		SELECT 'NISSAN MEXICANA','NISSAN MEXICANA','ING JAIME JUAREZ BECERRA','3','1','1','jaime.juarez@nissan.com.mx','KM 7.5 CARRETERA FEDERAL 45 LAGOS DE MORENO-AGS',NULL,NULL,NULL,'AGUASCALIENTES','AGUASCALIENTES','MEXICO',NULL,'449','910 4111','3709','DIR 910 4170',NULL, 0 UNION
		SELECT 'OMNILIFE MANUFACTURA S.A. DE C.V.','OMNILIFE MANUFACTURA S.A. DE C.V.','ING ERNESTO NAVARRO','3','1','1','ernesto.navarro@omnilife.com','AV. PASEO DEL PRADO','387-A',NULL,'LOMAS DEL VALLE','GUADALAJARA','JALISCO','MEXICO','45129','01(33)','36 48 36 36',NULL,NULL,NULL, 0 UNION
		SELECT 'POWERNET SA DE CV','POWERNET SA DE CV','RAUL GLORIA','3','1','3','jgloria@powernet.mx','MATIAS ROMERO','216','3ER PISO','DEL VALLE, DEL.BENITO JUAREZ','MEXICO','DF','MEXICO','3100','155','55594150',NULL,'63545012','POW131122P51', 0 UNION
		SELECT 'PEMEX TERMINAL DE ALMACENAMIENTO Y REPARTO MAZATLAN','PEMEX TERMINAL DE ALMACENAMIENTO Y REPARTO MAZATLAN','ING.JOSE ANTONIO RAMIREZ CASTAÑEDA','3','3','2','jose.antonio.ramirezc@pemex.com','DOMICILIO CONOCIDO','S/N',NULL,'LA ESPERANZA','MAZATLAN','SINALOA','MEXICO','82180','669','980 0302','57307','980 0303',NULL, 0 UNION
		SELECT 'BANSI SA DE CV','BANSI SA DE CV','ING.JUAN SANCHEZ FONSECA','3','3','1','jsanchez@bansi.com.mx','AV TERRANOVA','325',NULL,'PROVIDENCIA','GUADALAJARA','JALISCO','MEXICO',NULL,'33','3678 6540',NULL,NULL,NULL, 0 UNION
		SELECT 'BANCO DE MEXICO','BANCO DE MEXICO','ING. GERARDO REYES JIMENEZ','6','3','2','jreyesg@banxico.org.mx','Ave. 5 de Mayo','2',NULL,'CENTRO','MEXICO','DISTRITO FEDERAL','MEXICO','6059','01 55','5237 2000',NULL,NULL,NULL, 0 UNION
		SELECT 'BM MEXICANA DE COMERCIO, S.A. DE C.V.','BM MEXICANA DE COMERCIO, S.A. DE C.V.','Eduardo de las Peñas','6','3','3','edelaspenas@Bm-Mexicana.com','FRESNO','173',NULL,'SANTA MARIA LA RIBERA','MEXICO','DISTRITO FEDERAL','MEXICO','6400',NULL,'5518500647',NULL,NULL,'BMC971127Q77', 0 UNION
		SELECT 'BOLSA MEXICANA DE VALORES','BOLSA MEXICANA DE VALORES','ING. DAGOBERTO RODRIGUEZ','6','1','1','drodriguez@bmv.com.mx','PASEO DE LA REFORMA','255',NULL,NULL,'MEXICO','DISTRITO FEDERAL','MEXICO','6500','01 55','5342-9010',NULL,'4601-9955',NULL, 0 UNION
		SELECT 'COATS MEXICO & CA','COATS MEXICO & CA','Ma. Eugenia C. García González','6','3','1','eugenia.garcia@coats.com','AUTOPISTA MEXICO VERACRUZ KM 274','274',NULL,'ORIZABA VERACRUZ','ORIZABA','VERACRUZ','MEXICO','94390','01 272','728 1400','5046',NULL,NULL, 0 UNION
		SELECT 'CORPORACION MEXICANA DE INVESTIGACION EN MATERIALES S.A. DE C.V.','CORPORACION MEXICANA DE INVESTIGACION EN MATERIALES S.A. DE C.V.','IQ FEDERICO CARREON CANSECO','6','3','3','fcarreon@comimsa.com.mx','CIRCUITO TABASCO PONIENTE, MANZANA 3','13',NULL,'RANCHERIA PECHUCALCO 2DA. SECCION','CUNDUACAN','TABASCO','MEXICO',NULL,'01 914','126 0060','2269',NULL,NULL, 0 UNION
		SELECT 'E&T SOLUTIONS, S.A. DE C.V.','E&T SOLUTIONS, S.A. DE C.V.','ING. ANGEL ROSAS','6','3','3','arosas@etsolutions.com','Pajares','82',NULL,'PROGRESO DEL SUR','MEXICO, DF','DISTRITO FEDERAL','MEXICO','9810','01 55','5697-8590',NULL,NULL,NULL, 0 UNION
		SELECT 'ENLACE DE TECNOLOGIA, PROYECTOS Y SERVICIOS, S.A. DE C.V.','ENLACE DE TECNOLOGIA, PROYECTOS Y SERVICIOS, S.A. DE C.V.','Ing. Arq. María Isabel Cruz López','6','3','3','icruz@entec.com.mx','Av. 25 de Septiembre de 1873','58',NULL,'Leyes de Reforma','MEXICO','DISTRITO FEDERAL','MEXICO','9310',NULL,'56 96 79 09','234',NULL,NULL, 0 UNION
		SELECT 'ERICSSON TELECOM, S.A. DE C.V.','ERICSSON TELECOM, S.A. DE C.V.','ING. JUAN JUAREZ','6','1','1','juan.juarez@cwfacilities.com.mx','Paseo de la Reforma','1015','piso 7','Col. Santa Fe,','MEXICO','Mexico DF','MEXICO','1210','01 55','1103 0104',NULL,NULL,NULL, 0 UNION
		SELECT 'GRUPO AUTOFIN MEXICO','GRUPO AUTOFIN MEXICO','SONIA LOPEZ','6','1','1','compras10@grupoautofin.com','INSURGENTES SUR','1235',NULL,'EXTREMADURA INSURGENTES','MEXICO','DISTRITO FEDERAL','MEXICO','3740','55','54820300','2937',NULL,NULL, 0 UNION
		SELECT 'GRUPO IMER','GRUPO IMER','Ing. Luis Victor Quintero','6','1','1','victor.quintero@imer.com.mx','Mayorazgo','83',NULL,'XOCO','MEXICO','DISTRITO FEDERAL','MEXICO',NULL,'01 55','5628-1700','1723',NULL,NULL, 0 UNION
		SELECT 'GRUPO INDUSTRIAL MASECA, S.A. DE C.V.','GRUPO INDUSTRIAL MASECA, S.A. DE C.V.','Rafael A. Gárate Muñoz','6','1','1','rrocha@gruma.com','Calzada del Valle','407 Ote',NULL,'San Pedro Garza García','MONTERREY','NUEVO LEÓN','MEXICO','66220','01 81','83993300',NULL,NULL,NULL, 0 UNION
		SELECT 'GRUPO PILOT, S.A. DE C.V','GRUPO PILOT, S.A. DE C.V','ANGEL FRANCISCO ROSAS','6','3','1','afrosasf@yahoo.com','PONIENTE 128',NULL,NULL,'INDUSTRIAL VALLEJO','MEXICO','DISTRITO FEDERAL','MEXICO',NULL,'45','5512403235',NULL,NULL,NULL, 0 UNION
		SELECT 'GRUPO REFERIDOMAG DE MEXICO SA DE CV','GRUPO REFERIDOMAG DE MEXICO SA DE CV','ING. AMERICA REVUELTAS','6','3','3','america.revueltas@grupo-sacmag.com.mx','NUEVA YORK','310',NULL,'NAPOLES','MEXICO','DISTRITO FEDERAL','MEXICO','3810','55','56873666',NULL,NULL,NULL, 0 UNION
		SELECT 'IT COMM','IT COMM','JANET L. CERVERA LOZA','6','3','3','jcerveral@itcomm.com.mx',NULL,NULL,NULL,NULL,'MEXICO','MEXICO DF','MEXICO',NULL,NULL,NULL,NULL,NULL,NULL, 0 UNION
		SELECT 'KIMBERLY CLARK DE MEXICO SAB DE CV','KIMBERLY CLARK DE MEXICO SAB DE CV','JORGE ARTURO ELIZALDE','6','3','1','Jorge-Arturo.Elizalde@kcc.com','Avenida Jaime Balmes, No. 8, 9 Piso, México, D.F. 11510',NULL,NULL,NULL,'MEXICO',NULL,'MEXICO',NULL,'01 55','553215130','5020',NULL,NULL, 0 UNION
		SELECT 'MANTENIMIENTO ELECTRICO INDUSTRIAL, S.A. DE C.V.','MANTENIMIENTO ELECTRICO INDUSTRIAL, S.A. DE C.V.','ING. JOSE LUIS GARCIA GARCIA','6','3','3','meiig2@yahoo.com.mx',NULL,NULL,NULL,'SAN RAFAEL','MEXICO','DISTRITO FEDERAL','MEXICO',NULL,'01 55','5592-4156',NULL,NULL,NULL, 0 UNION
		SELECT 'OPEN SOLUTIONS INFORMATION TECHNOLOGIES SA DE CV','OPEN SOLUTIONS INFORMATION TECHNOLOGIES SA DE CV','INGRID RAMIREZ','6','3','3','iramirez@opensite.com.mx','BAHIA DE GUANTANAMO 79','79',NULL,'VERONICA ANZUREZ','MEXICO','DISTRITO FEDERAL','MEXICO','11300','01 55','52606569',NULL,NULL,NULL, 0 UNION
		SELECT 'ORACLE DE MEXICO, S.A. DE C.V.','ORACLE DE MEXICO, S.A. DE C.V.','OSCAR GARCIA GARCIA','6','3','1','oscar.x.garcia@oracle.com','PROL. REFORMA','600-210',NULL,'PEÑA BLANCA','MEXICO','DISTRITO FEDERAL','MEXICO','1210',NULL,'5284-5462',NULL,NULL,NULL, 0 UNION
		SELECT 'PSEINFOTELECOM','PSEINFOTELECOM','JACQUELINE RAMOS SAMPABLO','6','3','3','jramos@pseinfotelecom.com.mx','Viaducto Miguel Alemán 239','239','3er piso int. 6','ROMA SUR','MEXICO','DISTRITO FEDERAL','MEXICO','6760','01 55','10542313','205',NULL,NULL, 0 UNION
		SELECT 'SERVICIOS Y PROVEEDURIA INDUSTRIAL S.A. DE C.V.','SERVICIOS Y PROVEEDURIA INDUSTRIAL S.A. DE C.V.','Ing. David A. León Valencia','6','3','3','sepinsacarmen@yahoo.com.mx','53','414',NULL,'CALETA','DEL CARMEN','CAMPECHE','MEXICO','24110','01 938','1531082',NULL,NULL,'SPI0905093C8', 0 UNION
		SELECT 'TV AZTECA','TV AZTECA','Ing. Pablo Diaz Cruz','6','1','1','pdiazc@elektra.com','Periferico Sur','4121',NULL,'Fuentes del Pedregal','MEXICO','DISTRITO FEDERAL','MEXICO',NULL,'01 55','1720-1313','43363',NULL,NULL, 0 UNION
		SELECT 'CAJA POPULAR MEXICANA','CAJA POPULAR MEXICANA','JOSUE EFRAIN CENDEJAS ESPINOZA','4','1','1','josue_cendejas@cpm.coop','IGNACIO ALTAMIRANO','407',NULL,'SAN JUAN DE DIOS','LEON','GUANAJUATO','MEXICO','37004','477','7888000',NULL,NULL,NULL, 0 UNION
		SELECT 'CENTRO DE EVALUACION Y CONTROL DE CONFIANZA GUANAJUATO','CENTRO DE EVALUACION Y CONTROL DE CONFIANZA GUANAJUATO','SERGIO VELAZQUEZ URSUA','4','1','2','svelazqu@guanajuato.gob.mx','BLVD. JUAN JOSE TORRES LANDA','3005',NULL,'SAN ISIDRO','LEON','GUANAJUATO','MEXICO','35710','477','2673900',NULL,NULL,'CEC090101MGA', 0 UNION
		SELECT 'CENTRO DE INVESTIGACION EN MATEMATICAS AC','CENTRO DE INVESTIGACION EN MATEMATICAS AC','NOHEMI ARELY RUIZ HERNANDEZ','4','1','2','narely@cimat.mx','JALISCO SN COLONIA MINERAL DE VALENCIANA',NULL,NULL,'MINERAL DE VALENCIANA','GUANAJUATO','GUANAJUATO','MEXICO','36240','473','7327155',NULL,NULL,NULL, 0 UNION
		SELECT 'CENTRO DE INVESTIGACION Y DESARROLLO TECNOLOGICO EN ELECTROQUIMICA SC','CENTRO DE INVESTIGACION Y DESARROLLO TECNOLOGICO EN ELECTROQUIMICA SC','NICTE HA FLORES BORBOLLA','4','1','2','nflores@cideteq.mx','PARQUE TECNOLOGICO QUERETARO SANFANDILA',NULL,NULL,'PARQUE INDUSTRIAL TECNOLOGICO','QUERETARO','QUERETARO','MEXICO','76703','442','2116023',NULL,NULL,NULL, 0 UNION
		SELECT 'CENTRO NACIONAL DE METROLOGIA','CENTRO NACIONAL DE METROLOGIA','JORGE LUIS HERNANDEZ GARCIA','4','1','2','johernan@cenam.mx','KM 4.5 CARRETERA A LOS CUES',NULL,NULL,NULL,'EL MARQUES','QUERETARO','MEXICO','76246','442','2110500',NULL,NULL,NULL, 0 UNION
		SELECT 'CONSORCIO DE INGENIERIA DEL BAJIO S.A. DE C.V.','CONSORCIO DE INGENIERIA DEL BAJIO S.A. DE C.V.',NULL,'4','3',NULL,NULL,'LAUREL','5',NULL,'BARRIO DEL ESPIRITU SANTO','SAN JUAN DEL RIO','QUERÉTARO','MEXICO','76821','427','2728249',NULL,NULL,NULL, 0 UNION
		SELECT 'CONSTANTIA','CONSTANTIA','OSCAR IVAN SILVA','4','1','1','oscar.silva@aluprint.cflex.com','EJE 120','320',NULL,'ZONA INDUSTRIAL','SAN LUIS POTOSI','SAN LUIS POTOSÍ','MEXICO','78395','444','8267392',NULL,NULL,NULL, 0 UNION
		SELECT 'CUMMINS','CUMMINS','EFREN ZUÑIGA MADRIGAL','4','1','1','efren.zuniga@cummins.com','CARR. FEDERAL 57','4380',NULL,'ZONA INDUSTRIAL','SAN LUIS POTOSI','SAN LUIS POTOSÍ','MEXICO','78495','444','8706464',NULL,NULL,NULL, 0 UNION
		SELECT 'DEMOLOGISTICA SA DE CV','DEMOLOGISTICA SA DE CV','JUAN JOSE LOERA','4','3','1','jjloera@prodigy.net.mx','BOULEVARD ANTONIO MADRAZO','1025',NULL,'LAS TROJES','LEON','GUANAJUATO','MEXICO','37227','477','4134422',NULL,NULL,NULL, 0 UNION
		SELECT 'DISEÑO E INSTALACIONES ESPECIALES SA DE CV','DISEÑO E INSTALACIONES ESPECIALES SA DE CV','MANUEL SAUCEDO','4','3','1','diesacv@prodigy.net.mx','BRONCE','112',NULL,NULL,'LEON','GUANAJUATO','MEXICO','37100','477','7751022',NULL,NULL,NULL, 0 UNION
		SELECT 'DISTRIBUCION Y CONTROL DE ENERGIA S.A. DE C.V.','DISTRIBUCION Y CONTROL DE ENERGIA S.A. DE C.V.','ANA CORTES','4','3','1','acortes_dicesa@hotmail.com','SALAMA','579',NULL,'VALLE DEL TEPEYAC','MEXICO','MEXICO','MEXICO','7740','442','2090342',NULL,NULL,'DCE990730IZ9', 0 UNION
		SELECT 'ECONOAIRE SA DE CV','ECONOAIRE SA DE CV','DIOGENES ANTONIO ZAVALA CALDERON','4','3','1','dzavala@econoaire.com.mx','AV FRANCISCO VILLA','5518',NULL,'EL SAUCITO','CHIHUAHUA','CHIHUAHUA','MEXICO',NULL,'614','4250102',NULL,NULL,NULL, 0 UNION
		SELECT 'GAVT ILUMINACION S.A. DE C.V.','GAVT ILUMINACION S.A. DE C.V.','ARQ. RICARDO AVIÑA RAMIREZ','4','1','1','pukena_21@hotmail.com','BELISARIO DOMINGUEZ','2480',NULL,NULL,'TUXTLA GUTIERREZ','CHIAPAS','MEXICO','29050','961','6159444',NULL,NULL,NULL, 0 UNION
		SELECT 'GENERAL INSTALADORA SA DE CV','GENERAL INSTALADORA SA DE CV','ALEJANDRO RANGEL','4','1','1','alejandrogisa@hotmail.cm','TRIGO','202','2','EL COECILLO','LEON','GUANAJUATO','MEXICO','37260','477','7164309',NULL,NULL,NULL, 0 UNION
		SELECT 'GRUPO HYCSA','GRUPO HYCSA','FERNANDO BUEN ABAD VELASQUEZ','4','1','1','fbuenabad@grupohysa.com.mx','LOPE DE VEGA','117 PISO 2',NULL,'POLANCO','MEXICO','MEXICO','MEXICO','11560','55','50831650',NULL,NULL,NULL, 0 UNION
		SELECT 'GRUPO LA MESA','GRUPO LA MESA','ALEJANDRO HERNANDEZ','4','3','1','alejandro.hernandez@grupolamesa.com','AV. MEXICO JAPON','6',NULL,'CIUDAD INDUSTRIAL','CELAYA','GUANAJUATO','MEXICO','38010','461','6118717',NULL,NULL,NULL, 0 UNION
		SELECT 'INSITE INFORMATICA S.A. DE C.V.','INSITE INFORMATICA S.A. DE C.V.','RAMIRO CHAVEZ','4','3','1','insite@insisteinformatica.com','PRIEMRO DE MAYO','125',NULL,'PRIMERO DE MAYO','VILLAHERMOSA','TABASCO','MEXICO','85190','993','3525150',NULL,NULL,'IIN-020105-484', 0 UNION
		SELECT 'INSTITUO POTOSINO DE INVESTIGACION CIENTIFICA Y TECNOLOGICA A.C.','INSTITUO POTOSINO DE INVESTIGACION CIENTIFICA Y TECNOLOGICA A.C.','Lic. Karla Guerrero Lomelí','4','1','1','kguerrero@ipicyt.edu.mx','CAMINO A LA PRESA SAN JOSE','2055',NULL,'LOMAS 4 SECCION','SAN LUIS POTOSI','SAN LUIS POTOSÍ','MEXICO','78216','444','834 20 00','2074',NULL,NULL, 0 UNION
		SELECT 'INSTITUTO DE SEGURIDAD SOCIAL DEL ESTADO DE GUANAJUATO','INSTITUTO DE SEGURIDAD SOCIAL DEL ESTADO DE GUANAJUATO','LUIS FELIPE SANCHEZ','4','1','2','lsanchezgo@isseg.gob.mx','CARRETERA GUANJUATO-JUVENTINO ROSAS KM 10',NULL,NULL,'YERBABUENA','GUANAJUATO','GUANAJUATO','MEXICO','36250','473','7351438',NULL,NULL,NULL, 0 UNION
		SELECT 'INSTITUTO DE SEGURIDAD Y SERVICIOS SOCIALES DE LOS TRABAJADORES DEL ESTADO','INSTITUTO DE SEGURIDAD Y SERVICIOS SOCIALES DE LOS TRABAJADORES DEL ESTADO','MARIA DE JESUS ROMERO','4','1','2','mariade.gutierrez@issste.gob.mx',NULL,NULL,NULL,NULL,'QUERETARO','QUERETARO','MEXICO',NULL,'442','2153103',NULL,NULL,NULL, 0 UNION
		SELECT 'INSTITUTO DE VIVIENDA DEL ESTADO DE GUANAJUATO','INSTITUTO DE VIVIENDA DEL ESTADO DE GUANAJUATO','ARMANDO CONTRERAS ALVARADO','4','1','2','aca@guanajuato.gob.mx','CONJUNTO ADMINISTRATIVO POZUELOS',NULL,NULL,NULL,'GUANAJUATO','GUANAJUATO','MEXICO','36000','473','7353803',NULL,NULL,NULL, 0 UNION
		SELECT 'INSTITUTO NACIONAL DE ASTROFISICA OPTICA Y ELECTRONICA','INSTITUTO NACIONAL DE ASTROFISICA OPTICA Y ELECTRONICA','Jose Luis Rebollar','4','1','2','rebollar@inaoep.mx','LUIS ENRIQUE ERRO','1',NULL,'STA MA TONANTZINTLA','PUEBLA','PUEBLA','MEXICO','72000','222','2663100','5316',NULL,'INA711112IN7', 0 UNION
		SELECT 'Instituto Potosino de Investigación Científica y Tecnológica, A.C.','Instituto Potosino de Investigación Científica y Tecnológica, A.C.','Lic. Karla Guerrero Lomelí','4','1','1','kguerrero@ipicyt.edu.mx','CAMINO A LA PRESA SAN JOSE','2055',NULL,'LOMAS 4 SECCION','SAN LUIS POTOSI','SAN LUIS POTOSÍ','MEXICO','78216','444','834 20 00','2074',NULL,NULL, 0 UNION
		SELECT 'KENWORTH DEL BAJIO SA de CV','KENWORTH DEL BAJIO SA de CV','ING. ANTONIO SALAZAR','4','1','1',NULL,'Carretera Querétaro-México Km. 204',NULL,NULL,'SAN ISIDRO MIRANDA','QUERETARO','QUERÉTARO','MEXICO','76209','442','2774086',NULL,NULL,NULL, 0 UNION
		SELECT 'KOSTAL MEXICANA SA DE CV','KOSTAL MEXICANA SA DE CV','RODRIGO REYES','4','1','1','ro.reyes@kostal.com','ACCESO II','36',NULL,'PARQUE INDUSTRIAL BENITO JUAREZ','QUERETARO','QUERÉTARO','MEXICO','76120','442','2119536',NULL,NULL,NULL, 0 UNION
		SELECT 'LIBERTAD SERVICIOS FINANCIEROS','LIBERTAD SERVICIOS FINANCIEROS','LAURA LETICIA','4','1','1',NULL,'H COLEGIO MILITAR','67',NULL,'CORREGIDORA','VILLA CORREGIDORA','QUERETARO','MEXICO',NULL,'442','2110100',NULL,NULL,NULL, 0 UNION
		SELECT 'MABE SA DE CV','MABE SA DE CV','ALBINO GARCIA','4','1','1','albino.garcia@mabe.com.mx','ACCESO B','406',NULL,'PARQUE INDUSTRIAL JURICA','QUERETARO','QUERÉTARO','MEXICO','76100','442','2114800',NULL,NULL,'MAB911203RR7', 0 UNION
		SELECT 'MIGA INGENIERIA S.A. DE C.V.','MIGA INGENIERIA S.A. DE C.V.','MARCELO GALVEZ GAMEZ','4','3','1','galvez.gamez@migaingenieria.com.mx','PEDRO LASCURAIN','90',NULL,'SANTA BARBARA','QUERETARO','QUERÉTARO','MEXICO',NULL,'442','2155693',NULL,NULL,NULL, 0 UNION
		SELECT 'MUNICIPIO DE LEON','MUNICIPIO DE LEON','FRANCISCO FLORES','4','3','2','francisco.flores@leon.gob.mx',NULL,NULL,NULL,NULL,'LEON','GUANAJUATO','MEXICO',NULL,'477',NULL,NULL,NULL,NULL, 0 UNION
		SELECT 'SILLIKER','SILLIKER','JORGE GARCIA','4','1','1','jorge.garcia@mxns.com','CARR AL CAMPO MILITAR','305','B','SAN ANTONIO DE LA PUNTA','QUERETARO','QUERÉTARO','MEXICO','76135','442','2161663',NULL,NULL,NULL, 0 UNION
		SELECT 'SINERGIA TELECOMUNICACIONES','SINERGIA TELECOMUNICACIONES','MIGUEL ACEVEDO','4','1','1','macevedo@sinergia-telecomunicaciones.com','HERMENEGILDO BUSTOS','1361',NULL,'VALLE DEL MORAL','LEON','GUANAJUATO','MEXICO',NULL,'477','7186281',NULL,NULL,NULL, 0 UNION
		SELECT 'TECNOLOGICO DE MONTERREY CAMPUS QUERETARO','TECNOLOGICO DE MONTERREY CAMPUS QUERETARO','ADRIANA JUAREZ MEJIA','4','3','1','ajuarezm@itesm.mx',NULL,NULL,NULL,NULL,'QUERÉTARO','QUERÉTARO','MEXICO',NULL,'442','2383181',NULL,NULL,NULL, 0 UNION
		SELECT 'UNIVERSIDADTECNOLOGICA DEL NORTE DE GUANAJUATO','UNIVERSIDADTECNOLOGICA DEL NORTE DE GUANAJUATO','JESUS IVAN GERARDO HERNANDE','4','1','2','ivan.gerardo@utng.edu.mx','AV. EDUCACION TECNOLOGICA','34',NULL,'FRACC. UNIVERSIDAD','DOLORES HIDALGO','GUANAJUATO','MEXICO','37800','418','1825500',NULL,NULL,NULL, 0 UNION
		SELECT 'CAJA GONZALO VEGA','CAJA GONZALO VEGA','Ing Abraham Jimenez','4','1','1','abrahamj@cajacgv.com.mx','BLVD CENTRO SUR','107',NULL,'COLINAS DEL CIMATARIO','QUERETARO','QUERÉTARO','MEXICO',NULL,'442','209 6200','2014',NULL,NULL, 0 UNION
		SELECT 'CENTRO DE COMANDO, CONTROL, COMUNICACIONES Y COMPUTO DE LEON GTO','CENTRO DE COMANDO, CONTROL, COMUNICACIONES Y COMPUTO DE LEON GTO','Ing Francisco Flores','4','3','2','francisco.flores@leon.gob.mx','BLVD ARTURO SOTO RANGEL','S/N',NULL,'RESIDENCIAL EL FARO','LEON','GUANAJUATO','MEXICO','37353','477','212 0043','415',NULL,NULL, 0 UNION
		SELECT 'Guardian Industries V.P.S. de R.L. de C.V.','Guardian Industries V.P.S. de R.L. de C.V.','Eduardo del valle','4','1','1','ldelvalle@guardian.com','Carretera a Chichimequillas km 9.6',NULL,NULL,'La Griega','Querétaro','QUERÉTARO','MEXICO','76249','442','2781700',NULL,'2781709',NULL, 0 UNION
		SELECT 'Instituto Mexicano del Transporte','Instituto Mexicano del Transporte','ING ISAI VILLANUEVA','4','1','2','avillanu@imt.mx','KM 12 CARRETERA QUERETARO-GALINDO','S/N',NULL,'SANFANDILA','PEDRO ESCOBEDO','QUERÉTARO','MEXICO','76073','442','216 9777','2608',NULL,NULL, 0 UNION
		SELECT 'THYSSENKRUPP SYSTEM ENGINEERING, S.A. DE C.V.','THYSSENKRUPP SYSTEM ENGINEERING, S.A. DE C.V.','CARLOS SAAVEDRA ALONSO','4','1','1','carlos.saavedra@thyssenkrupp.com','AV. DEL MARQUÉS','36','A','PARQUE INDUSTRIAL BERNARDO QUINTANA','EL MARQUÉS','QUERÉTARO','MEXICO','76246','442','1924000',NULL,NULL,NULL, 0 UNION
		SELECT 'TRW FRENOS Y MECANISMOS','TRW FRENOS Y MECANISMOS',NULL,'4','3','1',NULL,'AV. LA GRIEGA','101',NULL,'PARQUE INDUSTRIAL QUERÉTARO','QUERETARO','QUERÉTARO','MEXICO','76220','442','2113300',NULL,NULL,NULL, 0 UNION
		SELECT 'BONAFONT GARRAFONES Y SERVICIOS SA DE CV','BONAFONT GARRAFONES Y SERVICIOS SA DE CV','ING CARLOS RAFAEL JARERO VALLE','2','1','1','jarero@bgs.com.mx,cjarero@bgs.com.mx','DR R MICHEL','1402',NULL,'SECTOR REFORMA','GUADALAJARA','JALISCO','MEXICO','44440','33','3636 9041',NULL,'3837 7752 directo',NULL, 0 UNION
		SELECT 'CONGRESO DEL ESTADO DE JALISCO','CONGRESO DEL ESTADO DE JALISCO','francisco villaseñor','2','1','2',NULL,'JUAREZ','273',NULL,NULL,'GUADALAJARA','JALISCO','MEXICO',NULL,NULL,NULL,NULL,NULL,NULL, 0 UNION
		SELECT 'CONTINENTAL','CONTINENTAL','Rolando Gutierrez Ríos / Juan Carlos Muro','2','3','1','rolando.gutierrez-rios@continental-corporation.com','Camino a la Tijera #3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'33','39152815','2815',NULL,NULL, 0 UNION
		SELECT 'COPPEL','COPPEL','ARQ MARIA ESPINOZA','2','3','1','mespinoza@elekter.com.mx','AV ANGEL FLORES','245',NULL,'CENTRO','CULIACAN','SINALOA','MEXICO','2000','667','7594260',NULL,'667 603 6908 CEL',NULL, 0 UNION
		SELECT 'CORPORATIVO SIE DE MEXICO SA DE CV','CORPORATIVO SIE DE MEXICO SA DE CV','Ing cesar lopez campos','2','1','1',NULL,NULL,NULL,NULL,'LOMAS DE ATEMAJAC','ZAPOPAN','JALISCO','MEXICO',NULL,'33','3563 3704',NULL,NULL,NULL, 0 UNION
		SELECT 'FRESENIUS MEDICAL CARE SA DE CV','FRESENIUS MEDICAL CARE SA DE CV','Omar Montes','2','3','1','omar.montes@fmc-ag.com',NULL,NULL,NULL,NULL,'GUADALAJARA','JALISCO','MEXICO',NULL,'133','35404222',NULL,NULL,NULL, 0 UNION
		SELECT 'FRESENIUS NETCARE','FRESENIUS NETCARE','Juvenal Neri Maravel','2','1','1','juvenal.neri@fresenius-netcare.com','PASEO DEL NORTE 5300-A',NULL,NULL,'GUADALAJARA TECHNOLOGY PARK','ZAPOPAN','JALISCO','MEXICO','45010','33','35-40-78-79',NULL,NULL,NULL, 0 UNION
		SELECT 'GATORADE','GATORADE','Viridiana Tovilla','2','1','1','viridiana.tovilla@gatorade.com.mx','PROL AV AMERICAS','1600','P-3-A','COUNTRY CLUB','GUADALAJARA','JALISCO','MEXICO','44637','33','3817 0246',NULL,NULL,NULL, 0 UNION
		SELECT 'GRUPO ACIR SA DE CV','GRUPO ACIR SA DE CV','ING.MARIO VAZQUEZ MURILLO','2','1','1','mariovazquez@grupoacir.com.mx','AV LAZARO CARDENAS','2820',NULL,'JARDINES DEL BOSQUE','GUADALAJARA','JALISCO','MEXICO',NULL,'33','3540 3400',NULL,NULL,NULL, 0 UNION
		SELECT 'H AYUNTAMIENTO DE GUADALAJARA','H AYUNTAMIENTO DE GUADALAJARA','CARLOS ALBERTO MENDIVIL','2','1','2','camendivil@guadalajara.gob.mx',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'33','38-18-36-00','3123',NULL,NULL, 0 UNION
		SELECT 'HOSPITAL SAN JAVIER','HOSPITAL SAN JAVIER','ING JESUS ZAZUETA','2','1','1',NULL,'AV PABLO CASALS','640',NULL,'PRADOS PROVIDENCIA','GUADALAJARA','JALISCO','MEXICO','44670','33','3669 0222','7140',NULL,NULL, 0 UNION
		SELECT 'LA PUREZA SA DE CV','LA PUREZA SA DE CV','ING RAFAEL DOMINGUEZ','2','1','1',NULL,'CLL 14','2650',NULL,'ZONA INDUSTRIAL','GUADALAJARA','JALISCO','MEXICO',NULL,'33','3942 8250',NULL,'3812 0290',NULL, 0 UNION
		SELECT 'LABORATORIOS PISA','LABORATORIOS PISA','MARCO CEJA','2','1','1','mceja@cablogistics.com.mx','JUAN DE LA BARRERA','3609',NULL,'ALAMO INDUSTRIAL',NULL,NULL,NULL,NULL,'33','36 68 47 00','4804',NULL,NULL, 0 UNION
		SELECT 'LABORATORIOS SOPHIA S A DE C V','LABORATORIOS SOPHIA S A DE C V','ING. HECTOR MUÑOZ','2','1','1','lmunoz@sophia.com.mx','AV HIDALGO','737',NULL,'SECTOR HIDALGO','GUADALAJARA','JALISCO','MEXICO',NULL,NULL,'39-42-56-00',NULL,NULL,NULL, 0 UNION
		SELECT 'MEGACABLE','MEGACABLE','Paulino Barajas/Raymundo Fernandez','2','3','1','pbarajas@megacable.com.mx /rfernandez@megacable.com.mx','AV. LAZARO CARDENAS','1694',NULL,'DEL FRESNO','GUADALAJARA','JALISCO','MEXICO','44900','33','37500029',NULL,NULL,NULL, 0 UNION
		SELECT 'MGB COMUNICACIONES, S.A. DE C.V','MGB COMUNICACIONES, S.A. DE C.V','Jose Carlos Galvez','2','1','1',NULL,'MAIZ','285',NULL,'LA NOGALERA','GUADALAJARA','JALISCO','MEXICO','44470','33','36-70-54-62',NULL,'38-49-45-02','MGB050827C22', 0 UNION
		SELECT 'OXXO CORPORATIVO','OXXO CORPORATIVO','ING.GERMAN','2','1','1',NULL,'CLL 2',NULL,NULL,'ZONA INDUSTRIAL','GUADALAJARA','JALISCO','MEXICO','44940',NULL,NULL,NULL,NULL,NULL, 0 UNION
		SELECT 'PROMOMEDIOS SA CV','PROMOMEDIOS SA CV','CPT MANUEL VALDEZ','2','1','1',NULL,'AV MARIANO OTERO','3405',NULL,'VERDE VALLE','GUADALAJARA','JALISCO','MEXICO',NULL,'33','3880 1500',NULL,NULL,NULL, 0 UNION
		SELECT 'SERVICIOS ROBLE S A DE C V','SERVICIOS ROBLE S A DE C V','ING. JOSE PALOMARES','2','3','1','jpalomares@sellorojo.com.mx','GONZALEZ GALLO','2190',NULL,'EL ROSARIO','GUADALAJARA','JALISCO','MEXICO',NULL,NULL,NULL,NULL,NULL,NULL, 0 UNION
		SELECT 'TELEPERFORMANCE SA CV','TELEPERFORMANCE SA CV','ING JUVENAL GONZALEZ','2','1','1','bequer.ryan@teleperformance.com','CAMINO AL ITESO','8900',NULL,NULL,NULL,'JALISCO','MEXICO',NULL,'33','3001 1200',NULL,NULL,NULL, 0 UNION
		SELECT 'U. DE GUADALAJARA CUSUR','U. DE GUADALAJARA CUSUR','ing.Roberto Cuevas','2','1','2','roberto.cuevas@cusur.udg.mx',NULL,NULL,NULL,'CENTRO','CIUDAD GUZMAN','JALISCO','MEXICO',NULL,NULL,'575 2222','46057',NULL,NULL, 0 UNION
		SELECT 'UNIFRIO SA DE CV','UNIFRIO SA DE CV','Ing. Leonardo Navarro','2','1','3','ventas@unifrio.com.mx','CARRETERA GUADALAJARA MORELIA','7783',NULL,'BONANZA RESIDENCIAL','ZAPOPAN','JALISCO','MEXICO','45645','33','3280 68/69',NULL,NULL,'UNI070201N38', 0 UNION
		SELECT 'Universidad Cuauhtemoc','Universidad Cuauhtemoc','Eduardo Lopez','2','1','1','eduar.lopez@cuauhtemocgdl.com.mx','Av. del Bajio','5901',NULL,'delo Bajio','ZAPOPAN','JALISCO','MEXICO','45019','33','31389316','122',NULL,NULL, 0 UNION
		SELECT 'IPESI ELECTRIFICACIONES SA de CV','IPESI ELECTRIFICACIONES SA de CV','Magdiel Camargo','5','3','1','m.camargo@corporativoholos.com.mx','Cerro de Loreto','215',NULL,'Colinas del Cimatario','QUERÉTARO','QUERÉTARO','MEXICO',NULL,'442','222 5309',NULL,'442 140 5868',NULL, 0 UNION
		SELECT 'GELATINAS D´GARY','GELATINAS D´GARY',NULL,'5','1','1',NULL,'AV. DE LAS MISIONES','7',NULL,'PARQUE INDUSTRIAL BERNARDO QUINTANA','EL MARQUÉS','QUERÉTARO','MEXICO','76246','442','1924300',NULL,'1924300',NULL, 0 UNION
		SELECT 'FARMACIAS SIMILARES, S.A. DE C.V.','FARMACIAS SIMILARES, S.A. DE C.V.','ING. FRANCISCO RUIZ','7','3','1','fruiz@fsimilares.com','EJE 6 SUR','26',NULL,'INDEPENDENCIA','MEXICO','DISTRITO FEDERAL','MEXICO','3630','01 55','5422-7002',NULL,NULL,'FSI970908ML5', 0 UNION
		SELECT 'INSTITUTO NACIONAL DE REHABILITACIÓN','INSTITUTO NACIONAL DE REHABILITACIÓN','Ing. Miguel Medina Salas','7','1','2','mmedina@inr.gob.mx','CALZADA MÉXICO XOCHIMILCO',NULL,'289','ARENAL DE GUADALUPE','MÉXICO','DISTRITO FEDERAL',NULL,'14389',NULL,NULL,NULL,NULL,'INR0506235L1', 0 UNION
		SELECT 'SANOFI AVENTIS','SANOFI AVENTIS','Carlos Gallegos','7','3','1','pilar.cristobal@sanofi-aventis.com','AV UNIVERSIDAD',NULL,NULL,NULL,NULL,'DISTRITO FEDERAL','MEXICO',NULL,'01 55','5484-4400','4130',NULL,NULL, 0 UNION
		SELECT 'COMISIÓN NACIONAL BANCARIA Y DE VALORES','COMISIÓN NACIONAL BANCARIA Y DE VALORES','ING. LUIS SOLIS ARROYO','9','1','1','jalmaguer@cnbv.gob.mx lsolis@cnbv.gob.mx','AV. INSURGENTES','1971',NULL,'FLORIDA','MÉXICO, D.F.','D.F.','MEXICO','1020','55','14546502',NULL,NULL,NULL, 0 UNION
		SELECT 'GEOPROCESADOS, S.A. DE C.V.','GEOPROCESADOS, S.A. DE C.V.','Ing. Román Hernández M.','9','3','1',NULL,'PASEO TABASCO','1203','1801','LINDA VISTA','VILLAHERMOSA','TABASCO','MEXICO','86050','993','9933520734',NULL,'9933520735','GEO9911096T7', 0 UNION
		SELECT 'CREDOMATIC SA DE CV','CREDOMATIC SA DE CV','ING.JAVIER SANCHEZ','2','3','1',NULL,'AV LAZARO CARDENAS',NULL,NULL,'JARDINES DE SAN IGNACIO','GUADALAJARA','JALISCO','MEXICO','45040','33','3880 3780','2701',NULL,NULL, 0;
	END IF;

	-- Lista inicial de Clientes
	IF(SELECT count(*) FROM blackstarDb.codexClient WHERE isProspect = 1) = 0 THEN
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

	-- Lista de precios - Inicial'
	IF(SELECT count(*) FROM blackstarDb.codexPriceList) = 0 THEN
	INSERT INTO blackstarDb.codexPriceList(code, name, price, codexProductFamilyId) VALUES
('M1100A-B-10-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 10KVA EXP. 50KVA (SIN BATERIAS)',16725.00,1),
('M1100A-B-20-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 20KVA EXP. 50KVA (SIN BATERIAS)',20412.00,1),
('M1100A-B-30-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 30KVA EXP. 50KVA (SIN BATERIAS)',23150.00,1),
('M1100A-B-40-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 40KVA EXP. 50KVA (SIN BATERIAS)',27588.00,1),
('M1100A-B-50-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 50KVA EXP. 50KVA (SIN BATERIAS)',30978.00,1),
('M1100A-A-10-208-208-1B','UPS MODULAR 1100 MARCA MITSUBISHI 10KVA EXP. 20KVA (CON BATERIAS PARA 16 MIN)',16661.00,1),
('M1100A-A-20-208-208-1B','UPS MODULAR 1100 MARCA MITSUBISHI 20KVA EXP. 20KVA (CON BATERIAS PARA 4 MIN)',20484.00,1),
('NETCOM-1100','TARJETA DE MONITOREO',1403.00,1),
('PMAU-02','MODULO DE PODER PARA EQUIPOS MITSUBISHI (10KVA)',8961.00,1),
('BB1217-1100-01','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 (UN ANILLO) Marca:CSB Dimensi贸n:',3566.00,1),
('BB1217-1100-02','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 (DOS ANILLOS en el mismo gabinete)',5781.00,1),
('BB1217-1100-03','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 (TRES ANILLOS en el mismo gabinete)',7996.00,1),
('BB1217-1100-04','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 (CUATRO ANILLOS en el mismo gabinete)',10545.00,1),
('M1100B-A-10-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 10KVA EXP. 80KVA (SIN BATERIAS)',23329.00,1),
('M1100B-A-20-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 20KVA EXP. 80KVA (SIN BATERIAS)',28109.00,1),
('M1100B-A-30-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 30KVA EXP. 80KVA (SIN BATERIAS)',32889.00,1),
('M1100B-A-40-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 40KVA EXP. 80KVA (SIN BATERIAS)',37669.00,1),
('M1100B-A-50-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 50KVA EXP. 80KVA (SIN BATERIAS)',42449.00,1),
('M1100B-A-60-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 60KVA EXP. 80KVA (SIN BATERIAS)',45899.00,1),
('M1100B-A-70-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 70KVA EXP. 80KVA (SIN BATERIAS)',50541.00,1),
('M1100B-A-80-208-208','UPS MODULAR 1100 MARCA MITSUBISHI 80KVA EXP. 80KVA (SIN BATERIAS)',55182.00,1),
('NETCOM-1100','TARJETA DE MONITOREO',1447.00,1),
('PMAU-02','MODULO DE PODER PARA EQUIPOS MITSUBISHI (10KVA)',10698.00,1),
('BB-80-1217-1100-01','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 DE HASTA 80KVA (UN ANILLO)',4188.00,1),
('BB-80-1217-1100-02','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 DE HASTA 80KVA (DOS ANILLO)',6498.00,1),
('BB-80-1217-1100-03','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 DE HASTA 80KVA (TRES ANILLO)',8809.00,1),
('BB-80-1217-1100-04','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 DE HASTA 80KVA (CUATRO ANILLO)',11119.00,1),
('BB-80-1217-1100-05','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 1100 DE HASTA 80KVA (CINCO ANILLO)',13430.00,1),
('M9900A-A-080-480-480','UPS MARCA MITSUBISHI 9900A 80KVA (SIN BATERIAS)',43207.00,1),
('M9900A-A-100-480-480','UPS MARCA MITSUBISHI 9900A 100KVA (SIN BATERIAS)',44583.00,1),
('M9900A-A-150-480-480','UPS MARCA MITSUBISHI 9900A 150KVA (SIN BATERIAS)',52429.00,1),
('M9900A-A-225-480-480','UPS MARCA MITSUBISHI 9900A 225KVA (SIN BATERIAS)',69279.00,1),
('M9900B-A-300-480-480-MSC','UPS MARCA MITSUBISHI 9900B 300KVA (SIN BATERIAS)',89682.00,1),
('M9900B-A-500-480-480-4','UPS MARCA MITSUBISHI 9900B 500KVA (SIN BATERIAS)',122786.00,1),
('M9900B-A-750-480-480-4','UPS MARCA MITSUBISHI 9900B 750KVA (SIN BATERIAS)',176844.00,1),
('BB1255-9900','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 9900, Marca: Dynasty, 12V 55AH',10694.00,1),
('BB1275-9900','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 9900, Marca: Dynasty, 12V 75AH',11506.00,1),
('BB1285-9900','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 9900, Marca: Dynasty, 12V 85AH',12562.00,1),
('BB12100-9900','BANCO DE BATERIAS EXTERNO PARA EQUIPOS 9900, Marca: Dynasty, 12V 100AH',17728.00,1),
('LINKS-INT-80','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 80KVA',508.00,1),
('LINKS-INT-100','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 100KVA',508.00,1),
('LINKS-INT-150','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 150KVA',761.00,1),
('LINKS-INT-225','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 225KVA POR ANILLO',888.00,1),
('LINKS-INT-300','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 300KVA',1142.00,1),
('LINKS-INT-500','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 500KVA',2030.00,1),
('LINKS-INT-750','LINKS E INTERRUPTORES DE BATERIAS PARA UN UPS DE 750KVA',2157.00,1),
('7011A-60','7011A UPS MODULES 6KVA',10227.00,1),
('7011A-80','7011A UPS MODULES 8KVA',16034.00,1),
('7011A-100','7011A UPS MODULES 10KVA',16388.00,1),
('7011A-12.0','7011A UPS MODULES 12KVA',16830.00,1),
('MBS-7011A-3','7011A Maintenance Bypass Switches 6, 8 or 10kva',1299.00,1),
('MBS-7011A-4','7011A Maintenance Bypass Switches 12kva',1743.00,1),
('BC7-18/2P007-006-40','7011A Battery Cabinets (17.9"x32.8"x27.7") con un tiempo de respaldo de 38 minutos para un UPS de 6kVA',3242.00,1),
('BC7-18P007-006-40','7011A Battery Cabinets (17.9"x32.8"x27.7") con un tiempo de respaldo de 22 minutos para un UPS de 6kVA',2151.00,1),
('BC7-18P080-006-40','7011A Battery Cabinets (17.9"x32.8"x27.7") con un tiempo de respaldo de 53 minutos para un UPS de 6kVA',2758.00,1),
('BC11-18/2P007-008-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 38 minutos para un UPS de 6kVA y 39 para un UPS de 8kVA',3748.00,1),
('BC11-18/2P007-010-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 28 minutos para un UPS de 10kVA',3748.00,1),
('BC11-18/2P007-012-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 22 minutos para un UPS de 12kVA',3748.00,1),
('BC11-18/2P080-010-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 65 minutos para un UPS de 10kVA',4967.00,1),
('BC11-18/2P080-012-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 53 minutos para un UPS de 12kVA',4967.00,1),
('BC11-18/3P007-008-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 55 minutos para un UPS de 6kVA y 53 para un UPS de 8kVA',4840.00,1),
('BC11-18/3P007-010-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 38 minutos para un UPS de 10kVA',4840.00,1),
('BC11-18/3P007-012-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 29 minutos para un UPS de 12kVA',4840.00,1),
('BC11-18P007-008-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 22 minutos para un UPS de 6kVA y 27 para un UPS de 8kVA',2660.00,1),
('BC11-18P007-010-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 19 minutos para un UPS de 10kVA',2660.00,1),
('BC11-18P007-012-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 15 minutos para un UPS de 12kVA',2660.00,1),
('BC11-18P080-008-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 53 minutos para un UPS de 6kVA y 51 minutos para un UPS de 8kVA',3268.00,1),
('BC11-18P080-010-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 36 minutos para un UPS de 10kVA',3268.00,1),
('BC11-18P080-012-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 28 minutos para un UPS de 12kVA',3268.00,1),
('BC11-18P100-008-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 58 minutos para un UPS de 8kVA',4098.00,1),
('BC11-18P100-010-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 42 minutos para un UPS de 10kVA',4098.00,1),
('BC11-18P100-012-60','7011A Battery Cabinets (17.9"x29.9"x40.6") con un tiempo de respaldo de 33 minutos para un UPS de 12kVA',4098.00,1),
('BC25-U200-6UL','Battery Cabinets 6kva battery cabinet',8270.00,1),
('BC25-U200-8UL','Battery Cabinets 8kva battery cabinet',8270.00,1),
('BC25-U300-10UL','Battery Cabinets 10kva battery cabinet',9239.00,1),
('BC25-U350-12UL','Battery Cabinets 12kva battery cabinet',9977.00,1),
('MCP-104-S','MUCM without DC power supply',1718.00,1),
('MCP-104-10004-S','MUCM with DC power supply',2289.00,1),
('NETCOM2-SEC-10004-S','Netcom with DC power supply',1353.00,1),
('NETCOM-SD','Netcom shutdown codes (price per code) MUST be purchased in increments of (10)',19.00,1),
('PDUCBP-50','PDU con Bypass de Mantenimiento en Gabinete Autosoportado para UPS 1100 de 50 KVAS. Cuenta con 48 Polos de distribución e incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318. (No incluye interruptores de distribución)',6125.85,2),
('PDUCBPCTRB-50','PDU con Bypass de Mantenimiento y Transformador de Bajada 480/208V factor K-13 en Gabinete Autosoportado para UPS 1100 de 50 KVAS. Cuenta con 48 Polos de distribución e incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318 (No incluye Interruptores de Distribución)',8935.12,2),
('PDUCBPCTR-50','PDU con Bypass de Mantenimiento y Transformador de Aislamiento 208/208V factor K-13 en Gabinete Autosoportado para UPS 1100 de 50 KVAS. Cuenta con 48 Polos de distribución e incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318 (No incluye interruptores de distribución)',8935.12,2),
('PDU-50','PDU en Gabinete Autosoportado para UPS 1100 de 50 KVAS. Cuenta con 48 Polos de distribución. (No incluye interruptores de distribución)',2034.79,2),
('PDUCTRB-50','PDU con Transformador de Bajada 480/208V factor K-13 en Gabinete Autosoportado para UPS 1100 de 50 KVAS. Cuenta con 48 Polos de distribución. (No incluye Interruptores de Distribución)',4844.07,2),
('PDUCTR-50','PDU con Transformador de Aislamiento 208/208V factor K-13 en Gabinete Autosoportado para UPS 1100 de 50 KVAS. Cuenta con 48 Polos de distribución (No incluye interruptores de distribución)',4844.07,2),
('BPCTR-50','Bypass de Mantenimiento en Gabinete Autosoportado para UPS 1100 de 50 KVAS con transformador de Aislamiento factor k-13 208/208V. Incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318.',8356.00,2),
('BPCTRB-50','Bypass de Mantenimiento en Gabinete Autosoportado para UPS 1100 de 50 KVAS con transformador de Aislamiento factor k-13 480/208V. Incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318.',8356.00,2),
('BP-50','Bypass de Mantenimiento en Gabinete Autosoportado para UPS 1100 de 50 KVAS. Incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318.',5545.95,2),
('PDUCBP-20','PDU con Bypass de Mantenimiento en Gabinete Autosoportado para UPS 1100 de 20 KVAS. Cuenta con 48 Polos de distribución e incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318. (No incluye interruptores de distribución)',6125.85,2),
('PDUCBPCTRB-20','PDU con Bypass de Mantenimiento y Transformador de Bajada 480/208V factor K-13 en Gabinete Autosoportado para UPS 1100 de 20 KVAS. Cuenta con 48 Polos de distribución e incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318 (No incluye Interruptores de Distribución)',7826.88,2),
('PDUCBPCTR-20','PDU con Bypass de Mantenimiento y Transformador de Aislamiento 208/208V factor K-13 en Gabinete Autosoportado para UPS 1100 de 20 KVAS. Cuenta con 48 Polos de distribución e incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318 (No incluye interruptores de distribución)',7826.88,2),
('PDU-20','PDU en Gabinete Autosoportado para UPS 1100 de 20 KVAS. Cuenta con 48 Polos de distribución. (No incluye interruptores de distribución)',2034.79,2),
('PDUCTRB-20','PDU con Transformador de Bajada 480/208V factor K-13 en Gabinete Autosoportado para UPS 1100 de 20 KVAS. Cuenta con 48 Polos de distribución. (No incluye Interruptores de Distribución)',3735.82,2),
('PDUCTR-20','PDU con Transformador de Aislamiento 208/208V factor K-13 en Gabinete Autosoportado para UPS 1100 de 20 KVAS. Cuenta con 48 Polos de distribución (No incluye interruptores de distribución)',3735.82,2),
('BPCTR-20','Bypass de Mantenimiento en Gabinete Autosoportado para UPS 1100 de 20 KVAS con transformador de Aislamiento factor k-13 208/208V. Incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318.',7247.95,2),
('BPCTRB-20','Bypass de Mantenimiento en Gabinete Autosoportado para UPS 1100 de 20 KVAS con transformador de Aislamiento factor k-13 480/208V. Incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318.',7247.95,2),
('BP-20','Bypass de Mantenimiento en Gabinete Autosoportado para UPS 1100 de 20 KVAS. Incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318.',5545.95,2),
('BPCTRB-80','Bypass de Mantenimiento en Gabinete Autosoportado para UPS 1100B de 80 KVAS con transformador de Aislamiento factor k-13 480/208V. Incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318.',16712.00,2),
('BP-80','Bypass de Mantenimiento en Gabinete Autosoportado para UPS 1100B de 80 KVAS. Incluye la tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318.',11091.90,2),
('A11H102A011USTWP','Serie A11H, 1 KVA 700 Watts doble conversión en línea, tipo Torre, Voltaje de entrada 120V, Voltaje de Salida 120 V., 5 min de baterias de respaldo incluido, UL1778; Conector a la entrada L5-15P; A la salida: 6 conectores 5-15R, Entrada: 55V - 150V. Frecuencia: 40-120 Hz, Dimensiones: 6.8" (Ancho); 16.9"" (profundidad) 10.6" (Altura); Peso: 37.5 lbs. 1 año de garantía incluyendo baterias. LAB DF.',782.00,3),
('A11H202A011USTWP','Serie A11H, 2 KVA 1400 Watts doble conversión en línea, tipo Torre, Voltaje de entrada 120V, Voltaje de Salida 120 V., 12 min de baterias de respaldo incluido. UL1778; Conector a la entrada L5-20P; A la salida: 4 conectores 5-20R, Entrada: 55V - 150V. Frecuencia: 40-120 Hz, Dimensiones: 6.8" (Ancho); 23.0"" (profundidad) 19.8" (Altura); Peso: 115 lbs. 1 año de garantía incluyendo baterias. LAB DF.',2041.34,3),
('A11H302A011USTWP','Serie A11H, 3 KVA 2100 Watts doble conversión en línea, tipo Torre, Voltaje de entrada 120V, Voltaje de Salida 120 V., 10 min de baterias de respaldo incluido. UL1778; Conector a la entrada L5-30P; A la salida: 1 receptaculo 30 amp twist-lock, Entrada: 55V - 150V. Frecuencia: 40-120 Hz, Dimensiones: 6.8" (Ancho); 25.9"" (profundidad) 19.8" (Altura); Peso: 147 lbs. 1 año de garantía incluyendo baterias. LAB DF.',2396.64,3),
('A11H102A011USP','Serie A11H, 1 KVA 700 Watts doble conversión en línea, tipo Rack, Voltaje de entrada 120V, Voltaje de Salida 120 V., 5 min de baterias de respaldo incluido. UL1778; Conector a la entrada L5-15P; A la salida: 6 conectores 5-15R, Dimensiones: 17.3" (Ancho); 16.0" (profundidad) 3.4" (Altura); Peso: 37.5 lbs. 1 año de garantía incluyendo baterias. LAB DF.',782.00,3),
('A11H202A011USP','Serie A11H, 2 KVA 1400 Watts doble conversión en línea, tipo Rack, Voltaje de entrada 120V, Voltaje de Salida 120 V., 5 min de baterias de respaldo incluido. UL1778; Conector a la entrada L5-20P; A la salida: 4 conectores 5-20R, Entrada: 55V - 150V. Frecuencia: 40-120 Hz, Dimensiones: 17.3" (Ancho); 22.3" (profundidad) 3.4" (Altura); Peso: 63.9 lbs. 1 año de garantía incluyendo baterias. LAB DF.',1446.48,3),
('A11H302A011USP','Serie A11H, 3 KVA 2100 Watts doble conversión en línea, tipo Rack, Voltaje de entrada 120V, Voltaje de Salida 120 V., 3.5 min de baterias de respaldo incluido. UL1778; Conector a la entrada L5-30P; A la salida: 1 receptaculo 30amp. Twist-lock. Entrada: 55V - 150V. Frecuencia: 40-120 Hz, Dimensiones: 18.3" (Ancho); 24.8" (profundidad) 3.4" (Altura); Peso: 81.6 lbs. 1 año de garantía incluyendo baterias. LAB DF.',2219.44,3),
('Sanyo PR11A01-US','TARJETA DE MONITOREO PARA UPS SANYO DENKI',420.00,3),
('SANTXFR','Sanyo TRANSFORMADOR DE AISLAMIENTO PARA UPS MARCA SANYO DEKI. 208V/120V',3047.10,3),
('A11J502A002TU','Serie A11J, 5 KVA 4.5 KWatts doble conversión verdaderamente en línea, tipo Torre, Voltaje de entrada y salida 200/208/220/230/240V (de requerir Voltaje de Salida 120 V., considerar transformador de salida), 5 min de baterias de respaldo incluido en UPS. 50/60Hz. Dimensiones: 17.13" (Ancho); 28.74" (profundidad) 5.12" (Altura); Peso: 134 lbs. 1 año de garantía incluyendo baterias.',5829.30,3),
('BCA11H102A01USTWP','1kVA 20 minute External Battery Module 6.8x16.9x10.6 45 lbs',992.25,3),
('BCA11H10280WCC-2','1kVA 58 minute External Battery Module 6.8x16.9x10.6 88 lbs',1620.15,3),
('BCA11H20235WCC-1','2kVA 27 minute External Battery Module 6.8x22.2x19.8 68 lbs',1514.10,3),
('BCA11H20235WCC-2','2kVA 40 minute External Battery Module 6.8x22.2x19.8 86 lbs',1723.05,3),
('BCA11H30235WCC-1','3kVA 21 minute External Battery Module 6.8x22.2x19.8 73 lbs',1638.00,3),
('BCA11H30235WCC-2','3kVA 32 minute External Battery Module 6.8x22.2x19.8 95 lbs',1877.40,3),
('BCA11H10235WCC-1R','1kVA 16 minute External Battery Module 19x22.5x3.5 51 lbs',1341.90,3),
('BCA11H10235WCC-2R','1kVA 28 minute External Battery Module 19x22.5x3.5 60 lbs',1420.65,3),
('BCA11H15235WCC-1R','1.5kVA 16 minute External Battery Module 19x22.5x3.5 51 lbs',1374.45,3),
('BCA11H15235WCC-2R','1.5kVA 28 minute External Battery Module 19x22.5x3.5 60 lbs',1522.50,3),
('BCA11H20235WCC-1R','2kVA 16 minute External Battery Module 19x22.5x3.5 51 lbs',1403.85,3),
('BCA11H20235WCC-2R','2kVA 28 minute External Battery Module 19x22.5x3.5 60 lbs',1594.95,3),
('BCA11H30235WCC-1R','3kVA 13 minute External Battery Module 19x22.5x3.5 55 lbs',1433.25,3),
('BCA11H30235WCC-2R','3kVA 22 minute External Battery Module 19x22.5x3.5 77 lbs',1674.75,3),
('GP6120','BATERIA 6V 12AH',22.28,5),
('GP1245','BATERIA 12V 4.5AH',21.98,5),
('GP1272','BATERIA 12V 7.2AH',22.87,5),
('GP12120','BATERIA 12V 12AH',42.38,5),
('GP12170','BATERIA 12V 17AH',58.90,5),
('GP12260','BATERIA 12V 26AH',87.17,5),
('GP12340','BATERIA 12V 34AH',111.70,5),
('GP12400','BATERIA 12V 40AH',164.78,5),
('GP12650','BATERIA 12V 65AH',247.71,5),
('GP12750','BATERIA 12V 75AH',265.07,5),
('GPL121000','BATERIA 12V 100AH',337.02,5),
('HR1221WF2','BATERIA 12V 5.1AH',24.21,5),
('HR1224WF2','BATERIA 12V 6.4AH',27.62,5),
('HR1234WF2','BATERIA 12V 9AH',29.85,5),
('HR12120W','BATERIA 12V 30AH',141.97,5),
('TE1XCS104XM','240/120V 1Ø, 3W Plus Ground, ( 2 Hots, 1 Neutral, 1 Ground)',727.00,6),
('TE2XCS104XM','208Y/120V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',736.00,6),
('TE21XCS104XM','220Y/127V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',736.00,6),
('TE3XCS104XM','240/120V 3Ø, 4W Plus Ground High Leg Delta ( 3 Hots, 1 Neutral, 1 Ground)',736.00,6),
('TE4XCS104XM','480Y/277V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',736.00,6),
('TE5XCS104XM','480V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',736.00,6),
('TE6XCS104XM','240V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',736.00,6),
('TE7XCS104XM','380Y/220V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',736.00,6),
('TE12XCS104XM','240V 1Ø, 2W Plus Ground, ( 1 Hots, 1 Neutral, 1 Ground)',719.00,6),
('A','Audible Alarm & Dry Contacts',43.00,6),
('E','Extended Indicator Light',32.00,6),
('TE1XDS154XM','240/120V 1Ø, 3W Plus Ground, ( 2 Hots, 1 Neutral, 1 Ground)',1072.00,6),
('TE2XDS154XM','208Y/120V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1108.00,6),
('TE21XDS154XM','220Y/127V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1108.00,6),
('TE3XDS154XM','240/120V 3Ø, 4W Plus Ground High Leg Delta ( 3 Hots, 1 Neutral, 1 Ground)',1108.00,6),
('TE4XDS154XM','480Y/277V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1108.00,6),
('TE5XDS154XM','480V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',1108.00,6),
('TE6XDS154XM','240V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',1108.00,6),
('TE7XDS154XM','380Y/220V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1108.00,6),
('TE12XDS154XM','240V 1Ø, 2W Plus Ground, ( 1 Hots, 1 Neutral, 1 Ground)',1034.00,6),
('A','Audible Alarm & Dry Contacts',42.00,6),
('TE1XDS204XM','240/120V 1Ø, 3W Plus Ground, ( 2 Hots, 1 Neutral, 1 Ground)',1252.00,6),
('TE2XDS204XM','208Y/120V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1281.00,6),
('TE21XDS204XM','220Y/127V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1281.00,6),
('TE3XDS204XM','240/120V 3Ø, 4W Plus Ground High Leg Delta ( 3 Hots, 1 Neutral, 1 Ground)',1281.00,6),
('TE4XDS204XM','480Y/277V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1281.00,6),
('TE5XDS204XM','480V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',1281.00,6),
('TE6XDS204XM','240V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',1281.00,6),
('TE7XDS204XM','380Y/220V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1281.00,6),
('TE12XDS204XM','240V 1Ø, 2W Plus Ground, ( 1 Hots, 1 Neutral, 1 Ground)',1227.00,6),
('A','Audible Alarm & Dry Contacts',42.00,6),
('TE/1HPS/CX/04/M','240/120V 1Ø, 3W Plus Ground, ( 2 Hots, 1 Neutral, 1 Ground)',1298.00,6),
('TE/2HPS/CX/04/M','208Y/120V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1390.00,6),
('TE/3HPS/CX/04/M','240/120V 3Ø, 4W Plus Ground High Leg Delta ( 3 Hots, 1 Neutral, 1 Ground)',1390.00,6),
('TE/4HPS/CX/04/M','480Y/277V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1390.00,6),
('TE/5HPS/CX/04/M','480V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',1390.00,6),
('TE/6HPS/CX/04/M','240V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',1390.00,6),
('TE/7HPS/CX/04/M','380Y/220V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1390.00,6),
('TE/12HPS/CX/04/M','240V 1Ø, 2W Plus Ground, ( 1 Hots, 1 Neutral, 1 Ground)',1254.00,6),
('/4X','NEMA 4X Polycarbonate Enclosure',313.00,6),
('/4S','NEMA 4X Stainless Steel Enclosure',731.00,6),
('/FM','NEMA 1 Flush Mount Enclosure',52.00,6),
('/DC','Dry Contacts',52.00,6),
('TE/1HPS/CL/04/M','240/120V 1Ø, 3W Plus Ground, ( 2 Hots, 1 Neutral, 1 Ground)',1480.00,6),
('TE/2HPS/CL/04/M','208Y/120V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1571.00,6),
('TE/3HPS/CL/04/M','240/120V 3Ø, 4W Plus Ground High Leg Delta ( 3 Hots, 1 Neutral, 1 Ground)',1571.00,6),
('TE/4HPS/CL/04/M','480Y/277V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1571.00,6),
('TE/5HPS/CL/04/M','480V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',1571.00,6),
('TE/6HPS/CL/04/M','240V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',1571.00,6),
('TE/7HPS/CL/04/M','380Y/220V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1571.00,6),
('TE/12HPS/CL/04/M','240V 1Ø, 2W Plus Ground, ( 1 Hots, 1 Neutral, 1 Ground)',1434.00,6),
('/4X','NEMA 4X Polycarbonate Enclosure',313.00,6),
('/4S','NEMA 4X Stainless Steel Enclosure',731.00,6),
('/FM','NEMA 1 Flush Mount Enclosure',52.00,6),
('/DC','Dry Contacts',52.00,6),
('TE/1XGA/04/M','240/120V 1Ø, 3W Plus Ground, ( 2 Hots, 1 Neutral, 1 Ground)',1799.00,6),
('TE/2XGA/04/M','208Y/120V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1843.00,6),
('TE/3XGA/04/M','240/120V 3Ø, 4W Plus Ground High Leg Delta ( 3 Hots, 1 Neutral, 1 Ground)',1843.00,6),
('TE/4XGA/04/M','480Y/277V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1843.00,6),
('TE/5XGA/04/M','480V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',1843.00,6),
('TE/6XGA/04/M','240V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',1843.00,6),
('TE/7XGA/04/M','380Y/220V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',1843.00,6),
('TE/12XGA/04/M','240V 1Ø, 2W Plus Ground, ( 1 Hots, 1 Neutral, 1 Ground)',1753.00,6),
('/4X','NEMA 4X Polycarbonate Enclosure',313.00,6),
('/4S','NEMA 4X Stainless Steel Enclosure',731.00,6),
('/FM','NEMA 1 Flush Mount Enclosure',52.00,6),
('/DC','Dry Contacts',52.00,6),
('/SC','Surge Counter',125.00,6),
('TE/1XGA/240/04/M','240/120V 1Ø, 3W Plus Ground, ( 2 Hots, 1 Neutral, 1 Ground)',2435.00,6),
('TE/2XGA/240/04/M','208Y/120V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',2616.00,6),
('TE/3XGA/240/04/M','240/120V 3Ø, 4W Plus Ground High Leg Delta ( 3 Hots, 1 Neutral, 1 Ground)',2616.00,6),
('TE/4XGA/240/04/M','480Y/277V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',2616.00,6),
('TE/5XGA/240/04/M','480V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',2616.00,6),
('TE/6XGA/240/04/M','240V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',2616.00,6),
('TE/7XGA/240/04/M','380Y/220V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',2616.00,6),
('TE/12XGA/240/04/M','240V 1Ø, 2W Plus Ground, ( 1 Hots, 1 Neutral, 1 Ground)',2253.00,6),
('/4X','NEMA 4X Polycarbonate Enclosure',313.00,6),
('/4S','NEMA 4X Stainless Steel Enclosure',731.00,6),
('/FM','NEMA 1 Flush Mount Enclosure',52.00,6),
('/DC','Dry Contacts',52.00,6),
('/SC','Surge Counter',125.00,6),
('TE1XAS30E1M','240/120V 1Ø, 3W Plus Ground, ( 2 Hots, 1 Neutral, 1 Ground)',2798.00,6),
('TE2XAS30E1M','208Y/120V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',2980.00,6),
('TE21XAS30E1M','220Y/127V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',2980.00,6),
('TE3XAS30E1M','240/120V 3Ø, 4W Plus Ground High Leg Delta ( 3 Hots, 1 Neutral, 1 Ground)',2980.00,6),
('TE4XAS30E1M','480Y/277V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',2980.00,6),
('TE5XAS30E1M','480V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',2980.00,6),
('TE6XAS30E1M','240V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',2980.00,6),
('TE7XAS30E1M','380Y/220V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',2980.00,6),
('TE12XAS30E1M','240V 1Ø, 2W Plus Ground, ( 1 Hots, 1 Neutral, 1 Ground)',2616.00,6),
('4X','NEMA 4X Polycarbonate Enclosure',313.00,6),
('4S','NEMA 4X Stainless Steel Enclosure',731.00,6),
('FM','NEMA 1 Flush Mount Enclosure',52.00,6),
('X','Surge Counter',125.00,6),
('D','Internal Rotary Disconnect Switch',313.00,6),
('T','Thru-door Rotary Disconnect Switch',418.00,6),
('TE1XAS40E1M','240/120V 1Ø, 3W Plus Ground, ( 2 Hots, 1 Neutral, 1 Ground)',3797.00,6),
('TE2XAS40E1M','208Y/120V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',3979.00,6),
('TE21XAS40E1M','220Y/127V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',3979.00,6),
('TE3XAS40E1M','240/120V 3Ø, 4W Plus Ground High Leg Delta ( 3 Hots, 1 Neutral, 1 Ground)',3979.00,6),
('TE4XAS40E1M','480Y/277V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',3979.00,6),
('TE5XAS40E1M','480V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',3979.00,6),
('TE6XAS40E1M','240V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',3979.00,6),
('TE7XAS40E1M','380Y/220V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',3979.00,6),
('TE12XAS40E1M','240V 1Ø, 2W Plus Ground, ( 1 Hots, 1 Neutral, 1 Ground)',3615.00,6),
('4X','NEMA 4X Polycarbonate Enclosure',313.00,6),
('4S','NEMA 4X Stainless Steel Enclosure',731.00,6),
('FM','NEMA 1 Flush Mount Enclosure',52.00,6),
('X','Surge Counter',125.00,6),
('D','Internal Rotary Disconnect Switch',313.00,6),
('T','Thru-door Rotary Disconnect Switch',418.00,6),
('TE1XAS50E1M','240/120V 1Ø, 3W Plus Ground, ( 2 Hots, 1 Neutral, 1 Ground)',4552.00,6),
('TE2XAS50E1M','208Y/120V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',4761.00,6),
('TE21XAS50E1M','220Y/127V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',4761.00,6),
('TE3XAS50E1M','240/120V 3Ø, 4W Plus Ground High Leg Delta ( 3 Hots, 1 Neutral, 1 Ground)',4761.00,6),
('TE4XAS50E1M','480Y/277V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',4761.00,6),
('TE5XAS50E1M','480V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',4761.00,6),
('TE6XAS50E1M','240V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',4761.00,6),
('TE7XAS50E1M','380Y/220V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',4761.00,6),
('TE12XAS50E1M','240V 1Ø, 2W Plus Ground, ( 1 Hots, 1 Neutral, 1 Ground)',4343.00,6),
('4X','NEMA 4X Polycarbonate Enclosure',313.00,6),
('4S','NEMA 4X Stainless Steel Enclosure',731.00,6),
('FM','NEMA 1 Flush Mount Enclosure',52.00,6),
('X','Surge Counter',125.00,6),
('D','Internal Rotary Disconnect Switch',313.00,6),
('T','Thru-door Rotary Disconnect Switch',418.00,6),
('TE/1C/M','240/120V 1Ø, 3W Plus Ground, ( 2 Hots, 1 Neutral, 1 Ground)',518.00,6),
('TE/2C/M','208Y/120V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',527.00,6),
('TE/3C/M','240/120V 3Ø, 4W Plus Ground High Leg Delta ( 3 Hots, 1 Neutral, 1 Ground)',527.00,6),
('TE/4C/M','480Y/277V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',527.00,6),
('TE/5C/M','480V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',527.00,6),
('TE/6C/M','240V 3Ø, 3W Plus Ground ( 3 Hots, 1 Ground)',527.00,6),
('TE/7C/M','380Y/220V 3Ø, 4W Plus Ground ( 3 Hots, 1 Neutral, 1 Ground)',527.00,6),
('TE/12C/M','240V 1Ø, 2W Plus Ground, ( 1 Hots, 1 Neutral, 1 Ground)',508.00,6),
('100','100 kA',62.00,6),
('NG','Neutral to Ground Mode adder',62.00,6),
('NF','Noise Filtration',32.00,6),
('/DC','Dry Contacts',42.00,6),
('RM','Remote Monitor, can be used with any product that has Dry Contacts',279.00,6),
('FMKITC','Flush Mount Plate for XCS and C Series Models',185.00,6),
('KITFMXF','Flush Mount Plate for XDS and XF Series Models',185.00,6),
('S50A120V1P','SPDee Series - 1 Pole Single Surge Current Rating: 50kA Per Phase',330.00,6),
('S50A127V1P','SPDee Series - 1 Pole Single Surge Current Rating: 50kA Per Phase',330.00,6),
('S50A240V1P','SPDee Series - 1 Pole Single Surge Current Rating: 50kA Per Phase',330.00,6),
('S50A277V1P','SPDee Series - 1 Pole Single Surge Current Rating: 50kA Per Phase',330.00,6),
('S50A480V1P','SPDee Series - 1 Pole Single Surge Current Rating: 50kA Per Phase',330.00,6),
('S50A120V1PN','SPDee Series - 1 Pole Single Surge Current Rating: 50kA Per Phase',353.00,6),
('S50A127V1PN','SPDee Series - 1 Pole Single Surge Current Rating: 50kA Per Phase',353.00,6),
('S50A240V1PN','SPDee Series - 1 Pole Single Surge Current Rating: 50kA Per Phase',353.00,6),
('S50A277V1PN','SPDee Series - 1 Pole Single Surge Current Rating: 50kA Per Phase',353.00,6),
('S50A480V1PN','SPDee Series - 1 Pole Single Surge Current Rating: 50kA Per Phase',353.00,6),
('D','Audible Alarm & Dry Contacts',44.00,6),
('S50A120V2P','SPDee Series - 2 Pole Split Phase Surge Current Rating: 50kA Per Phase',353.00,6),
('S50A127V2P','SPDee Series - 2 Pole Split Phase Surge Current Rating: 50kA Per Phase',353.00,6),
('S50A277V2P','SPDee Series - 2 Pole Split Phase Surge Current Rating: 50kA Per Phase',353.00,6),
('S50A120V2PN','SPDee Series - 2 Pole Split Phase Surge Current Rating: 50kA Per Phase',376.00,6),
('S50A127V2PN','SPDee Series - 2 Pole Split Phase Surge Current Rating: 50kA Per Phase',376.00,6),
('S50A480V2PN','SPDee Series - 2 Pole Split Phase Surge Current Rating: 50kA Per Phase',376.00,6),
('D','Audible Alarm & Dry Contacts',44.00,6),
('S50A120V3Y','SPDee Series - Wye Surge Current Rating: 50kA Per Phase',376.00,6),
('S50A127V3Y','SPDee Series - Wye Surge Current Rating: 50kA Per Phase',376.00,6),
('S50A220V3Y','SPDee Series - Wye Surge Current Rating: 50kA Per Phase',376.00,6),
('S50A277V3Y','SPDee Series - Wye Surge Current Rating: 50kA Per Phase',376.00,6),
('S50A347V3Y','SPDee Series - Wye Surge Current Rating: 50kA Per Phase',376.00,6),
('S50A120V3YN','SPDee Series - Wye Surge Current Rating: 50kA Per Phase',401.00,6),
('S50A127V3YN','SPDee Series - Wye Surge Current Rating: 50kA Per Phase',401.00,6),
('S50A220V3YN','SPDee Series - Wye Surge Current Rating: 50kA Per Phase',401.00,6),
('S50A277V3YN','SPDee Series - Wye Surge Current Rating: 50kA Per Phase',401.00,6),
('S50A347V3YN','SPDee Series - Wye Surge Current Rating: 50kA Per Phase',401.00,6),
('D','Audible Alarm & Dry Contacts',44.00,6),
('S50A240V3H','SPDee Series - Hi-Leg Surge Current Rating: 50kA Per Phase',376.00,6),
('S50A480V3H','SPDee Series - Hi-Leg Surge Current Rating: 50kA Per Phase',376.00,6),
('S50A240V3HN','SPDee Series - Hi-Leg Surge Current Rating: 50kA Per Phase',401.00,6),
('S50A480V3HN','SPDee Series - Hi-Leg Surge Current Rating: 50kA Per Phase',401.00,6),
('S50A240V3D','SPDee Series - Delta Surge Current Rating: 50kA Per Phase',376.00,6),
('S50A480V3D','SPDee Series - Delta Surge Current Rating: 50kA Per Phase',376.00,6),
('S50A600V3D','SPDee Series - Delta Surge Current Rating: 50kA Per Phase',376.00,6),
('MGMHT15A3B2','Transformador aislamiento MGM, aluminio, 15Kva, 150°C pico, factor estandar. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una capa electrostática.',1916.00,7),
('MGMHT15A3B2-K13','Transformador aislamiento MGM, aluminio, 15Kva, 150°C pico, factor K-13. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. Con una capa electrostática.',2106.00,7),
('MGMHT30A3B2','Transformador aislamiento MGM, aluminio, 30Kva, 150°C pico, factor estandar. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una capa electrostática.',2236.00,7),
('MGMHT30A3B2-K13','Transformador aislamiento MGM, aluminio, 30Kva, 150°C pico, factor K-13. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella.',2513.00,7),
('MGMHT45A3B2','Transformador aislamiento MGM, aluminio, 45Kva, 150°C pico, factor estandar. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una capa electrostática.',2621.00,7),
('MGMHT45A3B2-K13','Transformador aislamiento MGM, aluminio, 45Kva, 150°C pico, factor K-13. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella.',2895.00,7),
('MGMHT75A3B2','Transformador aislamiento MGM, aluminio, 75Kva, 150°C pico, factor estandar. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una pantalla electrostática.',3242.00,7),
('MGMHT75A3B2-K13','Transformador aislamiento MGM, aluminio, 75Kva, 150°C pico, factor K-13. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una pantalla electrostática.',3486.00,7),
('MGMHT112A3B2','Transformador aislamiento MGM, aluminio, 112.5Kva, 150°C pico, factor estandar. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una pantalla electrostática.',4083.00,7),
('MGMHT112A3B2-K13','Transformador aislamiento MGM, aluminio, 112.5Kva, 150°C pico, factor K-13. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una pantalla electrostática.',4650.00,7),
('MGMHT150A3B2','Transformador aislamiento MGM, aluminio, 150Kva, 150°C pico, factor estandar. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una pantalla electrostática.',4707.00,7),
('MGMHT150A3B2-K13','Transformador aislamiento MGM, aluminio, 150Kva, 150°C pico, factor K-13. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una pantalla electrostática.',5768.00,7),
('MGMHT225A3B2','Transformador aislamiento MGM, aluminio, 225Kva, 150°C pico, factor estandar. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una pantalla electrostática.',6395.00,7),
('MGMHT225A3B2-K13','Transformador aislamiento MGM, aluminio, 225Kva, 150°C pico, factor K-13. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una pantalla electrostática.',7830.00,7),
('MGMHT300A3B2','Transformador aislamiento MGM, aluminio, 300Kva, 150°C pico, factor estandar. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una pantalla electrostática.',7834.00,7),
('MGMHT300A3B2-K13','Transformador aislamiento MGM, aluminio, 300Kva, 150°C pico, factor K-13. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una pantalla electrostática.',10353.00,7),
('MGMHT500A3B2','Transformador aislamiento MGM, aluminio, 500Kva, 150°C pico, factor estandar. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una pantalla electrostática.',12257.00,7),
('MGMHT500A3B2-K13','Transformador aislamiento MGM, aluminio, 500Kva, 150°C pico, factor K-13. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella. 6 taps 2.5% (2 bajan, 4 suben). Con una pantalla electrostática.',15354.00,7),
('UPS12-100MR','BATERIA 12V 26AH',116.46,9),
('UPS12-150MR','BATERIA 12V 35AH',148.44,9),
('UPS12-210MR','BATERIA 12V 53AH',172.42,9),
('UPS12-300MR','BATERIA 12V 78AH',226.60,9),
('UPS12-350MR','BATERIA 12V 93AH',249.27,9),
('UPS12-400MR','BATERIA 12V 102AH',260.92,9),
('UPS12-490MR','BATERIA 12V 139AH',420.80,9),
('UPS12-540MR','BATERIA 12V 147AH',427.66,9),
('ACAC75005','FLOODED RECEIVER 62LBS 6 5/8" L',2188.00,10),
('ACAC75007','FLOODED RECEIVER 106LBS 8 5/8"DIA 60"L',2345.00,10),
('ACAC75009','Flooded Receiver 17lb, R410A, 6" Diameter, 18" Length',1580.00,10),
('ACCD75201','Condenser 1 EC Fan 8.8 MBH/1F TD 200-240V/3/6',7814.00,10),
('ACCD75202','Condenser 2 EC Fan 14.6 MBH/1F TD 200-240V/3/60',13601.00,10),
('ACCD75203','Condenser 3 EC Fan 25.8 MBH/1F TD 200-240V/3/60',22277.00,10),
('ACCD75204','Condenser 1 EC Fan 8.8 MBH/1F TD 460-480V/3/60',7814.00,10),
('ACCD75205','Condenser 2 EC Fan 14.6 MBH/1F TD 460-480V/3/60',13601.00,10),
('ACCD75206','Condenser 3 EC Fan 25.8 MBH/1F TD 460-480V/3/60',21841.00,10),
('ACCD75207','Condenser 1 EC Fan 4.8 kW/1C TD 380-415V/3/50',10905.00,10),
('ACCD75208','Condenser 2 EC Fan 8.1 kW/1C TD 380-415V/3/50',14516.00,10),
('ACCD75209','Condenser 2 EC Fan 11.1 kW/1C TD 380-415V/3/50',17135.00,10),
('ACCD75214','Condenser 1 Fan, Single Circuit, 2.4 MBH/1F TD, 208-240V/1/60',2861.00,10),
('ACCD75215','Condenser 1 Fan, Single Circuit, 4MBH/1F TD, 208-240V/1/60',3325.00,10),
('ACCD75216','Condenser 1 Fan, Single Circuit, 1.2MBH /1C TD, 400/3/50 FSC',3526.00,10),
('ACCD75217','Condenser, 2 Fan, Single Circuit, 2.3MBH /1C TD, 400/3/50 FSC',4483.00,10),
('ACCD75218','Condenser, 1 Fan, Single Circuit, 1.2MBH /1C TD, 220/1/50 FSC',2919.00,10),
('ACCD75219','Condenser, 2 Fan, Single Circuit, 2.3MBH /1C TD, 220/1/50 FSC',3801.00,10),
('ACCD76050','Condenser 20KW, 95F/120F, 208-230V/3/60Hz',3882.00,10),
('ACCD76051','Condenser 27kW, 95F/120F, 208-230V/3/60Hz',4273.00,10),
('ACCD76052','Condenser 32kW, 95F/120F, 208-230V/3/60Hz',4408.00,10),
('ACCD76053','Condenser 42kW, 95F/120F, 208-230V/3/60Hz',5073.00,10),
('ACCD76054','Condenser 60kW, 95F/120F, 208-230V/3/60Hz',6358.00,10),
('ACCD76055','Condenser 65kW, 95F/120F, 208-230V/3/60Hz',6884.00,10),
('ACCD76056','Condenser 88kW, 95F/120F, 208-230V/3/60Hz',7926.00,10),
('ACCD76057','Condenser 101kW, 95F/120F, 208-230V/3/60Hz',8338.00,10),
('ACCD76058','Condenser 127kW, 95F/120F, 208-230V/3/60Hz',9105.00,10),
('ACCD76059','Condenser 141kW, 95F/120F, 208-230V/3/60Hz',9980.00,10),
('ACCD76060','Condenser 178kW, 95F/120F, 208-230V/3/60Hz',11598.00,10),
('ACCD76061','Condenser 20kW, 95F/120F, 460V/3/60Hz',3995.00,10),
('ACCD76062','Condenser 27kW, 95F/120F, 460V/3/60Hz',4385.00,10),
('ACCD76063','Condenser 32kW, 95F/120F, 460V/3/60Hz',4521.00,10),
('ACCD76064','Condenser 42kW, 95F/120F, 460V/3/60Hz',5186.00,10),
('ACCD76065','Condenser 60kW, 95F/120F, 460V/3/60Hz',6517.00,10),
('ACCD76066','Condenser 65kW, 95F/120F, 460V/3/60Hz',7042.00,10),
('ACCD76067','Condenser 88kW, 95F/120F, 460V/3/60Hz',7931.00,10),
('ACCD76068','Condenser 101kW, 95F/120F, 460V/3/60Hz',8275.00,10),
('ACCD76069','Condenser 127kW, 95F/120F, 460V/3/60Hz',8872.00,10),
('ACCD76070','Condenser 141kW, 95F/120F, 460V/3/60Hz',9589.00,10),
('ACCD76071','Condenser 178kW, 95F/120F, 460V/3/60Hz',11697.00,10),
('Cooling Solutions » Air Distribution Accessories','',0.00,10),
('ACF001RF','APC Replacement Filter Air Dist Unit',59.00,10),
('Cooling Solutions » Cooling Distribution and Piping Accessories','',0.00,10),
('Cooling Solutions » EcoBreeze Air Economizers','',0.00,10),
('Cooling Solutions » Fluid Coolers','',0.00,10),
('ACFC75132','Fluid Cooler 186MBH@25TD, 20GPM, 14 Feeds, 230/3/60',9098.00,10),
('ACFC75173','Fluid Cooler 558MBH@25TD, 60GPM, 42 Feeds, 230/3/60',24171.00,10),
('ACFC75196','Fluid Cooler 182MBH@25TD, 20GPM, 21 Feeds, 230/3/60',5682.00,10),
('ACFC75206','Fluid Cooler 346MBH@25TD, 40GPM, 28 Feeds, 230/3/60',13786.00,10),
('ACFC75209','Fluid Cooler 135MBH@25TD, 30GPM, 16 Feeds, 230/3/60',4429.00,10),
('ACFC75210','Fluid Cooler 135MBH@25TD, 30 GPM, 16 Feeds, 460/3/60',4528.00,10),
('ACFC75255','Fluid Cooler 59MBH@25TD, 10 GPM, 8 Feeds, 480/3/60',2833.00,10),
('ACFC75256','Fluid Cooler 57MBH@25 TD, 10GPM, 5Feeds, 400/3/50',5887.00,10),
('ACFC75257','Fluid Cooler 57MBH@20TD, 10GPM, 8 Feeds, 400/3/50',5771.00,10),
('ACFC75260','Fluid Cooler 47kW@104F/115F, 32GPM, 208-230V/3/60Hz',8839.00,10),
('ACFC75261','Fluid Cooler 71kW@104F/115F, 48GPM, 208-230V/3/60Hz',13520.00,10),
('ACFC75262','Fluid Cooler 112kW@104F/115F, 75GPM, 208-230V/3/60Hz',17999.00,10),
('ACFC75263','Fluid Cooler 232kW@104F/115F, 153GPM, 208-230V/3/60Hz',35606.00,10),
('ACFC75264','Fluid Cooler 47kW@110F/120F, 34GPM, 208-230V/3/60Hz',6818.00,10),
('ACFC75265','Fluid Cooler 71kW@110F/120F, 53GPM, 208-230V/3/60Hz',8949.00,10),
('ACFC75266','Fluid Cooler 112kW@110F/120F, 84GPM, 208-230V/3/60Hz',15221.00,10),
('ACFC75267','Fluid Cooler 233kW@110F/120F, 162GPM, 208-230V/3/60Hz',26405.00,10),
('ACFC75268','Fluid Cooler 47kW@104F/115F, 32GPM, 460V/3/60Hz',8889.00,10),
('ACFC75269','Fluid Cooler 71kW@104F/115F, 48GPM, 460V/3/60Hz',13610.00,10),
('ACFC75270','Fluid Cooler 112kW@104F/115F, 75GPM, 460V/3/60Hz',18100.00,10),
('ACFC75271','Fluid Cooler 232kW@104F/115F, 153GPM, 460V/3/60Hz',35696.00,10),
('ACFC75272','Fluid Cooler 47kW@110F/120F, 34GPM, 460V/3/60Hz',7329.00,10),
('ACFC75273','Fluid Cooler 71kW@110F/120F, 53GPM, 460V/3/60Hz',9010.00,10),
('ACFC75274','Fluid Cooler 112kW@110F/120F, 84GPM, 460V/3/60Hz',15311.00,10),
('ACFC75275','Fluid Cooler 233kW@110F/120F, 162GPM, 460V/3/60Hz',26495.00,10),
('Cooling Solutions » InRoom Chilled Water','',0.00,10),
('Cooling Solutions » InRoom Direct Expansion','',0.00,10),
('Cooling Solutions » InRow Chilled Water Cooling','',0.00,10),
('ACAC10011','3ft (0.9144m) Stainless Flex Pipe Kit 1" MPT to 1" FPT Union',598.00,10),
('ACAC10012','6ft (1.828m) Stainless Flex Pipe Kit 1" MPT to 1" FPT Union',920.00,10),
('ACAC10016','3ft (0.914m) Stainless Flex Pipe Kit 1.25" MPT to 1.5" NPSM, OFS, Female',639.00,10),
('ACAC10017','6ft (1.828m) Stainless Flex Pipe Kit 1.25" MPT to 1.5" NPSM, OFS, Female',944.00,10),
('ACAC20002','CDU Flexible Fluid Piping - 300 Feet (91.4 Meters)',1916.00,10),
('ACAC20003','CDU Flexible Fluid Piping - 100 Feet (30.4 Meters)',758.00,10),
('ACAC20005','CDU Flexible Fluid Piping Insulation - 100 Feet (30.4 Meters)',373.00,10),
('ACAC20006','CDU Flexible Fluid Piping Couplings (4 per pack)',260.00,10),
('ACAC20008','CDU Flexible Fluid Piping Clamp/Hanger (qty of 50)',524.00,10),
('ACAC20010','CDU Flexible Fluid Piping Clamp/Hanger (qty of 10)',130.00,10),
('ACFD12-B','Cooling Distribution Unit 12 Circuit, Bottom/Top Mains, Bottom Distribution Piping',15320.00,10),
('ACFD12-T','Cooling Distribution Unit 12 Circuit, Bottom/Top Mains, Top Distribution Piping',15320.00,10),
('ACRC100','InRow RC, 300mm, Chilled Water, 100-120V, 50/60 Hz',10552.00,10),
('ACRC103','InRow RC, 300mm, Chilled Water, 200-240V, 50/60 Hz',10552.00,10),
('ACRC500','InRow RC, 600mm, Chilled Water, 200-240V, 50/60Hz',22981.00,10),
('ACRC501','InRow RC, 600mm, Chilled Water, 460-480V, 60Hz',22981.00,10),
('ACRC502','InRow RC, 600mm, Chilled Water, 380-415V, 50Hz',22981.00,10),
('ACRP500','InRow RP Chilled Water 200-240V 50/60Hz',24856.00,10),
('ACRP501','InRow RP Chilled Water 460-480V 60Hz',24856.00,10),
('ACRP502','InRow RP Chilled Water 380-415V 50 Hz',24856.00,10),
('Cooling Solutions » InRow Direct Expansion','',0.00,10),
('ACRD100','InRow RD, 300mm, Air Cooled, 208-230V, 60Hz',12897.00,10),
('ACRD101','InRow RD, 300mm, Air Cooled, 220-240V, 50Hz',12897.00,10),
('ACRD200','InRow RD, 300mm, Fluid Cooled, 208-230V, 60Hz',14461.00,10),
('ACRD201','InRow RD, 300mm, Fluid Cooled, 220-240V, 50Hz',14461.00,10),
('ACRD500','InRow RD, 600mm, Air Cooled, 200-240V, 50/60Hz',24231.00,10),
('ACRD501','InRow RD, 600mm, Air Cooled, 460-480V, 60Hz',24231.00,10),
('ACRD502','InRow RD, 600mm, Air Cooled, 380-415V, 50Hz',24231.00,10),
('ACRP100','InRow RP DX Air Cooled 200-240V 50/60Hz',25794.00,10),
('ACRP101','InRow RP DX Air Cooled 460-480V 60Hz',25794.00,10),
('ACRP102','InRow RP DX Air Cooled 380-415V 50 Hz',25794.00,10),
('ACSC100','InRow SC, 300mm, Air Cooled, Self-contained 200-240V 60Hz',8005.00,10),
('ACSC101','InRow SC, 300mm, Air Cooled, Self-contained 200-240v 50Hz',8005.00,10),
('Cooling Solutions » InRow OA','',0.00,10),
('Cooling Solutions » InRow Pumped Refrigerant','',0.00,10),
('ACAC21000','RDU Piping Kit, 1 Port',628.00,10),
('ACAC21002','RDU Piping Kit, 2 Port',1540.00,10),
('ACAC21004','RDU Piping Kit, 3 Port',2242.00,10),
('ACAC21005','RDU Rack Door',1765.00,10),
('ACAC21006','RDU Piping Flange Kit - Refrigerant',1386.00,10),
('ACAC21007','3ft (0.914m) Stainless Flex Pipe Kit - Rotolock',1735.00,10),
('ACAC21008','6ft (1.828m) Stainless Flex Pipe Kit - Rotolock',2120.00,10),
('ACAC21009','4.5ft (1.372m) Stainless Flex Pipe Kit - Rotolock',2020.00,10),
('ACAC21010','R-134a Connection Kit - Rotolock, 2 Supply, 2 Return',169.00,10),
('ACDA901','Refrigerant Distribution Unit, 750mm, 100-240V, 50/60Hz',45214.00,10),
('ACOA500','InRow OA, 600mm, Pumped Refrigerant, 100-120V, 50/60Hz',7586.00,10),
('ACOA501','InRow OA, 600mm, Pumped Refrigerant, 200-240V, 50/60Hz',7586.00,10),
('ACRA100','InRow RA, 300mm, Pumped Refrigerant, 100-120V, 50/60Hz',8047.00,10),
('ACRA101','InRow RA, 300mm, Pumped Refrigerant, 200-240V, 50/60Hz',8047.00,10),
('Cooling Solutions » NetworkAIR AFX','',0.00,10),
('Cooling Solutions » NetworkAIR Accessories','',0.00,10),
('Cooling Solutions » NetworkAIR CM','',0.00,10),
('Cooling Solutions » NetworkAIR CW','',0.00,10),
('Cooling Solutions » NetworkAIR FM','',0.00,10),
('Cooling Solutions » Rack Air Distribution','',0.00,10),
('ACF001','APC AIR DISTRIBUTION UNIT 2U RM 115V 60HZ',947.00,10),
('ACF002','APC AIR DIST UNIT 2U RM 230/208V 50/60HZ',906.00,10),
('ACF115','APC Rack Air Removal Unit SX Fan Assembly 100-240V 50/60 Hz',2328.00,10),
('ACF126','APC Rack Air Removal Unit SX Ducting Kit 24 inch',254.00,10),
('ACF127','APC Air Removal Unit Ducting Kit 600mm',254.00,10),
('ACF136','APC Rack Air Removal Unit SX 600mm Wide Frame',651.00,10),
('ACF137','APC Rack Air Removal Unit SX 750mm Wide Frame',785.00,10),
('ACF201BLK','Rack Side Air Distribution 2U 115V 60HZ',643.00,10),
('ACF202BLK','APC SIDE AIR DISTRIBUTION UNIT 2U RM 230/208 50/60HZ',643.00,10),
('ACF400','APC Rack Air Removal Unit SX 100-240V 50/60 Hz with 600mm Wide Frame',3040.00,10),
('ACF402','APC Rack Air Removal Unit SX 100-240V 50/60 Hz with 750mm Wide Frame',3114.00,10),
('ACF501','Netshelter SX Roof Fan Tray 115 VAC',382.00,10),
('ACF502','Netshelter SX Roof Fan Tray 208-230 VAC',382.00,10),
('ACF503','Netshelter SX Roof Fan Tray 115 VAC 750mm',592.00,10),
('ACF504','Netshelter SX Roof Fan Tray 208-230 VAC 750mm',592.00,10),
('ACF505','NetShelter AV Roof Fan Tray 825mm 115VAC',352.00,10),
('ACF600','NetShelter AV 2U Rack Fan Panel',198.00,10),
('AR7715','NetShelter SX Side Airflow Duct Kit For 750mm Wide Enclosures',403.00,10),
('AR7742','NetShelter SX 42U Nexus 7018 duct kit',2771.00,10),
('AR7747','NetShelter SX 48U Nexus 7018 duct kit',3079.00,10),
('AR7751','VED for 600mm Wide Short Range / Vertical Exhaust Duct Kit for SX Enclosure',738.00,10),
('AR7752','VED for 600mm Wide Tall Range / Vertical Exhaust Duct Kit for SX Enclosure',831.00,10),
('AR7753','VED for 750mm Wide Short Range / Vertical Exhaust Duct Kit for SX Enclosure',799.00,10),
('AR7754','VED for 750mm Wide Tall Range / Vertical Exhaust Duct Kit for SX Enclosure',876.00,10),
('AR7755','Overhead Cable Extension 600mm Wide / Vertical Exhaust Duct Kit for SX Enclosure',199.00,10),
('AR7756','Overhead Cable Extension 750mm Wide / Vertical Exhaust Duct Kit for SX Enclosure',214.00,10),
('AR8206ABLK','NETSHELTER WX FAN TRAY 120VAC BLACK',169.00,10),
('AR8207BLK','NetShelter WX Fan Tray 230VAC Black',175.00,10),
('Cooling Solutions » Room Air Distribution','',0.00,10),
('ACF301','Wiring Closet Ventilation Unit 100-240V 50/60HZ',1181.00,10),
('ACF301EM','Wiring Closet Ventilation Unit with Environmental Management',1540.00,10),
('ACF310','Air Intake Grille for Wiring Closet Ventilation Unit',539.00,10),
('Cooling Solutions » Room Cooling Accessories','',0.00,10),
('Cooling Solutions » Row Cooling Accessories','',0.00,10),
('ACAC10003','InRow Roof Height Adapter, SX42U to VX42U 300 MM',651.00,10),
('ACAC10004','InRow Roof Height Adapter, SX42U to VX42U 600 MM',657.00,10),
('ACAC10005','InRow Bridge Partition, Data Cable 300 MM',266.00,10),
('ACAC10007','InRow Roof Height Adapter, SX42U to SX48U 300 MM',767.00,10),
('ACAC10009','InRow Roof Height Adapter SX42U to SX48U 600 MM',859.00,10),
('ACAC10010','InRow Bridge Partition, Data Cable 600 MM',263.00,10),
('ACAC10021','InRow SC Bridge Trough, Power and Data Cables',210.00,10),
('ACAC10022','Isolation Valve Assemblies, 1/2" ODF',103.00,10),
('ACAC10023','InRow Roof Height Adapter, SX42U to VX42U 750mm',692.00,10),
('ACAC10024','InRow Roof Height Adapter, SX42U to SX48U 750mm',901.00,10),
('ACAC10025','InRow Roof Height Adapter, SX42U to SX45U 300 MM',602.00,10),
('ACAC10026','InRow Roof Height Adapter, SX42U to SX45U 600 MM',678.00,10),
('ACAC10027','InRow Roof Height Adapter, SX42U to SX45U 750 MM',753.00,10),
('ACAC11000','InRow OA Rack Mount Kit',521.00,10),
('ACAC11002','InRow OA Mount Kit, 2200mm (3 Unit)',2452.00,10),
('ACAC11003','InRow OA Ceiling Containment Kit, 300-450mm',368.00,10),
('ACAC11004','InRow OA Ceiling Containment Kit, 600mm',381.00,10),
('ACAC11005','InRow OA Pipe Clamp Kit',59.00,10),
('ACAC11006','InRow OA End Cap Kit',310.00,10),
('ACAC11007','InRow OA Mount Kit, 1800mm (3 Unit)',2300.00,10),
('ACAC11008','InRow OA End Aisle Containment Kit - 42U',544.00,10),
('ACAC11009','InRow OA End Aisle Containment Kit - 48U',581.00,10),
('AP9325','APC Leak Sensor - 20 ft (6.1 m)',335.00,10),
('AP9326','APC Leak Sensor Extension Cable - 20 ft (6.1 m)',258.00,10),
('Cooling Solutions » Thermal Containment','',0.00,10),
('ACCS1000','APC Rack Air Containment Rear Assembly for InRow 300 mm',969.00,10),
('ACCS1001','APC Rack Air Containment Rear Assembly for NetShelter SX 42U and InRow 600mm',1954.00,10),
('ACCS1002','APC Rack Air Containment End Caps',453.00,10),
('ACCS1003','APC Rack Air Containment Front Assembly for InRow 300mm',1126.00,10),
('ACCS1004','APC Rack Air Containment Front Assembly for InRow 600mm',1875.00,10),
('ACCS1005','APC Rack Air Containment Front Assembly for NetShelter SX 42U 600mm Wide',1752.00,10),
('ACCS1006','APC Rack Air Containment Rear Assembly for NetShelter SX 42U 750mm Wide',2267.00,10),
('ACCS1007','APC Rack Air Containment Front Assembly for NetShelter SX 42U 750mm Wide',2064.00,10),
('ACCS1008','APC Rack Air Containment, Front Assembly, InRow RA, 300mm',1104.00,10),
('ACDC1005','BAYING KIT - 900mm to 900mm',242.00,10),
('ACDC1006','BAYING KIT - 1070mm to 900mm',124.00,10),
('ACDC1007','BAYING KIT - 1070mm to 1070mm',124.00,10),
('ACDC1008','PRIVACY PANEL FOR SYMMETRA PX AND XR FRAME',643.00,10),
('ACDC1009','DOOR LOCK ASSY',1104.00,10),
('ACDC1015','Retrofittable Ceiling Assembly 750mm',914.00,10),
('ACDC1016','Door and Frame Assembly SX to SX',2783.00,10),
('ACDC1017','Door and Frame Assembly SX to VX (VX Right Side)',3985.00,10),
('ACDC1018','Ceiling Assembly 300mm',583.00,10),
('ACDC1019','Retrofittable Ceiling Assembly 600 mm',870.00,10),
('ACDC1020','Door and Frame Assembly VX to SX (VX Left Side)',3793.00,10),
('ACDC1021','Door and Frame Assembly VX to VX',2940.00,10),
('Data Centers and Server Rooms and Wiring Closets » InfraStruxure Type A','',0.00,10),
('ISX-A-DOC-EN','APC ISX for Wiring Closets/Computer Rooms System Doc English',2.00,10),
('Data Centers and Server Rooms and Wiring Closets » InfraStruxure Type B','',0.00,10),
('AP420','APC FERRITE FOR 10BT CABLE QTY 10',30.00,10),
('ISX20KF','20 kW 208 V UPS BASE FRAME w/ SBP and PDU All in One',20410.00,10),
('SYCBTMON','SYMMETRA PX BATTERY MONITORING CARD',565.00,10),
('SYCDCI','SYMMETRA PX DISPLAY AND COMPUTER INTERFACE',411.00,10),
('SYSW40KH','SYMMETRA PX STATIC SWITCH MODULE, 400V',1555.00,10),
('Power Distribution » Basic Rack PDU','',0.00,10),
('AP7516','Rack PDU, Basic, 1U, 14.4kW, 208V, (6) C19',708.00,10),
('AP7526','Rack PDU, Basic, 1U, 22KW, 400V, (6) C19',708.00,10),
('AP7530','Rack PDU, Basic, Zero U, 20A, 120V, (24)5-20',238.00,10),
('AP7532','Rack PDU, Basic, Zero U, 30A, 120V, (24) 5-20',370.00,10),
('AP7540','Rack PDU, Basic, Zero U, 20A, 208V, (20)C13 & (4)C19',240.00,10),
('AP7541','Rack PDU, Basic, Zero U, 30A, 200/208V, (20)C13 & (4)C19',362.00,10),
('AP7551','Rack PDU,Basic,ZeroU,16A,230V,(20)C13 & (4)C19; IEC309',282.00,10),
('AP7552','Rack PDU,Basic,ZeroU,16A,230V,(20)C13 & (4)C19; IEC C20',282.00,10),
('AP7553','Rack PDU, Basic, Zero U, 32A, 230V, (20)C13 & (4)C19',370.00,10),
('AP7554','Rack PDU,Basic,ZeroU,16A,230V,(20)C13 & (4)C19; IEC309, 10 ft Cord',318.00,10),
('AP7555A','Rack PDU, Basic, Zero U, 22kW, 230V, (6) C19 & (3) C13, High Temp',886.00,10),
('AP7557','Rack PDU, Basic, Zero U, 11 kW, 230V, (36) C13 & (6) C19',833.00,10),
('AP7557NA','Rack PDU, Basic, Zero U, 11 kW, 230V, (36) C13 & (6) C19',904.00,10),
('AP7562','Rack PDU, Basic, Zero U, 5.7kW, 120V, (42)5-20',297.00,10),
('AP7563','Rack PDU,Basic,ZeroU,5.7kW,120&208V,(21)5-20 & (6)L6-20',297.00,10),
('AP7564','Rack PDU, Basic, Zero U, 5.7kW, 208V, (36)C13 & (6)C19',297.00,10),
('AP7567','Rack PDU, Basic, Zero U, 14.4kW, 208 V, (6) C19 & (3) C13',904.00,10),
('AP7567A','Rack PDU, Basic, Zero U, 14.4kW, 208 V, (6) C19 & (3) C13, High Temp',886.00,10),
('AP7568','Rack PDU,Basic,ZeroU,12.5kW,208V,(30)C13,(6)C19;3'' Cord',740.00,10),
('AP7569','Rack PDU,Basic,0U,14.4kW,208V,(24)C13,(4)C19,(2)L6-30R;3''',1109.00,10),
('AP7580','Rack PDU Extender, Basic, 2U, 30A, 100/120/200/208V, (4)L5-20',517.00,10),
('AP7581','Rack PDU Extender, Basic, 2U, 30A, 200/208V, (4)L6-20',517.00,10),
('AP7582','Rack PDU Extender, Basic, 2U, 30A, 120V, (12)5-20',515.00,10),
('AP7583','Rack PDU Extender, Basic, 2U, 30A, 100/120/200/208V, (4)L5-30',507.00,10),
('AP7584','Rack PDU Extender, Basic, 2U, 30A, 200/208V, (4)L6-30',517.00,10),
('AP7585','Rack PDU Extender, Basic, 2U, 32A, 230V, (4) IEC C19',505.00,10),
('AP7586','Rack PDU Extender, Basic, 2U, 32A, 230V, (4) IEC 309-32',497.00,10),
('AP7592','Rack PDU,Basic,ZeroU,5.7kW,120V,(42)5-20; 10'' Cord',362.00,10),
('AP7598','Rack PDU,Basic,ZeroU,12.5kW,208V,(30)C13,(6)C19;10'' Cord',722.00,10),
('AP7599','Rack PDU,Basic,0U,14.4kW,208V,(24)C13,(4)C19,(2)L6-30R;10''',1087.00,10),
('AP9551','Rack PDU, Basic, Zero U, 20A, 120V, (14)5-15',186.00,10),
('AP9559','Rack PDU,Basic, 1U, 16A,208&230V, (10)C13 & (2)C19',194.00,10),
('AP9560','Rack PDU, Basic, 1U, 30A, 120V, (10)5-20',264.00,10),
('AP9562','Rack PDU, Basic, 1U, 15A, 120V, (10)5-15',101.00,10),
('AP9563','Rack PDU, Basic, 1U, 20A, 120V, (10)5-20; 5-20P',157.00,10),
('AP9564','Rack PDU, Basic, 1U, 20A, 120V, (10)5-20; L5-20P',157.00,10),
('AP9565','Rack PDU, Basic, 1U, 16A, 208/230V, (12)C13',157.00,10),
('AP9566','Rack PDU, Basic, 1U, 16A, 208V, (12)C13',157.00,10),
('AP9567','Rack PDU, Basic, Zero U, 15A, 100/120V, (14) 5-15',213.00,10),
('AP9568','Rack PDU,Basic,Zero U,10A,230V, (15)C13',176.00,10),
('AP9570','Rack PDU, Basic, 1U, 30A, 208V, (4) C19',264.00,10),
('AP9571A','Rack PDU, Basic, 1U, 30A, 208V, (10) C13',289.00,10),
('AP9572','Rack PDU, Basic, Zero U, 16A, 208/230V, (15) C13',196.00,10),
('Power Distribution » Configurable Power Distribution','',0.00,10),
('0G-8310','KIT FILLER SQD NQ PNL QTY 15 ATO',17.00,10),
('0G-8311','BCPM 42P KIT ATO',5543.00,10),
('0G-8312','KIT 100A CT BCPM SPLITCORE ATO',541.00,10),
('0G-8313','PLUG FILLER GLAND PLATE 84P PDU ATO',8.00,10),
('0G-8314','BCPM 84P KIT ATO',8399.00,10),
('0G-8315','ASSY PACKAGING FINAL 84P PDU ATO',2126.00,10),
('0G-PD150G6F','TYPE C 150KW ISX PDU 480V INPUT',21392.00,10),
('0G-PD40F6FK1-M','TYPE B PDU INCL. 208V ISOLATION TRANSFORMER & MBP',14656.00,10),
('0G-PD40G6FK1-M','TYPE B PDU INCL. 480V STEP DOWN TRANSFORMER & MBP',14715.00,10),
('0G-PD40H5HK1-M','ASSY PSX-PDU 230V TYPEB W XFRM',14123.00,10),
('0G-PD40H5HK1-M-X','ASSY PSX-PDU 230V W XFRM NO METER',10647.00,10),
('0G-PD40L6FK1-M','TYPE B PDU INCL. 600V STEP DOWN TRANSFORMER & MBP',14764.00,10),
('0G-PD60G6FK1','TYPE C PDU INCL. 480V STEP DOWN TRANSFORMER',12105.00,10),
('0G-PD60H5HK1','TYPE C PSX-PDU 400V INPUT W/ISO TRANS',12614.00,10),
('0G-PD60H5HK1-X','TYPE C PSX-PDU 400V NO METER',9380.00,10),
('0G-PD60L6FK1','TYPE C PDU INCL. 600V STEP DOWN TRANSFORMER',12239.00,10),
('0G-PD80F6FK1-M','TYPE B 80KW PSX-PDU 208V IN W/MBP W/ISO TRANS',25556.00,10),
('0G-PD80F6FK1-M1','PDU 80KW 208V IN MBP ISO TRANS SINGLE FEED',28427.00,10),
('0G-PD80G6FK1-M','TYPE B 80KW PSX-PDU 480V IN W/MBP W/ISO TRANS',25556.00,10),
('0G-PD80G6FK1-M1','PDU 80KW 480V IN MBP ISO TRANS SINGLE FEED',28427.00,10),
('0G-PD80H5HK1-M','TYPE B 80KW ISX-PDU400V INP W/MBP W/ISO TRANS',28427.00,10),
('0G-PD80H5HK1-M1','PDU 80KW 400V IN MBP ISO TRANS SINGLE FEED',23069.00,10),
('0G-PD80H5HK1-M2','PDU 80KW 400V IN MBP ISO TRANS DUAL FEED',26972.00,10),
('0G-PD80L6FK1-M','TYPE B 80KW PSX-PDU 600V IN W/MBP W/ISO TRANS',25556.00,10),
('0G-PD80L6FK1-M1','PDU 80KW 600V IN MBP ISO TRANS SINGLE FEED',28427.00,10),
('0G-PDPB150G6FATO','ASSY 84P PDU BASE UNIT ATO',29558.00,10),
('0G-PDRDP-F-13','ISX RDP 208V 13 IN VX RACK W/MONITORING',4396.00,10),
('0G-PDRDP-F-13-SX','ISX RDP 208V 13IN SX RACK',4394.00,10),
('0G-PDRDP-F-13-X','ISX RDP 208V 13 IN VX RACK',4396.00,10),
('0G-PDRDP-H-40-X','ISX RDP 230V 40 IN VX RACK',6388.00,10),
('0G-PDRPPH1000','TYPE C PSX-RPP 400V INPUT',6782.00,10),
('0G-PDRPPH1000-M','ASSY PSX-PDU 230V TYPEB NO XFRM',8802.00,10),
('0G-PDRPPH1000-M-X','TYPE B PSX-PDU INPUT W/MBP',7372.00,10),
('0G-PDRPPH1000-X','TYPE C PSX-RPP 400V NO METER',5014.00,10),
('0G-PDRPPH2000-M','TYPE B 80KW ISX-PDU 400V INPUT W/MBP',15616.00,10),
('0G-PDRPPH2000-M1','PDU 80KW 400V IN MBP NO TRANS SINGLE FEED',14196.00,10),
('0G-PDRPPH2000-M2','PDU 80KW 400V IN MBP NO TRANS DUAL FEED',17240.00,10),
('0G-PDRPPNX10','TYPE C PDU 208V INPUT',7668.00,10),
('0G-PDRPPNX10-M','S/A TYPE B PSX-PDU 208V IN W/MBP',9871.00,10),
('0G-PDRPPNX14-M','TYPE B 80KW PSX-PDU 208V IN W/MBP',13451.00,10),
('0G-PDRPPNX14-M1','PDU 80KW 208V IN MBP NO TRANS SINGLE FEED',14799.00,10),
('0H-0991','MBP CTO CABLES EXIT LEFT OF 84P',1311.00,10),
('0H-0992','MBP CTO CABLES EXIT RIGHT OF 84P',1311.00,10),
('PD150G6F','InfraStruxure PDU, 144kVA, 480V/208V',25544.00,10),
('PD40F6FK1-M','APC PDU 208V/208V W/ MBP',16126.00,10),
('PD40G6FK1-M','APC PDU 480V/208V W/ MBP',21117.00,10),
('PD40H5HK1-M','APC PDU 400V/400V W/ MBP',14196.00,10),
('PD40L6FK1-M','APC PDU 600V/208V W/MBP',21598.00,10),
('PD60F6FK1','InfraStruxure PDU 60kW 208V/208V',16297.00,10),
('PD60G6FK1','InfraStruxure PDU 60kW 480V/208V',16297.00,10),
('PD60H5HK1','InfraStruxure PDU 60kW 400V/400V',13309.00,10),
('PD60L6FK1','InfraStruxure PDU 60kW 600V/208V',16297.00,10),
('PDPB150G6F','InfraStruxure PDU, 150kVA, 416A, 480V:208V Isolation Transformer, 84 Poles, 1 Subfeed',31295.00,10),
('PDRDPF10U-R','Rack Distribution Panel 208 V',6743.00,10),
('PDRDPH10U-R','Rack Distribution Panel 230 V',6388.00,10),
('PDRPPH1000','InfraStruxure PDU 60kW 400V/400V Transformerless',8340.00,10),
('PDRPPH1000-M','APC Xmerless PDU w/ MBP 400 V',13131.00,10),
('PDRPPH2000-M','APC Xmerless 80 kVA PDU 400V INPUT W/MBP',17745.00,10),
('PDRPPNX10','InfraStruxure PDU 60kW 208V/208V Transformerless',14563.00,10),
('PDRPPNX10-M','APC Xmerless PDU w/ MBP 208 V',14499.00,10),
('Power Distribution » Metered Rack PDU','',0.00,10),
('AP7800','Rack PDU, Metered, 1U, 15A, 100/120V, (8) 5-15',463.00,10),
('AP7801','Rack PDU, Metered, 1U, 20A, 120V, (8) 5-20',531.00,10),
('AP7802','Rack PDU, Metered, 2U, 30A, 120V, (16) 5-20',828.00,10),
('AP7811','RACK PDU, METERED, 2U, 30A, 208V, (12) C13S & (4) C19',813.00,10),
('AP7820','Rack PDU, Metered, 1U, 12A/208V, 10A/230V, (8) C13',463.00,10),
('AP7821','Rack PDU, Metered, 1U, 16A, 208/230V, (8) C13',505.00,10),
('AP7822','RACK PDU, METERED, 2U, 32A, 230V, (12) C13 & (4) C19',811.00,10),
('AP7823','APC Rack PDU, Metered, 2U, 30A, 120/208V, (8) C13, (8) 5-20R',845.00,10),
('AP7830','Rack PDU, Metered, Zero U, 20A, 120V, (24) 5-20',438.00,10),
('AP7831','Rack PDU, Metered, Zero U, 15A, 100/120V, (16) 5-15',470.00,10),
('AP7832','Rack PDU, Metered, Zero U, 30A, 120V, (24) 5-20',564.00,10),
('AP7850','Rack PDU, Metered, Zero U, 10A, 230V, (16) C13',470.00,10),
('AP7851','RackPDU,Metered,ZeroU,16A,230V,(20)C13 &(4)C19; IEC309',428.00,10),
('AP7853','Rack PDU, Metered, Zero U, 32A, 230V, (20)C13 & (4)C19',541.00,10),
('AP7855A','Rack PDU, Metered, Zero U, 22kW, 400V, (6) C19',1318.00,10),
('AP7862','Rack PDU, Metered, Zero U, 5.7kW, 120V, (42)5-20',524.00,10),
('AP7863','RackPDU,Metered,ZeroU,5.7kW,120&208V,(21)5-20&(6)L6-20',524.00,10),
('AP7867A','Rack PDU, Metered, Zero U, 14.4kW, 208V, (6) C19, High Temp',1291.00,10),
('AP7869','Rack PDU,Metered,ZeroU,14.4kW,208V,(24)C13,(4)C19,(2)L6-30R; 3 CORD',1418.00,10),
('AP7892','Rack PDU, Metered, Zero U, 5.7kW,120V,(42)5-20; 10'' Cord',554.00,10),
('AP7893','RackPDU,Metered,ZeroU,5.7kW,120&208V,(21)5-20&(6)L6-20; 10'' Cord',554.00,10),
('AP7894','Rack PDU,Metered, ZeroU,5.7kW,208V,(36)C13&(6)C19; 10'' Cord',629.00,10),
('AP7899','Rack PDU,Metered,ZeroU,14.4kW,208V,(24)C13,(4)C19,(2)L6-30R;10 CORD',1423.00,10),
('AP8841','RACK PDU 2G, METERED, ZEROU, 30A, 200/208V, (36) C13 & (6) C19',656.00,10),
('AP8853','Rack PDU 2G, Metered, ZeroU, 32A, 230V, (36) C13 & (6) C19',690.00,10),
('AP8858','Rack PDU 2G, Metered, ZeroU, 20A/208V, 16A/230V, (18) C13 & (2) C19',509.00,10),
('AP8858EU3','Rack PDU 2G, Metered, ZeroU, 16A, 230V, (18) C13 & (2) C19, IEC309 Cord',553.00,10),
('AP8858NA3','Rack PDU 2G, Metered, ZeroU, 20A, 208V, (18) C13 & (2) C19, L620 Cord',526.00,10),
('AP8861','Rack PDU 2G, Metered, ZeroU, 5.7kW, 208V, (36) C13 & (6) C19 & (2) 5-20',730.00,10),
('AP8865','Rack PDU 2G, Metered, ZeroU, 8.6kW, 208V, (36) C13 & (6) C19 & (2) 5-20',1036.00,10),
('AP8866','Rack PDU 2G, Metered, ZeroU, 17.2kW, 208V, (6) C13 & (12) C19',2366.00,10),
('AP8867','Rack PDU 2G, Metered, ZeroU, 17.2kW, 208V, (30) C13',2366.00,10),
('AP8868','Rack PDU 2G, Metered, ZeroU, 10.0kW, 208V, (36) C13 & (6) C19',1352.00,10),
('AP8881','Rack PDU 2G, Metered, ZeroU, 11kW, 230V, (36) C13 & (6) C19',1217.00,10),
('AP8886','Rack PDU 2G, Metered, ZeroU, 22.0kW(32A), 230V, (30) C13 & (12) C19',2177.00,10),
('AP8887','Rack PDU 2G, Metered, ZeroU, 17.3kW, 240V, (30) C13 & (12) C19',1690.00,10),
('AP8888','Rack PDU 2G, Metered, ZeroU, 23.0kW, 240V, (30) C13 & (12) C19',2197.00,10),
('Power Distribution » Metered-by-Outlet Rack PDU','',0.00,10),
('AP8641','Rack PDU 2G, Metered by Outlet with Switching, ZeroU, 30A, 200/208V, (21) C13 & (3) C19',1607.00,10),
('AP8653','Rack PDU 2G, Metered by Outlet with Switching, ZeroU, 32A, 230V, (21) C13 & (3) C19',1844.00,10),
('AP8659','Rack PDU 2G, Metered by Outlet with Switching, ZeroU, 20A/208V, 16A/230V, (21) C13 & (3) C19',1470.00,10),
('AP8659EU3','Rack PDU 2G, Metered by Outlet with Switching, ZeroU, 16A, 230V, (21) C13 & (3) C19',1555.00,10),
('AP8659NA3','Rack PDU 2G, Metered by Outlet with Switching, ZeroU, 20A, 208V, (21) C13 & (3) C19',1521.00,10),
('AP8661','Rack PDU 2G, Metered by Outlet with Switching, ZeroU, 5.7kW, 208V, (21) C13 & (3) C19',1732.00,10),
('AP8681','Rack PDU 2G, Metered by Outlet with Switching, ZeroU, 11.0kW, 230V, (21) C13 & (3) C19',2197.00,10),
('Power Distribution » Modular Power Accessories','',0.00,10),
('PDM1316IEC-3P','APC IT Power Distribution Module 3x1 Pole 3 Wire 16A 3xIEC309 300cm, 360cm, 420cm',710.00,10),
('PDM1320IEC-3P-1','APC IT Power Distribution Module 3x1 Pole 3 Wire 20A 240V IEC309 260cm 380cm 500cm',568.00,10),
('PDM1320IEC-3P-2','APC IT Power Distribution Module 3x1 Pole 3 Wire 20A 240V IEC309 680cm 860cm 1040cm',715.00,10),
('PDM1320IEC-3P-3','APC IT Power Distribution Module 3x1 Pole 3 Wire 20A 240V IEC309 1680cm 1680cm 1680cm',1022.00,10),
('PDM1320L5-3P-1','APC IT Power Distribution Module 3x1 Pole 3 Wire 20A 250V L5-20 UL 260cm 380cm 500cm',1136.00,10),
('PDM1320L5-3P-2','APC IT Power Distribution Module 3x1 Pole 3 Wire 20A 250V L5-20 UL 680cm 860cm 1040cm',1595.00,10),
('PDM1320L5-3P-3','APC IT Power Distribution Module 3x1 Pole 3 Wire 20A 240V L5-20 UL 1680cm 1680cm 1680cm',2317.00,10),
('PDM1332IEC-3P','APC IT Power Distribution Module 3x1 Pole 3 Wire 32A 3xIEC309 300cm, 360cm, 420cm',880.00,10),
('PDM1332IEC-3P-2','APC IT Power Distribution Module 3x1 Pole 3 Wire 32A 3xIEC309 480cm, 540cm, 600cm',1234.00,10),
('PDM1332IEC-3P-3','APC IT Power Distribution Module 3x1 Pole 3 Wire 32A 3xIEC309 660cm, 720cm, 780cm',1435.00,10),
('PDM2330L6-12-1200','APC IT Power Distribution Module 2 Pole 3 Wire 30A L1-L2 L6-30 1200CM',791.00,10),
('PDM2330L6-12-1400','APC IT Power Distribution Module 2 Pole 3 Wire 30A L1-L2 L6-30 1400CM',843.00,10),
('PDM2330L6-12-1680','APC IT Power Distribution Module 2 Pole 3 Wire 30A L1-L2 L6-30 1680CM',919.00,10),
('PDM2330L6-12-380','APC IT Power Distribution Module 2 Pole 3 Wire 30A L1-L2 L6-30 380cm',551.00,10),
('PDM2330L6-12-500','APC IT Power Distribution Module 2 Pole 3 Wire 30A L1-L2 L6-30 500CM',575.00,10),
('PDM2330L6-12-620','APC IT Power Distribution Module 2 Pole 3 Wire 30A L1-L2 L6-30 620CM',600.00,10),
('PDM2330L6-12-740','APC IT Power Distribution Module 2 Pole 3 Wire 30A L1-L2 L6-30 740CM',625.00,10),
('PDM2330L6-12-860','APC IT Power Distribution Module 2 Pole 3 Wire 30A L1-L2 L6-30 860CM',647.00,10),
('PDM2330L6-12-980','APC IT Power Distribution Module 2 Pole 3 Wire 30A L1-L2 L6-30 980CM',673.00,10),
('PDM2330L6-23-1200','APC IT Power Distribution Module 2 Pole 3 Wire 30A L2-L3 L6-30 1200CM',791.00,10),
('PDM2330L6-23-1400','APC IT Power Distribution Module 2 Pole 3 Wire 30A L2-L3 L6-30 1400CM',843.00,10),
('PDM2330L6-23-1680','APC IT Power Distribution Module 2 Pole 3 Wire 30A L2-L3 L6-30 1680CM',919.00,10),
('PDM2330L6-23-380','APC IT Power Distribution Module 2 Pole 3 Wire 30A L2-L3 L6-30 380CM',551.00,10),
('PDM2330L6-23-500','APC IT Power Distribution Module 2 Pole 3 Wire 30A L2-L3 L6-30 500CM',575.00,10),
('PDM2330L6-23-620','APC IT Power Distribution Module 2 Pole 3 Wire 30A L2-L3 L6-30 620CM',600.00,10),
('PDM2330L6-23-740','APC IT Power Distribution Module 2 Pole 3 Wire 30A L2-L3 L6-30 740CM',625.00,10),
('PDM2330L6-23-860','APC IT Power Distribution Module 2 Pole 3 Wire 30A L2-L3 L6-30 860CM',647.00,10),
('PDM2330L6-23-980','APC IT Power Distribution Module 2 Pole 3 Wire 30A L2-L3 L6-30 980CM',673.00,10),
('PDM2330L6-31-1200','APC IT Power Distribution Module 2 Pole 3 Wire 30A L3-L1 L6-30 1200CM',791.00,10),
('PDM2330L6-31-1400','APC IT Power Distribution Module 2 Pole 3 Wire 30A L3-L1 L6-30 1400CM',843.00,10),
('PDM2330L6-31-1680','APC IT Power Distribution Module 2 Pole 3 Wire 30A L3-L1 L6-30 1680CM',919.00,10),
('PDM2330L6-31-380','APC IT Power Distribution Module 2 Pole 3 Wire 30A L3-L1 L6-30 380CM',551.00,10),
('PDM2330L6-31-500','APC IT Power Distribution Module 2 Pole 3 Wire 30A L3-L1 L6-30 500CM',575.00,10),
('PDM2330L6-31-620','APC IT Power Distribution Module 2 Pole 3 Wire 30A L3-L1 L6-30 620CM',600.00,10),
('PDM2330L6-31-740','APC IT Power Distribution Module 2 Pole 3 Wire 30A L3-L1 L6-30 740CM',625.00,10),
('PDM2330L6-31-860','APC IT Power Distribution Module 2 Pole 3 Wire 30A L3-L1 L6-30 860CM',647.00,10),
('PDM2330L6-31-980','APC IT Power Distribution Module 2 Pole 3 Wire 30A L3-L1 L6-30 980CM',673.00,10),
('PDM2332IEC-3P30R-1','PWR Dist. Mod. 3x1 POLE 3 WIRE RCD 32A 3xIEC309 300CM, 360CM, 420CM',1017.00,10),
('PDM2332IEC-3P30R-2','Power Dist. Mod. 3x1 POLE 3 Wire RCD 32A 3xIEC309 480CM, 540CM, 600CM',1139.00,10),
('PDM2332IEC-3P30R-3','Power Dist. Mod. 3x1 POLE 3 Wire RCD 32A 3xIEC309 660CM, 720CM, 780CM',1262.00,10),
('PDM316IEC-30R-1040','Power Dist. Mod. 3 Pole 5 Wire RCD 16A 30mA IEC309 1040CM',733.00,10),
('PDM316IEC-30R-140','Power Dist. Mod. 3 Pole 5 Wire RCD 16A 30mA IEC309 140CM',625.00,10),
('PDM316IEC-30R-320','Power Dist. Mod. 3 Pole 5 Wire RCD 16A 30mA IEC309 320CM',651.00,10),
('PDM316IEC-30R-500','Power Dist. Mod. 3 Pole 5 Wire RCD 16A 30mA IEC309 500CM',671.00,10),
('PDM316IEC-30R-680','Power Dist. Mod. 3 Pole 5 Wire RCD 16A 30mA IEC309 680CM',693.00,10),
('PDM316IEC-30R-860','Power Dist. Mod. 3 Pole 5 Wire RCD 16A 30mA IEC309 860CM',711.00,10),
('PDM332IEC-30R-1040','Power Dist. Mod. 3 Pole 5 Wire RCD 32A 30mA IEC309 1040CM',749.00,10),
('PDM332IEC-30R-140','Power Dist. Mod. 3 Pole 5 Wire RCD 32A 30mA IEC309 140CM',639.00,10),
('PDM332IEC-30R-320','Power Dist. Mod. 3 Pole 5 Wire RCD 32A 30mA IEC309 320CM',668.00,10),
('PDM332IEC-30R-500','Power Dist. Mod. 3 Pole 5 Wire RCD 32A 30mA IEC309 500CM',690.00,10),
('PDM332IEC-30R-680','Power Dist. Mod. 3 Pole 5 Wire RCD 32A 30mA IEC309 680CM',708.00,10),
('PDM332IEC-30R-860','Power Dist. Mod. 3 Pole 5 Wire RCD 32A 30mA IEC309 860CM',730.00,10),
('PDM3450CS50-1040','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 1040cm',1693.00,10),
('PDM3450CS50-1680','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 1680CM',2204.00,10),
('PDM3450CS50-200','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 200cm',1038.00,10),
('PDM3450CS50-260','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 260cm',1087.00,10),
('PDM3450CS50-320','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 320cm',1134.00,10),
('PDM3450CS50-380','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 380cm',1181.00,10),
('PDM3450CS50-440','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 440cm',1230.00,10),
('PDM3450CS50-500','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 500cm',1278.00,10),
('PDM3450CS50-560','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 560cm',1325.00,10),
('PDM3450CS50-620','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 620cm',1374.00,10),
('PDM3450CS50-680','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 680cm',1421.00,10),
('PDM3450CS50-740','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 740c',1469.00,10),
('PDM3450CS50-800','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 800cm',1518.00,10),
('PDM3450CS50-860','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 860cm',1565.00,10),
('PDM3450CS50-920','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 920cm',1597.00,10),
('PDM3450CS50-980','APC IT Power Distribution Module 3 Pole 4 Wire 50A CS50 980cm',1644.00,10),
('PDM3460IEC309-1040','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 1040cm',2278.00,10),
('PDM3460IEC309-1680','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 1680cm',2996.00,10),
('PDM3460IEC309-200','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 200cm',1335.00,10),
('PDM3460IEC309-260','APC IT POWER DISTRIBUTION MODULE 3 POLE 4 WIRE 60A IEC309 260CM',1403.00,10),
('PDM3460IEC309-320','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 320cm',1469.00,10),
('PDM3460IEC309-380','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 380cm',1536.00,10),
('PDM3460IEC309-440','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 440cm',1604.00,10),
('PDM3460IEC309-500','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 500cm',1671.00,10),
('PDM3460IEC309-560','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 560cm',1739.00,10),
('PDM3460IEC309-620','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 620cm',1807.00,10),
('PDM3460IEC309-680','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 680cm',1874.00,10),
('PDM3460IEC309-740','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 740cm',1942.00,10),
('PDM3460IEC309-800','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 800cm',2009.00,10),
('PDM3460IEC309-860','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 860cm',2077.00,10),
('PDM3460IEC309-920','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 920cm',2143.00,10),
('PDM3460IEC309-980','APC IT Power Distribution Module 3 Pole 4 Wire 60A IEC309 980cm',2212.00,10),
('PDM3516IEC-1040','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 1040cm',642.00,10),
('PDM3516IEC-140','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 140cm',531.00,10),
('PDM3516IEC-200','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 200cm',539.00,10),
('PDM3516IEC-260','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 260cm',546.00,10),
('PDM3516IEC-320','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 320cm',554.00,10),
('PDM3516IEC-380','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 380cm',561.00,10),
('PDM3516IEC-440','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 440cm',568.00,10),
('PDM3516IEC-500','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 500cm',576.00,10),
('PDM3516IEC-560','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 560cm',583.00,10),
('PDM3516IEC-620','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 620cm',592.00,10),
('PDM3516IEC-680','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 680cm',598.00,10),
('PDM3516IEC-740','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 740cm',605.00,10),
('PDM3516IEC-80','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 80cm',524.00,10),
('PDM3516IEC-800','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 800cm',613.00,10),
('PDM3516IEC-860','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 860cm',622.00,10),
('PDM3516IEC-920','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 920cm',629.00,10),
('PDM3516IEC-980','APC IT Power Distribution Module 3 Pole 5 Wire 16A IEC309 980cm',635.00,10),
('PDM3520IEC309-1040','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 1040cm',759.00,10),
('PDM3520IEC309-140','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 140cm',647.00,10),
('PDM3520IEC309-1680','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 1680cm',843.00,10),
('PDM3520IEC309-200','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 200cm',657.00,10),
('PDM3520IEC309-260','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 260cm',664.00,10),
('PDM3520IEC309-320','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 320cm',671.00,10),
('PDM3520IEC309-380','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 380cm',678.00,10),
('PDM3520IEC309-440','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 440cm',684.00,10),
('PDM3520IEC309-500','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 500cm',693.00,10),
('PDM3520IEC309-560','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 560cm',700.00,10),
('PDM3520IEC309-620','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 620cm',708.00,10),
('PDM3520IEC309-680','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 680cm',715.00,10),
('PDM3520IEC309-740','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 740cm',722.00,10),
('PDM3520IEC309-80','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 80cm',639.00,10),
('PDM3520IEC309-800','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 800cm',730.00,10),
('PDM3520IEC309-860','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 860cm',737.00,10),
('PDM3520IEC309-920','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 920cm',745.00,10),
('PDM3520IEC309-980','APC IT Power Distribution Module 3 Pole 5 Wire 20A 240V IEC309 980cm',752.00,10),
('PDM3520L2120-1040','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 1040cm',852.00,10),
('PDM3520L2120-1680','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 1680cm',919.00,10),
('PDM3520L2120-200','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 200cm',568.00,10),
('PDM3520L2120-260','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 260cm',581.00,10),
('PDM3520L2120-320','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 320cm',597.00,10),
('PDM3520L2120-380','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 380cm',610.00,10),
('PDM3520L2120-440','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 440cm',625.00,10),
('PDM3520L2120-500','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 500cm',639.00,10),
('PDM3520L2120-560','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 560cm',652.00,10),
('PDM3520L2120-620','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 620cm',668.00,10),
('PDM3520L2120-680','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 680cm',681.00,10),
('PDM3520L2120-740','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 740cm',696.00,10),
('PDM3520L2120-800','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 800cm',710.00,10),
('PDM3520L2120-860','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 860cm',723.00,10),
('PDM3520L2120-920','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 920cm',739.00,10),
('PDM3520L2120-980','APC IT Power Distribution Module 3 Pole 5 Wire 20A L21-20 980cm',752.00,10),
('PDM3530L2130-1040','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 1040cm',1142.00,10),
('PDM3530L2130-1680','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 1680cm',1460.00,10),
('PDM3530L2130-200','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 200cm',728.00,10),
('PDM3530L2130-260','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 260cm',759.00,10),
('PDM3530L2130-320','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 320cm',788.00,10),
('PDM3530L2130-380','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 380cm',818.00,10),
('PDM3530L2130-440','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 440cm',847.00,10),
('PDM3530L2130-500','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 500cm',877.00,10),
('PDM3530L2130-560','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 560cm',906.00,10),
('PDM3530L2130-620','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 620cm',935.00,10),
('PDM3530L2130-680','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 680cm',967.00,10),
('PDM3530L2130-740','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 740c',995.00,10),
('PDM3530L2130-800','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 800cm',1026.00,10),
('PDM3530L2130-860','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 860cm',1055.00,10),
('PDM3530L2130-920','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 920cm',1085.00,10),
('PDM3530L2130-980','APC IT Power Distribution Module 3 Pole 5 Wire 30A L21-30 980cm',1112.00,10),
('PDM3532IEC-1040','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 1040cm',720.00,10),
('PDM3532IEC-140','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 140cm',608.00,10),
('PDM3532IEC-200','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 200cm',615.00,10),
('PDM3532IEC-260','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 260cm',624.00,10),
('PDM3532IEC-320','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 320cm',630.00,10),
('PDM3532IEC-380','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 380cm',637.00,10),
('PDM3532IEC-440','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 440cm',646.00,10),
('PDM3532IEC-500','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 500cm',652.00,10),
('PDM3532IEC-560','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 560cm',661.00,10),
('PDM3532IEC-620','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 620cm',668.00,10),
('PDM3532IEC-680','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 680cm',674.00,10),
('PDM3532IEC-740','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 740cm',683.00,10),
('PDM3532IEC-80','APC IT Power Distribution Module 3-Pole 5-Wire 32A IEC309, 80cm',600.00,10),
('PDM3532IEC-800','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 800cm',690.00,10),
('PDM3532IEC-860','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 860cm',698.00,10),
('PDM3532IEC-920','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 920cm',705.00,10),
('PDM3532IEC-980','APC IT Power Distribution Module 3 Pole 5 Wire 32A IEC309 980cm',711.00,10),
('PDM3540IEC309-1040','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 1040cm',1901.00,10),
('PDM3540IEC309-1680','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 1680cm',2508.00,10),
('PDM3540IEC309-200','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 200cm',1070.00,10),
('PDM3540IEC309-260','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 260cm',1134.00,10),
('PDM3540IEC309-320','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 320cm',1198.00,10),
('PDM3540IEC309-380','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 380cm',1262.00,10),
('PDM3540IEC309-440','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 440cm',1310.00,10),
('PDM3540IEC309-500','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 500cm',1374.00,10),
('PDM3540IEC309-560','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 560cm',1438.00,10),
('PDM3540IEC309-620','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 620cm',1486.00,10),
('PDM3540IEC309-680','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 680cm',1550.00,10),
('PDM3540IEC309-740','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 740cm',1612.00,10),
('PDM3540IEC309-800','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 800cm',1661.00,10),
('PDM3540IEC309-860','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 860cm',1725.00,10),
('PDM3540IEC309-920','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 920cm',1788.00,10),
('PDM3540IEC309-980','APC IT Power Distribution Module 3 Pole 5 Wire 40A IEC 309 980cm',1837.00,10),
('PDM3563IEC-1040','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 1040cm',3306.00,10),
('PDM3563IEC-200','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 200cm',1616.00,10),
('PDM3563IEC-260','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 260cm',1727.00,10),
('PDM3563IEC-320','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 320cm',1840.00,10),
('PDM3563IEC-380','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 380cm',1955.00,10),
('PDM3563IEC-440','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 440cm',2069.00,10),
('PDM3563IEC-500','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 500cm',2185.00,10),
('PDM3563IEC-560','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 560cm',2297.00,10),
('PDM3563IEC-620','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 620cm',2412.00,10),
('PDM3563IEC-680','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 680cm',2530.00,10),
('PDM3563IEC-740','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 740cm',2641.00,10),
('PDM3563IEC-800','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 800cm',2756.00,10),
('PDM3563IEC-860','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 860cm',2868.00,10),
('PDM3563IEC-920','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 920cm',2979.00,10),
('PDM3563IEC-980','APC IT Power Distribution Module 3 Pole 5 Wire 63A IEC309 980cm',3089.00,10),
('PDX316IEC-1080','APC Modular IT Power Distribution Cable Extender 3 Wire 16A IEC309 1080cm',144.00,10),
('PDX316IEC-120','APC Modular IT Power Distribution Cable Extender 3 Wire 16A IEC309 120cm',100.00,10),
('PDX316IEC-1200','APC Modular IT Power Distribution Cable Extender 3 Wire 16A IEC309 1200cm',150.00,10),
('PDX316IEC-240','APC Modular IT Power Distribution Cable Extender 3 Wire 16A IEC309 240cm',106.00,10),
('PDX316IEC-360','APC Modular IT Power Distribution Cable Extender 3 Wire 16A IEC309 360cm',120.00,10),
('PDX316IEC-480','APC Modular IT Power Distribution Cable Extender 3 Wire 16A IEC309 480cm',112.00,10),
('PDX316IEC-600','APC Modular IT Power Distribution Cable Extender 3 Wire 16A IEC309 600cm',118.00,10),
('PDX316IEC-720','APC Modular IT Power Distribution Cable Extender 3 Wire 16A IEC309 720cm',127.00,10),
('PDX316IEC-840','APC Modular IT Power Distribution Cable Extender 3 Wire 16A IEC309 840cm',161.00,10),
('PDX316IEC-960','APC Modular IT Power Distribution Cable Extender 3 Wire 16A IEC309 960cm',139.00,10),
('PDX332IEC-1080','APC Modular IT Power Distribution Cable Extender 3 Wire 32A IEC309 1080cm',368.00,10),
('PDX332IEC-120','APC Modular IT Power Distribution Cable Extender 3 Wire 32A IEC309 120cm',264.00,10),
('PDX332IEC-1200','APC Modular IT Power Distribution Cable Extender 3 Wire 32A IEC309 1200cm',384.00,10),
('PDX332IEC-240','APC Modular IT Power Distribution Cable Extender 3 Wire 32A IEC309 240cm',279.00,10),
('PDX332IEC-360','APC Modular IT Power Distribution Cable Extender 3 Wire 32A IEC309 360cm',291.00,10),
('PDX332IEC-480','APC Modular IT Power Distribution Cable Extender 3 Wire 32A IEC309 480cm',294.00,10),
('PDX332IEC-600','APC Modular IT Power Distribution Cable Extender 3 Wire 32A IEC309 600cm',309.00,10),
('PDX332IEC-720','APC Modular IT Power Distribution Cable Extender 3 Wire 32A IEC309 720cm',323.00,10),
('PDX332IEC-840','APC Modular IT Power Distribution Cable Extender 3 Wire 32A IEC309 840cm',340.00,10),
('PDX332IEC-960','APC Modular IT Power Distribution Cable Extender 3 Wire 32A IEC309 960cm',353.00,10),
('PDX516IEC-300','APC Modular IT Power Distribution Cable Extender 5 Wire 16A IEC309 300cm',357.00,10),
('PDX516IEC-600','APC Modular IT Power Distribution Cable Extender 5 Wire 16A IEC309 600cm',394.00,10),
('PDX532IEC-300','APC Modular IT Power Distribution Cable Extender 5 Wire 32A IEC309 300cm',441.00,10),
('PDX532IEC-600','APC Modular IT Power Distribution Cable Extender 5 Wire 32A IEC309 600cm',480.00,10),
('Power Distribution » Modular Power Distribution','',0.00,10),
('PDPM100F-M','APC 100kVA Modular Power Distribution Unit, 208V, 72 Poles, MBP, 1 Subfeed',14215.00,10),
('PDPM100F6F-M','APC 100kVA Modular Power Distribution Unit, Isolation Transformer, 208:208V, 72 Pole, MBP, 1 Subfeed',27469.00,10),
('PDPM100G6F-M','APC 100kVA Modular Power Distribution Unit, Isolation Transformer, 480:208V, 72 Pole, MBP, 1 Subfeed',27469.00,10),
('PDPM100L6F-M','APC 100kVA Modular Power Distribution Unit, Isolation Transformer, 600:208V, 72 Pole, MBP, 1 Subfeed',29066.00,10),
('PDPM100SC','APC Symmetra PX 100kW Bottom Feed Side Car 300mm',3919.00,10),
('PDPM138H-5U','APC Modular Rack Distribution Panel, 138kVA, 200A, 400V, 18 Pole, 5U',2177.00,10),
('PDPM138H-R','APC Modular Rack-mounted Distribution Panel, 138kVA, 200A, 400V, 18 Pole, 5U',6833.00,10),
('PDPM144F','APC Modular Remote Power Panel, 144kVA, 400A, 208V, 72 Pole, 300mm',11534.00,10),
('PDPM150G6F','APC 144kVA Modular Power Distribution Unit, Isolation Transformer, 480:208V, 72 Poles, 2 Subfeed',38498.00,10),
('PDPM150L6F','APC 144kVA Modular Power Distribution Unit, Isolation Transformer, 600:208V, 72 Poles, 2 Subfeed',40557.00,10),
('PDPM150SC','APC 150kVA Modular PDU Bottom Feed Side Car, 300mm',4428.00,10),
('PDPM175G6H','APC 175kVA Modular Power Distribution Unit, Isolation Transformer, 480:415V, 72 Poles, 2 Subfeed',43095.00,10),
('PDPM277H','APC Modular Remote Power Panel, 277kVA, 400A, 400V, 72 Pole, 300mm',11534.00,10),
('PDPM288G6H','APC Modular Power Distribution Unit, 266kVA, 400A, 480V:415V Auto-transformer, 72 Pole, 300mm',28392.00,10),
('PDPM72F-5U','APC Modular Rack Distribution Panel, 72kVA, 200A, 208V, 18 Pole, 5U',3127.00,10),
('PDUM160H-B','APC Modular IT Power Distribution Unit with 36 Poles, MBP and Battery Frame for 9 Modules, 400 V',28823.00,10),
('Power Distribution » Rack PDU Accessories','',0.00,10),
('AP7400','BRACKET KIT, 0U RACK PDU, HP/DELL',57.00,10),
('AP7406','BRACKET KIT, 0U, RACK PDU, HP',61.00,10),
('AP9569','Cord Retention Bracket for Basic Rack PDUs',73.00,10),
('AR8417','NetShelter RS 4 Post Rack PDU Adapter Brackets',49.00,10),
('Power Distribution » Rack-mount Transfer Switches','',0.00,10),
('AP7701','Rack ATS, 5.7KW, (2) L21-20P in, (1) L21-20R out',945.00,10),
('AP7721','Rack ATS, 10A/230V, 12A/208V, C14 in, (12) C13 out',1039.00,10),
('AP7722A','Rack ATS, 16A, 230V, (2)IEC 309 in, (1)IEC 309 Out',1031.00,10),
('AP7723','Rack ATS, 20A/208V, 16A/230V, C20 in, (8) C13 (1) C19 out',1046.00,10),
('AP7724','Rack ATS, 230V, 32A, IEC309 in, (16) C13 (2) C19 out',1393.00,10),
('AP7730','Rack ATS, 200-208V, 20A, L6-20 in, (8) C13 (1) C19 out',1031.00,10),
('AP7732','Rack ATS, 200-208V, 30A, L6-30 in, (16) C13 (2) C19 out',1357.00,10),
('AP7750A','RACK ATS, 100-120V, 15A, L5-15 IN, (10) 5-15R OUT',894.00,10),
('AP7752','Rack ATS, 120V, 20A, L5-20 in, (10) 5-20R out',975.00,10),
('AP7753','Rack ATS, 120V, 30A, L5-30 In, (16) 5-20R Out',1320.00,10),
('AP7768','BRACKET KIT, REAR RAILS, RACK ATS',78.00,10),
('AP7769','Cord Retention Bracket for Rack ATS',78.00,10),
('Power Distribution » Switched Rack PDU','',0.00,10),
('AP7900','Rack PDU, Switched, 1U, 15A, 100/120V, (8)5-15',590.00,10),
('AP7901','Rack PDU, Switched, 1U, 20A, 120V, (8)5-20',613.00,10),
('AP7902','Rack PDU, Switched, 2U, 30A, 120V, (16)5-20',941.00,10),
('AP7911A','RACK PDU, SWITCHED, 2U, 30A, 208V, (16)C13',951.00,10),
('AP7920','Rack PDU, Switched, 1U, 12A/208V, 10A/230V, (8)C13',644.00,10),
('AP7921','Rack PDU, Switched, 1U, 16A, 208/230V, (8)C13',723.00,10),
('AP7922','Rack PDU, Switched, 2U, 32A, 230V, (16)C13',867.00,10),
('AP7930','Rack PDU, Switched, Zero U, 20A, 120V, (24)5-20',923.00,10),
('AP7931','Rack PDU, Switched, Zero U, 15A, 100/120V, (16) 5-15',923.00,10),
('AP7932','Rack PDU, Switched, Zero U, 30A, 120V, (24) 5-20',1014.00,10),
('AP7950','Rack PDU, Switched, Zero U, 10A, 230V, (16) C13',960.00,10),
('AP7960','Rack PDU, Switched, Zero U, 5.7kW, 120V, (24)5-20',1051.00,10),
('AP7968','Rack PDU,Switched,ZeroU,12.5kW,208V,(21)C13&(3)C19;3'' Cord',1475.00,10),
('AP7990','Rack PDU,Switched,ZeroU,5.7kW,120V,(24)5-20; 10'' Cord',1078.00,10),
('AP7998','Rack PDU,Switched,ZeroU,12.5kW,208V,(21)C13&(3)C19;10 Cord',1475.00,10),
('AP8941','Rack PDU 2G, Switched, ZeroU, 30A, 200/208V, (21) C13 & (3) C19',1085.00,10),
('AP8953','Rack PDU 2G, Switched, ZeroU, 32A, 230V, (21) C13 & (3) C19',1141.00,10),
('AP8958','Rack PDU 2G, Switched, ZeroU, 20A/208V, 16A/230V, (7) C13 & (1) C19',828.00,10),
('AP8958EU3','Rack PDU 2G, Switched, ZeroU, 16A, 230V, (7) C13 & (1) C19, IEC309 Cord',870.00,10),
('AP8958NA3','Rack PDU 2G, Switched, ZeroU, 20A, 208V, (7) C13 & (1) C19, L620 Cord',845.00,10),
('AP8959','Rack PDU 2G, Switched, ZeroU, 20A/208V, 16A/230V, (21) C13 & (3) C19',970.00,10),
('AP8959EU3','Rack PDU 2G, Switched, ZeroU, 16A, 230V, (21) C13 & (3) C19, IEC309 Cord',1019.00,10),
('AP8959NA3','Rack PDU 2G, Switched, ZeroU, 20A, 208V, (21) C13 & (3) C19, L620 Cord',938.00,10),
('AP8961','RACK PDU 2G, SWITCHED, ZEROU, 5.7KW, 200/208V, (21) C13 & (3) C19',1217.00,10),
('AP8965','RACK PDU 2G, SWITCHED, ZEROU, 8.6kW, 208V, (21) C13 & (3) C19',1480.00,10),
('AP8981','Rack PDU 2G, Switched, ZeroU, 11kW, 230V, (21) C13 & (3) C19',1565.00,10),
('Power Distribution » Wall-mount Transfer Switches','',0.00,10),
('UTS10BI','APC Universal Transfer Switch 10-Circuit 120/240V',664.00,10),
('UTS6','APC Universal Transfer Switch 6-Circuit 120V',521.00,10),
('UTS6BI','APC Universal Transfer Switch 6-Circuit 120/240V',521.00,10),
('UTS6H','APC Universal Transfer Switch 6-circuit 120V, L5-30',521.00,10),
('UTSHW','APC Universal Transfer Switch Hardwire Kit',37.00,10),
('Racks and Accessories » Airflow Management','',0.00,10),
('AR4701','Dust Filter Pack NetShelter CX 18U & 24U 2 Small Filters',118.00,10),
('AR4702','Dust Filter Pack Netshelter CX 38U 2 Small Filters & 2 Large Filters',245.00,10),
('AR7708','NetShelter SX Air Recirculation Prevention Kit',113.00,10),
('AR7720','KoldLok Integral Raised Floor Grommet',1320.00,10),
('AR7730','KoldLok Surface Mount Raised Floor Grommet',1989.00,10),
('AR7740','KoldLok Extended Raised Floor Grommet',2239.00,10),
('AR8101BLK','Blanking Panel Kit 19" Black (1U, 2U, 4U, 8U)',106.00,10),
('AR8108BLK','1U Blanking Panel Kit 19" Black',30.00,10),
('AR8136BLK','APC 1U 19" Black Modular Toolless Blanking Panel - Qty 10',63.00,10),
('AR8136BLK200','APC 1U 19" Black Modular Toolless Blanking Panel - Qty 200',686.00,10),
('AR8355','NetShelter WX Vented Gland Plates',37.00,10),
('Racks and Accessories » Cable Management','',0.00,10),
('AR7209','NetShelter SX Trough and Partition Roof Bridge',88.00,10),
('AR7501','Vertical Cable Organizer, NetShelter ValueLine, 42U (Qty 2)',100.00,10),
('AR7502','Vertical Cable Organizer, NetShelter SX, 42U (Qty. 2)',113.00,10),
('AR7505','Vertical Cable Organizer, Center Rear Mount, NetShelter SX',186.00,10),
('AR7511','Narrow Vertical Cable Organizer, NetShelter SX, 42U',113.00,10),
('AR7552','Vertical Cable Organizer, NetShelter SX, 45U',152.00,10),
('AR7572','Vertical Cable Organizer, NetShelter SX, 48U',132.00,10),
('AR7580A','Vertical Cable Manager for NetShelter SX 750mm Wide 42U (Qty 2)',404.00,10),
('AR7581A','Hinged Covers for NetShelter SX 750mm Wide 42U Vertical Cable Manager (Qty 2)',152.00,10),
('AR7582','Cable Retainer for NetShelter SX 750mm Wide Vertical Cable Manager (Qty 6)',54.00,10),
('AR7585','Vertical Cable Manager for NetShelter SX 750mm Wide 45U (Qty 2)',444.00,10),
('AR7586','Hinged Covers for NetShelter SX 750mm Wide 45U Vertical Cable Manager (Qty 2)',172.00,10),
('AR7588','Vertical Cable Manager for NetShelter SX 750mm Wide 48U (Qty 2)',465.00,10),
('AR7589','Hinged Covers for NetShelter SX 750mm Wide 48U Vertical Cable Manager (Qty 2)',193.00,10),
('AR7706','Mounting Rail Brush Strips, NetShelter SX, 750mm Wide',206.00,10),
('AR7707','Cable Management Rings, 8 Inch Deep, NetShelter SX, 750mm Wide (Qty. 8)',85.00,10),
('AR7710','Cable Containment Brackets with PDU Mounting Capability for NetShelter SX',132.00,10),
('AR7717A','Vertical Cable Manager for NetShelter SX 42U Networking Enclosure (Qty 4)',384.00,10),
('AR8008BLK','Horizontal Cable Organizer Side Channel 18 to 30 inch adjustment',76.00,10),
('AR8016ABLK','Horizontal Cable Organizer Side Channel 10 to 18 inch adjustment',68.00,10),
('AR8113A','Cable Management Rings (Qty. 5 Large and 5 Small Rings)',76.00,10),
('AR8129','Cable Management Arm',122.00,10),
('AR8162ABLK','Data Cable Partition, NetShelter, 600mm Wide',63.00,10),
('AR8163ABLK','Data Cable Partition, NetShelter, 600mm Wide, pass-through',63.00,10),
('AR8164ABLK','Cable Ladder 6" (15cm) Wide w/Ladder Attachment Kit (AR8166ABLK)',262.00,10),
('AR8164AKIT','Cable Ladder 6" (15cm) Wide (Qty 1)',186.00,10),
('AR8165ABLK','Cable Ladder 12" (30cm) Wide w/Ladder Attachment Kit (AR8166ABLK)',279.00,10),
('AR8165AKIT','Cable Ladder 12" (30cm) Wide (Qty 1)',206.00,10),
('AR8166ABLK','Cable Ladder Attachment Kit, Power Cable Troughs',88.00,10),
('AR8169','Cable Ladder Clamp Kit',41.00,10),
('AR8172BLK','Data Cable Partition, NetShelter, 750mm Wide',98.00,10),
('AR8173BLK','Data Cable Partition, NetShelter, 750mm Wide, pass-through',98.00,10),
('AR8177BLK','Cable Ladder Attachment Kit, 750mm Wide, Data Cable Partitions',83.00,10),
('AR8182BLK','Data Cable Partition, InfraStruXure PDU, 750mm Wide',117.00,10),
('AR8183BLK','Data Cable Partition, InfraStruXure PDU, 750mm Wide, pass-through',106.00,10),
('AR8184','Cable Partition, 300mm',63.00,10),
('AR8186','Bracket Kit, Cable Ladder Elevation',71.00,10),
('AR8190BLK','Third Party Rack Trough and Partition Adapter',308.00,10),
('AR824002','Accessory Bracket (Qty 2), NetShelter SV',66.00,10),
('AR8425A','Horizontal Cable Organizer 1U',57.00,10),
('AR8426A','Horizontal Cable Organizer 2U',63.00,10),
('AR8427A','Horizontal Cable Organizer 2U w/cable fingers',76.00,10),
('AR8428','Horizontal Cable Organizer 2U w/pass through holes',56.00,10),
('AR8429','Horizontal Cable Organizer 1U w/brush strip',46.00,10),
('AR8440A','3" Vertical Cable Organizer',335.00,10),
('AR8441A','Vertical Cable Organizer, 2 and 4 Post Racks, 6" Wide',360.00,10),
('AR8442','Vertical Cable Organizer, 8 Cable Rings, Zero U',162.00,10),
('AR8443A','Vertical Fiber Organizer',186.00,10),
('AR8444','Spools for Vertical Fiber Organizer Qty. (4)',86.00,10),
('AR8450A','4 Post Open Frame Trough and Partiton Adapter',88.00,10),
('AR8460','Cable Ladder Attachment Kit 2 Post Rack',54.00,10),
('AR8461','Cable Ladder Corner Clamp Kit',57.00,10),
('AR8462','Cable Ladder Angle Clamp Kit',113.00,10),
('AR8463','Cable Ladder Stacking Kit',189.00,10),
('AR8465','Cable Ladder Wall Termination Kit',57.00,10),
('AR8560','Cable Trough, Open Bottom, 600mm',144.00,10),
('AR8561','Cable Trough, 600mm',144.00,10),
('AR8567','Trough End Cap',51.00,10),
('AR8570','Cable Trough, Open Bottom, PDU 750mm',144.00,10),
('AR8571','Cable Trough, 750mm',162.00,10),
('AR8573','Perforated Cover, Cable Trough, 300mm',68.00,10),
('AR8574','Perforated Cover, Cable Trough, 600mm',85.00,10),
('AR8575','Perforated Cover, Cable Trough, 750mm',85.00,10),
('AR8576','Ladder Hanger Kit, Cable Trough',71.00,10),
('AR8579','Grommet, Edge Protection for NetShelter and Acc., PVC, Length-4m',33.00,10),
('AR8580','Cable Trough, Open Bottom, 300mm',125.00,10),
('AR8585','Trough Adapter Kit for Nexus 7018 ducts',137.00,10),
('AR8600','Horizontal Cable Manager, 2U Single Side with Cover',125.00,10),
('AR8601','Horizontal Cable Manager, 2U Double Side with Cover',144.00,10),
('AR8602','Horizontal Cable Manager, 1U Single Side with Cover',90.00,10),
('AR8603A','2U Horizontal Cable Manager, 6" Fingers Top, Bottom Tie Down',183.00,10),
('AR8605','3U Horizontal Cable Manager, 6" Fingers top and bottom',194.00,10),
('AR8606','2U Horizontal Cable Manager, 6" Fingers top and bottom',127.00,10),
('AR8612','1U Horizontal Cable Manager, 6" deep, Single-Sided',115.00,10),
('AR8615','CDX,Vertical Cable Manager, 84"x6"Wide, Single-Sided',850.00,10),
('AR8621','Toolless Hook and Loop Cable Managers (Qty 10)',49.00,10),
('AR8625','CDX, Vertical Cable Manager, 84"x6" wide, Double-Sided',1053.00,10),
('AR8635','CDX, Vertical Cable Manager, 84"x10" wide, Single-Sided',1012.00,10),
('AR8645','CDX, Vertical Cable Manager, 84"x10" wide Double-Sided',1296.00,10),
('AR8654','Cable Fall for NetShelter Racks and Enclosures (Qty 2)',140.00,10),
('AR8665','CDX, Vertical Cable Management, 84"x12" wide, Single-Sided',1073.00,10),
('AR8675','CDX, Vertical Cable Manager, 84"x12" wide, Double-Sided',1377.00,10),
('AR8678','CDX Side Cover, for Single Sided 84" Manager',465.00,10),
('AR8679','CDX,Side Cover, for Double Sided 84" Manager',505.00,10),
('AR8680','Cable Divider/Organizer (2 per kit)',142.00,10),
('AR8681','CDX, Connector Accessory Bracket, 6" (2 per kit)',73.00,10),
('AR8682','CDX, Connector Accessory Bracket, 10" (2 per kit)',98.00,10),
('AR8683','CDX, Connector Accessory Bracket, 12" (2 per kit)',101.00,10),
('AR8715','Valueline, Vertical Cable Manager for 2 & 4 Post Racks, 84"H X 6"W, Single-Sided with Door',336.00,10),
('AR8725','Valueline, Vertical Cable Manager for 2 & 4 Post Racks, 84"H X 6"W, Double-Sided with Doors',421.00,10),
('AR8728','Valueline, Vertical Cable Manager for 2 & 4 Post Racks, 96"H X 6"W, Single-Sided with Door',404.00,10),
('AR8765','Valueline, Vertical Cable Manager for 2 & 4 Post Racks, 84"H X 12"W, Single-Sided with Door',505.00,10),
('AR8768','Valueline, Vertical Cable Manager for 2 & 4 Post Racks, 96"H X 12"W, Single-Sided with Door',573.00,10),
('AR8775','Valueline, Vertical Cable Manager for 2 & 4 Post Racks, 84"H X 12"W, Double-Sided with Doors',590.00,10),
('AR8791','Door Kit for VL Vertical Cable Manager 2 & 4 Post Racks, 84"H X 6"W (Qty 1)',85.00,10),
('AR8792','Door Kit for VL Vertical Cable Manager 2 & 4 Post Racks, 84"H X 12"W (Qty 1)',127.00,10),
('AR8793','Door Kit for VL Vertical Cable Manager 2 & 4 Post Racks, 96"H X 6"W (Qty 1)',101.00,10),
('AR8794','Door Kit for VL Vertical Cable Manager 2 & 4 Post Racks, 96"H X 12"W (Qty 1)',144.00,10),
('AR8795','End Cap for VL Vertical Cable Manager 2 & 4 Post Racks (Qty 2)',17.00,10),
('Racks and Accessories » Data Distribution Cable','',0.00,10),
('AR8451','APC Data Distribution 1U Panel, Holds 4 each Data Distribution Cables for a Total of 24 Ports',37.00,10),
('AR8452','APC Data Distribution 2U Panel, Holds 8 each Data Distribution Cables for a Total of 48 Ports',54.00,10),
('AR8457','APC Data Distribution 0U SX Panel',51.00,10),
('AR8469','Data Distribution Plastic Snap-in Panel NetShelter SX (Qty 8)',57.00,10),
('CAT6PNL-24','APC CAT 6 Patch Panel, 24 port RJ45 to 110 568 A/B color coded',208.00,10),
('CAT6PNL-48','APC CAT 6 Patch Panel, 48 port RJ45 to 110 568 A/B color coded',390.00,10),
('DDCC5E-009','APC Data Distribution Cable, CAT5e UTP CMR Gray, 6xRJ-45 Jack to 6xRJ-45 Jack, 9ft (2,7m)',100.00,10),
('DDCC6-005','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 5FT (1.5M)',171.00,10),
('DDCC6-007','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 7FT (2.1M)',183.00,10),
('DDCC6-009','APC Data Distrbution Cable, CAT6 UTP CMR 6XRJ-45 Black 9FT (2.7M)',201.00,10),
('DDCC6-011','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 11FT (3.3M)',199.00,10),
('DDCC6-013','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 13FT (3.9M)',208.00,10),
('DDCC6-015','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 15FT (4.5M)',216.00,10),
('DDCC6-017','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 17FT (4.5M)',225.00,10),
('DDCC6-019','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 19FT (5.7M)',233.00,10),
('DDCC6-021','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 21FT (6.4M)',248.00,10),
('DDCC6-023','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 23FT (7.0M)',270.00,10),
('DDCC6-025','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 25FT (7.6M)',265.00,10),
('DDCC6-027','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 27FT (8.2M)',274.00,10),
('DDCC6-029','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 29FT (8.8M)',281.00,10),
('DDCC6-031','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 31FT (9.4M)',289.00,10),
('DDCC6-033','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 33FT (10.0M)',297.00,10),
('DDCC6-035','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 35FT (10.6M)',308.00,10),
('DDCC6-040','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 40FT (12.2M)',345.00,10),
('DDCC6-045','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 45FT (13.7M)',367.00,10),
('DDCC6-050','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 50FT (15.2M)',375.00,10),
('DDCC6-055','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 55FT (16.7M)',399.00,10),
('DDCC6-060','APC Data Distribution Cable, CAT6 UTP CMR 6XRJ-45 Black, 60FT (18.2M)',419.00,10),
('VDIM33174','Overhead 4U Patch Distribution Rack',201.00,10),
('Racks and Accessories » Ethernet Switches','',0.00,10),
('AP9224110','APC 24 Port 10/100 Ethernet Switch',380.00,10),
('Racks and Accessories » Mounting Hardware','',0.00,10),
('AR4000MV-FR','NetShelter CX Mini Fixed Rail Kit',110.00,10),
('AR4000MV12U','NetShelter CX Mini 12U Vertical Mounting Rail Kit',270.00,10),
('AR4601','Net Shelter CX Bolt Down Kit',186.00,10),
('AR7503','NetShelter SX 42U 600mm Wide Recessed Rail Kit',150.00,10),
('AR7504','NetShelter SX 48U 600mm Wide Recessed Rail Kit',159.00,10),
('AR7508','NetShelter SX 42U 750mm Wide Recessed Rail Kit',198.00,10),
('AR7510','NetShelter SX 42U, 23" EIA Mounting Rails for 750-mm Wide Enclosures, Square Holes Qty 4',946.00,10),
('AR7578','NetShelter SX 48U 750mm Wide Recessed Rail Kit',196.00,10),
('AR7600','NetShelter SX 42U/48U Baying Trim Kit Black',35.00,10),
('AR7700','NetShelter SX 600mm/750mm Stabilizer Plate',93.00,10),
('AR7701','NetShelter SX Bolt-Down Kit',85.00,10),
('AR7711','NetShelter Zero U Accessory Mounting Bracket',88.00,10),
('AR8005','10-32 Hardware Kit',52.00,10),
('AR8006A','Equipment Support Rails for 600mm Wide Enclosure',76.00,10),
('AR8100','M6 Hardware for 600mm Wide Enclosures',47.00,10),
('AR8105BLK','Fixed Shelf - 50lbs/23kg, Black',76.00,10),
('AR8112BLK','Bolt-down Bracket Kit, Black',59.00,10),
('AR8122BLK','Fixed Shelf - 250lbs/114kg, Black',125.00,10),
('AR8123BLK','Sliding Shelf - 100lbs/45kg Black',259.00,10),
('AR8125','Shelf, Adjustable 18"-25" 250 lb Black',147.00,10),
('AR8126ABLK','17" Keyboard Drawer Black',297.00,10),
('AR8127BLK','19" Rotating Keyboard Drawer Black',460.00,10),
('AR8128BLK','Sliding Shelf - 200lbs/91kg Black',497.00,10),
('AR8150BLK','Adapter Kit 23" to 19", Black',39.00,10),
('AR8395','20U Copper Busbar Kit for NetShelter AV Enclosures',171.00,10),
('AR8400','12-24 Hardware Kit',23.00,10),
('AR8422','Fixed Shelf - 250lbs',103.00,10),
('AR8652','Spacer Bracket for 4 Post Racks, 6" Wide (Qty 2)',90.00,10),
('Racks and Accessories » NetShelter CX','',0.00,10),
('AR4000MV','NetShelter CX Mini Enclosure',2451.00,10),
('AR4018A','NetShelter CX 18U Secure Soundproofed Server Room in a Box Enclosure',4827.00,10),
('AR4018IA','NetShelter CX 18U Secure Soundproofed Server Room in a Box Enclosure International',4732.00,10),
('AR4018X430','NetShelter CX 18U 750 mm Wide x 1130 mm Deep Enclosure Lt Grey Finish',5116.00,10),
('AR4018X431','NetShelter CX 18U 750 mm Wide x 1130 mm Deep Enclosure Dark Grey Finish',5116.00,10),
('AR4018X432','NetShelter CX 18U 750 mm Wide x 1130 mm Deep Enclosure White Finish',5116.00,10),
('AR4024A','NetShelter CX 24U Secure Soundproofed Server Room in a Box Enclosure',6300.00,10),
('AR4024IA','NetShelter CX 24U Secure Soundproofed Server Room in a Box Enclosure International',6177.00,10),
('AR4024X429','NetShelter CX 24U 750 mm Wide x 1130 mm Deep Enclosure Black Finish',6679.00,10),
('AR4024X430','NetShelter CX 24U 750 mm Wide x 1130 mm Deep Enclosure Lt Grey Finish',6679.00,10),
('AR4024X431','NetShelter CX 24U 750 mm Wide x 1130 mm Deep Enclosure Dark Grey Finish',6679.00,10),
('AR4024X432','NetShelter CX 24U 750 mm Wide x 1130 mm Deep Enclosure White Finish',6679.00,10),
('AR4038A','NetShelter CX 38U Secure Soundproofed Server Room in a Box Enclosure',8352.00,10),
('AR4038IA','NetShelter CX 38U Secure Soundproofed Server Room in a Box Enclosure International',8188.00,10),
('AR4038X429','NetShelter CX 38U 750 mm Wide x 1130 mm Deep Enclosure Black Finish',8854.00,10),
('AR4038X430','NetShelter CX 38U 750 mm Wide x 1130 mm Deep Enclosure Lt Grey Finish',8854.00,10),
('AR4038X431','NetShelter CX 38U 750 mm Wide x 1130 mm Deep Enclosure Dark Grey Finish',8854.00,10),
('AR4038X432','NetShelter CX 38U 750 mm Wide x 1130 mm Deep Enclosure White Finish',8854.00,10),
('Racks and Accessories » NetShelter SX','',0.00,10),
('AR3100','NetShelter SX 42U 600mm Wide x 1070mm Deep Enclosure with Sides Black',1719.00,10),
('AR3100HACS','NetShelter SX 42U 600mm Wide x 1070mm Deep Enclosure without rear doors',1683.00,10),
('AR3100SP1','NetShelter SX 42U 600mm Wide x 1070mm Deep Enclosure with Sides Black -1250 lbs. Shock Packaging',1989.00,10),
('AR3100SP2','NetShelter SX 42U 600mm Wide x 1070mm Deep Enclosure with Sides Black -2000 lbs. Shock Packaging',2756.00,10),
('AR3104','NetShelter SX 24U 600mm x 1070mm Deep Enclosure',1538.00,10),
('AR3105','NetShelter SX 45U 600mm Wide x 1070mm Deep Enclosure with Sides Black',1891.00,10),
('AR3107','NetShelter SX 48U 600mm Wide x 1070mm Deep Enclosure with Sides Black',2045.00,10),
('AR3140','NetShelter SX 42U 750mm Wide x 1070mm Deep Networking Enclosure with Sides',2966.00,10),
('AR3150','NetShelter SX 42U 750mm Wide x 1070mm Deep Enclosure with Sides Black',2118.00,10),
('AR3150HACS','NetShelter SX 42U 750mm Wide x 1070mm Deep Enclosure without rear doors',2080.00,10),
('AR3150SP1','NetShelter SX 42U 750mm Wide x 1070mm Deep Enclosure with Sides Black 1250 lbs. CTO',2858.00,10),
('AR3150SP2','NetShelter SX 42U 750mm Wide x 1070mm Deep Enclosure with Sides Black 2000 lbs. CTO',4866.00,10),
('AR3155','NetShelter SX 45U 750mm Wide x 1070mm Deep Enclosure with Sides Black',2297.00,10),
('AR3157','NetShelter SX 48U 750mm Wide x 1070mm Deep Enclosure with Sides Black',2532.00,10),
('AR3200','NetShelter SX Colocation 2 x 20U 600mm Wide x 1070mm Deep Enclosure with Sides Black',2623.00,10),
('AR3300','NetShelter SX 42U/600mm/1200mm Enclosure with Roof and Sides Black',2351.00,10),
('AR3305','NetShelter SX 45U 600mm Wide x 1200mm Deep Enclosure with Sides Black',2415.00,10),
('AR3307','NetShelter SX 48U/600mm/1200mm Enclosure with Roof and Sides Black',2805.00,10),
('AR3340','NetShelter SX 42U 750mm Wide x 1200mm Deep Networking Enclosure with Sides',3101.00,10),
('AR3347','NetShelter SX 48U 750mm Wide x 1200mm Deep Networking Enclosure with Sides',3446.00,10),
('AR3350','NetShelter SX 42U 750mm Wide x 1200mm Deep Enclosure with Sides Black',2986.00,10),
('AR3355','NetShelter SX 45U 750mm Wide x 1200mm Deep Enclosure with Sides Black',3023.00,10),
('AR3357','NetShelter SX 48U 750mm Wide x 1200mm Deep Enclosure',3274.00,10),
('AR3810','NetShelter AV 42U 600mm Wide x 825 Deep Enclosure with Sides and 10-32 Threaded Rails Black',1756.00,10),
('AR3812','NetShelter AV 42U 600mm Wide x 825mm Deep Enclosure 10-32 Threaded Rails No Sides/Roof/Doors Black',1239.00,10),
('AR3814','NetShelter AV 24U 600mm Wide x 825mm Deep Enclosure with Sides and 10-32 Threaded Rails Black',1584.00,10),
('Racks and Accessories » Open Frame Racks','',0.00,10),
('AR201','NetShelter 2 Post Rack 45U #12-24 Threaded Holes Black',252.00,10),
('AR203A','NetShelter 4 Post Open Frame Rack 44U Square Holes',602.00,10),
('AR204A','NetShelter 4 Post Open Frame Rack 44U #12-24 Threaded Holes',602.00,10),
('Racks and Accessories » Rack Components','',0.00,10),
('AP9513','MEASURE-UPS SWITCH KIT',130.00,10),
('AR7000A','NetShelter SX 42U 600mm Wide Perforated Curved Door Black',370.00,10),
('AR7003','NetShelter SX Colocation 20U 600mm Wide Perforated Curved Door Black',362.00,10),
('AR7005','NetShelter SX 45U 600mm Wide Perforated Curved Door Black',466.00,10),
('AR7007A','NetShelter SX 48U 600mm Wide Perforated Curved Door Black',395.00,10),
('AR702400','NetShelter SV 42U 600mm Wide Perforated Flat Door Black',363.00,10),
('AR702407','NetShelter SV 48U 600mm Wide Perforated Flat Door Black',404.00,10),
('AR702480','NetShelter SV 42U 800mm Wide Perforated Flat Door Black',431.00,10),
('AR702487','NetShelter SV 48U 800mm Wide Perforated Flat Door Black',456.00,10),
('AR7050A','NetShelter SX 42U 750mm Wide Perforated Curved Door Black',395.00,10),
('AR7055','NetShelter SX 45U 750mm Wide Perforated Curved Door Black',517.00,10),
('AR7057A','NetShelter SX 48U 750mm Wide Perforated Curved Door Black',446.00,10),
('AR7100','NetShelter SX 42U 600mm Wide Perforated Split Doors Black',352.00,10),
('AR7103','NetShelter SX Colocation 20U 600mm Wide Perforated Split Doors Black',389.00,10),
('AR7105','NetShelter SX 45U 600mm Wide Perforated Split Doors Black',470.00,10),
('AR7107','NetShelter SX 48U 600mm Wide Perforated Split Doors Black',443.00,10),
('AR712107','NetShelter SV 48U 600mm Wide Perforated Split Rear Doors',448.00,10),
('AR712187','NetShelter SV 48U 800mm Wide Perforated Split Rear Doors',490.00,10),
('AR712400','NetShelter SV 42U 600mm Wide Perforated Split Rear Doors',406.00,10),
('AR712480','NetShelter SV 42U 800mm Wide Perforated Split Rear Doors',472.00,10),
('AR7150','NetShelter SX 42U 750mm Wide Perforated Split Doors Black',438.00,10),
('AR7155','NetShelter SX 45U 750mm Wide Perforated Split Doors Black',608.00,10),
('AR7157','NetShelter SX 48U 750mm Wide Perforated Split Doors Black',515.00,10),
('AR7201','NetShelter SX 600mm Wide x 1070mm Deep Standard Roof Black',142.00,10),
('AR7202','Roof Match Kit for SX to VX, 750mm',360.00,10),
('AR7203','Roof Match Kit for SX to VX, 600mm',308.00,10),
('AR7211','NetShelter SX 600mm Wide x 1200mm Deep Roof',297.00,10),
('AR7212','NetShelter SX 750mm Wide x 1200mm Deep Roof',299.00,10),
('AR722400','NetShelter SV 1060mm Deep 600mm Wide Roof',279.00,10),
('AR722480','NetShelter SV 1060mm Deep 800mm Wide Roof',313.00,10),
('AR722500','NetShelter SV 1200mm Deep 600mm Wide Roof',296.00,10),
('AR722580','NetShelter SV 1200mm Deep 800mm Wide Roof',330.00,10),
('AR7251','NetShelter SX 750mm Wide x 1070mm Deep Standard Roof Black',213.00,10),
('AR7252','NetShelter SX 750mm Wide x 1070mm Deep Networking Roof',352.00,10),
('AR7301','NetShelter SX 42U 1070mm Deep Split Side Panels Black Qty 2',335.00,10),
('AR7303','NetShelter SX 42U 1200mm Deep Split Side Panels Qty. (2)',595.00,10),
('AR7304','NetShelter SX 48U 1200mm Deep Split Side Panels Qty. (2)',630.00,10),
('AR7305A','NetShelter SX 42U 1070 Split Feed Through Side Panels Black Qty 2',455.00,10),
('AR7307','NetShelter SX 45U 1070mm Deep Split Side Panels Black Qty 2',436.00,10),
('AR7308','NetShelter SX 45U 1200mm Deep Split Side Panels Black Qty 2',771.00,10),
('AR7313','NetShelter SX 42U 1200 Split Feed Through Side Panels Black Qty 2',688.00,10),
('AR7314','NetShelter SX 48U 1200 Split Feed Through Side Panels Black Qty 2',722.00,10),
('AR7315','NetShelter SX 45U 1070 Split Feed Through Side Panels Black Qty 2',598.00,10),
('AR7316','NetShelter SX 45U 1200 Split Feed Through Side Panels Black Qty 2',831.00,10),
('AR732400','NetShelter SV 42U 1060mm Deep Side Panels Black',296.00,10),
('AR732407','NetShelter SV 48U 1060mm Deep Side Panels Black',330.00,10),
('AR732500','NetShelter SV 42U 1200mm Deep Side Panels Black',313.00,10),
('AR7371','NetShelter SX 48U 1070mm Deep Split Side Panels Black Qty 2',335.00,10),
('AR7375','NetShelter SX 48U 1070 Split Feed Through Side Panels Black Qty 2',515.00,10),
('AR7714','NetShelter SX Roof Brush Strip',90.00,10),
('AR7716','NetShelter SX 750mm Wide x 1200mm Deep Networking Roof',379.00,10),
('AR7719','NetShelter ValueLine Swivel Caster Kit (Qty = 4)',79.00,10),
('AR8132A','Combination Lock Handles (Qty 2)',243.00,10),
('AR8356','NETSHELTER 13U GLASS DOOR',139.00,10),
('AR8358','NESHELTER 13U REAR DOOR',130.00,10),
('AR8359','NetShelter WX Caster Kit',139.00,10),
('AR8360BLK','42U/47U ROOF 1070MM DEEP BLACK',135.00,10),
('AR8361BLK','42U CURVED FRONT DOOR BLACK',335.00,10),
('AR8362BLK','NetShelter VX-VS 42U Split Rear Doors 600mm wide Black',313.00,10),
('AR8364BLK','42U SIDE PANEL 1070MM DEEP BLACK',237.00,10),
('AR8367BLK','NETSHELTER VX 47U SIDE PANEL BLACK',286.00,10),
('AR8386BLK','25U FRONT DOOR BLACK',211.00,10),
('AR8387BLK','NetShelter VS 25U Split Rear Doors 600mm wide Black',211.00,10),
('AR8391BLK','42U SEISMIC ROOF 1070MM DEEP BLACK',147.00,10),
('AR8392BLK','42U SEISMIC LEFT SIDE PANEL 1070MM DEEP BLACK',282.00,10),
('AR8393BLK','42U SEISMIC RIGHT SIDE PANEL 1070MM DEEP BLACK',282.00,10),
('Racks and Accessories » Specialty Enclosures','',0.00,10),
('AR100','NetShelter WX 13U w/Threaded Hole Vertical Mounting Rail Glass Front Door Black',632.00,10),
('AR100HD','NetShelter WX 13U w/Threaded Hole Vertical Mounting Rail Vented Front Door Black',632.00,10),
('AR2144BLK','NetShelter VX Seismic 42U Enclosure w/sides Black',3148.00,10),
('AR2145BLK','NetShelter VX Seismic 42U Enclosure w/o sides Black',2756.00,10),
('AR3100X609','NetShelter SX 42U 600mm Wide x 1070mm Deep Enclosure Without Sides Black',1521.00,10),
('Security and Environmental » NetBotz 200','',0.00,10),
('NBRK0200','NetBotz Rack Monitor 200',583.00,10),
('NBRK0201','NetBotz Rack Monitor 200 (with 120/240V Power Supply)',718.00,10),
('Security and Environmental » NetBotz 300','',0.00,10),
('NBWL0355','NetBotz Room Monitor 355 (without PoE Injector)',1864.00,10),
('NBWL0356','NetBotz Room Monitor 355 (with 120/240V PoE Injector)',2003.00,10),
('Security and Environmental » NetBotz 400','',0.00,10),
('NBRK0450','NetBotz Rack Monitor 450 (without 120/240V Power Supply)',2298.00,10),
('NBRK0451','NetBotz Rack Monitor 450 (with 120/240V Power Supply)',2434.00,10),
('NBWL0455','NetBotz Room Monitor 455 (without PoE Injector)',2731.00,10),
('NBWL0456','NetBotz Room Monitor 455 (with 120/240V PoE Injector)',2870.00,10),
('Security and Environmental » NetBotz 500','',0.00,10),
('NBBN0510','APC NetBotz Pilot Pack 500 Standard',17743.00,10),
('NBRK0570','NetBotz Rack Monitor 570',3262.00,10),
('NBWL0500','NetBotz 500 Wall Appliance with Camera',1955.00,10),
('NBWL0500N','APC NetBotz 500 Wall Appliance',3194.00,10),
('Security and Environmental » NetBotz Access Control','',0.00,10),
('AP9361','APC Netbotz Rack Access PX - HID',1994.00,10),
('AP9370-10','APC NetBotz HID Proximity Cards - 10 Pack',79.00,10),
('Security and Environmental » NetBotz Accessories and Cables','',0.00,10),
('NBAC0103','APC NetBotz Universal Power Supply',41.00,10),
('NBAC0105','APC NetBotz -48V Power Supply DC to DC',69.00,10),
('NBAC0106L','APC NetBotz Sensor Extender Cable LSZH - 50ft/15m',85.00,10),
('NBAC0106P','APC NetBotz Sensor Extender Cable Plenum- 50ft/15m',96.00,10),
('NBAC0120L','APC NetBotz Sensor Extender Cable LSOH - 25ft/8m',49.00,10),
('NBAC0120P','APC NetBotz Sensor Extender Cable Plenum - 25ft/8m',74.00,10),
('NBAC0122','Dual Power Supply (-5V/3.3V) for NetBotz 500',118.00,10),
('NBAC0205','APC NetBotz Camera Pod 120 Mounting Bracket',86.00,10),
('NBAC0206','APC NetBotz Sensor Pod 120 Mounting Bracket',17.00,10),
('NBAC0208','APC NetBotz 4-Port Cat5 Pod Extender',519.00,10),
('NBAC0209L','APC NetBotz USB Repeater Cable, LSZH - 16ft/5m',74.00,10),
('NBAC0209P','APC NetBotz USB Extender Repeater Cable, Plenum - 16ft/5m',118.00,10),
('NBAC0211L','APC NetBotz USB Cable, LSZH - 16ft/5m',51.00,10),
('NBAC0211P','APC NetBotz USB Cable, Plenum-rated - 16ft/5m',63.00,10),
('NBAC0212','APC NetBotz Fiber Pod Extender - 1640ft/500m',1217.00,10),
('NBAC0213L','NetBotz USB Latching Repeater Cable, LSZH - 5m',81.00,10),
('NBAC0213P','NetBotz USB Latching Repeater Cable, Plenum - 5m',122.00,10),
('NBAC0214L','NetBotz USB Latching Cable, LSZH - 5m',56.00,10),
('NBAC0214P','NetBotz USB Latching Cable, Plenum - 5m',68.00,10),
('NBAC0221','APC NetBotz Pod Mounting Kit',79.00,10),
('NBAC0226','APC NetBotz USB to Serial RS-232 DB-9 Adapter Cable - 6ft/1.8m',79.00,10),
('NBAC0236','NetBotz Small Device Tray',125.00,10),
('NBAC0301','Surface Mounting Brackets for NetBotz Room Monitor Appliance or Camera Pod',106.00,10),
('NBAC0302','Rack Mounting Bracket for NetBotz Camera Pod 160',106.00,10),
('NBAC0303','APC POE Injector',140.00,10),
('NBAS0201','APC NetBotz Extended Storage System (60GB) with Bracket',619.00,10),
('Security and Environmental » NetBotz Rack Access','',0.00,10),
('NBHN0171','APC SX Rack Handle Kit (for NetBotz Rack Access Pod 170)',485.00,10),
('NBPD0170','NetBotz Rack Access Pod 170 (pod only)',1154.00,10),
('NBPD0171','NetBotz Rack Access Pod 170 (for APC SX rack)',1766.00,10),
('NBPD0172','NetBotz Rack Access Pod 170 (for Chatsworth GlobalFrame rack)',1766.00,10),
('Security and Environmental » NetBotz Sensors','',0.00,10),
('AP9324','APC Alarm Beacon',184.00,10),
('AP9335T','APC Temperature Sensor',118.00,10),
('AP9335TH','APC Temperature & Humidity Sensor',183.00,10),
('AP9520T','APC Temperature Sensor with Display',267.00,10),
('AP9520TH','APC Temperature & Humidity Sensor with Display',331.00,10),
('NBAC0109','NetBotz Door Switch for Rooms or 3rd Party Racks, Mini-DIN - 12ft/3.7m',66.00,10),
('NBAC0231','APC NetBotz 0-5V Sensor Cable',64.00,10),
('NBDA1301','APC Netbotz Amp Detector 6-13G (UK, Ireland)',444.00,10),
('NBDA1501','APC Netbotz Amp Detector 1-15 (for NEMA 5-15)',333.00,10),
('NBDA1601','APC Netbotz Amp Detector 6-16C (Cont Europe)',444.00,10),
('NBDA1602','APC Netbotz Amp Detector 6-16M (South Africa)',433.00,10),
('NBDA2001','APC Netbotz Amp Detector 1-20 (for NEMA 5-20)',365.00,10),
('NBDA20L1','APC Netbotz Amp Detector 1-20L (for NEMA L5-20)',395.00,10),
('NBDA20L2','APC Netbotz Amp Detector 6-20L (for NEMA L6-20)',429.00,10),
('NBDA30L1','APC Netbotz Amp Detector 1-30L (for NEMA L5-30)',387.00,10),
('NBDA30L2','APC Netbotz Amp Detector 60-30L (for NEMA L6-30)',429.00,10),
('NBDC0001','APC NetBotz Dry Contact Cable',29.00,10),
('NBDC0002','NetBotz Door Switch for Rooms or 3rd Party Racks, 2.5mm - 50ft/15.2m',57.00,10),
('NBES0201','APC NetBotz Particle Sensor PS100',421.00,10),
('NBES0301','NetBotz Spot Fluid Sensor - 15 ft.',147.00,10),
('NBES0302','NetBotz Door Switch Sensor for Rooms or 3rd Party Racks - 50 ft.',68.00,10),
('NBES0303','NetBotz Door Switch Sensors (2) for an APC Rack - 12 ft.',135.00,10),
('NBES0304','NetBotz Dry Contact Cable - 15 ft.',47.00,10),
('NBES0305','NetBotz 0-5V Cable - 15 ft.',81.00,10),
('NBES0306','NetBotz Vibration Sensor - 12 ft.',135.00,10),
('NBES0307','NetBotz Smoke Sensor - 10 ft.',254.00,10),
('NBES0308','NetBotz Leak Rope Sensor - 20 ft.',401.00,10),
('NBES0309','NetBotz Leak Rope Extension - 20 ft.',309.00,10),
('NBFD0100B','APC NetBotz Fluid Detector FD100',140.00,10),
('NBHS0100','APC NetBotz Humidity Sensor HS10',140.00,10),
('NBPD0122','APC NetBotz Sensor Pod 120',353.00,10),
('NBPD0129','APC NetBotz 4-20mA Sensor Pod',500.00,10),
('NBPD0150','NetBotz Rack Sensor Pod 150',373.00,10),
('NBPD0155','NetBotz Room Sensor Pod 155',439.00,10),
('NBTS0100','APC NetBotz External Temperature Sensor',118.00,10),
('Security and Environmental » Security Cameras','',0.00,10),
('NBAC0218','APC NetBotz Wide-Angle Lens, 4.8mm, Fixed Objective',274.00,10),
('NBPD0121','APC NetBotz Camera Pod 120 with brkt and USB cable - 16ft/5m',651.00,10),
('NBPD0123','APC NetBotz CCTV Adapter Pod 120 with USB cable - 16ft/5m',466.00,10),
('NBPD0160','NetBotz Camera Pod 160',558.00,10),
('Security and Environmental » Software for NetBotz Appliances','',0.00,10),
('NBIP0021HP','APC Integration Pkg/HP OpenView V 6.4 Windows',1908.00,10),
('NBIP0031WU','APC Integration Pkg/Whats up Gold V 7.8',259.00,10),
('NBIP0032WP','APC Integration Pkg/WhatsUp Professional',505.00,10),
('NBWN0005','NetBotz Advanced Software Pack #1',135.00,10),
('NBWN0006','NetBotz Device Monitoring (Five Nodes) Pack',401.00,10),
('Services » Extended Warranties','',0.00,10),
('NBSP0362','APC InfraStruXure Central Enterprise Full-Year Extended Warranty Renewal',2699.00,10),
('WBEXTWAR1YR-SB-10','1 Year Extended Warranty',41.00,10),
('WBEXTWAR1YR-SB-11','1 Year Extended Warranty',63.00,10),
('WBEXTWAR1YR-SB-12','1 Year Extended Warranty',76.00,10),
('WBEXTWAR1YR-SB-13','1 Year Extended Warranty',117.00,10),
('WBEXTWAR1YR-SB-14','1 Year Extended Warranty',224.00,10),
('WBEXTWAR1YR-SB-15','1 Year Extended Warranty',450.00,10),
('WBEXTWAR1YR-SP-01','Service Pack 1 Year Warranty Extension (for new product purchases)',43.00,10),
('WBEXTWAR1YR-SP-02','Service Pack 1 Year Warranty Extension (for new product purchases)',85.00,10),
('WBEXTWAR1YR-SP-03','Service Pack 1 Year Warranty Extension (for new product purchases)',126.00,10),
('WBEXTWAR1YR-SP-04','Service Pack 1 Year Warranty Extension (for new product purchases)',203.00,10),
('WBEXTWAR1YR-SP-05','Service Pack 1 Year Warranty Extension (for new product purchases)',365.00,10),
('WBEXTWAR1YR-SP-06','Service Pack 1 Year Warranty Extension (for new product purchases)',729.00,10),
('WBEXTWAR1YR-SP-07','Service Pack 1 Year Warranty Extension (for new product purchases)',2025.00,10),
('WBEXTWAR1YR-SP-08','Service Pack 1 Year Warranty Extension (for new product purchases)',2552.00,10),
('WBEXTWAR1YR-SY-10','1 Year Extended Warranty',112.00,10),
('WBEXTWAR1YR-SY-11','1 Year Extended Warranty',246.00,10),
('WBEXTWAR1YR-SY-12','1 Year Extended Warranty',338.00,10),
('WBEXTWAR1YR-SY-13','1 Year Extended Warranty',450.00,10),
('WBEXTWAR1YR-SY-14','1 Year Extended Warranty',572.00,10),
('WBEXTWAR1YR-SY-15','1 Year Extended Warranty',744.00,10),
('WBEXTWAR1YR-SY-16','1 Year Extended Warranty',842.00,10),
('WBEXTWAR3YR-SB-10','3 Year Extended Warranty',95.00,10),
('WBEXTWAR3YR-SB-11','3 Year Extended Warranty',163.00,10),
('WBEXTWAR3YR-SB-12','3 Year Extended Warranty',192.00,10),
('WBEXTWAR3YR-SB-13','3 Year Extended Warranty',297.00,10),
('WBEXTWAR3YR-SB-14','3 Year Extended Warranty',618.00,10),
('WBEXTWAR3YR-SB-15','3 Year Extended Warranty',1152.00,10),
('WBEXTWAR3YR-SP-01','Service Pack 3 Year Warranty Extension (for new product purchases)',81.00,10),
('WBEXTWAR3YR-SP-02','Service Pack 3 Year Warranty Extension (for new product purchases)',267.00,10),
('WBEXTWAR3YR-SP-03','Service Pack 3 Year Warranty Extension (for new product purchases)',223.00,10),
('WBEXTWAR3YR-SP-04','Service Pack 3 Year Warranty Extension (for new product purchases)',432.00,10),
('WBEXTWAR3YR-SP-05','Service Pack 3 Year Warranty Extension (for new product purchases)',942.00,10),
('WBEXTWAR3YR-SP-06','Service Pack 3 Year Warranty Extension (for new product purchases)',1883.00,10),
('WBEXTWAR3YR-SP-07','Service Pack 3 Year Warranty Extension (for new product purchases)',3240.00,10),
('WBEXTWAR3YR-SP-08','Service Pack 3 Year Warranty Extension (for new product purchases)',5131.00,10),
('WBEXTWAR3YR-SY-10','3 Year Extended Warranty',269.00,10),
('WBEXTWAR3YR-SY-11','3 Year Extended Warranty',613.00,10),
('WBEXTWAR3YR-SY-12','3 Year Extended Warranty',748.00,10),
('WBEXTWAR3YR-SY-13','3 Year Extended Warranty',1212.00,10),
('WBEXTWAR3YR-SY-14','3 Year Extended Warranty',1449.00,10),
('WBEXTWAR3YR-SY-15','3 Year Extended Warranty',2007.00,10),
('WBEXTWAR3YR-SY-16','3 Year Extended Warranty',2128.00,10),
('WEXT1YR-UF-10','(1) Year Extended Warranty for 5-23 kW Compressor Only',144.00,10),
('WEXT1YR-UF-11','(1) Year Extended Warranty for 24-49 kW Compressor Only',305.00,10),
('WEXT1YR-UF-12','(1) Year Extended Warranty for 50-68 kW Compressor Only',386.00,10),
('WEXT1YR-UF-13','(1) Year Extended Warranty for 69-110 kW Compressor Only',771.00,10),
('WEXT1YR-UF-20','(1) Year Extended Warranty, Parts Only, for CW 5-26 kW',656.00,10),
('WEXT1YR-UF-21','(1) Year Extended Warranty, Parts Only, for CW 27-56 kW',711.00,10),
('WEXT1YR-UF-22','(1) Year Extended Warranty, Parts Only, for CW 57-89 kW',819.00,10),
('WEXT1YR-UF-23','(1) Year Extended Warranty, Parts Only, for CW 90-130 kW',964.00,10),
('WEXT1YR-UF-31','(1) Year Extended Warranty, Parts Only, for DX 5-23 kW',585.00,10),
('WEXT1YR-UF-32','(1) Year Extended Warranty, Parts Only, for DX 24-49 kW',664.00,10),
('WEXT1YR-UF-33','(1) Year Extended Warranty, Parts Only, for DX 50-68 kW',832.00,10),
('WEXT1YR-UF-34','(1) Year Extended Warranty, Parts Only, for DX 69-110 kW',1072.00,10),
('WEXT2YR-UF-10','(2) Year Extended Warranty for 5-23 kW Compressor Only',289.00,10),
('WEXT2YR-UF-11','(2) Year Extended Warranty for 24-49 kW Compressor Only',610.00,10),
('WEXT2YR-UF-12','(2) Year Extended Warranty for 50-68 kW Compressor Only',771.00,10),
('WEXT2YR-UF-13','(2) Year Extended Warranty for 69-110 kW Compressor Only',1540.00,10),
('WEXT2YR-UF-20','(2) Year Extended Warranty, Parts Only, for CW 5-26 kW',1575.00,10),
('WEXT2YR-UF-21','(2) Year Extended Warranty, Parts Only, for CW 27-56 kW',1643.00,10),
('WEXT2YR-UF-22','(2) Year Extended Warranty, Parts Only, for CW 57-89 kW',1860.00,10),
('WEXT2YR-UF-23','(2) Year Extended Warranty, Parts Only, for CW 90-130 kW',2149.00,10),
('WEXT2YR-UF-31','(2) Year Extended Warranty, Parts Only, for DX 5-23 kW',1438.00,10),
('WEXT2YR-UF-32','(2) Year Extended Warranty, Parts Only, for DX 24-49 kW',1635.00,10),
('WEXT2YR-UF-33','(2) Year Extended Warranty, Parts Only, for DX 50-68 kW',2044.00,10),
('WEXT2YR-UF-34','(2) Year Extended Warranty, Parts Only, for DX 69-110 kW',2635.00,10),
('WEXTWAR1YR-AX-01','1 Year Extended Warranty for 3-10 kW Compressors',115.00,10),
('WEXTWAR1YR-AX-02','1 Year Extended Warranty for 14-30 kW Compressors',135.00,10),
('WEXTWAR1YR-AX-03','1 Year Extended Warranty for 31-49 kW Compressors',169.00,10),
('WEXTWAR1YR-AX-04','1 Year Extended Warranty for 50-70 kW Compressors',251.00,10),
('WEXTWAR1YR-AX-05','1 Year Extended Warranty for 90-98 kW Compressors',329.00,10),
('WEXTWAR1YR-AX-10','1-Year Extended Warranty for NetworkAIR ADU',81.00,10),
('WEXTWAR1YR-AX-11','1 Year Extended Warranty for NetworkAIR Air Removal Unit',212.00,10),
('WEXTWAR1YR-SB-10','1 Year Extended Warranty',41.00,10),
('WEXTWAR1YR-SB-11','1 Year Extended Warranty',63.00,10),
('WEXTWAR1YR-SB-12','1 Year Extended Warranty',76.00,10),
('WEXTWAR1YR-SB-13','1 Year Extended Warranty',117.00,10),
('WEXTWAR1YR-SB-14','1 Year Extended Warranty',224.00,10),
('WEXTWAR1YR-SB-15','1 Year Extended Warranty',450.00,10),
('WEXTWAR1YR-SB-16','1 Year Extended Warranty for Smart-UPS RT 15/20kVA',1002.00,10),
('WEXTWAR1YR-SP-01','1 Year Extended Warranty (Renewal or High Volume)',39.00,10),
('WEXTWAR1YR-SP-02','1 Year Extended Warranty (Renewal or High Volume)',57.00,10),
('WEXTWAR1YR-SP-03','1 Year Extended Warranty (Renewal or High Volume)',93.00,10),
('WEXTWAR1YR-SP-04','1 Year Extended Warranty (Renewal or High Volume)',178.00,10),
('WEXTWAR1YR-SP-05','1 Year Extended Warranty (Renewal or High Volume)',348.00,10),
('WEXTWAR1YR-SP-06','1 Year Extended Warranty (Renewal or High Volume)',695.00,10),
('WEXTWAR1YR-SP-07','1 Year Extended Warranty (Renewal or High Volume)',1158.00,10),
('WEXTWAR1YR-SP-08','1 Year Extended Warranty (Renewal or High Volume)',1627.00,10),
('WEXTWAR1YR-SY-10','1 Year Extended Warranty',112.00,10),
('WEXTWAR1YR-SY-11','1 Year Extended Warranty',246.00,10),
('WEXTWAR1YR-SY-12','1 Year Extended Warranty',338.00,10),
('WEXTWAR1YR-SY-13','1 Year Extended Warranty',450.00,10),
('WEXTWAR1YR-SY-14','1 Year Extended Warranty',572.00,10),
('WEXTWAR1YR-SY-15','1 Year Extended Warranty',744.00,10),
('WEXTWAR1YR-SY-16','1 Year Extended Warranty',842.00,10),
('WEXTWAR3YR-SB-10','3 Year Extended Warranty',95.00,10),
('WEXTWAR3YR-SB-11','3 Year Extended Warranty',163.00,10),
('WEXTWAR3YR-SB-12','3 Year Extended Warranty',192.00,10),
('WEXTWAR3YR-SB-13','3 Year Extended Warranty',297.00,10),
('WEXTWAR3YR-SB-14','3 Year Extended Warranty',618.00,10),
('WEXTWAR3YR-SB-15','3 Year Extended Warranty',1152.00,10),
('WEXTWAR3YR-SB-16','3 Year Extended Warranty for Smart-UPS RT 15/20kVA',2304.00,10),
('WEXTWAR3YR-SP-01','3 Year Extended Warranty (Renewal or High Volume)',84.00,10),
('WEXTWAR3YR-SP-02','3 Year Extended Warranty (Renewal or High Volume)',278.00,10),
('WEXTWAR3YR-SP-03','3 Year Extended Warranty (Renewal or High Volume)',234.00,10),
('WEXTWAR3YR-SP-04','3 Year Extended Warranty (Renewal or High Volume)',446.00,10),
('WEXTWAR3YR-SP-05','3 Year Extended Warranty (Renewal or High Volume)',872.00,10),
('WEXTWAR3YR-SP-06','3 Year Extended Warranty (Renewal or High Volume)',1748.00,10),
('WEXTWAR3YR-SP-07','3 Year Extended Warranty (Renewal or High Volume)',2909.00,10),
('WEXTWAR3YR-SP-08','3 Year Extended Warranty (Renewal or High Volume)',4070.00,10),
('WEXTWAR3YR-SY-10','3 Year Extended Warranty',269.00,10),
('WEXTWAR3YR-SY-11','3 Year Extended Warranty',613.00,10),
('WEXTWAR3YR-SY-12','3 Year Extended Warranty',748.00,10),
('WEXTWAR3YR-SY-13','3 Year Extended Warranty',1212.00,10),
('WEXTWAR3YR-SY-14','3 Year Extended Warranty',1449.00,10),
('WEXTWAR3YR-SY-15','3 Year Extended Warranty',2007.00,10),
('WEXTWAR3YR-SY-16','3 Year Extended Warranty',2128.00,10),
('WEXWAR1Y-AC-01','1 Year Warranty Extension for (1) Accessory (Renewal or High Volume)',62.00,10),
('WEXWAR1Y-AC-02','1 Year Warranty Extension for (1) Accessory (Renewal or High Volume)',88.00,10),
('WEXWAR1Y-AC-03','1 Year Warranty Extension for (1) Accessory (Renewal or High Volume)',146.00,10),
('WEXWAR1Y-AC-04','1 Year Warranty Extension for (1) Accessory (Renewal or High Volume)',279.00,10),
('WEXWAR1Y-AC-05','1 Year Warranty Extension for (1) Accessory (Renewal or High Volume)',544.00,10),
('WEXWAR1Y-AC-06','1 Year Warranty Extension for (1) Accessory (Renewal or High Volume)',1083.00,10),
('WEXWAR1Y-AC-07','1 Year Warranty Extension for (1) Accessory (Renewal or High Volume)',1805.00,10),
('WMS1MHW-BASIC','1 Month Extended Hardware Warranty for StruxureWare Data Center Expert Basic',26.00,10),
('WMS1MHW-ENT','1 Month Extended Hardware Warranty for StruxureWare Data Center Expert Enterprise',77.00,10),
('WMS1MHW-STD','1 Month Extended Hardware Warranty for StruxureWare Data Center Expert Standard',43.00,10),
('WMS1YRHW-BASIC','1 Year Extended Hardware Warranty for StruxureWare Data Center Expert Basic',304.00,10),
('WMS1YRHW-ENT','1 Year Extended Hardware Warranty for StruxureWare Data Center Expert Enterprise',910.00,10),
('WMS1YRHW-STD','1 Year Extended Hardware Warranty for StruxureWare Data Center Expert Standard',505.00,10),
('WNBSP0131','APC NetBotz 21-Month Bridge Sftwr & Support Warranty - 3xx/4xx models - Single-Appliance Pack',278.00,10),
('WNBSP0131M','Monthly 420/320 First Year Bridge Software Warranty',18.00,10),
('WNBSP0132','APC NetBotz 21-Month Bridge Sftwr & Support Warranty - 3xx/4xx models - Five-Appliance Pack',1253.00,10),
('WNBSP0133','APC NetBotz 21-Month Bridge Sftwr & Support Warranty - 3xx/4xx models - 20-Appliance Pack',4500.00,10),
('WNBSP0141','APC NetBotz Full-Year Extended Warranty Renewal- 3xx/4xx models - Single-Appliance Pack',240.00,10),
('WNBSP0141M','Monthly 420/320 Full Year Software Warranty',27.00,10),
('WNBSP0142','APC NetBotz Full-Year Extended Warranty Renewal - 3xx/4xx models - Five-Appliance Pack',1088.00,10),
('WNBSP0143','APC NetBotz Full-Year Extended Warranty Renewal- 3xx/4xx models - 20-Appliance Pack',3856.00,10),
('WNBSP0231','APC NetBotz 21-Month Bridge Sftwr & Support Warranty - 500 models - Single-Appliance Pack',375.00,10),
('WNBSP0231M','Monthly 500 First Year Bridge Software Warranty',28.00,10),
('WNBSP0232','APC NetBotz 21-Month Bridge Sftwr & Support Warranty - 500 models - Five-Appliance Pack',1735.00,10),
('WNBSP0233','APC NetBotz 21-Month Bridge Sftwr & Support Warranty - 500 models - 20-Appliance Pack',6546.00,10),
('WNBSP0241','APC NetBotz Full-Year Extended Warranty Renewal- 500 Models - Single-Appliance Pack',327.00,10),
('WNBSP0241M','Monthly 500 Full Year Software Warranty',39.00,10),
('WNBSP0242','APC NetBotz Full-Year Extended Warranty Renewal- 500 Models - Five-Appliance Pack',1504.00,10),
('WNBSP0243','APC NetBotz Full-Year Extended Warranty Renewal- 500 Models - 20-Appliance Pack',5592.00,10),
('WNBSP3141','APC NetBotz Three-Year Extended Warranty - 3xx/4xx Models - Single-Appliance Pack',462.00,10),
('WNBSP3142','APC NetBotz Three-Year Extended Warranty - 3xx/4xx Models - Five-Appliance Pack',2091.00,10),
('WNBSP3143','APC NetBotz Three-Year Extended Warranty - 3xx/4xx Models - 20-Appliance Pack',7521.00,10),
('WNBSP3241','APC NetBotz Three-Year Extended Warranty - 500 Models - Single-Appliance Pack',636.00,10),
('WNBSP3242','APC NetBotz Three-Year Extended Warranty - 500 Models - Five-Appliance Pack',2892.00,10),
('WNBSP3243','APC NetBotz Three-Year Extended Warranty - 500 Models - 20-Appliance Pack',10896.00,10),
('WNBWN001','Base - 2 Year Software Support Contract (NBWL0355/NBWL0455)',193.00,10),
('WNBWN002','Base - 2 Year Software Support Contract (NBRK0450/NBRK0550)',290.00,10),
('WNBWN003','Extension - 1 Year Software Support Contract & 1 Year Hardware Warranty (NBWL0355/NBWL0455)',184.00,10),
('WNBWN004','Extension - 1 Year Software Support Contract & 1 Year Hardware Warranty (NBRK0450/NBRK0550)',281.00,10),
('Services » Network Integration Services','',0.00,10),
('WITSC','WITSC - Server Migration and Cable Management',173.00,10),
('Services » Training Services','',0.00,10),
('WTRAINING','Customer Training Service',2471.00,10),
('StruxureWare for Data Centers » Data Center Operation: Capacity','',0.00,10),
('AP9110','Data Center Operation: Capacity 10 Rack License',4658.00,10),
('AP91100','Data Center Operation: Capacity 100 Rack License',37058.00,10),
('AP911000','Data Center Operation: Capacity 1000 Rack License',211594.00,10),
('AP91200','Data Center Operation: Capacity 200 Rack License',53865.00,10),
('AP912000','Data Center Operation: Capacity 2000 Rack License',407799.00,10),
('AP91500','Data Center Operation: Capacity 500 Rack License',111375.00,10),
('AP915000','Data Center Operation: Capacity 5000 Rack License',961787.00,10),
('SFTWAP9110','Data Center Operation: Capacity; 10 Rack Subscription License',2700.00,10),
('SFTWAP91100','Data Center Operation: Capacity; 100 Rack Subscription License',18900.00,10),
('WCAM1M10','Data Center Operation: Capacity, 1 Month Software Maintenance Contract, 10 Racks',107.00,10),
('WCAM1M100','Data Center Operation: Capacity, 1 Month Software Maintenance Contract, 100 Racks',834.00,10),
('WCAM1M1000','Data Center Operation: Capacity, 1 Month Software Maintenance Contract, 1000 Racks',5301.00,10),
('WCAM1M200','Data Center Operation: Capacity, 1 Month Software Maintenance Contract, 200 Racks',1215.00,10),
('WCAM1M2000','Data Center Operation: Capacity, 1 Month Software Maintenance Contract, 2000 Racks',10217.00,10),
('WCAM1M500','Data Center Operation: Capacity, 1 Month Software Maintenance Contract, 500 Racks',2506.00,10),
('WCAM1M5000','Data Center Operation: Capacity, 1 Month Software Maintenance Contract, 5000 Racks',24098.00,10),
('WCAM1YR10','Data Center Operation: Capacity, 1 Year Software Maintenance Contract, 10 Racks',838.00,10),
('WCAM1YR100','Data Center Operation: Capacity, 1 Year Software Maintenance Contract, 100 Racks',6670.00,10),
('WCAM1YR1000','Data Center Operation: Capacity, 1 Year Software Maintenance Contract, 1000 Racks',38086.00,10),
('WCAM1YR200','Data Center Operation: Capacity, 1 Year Software Maintenance Contract, 200 Racks',9696.00,10),
('WCAM1YR2000','Data Center Operation: Capacity, 1 Year Software Maintenance Contract, 2000 Racks',73404.00,10),
('WCAM1YR500','Data Center Operation: Capacity, 1 Year Software Maintenance Contract, 500 Racks',20048.00,10),
('WCAM1YR5000','Data Center Operation: Capacity, 1 Year Software Maintenance Contract, 5000 Racks',173121.00,10),
('WCAM3YR10','Data Center Operation: Capacity, 3 Year Software Maintenance Contract, 10 Racks',2097.00,10),
('WCAM3YR100','Data Center Operation: Capacity, 3 Year Software Maintenance Contract, 100 Racks',16675.00,10),
('WCAM3YR1000','Data Center Operation: Capacity, 3 Year Software Maintenance Contract, 1000 Racks',95217.00,10),
('WCAM3YR200','Data Center Operation: Capacity, 3 Year Software Maintenance Contract, 200 Racks',24239.00,10),
('WCAM3YR2000','Data Center Operation: Capacity, 3 Year Software Maintenance Contract, 2000 Racks',183510.00,10),
('WCAM3YR500','Data Center Operation: Capacity, 3 Year Software Maintenance Contract, 500 Racks',50119.00,10),
('WCAM3YR5000','Data Center Operation: Capacity, 3 Year Software Maintenance Contract, 5000 Racks',432805.00,10),
('StruxureWare for Data Centers » Data Center Operation: Change','',0.00,10),
('AP9710','Data Center Operation: Change 10 Rack License',4658.00,10),
('AP97100','Data Center Operation: Change 100 Rack License',37058.00,10),
('AP971000','Data Center Operation: Change 1000 Rack License',211594.00,10),
('AP97200','Data Center Operation: Change 200 Rack License',53865.00,10),
('AP972000','Data Center Operation: Change 2000 Rack License',407799.00,10),
('AP97500','Data Center Operation: Change 500 Rack License',111375.00,10),
('AP975000','Data Center Operation: Change 5000 Rack License',961787.00,10),
('SFTWAP9710','Data Center Operation: Change; 10 Rack Subscription License',2700.00,10),
('SFTWAP97100','Data Center Operation: Change; 100 Rack Subscription License',18900.00,10),
('WCHM1M10','Data Center Operation: Change, 1 Month Software Maintenance Contract, 10 Racks',101.00,10),
('WCHM1M100','Data Center Operation: Change, 1 Month Software Maintenance Contract, 100 Racks',833.00,10),
('WCHM1M200','Data Center Operation: Change, 1 Month Software Maintenance Contract, 200 Racks',1170.00,10),
('WCHM1M2000','Data Center Operation: Change, 1 Month Software Maintenance Contract, 2000 Racks',10217.00,10),
('WCHM1M500','Data Center Operation: Change, 1 Month Software Maintenance Contract, 500 Racks',2506.00,10),
('WCHM1M5000','Data Center Operation: Change, 1 Month Software Maintenance Contract, 5000 Racks',24098.00,10),
('WCHM1YR10','Data Center Operation: Change, 1 Year Software Maintenance Contract, 10 Racks',838.00,10),
('WCHM1YR100','Data Center Operation: Change, 1 Year Software Maintenance Contract, 100 Racks',6670.00,10),
('WCHM1YR1000','Data Center Operation: Change, 1 Year Software Maintenance Contract, 1000 Racks',38086.00,10),
('WCHM1YR200','Data Center Operation: Change, 1 Year Software Maintenance Contract, 200 Racks',9696.00,10),
('WCHM1YR2000','Data Center Operation: Change, 1 Year Software Maintenance Contract, 2000 Racks',73404.00,10),
('WCHM1YR500','Data Center Operation: Change, 1 Year Software Maintenance Contract, 500 Racks',20048.00,10),
('WCHM1YR5000','Data Center Operation: Change, 1 Year Software Maintenance Contract, 5000 Racks',173121.00,10),
('WCHM3YR10','Data Center Operation: Change, 3 Year Software Maintenance Contract, 10 Racks',2097.00,10),
('WCHM3YR100','Data Center Operation: Change, 3 Year Software Maintenance Contract, 100 Racks',16675.00,10),
('WCHM3YR1000','Data Center Operation: Change, 3 Year Software Maintenance Contract, 1000 Racks',95217.00,10),
('WCHM3YR200','Data Center Operation: Change, 3 Year Software Maintenance Contract, 200 Racks',24239.00,10),
('WCHM3YR2000','Data Center Operation: Change, 3 Year Software Maintenance Contract, 2000 Racks',183510.00,10),
('WCHM3YR500','Data Center Operation: Change, 3 Year Software Maintenance Contract, 500 Racks',50119.00,10),
('WCHM3YR5000','Data Center Operation: Change, 3 Year Software Maintenance Contract, 5000 Racks',432805.00,10),
('StruxureWare for Data Centers » Data Center Operation: Energy Cost','',0.00,10),
('AP9135','Data Center Operation:Energy Cost License',6338.00,10),
('StruxureWare for Data Centers » Data Center Operation: Energy Efficiency','',0.00,10),
('AP90000','Data Center Operation: Energy Efficiency License',63375.00,10),
('WEE1M','Data Center Operation: Energy Efficiency, 1 Month Software Maintenance Contract',1585.00,10),
('WEE1YR','Data Center Operation: Energy Efficiency, 1 Year Software Maintenance Contract',11408.00,10),
('WEE3YR','Data Center Operation: Energy Efficiency, 3 Year Software Maintenance Contract',28519.00,10),
('WNSCENEFF','Data Center Operation: Energy Efficiency Configuration',18287.00,10),
('StruxureWare for Data Centers » Data Center Operation: IT Optimize','',0.00,10),
('AP916010','Data Center Operation: IT Optimize 10 Rack License',3549.00,10),
('AP9160100','Data Center Operation: IT Optimize 100 Rack License',28037.00,10),
('AP91601000','Data Center Operation: IT Optimize 1000 Rack License',160307.00,10),
('AP9160200','Data Center Operation: IT Optimize 200 Rack License',41168.00,10),
('AP91602000','Data Center Operation: IT Optimize 2000 Rack License',308954.00,10),
('AP9160500','Data Center Operation: IT Optimize 500 Rack License',85176.00,10),
('AP91605000','Data Center Operation: IT Optimize 5000 Rack License',728664.00,10),
('AP916110','Data Center Operation: IT Power Control 10 Rack License',1193.00,10),
('AP9161100','Data Center Operation: IT Power Control 100 Rack License',9498.00,10),
('AP91611000','Data Center Operation: IT Power Control 1000 Rack License',53321.00,10),
('AP9161200','Data Center Operation: IT Power Control 200 Rack License',13779.00,10),
('AP91612000','Data Center Operation: IT Power Control 2000 Rack License',102764.00,10),
('AP9161500','Data Center Operation: IT Power Control 500 Rack License',28444.00,10),
('AP91615000','Data Center Operation: IT Power Control 5000 Rack License',242366.00,10),
('SFTWAP916010','Data Center Operation: IT Optimize 10 Rack Subscription License',2113.00,10),
('SFTWAP9160100','Data Center Operation: IT Optimize 100 Rack Subscription License',14788.00,10),
('WITO1M10','Data Center Operation: IT Optimize, 1 Month Software Maintenance Contract, 10 Racks',90.00,10),
('WITO1M100','Data Center Operation: IT Optimize, 1 Month Software Maintenance Contract, 100 Racks',701.00,10),
('WITO1M1000','Data Center Operation: IT Optimize, 1 Month Software Maintenance Contract, 1000 Racks',4037.00,10),
('WITO1M200','Data Center Operation: IT Optimize, 1 Month Software Maintenance Contract, 200 Racks',1029.00,10),
('WITO1M2000','Data Center Operation: IT Optimize, 1 Month Software Maintenance Contract, 2000 Racks',7779.00,10),
('WITO1M500','Data Center Operation: IT Optimize, 1 Month Software Maintenance Contract, 500 Racks',2129.00,10),
('WITO1M5000','Data Center Operation: IT Optimize, 1 Month Software Maintenance Contract, 5000 Racks',18348.00,10),
('WITO1YR10','Data Center Operation: IT Optimize, 1 Year Software Maintenance Contract, 10 Racks',639.00,10),
('WITO1YR100','Data Center Operation: IT Optimize, 1 Year Software Maintenance Contract, 100 Racks',5046.00,10),
('WITO1YR1000','Data Center Operation: IT Optimize, 1 Year Software Maintenance Contract, 1000 Racks',28855.00,10),
('WITO1YR200','Data Center Operation: IT Optimize, 1 Year Software Maintenance Contract, 200 Racks',7411.00,10),
('WITO1YR2000','Data Center Operation: IT Optimize, 1 Year Software Maintenance Contract, 2000 Racks',55611.00,10),
('WITO1YR500','Data Center Operation: IT Optimize, 1 Year Software Maintenance Contract, 500 Racks',15332.00,10),
('WITO1YR5000','Data Center Operation: IT Optimize, 1 Year Software Maintenance Contract, 5000 Racks',131159.00,10),
('WITO3YR10','Data Center Operation: IT Optimize, 3 Year Software Maintenance Contract, 10 Racks',1597.00,10),
('WITO3YR100','Data Center Operation: IT Optimize, 3 Year Software Maintenance Contract, 100 Racks',12618.00,10),
('WITO3YR1000','Data Center Operation: IT Optimize, 3 Year Software Maintenance Contract, 1000 Racks',72138.00,10),
('WITO3YR200','Data Center Operation: IT Optimize, 3 Year Software Maintenance Contract, 200 Racks',18526.00,10),
('WITO3YR2000','Data Center Operation: IT Optimize, 3 Year Software Maintenance Contract, 2000 Racks',139030.00,10),
('WITO3YR500','Data Center Operation: IT Optimize, 3 Year Software Maintenance Contract, 500 Racks',38329.00,10),
('WITO3YR5000','Data Center Operation: IT Optimize, 3 Year Software Maintenance Contract, 5000 Racks',327899.00,10),
('WITPC1M10','Data Center Operation: IT Power Control, 1 Month Software Maintenance Contract, 10 Racks',30.00,10),
('WITPC1M100','Data Center Operation: IT Power Control, 1 Month Software Maintenance Contract, 100 Racks',237.00,10),
('WITPC1M1000','Data Center Operation: IT Power Control, 1 Month Software Maintenance Contract, 1000 Racks',1354.00,10),
('WITPC1M200','Data Center Operation: IT Power Control, 1 Month Software Maintenance Contract, 200 Racks',345.00,10),
('WITPC1M2000','Data Center Operation: IT Power Control, 1 Month Software Maintenance Contract, 2000 Racks',2608.00,10),
('WITPC1M500','Data Center Operation: IT Power Control, 1 Month Software Maintenance Contract, 500 Racks',711.00,10),
('WITPC1M5000','Data Center Operation: IT Power Control, 1 Month Software Maintenance Contract, 5000 Racks',6152.00,10),
('WITPC1YR10','Data Center Operation: IT Power Control, 1 Year Software Maintenance Contract, 10 Racks',215.00,10),
('WITPC1YR100','Data Center Operation: IT Power Control, 1 Year Software Maintenance Contract, 100 Racks',1710.00,10),
('WITPC1YR1000','Data Center Operation: IT Power Control, 1 Year Software Maintenance Contract, 1000 Racks',9598.00,10),
('WITPC1YR200','Data Center Operation: IT Power Control, 1 Year Software Maintenance Contract, 200 Racks',2481.00,10),
('WITPC1YR2000','Data Center Operation: IT Power Control, 1 Year Software Maintenance Contract, 2000 Racks',18497.00,10),
('WITPC1YR500','Data Center Operation: IT Power Control, 1 Year Software Maintenance Contract, 500 Racks',5121.00,10),
('WITPC1YR5000','Data Center Operation: IT Power Control, 1 Year Software Maintenance Contract, 5000 Racks',43626.00,10),
('WITPC3YR10','Data Center Operation: IT Power Control, 3 Year Software Maintenance Contract, 10 Racks',537.00,10),
('WITPC3YR100','Data Center Operation: IT Power Control, 3 Year Software Maintenance Contract, 100 Racks',4274.00,10),
('WITPC3YR1000','Data Center Operation: IT Power Control, 3 Year Software Maintenance Contract, 1000 Racks',23995.00,10),
('WITPC3YR200','Data Center Operation: IT Power Control, 3 Year Software Maintenance Contract, 200 Racks',6201.00,10),
('WITPC3YR2000','Data Center Operation: IT Power Control, 3 Year Software Maintenance Contract, 2000 Racks',46243.00,10),
('WITPC3YR500','Data Center Operation: IT Power Control, 3 Year Software Maintenance Contract, 500 Racks',12800.00,10),
('WITPC3YR5000','Data Center Operation: IT Power Control, 3 Year Software Maintenance Contract, 5000 Racks',109066.00,10),
('StruxureWare for Data Centers » Data Center Operation: Insight','',0.00,10),
('AP90055','Data Center Operation: Insight License',30178.00,10),
('StruxureWare for Data Centers » Data Center Operation: Mobile','',0.00,10),
('AP9700S','Data Center Operation: Mobile',4739.00,10),
('StruxureWare for Data Centers » Data Center Software Integration Kits','',0.00,10),
('SFSWDCIT','StruxureWare for Data Center Integration Toolkit',4866.00,10),
('StruxureWare for Data Centers » Environmental Management System','',0.00,10),
('AP9320','APC Environmental Management System',1595.00,10),
('StruxureWare for Data Centers » Environmental Monitoring Unit','',0.00,10),
('AP9319X393','EMU Home Depot for IDF Cabinet B',531.00,10),
('AP9319X394','EMU Home Depot for IDF Cabinet C',531.00,10),
('AP9319X395','EMU Home Depot for IDF Cabinet D',531.00,10),
('AP9319X396','EMU Home Depot for IDF Cabinet E',531.00,10),
('AP9319X452','Sun brackets for AP9319',69.00,10),
('AP9340','APC Environmental Manager',664.00,10),
('AP9341','APC Temperature & Humidity Expansion Module',335.00,10),
('StruxureWare for Data Centers » InfraStruxure Manager','',0.00,10),
('AP9420','ISX Manager, 25 Node',2074.00,10),
('AP9435','InfraStruXure Manager Incident Management Module',6033.00,10),
('StruxureWare for Data Centers » Sensors','',0.00,10),
('AP9322','APC Motion Sensor',199.00,10),
('AP9323','APC Smoke Sensor',252.00,10),
('AP9512TBLK','APC Temperature Sensor',118.00,10),
('AP9512THBLK','APC Temperature & Humidity Sensor',183.00,10),
('StruxureWare for Data Centers » Software Configuration','',0.00,10),
('WCONFIGNBQ-NB-20','DC Management Software Configuration',3076.00,10),
('WNSC010104','Data Center Expert Alarm Threshold Configuration',39.00,10),
('WNSC010105','Data Center Expert Alarm Action Configuration',34.00,10),
('WNSC010106','Data Center Expert Alarm Profile Configuration',116.00,10),
('WNSC010107','Data Center Expert Remote Management Configuration',233.00,10),
('WNSC010108','Data Center Expert Network Management Configuration',58.00,10),
('WNSC010109','Data Center Expert Building Management Configuration',465.00,10),
('WNSC010110','Data Center Expert Surveillance Configuration',39.00,10),
('WNSC010111','Data Center Device Identification',4.00,10),
('WNSC010112','Schneider Gateway Configuration Service',349.00,10),
('WNSC010201','Data Center Operation Floor Catalog Creation',39.00,10),
('WNSC010202','Data Center Operation RackMount Catalog Creation',58.00,10),
('WNSC010203','Data Center Operation Floor Layout Creation',8.00,10),
('WNSC010204','Data Center Operation Floor Equipment Identification',8.00,10),
('WNSC010205','Data Center Operation Rack PDU Assessment',8.00,10),
('WNSC010206','Data Center Operation Power Dependency Configuration',12.00,10),
('WNSC010207','Data Center Operation IT Device Assessment',58.00,10),
('WNSC010208','Data Center Operation Device Assignment',4.00,10),
('WNSC010214','Data Center Operation IT Optimize or Power Control Configuration',116.00,10),
('WNSC010215','Data Center Operation PUE DCIE Configuration',931.00,10),
('WNSC010301','Data Center Capacity Policy Configuration',116.00,10),
('WNSC010302','Data Center Capacity Advanced Power Configuration',39.00,10),
('StruxureWare for Data Centers » Software Education','',0.00,10),
('WNSC010401','Data Center Expert Post Configuration Review',931.00,10),
('WNSC010402','Data Center Capacity Post Configuration Review',931.00,10),
('WNSC010403','Data Center Operation Post Configuration Review',931.00,10),
('WNSC010404','Data Center Change Post Configuration Review',931.00,10),
('WNSC010405','Netbotz Post Configuration Review',879.00,10),
('WNSCCAPADM','Data Center Capacity Administrator Training',5022.00,10),
('WNSCISXCADM','Data Center Expert Administrator Training',5022.00,10),
('WNSCISXOADM','Data Center Operation Administrator Training',5022.00,10),
('StruxureWare for Data Centers » Software Installation','',0.00,10),
('WNSC010101','Data Center Management Software Configuration Base Service',3732.00,10),
('WNSC010102','Data Center Expert Basic Administration',698.00,10),
('WNSC010103','Data Center Expert Advanced Administration',465.00,10),
('WNSC010209','Data Center Mobile Installation',116.00,10),
('WNSC010210','Data Center Operation Labeling Service',4.00,10),
('WNSC010212','Data Center Operation Installation',465.00,10),
('WNSC010213','Data Center Operation IT Optimize or IT Power Control Installation',465.00,10),
('WNSC0105','Data Center Follow On Preparation Service',1997.00,10),
('StruxureWare for Data Centers » Software Integration','',0.00,10),
('WSWENG-1D','StruxureWare Operations Custom Software Development Project',84500.00,10),
('StruxureWare for Data Centers » StruxureWare Data Center Expert','',0.00,10),
('AP9452U','SNMP OPC Gateway UL',1773.00,10),
('AP9465','StruxureWare Data Center Expert Basic',4435.00,10),
('AP9470','StruxureWare Data Center Expert Standard',10138.00,10),
('AP9475','StruxureWare Data Center Expert Enterprise',19013.00,10),
('AP9480','StruxureWare Data Center Expert Standard Management Pack',16349.00,10),
('AP9482','StruxureWare Data Center Expert Basic Management Pack',5768.00,10),
('AP9485','StruxureWare Data Center Expert Enterprise Management Pack',29149.00,10),
('AP94VMACT','StruxureWare Data Center Expert Virtual Machine Activation Key - Physical/Paper SKU',6006.00,10),
('AP95100','StruxureWare Data Center Expert, 100 Node License Only',6336.00,10),
('AP951000','StruxureWare Data Center Expert, 1000 Node License Only',44361.00,10),
('AP9525','StruxureWare Data Center Expert, 25 Node License Only',1900.00,10),
('AP95500','StruxureWare Data Center Expert, 500 Node License Only',25348.00,10),
('AP95MODBUS','StruxureWare Data Center Expert Modbus TCP Output Module',6336.00,10),
('NBSV1000','NetBotz Surveillance Base - 15 Nodes',4938.00,10),
('NBSV1005','NetBotz Surveillance Add On Pack - 5 Nodes',1438.00,10),
('NBSV1010','NetBotz Surveillance Add On Pack - 10 Nodes',2456.00,10),
('NBSV1025','NetBotz Surveillance Add On Pack - 25 Nodes',5602.00,10),
('SFHPOMW50','HP Operations Manager for Windows Smart Plug In 5.0',632.00,10),
('TSXETG100','Schneider Modbus Ethernet Gateway',886.00,10),
('TSXETG100POE','Schneider Modbus Ethernet Gateway (with POE Injector)',1021.00,10),
('WMS1M1000N','1 Month 1000 Node StruxureWare Data Center Expert Software Support Contract',666.00,10),
('WMS1M100N','1 Month 100 Node StruxureWare Data Center Expert Software Support Contract',98.00,10),
('WMS1M25N','1 Month 25 Node StruxureWare Data Center Expert Software Support Contract',32.00,10),
('WMS1M500N','1 Month 500 Node StruxureWare Data Center Expert Software Support Contract',382.00,10),
('WMS1MBASIC','1 Month StruxureWare Data Center Expert Basic Software Support Contract',32.00,10),
('WMS1MENT','1 Month StruxureWare Data Center Expert Enterprise Software Support Contract',32.00,10),
('WMS1MOVM','1 Month StruxureWare Data Center Expert Virtual Machine Software Support Contract',36.00,10),
('WMS1MSTD','1 Month StruxureWare Data Center Expert Standard Software Support Contract',32.00,10),
('WMS1YR1000N','1 Year 1000 Node StruxureWare Data Center Expert Software Support Contract',7984.00,10),
('WMS1YR100N','1 Year 100 Node StruxureWare Data Center Expert Software Support Contract',1154.00,10),
('WMS1YR10N','1 Year 10 Node StruxureWare Data Center Expert Software Support Contract',232.00,10),
('WMS1YR25N','1 Year 25 Node StruxureWare Data Center Expert Software Support Contract',379.00,10),
('WMS1YR500N','1 Year 500 Node StruxureWare Data Center Expert Software Support Contract',4561.00,10),
('WMS1YR5N','1 Year 5 Node StruxureWare Data Center Expert Software Support Contract',115.00,10),
('WMS1YRBASIC','1 Year StruxureWare Data Center Expert Basic Software Support Contract',379.00,10),
('WMS1YRENT','1 Year StruxureWare Data Center Expert Enterprise Software Support Contract',379.00,10),
('WMS1YRSTD','1 Year StruxureWare Data Center Expert Standard Software Support Contract',379.00,10),
('WMS1YRVM','1 Year StruxureWare Data Center Expert Virtual Machine Software Support Contract',361.00,10),
('WMS3YR1000N','3 Year 1000 Node StruxureWare Data Center Expert Software Support Contract',19011.00,10),
('WMS3YR100N','3 Year 100 Node StruxureWare Data Center Expert Software Support Contract',2532.00,10),
('WMS3YR10N','3 Year 10 Node StruxureWare Data Center Expert Software Support Contract',551.00,10),
('WMS3YR25N','3 Year 25 Node StruxureWare Data Center Expert Software Support Contract',886.00,10),
('WMS3YR500N','3 Year 500 Node StruxureWare Data Center Expert Software Support Contract',10645.00,10),
('WMS3YR5N','3 Year 5 Node StruxureWare Data Center Expert Software Support Contract',275.00,10),
('WMS3YRBASIC','3 Year StruxureWare Data Center Expert Basic Software Support Contract',886.00,10),
('WMS3YRENT','3 Year StruxureWare Data Center Expert Enterprise Software Support Contract',886.00,10),
('WMS3YRSTD','3 Year StruxureWare Data Center Expert Standard Software Support Contract',886.00,10),
('WMS3YRVM','3 Year StruxureWare Data Center Expert Virtual Machine Software Support Contract',844.00,10),
('StruxureWare for Data Centers » StruxureWare Data Center Operation','',0.00,10),
('AP90010','StruxureWare Data Center Operation, 10 Rack License',2915.00,10),
('AP900100','StruxureWare Data Center Operation, 100 Rack License',23195.00,10),
('AP9001000','StruxureWare Data Center Operation, 1000 Rack License',132786.00,10),
('AP900200','StruxureWare Data Center Operation, 200 Rack License',33716.00,10),
('AP9002000','StruxureWare Data Center Operation, 2000 Rack License',255914.00,10),
('AP900500','StruxureWare Data Center Operation, 500 Rack License',69713.00,10),
('AP9005000','StruxureWare Data Center Operation, 5000 Rack License',603572.00,10),
('AP90065','StruxureWare Data Center Operation: Cluster Node/Disaster Recovery License, 1 Additional Server',12028.00,10),
('AP90110','StruxureWare Data Center Operation for Colo, License (10 Racks / 93 m2 / 1000 SQF)',3644.00,10),
('AP901100','StruxureWare Data Center Operation for Colo, License (100 Racks / 930 m2 / 10000 SQF)',28994.00,10),
('AP9011000','StruxureWare Data Center Operation for Colo, License (1000 Racks / 9300 m2 / 100000 SQF)',165982.00,10),
('AP901200','StruxureWare Data Center Operation for Colo, License (200 Racks / 1860 m2 / 20000 SQF)',42145.00,10),
('AP9012000','StruxureWare Data Center Operation for Colo, License (2000 Racks / 18600 m2 / 200000 SQF)',319893.00,10),
('AP901500','StruxureWare Data Center Operation for Colo, License (500 Racks / 4650 m2 / 50000 SQF)',87141.00,10),
('AP9015000','StruxureWare Data Center Operation for Colo, License (5000 Racks / 46500 m2 / 500000 SQF)',754465.00,10),
('AP9100SP','StruxureWare for Data Centers Mid Market Solution',60357.00,10),
('AP9105SP','Data Center Management Starter Pack',50700.00,10),
('SFTWAP90010','StruxureWare Data Center Operation; 10 Rack Subscription License',1690.00,10),
('SFTWAP900100','StruxureWare Data Center Operation, 100 Rack Subscription License',11830.00,10),
('SFTWAP90065','StruxureWare Data Center Operation; Cluster Node Subscription License; 1 Additional Server',6929.00,10),
('WDCHA1M','StruxureWare Data Center Operation: Cluster Node; 1 Month Software Maintenance Contract; 1 Server',297.00,10),
('WDCHA1YR','StruxureWare Data Center Operation: Cluster Node, 1 Year Software Maintenance Contract, 1 Server',2165.00,10),
('WDCHA3YR','StruxureWare Data Center Operation: Cluster Node, 3 Year Software Maintenance Contract, 1 Server',5394.00,10),
('WDCI1M','Data Center Operation: Insight, 1 Month Software Maintenance Contract',958.00,10),
('WDCI1YR','Data Center Operation: Insight, 1 Year Software Maintenance Contract',5432.00,10),
('WDCI3YR','Data Center Operation: Insight, 3 Year Software Maintenance Contract',13579.00,10),
('WOPC1M10','StruxureWare Data Center Operation for Colo, 1 Month Software Maintenance Contract, 10 Racks',117.00,10),
('WOPC1M100','StruxureWare Data Center Operation for Colo, 1 Month Software Maintenance Contract, 100 Racks',652.00,10),
('WOPC1M1000','StruxureWare Data Center Operation for Colo, 1 Month Software Maintenance Contract, 1000 Racks',4147.00,10),
('WOPC1M200','StruxureWare Data Center Operation for Colo, 1 Month Software Maintenance Contract, 200 Racks',948.00,10),
('WOPC1M2000','StruxureWare Data Center Operation for Colo, 1 Month Software Maintenance Contract, 2000 Racks',7994.00,10),
('WOPC1M500','StruxureWare Data Center Operation for Colo, 1 Month Software Maintenance Contract, 500 Racks',1960.00,10),
('WOPC1M5000','StruxureWare Data Center Operation for Colo, 1 Month Software Maintenance Contract, 5000 Racks',18854.00,10),
('WOPC1YR10','StruxureWare Data Center Operation for Colo, 1 Year Software Maintenance Contract, 10 Racks',656.00,10),
('WOPC1YR100','StruxureWare Data Center Operation for Colo, 1 Year Software Maintenance Contract, 100 Racks',5220.00,10),
('WOPC1YR1000','StruxureWare Data Center Operation for Colo, 1 Year Software Maintenance Contract, 1000 Racks',29878.00,10),
('WOPC1YR200','StruxureWare Data Center Operation for Colo, 1 Year Software Maintenance Contract, 200 Racks',7586.00,10),
('WOPC1YR2000','StruxureWare Data Center Operation for Colo, 1 Year Software Maintenance Contract, 2000 Racks',57580.00,10),
('WOPC1YR500','StruxureWare Data Center Operation for Colo, 1 Year Software Maintenance Contract, 500 Racks',15685.00,10),
('WOPC1YR5000','StruxureWare Data Center Operation for Colo, 1 Year Software Maintenance Contract, 5000 Racks',135805.00,10),
('WOPC3YR10','StruxureWare Data Center Operation for Colo, 3 Year Software Maintenance Contract, 10 Racks',1639.00,10),
('WOPC3YR100','StruxureWare Data Center Operation for Colo, 3 Year Software Maintenance Contract, 100 Racks',13047.00,10),
('WOPC3YR1000','StruxureWare Data Center Operation for Colo, 3 Year Software Maintenance Contract, 1000 Racks',74691.00,10),
('WOPC3YR200','StruxureWare Data Center Operation for Colo, 3 Year Software Maintenance Contract, 200 Racks',18967.00,10),
('WOPC3YR2000','StruxureWare Data Center Operation for Colo, 3 Year Software Maintenance Contract, 2000 Racks',143953.00,10),
('WOPC3YR500','StruxureWare Data Center Operation for Colo, 3 Year Software Maintenance Contract, 500 Racks',39215.00,10),
('WOPC3YR5000','StruxureWare Data Center Operation for Colo, 3 Year Software Maintenance Contract, 5000 Racks',339509.00,10),
('WOPS1M10','StruxureWare Data Center Operation, 1 Month Software Maintenance Contract, 10 Racks',93.00,10),
('WOPS1M100','StruxureWare Data Center Operation, 1 Month Software Maintenance Contract, 100 Racks',522.00,10),
('WOPS1M1000','StruxureWare Data Center Operation, 1 Month Software Maintenance Contract, 1000 Racks',3317.00,10),
('WOPS1M200','StruxureWare Data Center Operation, 1 Month Software Maintenance Contract, 200 Racks',759.00,10),
('WOPS1M2000','StruxureWare Data Center Operation, 1 Month Software Maintenance Contract, 2000 Racks',6395.00,10),
('WOPS1M500','StruxureWare Data Center Operation, 1 Month Software Maintenance Contract, 500 Racks',1568.00,10),
('WOPS1M5000','StruxureWare Data Center Operation, 1 Month Software Maintenance Contract, 5000 Racks',15083.00,10),
('WOPS1YR10','StruxureWare Data Center Operation, 1 Year Software Maintenance Contract, 10 Racks',524.00,10),
('WOPS1YR100','StruxureWare Data Center Operation, 1 Year Software Maintenance Contract, 100 Racks',4176.00,10),
('WOPS1YR1000','StruxureWare Data Center Operation, 1 Year Software Maintenance Contract, 1000 Racks',23902.00,10),
('WOPS1YR200','StruxureWare Data Center Operation, 1 Year Software Maintenance Contract, 200 Racks',6069.00,10),
('WOPS1YR2000','StruxureWare Data Center Operation, 1 Year Software Maintenance Contract, 2000 Racks',46064.00,10),
('WOPS1YR500','StruxureWare Data Center Operation, 1 Year Software Maintenance Contract, 500 Racks',12548.00,10),
('WOPS1YR5000','StruxureWare Data Center Operation, 1 Year Software Maintenance Contract, 5000 Racks',108643.00,10),
('WOPS3YR10','StruxureWare Data Center Operation, 3 Year Software Maintenance Contract, 10 Racks',1311.00,10),
('WOPS3YR100','StruxureWare Data Center Operation, 3 Year Software Maintenance Contract, 100 Racks',10437.00,10),
('WOPS3YR1000','StruxureWare Data Center Operation, 3 Year Software Maintenance Contract, 1000 Racks',59753.00,10),
('WOPS3YR200','StruxureWare Data Center Operation, 3 Year Software Maintenance Contract, 200 Racks',15173.00,10),
('WOPS3YR2000','StruxureWare Data Center Operation, 3 Year Software Maintenance Contract, 2000 Racks',115162.00,10),
('WOPS3YR500','StruxureWare Data Center Operation, 3 Year Software Maintenance Contract, 500 Racks',31371.00,10),
('WOPS3YR5000','StruxureWare Data Center Operation, 3 Year Software Maintenance Contract, 5000 Racks',271607.00,10),
('Surge Protection and Power Conditioning » SurgeArrest Performance','',0.00,10),
('NET8','SURGE 8 OUTLET NET',33.00,10),
('NET9RMBLK','APC Black Rackmount SurgeArrest 9 Outlet 120V',112.00,10),
('P11GTV','APC Power-Saving Performance SurgeArrest, 11 Outlets with Phone and Video Protection, 120V',45.00,10),
('P11VNT3','APC Performance SurgeArrest 11 Outlet with Phone (Splitter), Coax and Ethernet Protection, 120V',44.00,10),
('P11VT3','APC Performance SurgeArrest 11 Outlet with Phone (Splitter) and Coax Protection, 120V',33.00,10),
('PF8VNT3-FR','APC Performance SurgeArrest 8 outlets with Phone, Coax & Network Protection 230V France',57.00,10),
('PF8VNT3-GR','APC Performance SurgeArrest 8 outlets with Phone, Coax & Network Protection 230V Germany',57.00,10),
('PF8VNT3-IT','APC Performance SurgeArrest 8 outlets with Phone, Coax & Network Protection 230V Italy',57.00,10),
('PF8VNT3-RS','APC Performance SurgeArrest 8 outlets with Phone, Coax & Network Protection 230V Russia',57.00,10),
('PF8VNT3-SP','APC Performance SurgeArrest 8 outlets with Phone, Coax & Network Protection 230V Spain',57.00,10),
('PF8VNT3-UK','APC Performance SurgeArrest 8 outlets with Phone, Coax & Network Protection 230V UK',64.00,10),
('UPS » Additional Management Cards and Options','',0.00,10),
('AP9207','APC SHARE-UPS (ACCESSORY)',419.00,10),
('AP9505I','POWER SUPPLY UNIV 24VDC OUTPUT',132.00,10),
('AP9600','SMARTSLOT EXPANSION CHASSIS',113.00,10),
('AP9604BLK','APC SmartSlot Triple Chassis Black',338.00,10),
('AP9604S','SILCON TRIPLE CHASSIS PROTOCOL CONVERTER',380.00,10),
('AP9607CB','Interface Expander with 2 UPS Communication Cables SmartSlot Card',270.00,10),
('AP9613','Dry Contact I/O SmartSlot Card',270.00,10),
('AP9620','Legacy Communications SmartSlot Card',63.00,10),
('AP9622','Modbus/Jbus Interface Card',401.00,10),
('AP9830','UPS REMOTE POWER-OFF DEVICE',237.00,10),
('UPS » Symmetra','',0.00,10),
('SYA12K16IXR','APC Symmetra LX 12kVA scalable to 16kVA N+1 Ext. Run Tower, 220/230/240V or 380/400/415V',17432.00,10),
('SYA12K16P','APC Symmetra LX 12kVA scalable to 16kVA N+1 Tower',12434.00,10),
('SYA12K16PXR','APC Symmetra LX 12kVA Scalable to 16kVA N+1 Ext. Run Tower, 208/240V',17584.00,10),
('SYA12K16RMP','APC Symmetra LX 12kVA Scalable to 16kVA N+1 Rack-mount, 208/240V',12723.00,10),
('SYA16K16P','APC Symmetra LX 16kVA Scalable to 16kVA N+1 Tower, 208/240V',14901.00,10),
('SYA16K16PXR','APC Symmetra LX 16kVA Scalable to 16kVA N+1 Ext. Run Tower, 208/240V',19675.00,10),
('SYA16K16RMP','APC Symmetra LX 16kVA Scalable to 16kVA N+1 Rack-mount, 208/240V',15118.00,10),
('SYA4K8P','APC Symmetra LX 4kVA scalable to 8kVA N+1 Tower, 208/240V',7499.00,10),
('SYA4K8RMP','APC Symmetra LX 4kVA scalable to 8kVA N+1 Rack-mount, 208/240V',8171.00,10),
('SYA8K16P','APC Symmetra LX 8kVA Scalable to 16kVA N+1, Tower 208/240V',9675.00,10),
('SYA8K16PXR','APC Symmetra LX 8kVA Scalable to 16kVA N+1 Ext. Run Tower, 208/240V',15659.00,10),
('SYA8K16RMP','APC Symmetra LX 8kVA Scalable to 16kVA N+1 Rack-mount, 208/240V',10328.00,10),
('SYA8K8P','APC Symmetra LX 8kVA Scalable to 8kVA N+1 Tower, 208/240V',9675.00,10),
('SYA8K8RMP','APC Symmetra LX 8kVA Scalable to 8kVA N+1 Rack-mount, 208/240V',10328.00,10),
('SYAF16KBXRMT','APC Symmetra LX 16kVA N+1 Rack-mount Frame, 208/240V; no mounting rails, no outlets',4344.00,10),
('SYAF16KRMT','APC Symmetra LX 16kVA N+1 Rack-mount Frame, 208/240V',5586.00,10),
('SYAF16KT','APC Symmetra LX 16kVA N+1 Tower Frame, 208/240V',4912.00,10),
('SYAF16KXR9T','APC Symmetra LX 16kVA N+1 Extended Run Tower Frame, 208V',6978.00,10),
('SYAF8KRMT','APC SYMMETRA LX 8KVA N+1 Rack-Mount FRAME, 208/240V',5645.00,10),
('SYAF8KT','APC SYMMETRA LX 8KVA N+1 TOWER FRAME, 208/240V',4973.00,10),
('SYAFSU10L','APC Symmetra LX 19U left side panel',224.00,10),
('SYAFSU10R','APC Symmetra LX 19U right side panel',213.00,10),
('SYAFSU12R','APC Symmetra LX 32U right side panel',334.00,10),
('SYAFSU13','APC Symmetra LX frame electronics module- 200/208V',3280.00,10),
('SYAFSU14','APC Symmetra LX Input/Output wiring tray-200/208V',568.00,10),
('SYAFSU15','APC Symmetra LX Communications Card',128.00,10),
('SYAFSU2','APC Symmetra LX 13U replacement door',296.00,10),
('SYAFSU5','APC Symmetra LX 32U replacement door',357.00,10),
('SYAFSU6','APC Symmetra LX Castor Kit - Single Castor Left Front or Right Rear',136.00,10),
('SYAFSU7','APC Symmetra LX Castor Kit - Single Castor Right Front or Left Rear',136.00,10),
('SYAFSU8','APC Symmetra LX top panel',222.00,10),
('SYAFSU9L','APC Symmetra LX 13U left side panel',165.00,10),
('SYAFSU9R','APC Symmetra LX 13U right side panel',165.00,10),
('SYH2K6RMT','APC Symmetra RM 2kVA Scalable to 6kVA N+1 208/240V',3094.00,10),
('SYH2K6RMT-P1','APC Symmetra RM 2kVA Scalable to 6kVA N+1 208/240V w/208 to 120V Step-Down Transformer',3810.00,10),
('SYH2K6RMT-TF3','APC Symmetra RM 2kVA Scalable to 6kVA N+1 208/240V w/ 208 to 120V Step-Down Transformer (4) L5-20R',3808.00,10),
('SYH4K6RMT','APC Symmetra RM 4kVA Scalable to 6kVA N+1 208/240V',5171.00,10),
('SYH4K6RMT-P1','APC Symmetra RM 4kVA Scalable to 6kVA N+1 208/240V w/208 to 120V Step-Down Transformer',5886.00,10),
('SYH4K6RMT-TF3','APC Symmetra RM 4kVA Scalable to 6kVA N+1 208/240V w/ 208 to 120V Step-Down Transformer (4) L5-20R',5886.00,10),
('SYH6K6RMT','APC Symmetra RM 6kVA Scalable to 6kVA N+1 208/240V',7248.00,10),
('SYH6K6RMT-P1','APC Symmetra RM 6kVA Scalable to 6kVA N+1 208/240V w/208 to 120V Step-Down Transformer',7962.00,10),
('SYH6K6RMT-TF3','APC Symmetra RM 6kVA Scalable to 6kVA N+1 208/240V w/ 208 to 120V Step-Down Transformer (4) L5-20R',7962.00,10),
('SYHF6KT','APC Symmetra RM 6kVA N+1 Frame 208/240V',1018.00,10),
('UPS » Symmetra Accessories','',0.00,10),
('EPW9','Emergency Power Off (EPO)',723.00,10),
('SYAFSU1','APC Symmetra LX 5U replacement door',178.00,10),
('SYAFSU12L','APC Symmetra LX 32U left side panel',334.00,10),
('SYAFSU3','APC Symmetra LX 19U replacement door',299.00,10),
('SYAOPT1','APC Symmetra LX 4-post rack-mounting rails',219.00,10),
('SYAOPT2','APC Symmetra LX module CTO kit- UPS Frame',202.00,10),
('SYAOPT2XR3','APC Symmetra LX module CTO kit- XR3 Frame',53.00,10),
('SYAOPT2XR9','APC Symmetra LX module CTO kit- XR Frame',181.00,10),
('SYAOPT4','APC SYMMETRA LX BASIC BATTERY CABINET CABLE',240.00,10),
('SYAOPT5','APC Symmetra LX 15-foot battery cabinet cable- 200/208V',552.00,10),
('SYAOPT5I','APC SYMMETRA LX 4.5 METER BATTERY CABINET CABLE- 230V',566.00,10),
('SYAPD1','APC Symmetra LX power distribution panel; (1) L14-30, (2) L5-20',251.00,10),
('SYMIM2','APC Symmetra Main Intelligence Module 2',994.00,10),
('SYMIM3','APC Symmetra RM Main Intelligence Module',914.00,10),
('SYMIM4','Symmetra PX Intelligence Module',1834.00,10),
('SYMIM5','APC Symmetra LX Intelligence Module',1083.00,10),
('SYOPT1','APC Symmetra RM 2-6kVA N+1 Floor Mount Kit w/Casters',502.00,10),
('SYOPT12','APC Symmetra LX/Symmetra RM Two Post Rail Kit',158.00,10),
('SYOPT4','APC Symmetra RM 4ft Extender cable for 208/240V RM Battery Cabinet',246.00,10),
('SYOPT4I','APC Symmetra RM 4ft Extender Cable for 220-240V RM Battery Cabinet',234.00,10),
('SYPD10','Symmetra RM 230V backplate kit w/(2) IEC320 C19 and (1) IEC 60309',400.00,10),
('SYPD11','APC Symmetra RM and LX 208/240V Backplate Kit w/(2) L6-30R',251.00,10),
('SYPD3','APC Symmetra RM and LX 208/240V Backplate Kit w/(2) L6-20R & (1) L6-30R',251.00,10),
('SYPD4','APC Symmetra RM 220-240V Backplate Kit w/(8) IEC320 C13 & (2) IEC320 C19',251.00,10),
('SYPD6','APC Symmetra RM 2-6kVA 208/240V Hardwire Kit',238.00,10),
('SYPD7','APC Symmetra RM and LX 208V/240V Backplate kit with (3) L6-20R',251.00,10),
('SYPD8','SY RM PDU 4XC19',238.00,10),
('SYPD9','APC Symmetra RM 2-6kVA 230V Hardwire Kit',251.00,10),
('SYRIM2','APC Symmetra 4-16kVA Redundant Intelligence Module',827.00,10),
('SYRIM3','APC Symmetra RM 2-6kVA and 8-12kVA Redundant Intelligence Module',443.00,10),
('SYSW40KF','SYMMETRA PX STATIC SWITCH MODULE, 208V',1910.00,10),
('UPS » Symmetra Battery Systems','',0.00,10),
('SLB40XRL','PSX 40 KVA XR LINE-UP & MATCH BATTERY CABINET',16875.00,10),
('SYAFSU16','APC Symmetra LX XR Communication Card',547.00,10),
('SYARMXR3B3','APC Symmetra LX Extended Run Rack-mount w/ 3 SYBT5, 208V',2408.00,10),
('SYARMXR9B9','APC Symmetra LX Extended Run Rack-mount w/ 9 SYBT5, 208V',6339.00,10),
('SYARMXR9B9I','APC Symmetra LX Extended Run Rack-mount w/ 9 SYBT5, 230V',6155.00,10),
('SYAXR9B9','APC SYMMETRA LX EXTENDED RUN TOWER W/9 SYBT5 , 208V',6339.00,10),
('SYBATT','APC Symmetra 4-16kVA Battery Module',603.00,10),
('SYBBE','APC SYMMETRA PX 250/500kW BATTERY BREAKER ENCLOSURE.',13301.00,10),
('SYBBE250K500D','APC Symmetra PX 250kW Battery Breaker Enclosure with Fuse Kit for Third Party Batteries',14170.00,10),
('SYBBE500K500D','APC Symmetra PX 500kW Battery Breaker Enclosure with Fuse Kit for Third Party Batteries',14248.00,10),
('SYBFXR3RM','APC SYMMETRA 3 Battery RACKMOUNT XR FRAME (208/120V REGIONS)',853.00,10),
('SYBFXR8-8','APC Symmetra PX 250/500kW Battery Enclosure with 8 Battery Modules & Start Up',38818.00,10),
('SYBFXR9','APC SYMMETRA LX 9 BATTERY TOWER XR FRAME, 208V',1674.00,10),
('SYBFXR9RM','APC SYMMETRA LX 9 BATTERY Rack-Mount XR FRAME, 208V',1714.00,10),
('SYBSC','APC Symmetra PX 250/500 Battery Sidecar for remote battery solution without fuse',5427.00,10),
('SYBSC500K500','APC Symmetra PX250/500kW Battery Enclosure Sidecar for Remote Battery Solution with 1000A Fuse Kit',6125.00,10),
('SYBT2','APC Symmetra RM 2-6kVA Battery Module',448.00,10),
('SYBT2FR','APC Symmetra RM 2-6kVA Battery Module Flame Retardant',722.00,10),
('SYBT3','APC Symmetra RM 8-12kVA Battery Module',568.00,10),
('SYBT4','Battery Module for Symmetra PX, Smart-UPS VT or Galaxy 3500',1867.00,10),
('SYBT5','APC Symmetra LX Battery Module',518.00,10),
('SYBT5FR','APC SYMMETRA LX FLAME RETARDANT BATTERY MODULE',651.00,10),
('SYBT9-B4','APC High-Performance Battery Module for 400V Symmetra PX 48/96/160KW & 208V Symmetra PX 100KW',2334.00,10),
('SYBT9-B6','APC High Performance Battery Module for the Symmetra PX 250/500kW',3496.00,10),
('SYBTU1-PLP','Symmetra PX Battery Unit',461.00,10),
('SYBTU2-PLP','APC Symmetra PX 9Ah Battery Unit, High Performance',582.00,10),
('SYCF8BF','SYMMETRA PX 80kW BATTERY FRAME',6930.00,10),
('SYCF8BF-8','Symmetra PX80KW Battery Frame with 8 Battery Modules and Startup',19381.00,10),
('SYCF8BFS','Symmetra PX 80KW Battery Frame with Startup',7485.00,10),
('SYCFXR48','APC Symmetra PX48 Battery Frame for 9 Battery Modules',7475.00,10),
('SYCFXR48-9','APC Symmetra PX48 Battery Frame with 9 Battery modules & Startup',28478.00,10),
('SYCFXR48-S','APC Symmetra PX48 Battery Frame for 9 Battery modules with Startup',9474.00,10),
('SYCFXR8','SYMMETRA PX 40kW EXTENDED RUN BATTERY FRAME',7891.00,10),
('SYCFXR8-8','Symmetra PX 40KW Extended Run Battery Frame with 8 Battery Modules & Startup',20400.00,10),
('SYCFXR8S','Symmetra PX40KW Extended Run Battery Frame with Startup',8691.00,10),
('SYCFXR9','APC Symmetra PX Battery Frame for 400V PX 96/160kW & 208V PX 100kW for 9 Battery Modules',8907.00,10),
('SYCFXR9-9','APC Symmetra PX Battery Frame for 400V PX 96/160kW & 208V PX 100kW with 9 Battery Modules & Startup',29882.00,10),
('SYCFXR9-S','APC Symmetra PX Battery Frame for 400V PX 96/160kW & 208V PX 100kW for 9 Battery Modules & Startup',10906.00,10),
('SYRMXR2B4','APC Symmetra RM XR Frame w/2 SYBT2 Scalable to 4 208/240V',2477.00,10),
('SYRMXR2B4I','APC Symmetra RM XR Frame w/2 SYBT2 Scalable to 4 220-240V',2602.00,10),
('SYRMXR4B4','APC Symmetra RM XR Frame w/4 SYBT2 208/240V',3498.00,10),
('SYRMXR4B4I','APC Symmetra RM XR Frame w/4 SYBT2, 220-240V',3498.00,10),
('UPS » Symmetra PX','',0.00,10),
('0G-SY20KF','GENERIC ASSY SYM 20KVA 3PH 208V W/DIST',17605.00,10),
('0G-SY20KH','GENERIC ASSY SYM 20KVA 3PH 400V W/DIST',16091.00,10),
('ISX20K20F','Symmetra PX 20kW, 208V',33530.00,10),
('SY100K100F','APC Symmetra PX 100kW Scalable to 100kW, 208V with Startup',83600.00,10),
('SY100K250D','APC Symmetra PX 100KW Scalable to 250KW Without Maintenance Bypass or Distribution-Parallel Capable',92795.00,10),
('SY100K250DL-PD','APC Symmetra PX 100kW Scalable to 250kW with Maintenance Bypass Left & Distribution',106437.00,10),
('SY100K250DR-PD','APC Symmetra PX 100kW Scalable to 250kW with Right Mounted Maintenance Bypass and Distribution',106437.00,10),
('SY10K100F','APC Symmetra PX 10kW Scalable to 100kW, 208V with Startup',32187.00,10),
('SY10K40F','Symmetra PX 10kW Scalable to 40kW N+1, 208V',23043.00,10),
('SY125K250D','APC Symmetra PX 125KW Scalable to 250KW Without Maintenance Bypass or Distribution-Parallel Capable',105166.00,10),
('SY125K250D-NB','APC Symmetra PX 125kW Scalable to 250kW w/o Bypass, Distribution or Batteries-Parallel Capable',66349.00,10),
('SY125K250DL-PD','APC Symmetra PX 125kW Scalable to 250kW with Left Mounted Maintenance Bypass and Distribution',118808.00,10),
('SY125K250DL-PDNB','APC Symmetra PX 125kW Scalable to 250kW with Maintenance Bypass Left, Distribution & No Batteries',79990.00,10),
('SY125K250DR-PD','APC Symmetra PX 125kW Scalable to 250kW with Right Mounted Maintenance Bypass and Distribution',118808.00,10),
('SY125K250DR-PDNB','APC Symmetra PX 125kW Scalable to 250kW with Maintenance Bypass and Distribution, No Batteries',79990.00,10),
('SY125K500D','APC Symmetra PX 125kW Scalable to 500kW without Maintenance Bypass & Distribution-Parallel Capable',111118.00,10),
('SY125K500D-NB','APC Symmetra PX 125kW Scalable to 500kW without Bypass, Distribution or Batteries-Parallel Capable',72301.00,10),
('SY125K500DL-PD','APC Symmetra PX 125kW Scalable to 500kW with Maintenance Bypass Left & Distribution',124760.00,10),
('SY125K500DL-PDNB','APC Symmetra PX 125kW Scalable to 500kW with Maintenance Bypass Left, Distribution & No Batteries',85942.00,10),
('SY125K500DR-PD','APC Symmetra PX 125kW Scalable to 500kW with Right Mounted Maintenance Bypass and Distribution',124760.00,10),
('SY125K500DR-PDNB','APC Symmetra PX 125kW Scalable to 500kW with Maintenance Bypass and Distribution, No Batteries',85942.00,10),
('SY128K160H','APC Symmetra PX 128kW Scalable to 160kW, 400V',98523.00,10),
('SY128K160H-PD','APC Symmetra PX 128kW Scalable to 160kW, 400V w/ Integrated Modular Distribution',116125.00,10),
('SY150K250D','APC Symmetra PX 150kW Scalable to 250kW without Maintenance Bypass or Distribution-Parallel Capable',131459.00,10),
('SY150K250DL-PD','APC Symmetra PX 150kW Scalable to 250kW with Maintenance Bypass Left & Distribution',145101.00,10),
('SY150K250DR-PD','APC Symmetra PX 150kW Scalable to 250kW with Right Mounted Maintenance Bypass and Distribution',145101.00,10),
('SY160K160H','APC Symmetra PX 160kW, 400V',116731.00,10),
('SY160K160H-PD','APC Symmetra PX 160kW 400V w/ Integrated Modular Distribution',134330.00,10),
('SY16K48H-PD','APC Symmetra PX 16kW All-In-One, Scalable to 48kW, 400V',39555.00,10),
('SY200K250D','APC Symmetra PX 200kW Scalable to 250kW without Maintenance Bypass or Distribution-Parallel Capable',159270.00,10),
('SY200K250DL-PD','APC Symmetra PX 200kW Scalable to 250kW with Maintenance Bypass Left & Distribution',172912.00,10),
('SY200K250DR-PD','APC Symmetra PX 200kW Scalable to 250kW with Right Mounted Maintenance Bypass and Distribution',172912.00,10),
('SY20K100F','APC Symmetra PX 20kW Scalable to 100kW, 208V with Startup',38102.00,10),
('SY20K40F','Symmetra PX 20kW Scalable to 40kW N+1, 208V',29414.00,10),
('SY250K500D','APC Symmetra PX 250kW Scalable to 500kW without Maintenance Bypass or Distribution-Parallel Capable',193438.00,10),
('SY250K500DL-PD','APC Symmetra PX 250kW Scalable to 500kW with Left Mounted Maintenance Bypass and Distribution',207080.00,10),
('SY250K500DR-PD','APC Symmetra PX 250kW Scalable to 500kW w/ right mounted MBwD',207080.00,10),
('SY300K500D','APC Symmetra PX 300kW Scalable to 500kW without Maintenance Bypass or Distribution-Parallel Capable',236875.00,10),
('SY300K500DL-PD','APC Symmetra PX 300kW Scalable to 500kW with Maintenance Bypass Left & Distribution',250517.00,10),
('SY300K500DR-PD','APC Symmetra PX 300kW Scalable to 500kW with Right Mounted Maintenance Bypass and Distribution',250517.00,10),
('SY30K100F','APC Symmetra PX 30kW Scalable to 100kW, 208V with Startup',44014.00,10),
('SY30K40F','Symmetra PX 30kW Scalable to 40kW N+1, 208V',35790.00,10),
('SY32K160H','APC Symmetra PX 32kW Scalable to 160kW, 400V',43909.00,10),
('SY32K160H-PD','APC Symmetra PX 32kW Scalable to 160kW, 400V w/ Integrated Modular Distribution',61509.00,10),
('SY32K48H-PD','APC Symmetra PX 32kW All-In-One, Scalable to 48kW, 400V',49221.00,10),
('SY32K96H','Symmetra PX 32kW Scalable to 96kW, 400 V',43909.00,10),
('SY32K96H-PD','APC Symmetra PX 32kW Scalable to 96kW 400V with Modular Power Distribution',61509.00,10),
('SY400K500D','APC Symmetra PX 400kW Scalable to 500kW without Maintenance Bypass or Distribution-Parallel Capable',303349.00,10),
('SY400K500DL-PD','APC Symmetra PX 400kW Scalable to 500kW with Maintenance Bypass Left & Distribution',316990.00,10),
('SY400K500DR-PD','APC Symmetra PX 400kW Scalable to 500kW with Right Mounted Maintenance Bypass and Distribution',316990.00,10),
('SY40K100F','APC Symmetra PX 40kW Scalable to 100kW, 208V with Startup',49928.00,10),
('SY40K40F','Symmetra PX 40kW Scalable to 40kW N+1, 208V',42165.00,10),
('SY48K48H-PD','APC Symmetra PX All-In-One 48kW Scalable to 48kW, 400V',58891.00,10),
('SY500K500D','APC Symmetra PX 500kW Scalable to 500kW without Maintenance Bypass or Distribution-Parallel Capable',358970.00,10),
('SY500K500DL-PD','APC Symmetra PX 500kW Scalable to 500kW with Maintenance Bypass Left & Distribution',372611.00,10),
('SY500K500DR-PD','APC Symmetra PX 500kW Scalable to 500kW with Right Mounted Maintenance Bypass and Distribution',372611.00,10),
('SY50K100F','APC Symmetra PX 50kW Scalable to 100kW, 208V with Startup',55840.00,10),
('SY60K100F','APC Symmetra PX 60kW Scalable to 100kW, 208V with Startup',61755.00,10),
('SY64K160H','APC Symmetra PX 64kW Scalable to 160kW, 400V',62114.00,10),
('SY64K160H-PD','APC Symmetra PX 64kW Scalable to 160kW, 400V w/ Integrated Modular Distribution',79714.00,10),
('SY64K96H','APC Symmetra PX 64kW Scalable to 96kW, 400V',62114.00,10),
('SY64K96H-PD','APC Symmetra PX 64kW Scalable to 96kW 400V with Modular Power Distribution',79714.00,10),
('SY70K100F','APC Symmetra PX 70kW Scalable to 100kW, 208V with Startup',67664.00,10),
('SY80K100F','APC Symmetra PX 80kW Scalable to 100kW, 208V with Startup',73579.00,10),
('SY90K100F','APC Symmetra PX 90kW Scalable to 100kW, 208V with Startup',78589.00,10),
('SY96K160H','APC Symmetra PX 96kW Scalable to 160kW, 400V',80318.00,10),
('SY96K160H-PD','APC Symmetra PX 96kW Scalable to 160kW, 400V w/ Integrated Modular Distribution',97920.00,10),
('SY96K96H','APC Symmetra PX 96kW Scalable, 400V',80318.00,10),
('SY96K96H-PD','APC Symmetra PX 96kW Scalable, 400V with Modular Power Distribution',97920.00,10),
('SYBFXR8','APC Symmetra PX 250/500kW Battery Enclosure for up to 8 Battery Modules',10851.00,10),
('SYBFXR8S','APC Symmetra PX 250/500kW Battery Enclosure for up to 8 Battery Modules & Start Up',13123.00,10),
('SYCF100KF','Second Generation Symmetra PX 100kW Frame, 208V',27173.00,10),
('SYCF160KH','APC Symmetra PX Frame 160kW 400V',15627.00,10),
('SYCF40KF','SYMMETRA PX 40KW FRAME, 208V',15995.00,10),
('SYCF48KH','APC Symmetra PX 48kW All-In-One Frame, 400V',27973.00,10),
('SYCF80KF','Symmetra PX 80kW Frame, 208V',24242.00,10),
('SYIOF500KD','APC Symmetra PX 250/500kW IO Frame, 400/480V',13642.00,10),
('SYIOF500KMBL','APC Symmetra PX 250/500kW IO Frame with Left Mounted Maintenance Bypass and Distribution, 400/480V',23718.00,10),
('SYIOF500KMBR','APC Symmetra PX 250/500kW IO Frame with Right Mounted Maintenance Bypass and Distribution 400/480V',23718.00,10),
('SYPF250KD','APC Symmetra PX 250kW Power Module Frame, 400/480V',6357.00,10),
('UPS » Symmetra PX Accessories','',0.00,10),
('SYBFF','APC Symmetra PX 500kW Bottom Feed Frame for 500kW Dual Mains Configs',5427.00,10),
('SYBSC250K500','APC Symmetra PX250/500kW Batt. enclosure sidecar for remote battery solution with 500A fuse kit',6038.00,10),
('SYMBP100F','Symmetra PX 100 Maintenance Bypass Panel, 208V',9837.00,10),
('SYOPT003','APC Symmetra PX 250kW Battery Breaker Enclosure Fuse Kit 500A',869.00,10),
('SYOPT004','APC Symmetra PX 500kW Battery Breaker Enclosure Fuse Kit 1000A',947.00,10),
('SYOPT005','APC Symmetra PX 250/500 Air Filter',458.00,10),
('SYOPT006','APC Symmetra PX 250/500kW Optional Terminal Blocks',77.00,10),
('SYOPT007','APC Symmetra PX250/500 Third Party Switchgear Kit',1184.00,10),
('SYSW250KD','APC Symmetra PX 250kW Static Switch Module, 400/480V',6821.00,10),
('SYSW500KD','APC Symmetra PX 500kW Static Switch Module, 400/480V',8525.00,10),
('SYSW80KF','Symmetra PX 80kW Static Switch Module, 208V',5534.00,10),
('SYSW80KH','Symmetra PX 80kW Static Switch Module, 400V',6013.00,10),
('UPS » Symmetra Power Module','',0.00,10),
('SYPM','APC Symmetra 4-16kVA Power Module (4kVA)',2258.00,10),
('SYPM10K16H','APC Symmetra PX Power Module, 10/16kW, 400V',7334.00,10),
('SYPM10KF','Symmetra PX 10kW Power Module, 208V',5010.00,10),
('SYPM25KD','APC Symmetra PX 25kW Power Module, 400/480V',9301.00,10),
('SYPM2KU','APC Symmetra RM 2-6kVA Power Module (2kVA)',1630.00,10),
('SYPM4KI','APC Symmetra LX 4kVA Power Module, 220/230/240V',1930.00,10),
('SYPM4KP','APC Symmetra LX 4kVA Power Module, 200/208V',2008.00,10),
('SYPM4KU','APC Symmetra RM 8-12kVA Power Module (4kVA)',2170.00,10),
('UPS » Telecommunication','',0.00,10),
('UPS » UPS Network Management Cards','',0.00,10),
('AP9618','UPS Network Management Card, PowerChute Network Shutdown, Environmental Monitoring & Modem',659.00,10),
('AP9630','UPS Network Management Card with PowerChute Network Shutdown',346.00,10),
('AP9631','UPS Network Management Card with PowerChute Network Shutdown & Environmental Monitoring',559.00,10),
('AP9635CH','Schneider UPS Network Management Card 2 with Environment Monitoring, Out of Band Access and Modbus',754.00,10),
('AP9810','APC Dry Contact I/O Accessory',123.00,10),
('W490-0079','INROW SC CONDENSER FAN 200MM MIXED FLOW - SPARTE PART',447.00,10),
('W920-0082','DC RECTIFIER 500W FOR ACRD100-201 - SPARTE PART',667.00,10),
('WAGSLABOR','MANO DE OBRA PARA REEMPLAZO DE TARJETAS DE AIRE ACONDICIONADO (NO INCLUYE VIÁTICOS)',591.00,10),
('FGES-55K','Kit de tierra',615.00,11),
('FGES-90K','Kit de tierra',1174.00,11),
('FGES-150K','Kit de tierra',1621.00,11),
('FGES-500K','Kit de tierra',1845.00,11),
('FGES-800-LP','Electrodo 800 A',1677.00,11),
('FGES-1200-LP','Electrodo 1200 A',2516.00,11),
('FGES-1800-LP','Electrodo 1800 A',2963.00,11),
('FGES-3000-LP','Electrodo 3000 A',3858.00,11),
('FGES-CO1','Coplagauss 1000 A',503.00,11),
('FGES-CO2','Coplagauss 1600 A',727.00,11),
('FGES-CO4','Coplagauss 3000 A',1062.00,11),
('FGBUES-10','Barrra de unión 1000 A',391.00,11),
('FGBUE-11','Barrra de unión 1500 A',537.00,11),
('FGBUES-12','Barrra de unión 3000 A',671.00,11),
('FGES-BU-10','Barrra de unión 1000 A sin gabinete',335.00,11),
('FGES-BU-11','Barrra de unión 1500 A sin gabinete',481.00,11),
('FGES-BU-12','Barrra de unión 3000 A sin gabinete',537.00,11),
('FGES-MIX-02A','Compuesto acondicionador 15 Kg',86.00,11),
('FGES-M06','Mastil para pararrayos 6 m',666.00,11),
('PROTECTOX','Solucion antioxidante',76.00,11),
('FGES-LP01','Kit pararrayos (50 m. diametro)',1286.00,11),
('FGES-LP5006','Kit pararrayos (120 m. diametro)',2963.00,11),
('FGES-LP5004','Kit pararrayos (300 m. diametro)',5088.00,11),
('FGS-KIT-15A','Kit light',319.00,11),
('FGS-KP-01A','Kit premium',878.00,11),
('FGS-KIT-01A','Kit básico',1286.00,11),
('FGS-CG-CL 10','Coplagauss',151.00,11),
('FGS-CG-KP','Coplagauss',330.00,11),
('FGS-CGDM','Coplagauss',503.00,11),
('FGS-CG01A','Coplagauss',654.00,11),
('FGS-CG02A','Coplagauss',727.00,11),
('FGS-CG03A','Coplagauss',1230.00,11),
('FGS-CG04A','Coplagauss',1398.00,11),
('FGS-CG05A','Coplagauss',1845.00,11),
('FGS-CG012A','Coplagauss',2180.00,11),
('FGS-CG06PA','Coplagauss',1901.00,11),
('FGS-CG10A','Coplagauss',1062.00,11),
('FGS-CGDMI','Coplagauss',895.00,11),
('FGS-CGD01AI','Coplagauss',895.00,11),
('FGS-CGD02AI','Coplagauss',1096.00,11),
('FGS-CGD03AI','Coplagauss',1644.00,11),
('FGS-CGD04AI','Coplagauss',1800.00,11),
('FGS-CGD05AI','Coplagauss',1800.00,11),
('FGS-CGD06PAI','Coplagauss',2192.00,11),
('FGS-CG10PAI','Coplagauss',2404.00,11),
('FGS-CG12BU','Coplagauss y barra unión',1437.00,11),
('FGS-BU01A','Barra de unión',391.00,11),
('FGS-BU02A','Barra de unión',542.00,11),
('FGS-BU03A','Barra de unión',665.00,11),
('FGS-BU04A','Barra de unión',839.00,11),
('FGS-BU05A','Barra de unión',1107.00,11),
('FGS-25KP01','Electrodos',526.00,11),
('FGS-50D1','Electrodos',649.00,11),
('FGS-300A','Electrodos',1845.00,11),
('FGS-600A','Electrodos',2572.00,11),
('FGS-800A','Electrodos',3410.00,11),
('FGS-1200A','Electrodos',4529.00,11),
('FGS-2000A','Electrodos',5535.00,11),
('FGS-300AI','Electrodos',3736.00,11),
('FGS-600AI','Electrodos',5072.00,11),
('FGS-800AI','Electrodos',6461.00,11),
('FGS-1200AI','Electrodos',8101.00,11),
('FGS-2000AI','Electrodos',9628.00,11),
('FGS-800LP','Electrodos',3410.00,11),
('FGS-1200LP','Electrodos',4529.00,11),
('FGS-2000LP','Electrodos',5535.00,11),
('FGS-250RAD','Electrodos',1286.00,11),
('FGS-LP50-02','Pararrayos (750 M. Diametro)',2628.00,11),
('FGS-LP50-03','Pararrayos (500 M. Diametro)',2069.00,11),
('FGS-LP50-04','Pararrayos (300 M. Diametro)',1733.00,11),
('FGS-LP50-05','Pararrayos (200 M. Diametro)',1510.00,11),
('FGS-LP50-06','Pararrayos (120 M. Diametro)',1286.00,11),
('FGS-LP50-200F','Pararrayos (60 M. Diametro)',2069.00,11),
('FGS-PROCAR-01','Procar',1510.00,11),
('FGS-PROCAR-600P','Arocar',2739.00,11),
('FGS-PROCAR-200P','0rAocar',44263.00,11),
('FGS-DPT-01','Plano de tierras',839.00,11),
('FGS-DEPAT-01','Protector luces de obstrucción',1062.00,11),
('FGS-MIX-01A','Compuesto acondicionador',140.00,11),
('FGS-MIX-02A','Compuesto acondicionador',50.00,11),
('FGS-MIX-06AME','Compuesto acondicionador',218.00,11),
('FGS-CF10A','Contacto',56.00,11),
('FGS-CF-3HE','Contacto',56.00,11),
('FGS-TR-01A','Tapa de registro',183.00,11),
('FGS-TR-02A','Tapa de registro',183.00,11),
('FGS-TR-01AI','Tapa de registro de acero inoxidable 0,40 x 0,40',201.00,11),
('FGS-TR-02AI','Tapa de registro de acero inoxidable 0,50 x 0,50',231.00,11),
('MC-AI','Multiconector de acero inoxidable',123.00,11),
('FGS-TPKY-01A','Telurometro profecional digital',1057.00,11),
('FGS 250 RAD PC','Electrodo catódico',3693.00,11),
('FGS 600 PC','Electrodo catódico',6690.00,11),
('FGS 800 LP/PC','Electrodo catódico',8456.00,11),
('FGS MIX 10/PC','Acondicionador catódico',382.00,11),
('FGS CG/50 PC','Acoplador catódico',5476.00,11),
('FGS AS/100MZ','Anodo de sacrificio magnecio zinc',1480.00,11),
('FGS AS/200AZM','Anodo de sacrificio aluminio zinc mg',1128.00,11),
('FGS ZC/PC-01','Zapatas',274.00,11),
('A2000','Clase 0,2S - Medidor Multifunción Trifásico KWh, 4 Cuadrantes Kvarh, KVAh Demanda Máxima, Historial4 Tarifas TOU, Registro de eventos, Puerto 485, IEC-60687',1167.43,13),
('A2001','Clase 0,5S - Medidor Multifunción Trifásico KWh, 4 Cuadrantes Kvarh, KVAh Demanda Máxima, Historial4 Tarifas TOU, Registro de eventos, Puerto 485, IEC-60688',695.74,13),
('A2002','Clase 1 - Medidor Multifunción Trifásico KWh, 4 Cuadrantes Kvarh, KVAh Demanda Máxima, Historial4 Tarifas TOU, Registro de eventos, Puerto 485, IEC-60689',619.09,13),
('B2000','Clase 0,5S - Medidor Multifunción Trifásico KWh, Bi-direccional Kvarh, IEC-62053-21, Demanda Máxima, Historial 4 Tarifas TOU, Registro de eventos, Puerto 485',412.73,13),
('B2001','Clase 1 - Medidor Multifunción Trifásico KWh, Bi-direccional Kvarh, IEC-62053-21, Demanda Máxima, Historial 4 Tarifas TOU, Registro de eventos, Puerto 486',353.77,13),
('C1000M','Medidor Multifunción Monofásico kWh, Demanda Máxima, IEC-62053-21, Medición de Corriente y VoltajePuerto 485',135.61,13),
('C2000','Medidor monofásico KWh, Puerto 485',64.86,13),
('Software de explotación','Software instalable en ambiente Windows para la extracción de información de los medidores.',47.91,13),
('100/5','TRANSFORMADOR DE CORRIENTE Ventana útil de 2x3 (NUCLEO ABIERTO)',150.63,13),
('250/5','TRANSFORMADOR DE CORRIENTE Ventana útil de 5x8 (NUCLEO ABIERTO)',189.90,13),
('500/5','TRANSFORMADOR DE CORRIENTE 500 Ventana útil de 8x8 (NUCLEO ABIERTO)',204.88,13),
('800/5','TRANSFORMADOR DE CORRIENTE 800 Ventana útil de 8x8 (NUCLEO ABIERTO)',183.21,13),
('1000/5','TRANSFORMADOR DE CORRIENTE Ventana útil de 8x12 (NUCLEO ABIERTO)',233.76,13),
('2000/5','TRANSFORMADOR DE CORRIENTE Ventana útil de 8x16 (NUCLEO ABIERTO)',485.28,13),
('TGW-715','Módulo Modbus / TCP a RTU / ASCII gateway, 1 puerto RS 485/422, puerto Ethernet (10/100 Base-TX) con PoE. (Logicbus)',356.02,14),
('LBCSP-142-025-24','Fuente de poder 24V/1.04',83.31,14),
('IB-110','Embedded web server 8 analog/universal inputs EIA-232/485 Serial port. Power 24V AC/DC (Power supply sold separately) (BABEL BUSTER)',711.29,14),
('SPM-200','Remote monitoring LF critical site conditions Newmar',1168.30,14),
('SS-30RM1','Powerwerx 30 Amp Single Unit Rack Mount Switching Power Supply',296.13,14),
('MONCISX','Servicio de Monitoreo remoto y análisis por equipo trimestral que incluye soporte para asistencia de monitoreo o conectarlo a la red (no incluye hardware), estadísticas de fallas y solución, análisis de sensores, reporteo de fallas vía correo electrónico. Incluye Analisis trimestral de operacion por medio del monitoreo por equipo, incluye software y licencias.',111.00,14),
('MONSISX','Analisis trimestral de operacion por medio del monitoreo por equipo, no incluye software ni licencias. Incluye revision de parametros de operacion, historicos, alarmas, conectividad, tiempos de operacion, generacion de graficas, resumen y recomendaciones.',51.00,14);

	END IF;

	-- Lista de precios, 2a Carga
	IF(SELECT count(*) FROM codexPriceList) < 2243 THEN
		INSERT INTO blackstarDb.codexPriceList(code, name, price, codexProductFamilyId) VALUES
('CS25','Planta de emergencia con Capacidad de: Emergencia 23KW, Continuo 21KW, Emergencia 29KVA, Continuo 26KVA. El modelo PLANELEC es 025G4D0023 Cuenta con Motor CUMMINS modelo X2.5G4 y un Generador modelo UCI224C, Consumo diesel por hr. plena carga.8',10184.67,8),
('CS35','Planta de emergencia con Capacidad de: Emergencia 35KW, Continuo 30KW, Emergencia 44KVA, Continuo 38KVA. El modelo PLANELEC es 033G2D0035 Cuenta con Motor CUMMINS modelo X3.3G2 y un Generador modelo UCDI224C, Consumo diesel por hr. plena carga.12.1',11417.29,8),
('CS40','Planta de emergencia con Capacidad de: Emergencia 41KW, Continuo 37KW, Emergencia 51KVA, Continuo 46KVA. El modelo PLANELEC es 038G8D0041 Cuenta con Motor CUMMINS modelo S3.8G8 y un Generador modelo UCI224C, Consumo diesel por hr. plena carga.13.6',12350.17,8),
('CS50','Planta de emergencia con Capacidad de: Emergencia 51KW, Continuo 46KW, Emergencia 64KVA, Continuo 58KVA. El modelo PLANELEC es 038G9D0051 Cuenta con Motor CUMMINS modelo S3.8G9 y un Generador modelo UCI224D, Consumo diesel por hr. plena carga.16',12960.91,8),
('CS60','Planta de emergencia con Capacidad de: Emergencia 62KW, Continuo 56KW, Emergencia 77KVA, Continuo 70KVA. El modelo PLANELEC es 038G10D0062 Cuenta con Motor CUMMINS modelo S3.8G10 y un Generador modelo UCI224E, Consumo diesel por hr. plena carga.19',13663.92,8),
('CS80','Planta de emergencia con Capacidad de: Emergencia 82KW, Continuo 75KW, Emergencia 103KVA, Continuo 94KVA. El modelo PLANELEC es 039G3D0082 Cuenta con Motor CUMMINS modelo 4BTA3.9G3 y un Generador modelo UCI224F, Consumo diesel por hr. plena carga.25',16490.06,8),
('CS110','Planta de emergencia con Capacidad de: Emergencia 111KW, Continuo 99KW, Emergencia 139KVA, Continuo 124KVA. El modelo PLANELEC es 059G6D0111 Cuenta con Motor CUMMINS modelo 6BTA5.9G6 y un Generador modelo UCI274D, Consumo diesel por hr. plena carga.31',17344.85,8),
('CS135','Planta de emergencia con Capacidad de: Emergencia 136KW, Continuo 122KW, Emergencia 170KVA, Continuo 153KVA. El modelo PLANELEC es 059G3D0136 Cuenta con Motor CUMMINS modelo 6BTA5.9G3 y un Generador modelo UCI274E, Consumo diesel por hr. plena carga.40',19939.02,8),
('CS185','Planta de emergencia con Capacidad de: Emergencia 186KW, Continuo 168KW, Emergencia 233KVA, Continuo 210KVA. El modelo PLANELEC es 083G2D0186 Cuenta con Motor CUMMINS modelo 6CTA8.3G2 y un Generador modelo UCI274G, Consumo diesel por hr. plena carga.53',27180.14,8),
('CS215','Planta de emergencia con Capacidad de: Emergencia 215KW, Continuo 193KW, Emergencia 269KVA, Continuo 241KVA. El modelo PLANELEC es 083G3D0215 Cuenta con Motor CUMMINS modelo 6CTAA8.3G3 y un Generador modelo UCI274H, Consumo diesel por hr. plena carga.59',29154.11,8),
('CS270','Planta de emergencia con Capacidad de: Emergencia 268KW, Continuo 235KW, Emergencia 335KVA, Continuo 294KVA. El modelo PLANELEC es 090G3D0268 Cuenta con Motor CUMMINS modelo QSL9-G3 y un Generador modelo UCI274K, Consumo diesel por hr. plena carga.77',37332.94,8),
('CS320','Planta de emergencia con Capacidad de: Emergencia 321KW, Continuo 277KW, Emergencia 401KVA, Continuo 346KVA. El modelo PLANELEC es 090G5D0321 Cuenta con Motor CUMMINS modelo QSL9-G5 y un Generador modelo HCI444D, Consumo diesel por hr. plena carga.89',42849.67,8),
('CS360','Planta de emergencia con Capacidad de: Emergencia 362KW, Continuo 323KW, Emergencia 453KVA, Continuo 404KVA. El modelo PLANELEC es 140G3D0362 Cuenta con Motor CUMMINS modelo NTA-855G3 y un Generador modelo HCI444E, Consumo diesel por hr. plena carga.96',46437.58,8),
('CS410','Planta de emergencia con Capacidad de: Emergencia 410KW, Continuo - - -KW, Emergencia 513KVA, Continuo - - -KVA. El modelo PLANELEC es 140G5D0410 Cuenta con Motor CUMMINS modelo NTA-855G5 y un Generador modelo HCI444F, Consumo diesel por hr. plena carga.110',48916.75,8),
('CS440','Planta de emergencia con Capacidad de: Emergencia 440KW, Continuo 428KW, Emergencia 550KVA, Continuo 535KVA. El modelo PLANELEC es 150G9D0440 Cuenta con Motor CUMMINS modelo QSX-15G9 y un Generador modelo HCI444F, Consumo diesel por hr. plena carga.120',63922.95,8),
('CS510','Planta de emergencia con Capacidad de: Emergencia 512KW, Continuo 460KW, Emergencia 640KVA, Continuo 575KVA. El modelo PLANELEC es 150G9D0512 Cuenta con Motor CUMMINS modelo QSX-15G9 y un Generador modelo HCI544C, Consumo diesel por hr. plena carga.138',65348.67,8),
('CS550','Planta de emergencia con Capacidad de: Emergencia 555KW, Continuo 540KW, Emergencia 694KVA, Continuo 675KVA. El modelo PLANELEC es 280G5D0555 Cuenta con Motor CUMMINS modelo VTA-28G5 y un Generador modelo HCI534D, Consumo diesel por hr. plena carga.173',80209.08,8),
('CS620','Planta de emergencia con Capacidad de: Emergencia 619KW, Continuo 558KW, Emergencia 774KVA, Continuo 698KVA. El modelo PLANELEC es 280G5D0619 Cuenta con Motor CUMMINS modelo VTA-28G5 y un Generador modelo HCI534E, Consumo diesel por hr. plena carga.193',82094.22,8),
('CS820','Planta de emergencia con Capacidad de: Emergencia 819KW, Continuo 738KW, Emergencia 1024KVA, Continuo 923KVA. El modelo PLANELEC es 230G3D0819 Cuenta con Motor CUMMINS modelo QSK23G3 y un Generador modelo HCI634G, Consumo diesel por hr. plena carga.227',129538.89,8),
('CS920','Planta de emergencia con Capacidad de: Emergencia 928KW, Continuo 835KW, Emergencia 1160KVA, Continuo 1044KVA. El modelo PLANELEC es 300G3D0928 Cuenta con Motor CUMMINS modelo QST30G3 y un Generador modelo HCI634H, Consumo diesel por hr. plena carga.228',160320.37,8),
('CS1020','Planta de emergencia con Capacidad de: Emergencia 1026KW, Continuo 926KW, Emergencia 1283KVA, Continuo 1158KVA. El modelo PLANELEC es 300G5D1026 Cuenta con Motor CUMMINS modelo QST30G4 y un Generador modelo HCI634J, Consumo diesel por hr. plena carga.267',170063.68,8),
('CS1250','Planta de emergencia con Capacidad de: Emergencia 1260KW, Continuo 1134KW, Emergencia 1575KVA, Continuo 1418KVA. El modelo PLANELEC es 500G3D1260 Cuenta con Motor CUMMINS modelo KTA-50G3 y un Generador modelo HCI634K, Consumo diesel por hr. plena carga.293',224086.95,8),
('CS1550','Planta de emergencia con Capacidad de: Emergencia 1547KW, Continuo 1287KW, Emergencia 1934KVA, Continuo 1609KVA. El modelo PLANELEC es 500G9D1547A Cuenta con Motor CUMMINS modelo KTA-50-G9 y un Generador modelo PI734C, Consumo diesel por hr. plena carga.392',264729.62,8),
('CS2000','Planta de emergencia con Capacidad de: Emergencia 2052KW, Continuo 1855KW, Emergencia 2565KVA, Continuo 2319KVA. El modelo PLANELEC es 600G6D2052A Cuenta con Motor CUMMINS modelo QSK-60-G6 y un Generador modelo PI734F, Consumo diesel por hr. plena carga.521',388853.26,8),
('CS2200','Planta de emergencia con Capacidad de: Emergencia 2228KW, Continuo 1831KW, Emergencia 2785KVA, Continuo 2289KVA. El modelo PLANELEC es 600G14D2228A Cuenta con Motor CUMMINS modelo QSK-60-G14 y un Generador modelo PI734F, Consumo diesel por hr. plena carga.',450226.28,8),
('CS2800','Planta de emergencia con Capacidad de: Emergencia 2821KW, Continuo 2542KW, Emergencia 3526KVA, Continuo 3178KVA. El modelo PLANELEC es 780G8D2821A Cuenta con Motor CUMMINS modelo QSK-78-G8 y un Generador modelo LV804S, Consumo diesel por hr. plena carga.',836421.79,8),
('CS25-BT','Base Tanque con capacidad de 90 Ltspara una planta de emergencia de capacidad de 23KW',224.72,8),
('CS35-BT','Base Tanque con capacidad de 90 Ltspara una planta de emergencia de capacidad de 35KW',233.33,8),
('CS40-BT','Base Tanque con capacidad de 130 Ltspara una planta de emergencia de capacidad de 41KW',235.91,8),
('CS50-BT','Base Tanque con capacidad de 130 Ltspara una planta de emergencia de capacidad de 51KW',235.91,8),
('CS60-BT','Base Tanque con capacidad de 130 Ltspara una planta de emergencia de capacidad de 62KW',235.91,8),
('CS80-BT','Base Tanque con capacidad de 130 Ltspara una planta de emergencia de capacidad de 82KW',235.91,8),
('CS110-BT','Base Tanque con capacidad de 250 Ltspara una planta de emergencia de capacidad de 111KW',301.35,8),
('CS135-BT','Base Tanque con capacidad de 250 Ltspara una planta de emergencia de capacidad de 136KW',280.69,8),
('CS185-BT','Base Tanque con capacidad de 350 Ltspara una planta de emergencia de capacidad de 186KW',839.48,8),
('CS215-BT','Base Tanque con capacidad de 350 Ltspara una planta de emergencia de capacidad de 215KW',839.48,8),
('CS270-BT','Base Tanque con capacidad de 555 Ltspara una planta de emergencia de capacidad de 268KW',991.01,8),
('CS320-BT','Base Tanque con capacidad de 555 Ltspara una planta de emergencia de capacidad de 321KW',991.01,8),
('CS360-BT','Base Tanque con capacidad de 530 Ltspara una planta de emergencia de capacidad de 362KW',995.32,8),
('CS410-BT','Base Tanque con capacidad de 530 Ltspara una planta de emergencia de capacidad de 410KW',995.32,8),
('CS440-BT','Base Tanque con capacidad de 860 Ltspara una planta de emergencia de capacidad de 440KW',1028.03,8),
('CS510-BT','Base Tanque con capacidad de 860 Ltspara una planta de emergencia de capacidad de 512KW',1028.03,8),
('CS550-BT','Base Tanque con capacidad de 1000 Ltspara una planta de emergencia de capacidad de 555KW',1174.40,8),
('CS620-BT','Base Tanque con capacidad de 1000 Ltspara una planta de emergencia de capacidad de 619KW',1174.40,8),
('CS820-BT','Base Tanque con capacidad de 1200 Ltspara una planta de emergencia de capacidad de 819KW',1268.25,8),
('CS920-BT','Base Tanque con capacidad de 1200 Ltspara una planta de emergencia de capacidad de 928KW',1384.49,8),
('CS1020-BT','Base Tanque con capacidad de 1200 Ltspara una planta de emergencia de capacidad de 1026KW',1396.54,8),
('CS1250-BT','Base Tanque con capacidad de 1800 Ltspara una planta de emergencia de capacidad de 1260KW',1986.33,8),
('CS1550-BT','Base Tanque con capacidad de 1800 Ltspara una planta de emergencia de capacidad de 1547KW',1986.33,8),
('CS2000-BT','Base Tanque con capacidad de 2300 Ltspara una planta de emergencia de capacidad de 2052KW',2073.29,8),
('CS2200-BT','Base Tanque con capacidad de 2300 Ltspara una planta de emergencia de capacidad de 2228KW',2073.29,8),
('CS2800-BT','Base Tanque con capacidad de 0 Ltspara una planta de emergencia de capacidad de 2821KW',2145.61,8),
('CS25-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 80 AMP a 220V',196.31,8),
('CS35-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 125 AMP a 220V',205.78,8),
('CS40-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 160 AMP a 220V',237.64,8),
('CS50-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 200 AMP a 220V',391.76,8),
('CS60-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 200 AMP a 220V',391.76,8),
('CS80-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 320 AMP a 220V',671.58,8),
('CS110-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 400 AMP a 220V',696.55,8),
('CS135-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 500 AMP a 220V',941.07,8),
('CS185-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 630 AMP a 220V',1010.81,8),
('CS215-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 800 AMP a 220V',1805.52,8),
('CS270-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 1000 AMP a 220V',2352.25,8),
('CS320-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 1250 AMP a 220V',2589.03,8),
('CS360-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 1250 AMP a 220V',2589.03,8),
('CS410-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 1600 AMP a 220V',3271.80,8),
('CS440-IPG220V','Interruptor a pie de Generador tipo TM, capacidad de 1600 AMP a 220V',3271.80,8),
('CS510-IPG220V','Interruptor a pie de Generador tipo EM, capacidad de 2000 AMP a 220V',3723.83,8),
('CS550-IPG220V','Interruptor a pie de Generador tipo EM, capacidad de 2000 AMP a 220V',3723.83,8),
('CS620-IPG220V','Interruptor a pie de Generador tipo EM, capacidad de 2000 AMP a 220V',3723.83,8),
('CS820-IPG220V','Interruptor a pie de Generador tipo EM, capacidad de 3200 AMP a 220V',5601.67,8),
('CS920-IPG220V','Interruptor a pie de Generador tipo EM, capacidad de 3200 AMP a 220V',5601.67,8),
('CS1020-IPG220V','Interruptor a pie de Generador tipo EM, capacidad de 4000 AMP a 220V',9900.64,8),
('CS1250-IPG220V','Interruptor a pie de Generador tipo EM, capacidad de 5000 AMP a 220V',17176.95,8),
('CS1550-IPG220V','Interruptor a pie de Generador tipo EM, capacidad de 5000 AMP a 220V',17176.95,8),
('CS25-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 80 AMP a 240V',196.31,8),
('CS35-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 125 AMP a 240V',205.78,8),
('CS40-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 125 AMP a 240V',205.78,8),
('CS50-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 160 AMP a 240V',237.64,8),
('CS60-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 200 AMP a 240V',391.76,8),
('CS80-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 250 AMP a 240V',431.36,8),
('CS110-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 400 AMP a 240V',696.55,8),
('CS135-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 400 AMP a 240V',696.55,8),
('CS185-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 630 AMP a 240V',1010.81,8),
('CS215-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 630 AMP a 240V',1010.81,8),
('CS270-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 800 AMP a 240V',1805.52,8),
('CS320-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 1000 AMP a 240V',2352.25,8),
('CS360-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 1250 AMP a 240V',2589.03,8),
('CS410-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 1250 AMP a 240V',2589.03,8),
('CS440-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 1600 AMP a 240V',3271.80,8),
('CS510-IPG240V','Interruptor a pie de Generador tipo TM, capacidad de 1600 AMP a 240V',3271.80,8),
('CS550-IPG240V','Interruptor a pie de Generador tipo EM, capacidad de 2000 AMP a 240V',3723.83,8),
('CS620-IPG240V','Interruptor a pie de Generador tipo EM, capacidad de 2000 AMP a 240V',3723.83,8),
('CS820-IPG240V','Interruptor a pie de Generador tipo EM, capacidad de 2500 AMP a 240V',4581.38,8),
('CS920-IPG240V','Interruptor a pie de Generador tipo EM, capacidad de 3200 AMP a 240V',5601.67,8),
('CS1020-IPG240V','Interruptor a pie de Generador tipo EM, capacidad de 3200 AMP a 240V',5601.67,8),
('CS1250-IPG240V','Interruptor a pie de Generador tipo EM, capacidad de 4000 AMP a 240V',9900.64,8),
('CS1550-IPG240V','Interruptor a pie de Generador tipo EM, capacidad de 5000 AMP a 240V',17176.95,8),
('CS2000-IPG240V','Interruptor a pie de Generador tipo EM, capacidad de 6300 AMP a 240V',19879.63,8),
('CS25-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 40 AMP a 440V',187.70,8),
('CS35-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 63 AMP a 440V',187.70,8),
('CS40-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 80 AMP a 440V',196.31,8),
('CS50-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 100 AMP a 440V',196.31,8),
('CS60-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 100 AMP a 440V',196.31,8),
('CS80-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 160 AMP a 440V',237.64,8),
('CS110-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 200 AMP a 440V',391.76,8),
('CS135-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 250 AMP a 440V',431.36,8),
('CS185-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 320 AMP a 440V',671.58,8),
('CS215-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 400 AMP a 440V',696.55,8),
('CS270-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 500 AMP a 440V',941.07,8),
('CS320-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 630 AMP a 440V',1010.81,8),
('CS360-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 630 AMP a 440V',1010.81,8),
('CS410-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 800 AMP a 440V',1805.52,8),
('CS440-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 800 AMP a 440V',1805.52,8),
('CS510-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 1000 AMP a 440V',2352.25,8),
('CS550-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 1000 AMP a 440V',2352.25,8),
('CS620-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 1000 AMP a 440V',2352.25,8),
('CS820-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 1600 AMP a 440V',3271.80,8),
('CS920-IPG440V','Interruptor a pie de Generador tipo TM, capacidad de 1600 AMP a 440V',3271.80,8),
('CS1020-IPG440V','Interruptor a pie de Generador tipo EM, capacidad de 2000 AMP a 440V',3723.83,8),
('CS1250-IPG440V','Interruptor a pie de Generador tipo EM, capacidad de 2500 AMP a 440V',4581.38,8),
('CS1550-IPG440V','Interruptor a pie de Generador tipo EM, capacidad de 2500 AMP a 440V',4581.38,8),
('CS2000-IPG440V','Interruptor a pie de Generador tipo EM, capacidad de 4000 AMP a 440V',9900.64,8),
('CS2200-IPG440V','Interruptor a pie de Generador tipo EM, capacidad de 4000 AMP a 440V',9900.64,8),
('CS2800-IPG440V','Interruptor a pie de Generador tipo EM, capacidad de 5000 AMP a 440V',17176.95,8),
('CS25-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 40 AMP a 480V',187.70,8),
('CS35-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 63 AMP a 480V',187.70,8),
('CS40-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 80 AMP a 480V',196.31,8),
('CS50-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 80 AMP a 480V',196.31,8),
('CS60-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 100 AMP a 480V',196.31,8),
('CS80-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 125 AMP a 480V',205.78,8),
('CS110-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 200 AMP a 480V',391.76,8),
('CS135-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 200 AMP a 480V',391.76,8),
('CS185-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 320 AMP a 480V',671.58,8),
('CS215-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 320 AMP a 480V',671.58,8),
('CS270-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 400 AMP a 480V',696.55,8),
('CS320-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 500 AMP a 480V',941.07,8),
('CS360-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 630 AMP a 480V',1010.81,8),
('CS410-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 630 AMP a 480V',1010.81,8),
('CS440-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 800 AMP a 480V',1805.52,8),
('CS510-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 800 AMP a 480V',1805.52,8),
('CS550-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 1000 AMP a 480V',2352.25,8),
('CS620-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 1000 AMP a 480V',2352.25,8),
('CS820-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 1250 AMP a 480V',2589.03,8),
('CS920-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 1600 AMP a 480V',3271.80,8),
('CS1020-IPG480V','Interruptor a pie de Generador tipo TM, capacidad de 1600 AMP a 480V',3271.80,8),
('CS1250-IPG480V','Interruptor a pie de Generador tipo EM, capacidad de 2000 AMP a 480V',3723.83,8),
('CS1550-IPG480V','Interruptor a pie de Generador tipo EM, capacidad de 2500 AMP a 480V',4581.38,8),
('CS2000-IPG480V','Interruptor a pie de Generador tipo EM, capacidad de 3200 AMP a 480V',5601.67,8),
('CS2200-IPG480V','Interruptor a pie de Generador tipo EM, capacidad de 4000 AMP a 480V',9900.64,8),
('CS2800-IPG480V','Interruptor a pie de Generador tipo EM, capacidad de 5000 AMP a 480V',17176.95,8),
('500FG30','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG31','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG33','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG34','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG35','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG36','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG38','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG39','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG41','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG42','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG44','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG45','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG47','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG48','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG50','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG51','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG53','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG54','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('500FG56','Filtro Racor c/sensor agua, capacidad de 227 Lt/hr',433.94,8),
('900FH30','Filtro Racor c/sensor agua, capacidad de 341 Lt/hr',494.21,8),
('900FH31','Filtro Racor c/sensor agua, capacidad de 341 Lt/hr',494.21,8),
('900FH33','Filtro Racor c/sensor agua, capacidad de 341 Lt/hr',494.21,8),
('1000FH30','Filtro Racor c/sensor agua, capacidad de 681 Lt/hr',531.24,8),
('1000FH32','Filtro Racor c/sensor agua, capacidad de 681 Lt/hr',531.24,8),
('1000FH34','Filtro Racor c/sensor agua, capacidad de 681 Lt/hr',531.24,8),
('1000FH36','Filtro Racor c/sensor agua, capacidad de 681 Lt/hr',531.24,8),
('CS25-TRANS208V','Transferencia tipo C, capacidad de 80 AMP a 208V',512.29,8),
('CS35-TRANS208V','Transferencia tipo C, capacidad de 160 AMP a 208V',669.00,8),
('CS40-TRANS208V','Transferencia tipo C, capacidad de 160 AMP a 208V',669.00,8),
('CS50-TRANS208V','Transferencia tipo TM, capacidad de 200 AMP a 208V',2369.47,8),
('CS60-TRANS208V','Transferencia tipo TM, capacidad de 250 AMP a 208V',2410.80,8),
('CS80-TRANS208V','Transferencia tipo TM, capacidad de 350 AMP a 208V',3181.40,8),
('CS110-TRANS208V','Transferencia tipo TM, capacidad de 400 AMP a 208V',3222.72,8),
('CS135-TRANS208V','Transferencia tipo TM, capacidad de 500 AMP a 208V',3696.27,8),
('CS185-TRANS208V','Transferencia tipo TM, capacidad de 800 AMP a 208V',4561.58,8),
('CS215-TRANS208V','Transferencia tipo TM, capacidad de 800 AMP a 208V',4561.58,8),
('CS270-TRANS208V','Transferencia tipo TM, capacidad de 1000 AMP a 208V',5298.59,8),
('CS320-TRANS208V','Transferencia tipo TM, capacidad de 1250 AMP a 208V',6818.26,8),
('CS360-TRANS208V','Transferencia tipo TM, capacidad de 1600 AMP a 208V',7826.49,8),
('CS410-TRANS208V','Transferencia tipo TM, capacidad de 1600 AMP a 208V',7826.49,8),
('CS440-TRANS208V','Transferencia tipo TM, capacidad de 1600 AMP a 208V',7826.49,8),
('CS510-TRANS208V','Transferencia tipo EM, capacidad de 2000 AMP a 208V',9150.71,8),
('CS550-TRANS208V','Transferencia tipo EM, capacidad de 2000 AMP a 208V',9150.71,8),
('CS620-TRANS208V','Transferencia tipo EM, capacidad de 2500 AMP a 208V',10529.17,8),
('CS820-TRANS208V','Transferencia tipo EM, capacidad de 3200 AMP a 208V',14804.03,8),
('CS920-TRANS208V','Transferencia tipo EM, capacidad de 3200 AMP a 208V',14804.03,8),
('CS1020-TRANS208V','Transferencia tipo EM, capacidad de 4000 AMP a 208V',22708.88,8),
('CS1250-TRANS208V','Transferencia tipo EM, capacidad de 5000 AMP a 208V',40798.49,8),
('CS25-TRANS240V','Transferencia tipo C, capacidad de 80 AMP a 240V',512.29,8),
('CS35-TRANS240V','Transferencia tipo C, capacidad de 160 AMP a 240V',588.92,8),
('CS40-TRANS240V','Transferencia tipo C, capacidad de 160 AMP a 240V',669.00,8),
('CS50-TRANS240V','Transferencia tipo TM, capacidad de 200 AMP a 240V',2369.47,8),
('CS60-TRANS240V','Transferencia tipo TM, capacidad de 250 AMP a 240V',2410.80,8),
('CS80-TRANS240V','Transferencia tipo TM, capacidad de 350 AMP a 240V',3181.40,8),
('CS110-TRANS240V','Transferencia tipo TM, capacidad de 400 AMP a 240V',3222.72,8),
('CS135-TRANS240V','Transferencia tipo TM, capacidad de 500 AMP a 240V',3696.27,8),
('CS185-TRANS240V','Transferencia tipo TM, capacidad de 800 AMP a 240V',3777.21,8),
('CS215-TRANS240V','Transferencia tipo TM, capacidad de 800 AMP a 240V',4561.58,8),
('CS270-TRANS240V','Transferencia tipo TM, capacidad de 1000 AMP a 240V',5298.59,8),
('CS320-TRANS240V','Transferencia tipo TM, capacidad de 1250 AMP a 240V',6818.26,8),
('CS360-TRANS240V','Transferencia tipo TM, capacidad de 1600 AMP a 240V',6818.26,8),
('CS410-TRANS240V','Transferencia tipo TM, capacidad de 1600 AMP a 240V',7826.49,8),
('CS440-TRANS240V','Transferencia tipo TM, capacidad de 1600 AMP a 240V',7826.49,8),
('CS510-TRANS240V','Transferencia tipo EM, capacidad de 2000 AMP a 240V',9150.71,8),
('CS550-TRANS240V','Transferencia tipo EM, capacidad de 2000 AMP a 240V',9150.71,8),
('CS620-TRANS240V','Transferencia tipo EM, capacidad de 2500 AMP a 240V',10529.17,8),
('CS820-TRANS240V','Transferencia tipo EM, capacidad de 3200 AMP a 240V',14804.03,8),
('CS920-TRANS240V','Transferencia tipo EM, capacidad de 3200 AMP a 240V',14804.03,8),
('CS1020-TRANS240V','Transferencia tipo EM, capacidad de 4000 AMP a 240V',22708.88,8),
('CS1250-TRANS240V','Transferencia tipo EM, capacidad de 5000 AMP a 240V',40798.49,8),
('CS25-TRANS440V','Transferencia tipo C, capacidad de 40 AMP a 440V',670.72,8),
('CS35-TRANS440V','Transferencia tipo C, capacidad de 63 AMP a 440V',735.29,8),
('CS40-TRANS440V','Transferencia tipo C, capacidad de 80 AMP a 440V',758.54,8),
('CS50-TRANS440V','Transferencia tipo C, capacidad de 100 AMP a 440V',758.54,8),
('CS60-TRANS440V','Transferencia tipo C, capacidad de 125 AMP a 440V',835.17,8),
('CS80-TRANS440V','Transferencia tipo C, capacidad de 160 AMP a 440V',1064.20,8),
('CS110-TRANS440V','Transferencia tipo TM, capacidad de 200 AMP a 440V',2615.72,8),
('CS135-TRANS440V','Transferencia tipo TM, capacidad de 250 AMP a 440V',2657.05,8),
('CS185-TRANS440V','Transferencia tipo TM, capacidad de 350 AMP a 440V',3428.50,8),
('CS215-TRANS440V','Transferencia tipo TM, capacidad de 400 AMP a 440V',3468.97,8),
('CS270-TRANS440V','Transferencia tipo TM, capacidad de 500 AMP a 440V',3942.52,8),
('CS320-TRANS440V','Transferencia tipo TM, capacidad de 630 AMP a 440V',4024.31,8),
('CS360-TRANS440V','Transferencia tipo TM, capacidad de 630 AMP a 440V',4024.31,8),
('CS410-TRANS440V','Transferencia tipo TM, capacidad de 800 AMP a 440V',4807.82,8),
('CS440-TRANS440V','Transferencia tipo TM, capacidad de 800 AMP a 440V',4807.82,8),
('CS510-TRANS440V','Transferencia tipo TM, capacidad de 1000 AMP a 440V',5544.84,8),
('CS550-TRANS440V','Transferencia tipo TM, capacidad de 1000 AMP a 440V',5544.84,8),
('CS620-TRANS440V','Transferencia tipo TM, capacidad de 1250 AMP a 440V',7064.51,8),
('CS820-TRANS440V','Transferencia tipo TM, capacidad de 1600 AMP a 440V',8073.60,8),
('CS920-TRANS440V','Transferencia tipo TM, capacidad de 1600 AMP a 440V',8073.60,8),
('CS1020-TRANS440V','Transferencia tipo EM, capacidad de 2000 AMP a 440V',9397.82,8),
('CS1250-TRANS440V','Transferencia tipo EM, capacidad de 2500 AMP a 440V',10775.42,8),
('CS1550-TRANS440V','Transferencia tipo EM, capacidad de 3200 AMP a 440V',15050.28,8),
('CS2000-TRANS440V','Transferencia tipo EM, capacidad de 4000 AMP a 440V',22955.98,8),
('CS2200-TRANS440V','Transferencia tipo EM, capacidad de 4000 AMP a 440V',22955.98,8),
('CS2800-TRANS440V','Transferencia tipo EM, capacidad de 5000 AMP a 440V',41045.59,8),
('CS25-TRANS480V','Transferencia tipo C, capacidad de 40 AMP a 480V',670.72,8),
('CS35-TRANS480V','Transferencia tipo C, capacidad de 63 AMP a 480V',735.29,8),
('CS40-TRANS480V','Transferencia tipo C, capacidad de 80 AMP a 480V',758.54,8),
('CS50-TRANS480V','Transferencia tipo C, capacidad de 80 AMP a 480V',758.54,8),
('CS60-TRANS480V','Transferencia tipo C, capacidad de 100 AMP a 480V',758.54,8),
('CS80-TRANS480V','Transferencia tipo C, capacidad de 125 AMP a 480V',835.17,8),
('CS110-TRANS480V','Transferencia tipo TM, capacidad de 200 AMP a 480V',2615.72,8),
('CS135-TRANS480V','Transferencia tipo TM, capacidad de 200 AMP a 480V',2615.72,8),
('CS185-TRANS480V','Transferencia tipo TM, capacidad de 350 AMP a 480V',3428.50,8),
('CS215-TRANS480V','Transferencia tipo TM, capacidad de 350 AMP a 480V',3428.50,8),
('CS270-TRANS480V','Transferencia tipo TM, capacidad de 400 AMP a 480V',3468.97,8),
('CS320-TRANS480V','Transferencia tipo TM, capacidad de 500 AMP a 480V',3942.52,8),
('CS360-TRANS480V','Transferencia tipo TM, capacidad de 630 AMP a 480V',4024.31,8),
('CS410-TRANS480V','Transferencia tipo TM, capacidad de 630 AMP a 480V',4024.31,8),
('CS440-TRANS480V','Transferencia tipo TM, capacidad de 800 AMP a 480V',4807.82,8),
('CS510-TRANS480V','Transferencia tipo TM, capacidad de 800 AMP a 480V',4807.82,8),
('CS550-TRANS480V','Transferencia tipo TM, capacidad de 1000 AMP a 480V',5544.84,8),
('CS620-TRANS480V','Transferencia tipo TM, capacidad de 1000 AMP a 480V',5544.84,8),
('CS820-TRANS480V','Transferencia tipo TM, capacidad de 1250 AMP a 480V',7064.51,8),
('CS920-TRANS480V','Transferencia tipo TM, capacidad de 1600 AMP a 480V',8073.60,8),
('CS1020-TRANS480V','Transferencia tipo TM, capacidad de 1600 AMP a 480V',8073.60,8),
('CS1250-TRANS480V','Transferencia tipo EM, capacidad de 2000 AMP a 480V',9397.82,8),
('CS1550-TRANS480V','Transferencia tipo EM, capacidad de 2500 AMP a 480V',10775.42,8),
('CS2000-TRANS480V','Transferencia tipo EM, capacidad de 3200 AMP a 480V',15050.28,8),
('CS2200-TRANS480V','Transferencia tipo EM, capacidad de 4000 AMP a 480V',22955.98,8),
('CS2800-TRANS480V','Transferencia tipo EM, capacidad de 5000 AMP a 480V',41045.59,8),
('CS25-CINA','CASETA tipo Interperie No Acustica para planta de 23 KW en Emergencia',2217.94,8),
('CS35-CINA','CASETA tipo Interperie No Acustica para planta de 35 KW en Emergencia',2400.47,8),
('CS40-CINA','CASETA tipo Interperie No Acustica para planta de 41 KW en Emergencia',2501.21,8),
('CS50-CINA','CASETA tipo Interperie No Acustica para planta de 51 KW en Emergencia',2501.21,8),
('CS60-CINA','CASETA tipo Interperie No Acustica para planta de 62 KW en Emergencia',2501.21,8),
('CS80-CINA','CASETA tipo Interperie No Acustica para planta de 82 KW en Emergencia',2558.03,8),
('CS110-CINA','CASETA tipo Interperie No Acustica para planta de 111 KW en Emergencia',2928.26,8),
('CS135-CINA','CASETA tipo Interperie No Acustica para planta de 136 KW en Emergencia',2928.26,8),
('CS185-CINA','CASETA tipo Interperie No Acustica para planta de 186 KW en Emergencia',3224.45,8),
('CS215-CINA','CASETA tipo Interperie No Acustica para planta de 215 KW en Emergencia',3527.52,8),
('CS270-CINA','CASETA tipo Interperie No Acustica para planta de 268 KW en Emergencia',3806.48,8),
('CS320-CINA','CASETA tipo Interperie No Acustica para planta de 321 KW en Emergencia',3806.48,8),
('CS360-CINA','CASETA tipo Interperie No Acustica para planta de 362 KW en Emergencia',4478.06,8),
('CS410-CINA','CASETA tipo Interperie No Acustica para planta de 410 KW en Emergencia',5159.11,8),
('CS440-CINA','CASETA tipo Interperie No Acustica para planta de 440 KW en Emergencia',6518.63,8),
('CS510-CINA','CASETA tipo Interperie No Acustica para planta de 512 KW en Emergencia',6518.63,8),
('CS550-CINA','CASETA tipo Interperie No Acustica para planta de 555 KW en Emergencia',7792.91,8),
('CS620-CINA','CASETA tipo Interperie No Acustica para planta de 619 KW en Emergencia',7792.91,8),
('CS820-CINA','CASETA tipo Interperie No Acustica para planta de 819 KW en Emergencia',8871.74,8),
('CS920-CINA','CASETA tipo Interperie No Acustica para planta de 928 KW en Emergencia',9347.02,8),
('CS1020-CINA','CASETA tipo Interperie No Acustica para planta de 1026 KW en Emergencia',9347.02,8),
('CS1250-CINA','CASETA tipo Interperie No Acustica para planta de 1260 KW en Emergencia',10637.66,8),
('CS1550-CINA','CASETA tipo Interperie No Acustica para planta de 1547 KW en Emergencia',18031.06,8),
('CS25-I84DB','CASETA tipo Nivel I 84 dB para planta de 23 KW en Emergencia',2469.35,8),
('CS35-I84DB','CASETA tipo Nivel I 84 dB para planta de 35 KW en Emergencia',2682.88,8),
('CS40-I84DB','CASETA tipo Nivel I 84 dB para planta de 41 KW en Emergencia',3464.66,8),
('CS50-I84DB','CASETA tipo Nivel I 84 dB para planta de 51 KW en Emergencia',3464.66,8),
('CS60-I84DB','CASETA tipo Nivel I 84 dB para planta de 62 KW en Emergencia',3464.66,8),
('CS80-I84DB','CASETA tipo Nivel I 84 dB para planta de 82 KW en Emergencia',3545.60,8),
('CS110-I84DB','CASETA tipo Nivel I 84 dB para planta de 111 KW en Emergencia',4071.67,8),
('CS135-I84DB','CASETA tipo Nivel I 84 dB para planta de 136 KW en Emergencia',4071.67,8),
('CS185-I84DB','CASETA tipo Nivel I 84 dB para planta de 186 KW en Emergencia',4492.70,8),
('CS215-I84DB','CASETA tipo Nivel I 84 dB para planta de 215 KW en Emergencia',4919.75,8),
('CS270-I84DB','CASETA tipo Nivel I 84 dB para planta de 268 KW en Emergencia',5313.23,8),
('CS320-I84DB','CASETA tipo Nivel I 84 dB para planta de 321 KW en Emergencia',5313.23,8),
('CS360-I84DB','CASETA tipo Nivel I 84 dB para planta de 362 KW en Emergencia',6276.69,8),
('CS410-I84DB','CASETA tipo Nivel I 84 dB para planta de 410 KW en Emergencia',6956.88,8),
('CS440-I84DB','CASETA tipo Nivel I 84 dB para planta de 440 KW en Emergencia',8864.00,8),
('CS510-I84DB','CASETA tipo Nivel I 84 dB para planta de 512 KW en Emergencia',8864.00,8),
('CS550-I84DB','CASETA tipo Nivel I 84 dB para planta de 555 KW en Emergencia',10623.02,8),
('CS620-I84DB','CASETA tipo Nivel I 84 dB para planta de 619 KW en Emergencia',10623.02,8),
('CS820-I84DB','CASETA tipo Nivel I 84 dB para planta de 819 KW en Emergencia',12128.05,8),
('CS920-I84DB','CASETA tipo Nivel I 84 dB para planta de 928 KW en Emergencia',12800.49,8),
('CS1020-I84DB','CASETA tipo Nivel I 84 dB para planta de 1026 KW en Emergencia',12800.49,8),
('CS1250-I84DB','CASETA tipo Nivel I 84 dB para planta de 1260 KW en Emergencia',14635.28,8),
('CS1550-I84DB','CASETA tipo Nivel I 84 dB para planta de 1547 KW en Emergencia',22027.82,8),
('CS25-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 23 KW en Emergencia',2838.72,8),
('CS35-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 35 KW en Emergencia',3319.16,8),
('CS40-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 41 KW en Emergencia',4042.40,8),
('CS50-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 51 KW en Emergencia',4042.40,8),
('CS60-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 62 KW en Emergencia',4042.40,8),
('CS80-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 82 KW en Emergencia',4137.97,8),
('CS110-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 111 KW en Emergencia',4757.02,8),
('CS135-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 136 KW en Emergencia',4757.02,8),
('CS185-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 186 KW en Emergencia',5252.96,8),
('CS215-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 215 KW en Emergencia',5754.06,8),
('CS270-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 268 KW en Emergencia',6218.14,8),
('CS320-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 321 KW en Emergencia',6218.14,8),
('CS360-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 362 KW en Emergencia',7340.03,8),
('CS410-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 410 KW en Emergencia',8021.08,8),
('CS440-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 440 KW en Emergencia',10278.62,8),
('CS510-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 512 KW en Emergencia',10278.62,8),
('CS550-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 555 KW en Emergencia',11607.14,8),
('CS620-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 619 KW en Emergencia',12310.58,8),
('CS820-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 819 KW en Emergencia',14082.52,8),
('CS920-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 928 KW en Emergencia',14873.78,8),
('CS1020-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 1026 KW en Emergencia',14873.78,8),
('CS1250-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 1260 KW en Emergencia',17031.44,8),
('CS1550-ASBT76DB','CASETA tipo ACUSTICA SOBRE BT 76 dB para planta de 1547 KW en Emergencia',24424.85,8),
('CS25-ADP','CASETA tipo Acustica Directa al Piso para planta de 23 KW en Emergencia',2931.71,8),
('CS35-ADP','CASETA tipo Acustica Directa al Piso para planta de 35 KW en Emergencia',3103.04,8),
('CS40-ADP','CASETA tipo Acustica Directa al Piso para planta de 41 KW en Emergencia',4438.46,8),
('CS50-ADP','CASETA tipo Acustica Directa al Piso para planta de 51 KW en Emergencia',4438.46,8),
('CS60-ADP','CASETA tipo Acustica Directa al Piso para planta de 62 KW en Emergencia',4438.46,8),
('CS80-ADP','CASETA tipo Acustica Directa al Piso para planta de 82 KW en Emergencia',4552.11,8),
('CS110-ADP','CASETA tipo Acustica Directa al Piso para planta de 111 KW en Emergencia',5240.91,8),
('CS135-ADP','CASETA tipo Acustica Directa al Piso para planta de 136 KW en Emergencia',5240.91,8),
('CS185-ADP','CASETA tipo Acustica Directa al Piso para planta de 186 KW en Emergencia',5787.64,8),
('CS215-ADP','CASETA tipo Acustica Directa al Piso para planta de 215 KW en Emergencia',6365.37,8),
('CS270-ADP','CASETA tipo Acustica Directa al Piso para planta de 268 KW en Emergencia',7030.07,8),
('CS320-ADP','CASETA tipo Acustica Directa al Piso para planta de 321 KW en Emergencia',7030.07,8),
('CS360-ADP','CASETA tipo Acustica Directa al Piso para planta de 362 KW en Emergencia',8135.59,8),
('CS410-ADP','CASETA tipo Acustica Directa al Piso para planta de 410 KW en Emergencia',8815.78,8),
('CS440-ADP','CASETA tipo Acustica Directa al Piso para planta de 440 KW en Emergencia',12319.19,8),
('CS510-ADP','CASETA tipo Acustica Directa al Piso para planta de 512 KW en Emergencia',12319.19,8),
('CS550-ADP','CASETA tipo Acustica Directa al Piso para planta de 555 KW en Emergencia',13972.31,8),
('CS620-ADP','CASETA tipo Acustica Directa al Piso para planta de 619 KW en Emergencia',13972.31,8),
('CS820-ADP','CASETA tipo Acustica Directa al Piso para planta de 819 KW en Emergencia',15524.69,8),
('CS920-ADP','CASETA tipo Acustica Directa al Piso para planta de 928 KW en Emergencia',16660.35,8),
('CS1020-ADP','CASETA tipo Acustica Directa al Piso para planta de 1026 KW en Emergencia',16660.35,8),
('CS1250-ADP','CASETA tipo Acustica Directa al Piso para planta de 1260 KW en Emergencia',18946.31,8),
('CS1550-ADP','CASETA tipo Acustica Directa al Piso para planta de 1547 KW en Emergencia',26339.71,8),
('CS25-CBDE','CASETA tipo Con Bafle de Entrada para planta de 23 KW en Emergencia',3335.51,8),
('CS35-CBDE','CASETA tipo Con Bafle de Entrada para planta de 35 KW en Emergencia',3518.91,8),
('CS40-CBDE','CASETA tipo Con Bafle de Entrada para planta de 41 KW en Emergencia',4620.99,8),
('CS50-CBDE','CASETA tipo Con Bafle de Entrada para planta de 51 KW en Emergencia',4620.99,8),
('CS60-CBDE','CASETA tipo Con Bafle de Entrada para planta de 62 KW en Emergencia',4620.99,8),
('CS80-CBDE','CASETA tipo Con Bafle de Entrada para planta de 82 KW en Emergencia',4730.33,8),
('CS110-CBDE','CASETA tipo Con Bafle de Entrada para planta de 111 KW en Emergencia',5442.38,8),
('CS135-CBDE','CASETA tipo Con Bafle de Entrada para planta de 136 KW en Emergencia',5442.38,8),
('CS185-CBDE','CASETA tipo Con Bafle de Entrada para planta de 186 KW en Emergencia',6013.22,8),
('CS215-CBDE','CASETA tipo Con Bafle de Entrada para planta de 215 KW en Emergencia',6588.37,8),
('CS270-CBDE','CASETA tipo Con Bafle de Entrada para planta de 268 KW en Emergencia',7256.51,8),
('CS320-CBDE','CASETA tipo Con Bafle de Entrada para planta de 321 KW en Emergencia',7256.51,8),
('CS360-CBDE','CASETA tipo Con Bafle de Entrada para planta de 362 KW en Emergencia',8412.83,8),
('CS410-CBDE','CASETA tipo Con Bafle de Entrada para planta de 410 KW en Emergencia',9093.88,8),
('CS440-CBDE','CASETA tipo Con Bafle de Entrada para planta de 440 KW en Emergencia',12747.11,8),
('CS510-CBDE','CASETA tipo Con Bafle de Entrada para planta de 512 KW en Emergencia',12747.11,8),
('CS550-CBDE','CASETA tipo Con Bafle de Entrada para planta de 555 KW en Emergencia',13590.89,8),
('CS620-CBDE','CASETA tipo Con Bafle de Entrada para planta de 619 KW en Emergencia',13590.89,8),
('CS820-CBDE','CASETA tipo Con Bafle de Entrada para planta de 819 KW en Emergencia',15100.22,8),
('CS920-CBDE','CASETA tipo Con Bafle de Entrada para planta de 928 KW en Emergencia',16218.66,8),
('CS1020-CBDE','CASETA tipo Con Bafle de Entrada para planta de 1026 KW en Emergencia',17398.23,8),
('CS1250-CBDE','CASETA tipo Con Bafle de Entrada para planta de 1260 KW en Emergencia',19618.75,8),
('CS1550-CBDE','CASETA tipo Con Bafle de Entrada para planta de 1547 KW en Emergencia',27012.15,8),
('CS25-REM','CASETA tipo Remolque para planta de 23 KW en Emergencia',3074.63,8),
('CS35-REM','CASETA tipo Remolque para planta de 35 KW en Emergencia',3074.63,8),
('CS40-REM','CASETA tipo Remolque para planta de 41 KW en Emergencia',4365.27,8),
('CS50-REM','CASETA tipo Remolque para planta de 51 KW en Emergencia',4365.27,8),
('CS60-REM','CASETA tipo Remolque para planta de 62 KW en Emergencia',4365.27,8),
('CS80-REM','CASETA tipo Remolque para planta de 82 KW en Emergencia',4365.27,8),
('CS110-REM','CASETA tipo Remolque para planta de 111 KW en Emergencia',4656.29,8),
('CS135-REM','CASETA tipo Remolque para planta de 136 KW en Emergencia',4656.29,8),
('CS185-REM','CASETA tipo Remolque para planta de 186 KW en Emergencia',4656.29,8),
('CS215-REM','CASETA tipo Remolque para planta de 215 KW en Emergencia',6432.53,8),
('CS270-REM','CASETA tipo Remolque para planta de 268 KW en Emergencia',6432.53,8),
('CS320-REM','CASETA tipo Remolque para planta de 321 KW en Emergencia',6432.53,8),
('CS360-REM','CASETA tipo Remolque para planta de 362 KW en Emergencia',8519.59,8),
('CS410-REM','CASETA tipo Remolque para planta de 410 KW en Emergencia',8519.59,8),
('CS440-REM','CASETA tipo Remolque para planta de 440 KW en Emergencia',12979.58,8),
('CS510-REM','CASETA tipo Remolque para planta de 512 KW en Emergencia',12979.58,8),
('CS820-CONTMAR','CASETA tipo Contenedor Marino para planta de 819 KW en Emergencia',31952.57,8),
('CS920-CONTMAR','CASETA tipo Contenedor Marino para planta de 928 KW en Emergencia',31952.57,8),
('CS1020-CONTMAR','CASETA tipo Contenedor Marino para planta de 1026 KW en Emergencia',31952.57,8),
('CS1250-CONTMAR','CASETA tipo Contenedor Marino para planta de 1260 KW en Emergencia',35462.01,8),
('CS1550-CONTMAR','CASETA tipo Contenedor Marino para planta de 1547 KW en Emergencia',42855.41,8),
('CS2000-CONTMAR','CASETA tipo Contenedor Marino para planta de 2052 KW en Emergencia',67126.14,8),
('CS2200-CONTMAR','CASETA tipo Contenedor Marino para planta de 2228 KW en Emergencia',67126.14,8),
('CS2800-CONTMAR','CASETA tipo Contenedor Marino para planta de 2821 KW en Emergencia',67126.14,8),
('DSE892','Monitoreo para control DSE7320 con protocolos WEB, Modbus y SNMP',640.00,8),
('MC - P','Medición de capacitores: punto (instantáneo)',48.00,16),
('FPOD-P','Factor de potencia o demanda: punto (instantáneo)',75.00,16),
('FPOD-1','Factor de potencia o demanda: punto de 24 Hrs.',291.00,16),
('FPOD-2','Factor de potencia o demanda: de 2 días',583.00,16),
('FPOD-3','Factor de potencia o demanda: de 3 días',730.00,16),
('FPOD-5','Factor de potencia o demanda: de 5 días',1166.00,16),
('FPOD-7','Factor de potencia o demanda: de 7 días',1312.00,16),
('FPOD-10','Factor de potencia o demanda: de 10 días',1750.00,16),
('FPOD-15','Factor de potencia o demanda: de 15 días',2916.00,16),
('FPOD-30','Factor de potencia o demanda: de 30 días',4375.00,16),
('APE-P','Armónicas y Parámetros Eléctricos: punto (instantáneo)',100.00,16),
('APE-1','Armónicas y Parámetros Eléctricos: punto de 24 Hrs.',383.00,16),
('APE-2','Armónicas y Parámetros Eléctricos: de 2 días',766.00,16),
('APE-3','Armónicas y Parámetros Eléctricos: de 3 días',960.00,16),
('APE-5','Armónicas y Parámetros Eléctricos: de 5 días',1533.00,16),
('APE-7','Armónicas y Parámetros Eléctricos: de 7 días',1725.00,16),
('APE-10','Armónicas y Parámetros Eléctricos: de 10 días',2300.00,16),
('APE-15','Armónicas y Parámetros Eléctricos: de 15 días',3833.00,16),
('APE-30','Armónicas y Parámetros Eléctricos: de 30 días',5750.00,16),
('TPE-P','Transitorios y Parámetros Eléctricos: punto (instantáneo)',100.00,16),
('TPE-1','Transitorios y Parámetros Eléctricos: punto de 24 Hrs.',383.00,16),
('TPE-2','Transitorios y Parámetros Eléctricos: de 2 días',766.00,16),
('TPE-3','Transitorios y Parámetros Eléctricos: de 3 días',960.00,16),
('TPE-5','Transitorios y Parámetros Eléctricos: de 5 días',1533.00,16),
('TPE-7','Transitorios y Parámetros Eléctricos: de 7 días',1725.00,16),
('TPE-10','Transitorios y Parámetros Eléctricos: de 10 días',2300.00,16),
('TPE-15','Transitorios y Parámetros Eléctricos: de 15 días',3833.00,16),
('TPE-30','Transitorios y Parámetros Eléctricos: de 30 días',5750.00,16),
('CE-1','Calidad eléctrica: punto (instantáneo)',250.00,16),
('CE-1','Calidad eléctrica: punto de 24 Hrs.',550.00,16),
('CE-2','Calidad eléctrica: de 2 días',1100.00,16),
('CE-3','Calidad eléctrica: de 3 días',1375.00,16),
('CE-5','Calidad eléctrica: de 5 días',2200.00,16),
('CE-7','Calidad eléctrica: de 7 días',2475.00,16),
('CE-10','Calidad eléctrica: de 10 días',3300.00,16),
('CE-15','Calidad eléctrica: de 15 días',5500.00,16),
('CE-30','Calidad eléctrica: de 30 días',8250.00,16),
('T-H','Termografía: 1 a 2 hrs / Por hora',210.00,16),
('T-J','Termografía: 3 a 4 hrs / Por jornada',166.00,16),
('TERMO','Termografía: 6 hrs',625.00,16),
('AT-5','Análisis de tierras de 1 a 5 electrodos',38.00,16),
('AT-12','Análisis de tierras de 6 a 12 electrodos',30.00,16),
('AT-40','Análisis de tierras de 13 a 40 electrodos NOTA: Se podrá realizar en un solo día un máximo de 25 electrodos accesibles',25.00,16),
('AT-40+','Análisis de tierras mas de 40 electrodos NOTA: Se podrá realizar en un solo día un máximo de 25 electrodos accesibles',20.00,16),
('SCF-9','Servicio de Capacitores de 1 a 9 capacitoresMantenimiento a equipo fijo',62.00,16),
('SCF-25','Servicio de Capacitores de 10 a 25 capacitoresMantenimiento a equipo fijo NOTA: Se podrá realizar en un solo día 10 bancos fijos.',50.00,16),
('SCF-26+','Servicio de Capacitores mas de 25 capacitoresMantenimiento a equipo fijo NOTA: Se podrá realizar en un solo día 10 bancos fijos.',42.00,16),
('SCA-5','Servicio de Capacitores de 3 a 5 pasos Mantenimiento a equipo automático NOTA: Se podrá realizar en un solo día 2 automáticos.',333.00,16),
('SCA-9','Servicio de Capacitores de 6 a 9 pasos Mantenimiento a equipo automático NOTA: Se podrá realizar en un solo día 2 automáticos.',375.00,16),
('SCA-15','Servicio de Capacitores 10 a 15 pasos Mantenimiento a equipo automáticoSe podrá realizar en un solo día 2 automáticos.',460.00,16),
('UB3KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 3KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',362.20,17),
('UB5KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 5KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',721.86,17),
('UB6KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 6KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',753.62,17),
('UB8KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 8KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',979.65,17),
('UB10KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 10KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',1063.45,17),
('UB14KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 14KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',1403.46,17),
('UB18KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 18KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',1520.42,17),
('UT10KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 10KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',2079.20,17),
('UT20KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 20KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',2274.12,17),
('UT30KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 30KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',2453.29,17),
('UT40KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 40KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',2612.98,17),
('UT60KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 60KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',2985.01,17),
('UT80KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 80KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',3584.20,17),
('UT100KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 100KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',4141.49,17),
('UT120KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 120KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',4554.20,17),
('UT150KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 150KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',5476.08,17),
('UT225KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 225KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',7288.33,17),
('UT300KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 300KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',8545.01,17),
('UT400KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 400KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',11183.79,17),
('UT500KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 500KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',12440.32,17),
('UT750KCMP-47-2','Contrato Mtto 2 Prev,Capacidad 750KVA,Incluye Partes: SI,T. Resp/H. Aten.4/12hr Loc/for 7x24',12813.53,17),
('UB3KCM-47-2','Contrato Mtto 2 Prev,Capacidad 3KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',271.65,17),
('UB5KCM-47-2','Contrato Mtto 2 Prev,Capacidad 5KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',541.40,17),
('UB6KCM-47-2','Contrato Mtto 2 Prev,Capacidad 6KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',565.22,17),
('UB8KCM-47-2','Contrato Mtto 2 Prev,Capacidad 8KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',734.74,17),
('UB10KCM-47-2','Contrato Mtto 2 Prev,Capacidad 10KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',797.59,17),
('UB14KCM-47-2','Contrato Mtto 2 Prev,Capacidad 14KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1052.60,17),
('UB18KCM-47-2','Contrato Mtto 2 Prev,Capacidad 18KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1140.32,17),
('UT10KCM-47-2','Contrato Mtto 2 Prev,Capacidad 10KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1559.40,17),
('UT20KCM-47-2','Contrato Mtto 2 Prev,Capacidad 20KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1705.59,17),
('UT30KCM-47-2','Contrato Mtto 2 Prev,Capacidad 30KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1839.97,17),
('UT40KCM-47-2','Contrato Mtto 2 Prev,Capacidad 40KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1959.74,17),
('UT60KCM-47-2','Contrato Mtto 2 Prev,Capacidad 60KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',2238.76,17),
('UT80KCM-47-2','Contrato Mtto 2 Prev,Capacidad 80KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',2688.15,17),
('UT100KCM-47-2','Contrato Mtto 2 Prev,Capacidad 100KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',3106.12,17),
('UT120KCM-47-2','Contrato Mtto 2 Prev,Capacidad 120KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',3415.65,17),
('UT150KCM-47-2','Contrato Mtto 2 Prev,Capacidad 150KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',4107.06,17),
('UT225KCM-47-2','Contrato Mtto 2 Prev,Capacidad 225KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',5466.25,17),
('UT300KCM-47-2','Contrato Mtto 2 Prev,Capacidad 300KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',6408.76,17),
('UT400KCM-47-2','Contrato Mtto 2 Prev,Capacidad 400KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',8387.84,17),
('UT500KCM-47-2','Contrato Mtto 2 Prev,Capacidad 500KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',9330.24,17),
('UT750KCM-47-2','Contrato Mtto 2 Prev,Capacidad 750KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',9610.15,17),
('UB3KVR-7','Visita Prev o Arranq.,Capacidad 3KVA,,T. Resp/H. Aten.7x24',135.83,17),
('UB5KVR-7','Visita Prev o Arranq.,Capacidad 5KVA,,T. Resp/H. Aten.7x24',270.70,17),
('UB6KVR-7','Visita Prev o Arranq.,Capacidad 6KVA,,T. Resp/H. Aten.7x24',282.61,17),
('UB8KVR-7','Visita Prev o Arranq.,Capacidad 8KVA,,T. Resp/H. Aten.7x24',367.37,17),
('UB10KVR-7','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.7x24',398.80,17),
('UB14KVR-7','Visita Prev o Arranq.,Capacidad 14KVA,,T. Resp/H. Aten.7x24',526.30,17),
('UB18KVR-7','Visita Prev o Arranq.,Capacidad 18KVA,,T. Resp/H. Aten.7x24',570.16,17),
('UT10KVR-7','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.7x24',779.70,17),
('UT20KVR-7','Visita Prev o Arranq.,Capacidad 20KVA,,T. Resp/H. Aten.7x24',852.80,17),
('UT30KVR-7','Visita Prev o Arranq.,Capacidad 30KVA,,T. Resp/H. Aten.7x24',919.99,17),
('UT40KVR-7','Visita Prev o Arranq.,Capacidad 40KVA,,T. Resp/H. Aten.7x24',979.87,17),
('UT60KVR-7','Visita Prev o Arranq.,Capacidad 60KVA,,T. Resp/H. Aten.7x24',1119.38,17),
('UT80KVR-7','Visita Prev o Arranq.,Capacidad 80KVA,,T. Resp/H. Aten.7x24',1344.08,17),
('UT100KVR-7','Visita Prev o Arranq.,Capacidad 100KVA,,T. Resp/H. Aten.7x24',1553.06,17),
('UT120KVR-7','Visita Prev o Arranq.,Capacidad 120KVA,,T. Resp/H. Aten.7x24',1707.83,17),
('UT150KVR-7','Visita Prev o Arranq.,Capacidad 150KVA,,T. Resp/H. Aten.7x24',2053.53,17),
('UT225KVR-7','Visita Prev o Arranq.,Capacidad 225KVA,,T. Resp/H. Aten.7x24',2733.13,17),
('UT300KVR-7','Visita Prev o Arranq.,Capacidad 300KVA,,T. Resp/H. Aten.7x24',3204.38,17),
('UT400KVR-7','Visita Prev o Arranq.,Capacidad 400KVA,,T. Resp/H. Aten.7x24',4193.92,17),
('UT500KVR-7','Visita Prev o Arranq.,Capacidad 500KVA,,T. Resp/H. Aten.7x24',4665.12,17),
('UT750KVR-7','Visita Prev o Arranq.,Capacidad 700KVA,,T. Resp/H. Aten.7x24',4805.07,17),
('BEUB3KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 3KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',32.36,17),
('BEUB5KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 5KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',64.50,17),
('BEUB6KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 6KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',67.33,17),
('BEUB8KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 8KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',87.53,17),
('BEUB10KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 10KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',95.02,17),
('BEUB14KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 14KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',125.39,17),
('BEUB18KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 18KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',135.84,17),
('BEUT10KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 10KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',189.75,17),
('BEUT20KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 20KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',207.00,17),
('BEUT30KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 30KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',227.24,17),
('BEUT40KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 40KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',242.03,17),
('BEUT60KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 60KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',276.49,17),
('BEUT80KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 80KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',331.99,17),
('BEUT100KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 100KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',390.78,17),
('BEUT120KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 120KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',429.72,17),
('BEUT150KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 150KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',516.70,17),
('BEUT225KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 225KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',687.70,17),
('BEUT300KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 300KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',806.28,17),
('BEUT400KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 400KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1055.26,17),
('BEUT500KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 500KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1173.83,17),
('BEUT750KCM-47-2-10M','Contrato Mtto 2 Prev,Capacidad 750KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1584.66,17),
('BEUB3KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 3KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',64.72,17),
('BEUB5KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 5KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',128.99,17),
('BEUB6KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 6KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',134.67,17),
('BEUB8KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 8KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',175.06,17),
('BEUB10KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 10KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',190.03,17),
('BEUB14KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 14KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',250.79,17),
('BEUB18KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 18KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',271.69,17),
('BEUT10KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 10KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',379.50,17),
('BEUT20KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 20KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',414.00,17),
('BEUT30KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 30KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',454.47,17),
('BEUT40KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 40KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',484.06,17),
('BEUT60KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 60KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',552.97,17),
('BEUT80KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 80KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',663.97,17),
('BEUT100KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 100KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',781.55,17),
('BEUT120KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 120KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',859.44,17),
('BEUT150KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 150KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1033.41,17),
('BEUT225KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 225KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1375.40,17),
('BEUT300KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 300KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1612.56,17),
('BEUT400KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 400KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',2110.53,17),
('BEUT500KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 500KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',2347.65,17),
('BEUT750KCM-47-2-20M','Contrato Mtto 2 Prev,Capacidad 750KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',3169.33,17),
('BEUB3KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 3KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',97.08,17),
('BEUB5KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 5KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',193.49,17),
('BEUB6KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 6KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',202.00,17),
('BEUB8KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 8KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',262.59,17),
('BEUB10KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 10KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',285.05,17),
('BEUB14KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 14KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',376.18,17),
('BEUB18KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 18KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',407.53,17),
('BEUT10KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 10KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',563.50,17),
('BEUT20KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 20KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',621.00,17),
('BEUT30KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 30KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',681.71,17),
('BEUT40KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 40KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',726.08,17),
('BEUT60KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 60KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',829.46,17),
('BEUT80KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 80KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',995.96,17),
('BEUT100KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 100KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1172.33,17),
('BEUT120KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 120KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1289.16,17),
('BEUT150KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 150KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',1550.11,17),
('BEUT225KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 225KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',2063.10,17),
('BEUT300KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 300KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',2418.83,17),
('BEUT400KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 400KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',3165.79,17),
('BEUT500KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 500KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',3521.48,17),
('BEUT750KCM-47-2-30M','Contrato Mtto 2 Prev,Capacidad 750KVA,Incluye Partes: NO,T. Resp/H. Aten.4/12hr Loc/for 7x24',4753.99,17),
('BEUB3KVR-5-10M','Visita Prev o Arranq.,Capacidad 3KVA,,T. Resp/H. Aten.5x8',16.18,17),
('BEUB5KVR-5-10M','Visita Prev o Arranq.,Capacidad 5KVA,,T. Resp/H. Aten.5x8',32.25,17),
('BEUB6KVR-5-10M','Visita Prev o Arranq.,Capacidad 6KVA,,T. Resp/H. Aten.5x8',33.67,17),
('BEUB8KVR-5-10M','Visita Prev o Arranq.,Capacidad 8KVA,,T. Resp/H. Aten.5x8',43.76,17),
('BEUB10KVR-5-10M','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.5x8',47.51,17),
('BEUB14KVR-5-10M','Visita Prev o Arranq.,Capacidad 14KVA,,T. Resp/H. Aten.5x8',62.70,17),
('BEUB18KVR-5-10M','Visita Prev o Arranq.,Capacidad 18KVA,,T. Resp/H. Aten.5x8',67.92,17),
('BEUT10KVR-5-10M','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.5x8',92.00,17),
('BEUT20KVR-5-10M','Visita Prev o Arranq.,Capacidad 20KVA,,T. Resp/H. Aten.5x8',102.35,17),
('BEUT30KVR-5-10M','Visita Prev o Arranq.,Capacidad 30KVA,,T. Resp/H. Aten.5x8',113.62,17),
('BEUT40KVR-5-10M','Visita Prev o Arranq.,Capacidad 40KVA,,T. Resp/H. Aten.5x8',121.01,17),
('BEUT60KVR-5-10M','Visita Prev o Arranq.,Capacidad 60KVA,,T. Resp/H. Aten.5x8',138.24,17),
('BEUT80KVR-5-10M','Visita Prev o Arranq.,Capacidad 80KVA,,T. Resp/H. Aten.5x8',165.99,17),
('BEUT100KVR-5-10M','Visita Prev o Arranq.,Capacidad 100KVA,,T. Resp/H. Aten.5x8',195.39,17),
('BEUT120KVR-5-10M','Visita Prev o Arranq.,Capacidad 120KVA,,T. Resp/H. Aten.5x8',214.86,17),
('BEUT150KVR-5-10M','Visita Prev o Arranq.,Capacidad 150KVA,,T. Resp/H. Aten.5x8',258.35,17),
('BEUT225KVR-5-10M','Visita Prev o Arranq.,Capacidad 225KVA,,T. Resp/H. Aten.5x8',343.85,17),
('BEUT300KVR-5-10M','Visita Prev o Arranq.,Capacidad 300KVA,,T. Resp/H. Aten.5x8',403.14,17),
('BEUT400KVR-5-10M','Visita Prev o Arranq.,Capacidad 400KVA,,T. Resp/H. Aten.5x8',527.63,17),
('BEUT500KVR-5-10M','Visita Prev o Arranq.,Capacidad 500KVA,,T. Resp/H. Aten.5x8',586.91,17),
('BEUT750KVR-5-10M','Visita Prev o Arranq.,Capacidad 750KVA,,T. Resp/H. Aten.5x8',792.33,17),
('BEUB3KVR-7-10M','Visita Prev o Arranq.,Capacidad 3KVA,,T. Resp/H. Aten.7x24',21.84,17),
('BEUB5KVR-7-10M','Visita Prev o Arranq.,Capacidad 5KVA,,T. Resp/H. Aten.7x24',43.53,17),
('BEUB6KVR-7-10M','Visita Prev o Arranq.,Capacidad 6KVA,,T. Resp/H. Aten.7x24',45.45,17),
('BEUB8KVR-7-10M','Visita Prev o Arranq.,Capacidad 8KVA,,T. Resp/H. Aten.7x24',59.08,17),
('BEUB10KVR-7-10M','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.7x24',64.14,17),
('BEUB14KVR-7-10M','Visita Prev o Arranq.,Capacidad 14KVA,,T. Resp/H. Aten.7x24',84.64,17),
('BEUB18KVR-7-10M','Visita Prev o Arranq.,Capacidad 18KVA,,T. Resp/H. Aten.7x24',91.69,17),
('BEUT10KVR-7-10M','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.7x24',120.75,17),
('BEUT20KVR-7-10M','Visita Prev o Arranq.,Capacidad 20KVA,,T. Resp/H. Aten.7x24',138.00,17),
('BEUT30KVR-7-10M','Visita Prev o Arranq.,Capacidad 30KVA,,T. Resp/H. Aten.7x24',153.38,17),
('BEUT40KVR-7-10M','Visita Prev o Arranq.,Capacidad 40KVA,,T. Resp/H. Aten.7x24',163.37,17),
('BEUT60KVR-7-10M','Visita Prev o Arranq.,Capacidad 60KVA,,T. Resp/H. Aten.7x24',186.63,17),
('BEUT80KVR-7-10M','Visita Prev o Arranq.,Capacidad 80KVA,,T. Resp/H. Aten.7x24',224.09,17),
('BEUT100KVR-7-10M','Visita Prev o Arranq.,Capacidad 100KVA,,T. Resp/H. Aten.7x24',263.77,17),
('BEUT120KVR-7-10M','Visita Prev o Arranq.,Capacidad 120KVA,,T. Resp/H. Aten.7x24',290.06,17),
('BEUT150KVR-7-10M','Visita Prev o Arranq.,Capacidad 150KVA,,T. Resp/H. Aten.7x24',348.78,17),
('BEUT225KVR-7-10M','Visita Prev o Arranq.,Capacidad 225KVA,,T. Resp/H. Aten.7x24',464.20,17),
('BEUT300KVR-7-10M','Visita Prev o Arranq.,Capacidad 300KVA,,T. Resp/H. Aten.7x24',544.24,17),
('BEUT400KVR-7-10M','Visita Prev o Arranq.,Capacidad 400KVA,,T. Resp/H. Aten.7x24',712.30,17),
('BEUT500KVR-7-10M','Visita Prev o Arranq.,Capacidad 500KVA,,T. Resp/H. Aten.7x24',792.33,17),
('BEUT750KVR-7-10M','Visita Prev o Arranq.,Capacidad 750KVA,,T. Resp/H. Aten.7x24',1069.65,17),
('BEUB3KVR-5-20M','Visita Prev o Arranq.,Capacidad 3KVA,,T. Resp/H. Aten.5x8',32.36,17),
('BEUB5KVR-5-20M','Visita Prev o Arranq.,Capacidad 5KVA,,T. Resp/H. Aten.5x8',64.50,17),
('BEUB6KVR-5-20M','Visita Prev o Arranq.,Capacidad 6KVA,,T. Resp/H. Aten.5x8',67.33,17),
('BEUB8KVR-5-20M','Visita Prev o Arranq.,Capacidad 8KVA,,T. Resp/H. Aten.5x8',87.53,17),
('BEUB10KVR-5-20M','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.5x8',95.02,17),
('BEUB14KVR-5-20M','Visita Prev o Arranq.,Capacidad 14KVA,,T. Resp/H. Aten.5x8',125.39,17),
('BEUB18KVR-5-20M','Visita Prev o Arranq.,Capacidad 18KVA,,T. Resp/H. Aten.5x8',135.84,17),
('BEUT10KVR-5-20M','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.5x8',189.75,17),
('BEUT20KVR-5-20M','Visita Prev o Arranq.,Capacidad 20KVA,,T. Resp/H. Aten.5x8',205.85,17),
('BEUT30KVR-5-20M','Visita Prev o Arranq.,Capacidad 30KVA,,T. Resp/H. Aten.5x8',227.24,17),
('BEUT40KVR-5-20M','Visita Prev o Arranq.,Capacidad 40KVA,,T. Resp/H. Aten.5x8',242.03,17),
('BEUT60KVR-5-20M','Visita Prev o Arranq.,Capacidad 60KVA,,T. Resp/H. Aten.5x8',276.49,17),
('BEUT80KVR-5-20M','Visita Prev o Arranq.,Capacidad 80KVA,,T. Resp/H. Aten.5x8',331.99,17),
('BEUT100KVR-5-20M','Visita Prev o Arranq.,Capacidad 100KVA,,T. Resp/H. Aten.5x8',390.78,17),
('BEUT120KVR-5-20M','Visita Prev o Arranq.,Capacidad 120KVA,,T. Resp/H. Aten.5x8',429.72,17),
('BEUT150KVR-5-20M','Visita Prev o Arranq.,Capacidad 150KVA,,T. Resp/H. Aten.5x8',516.70,17),
('BEUT225KVR-5-20M','Visita Prev o Arranq.,Capacidad 225KVA,,T. Resp/H. Aten.5x8',687.70,17),
('BEUT300KVR-5-20M','Visita Prev o Arranq.,Capacidad 300KVA,,T. Resp/H. Aten.5x8',806.28,17),
('BEUT400KVR-5-20M','Visita Prev o Arranq.,Capacidad 400KVA,,T. Resp/H. Aten.5x8',1055.26,17),
('BEUT500KVR-5-20M','Visita Prev o Arranq.,Capacidad 500KVA,,T. Resp/H. Aten.5x8',1173.83,17),
('BEUT750KVR-5-20M','Visita Prev o Arranq.,Capacidad 750KVA,,T. Resp/H. Aten.5x8',1584.66,17),
('BEUB3KVR-7-20M','Visita Prev o Arranq.,Capacidad 3KVA,,T. Resp/H. Aten.7x24',43.69,17),
('BEUB5KVR-7-20M','Visita Prev o Arranq.,Capacidad 5KVA,,T. Resp/H. Aten.7x24',87.07,17),
('BEUB6KVR-7-20M','Visita Prev o Arranq.,Capacidad 6KVA,,T. Resp/H. Aten.7x24',90.90,17),
('BEUB8KVR-7-20M','Visita Prev o Arranq.,Capacidad 8KVA,,T. Resp/H. Aten.7x24',118.16,17),
('BEUB10KVR-7-20M','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.7x24',128.27,17),
('BEUB14KVR-7-20M','Visita Prev o Arranq.,Capacidad 14KVA,,T. Resp/H. Aten.7x24',169.28,17),
('BEUB18KVR-7-20M','Visita Prev o Arranq.,Capacidad 18KVA,,T. Resp/H. Aten.7x24',183.39,17),
('BEUT10KVR-7-20M','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.7x24',253.00,17),
('BEUT20KVR-7-20M','Visita Prev o Arranq.,Capacidad 20KVA,,T. Resp/H. Aten.7x24',276.00,17),
('BEUT30KVR-7-20M','Visita Prev o Arranq.,Capacidad 30KVA,,T. Resp/H. Aten.7x24',306.77,17),
('BEUT40KVR-7-20M','Visita Prev o Arranq.,Capacidad 40KVA,,T. Resp/H. Aten.7x24',326.74,17),
('BEUT60KVR-7-20M','Visita Prev o Arranq.,Capacidad 60KVA,,T. Resp/H. Aten.7x24',373.26,17),
('BEUT80KVR-7-20M','Visita Prev o Arranq.,Capacidad 80KVA,,T. Resp/H. Aten.7x24',448.18,17),
('BEUT100KVR-7-20M','Visita Prev o Arranq.,Capacidad 100KVA,,T. Resp/H. Aten.7x24',527.55,17),
('BEUT120KVR-7-20M','Visita Prev o Arranq.,Capacidad 120KVA,,T. Resp/H. Aten.7x24',580.12,17),
('BEUT150KVR-7-20M','Visita Prev o Arranq.,Capacidad 150KVA,,T. Resp/H. Aten.7x24',697.55,17),
('BEUT225KVR-7-20M','Visita Prev o Arranq.,Capacidad 225KVA,,T. Resp/H. Aten.7x24',928.40,17),
('BEUT300KVR-7-20M','Visita Prev o Arranq.,Capacidad 300KVA,,T. Resp/H. Aten.7x24',1088.48,17),
('BEUT400KVR-7-20M','Visita Prev o Arranq.,Capacidad 400KVA,,T. Resp/H. Aten.7x24',1424.61,17),
('BEUT500KVR-7-20M','Visita Prev o Arranq.,Capacidad 500KVA,,T. Resp/H. Aten.7x24',1584.66,17),
('BEUT750KVR-7-20M','Visita Prev o Arranq.,Capacidad 750KVA,,T. Resp/H. Aten.7x24',2139.30,17),
('BEUB3KVR-5-30M','Visita Prev o Arranq.,Capacidad 3KVA,,T. Resp/H. Aten.5x8',48.54,17),
('BEUB5KVR-5-30M','Visita Prev o Arranq.,Capacidad 5KVA,,T. Resp/H. Aten.5x8',96.74,17),
('BEUB6KVR-5-30M','Visita Prev o Arranq.,Capacidad 6KVA,,T. Resp/H. Aten.5x8',101.00,17),
('BEUB8KVR-5-30M','Visita Prev o Arranq.,Capacidad 8KVA,,T. Resp/H. Aten.5x8',131.29,17),
('BEUB10KVR-5-30M','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.5x8',142.52,17),
('BEUB14KVR-5-30M','Visita Prev o Arranq.,Capacidad 14KVA,,T. Resp/H. Aten.5x8',188.09,17),
('BEUB18KVR-5-30M','Visita Prev o Arranq.,Capacidad 18KVA,,T. Resp/H. Aten.5x8',203.77,17),
('BEUT10KVR-5-30M','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.5x8',281.75,17),
('BEUT20KVR-5-30M','Visita Prev o Arranq.,Capacidad 20KVA,,T. Resp/H. Aten.5x8',304.75,17),
('BEUT30KVR-5-30M','Visita Prev o Arranq.,Capacidad 30KVA,,T. Resp/H. Aten.5x8',340.85,17),
('BEUT40KVR-5-30M','Visita Prev o Arranq.,Capacidad 40KVA,,T. Resp/H. Aten.5x8',363.04,17),
('BEUT60KVR-5-30M','Visita Prev o Arranq.,Capacidad 60KVA,,T. Resp/H. Aten.5x8',414.73,17),
('BEUT80KVR-5-30M','Visita Prev o Arranq.,Capacidad 80KVA,,T. Resp/H. Aten.5x8',497.98,17),
('BEUT100KVR-5-30M','Visita Prev o Arranq.,Capacidad 100KVA,,T. Resp/H. Aten.5x8',586.17,17),
('BEUT120KVR-5-30M','Visita Prev o Arranq.,Capacidad 120KVA,,T. Resp/H. Aten.5x8',644.58,17),
('BEUT150KVR-5-30M','Visita Prev o Arranq.,Capacidad 150KVA,,T. Resp/H. Aten.5x8',775.06,17),
('BEUT225KVR-5-30M','Visita Prev o Arranq.,Capacidad 225KVA,,T. Resp/H. Aten.5x8',1031.55,17),
('BEUT300KVR-5-30M','Visita Prev o Arranq.,Capacidad 300KVA,,T. Resp/H. Aten.5x8',1209.42,17),
('BEUT400KVR-5-30M','Visita Prev o Arranq.,Capacidad 400KVA,,T. Resp/H. Aten.5x8',1582.90,17),
('BEUT500KVR-5-30M','Visita Prev o Arranq.,Capacidad 500KVA,,T. Resp/H. Aten.5x8',1760.74,17),
('BEUT750KVR-5-30M','Visita Prev o Arranq.,Capacidad 750KVA,,T. Resp/H. Aten.5x8',2377.00,17),
('BEUB3KVR-7-30M','Visita Prev o Arranq.,Capacidad 3KVA,,T. Resp/H. Aten.7x24',65.53,17),
('BEUB5KVR-7-30M','Visita Prev o Arranq.,Capacidad 5KVA,,T. Resp/H. Aten.7x24',130.60,17),
('BEUB6KVR-7-30M','Visita Prev o Arranq.,Capacidad 6KVA,,T. Resp/H. Aten.7x24',136.35,17),
('BEUB8KVR-7-30M','Visita Prev o Arranq.,Capacidad 8KVA,,T. Resp/H. Aten.7x24',177.25,17),
('BEUB10KVR-7-30M','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.7x24',192.41,17),
('BEUB14KVR-7-30M','Visita Prev o Arranq.,Capacidad 14KVA,,T. Resp/H. Aten.7x24',253.92,17),
('BEUB18KVR-7-30M','Visita Prev o Arranq.,Capacidad 18KVA,,T. Resp/H. Aten.7x24',275.08,17),
('BEUT10KVR-7-30M','Visita Prev o Arranq.,Capacidad 10KVA,,T. Resp/H. Aten.7x24',379.50,17),
('BEUT20KVR-7-30M','Visita Prev o Arranq.,Capacidad 20KVA,,T. Resp/H. Aten.7x24',414.00,17),
('BEUT30KVR-7-30M','Visita Prev o Arranq.,Capacidad 30KVA,,T. Resp/H. Aten.7x24',460.15,17),
('BEUT40KVR-7-30M','Visita Prev o Arranq.,Capacidad 40KVA,,T. Resp/H. Aten.7x24',490.11,17),
('BEUT60KVR-7-30M','Visita Prev o Arranq.,Capacidad 60KVA,,T. Resp/H. Aten.7x24',559.89,17),
('BEUT80KVR-7-30M','Visita Prev o Arranq.,Capacidad 80KVA,,T. Resp/H. Aten.7x24',672.27,17),
('BEUT100KVR-7-30M','Visita Prev o Arranq.,Capacidad 100KVA,,T. Resp/H. Aten.7x24',791.32,17),
('BEUT120KVR-7-30M','Visita Prev o Arranq.,Capacidad 120KVA,,T. Resp/H. Aten.7x24',870.18,17),
('BEUT150KVR-7-30M','Visita Prev o Arranq.,Capacidad 150KVA,,T. Resp/H. Aten.7x24',1046.33,17),
('BEUT225KVR-7-30M','Visita Prev o Arranq.,Capacidad 225KVA,,T. Resp/H. Aten.7x24',1392.60,17),
('BEUT300KVR-7-30M','Visita Prev o Arranq.,Capacidad 300KVA,,T. Resp/H. Aten.7x24',1632.71,17),
('BEUT400KVR-7-30M','Visita Prev o Arranq.,Capacidad 400KVA,,T. Resp/H. Aten.7x24',2136.91,17),
('BEUT500KVR-7-30M','Visita Prev o Arranq.,Capacidad 500KVA,,T. Resp/H. Aten.7x24',2377.00,17),
('BEUT750KVR-7-30M','Visita Prev o Arranq.,Capacidad 750KVA,,T. Resp/H. Aten.7x24',3208.95,17),
('A7KWCMP-47-4','Contrato Mtto 4 PREV, Capacidad 2TR, Partes: SI, COMPRESOR: NO, T. RESP/H. ATEN 4/12hr Loc/for 7x24',1738.03,15),
('A10KWCMP-47-4','Contrato Mtto 4 PREV, Capacidad 3TR, Partes: SI, COMPRESOR: NO, T. RESP/H. ATEN 5/12hr Loc/for 7x24',1764.25,15),
('A14KWCMP-47-4','Contrato Mtto 4 PREV, Capacidad 4TR, Partes: SI, COMPRESOR: NO, T. RESP/H. ATEN 6/12hr Loc/for 7x24',1852.17,15),
('A18KWCMP-47-4','Contrato Mtto 4 PREV, Capacidad 5TR, Partes: SI, COMPRESOR: NO, T. RESP/H. ATEN 7/12hr Loc/for 7x24',1884.87,15),
('A21KWCMP-47-4','Contrato Mtto 4 PREV, Capacidad 6TR, Partes: SI, COMPRESOR: NO, T. RESP/H. ATEN 8/12hr Loc/for 7x24',2171.15,15),
('A28KWCMP-47-4','Contrato Mtto 4 PREV, Capacidad 8TR, Partes: SI, COMPRESOR: NO, T. RESP/H. ATEN 9/12hr Loc/for 7x24',2546.89,15),
('A35KWCMP-47-4','Contrato Mtto 4 PREV, Capacidad 10TR, Partes: SI, COMPRESOR: NO, T. RESP/H. ATEN 10/12hr Loc/for 7x24',2831.94,15),
('A45KWCMP-47-4','Contrato Mtto 4 PREV, Capacidad 13TR, Partes: SI, COMPRESOR: NO, T. RESP/H. ATEN 11/12hr Loc/for 7x24',3135.96,15),
('A56KWCMP-47-4','Contrato Mtto 4 PREV, Capacidad 16TR, Partes: SI, COMPRESOR: NO, T. RESP/H. ATEN 12/12hr Loc/for 7x24',3446.60,15),
('A70KWCMP-47-4','Contrato Mtto 4 PREV, Capacidad 20TR, Partes: SI, COMPRESOR: NO, T. RESP/H. ATEN 13/12hr Loc/for 7x24',3808.00,15),
('A91KWCMP-47-4','Contrato Mtto 4 PREV, Capacidad 26TR, Partes: SI, COMPRESOR: NO, T. RESP/H. ATEN 14/12hr Loc/for 7x24',3939.88,15),
('A105KWCMP-47-4','Contrato Mtto 4 PREV, Capacidad 30TR, Partes: SI, COMPRESOR: NO, T. RESP/H. ATEN 15/12hr Loc/for 7x24',4822.01,15),
('A7KWCMF-47-4','Contrato Mtto 4 PREV, Capacidad 2TR, Partes: NO, COMPRESOR: NO, T. RESP/H. ATEN 16/12hr Loc/for 7x24',1303.52,15),
('A10KWCMF-47-4','Contrato Mtto 4 PREV, Capacidad 3TR, Partes: NO, COMPRESOR: NO, T. RESP/H. ATEN 17/12hr Loc/for 7x24',1323.19,15),
('A14KWCMF-47-4','Contrato Mtto 4 PREV, Capacidad 4TR, Partes: NO, COMPRESOR: NO, T. RESP/H. ATEN 18/12hr Loc/for 7x24',1389.13,15),
('A18KWCMF-47-4','Contrato Mtto 4 PREV, Capacidad 5TR, Partes: NO, COMPRESOR: NO, T. RESP/H. ATEN 19/12hr Loc/for 7x24',1413.65,15),
('A21KWCMF-47-4','Contrato Mtto 4 PREV, Capacidad 6TR, Partes: NO, COMPRESOR: NO, T. RESP/H. ATEN 20/12hr Loc/for 7x24',1628.36,15),
('A28KWCMF-47-4','Contrato Mtto 4 PREV, Capacidad 8TR, Partes: NO, COMPRESOR: NO, T. RESP/H. ATEN 21/12hr Loc/for 7x24',1910.17,15),
('A35KWCMF-47-4','Contrato Mtto 4 PREV, Capacidad 10TR, Partes: NO, COMPRESOR: NO, T. RESP/H. ATEN 22/12hr Loc/for 7x24',2123.96,15),
('A45KWCMF-47-4','Contrato Mtto 4 PREV, Capacidad 13TR, Partes: NO, COMPRESOR: NO, T. RESP/H. ATEN 23/12hr Loc/for 7x24',2351.97,15),
('A56KWCMF-47-4','Contrato Mtto 4 PREV, Capacidad 16TR, Partes: NO, COMPRESOR: NO, T. RESP/H. ATEN 24/12hr Loc/for 7x24',2584.95,15),
('A70KWCMF-47-4','Contrato Mtto 4 PREV, Capacidad 20TR, Partes: NO, COMPRESOR: NO, T. RESP/H. ATEN 25/12hr Loc/for 7x24',2856.00,15),
('A91KWCMF-47-4','Contrato Mtto 4 PREV, Capacidad 26TR, Partes: NO, COMPRESOR: NO, T. RESP/H. ATEN 26/12hr Loc/for 7x24',2954.91,15),
('A105KWCMF-47-4','Contrato Mtto 4 PREV, Capacidad 30TR, Partes: NO, COMPRESOR: NO, T. RESP/H. ATEN 27/12hr Loc/for 7x24',3616.51,15),
('A7KWCMC-47-4','Contrato Mtto 4 PREV, Capacidad 2TR, Partes: SI, COMPRESOR: SI, T. RESP/H. ATEN 28/12hr Loc/for 7x24',2085.64,15),
('A10KWCMC-47-4','Contrato Mtto 4 PREV, Capacidad 3TR, Partes: SI, COMPRESOR: SI, T. RESP/H. ATEN 29/12hr Loc/for 7x24',2117.10,15),
('A14KWCMC-47-4','Contrato Mtto 4 PREV, Capacidad 4TR, Partes: SI, COMPRESOR: SI, T. RESP/H. ATEN 30/12hr Loc/for 7x24',2222.60,15),
('A18KWCMC-47-4','Contrato Mtto 4 PREV, Capacidad 5TR, Partes: SI, COMPRESOR: SI, T. RESP/H. ATEN 31/12hr Loc/for 7x24',2261.84,15),
('A21KWCMC-47-4','Contrato Mtto 4 PREV, Capacidad 6TR, Partes: SI, COMPRESOR: SI, T. RESP/H. ATEN 32/12hr Loc/for 7x24',2605.38,15),
('A28KWCMC-47-4','Contrato Mtto 4 PREV, Capacidad 8TR, Partes: SI, COMPRESOR: SI, T. RESP/H. ATEN 33/12hr Loc/for 7x24',3056.27,15),
('A35KWCMC-47-4','Contrato Mtto 4 PREV, Capacidad 10TR, Partes: SI, COMPRESOR: SI, T. RESP/H. ATEN 34/12hr Loc/for 7x24',3398.33,15),
('A45KWCMC-47-4','Contrato Mtto 4 PREV, Capacidad 13TR, Partes: SI, COMPRESOR: SI, T. RESP/H. ATEN 35/12hr Loc/for 7x24',3763.15,15),
('A56KWCMC-47-4','Contrato Mtto 4 PREV, Capacidad 16TR, Partes: SI, COMPRESOR: SI, T. RESP/H. ATEN 36/12hr Loc/for 7x24',4135.92,15),
('A70KWCMC-47-4','Contrato Mtto 4 PREV, Capacidad 20TR, Partes: SI, COMPRESOR: SI, T. RESP/H. ATEN 37/12hr Loc/for 7x24',4569.60,15),
('A91KWCMC-47-4','Contrato Mtto 4 PREV, Capacidad 26TR, Partes: SI, COMPRESOR: SI, T. RESP/H. ATEN 38/12hr Loc/for 7x24',4727.86,15),
('A105KWCMC-47-4','Contrato Mtto 4 PREV, Capacidad 30TR, Partes: SI, COMPRESOR: SI, T. RESP/H. ATEN 39/12hr Loc/for 7x24',5786.41,15),
('A7KWVR-5','Visita Rev o Arranque, Capacidad 2TR, T. RESP/H. ATEN 5x8',384.52,15),
('A10KWVR-5','Visita Rev o Arranque, Capacidad 3TR, T. RESP/H. ATEN 5x8',390.32,15),
('A14KWVR-5','Visita Rev o Arranque, Capacidad 4TR, T. RESP/H. ATEN 5x8',409.77,15),
('A18KWVR-5','Visita Rev o Arranque, Capacidad 5TR, T. RESP/H. ATEN 5x8',417.01,15),
('A21KWVR-5','Visita Rev o Arranque, Capacidad 6TR, T. RESP/H. ATEN 5x8',480.34,15),
('A28KWVR-5','Visita Rev o Arranque, Capacidad 8TR, T. RESP/H. ATEN 5x8',563.47,15),
('A35KWVR-5','Visita Rev o Arranque, Capacidad 10TR, T. RESP/H. ATEN 5x8',626.54,15),
('A45KWVR-5','Visita Rev o Arranque, Capacidad 13TR, T. RESP/H. ATEN 5x8',693.80,15),
('A56KWVR-5','Visita Rev o Arranque, Capacidad 16TR, T. RESP/H. ATEN 5x8',762.52,15),
('A70KWVR-5','Visita Rev o Arranque, Capacidad 20TR, T. RESP/H. ATEN 5x8',842.48,15),
('A91KWVR-5','Visita Rev o Arranque, Capacidad 26TR, T. RESP/H. ATEN 5x8',871.65,15),
('A105KWVR-5','Visita Rev o Arranque, Capacidad 30TR, T. RESP/H. ATEN 5x8',1066.82,15),
('A7KWVR-7','Visita Rev o Arranque, Capacidad 2TR, T. RESP/H. ATEN 7x24',519.10,15),
('A10KWVR-7','Visita Rev o Arranque, Capacidad 3TR, T. RESP/H. ATEN 7x24',526.93,15),
('A14KWVR-7','Visita Rev o Arranque, Capacidad 4TR, T. RESP/H. ATEN 7x24',553.19,15),
('A18KWVR-7','Visita Rev o Arranque, Capacidad 5TR, T. RESP/H. ATEN 7x24',562.96,15),
('A21KWVR-7','Visita Rev o Arranque, Capacidad 6TR, T. RESP/H. ATEN 7x24',648.46,15),
('A28KWVR-7','Visita Rev o Arranque, Capacidad 8TR, T. RESP/H. ATEN 7x24',760.69,15),
('A35KWVR-7','Visita Rev o Arranque, Capacidad 10TR, T. RESP/H. ATEN 7x24',845.82,15),
('A45KWVR-7','Visita Rev o Arranque, Capacidad 13TR, T. RESP/H. ATEN 7x24',936.62,15),
('A56KWVR-7','Visita Rev o Arranque, Capacidad 16TR, T. RESP/H. ATEN 7x24',1029.41,15),
('A70KWVR-7','Visita Rev o Arranque, Capacidad 20TR, T. RESP/H. ATEN 7x24',1137.35,15),
('A91KWVR-7','Visita Rev o Arranque, Capacidad 26TR, T. RESP/H. ATEN 7x24',1176.73,15),
('A105KWVR-7','Visita Rev o Arranque, Capacidad 30TR, T. RESP/H. ATEN 7x24',1440.20,15),
('PE1500KCAL-7','Tipo de serv. AFINACION, Capacidad1500 KW, Horario Atención 7x24',1044.90,18),
('PE1500KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad1500 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',3831.30,18),
('PE1500KPM-7','Tipo de serv. Puesta en Marcha, Capacidad1500 KW, Horario Atención 7x24',696.60,18),
('PE100KCAL-7','Tipo de serv. AFINACION, Capacidad100 KW, Horario Atención 7x24',729.00,18),
('PE100KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad100 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',2673.00,18),
('PE100KPM-7','Tipo de serv. Puesta en Marcha, Capacidad100 KW, Horario Atención 7x24',486.00,18),
('PE125KCAL-7','Tipo de serv. AFINACION, Capacidad125 KW, Horario Atención 7x24',729.00,18),
('PE125KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad125 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',2673.00,18),
('PE125KPM-7','Tipo de serv. Puesta en Marcha, Capacidad125 KW, Horario Atención 7x24',486.00,18),
('PE175KCAL-7','Tipo de serv. AFINACION, Capacidad175 KW, Horario Atención 7x24',729.00,18),
('PE175KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad175 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',2673.00,18),
('PE175KPM-7','Tipo de serv. Puesta en Marcha, Capacidad175 KW, Horario Atención 7x24',486.00,18),
('PE1000KCAL-7','Tipo de serv. AFINACION, Capacidad1000 KW, Horario Atención 7x24',947.70,18),
('PE1000KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad1000 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',3474.90,18),
('PE1000KPM-7','Tipo de serv. Puesta en Marcha, Capacidad1000 KW, Horario Atención 7x24',631.80,18),
('PE200KCAL-7','Tipo de serv. AFINACION, Capacidad200 KW, Horario Atención 7x24',850.50,18),
('PE200KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad200 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',3118.50,18),
('PE200KPM-7','Tipo de serv. Puesta en Marcha, Capacidad200 KW, Horario Atención 7x24',567.00,18),
('PE2000KCAL-7','Tipo de serv. AFINACION, Capacidad2000 KW, Horario Atención 7x24',1044.90,18),
('PE2000KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad2000 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',3831.30,18),
('PE2000KPM-7','Tipo de serv. Puesta en Marcha, Capacidad2000 KW, Horario Atención 7x24',696.60,18),
('PE300KCAL-7','Tipo de serv. AFINACION, Capacidad300 KW, Horario Atención 7x24',850.50,18),
('PE300KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad300 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',3118.50,18),
('PE300KPM-7','Tipo de serv. Puesta en Marcha, Capacidad300 KW, Horario Atención 7x24',567.00,18),
('PE400KCAL-7','Tipo de serv. AFINACION, Capacidad400 KW, Horario Atención 7x24',850.50,18),
('PE400KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad400 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',3118.50,18),
('PE400KPM-7','Tipo de serv. Puesta en Marcha, Capacidad400 KW, Horario Atención 7x24',567.00,18),
('PE40KCAL-7','Tipo de serv. AFINACION, Capacidad40 KW, Horario Atención 7x24',729.00,18),
('PE40KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad40 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',2673.00,18),
('PE40KPM-7','Tipo de serv. Puesta en Marcha, Capacidad40 KW, Horario Atención 7x24',486.00,18),
('PE500KCAL-7','Tipo de serv. AFINACION, Capacidad500 KW, Horario Atención 7x24',850.50,18),
('PE500KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad500 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',3118.50,18),
('PE500KPM-7','Tipo de serv. Puesta en Marcha, Capacidad500 KW, Horario Atención 7x24',567.00,18),
('PE600KCAL-7','Tipo de serv. AFINACION, Capacidad600 KW, Horario Atención 7x24',947.70,18),
('PE600KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad600 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',3474.90,18),
('PE600KPM-7','Tipo de serv. Puesta en Marcha, Capacidad600 KW, Horario Atención 7x24',631.80,18),
('PE60KCAL-7','Tipo de serv. AFINACION, Capacidad60 KW, Horario Atención 7x24',729.00,18),
('PE60KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad60 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',2673.00,18),
('PE60KPM-7','Tipo de serv. Puesta en Marcha, Capacidad60 KW, Horario Atención 7x24',486.00,18),
('PE80KCAL-7','Tipo de serv. AFINACION, Capacidad80 KW, Horario Atención 7x24',729.00,18),
('PE80KCM-47-4','Tipo de serv. MTTO. PREV, Capacidad80 KW, Horario Atención 7x24 TR 4/12hrs Loc/for',2673.00,18),
('PE80KPM-7','Tipo de serv. Puesta en Marcha, Capacidad80 KW, Horario Atención 7x24',486.00,18);

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

-- -----------------------------------------------------------------------------
-- File:	blackstarConst_CreateSchema.sql    
-- Name:	blackstarConst_CreateSchema
-- Desc:	Crea una version inicial de la base de datos de constatnes
-- Auth:	Sergio A Gomez
-- Date:	20/12/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    20/12/2014  SAG  	Version inicial.
-- ---------------------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS blackstarConst ;

CREATE TABLE IF NOT EXISTS blackstarConst.location(
  _id INT NOT NULL AUTO_INCREMENT,
  zipCode VARCHAR(20) NOT NULL,
  country TEXT NOT NULL,
  state TEXT NOT NULL,
  municipality TEXT NOT NULL,
  city TEXT,
  neighborhood TEXT NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;



