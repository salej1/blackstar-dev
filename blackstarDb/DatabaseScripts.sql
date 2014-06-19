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
-- 27	11/02/2014	SAG 	Se modifica:
--								blackstarDb.GetPersonalServiceOrders
-- -----------------------------------------------------------------------------
-- 28	12/02/2014	SAG 	Se reemplaza:
--								blackstarDb.GetEquipmentTypeBySOId por
--								blackstarDb.GetServiceOrderTypeBySOId
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
		INNER JOIN serviceOrderEmployee se ON so.serviceOrderId = se.serviceOrderId
	where serviceStatus IN ('NUEVO', 'PENDIENTE')
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

	-- Asignacion del dueÃ±o del ticket
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
-- 1    08/08/2013  SAG  	Se aumenta el tamaÃ±o de ticket.serialNumber
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
-- 1    08/04/2014	DCB		Se Integran los SP iniciales:
--							bloomDb.getBloomPendingTickets
--							bloomDb.getBloomTickets
--							bloomDb.getBloomDocumentsByService
-- 							bloomDb.getBloomProjects
-- 							bloomDb.getBloomApplicantArea
-- 							bloomDb.getBloomServiceType
-- 							bloomDb.getBloomOffice

-- 							bloomDb.GetNextInternalTicketNumber
-- 							bloomDb.AddInternalTicket
-- 							bloomDb.AddMemberTicketTeam
-- 							bloomDb.AddDeliverableTrace


--		08/04/2014			bloomDb.GetUserData (MODIFICADO:Sobrescribimos la version anterior)
--							bloomDb.getBloomEstatusTickets
-- 19    16/05/2014  OMA	bloomDb.GetBloomSupportAreasWithTickets
-- 20    16/05/2014  OMA	bloomDb.GetBloomStatisticsByAreaSupport
-- 21    16/05/2014  OMA	bloomDb.GetBloomPercentageTimeClosedTickets
-- 22    16/05/2014  OMA	bloomDb.GetBloomPercentageEvaluationTickets
-- 23    16/05/2014  OMA	bloomDb.GetBloomNumberTicketsByArea
-- 24    16/05/2014  OMA	bloomDb.GetBloomUnsatisfactoryTicketsByUserByArea
-- 25    16/05/2014  OMA	bloomDb.GetBloomHistoricalTickets
-- 26    13/06/2014  OMA	bloomDb.getBloomAdvisedUsers
--
-- ------------------------------------------------------------------------------


use blackstarDb;



DELIMITER $$


-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomPendingTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomPendingTickets$$
CREATE PROCEDURE blackstarDb.getBloomPendingTickets(UserId INTEGER)
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
WHERE tm.workerRoleTypeId=1 and tm.blackstarUserId=UserId;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomTickets vista para el coordinador.
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomTickets$$
CREATE PROCEDURE blackstarDb.getBloomTickets(UserId INTEGER)
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

select a._id as id, a.name as label from bloomDeliverableType a
WHERE a.serviceTypeId =paramServiceTypeId
AND a._id != -1
ORDER BY a._id;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomProjects
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomProjects$$
CREATE PROCEDURE blackstarDb.getBloomProjects()
BEGIN

	SELECT DISTINCT project AS id,project label
	FROM blackstarDb.policy
		WHERE startDate <= NOW() AND NOW() <= endDate
	ORDER BY project;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomApplicantArea
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomApplicantArea$$
CREATE PROCEDURE blackstarDb.getBloomApplicantArea()
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
  createdByUsr Int(11),
  reponseInTime Tinyint,
  additionalInformation1 Varchar(2500),
  additionalInformation2 Varchar(2500),
  additionalInformation3 Varchar(2500),
  additionalInformation4 Varchar(2500),
  additionalInformation5 Varchar(2500)
  )
BEGIN
	INSERT INTO bloomTicket
(applicantUserId,officeId,serviceTypeId,statusId,
applicantAreaId,dueDate,project,ticketNumber,
description,created,createdBy,createdByUsr,reponseInTime,
additionalInformation1,additionalInformation2,additionalInformation3,
additionalInformation4,additionalInformation5)
VALUES
(applicantUserId,officeId,serviceTypeId,statusId,
applicantAreaId,dueDate,project,ticketNumber,
description,created,createdBy,createdByUsr,reponseInTime,
additionalInformation1,additionalInformation2,additionalInformation3,
additionalInformation4,additionalInformation5);
select LAST_INSERT_ID();
END$$




-- -----------------------------------------------------------------------------
	-- blackstarDb.AddMemberTicketTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddMemberTicketTeam$$
CREATE PROCEDURE blackstarDb.AddMemberTicketTeam (  
  ticketId Int(11),
  workerRoleTypeId Int(11),
  blackstarUserId Int(11))
BEGIN
	INSERT INTO bloomTicketTeam
(ticketId,workerRoleTypeId,blackstarUserId,assignedDate)
VALUES
(ticketId,workerRoleTypeId,blackstarUserId,CURRENT_TIMESTAMP());
select LAST_INSERT_ID();
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddDeliverableTrace
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddDeliverableTrace$$
CREATE PROCEDURE blackstarDb.AddDeliverableTrace (  
  bloomTicketId Int(11),
  deliverableTypeId Int(11),
  delivered Int(11),
  dateDeliverableTrace Datetime)
BEGIN
	INSERT INTO bloomDeliverableTrace
(bloomTicketId,deliverableTypeId,delivered,date)
VALUES
(bloomTicketId,deliverableTypeId,delivered,dateDeliverableTrace);
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
					AND t.statusId=5
					AND bu.blackstarUserId <> t.createdByUsr -- que no sea el creador
					AND ug.userGroupId NOT IN (3,4)  -- No se del perfil de mesa de ayuda, ni coordinador
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
CREATE PROCEDURE blackstarDb.GetBloomStatisticsByAreaSupport(userGroupIdParam INT, groupName VARCHAR(100),startCreationDate Datetime,endCreationDate Datetime)
BEGIN

  DECLARE maxTimeRes DECIMAL(12,2) DEFAULT 0;
  DECLARE minTimeRes DECIMAL(12,2) DEFAULT 0;
  DECLARE promTimeRes DECIMAL(12,2) DEFAULT 0;
  DECLARE sumaTotalTimeResp DECIMAL(12,2) DEFAULT 0;
  DECLARE totalTicket INT DEFAULT 0;
  DECLARE exit_flag INT DEFAULT 0;
  DECLARE bloomTicketIdParam INT;
  -- DECLARE tmpLog Varchar(50000);
	
	
  -- lista de tickets del followUp de una area de apoyo especifica	
  DECLARE listTicketsCursor CURSOR FOR   SELECT f.bloomTicketId FROM followUp f
								INNER JOIN blackstarUser bu ON (f.asignee=bu.email)
								INNER JOIN blackstarUser_userGroup bug ON (bu.blackstarUserId=bug.blackstarUserId)
								INNER JOIN userGroup ug ON (ug.userGroupId=bug.userGroupId)
								INNER JOIN bloomTicket t ON (t._id=f.bloomTicketId)
								WHERE f.bloomTicketId IS NOT NULL
								AND t.statusId=5 -- ticktes cerrados
								AND ug.userGroupId= userGroupIdParam -- id perfil groupId
								AND t.created>= startCreationDate
								AND t.created <= endCreationDate
								GROUP BY f.bloomTicketId;

  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET exit_flag = 1;


-- SET tmpLog='';

-- SET tmpLog= CONCAT(tmpLog, 'userGroupIdParam:');	
-- SET tmpLog= CONCAT(tmpLog, userGroupIdParam);	


OPEN listTicketsCursor;	

               timeRespLoop:  LOOP

				FETCH listTicketsCursor INTO bloomTicketIdParam;

				IF exit_flag = 1 THEN LEAVE timeRespLoop; END IF;
				
				-- SET tmpLog= CONCAT(tmpLog, ' * TicketID:');	
				-- SET tmpLog= CONCAT(tmpLog, bloomTicketIdParam);	

				 BLOCK2: begin

					DECLARE detailTicketId INT;
					DECLARE detailEmailUser VARCHAR(100);
					DECLARE detailCreateDate DATETIME;
					DECLARE detailUserGroupId INT;
					
					DECLARE beforeDetailTicketId INT;
					DECLARE beforeDetailEmailUser VARCHAR(100);
					DECLARE beforeDetailCreateDate DATETIME;
					DECLARE beforeDetailUserGroupId INT;

					DECLARE existRows INT DEFAULT 0;
					
					DECLARE sumaDetailFollowTimeResp DECIMAL(12,2) DEFAULT 0;
					
					DECLARE difMinutes INT;

					DECLARE exit_flag2 INT DEFAULT 0;

					-- lista de seguimiento de un tickets especifico para sumar tiempos
					DECLARE ticketFollowDetailCursor CURSOR FOR  SELECT f.bloomTicketId, f.asignee, f.created, ug.userGroupId FROM followUp f 
								INNER JOIN blackstarUser bu ON (f.asignee=bu.email)
								INNER JOIN blackstarUser_userGroup bug ON (bu.blackstarUserId=bug.blackstarUserId)
								INNER JOIN userGroup ug ON (ug.userGroupId=bug.userGroupId)
								WHERE f.bloomTicketId=bloomTicketIdParam
								ORDER BY f.bloomTicketId, f.created; 	

					DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET exit_flag2 = 1;
					
					 OPEN ticketFollowDetailCursor;	

					 detailFollowLoop: LOOP
					
						 
						FETCH ticketFollowDetailCursor INTO detailTicketId,detailEmailUser,detailCreateDate,detailUserGroupId;
						IF exit_flag2 = 1 THEN LEAVE detailFollowLoop; END IF;				
					
						 -- SET tmpLog= CONCAT(tmpLog, ' *[ BloomID:');
						 -- SET tmpLog= CONCAT(tmpLog, detailTicketId);	
						 -- SET tmpLog= CONCAT(tmpLog, ' Email:');	
						 -- SET tmpLog= CONCAT(tmpLog, detailEmailUser);	
						 -- SET tmpLog= CONCAT(tmpLog, ' Fecha:');	
						 -- SET tmpLog= CONCAT(tmpLog, detailCreateDate);	
						 -- SET tmpLog= CONCAT(tmpLog, ' Grupo:');	
						 -- SET tmpLog= CONCAT(tmpLog, detailUserGroupId);	
						 -- SET tmpLog= CONCAT(tmpLog, ' ]');

							

						IF(detailUserGroupId = userGroupIdParam) THEN
							
							-- SET tmpLog= CONCAT(tmpLog, '* -F Set Before items');

							SET beforeDetailTicketId = detailTicketId;
							SET beforeDetailEmailUser = detailEmailUser;
							SET beforeDetailCreateDate = detailCreateDate;
							SET beforeDetailUserGroupId = detailUserGroupId;

							SET existRows = existRows +1;

						 -- SET tmpLog= CONCAT(tmpLog, ' * (BB BloomID:');
						 -- SET tmpLog= CONCAT(tmpLog, beforeDetailTicketId);	
						 -- SET tmpLog= CONCAT(tmpLog, ' BB Email:');	
						 -- SET tmpLog= CONCAT(tmpLog, beforeDetailEmailUser);	
						 -- SET tmpLog= CONCAT(tmpLog, ' BB Fecha:');	
						 -- SET tmpLog= CONCAT(tmpLog, beforeDetailCreateDate);	
						 -- SET tmpLog= CONCAT(tmpLog, ' BB Grupo:');	
						 -- SET tmpLog= CONCAT(tmpLog, beforeDetailUserGroupId);	
						 -- SET tmpLog= CONCAT(tmpLog, ' )');


						ELSE
							

							IF(existRows > 0) THEN
							
							-- sacar la diferencia 
							SET difMinutes = TIMESTAMPDIFF(MINUTE,beforeDetailCreateDate,detailCreateDate);
						
							-- sumarla a sumaDetailFollowTimeResp
							SET sumaDetailFollowTimeResp = sumaDetailFollowTimeResp + difMinutes;

							 -- SET tmpLog= CONCAT(tmpLog, ' *-F sacar la diferencia y sum ');
							 -- SET tmpLog= CONCAT(tmpLog, ' *-F ');
							 -- SET tmpLog= CONCAT(tmpLog, beforeDetailCreateDate);
							 -- SET tmpLog= CONCAT(tmpLog, ' *-F ');
							 -- SET tmpLog= CONCAT(tmpLog, detailCreateDate);
							 -- SET tmpLog= CONCAT(tmpLog, ' *-F difMinutes:');
							 -- SET tmpLog= CONCAT(tmpLog, difMinutes);
							 -- SET tmpLog= CONCAT(tmpLog, ' *-F sumaDetailFollowTimeResp:');
							 -- SET tmpLog= CONCAT(tmpLog, sumaDetailFollowTimeResp);

							END IF;

						END IF;

						 

					 END LOOP detailFollowLoop;

					CLOSE ticketFollowDetailCursor;

					-- Se actualiza maximo
					IF(sumaDetailFollowTimeResp > maxTimeRes) THEN
						SET maxTimeRes=sumaDetailFollowTimeResp;
					END IF;
					
					-- Se actualiza minimo
					IF(sumaDetailFollowTimeResp < minTimeRes) THEN
						SET minTimeRes=sumaDetailFollowTimeResp;
					END IF;

					-- si hace falta se corrige el valor minimo
					IF(minTimeRes = 0) THEN
						SET minTimeRes=maxTimeRes;
					END IF;


					-- suma para el promedio y contador
					SET sumaTotalTimeResp = sumaTotalTimeResp + sumaDetailFollowTimeResp;
					SET totalTicket = totalTicket + 1;

					-- SET tmpLog= CONCAT(tmpLog, ' *-F maxTimeRes:');
					-- SET tmpLog= CONCAT(tmpLog, maxTimeRes);
					-- SET tmpLog= CONCAT(tmpLog, ' *-F minTimeRes:');
					-- SET tmpLog= CONCAT(tmpLog, minTimeRes);
					-- SET tmpLog= CONCAT(tmpLog, ' *-F sumaTotalTimeResp:');
					-- SET tmpLog= CONCAT(tmpLog, sumaTotalTimeResp);
					-- SET tmpLog= CONCAT(tmpLog, ' *-F totalTicket:');
					-- SET tmpLog= CONCAT(tmpLog, totalTicket);
					
				
				END BLOCK2;


 
               END LOOP timeRespLoop;  

	 CLOSE listTicketsCursor;	


		-- sacamos promedio
		IF(sumaTotalTimeResp > 0) THEN
			SET promTimeRes = sumaTotalTimeResp/totalTicket;
		ELSE
			SET promTimeRes = 0;
		END IF;

		-- SET tmpLog= CONCAT(tmpLog, ' *-F promTimeRes:');
		-- SET tmpLog= CONCAT(tmpLog, promTimeRes);


		-- select tmpLog as log;
		
		-- resultado por area
		SELECT groupName,(maxTimeRes/60) AS maxTime, (minTimeRes/60) minTime,  (promTimeRes/60) promTime; 


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
		where t.statusId=5 -- tickets cerrados
		AND t.created>= startCreationDate
		AND t.created <= endCreationDate
		and date(t.responseDate) <= t.dueDate) as satisfactory);

	SET noTicketsUnsatisfactory = (select count(id) from (
		select t._id as id, t.created ,t.dueDate,t.responseDate,date(t.responseDate),t.statusId from bloomTicket t
		where t.statusId=5 -- tickets cerrados 
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
		where t.evaluation>=initEvaluationValue
		AND t.statusId=5 -- tickets cerrados
		AND t.created>= startCreationDate
		AND t.created <= endCreationDate
		) as evaluation);

	SET noTicketsEvaluationUnsatisfactory = (select count(id) from (
		select t._id as id, t.evaluation, t.created ,t.dueDate,t.responseDate,date(t.responseDate),t.statusId from bloomTicket t
		where t.evaluation<initEvaluationValue
		AND t.statusId=5 -- tickets cerrados
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
						AND t.statusId=5 -- tickets cerrados
						AND t.created>= startCreationDate
						AND t.created <= endCreationDate
						AND bu.blackstarUserId <> t.createdByUsr -- que no sea el creador
						AND ug.userGroupId NOT IN (3,4) -- que no sea de mesa de ayuda ni coordiandor
						GROUP BY f.bloomTicketId
	) AS ticketsByArea
	GROUP BY userGroup;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomUnsatisfactoryTicketsByUserByArea
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomUnsatisfactoryTicketsByUserByArea$$
CREATE PROCEDURE blackstarDb.GetBloomUnsatisfactoryTicketsByUserByArea(initEvaluationValue INT,userGroupId INT,startCreationDate Datetime,endCreationDate Datetime)

BEGIN

	SELECT userName, COUNT(ticketId) as noTickets FROM( 
	SELECT f.bloomTicketId AS ticketId, bu.blackstarUserId AS userId, bu.name AS userName FROM followUp f
									INNER JOIN blackstarUser bu ON (f.asignee=bu.email)
									INNER JOIN blackstarUser_userGroup bug ON (bu.blackstarUserId=bug.blackstarUserId)
									INNER JOIN userGroup ug ON (ug.userGroupId=bug.userGroupId)
									INNER JOIN bloomTicket t ON (t._id=f.bloomTicketId)
									WHERE f.bloomTicketId IS NOT NULL
									AND t.evaluation < initEvaluationValue -- limite inicial para evaluacion satisfactoria
									AND t.statusId=5     -- tickets cerrados
									AND t.created>= startCreationDate
									AND t.created <= endCreationDate
									AND ug.userGroupId= userGroupId -- ingenieria de servicio(5) o otra area
									GROUP BY f.bloomTicketId,bu.blackstarUserId,bu.name
	  ) AS report
	GROUP BY userName;

END$$



-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomHistoricalTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomHistoricalTickets$$
CREATE PROCEDURE blackstarDb.GetBloomHistoricalTickets(statusTicket INT,startCreationDate VARCHAR(50),endCreationDate VARCHAR(50))
BEGIN

DECLARE tmp1 VARCHAR(800);
DECLARE tmp2 VARCHAR(50);
DECLARE tmp3 VARCHAR(50);
DECLARE tmp4 VARCHAR(50);
DECLARE tmp5 VARCHAR(1500);

SET tmp1 = 'SELECT ti._id as id, ti.ticketNumber, ti.created, ti.applicantAreaId, ba.name as areaName, ti.serviceTypeId, st.name as serviceName, st.responseTime, ti.project, ti.officeId, o.officeName,ti.statusId, s.name as statusTicket FROM bloomTicket ti INNER JOIN bloomApplicantArea ba on (ba._id = ti.applicantAreaId) INNER JOIN bloomServiceType st on (st._id = ti.serviceTypeId) INNER JOIN office o on (o.officeId = ti.officeId) INNER JOIN bloomStatusType s on (s._id = ti.statusId) WHERE ti.created>=\'';
SET tmp2 = '\' AND ti.created <= \'';

IF statusTicket <> -1 THEN 
	SET tmp3 = CONCAT('\' AND ti.statusId= ', statusTicket);	
ELSE
	SET tmp3 = '\'';
END IF;				

SET tmp4 = ' ORDER BY ti.created DESC ';

SET @sqlv=CONCAT(tmp1,startCreationDate,tmp2,endCreationDate,tmp3,tmp4);

 PREPARE stmt FROM @sqlv;

EXECUTE stmt;
DEALLOCATE PREPARE stmt;

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

select u.blackstarUserId as id,u.name name, u.email email from blackstarUser u
inner join blackstarUser_userGroup ug on (u.blackstarUserId=ug.blackstarUserId)
inner join userGroup g on (g.userGroupId=ug.userGroupId)
inner join bloomAdvisedGroup ag on (ag.userGroupId=ug.userGroupId)
where ag.applicantAreaId=applicantAreaIdParam
and ag.serviceTypeId=serviceTypeIdParam;
	
END$$


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

CALL ExecuteTransfer();
-- -----------------------------------------------------------------------------
-- FIN - SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- Desc:Carga de datos inicial
-- Auth:Daniel Castillo
-- Date:20/03/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    AuthorDescription
-- --   --------   -------  ------------------------------------
-- 1    20/03/2014  DCB  	Version inicial. 
-- 2    08/05/2014  OMA  	ID secuencia tickets internos 
-- 3    08/05/2014  OMA  	Perfil Mesa de ayuda
-- ---------------------------------------------------------------------------
use blackstarDb;

-- -----------------------------------------------------------------------------
	-- CATALOGS
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
	-- SECUENCIA
-- -----------------------------------------------------------------------------
--secuencia para tinckets internos
INSERT INTO blackstarDb.sequence (sequenceTypeId,sequenceNumber) values('I',1);	


INSERT INTO bloomWorkerRoleType VALUES (1,'Responsable', 'Responsable de dar seguimiento al Ticket');
INSERT INTO bloomWorkerRoleType VALUES (2,'Colaborador', 'Personal de apoyo');

INSERT INTO bloomStatusType VALUES (1,'Abierto', 'Ingreso de solicitud');
INSERT INTO bloomStatusType VALUES (2,'En proceso', 'Asignado, en proceso de solucion');
INSERT INTO bloomStatusType VALUES (3,'Suspendido', 'Suspendido');
INSERT INTO bloomStatusType VALUES (4,'Cancelado', 'Cancelado');
INSERT INTO bloomStatusType VALUES (5,'Cerrado', 'Cerrado');


insert into blackstarDb.userGroup (userGroupId,externalId,name) values ('4', 'sysHelpDeskManager', 'Mesa de ayuda (Ingenieria)');
insert into blackstarDb.userGroup (userGroupId,externalId,name) values ('5', 'sysPurchaseManager', 'Jefe de Compras');
insert into blackstarDb.userGroup (userGroupId,externalId,name) values ('6', 'sysHRManager','Jefe de Capital Humano');
insert into blackstarDb.userGroup (userGroupId,externalId,name) values ('7', 'sysNetworkManager','Ingeniero de Redes y Monitoreo');
insert into blackstarDb.userGroup (userGroupId,externalId,name) values ('8', 'sysQAManager', ' Gerente de Calidad');
insert into blackstarDb.userGroup (userGroupId,externalId,name) values ('9', 'sysSalesManager', 'Gerente comercial');
            
insert into blackstarDb.userGroup (userGroupId,externalId,name) values ('10', 'sysCeo', 'Direccion');
insert into blackstarDb.userGroup (userGroupId,externalId,name) values ('11', 'sysPurchase', 'Compras');
insert into blackstarDb.userGroup (userGroupId,externalId,name) values ('12', 'sysHR', 'Capital Humano');
insert into blackstarDb.userGroup (userGroupId,externalId,name) values ('13', 'sysQA', 'Calidad');



-- lista solicitantes
INSERT INTO blackstarDb.bloomApplicantArea VALUES (1,'Ventas', 'Ventas');
INSERT INTO blackstarDb.bloomApplicantArea VALUES (2,'Implementación y Servicio', 'Implementación y Servicio');
INSERT INTO blackstarDb.bloomApplicantArea VALUES (3,'Gerentes o Coordinadoras al Area de Compras', 'Gerentes o Coordinadoras al Area de Compras');
INSERT INTO blackstarDb.bloomApplicantArea VALUES (4,'Personal con gente a su cargo', 'Personal con gente a su cargo');
INSERT INTO blackstarDb.bloomApplicantArea VALUES (5,'General', 'General');
 
   
-- Solicitante:Ventas, Lista de tipo de servicios
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (1,1,7,'Levantamiento', 'Levantamiento');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (2,1,7,'Apoyo de Ingeniero de Soprte o Apoyo de Servicio', 'Apoyo de Ingeniero de Soprte o Apoyo de Servicio');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (3,1,4,'Elaboración de Diagrama CAD', 'Elaboración de Diagrama CAD');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (4,1,4,'Elaboración de Plano e Imágenes 3D del SITE', 'Elaboración de Plano e Imágenes 3D del SITE');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (5,1,4,'Realización de Cédula de Costos', 'Realización de Cédula de Costos');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (6,1,2,'Pregunta técnica', 'Pregunta técnica');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (7,1,4,'Solicitud de Aprobación de Proyectos Mayores a 50KUSD y con mínimo 3 líneas diferentes', 'Solicitud de Aprobación de Proyectos Mayores a 50KUSD y con mínimo 3 líneas diferentes');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (8,1,4,'Solicitud de Precio de Lista de algún producto que no se encuentre en lista de precio', 'Solicitud de Precio de Lista de algún producto que no se encuentre en lista de precio');
                                                                   
                                                                   
-- Solicitante:Implementación y Servicio, Lista de tipo de servicios                                                                
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (9, 2,4,'Elaboración de Diagrama CAD o de Plano en 3D', 'Elaboración de Diagrama CAD o de Plano en 3D');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (10,2,4,'Reporte de Cálidad de Energía', 'Reporte de Cálidad de Energía');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (11,2,8,'Soporte en Monitoreo y/o desarrollo de mapeo', 'Soporte en Monitoreo y/o desarrollo de mapeo');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (12,2,2,'Pregunta técnica', 'Pregunta técnica');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (13,2,8,'Requisición de Parte o Refacción', 'Requisición de Parte o Refacción');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (14,2,4,'Solicitud de Precio de Costo', 'Solicitud de Precio de Costo');
                                                  
                                                  
-- Solicitante:Gerentes o Coordinadoras al Area de Compras, Lista de tipo de servicios                                                   
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (15,3,11,'Requerimiento de Compra de Activos', 'Requerimiento de Compra de Activos');
                                                      
-- Solicitante:Personal con gente a su cargo, Lista de tipo de servicios                                                
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (16,4,5,'Aumento de sueldo', 'Aumento de sueldo');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (17,4,30,'Contratación de personal', 'Contratación de personal');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (18,4,5,'Nueva Creación', 'Nueva Creación');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (19,4,3,'Finiquito', 'Finiquito');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (20,4,2,'Acta Adminsitrativa', 'Acta Adminsitrativa');
                                                      
                                                      
-- Solicitante:General, Lista de tipo de servicios                                                    
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (21,5,5,'Req. de Curso', 'Req. de Curso');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (22,5,5,'Modificación del SGC', 'Modificación del SGC');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (23,5,5,'Sugerencia de Modificación', 'Sugerencia de Modificación');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (24,5,4,'Problemas con telefonía o con la red', 'Problemas con telefonía o con la red');
									  


INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (1,1,'CheckList de levantamiento', 'CheckList de levantamiento');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (2,1,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (3,2,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (4,3,'Diagrama en CAD', 'Diagrama en CAD');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (5,3,'Diagrama en PDF', 'Diagrama en PDF');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (6,3,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (7,4,'Imágenes de Plano en 3D', 'Imágenes de Plano en 3D');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (8,4,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (9,5,'Cédula de Costos', 'Cédula de Costos');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (10,5,'Cédula de Costos', 'Cédula de Costos');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (11,6,'Respuesta', 'Respuesta');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (12,6,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (13,7,'Aprobación o retroalimentación', 'Aprobación o retroalimentación');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (14,7,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (15,8,'Precio de Lista y Condiciones comerciales', 'Precio de Lista y Condiciones comerciales');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (16,8,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (17,9,'Diagrama en CAD o Imágenes de Plano en 3D', 'Diagrama en CAD o Imágenes de Plano en 3D');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (18,9,'Diagrama en PDF', 'Diagrama en PDF');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (19,9,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (20,10,'Reporte de Cálidad', 'Reporte de Cálidad');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (21,10,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (22,11,'Respuesta o desarrollo', 'Respuesta o desarrollo');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (23,11,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (24,12,'Respuesta', 'Respuesta');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (25,12,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (26,13,'Entrega de la parte', 'Entrega de la parte');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (27,13,'Orden de Compra', 'Orden de Compra');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (28,13,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (29,14,'Precio de Costo', 'Precio de Costo');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (30,14,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (31,15,'Entrega de Activos', 'Entrega de Activos');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (32,15,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (33,16,'Respuesta del incremento', 'Respuesta del incremento');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (34,16,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (35,17,'Nuevo personal', 'Nuevo personal');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (36,17,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (37,18,'Respuesta', 'Respuesta');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (38,18,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (39,19,'Baja del colaborador', 'Baja del colaborador');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (40,19,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (41,20,'Acta Administrativa personalizada', 'Acta Administrativa personalizada');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (42,21,'RESPUESTA DEL REQ.', 'RESPUESTA DEL REQ.');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (43,22,'RESPUESTA DEL REQ.', 'RESPUESTA DEL REQ.');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (44,23,'RESPUESTA DEL REQ.', 'RESPUESTA DEL REQ.');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (45,24,'Respuesta', 'Respuesta');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (46,24,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');


insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,1,9);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,2,4);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,2,9);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,3,4);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,3,9);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,4,4);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,4,9);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,5,4);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,5,9);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,6,4);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,6,9);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,7,4);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,7,9);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,8,4);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(1,8,9);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(2,9,4);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(2,10,4);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(2,11,4);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(2,11,7);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(2,12,4);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(2,13,4);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(2,13,11);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(2,14,4);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(3,15,11);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(4,16,12);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(4,16,10);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(4,17,12);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(4,17,10);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(4,18,12);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(4,18,10);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(4,19,12);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(4,19,10);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(4,20,12);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(4,20,10);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(5,21,12);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(5,21,10);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(5,22,13);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(5,22,10);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(5,23,13);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(5,23,10);
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroupId) values(5,24,11);





-- creacion de usuarios segun la confi,applicantAreaIdguracion del excel en la columna de enterados.
Call blackstarDb.UpsertUser('nicolas.andrade@gposac.com.mx','Nicolas Andrade');
Call blackstarDb.CreateUserGroup('sysSalesManager','Gerente comercial','nicolas.andrade@gposac.com.mx');
     
Call blackstarDb.UpsertUser('mesa-de-ayuda@gposac.com.mx','Mesa de ayuda');
Call blackstarDb.CreateUserGroup('sysHelpDeskManager','Mesa de ayuda (Ingenieria)','mesa-de-ayuda@gposac.com.mx');
     
Call blackstarDb.UpsertUser('jose.osorio@gposac.com.mx','Ingeniero de Redes y Monitoreo');
Call blackstarDb.CreateUserGroup('sysNetworkManager','Ingeniero de Redes y Monitoreo','jose.osorio@gposac.com.mx');
  
Call blackstarDb.UpsertUser('compras@gposac.com.mx','Compras');
Call blackstarDb.CreateUserGroup('sysPurchase','Compras','compras@gposac.com.mx');
  
Call blackstarDb.UpsertUser('capital.humano@gposac.com.mx','Capital Humano');
Call blackstarDb.CreateUserGroup('sysHR','Capital Humano','capital.humano@gposac.com.mx');
   
Call blackstarDb.UpsertUser('direccion@gposac.com.mx','Direccion');
Call blackstarDb.CreateUserGroup('sysCeo','Direccion','direccion@gposac.com.mx');
  
Call blackstarDb.UpsertUser('calidad@gposac.com.mx','Calidad');
Call blackstarDb.CreateUserGroup('sysQA','Calidad','calidad@gposac.com.mx');



-- -----------------------------------------------------------------------------
	-- UNKNOWN REFERENCES
-- -----------------------------------------------------------------------------
INSERT INTO office VALUES('?', 'DESCONOCIDA', null);
INSERT INTO blackstaruser VALUES (-1, 'unknown@gposac.com.mx', 'Usuario Bloom sin correspondencia');
INSERT INTO bloomServiceType VALUES (-1,'DESCONOCIDO', 'Tipo de servicio no registrado', 0);
INSERT INTO bloomApplicantArea VALUES (-1,'DESCONOCIDO', 'Area no registrada');

-- -----------------------------------------------------------------------------
	-- TEST TRANSFER
-- -----------------------------------------------------------------------------
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC1','Juan Pablo Procopio');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC2','Joel Paz');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC3','Joel Paz');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC3','para monitoreo Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC4','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC5','Joel Paz');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC6','Josue Ramirez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC7','Rogelio Valadez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC8','Jorge Chaves');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC9','Julio Lara');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC9','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC9','Rogelio Valadez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC11','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC11','Roberto Osorio');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC12','Luis Andrade');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC12','Ivan Martin');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC13','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC14','Jorge Martines');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC14','Luis Andrade');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC15','Josue Mrtinez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC15','Rufino Moctezuma');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC16','Rufino Moctezuma');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC17','Julio Lara');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC18','Juan Espinoza');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC19','Carlos Hernandez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC20','Joel Paz');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC20','Jorge Martinez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC21','Jorge Martines');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC21','Julio Lara');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC22','Juan Jose Espinoza');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC23','Jose Luis Esteva');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC24','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC25','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC25','Camilo Peña');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC26','Rogelio Valadez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC26','Joel Paz');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC27','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC28','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC28','Miguel Garcia');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC29','Miguel Garcia');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC30','Joel Paz');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC31','Oscar Huerta');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC32','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC33','Jose Luis Esteva');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC34','Joel Paz');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC34','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC35','Camilo Peña');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC36','Joel Paz');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC36','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC37','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC37','Juan Jose Espinoza');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC38','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC38','Juan Jose Espinoza');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC39','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC39','Juan Jose Espinoza');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC40','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC40','Rogelio Valadez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC40','Ivan Martinez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC41','Juan Jose Espinoza');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC42','Jorge Chavez ');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC43','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC43','Miguel Garcia');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC44','Jorge Alberto Martinez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC45','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC46','Carlos Bailon');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC46','Raul Perez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC47','Jose Ivan');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC47','Angeles Avila');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC48','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC48','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC49','Jorge Chaves');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC50','Julio Lara Reyes');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC50','Rogelio Valadez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC51','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC52','Claudia Rivera');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC52','Miguel Garcia');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC53','Martin');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC54','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC55','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC55','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC57','Joel Paz');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC58','Claudia Rivera');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC59','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC60','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC60','Miguel Garcia');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC61','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC61','Miguel Garcia');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC62','Oscar Huerta');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC63','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC64','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC64','Miguel Garcia');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC65','Raul Perez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC66','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC67','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC68','Salvador Ruvalacaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC69','Jorge chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC70','Julio Lara');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC70','Joel Paz');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC71','Salvador Ruvalacaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC71','Oscar Huerta');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC71','Raul Perez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC72','Jorge Cavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC72','Miguel Garcia');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC73','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC74','Claudia Rivera');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC75','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC76','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC77','Daniel Bravo');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC78','Claudia Rivera');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC79','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC79','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC80','Joirge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC81','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC81','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC82','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC82','Joel Paz');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC83','Luis Andrade');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC84','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC85','Joel Paz');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC86','Miguel Salinas');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC86','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC87','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC88','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC89','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC89','Raul Perez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC90','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC91','Raul Perez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC92','Claudia Rivera');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC93','Salvador Ruvalcaba');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC94','Claudia Rivera');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC95','Raul Perez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC95','Jorge Chavez');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC95','Miguel Garcia');
insert into `bloomTransferTicketTeam`(`ticketNumber`,`userName`) values ('SAC140',':uis Andrade');

insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-01-29 13:30:53','ivan.ramirez@gposac.com.mx','Area de Ventas','Levantamiento','','','2013-01-29 00:00:00','Se realiza levantamiento al cliente Baxter civac, sera realizado por el Ing. Juan Pablo Procopio, esto con el objeto de validar las instalaciones eléctricas dentro del site, el proyecto esta conformado por UPS de 20kva, 2 aires acondicionados y la implementación de un sistema de monitorio.  https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AobMHo1P0jzedHFReExteFB4Q3UzOHFVMFhLeGFQNFE#gid=0','','','','SAC1','2013-01-29 18:53:00','NO','','0.22369212963531027','0.7868055555591127','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-01 16:08:10','ivan.ramirez@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','','2013-02-01 00:00:00','se solicita apoyo para realizar cedula de costos los datos seran entregados al Ing. Joel Paz para la realizacion de la misma','','','','SAC2','2013-02-02 15:00:00','SI','','-0.9526620370379533','1.625','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-04 16:39:39','rogelio.valadez@gposac.com.mx','Area de Ventas','Pregunta técnica','','','2013-02-05 00:00:00','Se requiere su VoBo para ofertar el mantenimiento de 11 para un sistema de monitoreo Liebert, la información se muestra en: https://docs.google.com/a/gposac.com.mx/file/d/0BxpwtIK26_pSQ25EVFQ5OG5oTlE/edit  En caso afirmativo, indicar precio de venta.  Gracias','','','','SAC3',null,'NO','','-41309.69420138889','-41310','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-05 17:43:53','ivan.ramirez@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','','2013-01-06 00:00:00','SE REQUIERE COSTO DE BY PASS EXTERNO PARA UN EQUIPO UPS DE 100KVA MARCA MITSUBISHI    (REQUERIMENTO PARA EL PROYECTO CM253 DE DAIMLER)','','','','SAC4','2013-02-06 10:33:53','SI','','0.7013888888832298','31.44019675925665','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-06 10:13:43','jorge.martinez@gposac.com.mx','Area de Ventas','Solicitud de aprobación de proyectos mayores a 50 KUSD y con mínimo 3 líneas diferentes','','','2013-02-20 00:00:00','Revision de proyecto de implementacion de Aires Tipo Inrow en site de RCI en la Cd. de Mexico, se requiere reacomodar sus racks para formar el pasillo frio y caliente, contamos con un plano de Trayectorias Electricas, Unifilar Electrico (del UPS Symmetra de 80kva) que Grupo SAC elaboro en el 2006 y Un listado de Parametros electricos en donde se indica el consumo de corriente por un determinado lapso de meses, esta informacion la entregare a Ing. Joel Paz,  Ademas de este proyecto hay otro de renovacion de Plantas electricas aun no tengo el dato en cuanto tenga el contacto del encargado de este proyecto les hare llegar la informacion.','','','','SAC5','2013-02-09 14:25:00','NO','','3.1745023148178007','-10.399305555554747','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-07 16:14:54','rufino.moctezuma@gposac.com.mx','Area de Ventas','Levantamiento','','','2013-02-11 00:00:00','Se requiere apoyo a las 3:30pm para visita de levantamiento en Planta NowPak, en el Parque Bernardo Quintana, para proponer UPS´s y planta de emergencia.','','','','SAC6','2013-03-15 12:00:00','NO','','35.781319444446126','32.45833333333576','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-08 18:17:41','jorge.martinez@gposac.com.mx','Area de Ventas','Pregunta técnica','','','2013-02-18 00:00:00','Ing. Joel, Ing. Salvador,  Buena tarde, solicitu su apoyo para validar la solicitud que nos hace la empresa SERVICIOS Y PROVEEDURIA INDUSTRIAL S.A. DE C.V. ubicada en CALLE 53 No 414 COL.CALETA C.P. 24110 CD. DEL CARMEN CAMP.,  Ellos solicitan un listado de equipos de Precision: - Equipo de 10TR de expansion directa con su condensadora - 2 Equipos de 3TR de expansion directa con su condensadora  y algunos otros equipos de Aire acondicionado de confort, que supongo no estan dentro de nuestro interes vender ya que no seriamos competitivos,  a la empresa que nos lo solicita se lo solicito otra empresa que se dedica a la Construccion Mecanica y Civil, el cliente final es PEMEX, No se tiene el dato de quien esta especificando estos equipos ya que PEMEX solo les entrego la informacion de lo que requiere cotizar al parecer esto esta dirigido a otra linea, hay que revisar que puedamos cumplir y detectar posibles candados  No saben si es licitacion o un proyecto ya asignado, quedaron de investigar esa informacion para saber a que le apostamos en caso de decidir participar, les proporciono una copia de la solicitud de cotizacion que nos envian','','','','SAC7','2013-02-12 11:23:00','NO','','3.7120254629699048','-5.525694444440887','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-11 09:56:16','juanjose.espinoza@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','','2013-02-12 00:00:00','Buen día Requiero de su apoyo para el precio de los siguientes Interruptores que necesitan en INEGI. 1.- Marca: EATON  Modelo:KD3 5K. 2.- Marca: EATON  Modelo:HLD-DC.  Anexo fotografias de los Interruptores.  https://mail.google.com/mail/?ui=2&ik=6126beaaa3&view=att&th=13cb5278c7eea502&attid=0.2&disp=thd&realattid=1426324309188732225-2&zw  https://mail.google.com/mail/?ui=2&ik=6126beaaa3&view=att&th=13cb5278c7eea502&attid=0.1&disp=thd&realattid=1426324309188732225-1&zw ','','','','SAC8','2013-02-21 09:52:00','','','9.997037037035625','9.411111111112405','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-11 17:10:52','carlos.hernandez@gposac.com.mx','Area de Ventas','Levantamiento','','','2013-02-13 00:00:00','Que tal buen día;  Necesito del apoyo del área de implementación en el siguiente asunto;  Hace algunas semanas se acudio a un servicio de arranque de un equipo DataAire al hospital angeles en México DF, en el cual se cambiaron unas tarjetas al equipo para poder arrancarlo y las dañadas se retiraron, aunque aún cuando se cambiaron las tarjetas el equipo no arranco y se dieron cuenta que era un cable el que estaba dañado, el cual se cambio y se arranco el equipo, pero el cliente nos esta pidiendo que se prueben las tarjetas que se retiraron para ver si estan funcionales y de ser así se dejen las tarjetas originales, este tema ya lo plático el cliente con Rogelio y se quedo en el acuerdo de realizar dicha prueba.  De antemano les agradezco el apoyo y quedo en espera de su respuesta.  Saludos  ','','','','SAC9','2013-02-16 14:00:00','SI','','4.867453703707724','3.5833333333357587','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-12 11:33:15','juanjose.espinoza@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','','2013-02-13 00:00:00','Buen dia  Me pueden apoyar con el precio para el suministro e instalación de 96 baterías marca: CSB modelo: GP1272 con capacidad de 12V-7Ah en la ciudad de culiacan para la TAR de PEMEX por favor.','','','','SAC10',null,'','','-41317.48142361111','-41318','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-12 11:40:25','juanjose.espinoza@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','','2013-02-13 00:00:00','Buen día. INEGI se necesita agregar un nodo de red y un transductor para poder integrar un tablero de distribución  al central, (Tienen Power logic).  Me comenta Saul que el cable debe ser máximo de 2.5 mts.  ','','','','SAC11','2013-02-12 15:00:00','','','0.13859953703649808','-0.375','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-12 12:26:07','ivan.martin@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','','2013-02-14 00:00:00','cotizar un equipo Kitron la información que tengo es la siguiente:   -          Voltaje de opearacion 230 volts -          Capacidad del interruptor , 250 amp. -          El consumo que tiene por fase es de L1 54.2, L2 47.6, L3 53.1 -          El tablero esta en exterior junto al transformador. ','','','','SAC12','2013-02-14 13:00:00','Si','','2.0235300925924093','0.5416666666642413','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-12 12:55:40','ivan.martin@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','','2013-02-14 00:00:00','Transferencia para PE de 750 kw marca Caterpillar, transicion abierta, voltaje de operación de 480 volts, incluye solo el suministro de la transferencia.','','','','SAC13','2013-02-14 15:00:00','SI','','2.0863425925927004','0.625','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-12 14:47:14','jorge.martinez@gposac.com.mx','Area de Ventas','Elaboración diagrama en CAD (Se entregarán diagramas Genéricos, si se desea solicitar uno exacto se deberá requisitar vía una cédula de costos), Pregunta técnica','','','2013-03-01 00:00:00','Proyecto: "Fortalecimiento Centros de Computo PEMEX", Ing. Victor Portales de PEMEX, nos proporciono el dia de ayer la informacion de diferentes sitios: Coatzacoalcos, Minatitlan, Salamanca, Salina Cruz, Marina Site Carmen, Varios sites en la region Norte, Monterrey y reynosa, para proponer mejoras en su sistema de climatizacion es decir actualizar por nuevas tecnologias tipo Inrow, pasillos frios y calientes, contencion de Racks, se requiere proponer una solucion personalizada para cada site desde reacomodar sus cargas para optimizar espacio y hacer mas eficiente el enfriamiento con unidades pequeñas de aire y con la capacidad adecuada que requiere la carga,  Entregare la informacion proporcionada por PEMEX aIng. Joel Paz: - Listado de cargas - Plano de site - Fotos  Quedo a sus ordenes Gracias','','','','SAC14','2013-03-15 13:19:00','NO','','30.897060185183364','14.513194444443798','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-12 15:20:18','rufino.moctezuma@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','','2013-02-11 00:00:00','Que datos necesitamos para cotizar un estudio de calidad de la energía. Cliente           NowPack Ubicación       P.I. Bernardo Quintana Sub-Estación  750 KVA y 30 KVA F.P.               0.88 Si requieres mas información házmelo saber','','','','SAC15','2013-02-14 12:00:00','NO','','1.8609027777783922','3.5','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-13 13:25:58','rufino.moctezuma@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','','2013-02-14 00:00:00','Se requiere apoyo para terminar cedula de proyecto que comprende el suministro de un equipos UPS Mitsu de 50KVA Mod:M1100A-A-50-208-208-1 con banco de baterias para 30 min, necesito el costo de traslado del equipo a CFE Lazaro Cardenas, Mich., costo de instalación, arranque y pruebas al equipo.  Si se necesita mas información, háganme saber. Quedo a sus ordenes y al pendiente de sus comentarios,   Saludos y gracias.','','','','SAC16','2013-02-14 15:00:00','NO','','1.0653009259258397','0.625','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-13 18:28:59','jorge.martinez@gposac.com.mx','Area de Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-02-15 00:00:00','Solicitud de revision y diagnostico de equipo UPS APC de 8Kva Ubicado en Torre Ejecutiva piso 25, reportado por Ing. Victor Portales','','','','SAC17','2013-02-15 16:30:00','SI','','1.917372685187729','0.6875','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-15 12:46:55','juanjose.espinoza@gposac.com.mx','Area de Ventas','Levantamiento','','',null,'Buen día Necesito me puedan apoyar para un Levantamiento en Flextronics Planta norte en Zapopan Jalisco. ','','','','SAC18','2013-02-16 15:00:00','SI','','1.0924189814832062','0','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-15 18:15:59','carlos.hernandez@gposac.com.mx','Area de Ventas','Levantamiento','','','2013-02-20 00:00:00','Se requiere el apoyo de ingenieria para realizar un levantamiento en Manzanillo con el prospecto Puerto Internacional de Manzanillo, el cliente nos mostrará sus sites y necesitamos realizar una porpuesta de reacondicionamiento de los mismos.','','','','SAC19',null,'','','-41320.761099537034','-41325','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-19 18:35:06','jorge.martinez@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','','2013-02-21 00:00:00','Ing. Joel Paz,  Favor de realizar cedula de costos para proyecto de reinstalacion de aire de 30TR para PEMEX urge con motivo del incidente que se presento en sus instalaciones y como consecuencia tienen que reubicar los SITES del B1 y B2, le envio la lista de materiales que viene en las bases que nos envia PEMEX y la cedula de proyectos que elaboramos el año pasado, saludos','','','','SAC20','2013-02-21 13:30:00','SI','','1.7881249999991269','0.5625','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-20 09:27:02','jorge.martinez@gposac.com.mx','Area de Ventas','Levantamiento, Realización de Cedula de Costos ','','','2013-02-22 00:00:00','Favor de realizar visita a Azcapotzalco y Manina Nacional No. 329, Edificio C y B1  Para verificar que la cantidad y el tipo de Baterias de baterías de cada banco del listado de equipos de abajo:  - Los UPS''s de 80 KVA (2) son los de Azcapotzalco y llevan un solo banco  - Los UPS''s de 160 KVA PowerWare (2)  son los del sótano del 4C y llevan dos bancos  - El UPS de 225 KVA MGE (1) es el que está en el 4o piso del C y lleva dos bancos.  - Los UPS''s de 40 KVA PowerWare (2) son los que están en el 1er  piso del B1 y llevan un banco,   - un banco de baterías para el UPS de 50 KVA power ware que está en Azcapo planta alta,   De la mayoria ya se tiene informacion solo hay que validar, este requerimiento URGE para dar presupuesto esta semana, gracias  quedo a sus ordenes para cualquier comentario y/o duda,   saludos','','','','SAC21','2013-02-22 15:25:00','SI','','2.2485879629603005','0.6423611111094942','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-21 10:38:06','juanjose.espinoza@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','',null,'Buen dia. De la TAR de Parral me están pidiendo un supresor de picos de la marca Dynatron modelo SMM502-ED.  5.0 KVA-KW    In:127 vca   Out: 120+-1% vca    Les pido que me apoyen a saber y cotizar un PQ que cumpla con esta características, ya que me comenta el cliente que quiere sacar la PO esta semana. ','','','','SAC22','2013-02-24 12:00:00','SI','','3.0568750000020373','0','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-26 11:53:43','carlos.hernandez@gposac.com.mx','Area de Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-02-27 00:00:00','Se requiere que el Ing. Salvador Ruvalcaba nos acompañe a una cita el día de mañana 27-02-13 a las instalaciones de CFE en Guadalajara, para ver los requerimientos del cliente acerca de un proyecto.','','','','SAC23',null,'NO','','-41331.49563657407','-41332','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-26 12:08:45','juanjose.espinoza@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','',null,'Buen día  Me pueden apoyar a cotizar a un cliente la reparación de un motor para minisplit, es para PEMEX Tepic, pero me comentan que el equipo no esta en contrato,    MOTOR ELÉCTRICA MARCA: BALDOR GRUPO 1 CLASE D, POTENCIA ¾ H.P. VOLTAJE 100/230 AMPERAJE 11.4/5.7 1140 RPM. ROTOR AMARRADO ','','','','SAC24','2013-03-09 15:30:00','NO','','11.139756944445253','0','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-26 17:39:01','juanjose.espinoza@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','',null,'Buen dia  Me pueden apoyar a realizar una cedula de costos para 96 Baterias marcas CSB de 12V 5AH y el flete para Mazatlan. (Es para un UPS APC SUR15000)  De igualforma 96 Baterias marcas CSB de 12V 7AH y el flete para Culiacan. Asi como la instalacion  (Es para un UPS POWERWARE)','','','','SAC25','2013-03-01 12:00:00','NO','','2.764571759260434','0','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-27 11:02:09','jorge.martinez@gposac.com.mx','Area de Ventas','Pregunta técnica','','','2012-02-27 00:00:00','Solicitud de revision de "Apartado Tecnico UMAS 90 TR 4C" de PEMEX para elaborar propuesta Tecnica que se requiere de manera urgente para el dia de hoy entregar cotizacion a PEMEX','','','','SAC26','2013-02-27 11:00:00','NO','','0.0014930555553291924','366.45833333333576','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-27 11:29:39','jorge.martinez@gposac.com.mx','Area de Ventas','Realización de Cedula de Costos ','','','2013-02-27 00:00:00','Solicitud de precio de subestacion de 500kw a 480v, para instalar en PEMEX en  exrefineria 18 de marzo, Azcapotzalco','','','','SAC27','2013-03-14 15:20:00','SI','','15.118298611108912','15.597222222218988','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-27 17:32:20','rufino.moctezuma@gposac.com.mx','Ventas','Pregunta técnica','','','2013-02-27 00:00:00','Solicito por favor precio de UPS Mitsubishi Modelo 2033C de 10KVA, con el tiempo de respaldo minimo   Requiero precio de flete de los siguientes equipos: 1.- 1 Pieza, UPS Mitsu 1100 - 20 kVA, Input/Output Voltage: 208/208, Part Number M1100A-A-20-208-208-1B, Dimensions (W x D x H) inches 19.7 x 27.0 x 55.1, Total System Weight (lbs) 730  2.- 1 Pieza, UPS Mitsu 9900 - 150 kVA, Input/Output Voltage: 480/480, Part Number M9900A-A-150-480-480+BBMS10M, Dimensions (W x D x H) inches 35.4" x 32.5" x 80.6", Total System Weight (lbs) 1,146  3.- 1 Pieza, UPS Mitsu 7011A-60 - 6 kVA, Input/Output Voltage: 240/120V (1 Phase), 208/120V (2 Phase), Part Number M9900A-A-150-480-480+BBMS10M, Dimensions (W x D x H) inches 13.8" x 29.9" x 27.8", Total System Weight (lbs) 307  Quedo al pendiente, gracias. ','','','','SAC28','2013-02-28 16:30:00','SI','','-0.9567129629649571','1.6875','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-27 17:37:28','rufino.moctezuma@gposac.com.mx','Ventas','Pregunta técnica','','','2013-02-27 00:00:00','Requiero precio de tageta de monitoreo para UPS Mitusubishi 7011A,  Requiero precio de bypass de mantenimiento externo, para:  1.- 1 Pieza, UPS Mitsu 1100 - 20 kVA, Input/Output Voltage: 208/208, Part Number M1100A-A-20-208-208-1B,  2.- 1 Pieza, UPS Mitsu 9900 - 150 kVA, Input/Output Voltage: 480/480, Part Number M9900A-A-150-480-480+BBMS10M,  3.- 1 Pieza, UPS Mitsu 7011A-60 - 6 kVA, Input/Output Voltage: 240/120V (1 Phase), 208/120V (2 Phase), Part Number M9900A-A-150-480-480+BBMS10M,   Quedo al pendiente, gracias.','','','','SAC29','2013-02-28 15:00:00','SI','','0.8906481481462833','1.625','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-27 18:10:46','jorge.martinez@gposac.com.mx','Ventas','Levantamiento','','','2013-03-01 00:00:00','Favor de realizar una visita de levantamiento a el site del 4to piso del edificio C para revisar que haya un tablero disponible a 480V para el proyecto CM291 que es de instalacion de 6 aires GForce de 16TR y 2 Inrow SC','','','','SAC30','2013-03-01 11:00:00','SI','','-1.700856481482333','0.45833333333575865','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-02-28 11:45:50','jorge.martinez@gposac.com.mx','Ventas','Levantamiento','','','2013-02-28 00:00:00','Levantamiento en PEMEX 4to piso del edificio C, para rastrear alimentacion de Equipos de Aire a sustitui por proyecto de Implementacion de 90TR, con 6 equipos de Aire,  Se solicito el Apoyo de Ing. Joel Paz e Ing. Oscar Huerta','','','','SAC31','2013-02-28 16:00:00','SI','','0.17650462962774327','0.6666666666642413','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-01 13:51:10','rufino.moctezuma@gposac.com.mx','Ventas','Pregunta técnica','','','2013-03-01 00:00:00','Requiero apoyo con el precio de   30 piezas BATERIAS DYNASTY UPS 12-300MR	MAXRATE MR12-300  30 piezas BATERIAS DYNASTY UPS 12-400MR	MAXRATE MR12-400  Quedo a sus ordenes.  saludos y gracias.','','','','SAC32','2013-03-02 16:00:00','SI','','1.0894675925883348','1.6666666666642413','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-04 08:53:39','carlos.hernandez@gposac.com.mx','Ventas','Levantamiento','','','2012-03-04 00:00:00','Se requiere del apoyo de un ingeniero debido a que nuestro cliente Continental nos acaba de conformar una cita para el día de hoy a las 12:00 del día, en la cual se tiene que realizar un levantamiento de las condiciones actuales del site y ver las modicifaciones que se tienen que realizar al mismo, así como puntos de monitoreo y algunas otras especificaciones.','','','','SAC33','2013-04-02 13:50:00','NO','','29.16413194443885','394.534722222219','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-04 12:23:39','ivan.ramirez@gposac.com.mx','Ventas','Realización de Cedula de Costos ','','','2013-03-05 00:00:00','SE REQUIERE CÉDULA DE COSTO PARA EL REMPLAZO DE 2 BANCOS DE BATERÍAS (80 BATERÍAS CADA UNO) PARA LOS EQUIPOS MGE, MODELO EPS-6000EN QUE PEMEX TIENE EN CONTRATO CON GPOSAC (PROYECTO CM50) SE REQUIERE PRECIO DE LAS 160 BATERÍAS MODELO UPS12-300MR MARCA DYNASTY, COSTO DE LAS MANIOBRAS NECESARIAS PARA LA COLOCACIÓN E INSTALACIÓN DE LAS MISMAS EN PISO 2 DE TORRE EJECUTIVA, CONSIDERAR  DESINSTALACION Y RETIRO DE LAS BATERÍAS EXISTENTES PARA SU CONFINAMIENTO. CONSIDERAR QUE ESTOS EQUIPOS A SU VEZ LOS TENEMOS EN CONTRATO CON APC.','','','','SAC34','2013-03-06 12:00:00','SI','','1.9835763888913789','1.5','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-05 10:33:40','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos ','','',null,'Buen  día solicito de su apoyo para cotizar la instalación de la UPS en SITE Guamúchil Marca APC de 15 KVA (información completa lineas abajo)  CONTENIDO CAJA 1         UPS SERIE  IS1233006745 MARCA: APC CARACTERISTICAS: SURT.15KVA XLT     CONTENIDO CAJA 2     BATERIA MARCA: APC DE 192V RM SERIE: US 1243104084    CONTENIDO CAJA 3 TRANSFORMADOR MARCA: APC DESCRIPCION: 120V 10KVA TXL APTF 10KTO1 SERIE: 5S1237T18263     ','','','','SAC35','2013-03-06 12:00:00','SI','','1.059953703705105','0','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-05 11:12:26','ivan.ramirez@gposac.com.mx','Ventas','Realización de Cedula de Costos ','','',null,'','','','','SAC36','2013-03-07 15:30:00','SI','','2.1788657407450955','0','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-05 11:31:39','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos ','','',null,'Buen día  Espero me puedan apoyar a realizar una cédula de costos para un modulo de poder de 10KVA para un UPS Symmetra px, así como flete, maniobras y mano de obra para instalación del mismo. Es para PEMEX TAR ZACATECAS. "ESTE MODULO SE REQUIERE POR CRECIMIENTO" ','','','','SAC37','2013-03-05 18:00:00','SI','','0.26968749999650754','0','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-05 11:40:11','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos ','','',null,'Buen día  Necesito de u apoyo para realizar una cédula de proyectos para PEMEX TAR GOMEZ PALACIO, que requiere un Modulo de Bypass Manual Externo de la marca APC, para el UPS Symmetra Px, y 16 módulos de 8 baterías c/u. para el mismo UPS, así como Flete, maniobras y mano de obra por instalación.  ','','','','SAC38','2013-03-05 18:30:00','SI','','0.2845949074107921','0','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-05 11:45:12','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos ','','',null,'Buen día  Necesito de u apoyo para realizar una cédula de proyectos para PEMEX TAR AGUASCALIENTES, que requiere un Modulo de Bypass Manual Externo de la marca APC, para el UPS Symmetra Px y  un Modulo de Poder de 10 KVA para el mismo UPS, así como Flete, maniobras y mano de obra por instalación.','','','','SAC39','2013-03-05 18:30:00','SI','','0.28111111111502396','0','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-05 13:13:01','ivan.ramirez@gposac.com.mx','Ventas','Realización de Cedula de Costos ','','','2013-03-05 00:00:00','SE REQUIERE APOYO PARA DETERMINAR 3 PLANTAS DE CD DE -48 de 20 Amp CON SUS RESPECTIVOS BANCOS DE 50HR, AUTONOMÍA DE 8HRS, SE REQUIERE DETERMINAR PRECIO DE SUMINISTRO MANIOBRAS E INSTALACIÓN. FAVOR DE ATENDER A LA BREVEDAD YA QUE ES PROYECTO CON CARÁCTER DE URGENTE SERA ADJUDICACIÓN DIRECTA','','','','SAC40','2013-03-07 16:00:00','SI','','2.115960648145119','2.6666666666642413','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-05 13:37:03','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos ','','',null,'Buen día  Requiero de su apoyo para realizar una cédula de costos para la instalación de: Un AAP Dataaire Datacool de 2 toneladas 1 face, voltage a 230V, Refrigerado por aire, con flujo por la parte superior, humidificador OPT-80-230V	HUMIDIFIER-5LB 230V y condensador DAAC-0212 INDOOR CONDENSING UNIT 2 TON - No Tag Number.  Este servicio lo requiero para PEMEX TAR ZACATECAS. Favor de incluir costo de Flete y maniobras para el equipo.','','','','SAC41','2013-03-06 13:00:00','SI','','0.9742708333287737','0','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-05 13:45:20','ivan.ramirez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-03-05 00:00:00','BUENA TARDE SE SOLICITA DEL APOYO PARA OBTENER EL PRECIO DE LOS SIGUIENTES EQUIPOS UPS DE APC.  SURTD5000XLT-1TF3 SURTD5000RMXLP3U  SUVTP10KF1B2S SURT10000XLT-1TF10K SURTRK2  SE REQUIERE LA MARCA SEA APC DEBIDO A QUE MUY PROBABLEMENTE LOS EQUIPOS SEAN MONTADOS EN RACK, SE REQUIERE SE ATIENDA A LA BREVEDAD ESTA SOLICITUD YA QUE ES PARA EL PROYECTO J DE PEMEX DERIVADO DE LO SUCEDIDO EN B-2.','','','','SAC42','2013-03-06 10:00:00','SI','','0.8435185185153387','1.4166666666642413','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-05 13:51:50','jorge.martinez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-03-06 00:00:00','Favor de cotizar un UPS de 1Kva Mca APC Mod. SUA1000, es para la cotizacion No. CM294,   Esto es mas que nada como una atencion a el cliente ya que es un equipo No-break que no comercializamos comunmente, ha estado satisfecho con nuestro servicio y quiere comprar este equipo con nosotros   VAC ya nos dio un costo de referencia de $406 USD mas iva,  Se checo con Lourdes Rivera lrivera@vaconline.com.mx Tel: 01 55 2487-0278 ext 820, 821 y 824','','','','SAC43','2013-03-09 13:30:00','NO','','3.9848379629620467','3.5625','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-05 16:58:36','jorge.martinez@gposac.com.mx','Ventas','Realización de Cedula de Costos , Pregunta técnica','','','2012-03-06 00:00:00','Solicitu de cotizacion del sig. listado de Baterias y las cantidades indicadas   80 piezas de: Batería con capacidad de 206 watts/ celda @15’1.67 vcp. Para Sistema de Fuerza Ininterrumpida. De 12V, 53.8AH, de preferencia Dynasty o Genesis  40 piezas de: Batería con capacidad de 488 watts/ celda @15’1.67 vcp. Para Sistema de Fuerza Ininterrumpida. De 12V, 115AH, de preferencia Dynasty o Genesis   40 piezas de: Batería con capacidad de 300 watts/ celda @15’1.67 vcp. Para Sistema de Fuerza Ininterrumpida. De 12V, 78.6AH, de preferencia Dynasty o Genesis   80 piezas de: Batería con capacidad de 350 watts/ celda @15’1.67 vcp. Para Sistema de Fuerza Ininterrumpida. De 12V, 93.2AH, de preferencia Dynasty o Genesis    1 Batería de marca CRONOS, plomo-acido, mod. C-8D-1125 CA1406A CCA 1125A 12 V, terminales estándar. Para plantas de emergencia.  1 Batería de marca CRONOS, plomo-acido, mod. C-30H-670 CA837A CCA 670A 12 V, terminales estándar. Para plantas de emergencia.  Para su instalacion en el banco de Mexico, en la Cd. de Mexico,  quedo a sus ordenes para cualquier comentario, gracias  saludos  ','','','','SAC44','2013-03-22 10:27:00','NO','','16.686388888891088','381.3937500000029','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-06 11:43:35','ivan.ramirez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-03-06 00:00:00','se requiere ayuda para poder cotizar las siguientes piezas derivadas de la requisicion SAC42  2 PZ SURT192XLBP SISTEMA DE BATERIAS PARA EQUIPO UPS SURT','','','','SAC45','2013-03-07 10:00:00','SI','','0.9280671296291985','1.4166666666642413','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-07 10:10:26','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cedula de Costos , Pregunta técnica','','','2013-03-07 00:00:00','Buenos dias. Requiero precio de: 32 piezas de Baterías de 12 Vcd, 7 Ah, Terminal F2, tipo sellada. 8   piezas de Baterías de 12 volts 9 ah, para SMART UPS RT 1500 Un juego de baterías para SMART UPS 2200 XL  1  pieza  de Compresor Modelo ZR72KC-TF5-265, 72,000 btu capacity on R-22,      208 - 230 volt, 3 fases, para AAP APC de 5-Tr,  1  pieza filtro deshidratador 1  pieza solenoide marca SPORLAN Type: E10S250  Así como apoyo de cédula de costos por: Instalación de las mismas en los módulos de batería del UPS Cambio del compresor del que se requiere precio, Colocación de filtro deshidratador y solenoide para AAP APC 5Tr. (hay que considerar que el compresor que trae es roscable)  El equipo se encuentra en: Central Termoeléctrica Presidente Plutarco Elías Calles,  Km 28.5 Carr. Lázaro Cardenas-Zihuatanejo, Petacalco Gro. CFE Lazaro Cardenaz, michoacan  Quedo al pendiente,   Saludos y gracias. ','','','','SAC46','2013-03-20 19:30:00','NO','','13.346921296295477','13.770833333335759','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-07 11:08:38','rufino.moctezuma@gposac.com.mx','Ventas','Pregunta técnica','','','2013-03-07 00:00:00','Buenso días.  Hablo el Ing. Javier Perez Martinez Pemex Guadalajara Tel: 0133 3678 2500  ext 52466  Solicita posponer la fecha del servicio programada para mañana, hasta la proxima semana, la  fecha aun no esta definida.  Ponerse en contacto con el Ing. Javier para su reprogramación  Saludos.','','','','SAC47',null,'SI','','-41340.4643287037','-41340','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-07 16:55:23','carlos.hernandez@gposac.com.mx','Ventas','Realización de Cedula de Costos ','','','2013-03-08 00:00:00','Necesito de favor me apoyen con el precio para unas baterías para los siguientes equipos:  UPS Power Eaton, Modelo: 9155-10, Capacidad: 10 KVA, No. de Serie:BC424FBB09, el cual cuenta con 32 Baterias,  de capacidad: 12v, 7AH.  UPS Power Eaton, Modelo: EXRT 7, Capacidad: 7 KVA, No. de Serie: ICNL28038   el cual cuenta con 40 Baterias, de capacidad: 12v, 7AH.  UPS Power Ware, Modelo: 9155-15, Capacidad: 15 KVA, No. de Serie: FB101FBB20, el cual cuenta con 96 Baterias, de capacidad: 12v, 7AH.   UPS Power Ware, Modelo: 9155-10, Capacidad 10 KVA, No. de serie: BC422FBB05, el cual cuenta con 32 Baterias, de capacidad: 12v, 7AH.  Así mismo requiero el precio del flete y mano de obra para su instalación esto es para Minera Fresnillo en Fresnillo Zacatecas.  De antemano muchas gracias por el apoyo.  saludos ','','','','SAC48','2013-03-13 13:00:00','SI','','5.794872685182781','5.5','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-08 11:48:40','rufino.moctezuma@gposac.com.mx','Ventas','Pregunta técnica','','','2013-03-08 00:00:00','buenos dias.  Solicito precio de Flete a: Central Termoeléctrica Presidente Plutarco Elías Calles,  Km 28.5 Carr. Lázaro Cardenas-Zihuatanejo, Petacalco Gro.  Equipo a suministra: UPS Mitsubishi: 20 KVA Up to 50kva Only, Dimensions (W x D x H) inches, 19.7 x 27.0 x 55.1 Total System Weight (Ibs) sin Bat. 340, UPS+Bco Bat 10min.  Gracias. ','','','','SAC49','2013-03-15 10:31:00','NO','','6.904398148144537','7.396527777775191','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-14 18:33:56','ivan.ramirez@gposac.com.mx','Ventas','Levantamiento','','','2013-03-15 01:00:00','SE SOLICITA DEL APOYO NECESARIO PARA REALIZAR REVISION POR PERSONAL TECNICO A LOS EQUIPOS DE INFRAESTRUCTURA LOCALIZADOS EN PISO 2 DE TORRE EJECUTIVA DE PEMEX, YA QUE ESTOS COMENTA EL CLIENTE ING CARLOS JUVENCIO HERNANDEZ SE ESTÁN ALARMANDO','','CM122','MXO','SAC50','2013-03-15 13:58:00','NO','','0.8083796296268702','0.5402777777781012','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-14 18:36:34','raul.perez@gposac.com.mx','Ventas','Levantamiento','','','2013-03-12 01:00:00','Licitación para servicios a equipo electromecánico, los puntos importantes que contempla son: 1.- mantenimiento preventivo mayor para los equipos de los anexos 1 y 5 contemplando el cambio de partes o consumibles que se describen en dicho anexo. 2.- atención de fallas o emergencias en el equipo, asi como los correctivos que se requieran, las partes no están incluidas, estas se cotizan por separado. 3.- el tiempo de respuesta para fallas será de 24 horas. -          Para los UPS están solicitando cambio de baterías, los modelos son los siguientes:  -          UPS de 120 kva usa 40 baterías 12 volts 78 ah, el modelo que tiene instalado son C&D HIGHT RATE MAX MODELO UPS12-300MR  -          UPS de 80 kva (2 unidades) 40 baterias cada uno 12 volts, 35 ah.  -          UPS de 60 kva, 40 baterias 12 volts, 35 ah.','','NA','GDA','SAC51','2013-03-15 12:13:00','SI','8','0.7336342592607252','3.46736111111386','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-15 14:01:21','rogelio.valadez@gposac.com.mx','Gerentes al Area de Compras','','','','2013-03-15 01:00:00','Se solicita la compra de dos lap´s de acuerdo a las recomendaciones de Roberto, las lap´s son para los puestos de Asistente y consultor.  Me pueden validar que se tengan disponibles lineas de celular para asistente y CST?  Gracias','Requerimiento de Compra de Activos','NA','MXO','SAC52','2013-03-27 13:00:00','NO','','11.957395833334886','12.5','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-19 11:34:55','martin.vazquez@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-03-19 01:00:00','Prueba: parte xxxx  modelo xxxx','','cq117','QRO','SAC53','2013-03-19 12:00:00','SI','10','0.017418981486116536','0.45833333333575865','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-19 17:16:03','raul.perez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-03-19 01:00:00','Se solicita cotizacion del capacitor para 9700, modelo CAP00250, parte LNX2W842MSMCMK 450V 8400uF KKLV-C435-H01.','','NA','GDA','SAC54','2013-03-19 13:14:05','SI','8','-0.1680324074040982','0.5097800925941556','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-20 12:47:24','berenice.martinez@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-03-20 01:00:00','TAR NAVOJOA DATOS DE DESHUMIDIFICADOR:  1 PIEZA Modelo: DTAD-0332-AO MARCA: DATA AIRE Voltage:208 V Job No.: 32961 Serial No. 2010-2257-A M#DTAD-0332-AO S#2010-2257-A J#32961  HUMIDIFIER CYLINER 10 LBS 230V PART#154-060-006   TAR GUAMUCHIL: 6 PIEZAS OTM-25 25 AMP FUSES PART#146-010-251 EQUIPO:AIRE MARCA: DATA AIRE,  MODELO DCAU-0312-AO,  CAPACIDAD: 3TR NUMERO DE SERIE: 2010-2233-A.   FAVOR DE ENVIAR A Camilo Peña en Culiacan, Sin. CENTRO DE SERVICIO SICET, Dom: Mariano Escobedo 1133, Col las Vegas  CP. 80090 Culiacan, Sinaloa. ','','CM150','GDA','SAC55',null,'','','','-41353','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-20 12:56:12','berenice.martinez@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-03-20 01:00:00','TAR NAVOJOA DATOS DE DESHUMIDIFICADOR: 1 PIEZA Modelo: DTAD-0332-AO MARCA: DATA AIRE Voltage:208 V Job No.: 32961 Serial No. 2010-2257-A M#DTAD-0332-AO S#2010-2257-A J#32961 HUMIDIFIER CYLINER 10 LBS 230V PART#154-060-006  CM150  TAR GUAMUCHIL: 6 PIEZAS OTM-25 25 AMP FUSES PART#146-010-251 EQUIPO:AIRE MARCA: DATA AIRE, MODELO DCAU-0312-AO, CAPACIDAD: 3TR NUMERO DE SERIE: 2010-2233-A. CM150  FAVOR DE ENVIAR A Camilo Peña en Culiacan, Sin. CENTRO DE SERVICIO SICET, Dom: Mariano Escobedo 1133, Col las Vegas CP. 80090 Culiacan, Sinaloa. ','','CM150','GDA','SAC56',null,'','','','-41353','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-20 17:10:01','ivan.ramirez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-03-20 01:00:00','SE REQUIERE DE EL APOYO DE INGENIERIA PARA ASISTIR A LA REUNION QUE SE TENDRA CON DAIMLER PARA DEFINIR DETALLES DE LA INSTALACION DE UN EQUIPO UPS 990A. SE PRETENDE QUE LA PERSONA DE INGENIERIA QUE ESTE PRESENTE EN ESTA REUNION SEA EL ING. JOEL PAZ','','CM253','MXO','SAC57','2013-03-20 17:49:00','SI','','-0.02707175925752381','0.7006944444437977','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-21 13:51:40','claudia.rivera@gposac.com.mx','Otros','','','REFACCION','2013-03-22 01:00:00','MOTOR. ELECTRICO MARCA EMERSON. MODELO.K55HXJZE-3122                             HP 1/5 VOLT.208-230-200-220 HZ 60/50 AMP 1.4/1.3 PH 1PRM 1075/890    THERMAKKY PROTECTED PART . NO .1D21122P 1          MFG .NO.B97 8 INS CL B 40 ° C A/R OVER CONT                   FRAME  48 Y','','CM122','MXO','SAC58','2013-03-20 16:32:00','Si','','0.8886574074058444','-1.3527777777781012','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-21 17:50:35','raul.perez@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-03-22 01:00:00','Buena tarde, de favor me pueden cotizar el siguiente material asi como dar el dato de Tiempo de Entrega,  2 contactores  marca  Cutler-Hammer D15CR40 de la serie 8  Quedo a sus ordenes en espera de su pronta respuesta, gracias  saludos','','CM306','MXO','SAC59','2013-03-20 18:00:00','SI','10','0.9934606481474475','-1.2916666666642413','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-22 10:08:34','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-03-22 01:00:00','1 MODULO DE POTENCIA SYPM10KF PARA EQUIPO APC SYMMETRA PX  ENVIAR A SITIO GRANDE 302 FRACC. JOSE COLOMO C.P. 86100 VILLAHERMOSA, TABASCO','','CM150','MXO','SAC60','2013-03-22 14:00:00','SI','','-0.16071759258920792','0.5416666666642413','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-22 10:11:06','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-03-25 01:00:00','MODULO DE PODER SYPM10KF PARA AA APC SYMMETRA PX   ENTREGAR EN "SITIO GRANDE No. 302  FRACCIONAMIENTO JOSE COLOMO  C.P. 86100. VILLAHERMOSA, Tabasco" ','','CM150','MXO','SAC61','2013-03-22 14:00:00','SI','','-0.15895833333343035','-2.4583333333357587','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-22 17:06:57','juanjose.espinoza@gposac.com.mx','Ventas','Levantamiento','','','2013-03-25 01:00:00','Necesito me puedan apoyar con un levantamiento en el edificio patriotismo del INEGI  para un proyecto que se licitara ahí, el cual consiste en 2 UPS de 150KVA 2 Aires de 10TR y una planta de emergencia.  Lo que se necesita es el levantamiento para la instalación hidráulica y eléctrica.','','NA','GDA','SAC62','2013-03-26 13:30:00','SI','','-3.8493402777821757','1.5208333333357587','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-26 09:43:48','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-03-26 01:00:00','SE SOLICITA DEL APOYO NECESARIO PARA OBTENER LA COTIZACION DE 40 PZ DE LA BATERÍA UPS12-150MR DE LA MARCA DYNASTY ESTO CON EL OBJETO DE ATENDER LA NECESIDAD DEL CLIENTE TRUPER.','','na','MXO','SAC63',null,'','','','-41359','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-27 12:14:16','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-03-27 01:00:00','SE SOLICITA DEL APOYO NECESARIO PARA OBTENER EL PRECIO PARA EL SIGUIENTE AIRE PORTATIL DE APC ES PARA SATISFACER EL REQUERIMIENTO DEL CLIENTE BAXTER ACPSC2000','','NA','MXO','SAC64','2013-03-27 18:19:00','SI','','-0.25328703704144573','0.7215277777795563','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-03-27 13:58:09','jorge.martinez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-03-27 01:00:00','Buen dia, super urge esta cotizacion el cliente ya mando anteriormente un correo de que ya habia comprado el equipo de Aire para ejercer presion, requerimos este costo lo antes posible ya que la cotizacion ya se tiene lista pero no se ha liberado a el cliente por que este es un trabajo importante que se debe contemplar desde un inicio para no tener problemas al momento del cierre comercial del proyecto,  quedo a sus ordenes en espera de su pronta respuesta, gracias  saludos','','CM302','MXO','SAC65','2013-03-27 14:37:00','SI','','-0.026979166665114462','0.5673611111124046','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-01 10:14:12','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-04-03 01:00:00','Me pueden apoyar con el suiguiente requerimiento para INEGI por favor.  para INEGI por favor.   Batería para UPS Sellada libre de mantenimiento, Marcas DYNASTY, Modelo UPS12-350MR; marca SPRINTER ó equivalente en calidad, voltaje 12 VCD, capacidad 93 a.h., terminal insertada en el cuerpo de la batería, con 1.67 VPC, a 15 min 350 a.h., de plomo-acido con electrolito suspendido, con las siguientes dimensiones: 20.48 cm (8.06 pulgadas) de alto, 30.58 cm (12.04 pulgadas) de largo y 16.89 cm (6.65 pulgadas) de ancho. Las baterías deberán incluir: rondana y tornillo de acero inoxidable cabeza hexagonal para conexión de batería, 164 links para interconexión de baterías fabricados de cables de cobre porta electrodo calibre 2/0, 90°C, 600 Volts, 1330 hilos con zapatas de cobre bañada de estaño con ojillo de 1/4 de pulgada para conexión a baterías. Los links para interconexión deben de ser con las siguientes cantidades y medidas: 32 piezas de 21 cm, 96 piezas de 31 cm, 16 piezas de 60 cm, 12 piezas de 150 cm, 4 piezas de 250 cm y 4 de 50 cm.  TOTAL DE BATERIAS 160  CONSIDERAR INSTALACIÓN POR SEPARADO.  ESTAS SON LAS CONDICIONES QUE TENEMOS QUE CUMPLIR CON LAS BATERIAS:  Tiempo de entrega no mayor a 35 dias naturales Entrega en Aguascalientes Garantia por 2 años Cumplir con la NOM-001-SEDE-2005.- “Instalaciones Eléctricas”,  y estándares internacionales como la UL 1778.-“Sistemas de alimentación ininterrumpida”','','NA','GDA','SAC66','2013-04-04 14:30:00','Si','','3.1776388888902147','1.5625','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-02 10:15:25','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-04-04 01:00:00','Buen día  Me pueden apoyar con la cotización de las sig. baterías por favor.  TAR Ensenada:96 baterias, capacidad: 12v,7Ah.  modelo: HRL1234WF2FR., marca: CSB.                                      TAR Mexicali: 96 baterías capaciad: 12v,7Ah. modelo: HRL1234WF2FR, marca: CSB  TAR Rosarito:  192 baterías capacidad: 12v,5Ah., para equipo UPS marca: APC, modelo:Smart, de 15 KVA. serie: IS0918002622.    TAR Rosarito: 96 baterías, capacidad: 12v,7Ah. marca: CSB modelo: HRL1234WF2FR, para equipo UPS marca: POWER WARE modelo: 9155 LVEM.  de 15 KVA.  DE IGUAL FORMA FAVOR DE COTIZAR FLETES E INSTALACIÓN POR FAVOR.  ','','CM150','GDA','SAC67','2013-04-02 15:05:00','SI','','-0.20109953703649808','-1.4131944444452529','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-02 11:27:10','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-04-04 01:00:00','Me pueden apoyar con una cédula de costos para un estudio de calidad de energía. 4 puntos de conexión a barras, lo necesita por 7 días iniciando un miércoles, "la problemática la tiene los lunes al arranque de la planta en el área de envasado", no tiene supresores de picos y se le han quemado algunos sensores   Anexo la liga de unifilares  https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0B2jQgfvQJ9a0bjQtSm1zWUhvUFE  ','','NA','GDA','SAC68','2013-04-02 15:17:00','SI','','-0.15960648148029577','-1.4048611111138598','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-02 15:09:09','rogelio.valadez@gposac.com.mx','Gerentes al Area de Compras','','','','2013-04-09 00:00:00','Se requiere Lap top para Rufino debido a que el Cubo que ocupa le fue requerido por servicio.  Saludos','Requerimiento de Compra de Activos','NA','QRO','SAC69','2013-04-04 10:00:00','SI','','1.7853124999965075','-4.625','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-02 17:57:07','ivan.ramirez@gposac.com.mx','Ventas','Elaboración de Plano e Imagenes 3D del SITE (se deben anexar planos del edificio y dibujos de levantamiento)','','','2013-04-02 01:00:00','Se requiere del apoyo de ingeniería para poder realizar el diagrama o plano de sembrado del sitio en donde se instalara el equipo UPS vendido a Daimler correspondiente al proyecto CM253, el Ing. Julio Lara realizo un levantamiento el día 26/03/13 en este sitio, se requiere tambien se especifique en este diagrama los requerimientos necesarios (Tipo de cableado para UPS, By pass, supresor de picos, Transformador y suministro de tableros eléctricos) que deben cumplir las instalaciones del cliente, esto debido a que la instalación eléctrica correra por parte del cliente.','','CM253','MXO','SAC70','2013-04-11 15:30:00','SI','','8.939502314817219','9.645833333335759','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-02 19:42:54','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-04-03 01:00:00','Me pueden apoyar con la cédula de costos del ticket SAC62 por favor.  Ya tengo el precios de los equipos, solo necesito el costo de la mano de obra por la instalación, puesta en marcha, materiales y todo los que implique dejar funcionando los equipos así como la reubicacion de la Planta de emergencia.','','NA','GDA','SAC71','2013-04-09 12:30:00','SI','','6.741041666668025','6.520833333335759','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-03 18:48:45','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-05 01:00:00','COMPRESOR: COMPRESOR COPELAND SCROLL ROSCABLE MODELO: ZP120KCE-TF5-265 SERIE: 11KA4918D REFRIGERANTE R-410 AMP  29.5A  ES POR GARANTIA Y ES PARA ENTREGA EN CIUDAD DEL CARMEN','','CM118','MXO','SAC72',null,'','','','-41369','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-03 19:03:10','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-04-03 01:00:00','Se visito la empresa EIKA México, y solicitaron de urgente la cotización de:  Un compresor Marca "Danfoss Maneurop Compresores", Modelo: MT28JE4A, Serial: KA 2657958, (440V, 3F, 60Hz, 7.5Amp Max), (440V, 3F, 50Hz, LR 23 A), REFRIGERANTE: R22. Se tomaron datos a la placa del motor, se anexan en correo.','','NA','QRO','SAC73','2013-04-04 11:00:00','SI','','0.6644675925927004','1.4166666666642413','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-04 11:37:59','jorge.martinez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional), Pregunta técnica','','','2013-04-05 01:00:00','Solicitud de reunion de 35 minutos con Ing. Joel Paz para revisar proyecto de acondicionamiento electrico y de climatizacion a SITE de Exrefineria Azcapotzalco de PEMEX, ver los ultimos datos obtenidos en cuanto a la parte tecnica como a los presupuestos que se deben agregar a la propuesta inicial','','CM111','MXO','SAC74','2013-04-04 17:30:00','SI','','0.24445601851766696','-0.3125','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-04 15:58:18','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-08 00:00:00','1 TARJETA DE COMUNICACIÓN MARCA LIEBERT MODELO ASSY 416791G 1 TARJETA DE COMUNICACIÓN MARCA LIEBERT MODELO 1207BMK46654  REPORTE 13-41 Y 13-42 ES PARA ENTREGA EN ISEC VILLAHERMOSA','','CM150','MXO','SAC75',null,'','','-41368.623819444445','-41372','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-04 19:44:28','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-04-05 01:00:00','SE REQUIERE DEL PRECIO PARA EL NUMERO DE PARTE OPT-7310 (DAP4) PARA UN EQUIPO DE AIRE DE 30TR MARCA DATA AIRE SERIE DATA AIRE','','NA','MXO','SAC76','2013-04-12 15:00:00','SI','','7.844120370369637','7.625','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-09 11:59:12','juanjose.espinoza@gposac.com.mx','Ventas','Pregunta técnica','','','2013-04-11 00:00:00','El cliente me esta pidiendo apoyo para saber cuales alarmas son reseteables manualmente y cuales son automáticas de los sig. modelos: ·         DACD 2234 (DATA AIRE)  ·         DACD 3034 (DATA AIRE)  ·         ACRP501 (APC)','','CG140','GDA','SAC77','2013-04-11 14:30:00','SI','','2.1047222222186974','0.6041666666642413','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-09 12:31:45','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-09 00:00:00','2 CAPACITORES 50+5 +/-6% 370V 2 CONTACTORES SQUARE DI MOD.8910DPA23 220V. 2 TARJETA UNIVERSAL (TARJETA DE CONTROL. CONTROL REMOTO Y TRANSFORMADOR  YA TENGO COTIZACION PARA ENTREGA INMEDIATA Y LO PUEDO COMPRAR.  ','','CM122','MXO','SAC78','2013-04-09 16:20:00','SI','','0.1585069444408873','0.6805555555547471','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-09 14:14:32','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-15 00:00:00','1 HUMIDIFICADOR PARA EQUIPO DATA AIRE  Humidity sensor                              160-011-203 Strainer assembly                           129-050-002 Cylinder, no. 102 208/230V              154-050-003 Fill valve, no. 1                                154-300-133 Drain valve                                      154-300-185 PC board 208/230V                         154-050-208 Nortec hmdfr, MES-U-5C 208/230V   154-050-001 Water pressure switch                      159-300-002  INFORMACION DE DATOS TECNICOS CON JULIO LARA (ENVIÒ MAIL), POR FAVOR','','CM150','MXO','SAC79',null,'','','','-41379','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-09 16:22:05','raul.perez@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-09 00:00:00','SE REQUIERE COMPRAR LA SIGUIENTE CAMARA SOLICITADA POR ROBERTO OROZCO PARA LA EMPRESA GOBIERNO DEL ESTADO DE GUANAJUATO EL LUGAR DONDE SE DEBE DE MANDAR ES A QUERETARO.  CARACTERISTICAS DE LA CAMARA MARCA: ATV, Videograbadora Pelco Ever Focus MODELO: EDVR4DI  -          Se anexa FICHA DE LA CAMARA.  -          Cotizar igual o similar, solo especificar Marca y modelo  -          Incluir ficha del equipo cotizado. ','','CQ97','QRO','SAC80','2013-04-09 17:40:00','SI','','0.05410879629198462','0.7361111111094942','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-09 18:09:36','raul.perez@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-09 00:00:00','Buen di se solicita la compra de las siguientes partes, los datos de las partes que se tienen que cambiar en el Aire data cool de 3 ton en la Paz Baja California Sur, el cliente es Pemex con numero de Pedido CM150.    Descripción                             Numero de part  Humidity sensor                              160-011-203 Strainer assembly                           129-050-002 Cylinder, no. 102 208/230V              154-050-003 Fill valve, no. 1                                154-300-133 Drain valve                                      154-300-185 PC board 208/230V                         154-050-208 Nortec hmdfr, MES-U-5C 208/230V   154-050-001 Water pressure switch                      159-300-002  Los numeros de parte son de la marca Data Aire. Adjunto algunas imágenes de las partes.  Quedo atento a sus comentarios','','CM150','MXO','SAC81',null,'','','','-41373','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-11 11:13:25','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-04-15 00:00:00','Me pueden apoyar con una cedula de costos para: 64 Baterias sellada libre de mantenimiento de plomo-ácido para sistema de energía ininterrumpida (UPS), capacidad de 12 V, 78 amperes- hora, @ 20hr, 300 watts por celda en un rango de 15 minutos, voltaje de corte 1.67 V.C.D por celda, rango de temperatura nominal de operación:+ 74°F (23°C) a +80°F (27°C), voltaje de flotación: 13.65 +- 0.15 V.C.D promedio por unidad de 12 V. (6.75 A 6.90 por unidad de 6 V). Dimensiones: largo 260mm, ancho 173mm, alto 203mm, válvula reguladora, cuerpo y cubierta retardante a la flama, atornillable sin poste. Incluye: tornillos y rondanas para bornes. Se requiere que el bien cuente con Certificado de seguridad UL94-V2 Se requiere un período de garantía mínimo de 12 (doce) meses La entrega de los bienes será dentro de los 20 (veinte) días naturales.  ASÍ COMO LA MANO DE OBRA POR LA INSTALACIÓN Y EL FLETE Y MANIOBRAS PARA OAXACA DE JUÁREZ, OAXACA ','','NA','GDA','SAC82','2013-04-18 13:30:00','SI','','7.0948495370394085','3.5625','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-11 16:41:03','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-03-11 01:00:00','Buenas tardes.  Se requiere el apoyo para la elaboración de una cedula de costos para las siguientes instalaciones en Seg. El Potosi, en SLP.  INSTALACIÓN DE EQUIPOS SUPRESORES DE PICOS, Incluye material de instalación e interruptor de protección 3 x 50 A	 INSTALACIÓN DE TR DE AISLAMIENTO K-1, Incluye material de instalación e interruptores de protección a la entrada y salida del mismo	 INSTALACIÓN DE TR DE AISLAMIENTO K-13, Incluye material de instalación e interruptores de protección a la entrada y salida del mismo	 ELABORACIÓN DE DIAGRAMA UNIFILAR, Levantamiento por 3 pisos de operación y subestación eléctrica	  Se reenviara correo de SAC Energía para su valoración. Si requieren mas datos para cotizar por favor indiquenlo. Saludos y gracias.','','NA','QRO','SAC83','2013-04-15 11:30:00','SI','','3.7839930555564933','35.47916666666424','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-11 18:56:30','jorge.martinez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-04-12 00:00:00','Que precio tiene la planta Mca Ottomotores Mod. CNY500 y favor de confirmar si lleva o no caseta acustica,  En caso de que no si de favor me la puedes cotizar tambien  quedo a tus ordenes en espera de tu pronta respuesta, gracias  saludos','','CM111','MXO','SAC84','2013-04-22 14:00:00','NO','','10.79409722222772','10.583333333335759','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-12 16:01:05','jorge.martinez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2012-04-12 00:00:00','Solicitud para que el Ing. Joel Paz me pueda acompañar el dia de hoy a una cita a AFORE XXI en el anexo de la torre mayor, para confirmar datos de la propuesta economica que vamos a presentar para la implementacion de un aire perimetral de 10TR','','CM297','MXO','SAC85','2013-04-12 13:30:00','SI','','-0.10491898148029577','365.5625','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-14 23:23:38','jorge.martinez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-04-16 00:00:00','Mesa de ayuda,  Buena tarde, favor de cotizar un chiller de 60 tr marca york Mod. YLAA0210SE, enfriados por aire con refrigerante ecológico R410a y debe incluir Tanque recirculador, bomba, sistema de control y conexiones hidráulicas  Te envio los datos del contacto en GDL que ya nos ha cotizado  Ing. Miguel Angel Salinas Sanchez  Process Engineering AIREYORK, S.A. DE C.V. Nextel (33) 1484-2361     ID  72*74379*53 CEL. 044-3314105956 miguel.salinas@aireyork.com  www.aireyork.net ','','CM111','MXO','SAC86','2013-04-15 16:30:00','SI','','0.7127546296323999','-0.3125','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-15 10:00:05','joseluis.esteva@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-19 00:00:00','Se requiere el cilindro del humidificador de un Data Aire de 5 Tr. Para PEMEX Aviación ya que el equipo esta presentando alarmas de flujo de agua y baja humedad.  Mando datos del Aire Acondicionado de Precisión.  Model No.: DTAD-0532-AO    Job No.: 32961  Serial No.: 2010-2266-A  Gracias','','CM150','GDA','SAC87','2013-04-30 13:44:00','NO','','15.155497685191222','11.57222222222481','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-15 10:18:00','jorge.martinez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-04-16 00:00:00','Mesa de Ayuda Buen dia de favor me pueden cotizar 80 Baterias Mca Dynasty del Mod. UPS12-490SR de 12V y 134.8AH de capacidad, es para la entrega en la Cd. de Mexico en Av. Marina Nacional 4to piso del Edificio C','','NA','MXO','SAC88','2013-04-15 17:13:00','SI','','0.2881944444452529','-0.2826388888861402','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-15 18:38:24','raul.perez@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-18 00:00:00','DOS VALVULAS SOLENOIDES DAÑADAS LAS CUALES NO PERMITEN EL PASO DEL GAS REFRIGERANTE. SE REQUIERE LA COMPRA DE LAS VALVULAS CON ENVIO OFICINA DE MEXICO. PARA PEMEX   MODELO: GS-1990-1 (200RB3T4) MARCA:ALCOCONTROLS VOLTAJE: 24VCD POTENCIA: 12W FRECUENCIA:50-60HZ 0MODELO: GS-1682-1 (200RB5T4) MARCA:ALCOCONTROLS VOLTAJE: 24VCD POTENCIA: 12W FRECUENCIA:50-60HZ  PARA UN EQUIPO LIEBERT  MODELO: CS067A-C00 CAPACIDAD: 3 TR  ','','CM122','MXO','SAC89','2013-04-17 16:57:00','SI','','1.929583333338087','-0.2937499999970896','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-16 14:12:28','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-04-17 00:00:00','SE REQUIERE AYUDA PARA OBTENER LOS PRECIOS DE LOS SIGUIENTES AIRES ACONDICIONADOS DE CONFORT E INDUSTRIALES.  -WA3S1-A10BPXXX. MARCA BARD 3TR -WA5S1-A20BPXXX. MARCA BARD 5TR -W242CM EQUIPO VENTANA 1TR MARCA LG -W122CM EQUIPO VENTANA 2TR MARCA LG -MCX536G1, TTK536K1. MINI SPLIT 3TR Y EVAPORADORA MARCA TRANE -MCX524G1, TTK524P1. MINI SPLIT 2TR Y EVAPORADORA MARCA TRANE  -MCX518G1, TTK518P1. MINI SPLIT 1.5TR Y EVAPORADORA MARC TRANE  GRACIAS','','NA','MXO','SAC90','2013-04-19 13:20:00','NO','','2.9635648148105247','2.555555555554747','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-17 09:23:06','jorge.martinez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-04-19 00:00:00','Mesa de Ayuda,  Buena tarde de favor puedes solicitar nuevamente a Miguel Angel Salinas de YORK la actualizacion de la cotizacion "Grupo SAC, Chiller tempo 70.080711.rtf"  de un equipo Serie Tempo  Chillers Scroll Process enfriados por aire con refrigerante ecológico R410a, de 72 TR  Quedo a tus ordenes en espera de tu respuesta y/o comentarios, gracias  saludos','','CM111','MXO','SAC91','2013-04-22 13:20:00','NO','','5.164513888885267','3.555555555554747','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-17 15:50:42','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-17 00:00:00','1 MOTOR MAGNETEK PARA CONDENSADORA 208-230/460 RPM 1100 3/4 HP MONOFASICO 60HZ FLECHA DE 5/8 Y LARGO DE 4.5 NO. DE PARTE 8-184787-04  FAVOR DE CONFIRMAR SI NO SE TIENE EN INVENTARIO PARA COMPRARLO, YA ESTA COTIZADO EN $3300','','CM122','MXO','SAC92','2013-04-18 18:00:00','SI','','1.0897916666654055','1.0897916666654055','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-18 16:57:16','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-04-19 00:00:00','ME PUEDEN APOYAR CON LOS PRECIOS PARA UNA POLIZA DE MANTENIMIENTO DE LOS SIGUIENTES EQUIPOS POR FAVOR.   CANTIDAD: 2 PÓLIZA DE MANTENIMIENTO PREVENTIVO/CORRECTIVO ANUAL SISTEMA DE EXPANSION DIRECTA DIVIDIDO TIPO MULTI-SPLIT MARCA SAMSUNG MODELO: MC36F2 	  CANTIDAD 2 PÓLIZA DE MANTENIMIENTO PREVENTIVO/CORRECTIVO ANUAL SISTEMA DE EXPANSION DIRECTA DIVIDIDO TIPO MINI-SPLIT MARCA: TRANE MODELO: 2TTK0530G1P00AA 	  CANTIDAD 3 PÓLIZA DE MANTENIMIENTO PREVENTIVO/CORRECTIVO ANUAL A UNIDADES GENERADOS DE AGUA HELADA MARCA:MCQUAY, MODELO: AGZ050CHNN-ER10 	  CANTIDAD 3 PÓLIZA DE MANTENIMIENTO PREVENTIVO/CORRECTIVO ANUAL A UNIDADES RECIRCULADORAS DE AGUA HELADA MARCA: BELL & GOSSET, MODELO: 1510-2BC	  EN TODAS SE PIDEN SERVICIOS BIMESTRALES CON UN TOTAL DE 4   ','','na','GDA','SAC93','2013-04-19 16:30:00','SI','','0.9810648148122709','0.6875','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-18 17:33:29','ivan.ramirez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-04-19 00:00:00','SE REQUIERE DEL APOYO POR PARTE DE INGENIERIA PARA REALIZAR LA VISITA A INSTALACIONES DE LA CAPUFE SE PRETENDE SE REALICE UN LEVANTAMIENTO DEBIDO A QUE ESTAN REALIZANDO UNA LICITACION PARA MANTTO A EQUIPOS DE INFRAESTRUCTURA LOS EQUIPOS QUE ESTAN LICITANDO PARA MANTTO SE DECRIBEN EN LA SIGUIENTE LIGA https://docs.google.com/a/gposac.com.mx/document/d/163xQh27WO_0Mal6_ETI8NxoLjQMtAdatQO5bpmVQuXE/edit ','','NA','MXO','SAC94','2013-04-22 17:40:00','NO','','4.004525462958554','3.7361111111094942','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-19 09:37:03','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-21 00:00:00','-1 tarjeta de control de operación para unidad condensadora (controla el ventilador auxiliar que entra cuando solicita más demanda de ventilación) Mod. P266BHA-100 (Para trámite de garantía) -3 fusibles de ret. 11 amperes -1 block de conexiones s/m  Para equipo de precisión DATA-AIRE de 96,000 btu/hra Mod DALA-083A-EAO-D Entrega en   ','','NA','MXO','SAC95',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-22 19:14:29','rogelio.valadez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-04-26 00:00:00','Favor de cotizar las siguientes cámaras, en su defecto un modelo de iguales prestaciones: - MARCA CNB,  MODELO  WDR, COLOR  VIDEO CAMERA   DAY&NIGHT, Alimentación:  24V AC /  12V DC   - MARCA Micro High Tech, Modelo  MH-3520, Color CCD Camera   System NTSC, Alimentación: 24V AC /  12V DC  Gracias','','CM150','MXO','SAC96',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-23 11:40:25','rogelio.valadez@gposac.com.mx','Ventas','Levantamiento','','','2013-04-26 00:00:00','Se requiere realizar la instalación y arranque de una planta de corriente directa de 3.2 kva de la marca eltek para este viernes en la TE de PEMEX. Los datos de la instalación se proporcionaran el día de hoy, para contemplar los materiales. La puesta en marcha se debe solicitar a eltek e incluso tambien la instalación.','','PM93','MXO','SAC97',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-23 16:56:44','berenice.martinez@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-23 00:00:00','SOLICITO DE FAVOR LAS SIGUIENTES REFACCIONES PARA: EQUIPO: AA MARCA: DATA AIRE MODELO: DCAU-0312-AO CAPACIDAD: 3 TR REFERENCIA: ORDEN DE SERVICIO AA-0252 TAR GUAMUCHIL  3 FILTROS DE AIRE: MEDIDAS DE 16X16X1 PLGS, O EL MODELO : SC MERV 8 1 CONTACTOR EATON: cat: C25DND330 DEHUMIDIFICADOR JOB NO. 32961 MODEL NO: DCAU-0312-AO VOLTAJE: 208V SERIAL: 2010-2233-A  EN CASO DE REQUERIR LAS IMAGENES FAVOR DE SOLICITARLAS.  FAVOR DE ENVIAR A Camilo Peña en Culiacan, Sin. CENTRO DE SERVICIO SICET, Dom: Mariano Escobedo 1133, Col las Vegas CP. 80090 Culiacan, Sinaloa.  CM150 ','','CM150','GDA','SAC98',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-23 18:09:27','jorge.martinez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-04-24 00:00:00','Mesa de Ayuda,  Buena tarde, favor de cotizar  4 Baterias LC-RD 1217P, 12V, 17AH/20AH  94 Baterias KPL 100P, 100AH/1.2V Ni-CD  128 Baterias CP 1270, 12V, 7.0AH  Para suministro a Pie de camion en la TAR Minatitlan, perdon por la premura pero se requiere la respuesta con el menor tiempo posible en cuanto a los costos, gracias  saludos','','NA','MXO','SAC99',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-24 12:36:51','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-24 00:00:00','2 COMPRESORES COPELAND SCROLL MOD.ZP34K5E-PFV-130 GAS R-410 MONOFASICO 208-230 V /1 HP3   FAVOR DE CONFIRMAR SI SE TIENE EN INVENTARIO,URGE  YA ESTA COTIZADO PARA COMPRA,1 DIA $10,700 C/U, ES PARA ENTREGA EN Av.21 No.76 Col. Fernando Gutièrrez C.P.94297 Boca del Rìo, Veracruz','','CM122','MXO','SAC100',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-24 14:01:23','berenice.martinez@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-24 00:00:00',' EL CONTACTOR QUE SE RECOMIENDO REEMPLAZO: MARCA CUTLER-HAMMER P/N: C25DND330 EQUIPO. AA MARCA: DATA AIRE MODELO: DCAU-0312-A0 CAPACIDAD;: 3TR CM150 ORDEN DE SERVICIO: AA-0254 TAR CULIACAN    EQUIPO. AA MARCA: DATA AIRE MODELO: DTAD-0332-A0 CAPACIDAD;: 3TR CM150 ORDEN DE SERVICIO: AA-0255 TAR OBREGON REFACCION: BLOWER  SE RECOMIENDA REEMPLAZO DE TODO EL BLOWER YA INTEGRADO, POR LA CUESTION DEL BALANCEO ADEMAS UNO DE LOS AMORTIGUADORES TENIA DESGASTE YA QUE SE PATINABA EL BALERO DENTRO DE ESTE.','','CM150','GDA','SAC101',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-24 14:42:26','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-04-25 00:00:00','SE SOLICITA APOYO PARA DETERMINAR EL PRECIO QUE TENDRIA UNA POLIZA DE MANTENIMINETO PREVENTIVO CON 2 VISITAS POR AÑO PARA UN SISTEMA CONTRA INCENDIO DE LAS SIGUIENTES CARACTERISTICAS:  LA MEDIDA DEL SITE ES DE 40 M2 EL CILINDRO DEL EXTINTOR ES DE 85kg FM-200 CONTIENE 2 REGADERAS PARA EL LIQUIDO EXTINGUIDOR 4 DETECTORES DE HUMO BAJO PISO 3 DETECTORES DE HUMO PARA TECHO  ','','CM 292','MXO','SAC102',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-24 15:12:47','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-24 00:00:00','1 CONTROL DE BAJA PRESION MOD. HK02IB028  1 SENSOR DE FLUJO DE AIRE MOD.AP4094 1 ASPA 26" X 1/2" DE 4 ALABES EN ALUMINIO  REQUISICION DE PARTES X ISEC VILLAHERMOSA DERIVADO DE PREVENTIVOS EN SITIO: REFORMA  YA SE TIENEN COTIZADOS, FAVOR DE CONFIRMAR EXISTENCIA','','CM150','MXO','SAC103',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-24 16:53:54','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-24 00:00:00','SISTEMA DE HUMIDIFICACIÓN PARA AIRE ACONDICIONADO DE CADEREYTA. COTIZADO POR JORGE CHAVEZ MODELO:SK310-208-3, COMMERCIAL ELECTRIC (14KG/HR)','','CM150','QRO','SAC104',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-24 16:54:27','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-25 00:00:00','1 MOTOR MOD. P63PYDCL 3128 CON POLEA MOD.1VB501 HP1 1/2 RPM1750 SF1.15 230/460V   ','','CM237','MXO','SAC105',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-24 18:40:17','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-25 00:00:00','2 CONTACTORES ELECTRICOS 3 FASES 75AMP 220V CAT.C25FNF375, BOBINA 24V 50-60HZ CUTLER HAMMER $3553 C/U  6 CARTUCHO FUSIBLE 60 AMP CAT.TR60R 250V MARCA TRI-NIC $370 C/U  YA ESTA COTIZADO X CENTRO DE SERVICIO PERO NO TENGO REFERENCIA DE OTRO PRECIO  URGE REPARACION, EQUIPO EN BOCA DEL RIO AA DATA AIRE 30 TON.','','CM150','MXO','SAC106',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-25 03:17:04','jorge.martinez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-04-30 00:00:00','Mesa de ayuda, buen dia de favor me puden cotizar las siguientes refacciones para equipos de Aire con su tiempo de entrega:  - Compresor Marca Copeland Mod.    ZRT188KC-TFS-250 Costumer Part:    875-3282 Volts  200-230     200-220 PH     3   - MOTOR MCA. MARATHON MOD. AWK56T1105538E PART NO. 25301801 1 1/2 HP   - MOTOR MCA. MARATHON MOD. FB050-4EA.41.2L Volts 208/230 VAC 60HZ    3PH   - MOTOR DE EVAPORADORA PARA EQUIPO MCA STULZ DE 10TR DESCRIPCION: MOTOR MCA AC-MOTOREN GMBH, TYPE AA 100LA-4, NR 051/0675B04, 220-240/220-280V, 2.2/2.64KW   - VALVULA DE BOLA MARCA ALCO MOD. ABV7 7/8”   - FILTRO DESHIDRATADOR LINEA LIQUIDO MODELO TD-305F CON ENTRADA DE 5/8” F, MCA EMERSON   - Filtros para Aire  4" 25X16 M8 45% ASHRAE 52.1-99   - PRESOSTATO DE BAJA PRESION 15/35 PSI, NP: 1D1 5059P1, PARA EQUIPO DE AIRE MARCA LIEBERT DE 20 TR   - MOTOR PARA VENTILADOR, MCA MAGNETEK, MOD. 10-158866-02, CAP 3 HP, 460/200-230V, 1140rpm, 3HP, PARA CHILLER MCA MCQUAY DE 40TR  - SWITCH DE PRESION CON LA SIG DESCRIPCION:    ASSY HI-PRESS SW OPENS 375 PSIG, PARA EQUIPO DE AIRE MARCA APC. MOD. FM50M  Sin mas por el momento quedo a sus ordenes en espera de su respuesta y/o cualquier comentario, duda, gracias  saludos','','NA','MXO','SAC107',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-25 17:22:12','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-24 00:00:00','1 COMPRESOR COPELAND SCROLL MOD.ZR24K3-PFV-230 GAS R22, CONFIRMAR SI NO ESTA EN INVENTARIO Y AUTORIZAR COMPRA $6638 ENTREGA INMEDIATA','','CM122','MXO','SAC108',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-25 17:25:38','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-04-25 00:00:00','1 COMPRESOR COPELAND SCROLL MOD.ZR24K3-PFV-230 GAS R22, CONFIRMAR SI NO ESTA EN INVENTARIO Y AUTORIZAR COMPRA $6638 ENTREGA INMEDIATA','','CM122','MXO','SAC109',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-26 09:02:03','rogelio.valadez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-04-27 00:00:00','Se requiere el precio de lista de bypass y tablero de distribución de 42 polos montado en un mismo gabinete (Fabricación SAC). Para UPS 1100 de 50 Kva.  Gracias','','CM324','MXO','SAC110',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-26 10:16:17','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2014-03-20 17:04:54','Buen día, me pueden apoyar con una cedula de costos para un:  UPS MARCA APC, LINEA " SMART " , MODELO SUA 3000','','NA','GDA','SAC111',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-26 11:10:05','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-04-26 00:00:00','El prospecto TIC Andres Mora, me solicito cotizar el cambio de un 20% de un plafon y un 20% del piso falso de un site, la Srita. Alejandra Servin me envío una propuesta por el plafon, te la reenvio, del piso falso aun no nos pasan el modelo requerido  15 cajas es por 44 mts2 para cubrir el 20% de los dañados.   $ 11,489.70 mn  42 cajas son para cubrir los 244 mts2                                      $ 27,670.88    Les enviare la propuesta de la Srita Alejandra Servin.  Saludos','','CQ364','QRO','SAC112',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-29 12:34:25','victor.hubert@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-05-03 00:00:00','1 Compresor   Marca American Standar inc.   Modelo: AL33A-FF1-B.  Serial: 33740414.  Voltaje: 200-230.  Frecuencia: 60 Hz.  Para un Aire Acondicionado TRANE de 3 toneladas.   ','','CM122','MXO','SAC113',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-30 18:41:03','jorge.martinez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-05-02 00:00:00','Mesa de ayuda,  Buena tarde, favor de cotizar maniobras para reubicacion de 2 equipos de Aire de 30TR, Mca Liebert y un equipo de 10TR Mca STULZ, se requiere el apagado, desconexion y arrastre a 10mts de su lugar original, acondicionamiento (tapar con placas de piso falso y realizar cortes a las placas en donde sera el nuevo lugar del equipo), reinstalar electrica e hidraulicamente estos equipos, conexion y arranque  Sin mas por el momento quedo a sus ordenes para cualquier comentario y/o duda, gracias  saludos','','CM48','MXO','SAC114',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-04-30 19:37:30','jorge.martinez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-04-30 00:00:00','Mesa de ayuda,   Buena tarde, por medio del presente solicito de favor se realize la cedula de costos por parte del Ing. Joel Paz, para instalara un Motogenerador de 80kw, un UPS Modular 1100 de 20kva (N+1) escalable a 50kva, conexion a 20mts del UPS al PDU a 220V, 6 boas trifasicas de 15mts de largo del PDU a los 3 racks, una boa para cada regleta  esta cedula ya se realizo: https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AuE-MkGtG1AudDBLMFBmYVNBV2d2RV9tdElJMkRHbEE&usp=sharing#gid=0  de antemano, gracias por su apoyo  saludos,   ','','CM324','MXO','SAC115',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-02 09:51:58','rufino.moctezuma@gposac.com.mx','Ventas','Pregunta técnica','','','2013-05-02 00:00:00','Solicito precio de las siguientes baterias:  64 Piezas Baterias para UPS APC Simmetra XP de  20KVA, de 12 Vcd, 7 Ah, Terminal F2, Marca CSB o similar.  Saludos y gracias','','CQ391','QRO','SAC116',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-03 11:19:14','rogelio.valadez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-08 00:00:00','Solicito el precio de lista de filtros lavables para un data aire de 3 ton.','','NA','MXO','SAC117',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-06 10:04:44','jorge.martinez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-05-06 00:00:00','Se solicita el apoyo del Ing. Joel Paz, para acompañar a visita a Ex-refineria 18 de Marzo para la revision de la instalacion de equipos de Aire del proyecto J, la visita se requiere para el dia de hoy a las 10:30am,  Sin mas por el momento quedo a sus ordenes, gracias  saludos','','CM329','MXO','SAC118',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-06 11:16:00','rufino.moctezuma@gposac.com.mx','Ventas','Pregunta técnica','','','2013-05-06 00:00:00','Como resultado de la visita para mantto preventivo en Granite Chief solicito por favor precio para el suministro de los siguientes equipos:  1pza  Compresor, Modelo: CR37KKQPFV280BB, 3PH, R-22 1pza  Filtro Deshidratador TD-163S 3/8" Soldable 1pza  Gas Refrigerante R-22 de 13.6kg 1pza  Soldadura plana Harris 0% Ag  Así como el costo de la mano de obra para su sustitución en Granite Chief en el Centro de Negocios Apaseo   Saludos y gracias.','','NA','QRO','SAC119',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-06 13:18:56','ivan.martin@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-07 00:00:00','PLANTA GENERADORA DE ENERGIA ELECTRICA CON CAPACIDAD STAND-BY DE 1000 KW Y 1250 KVA, CARGA CONTINUA DE 910 KW Y 1138 KVA, 480V, 3F, 4H, 60Hz. 1800 r.p.m,  f.p. = 0.8, GRADO HOSPITAL CON INTERRUPTOR PRINCIPAL AUTOMATICO DEL TIPO ELECTROMAGNETICO DE 3PX2000A, TANQUE DE DIESEL EN LA BASE DE LA PLANTA CON CAPACIDAD DE 1000 LTS, PARA OPERAR A 2500 m.s.n.m MARCA OTTOMOTORES ','','NA','QRO','SAC120',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-06 13:39:52','eduardo.gonzalez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-05-08 00:00:00','Se solicita el precio del suministro y entrega de unas baterías de UPS para LAB PEMEX Cd. Del Carmen. Incluyendo la instalación.','','LAB PEMEX Cd. Del Carmen','MXO','SAC121',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-06 15:38:35','alberto.suarez@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-05-06 00:00:00','Se solicita parte para reparacion de UPS de Pemex Tar Zamora. Parte: Selector rotatorio. Numero de Parte: (tipo: C42) Marca: KRAUS & NAIMER Caracteristicas eléctricas: 65 Amp, 600 VAC.  Lugar de Entrega: Guadalajara. Nota: (En caso de que ocupen fotos de muestra de la parte estamos a sus  ordenes)','','CM-150','GDA','SAC122',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-06 15:52:01','rufino.moctezuma@gposac.com.mx','Ventas','Pregunta técnica','','','2013-05-06 00:00:00','Se solicita precio de suministro de baterías (marca la que propongamos) y flete a los lugares indicados en cada uno de los casos.  20 piezas  BATERIA SELLADA LIBRE DE MANTENIMIENTO DYNASTY MODELO UPS12-300MR DE 12 VOLTS 78 A.H. PARA UPS POWERWARE.		 Ubicado en la Cd. de Uruapan Mich.  	 18 piezas  BATERIA SELLADA LIBRE DE MANTENIMIENTO BATERIAS MOD GP1272 12V 7AH PARA UPS POWERWARE 9125 2 equipos ubicados a 40 min de Uruapan Mich.  (Charapendo y Lombardia Mich.)  1 equipo ubicado a 2 horas de Uruapan Mich.(Panindicuaro Mich.)	  24 piezas BATERIA SELLADA LIBRE DE MANTENIMIENTO MARCA CEGA POWER MODELO 6-GFM-7 O SIMILAR LEAD ACID  BATTERY 12V 7AH PARA UPS MARCA ZIGOR VOLGA DE 2KVA 1 equipo ubicado a 1 hora de Uruapan Mich. en Zamora Mich.  1 equipo ubicado a 1 hora de Uruapan Mich en Morelia Mich.  1 equipo ubicado a 2 horas de Uruapan Mich.  en Tacambaro Mich.  1 equipo ubicado a 1 hora de Uruapan Mich. en Los Reyes Mich. 	 4 piezas Batery Packs SYBTU1 - PLP , BATERIAS PARA UPS MARCA APC MODELO SYMMETRA 10 KVA EXPANDIBLE A 40KVA. UBICADO EN LA CD. DE URUAPAN MICH  Si se requiré mas información indidquenlo. Saludos.','','NA','QRO','SAC123',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-06 16:40:13','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-07 00:00:00','Buen día. Me pueden apoyar con el precio de 32 baterías marca csb con capacidad de 12V 7Ah, para un UPS Powerware modelo; 9155-15 de minera fresnillo, de igual forma les pido me apoyen con el precio de fletes, maniobra e instalación de las baterías por favor. ','','NA','GDA','SAC124',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-06 18:12:41','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-08 00:00:00','Me pueden apoyar con el precio del siguiente modulo por favor. CABE MENCIONAR QUE ES PARA EL CLIENTE SANMINA, EL MANEJA PUROS EQUIPOS APC.  MODULO DE PODER SYMMETRA LX 200/208V MARCA APC, LINEA SYMETRA, MODELO SYPM4KP CAPACIDAD: 4000VA / 3200 W, 120V, 208V, ó 120V / 240V, 60Hz VOLTAJE DE ENTRADA 200VAC ó 208 VAC RANGO DE REGULACION DE ENTRADA: 155 - 276 V DIMENSIONES Y PESO: ( Alto 17.5, Ancho 43.2, Fondo 75.7 )cm; 118.18Kg','','NA','GDA','SAC125',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-06 18:56:38','jorge.martinez@gposac.com.mx','Ventas','Levantamiento','','','2013-05-07 00:00:00','Buena tarde, se solicita de favor el apoyo del Ing. Joel Paz y otro Ingeniero de Servicio para realizar una visita de Levantamiento a detalle en la Ex-refineria 18 de Marzo, en Azcapotzalco, para la informacion que solicita PEMEX como es detalle de la implementacion de los equipos a renovar, plan de trabajo y etapas en las que se realizaran estos trabajos.  Le reunion es el dia de mañana a las 10:00am con el Ing. Victor Portales de PEMEX,  Quedo a sus ordenes en espera de su respuesta y/o comentarios, gracias  saludos','','CM329','MXO','SAC126',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-07 18:35:34','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-05-07 00:00:00','Una batería de 12 volts 27 placas, ya se tiene precio $4,200 + IVA.  PE-0012 Requerimiento de preventivo ','','CM150','MXO','SAC127',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-08 11:28:15','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional), Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-09 00:00:00','BUEN DÍA. ME PUEDEN APOYAR POR FAOR, LO QUE NECESITO ES: 1; COSTO DE INSTALACIÓN PARA 16 MÓDULOS DE BAT. (CON 8 BAT. C/MODULO), MODELO SYBT4,  1 MODULO DE PODER MODELO SYPM10K16H Y 1 MODULO DE BAY PASS, Maintenance Bypass Panel 20-30kVA 208V Wallmount (EL BYPASS SE ENCONTRARA A 5 METROS DE DISTANCIA DEL UPS). 2; ME PUEDEN PROPONER QUE BYPASS SE NECESITA ASI COMO EL PRECIO. 3; EL COSTO DEL FLETE PARA TODOS LOS EQUIPOS. ESTOS EQUIPOS SE ESTARÁN INSTALANDO EN EL TAR GOMEZ PALACIO EN DURANGO Y EL EQUIPO PARA EL QUE SE NECESITAN ESTOS ACCESORIOS ES UN: UPS  MARCA APC MODELO SYMMETRA PX CON CAPACIDAD DE 10KVA CON CRECIMIENTO A 40 KVA         ','','NA','GDA','SAC128',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-09 15:32:51','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-09 00:00:00','Solicito precio de la siguiente planta de ottomotores 1 pieza de  PLANTA  GENERADORA  DE  ENERGIA  ELECTRICA   (PE-01)   PARA   EL   SISTEMA   ELECTRICO   ESENCIAL,   DE  250kW/312,5kVA, SERVICIO CONTINUO, GRADO HOSPITAL CON 10% DE SOBRE  CARGA   PARA 2 HORAS 3F-4H+PT, 480/277V,  60Hz,   F.P=0.80,   CON   INTERRUPTOR  DE  3P-400A  AL PIE  DEL GENERADOR  MARCA  OTTOMOTORES   (LOS  VALORES  REQUERIDOS   SON  EFECTIVOS  A  1 891 m.s.n.m.),  CON  BASE  TANQUE  INTEGRADO CON CAPACIDAD DE 550lts, CON UN  NIVEL  DE  RUIDO =77 dB A 10m, PESO= 2 355kg, CLASE=24 hrs LOS 365 DIAS DEL AÑO, TIPO= 10 SEGUNDOS, NIVEL 1 (SEGURIDAD DE  VIDA) DE  ACUERDO A  LA  NFPA 110 VIGENTE  Quedo a sus ordenes, gracias,','','NA','QRO','SAC129',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-09 17:33:11','rufino.moctezuma@gposac.com.mx','Ventas','Pregunta técnica','','','2013-05-09 00:00:00','Solicito precio de viáticos para mantto de UPS en los siguientes lugares.  Viáticos para 1 servicio de mantto para UPS en  Ubicado en la Cd. de Uruapan Mich.   Viaticos para 2 servicio de mantto para UPS en   2 equipos ubicados a 40 min de Uruapan Mich.  (Charapendo y Lombardia Mich.) 1 equipo ubicado a 2 horas de Uruapan Mich.(Panindicuaro Mich.)  Viaticos para 4 servicio de mantto para UPS en  1 equipo ubicado a 1 hora de Uruapan Mich. en Zamora Mich.  1 equipo ubicado a 1 hora de Uruapan Mich en Morelia Mich.  1 equipo ubicado a 2 horas de Uruapan Mich.  en Tacambaro Mich.  1 equipo ubicado a 1 hora de Uruapan Mich. en Los Reyes Mich.   Viaticos para 1 servicio de mantto para UPS en  Ubicado en la Cd. de Uruapan Mich.   Si se requiere mas información, comentenlo  Saludos y gracias.','','NA','QRO','SAC130',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-09 17:59:03','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-05-09 00:00:00','La tarjeta COMMUNICATION INTERFACE A008/21391-3/DPD95185  presenta falla','','CM150','QRO','SAC131',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-09 18:04:25','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-13 00:00:00','Se requiere la ayuda para determinar precio de 2 piezas del cilindro Humidificador con numero de parte 154-060-005  estos se suministraran a dos equipos de aire marca Data aire modelo DAWD 3034. los numeros de serie de los equipos a los que se les suministrara estos cilindros es a los siguientes:  S/N: 2012-1955-A S/N: 2012-0404-A   quedando en espera de sus comentarios agradezco su atencion','','na','MXO','SAC132',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-09 18:42:21','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-05-09 00:00:00','* 1 Juego de empaques del compresor siguiente: Marca Carlyle Modelo : 06DF8252BA3260G VOLTS 208/230 FASES 3 60 HZ INCLUIR JUEGO DE EMPAQUES DE VÁLVULA DE SERVICIO ALTA Y BAJA Y TAPONES DE VÁLVULAS DE SERVICIO ALTA Y BAJA(EX-REFINERÍA TULA) $1500 * 4 CAPACITORES 5 MICROFALADIOS (ROSALES) $31 C/U * 1 TARJETA MINISPLIT MOD.QTH-700W $450 (ROSALES)    AUTORIZAR COMPRA SI NO ESTA EN INVENTARIO, AUN NO TENGO NO. DE ORDEN   ','','CM122','MXO','SAC133',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-13 11:26:02','rogelio.valadez@gposac.com.mx','Gerentes al Area de Compras','','','','2013-05-17 00:00:00','Se solicita la compra de laptop y escritorio para cordinadora de servicio.  Gracias','Requerimiento de Compra de Activos','NA','MXO','SAC134',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-13 11:34:45','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-05-13 00:00:00','2 MOTOR: 3/4 HP, 920/110 RPM, 220/460 VOLTS, 50/60 HZ, FLECHA 5/8, COMPLETAMENTE CERRADO.   2 CAPACITOR PARA MOTOR','','CM150','QRO','SAC135',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-13 13:14:14','rufino.moctezuma@gposac.com.mx','Ventas','Pregunta técnica','','','2013-05-13 00:00:00','Solicito apoyo para localizar en el tiempo mas inmediato posible el siguiente equipo:  TE3XDS154XM	 240/120V 3Ø, 4W Plus Ground High Leg Delta ( 3 Hots, 1 Neutral, 1 Ground)	  Un cliente nos lo pide en el menor tiempo de entrega, Quedo a sus ordenes, gracias.','','NA','QRO','SAC136',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-13 16:40:45','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-14 00:00:00','ME PUEDEN APOYAR CON EL PRECIO PARA UNA PLANTA DE EMERGENCIA DE 80KVA A DIESEL CON UNA TRANSFERENCIA A 460V, CON CASETA ACÚSTICA PARA EXTERIOR, AISLADORES TIPO RESORTE Y UN TANQUE DE 500 LTS.','','NA','GDA','SAC137',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-13 19:09:56','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-05-13 00:00:00','1 TARJETA DE TRANSFERENCIA MOD. TRN 90-5 PARA PE SELMEC $3484.60 AUTORIZAR COMPRA ','','CM150','MXO','SAC138',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-14 18:07:33','berenice.martinez@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-05-15 00:00:00','TAR	                  EQUIPO	MODELO		CAPACIDAD HERMOSILLO	DATA AIRE	DTAD-0332-AO	2010-2254-A	3 TR 2 FILTROS MEDIDAS: 16X25X4.				 				 CILINDRO DEL HUMIDIFICADOR, EL CUAL ES EL				 MARCA NORTEC.				 MODELO: CYLINDER 202. 				 PART No.: 1519002				 				 OBREGON	DATA AIRE	DTAD-0332-AO 	2010-2256-A	3 TR CILINDRO  HUMIDIFICADOR 202 IN UNIT 6232				 				 				 CULIACAN	DATA AIRE	DCAU-0312-AO	2010-2232-A	3 TR EL CONTACTOR		 MARCA CUTLER-HAMMER				 P/N: C25DND330				 				 MAGDALENA	DATA AIRE	DACU-0212-AO	2010-2245-A	3 TR GAS 407				 				 NOGALES	DATA AIRE	DACU-0212-AO	2010-2244-A	3 TR  3 FILTROS DE AIRE 16x16x1				 				 NOGALES	UPS 	POWERWARE	PROFILE	12.5 RECTIFICADOR NO SE TIENE MAS INFORMACIÓN.				 				 GUAYMAS	DATA AIRE	DCAU-0312-AO	2010-2231-A	3 TR CONTACTOR								 MARCA CUTLER-HAMMER				 MODELO: C25DND330T				 				 CONTRATO CM150				  FAVOR DE ENVIAR A CAMILO PEÑA FRANCO, CENTRO DE SERVICIO SICET, CULIACAN, SIN.  Dom: Mariano Escobedo 1133, Col las Vegas CP. 80090 Culiacan, Sinaloa.  ','','CM150','GDA','SAC139',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-15 17:43:07','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-05-21 00:00:00','Buen día  Me pueden apoyar con una cédula de costos para una póliza de mantenimiento a plantas de emergencia en PEMEX, e el cual se tienen que generar un catalogo de conceptos, desglosados por tipo de servicio, actividad a realizar y refacciones. Existe un archivo de referencia de estos precios el cual se oferto el año pasado. Anexo el link con los archivos de referencia https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0B2jQgfvQJ9a0OGlacUYwaFBNZUk  NOTA: LUIS ANDRADE SE COMPROMETIÓ A DARME RESPUESTA EL MARTES 21 DE MAYO.','','NA','GDA','SAC140',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-16 11:48:50','jorge.martinez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-05-17 00:00:00','Favor de comunicarse a la Empresa HUMAN FACTOR con Elsa Huerta sus datos de contacto son: Tel: 01 55 4212 1500 mail: ehuerta@humanfactor.mx  Para atender 2 asuntos de PEMEX que vamos a dar el servicio :  - Se requiere integrar una camara de Video vigilancia a una consola BOSCH Mod. DR21650 de 16 puertos tipo BNC. Esto es en el site del 4to piso del Edificio C del corporativo de PEMEX en Av. Marina Nacional, Mexico DF. Esta consola BOSCH que en realidad es el CPU de una computadora, tiene falla en una tarjeta de su fiuente de alimentacion por lo tanto se requiere que el proveedor realize una visita de levantamiento para cotizar la reparacion de dicha consola.  - Se tiene un control de acceso con un sitema Mayfer Guardian que es donde esta la base de datos de los usuarios que estan registrados, esta base de datos esta en una PC con Windows XP, pero se debe de cambiar todo el sistema a otra con Windows 7, tambien requerimos cotize este servicio,  Lo primero es conseguir la visita de levantamiento para que puedan cotizar la reparacion de la consola BOSH y la integracion de la camara de videovigilancia a esta,  quedo a sus ordenes en espera de su pronta respuesta y/o comentarios, gracias  saludos   - ','','CM121','MXO','SAC141',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-17 14:05:56','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-05-23 00:00:00','1 MODULO DE POTENCIA para symmetra px MOD. SYPM10KF PARA TAR CAMPECHE, OS. 0577 ENVIAR A ARO SISTEMAS :Calle 17 NO.200 J x 24. Col. Garcìa Ginerès C.P. 97070 Mèrida, Yucatàn a nombre de Armando Ramos Oramas. Ya se verificò con Jorge Chàvez la disponibilidad en inventario.','','CM150','MXO','SAC142',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-17 15:46:44','ivan.ramirez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-05-20 00:00:00','BUEN DÍA, RESPECTO AL PROYECTO CM253 DE DAIMLER SE REQUIERE SE REALICE UNA CAPACITACIÓN DE FUNCIONES BÁSICAS DEL EQUIPO SUMINISTRADO AL USUARIO FINAL Y SE GENERE UNA CONSTANCIA DE CAPACITACIÓN, TAMBIÉN SE REQUIERE SE PROPORCIONEN LOS  MANUALES DE OPERACIÓN DE CADA UNO DE LOS EQUIPOS SUMINISTRADOS, SE REQUIERE DE UN ESQUEMA ELÉCTRICO DE FUNCIONAMIENTO DEL EQUIPO BY PASS (PASOS A SEGUIR PARA OPERAR BY PASS  MANUAL ) ESTO PARA QUE SE ADHIERA AL EQUIPO Y PUEDA SER OPERADO POR EL PERSONAL DE MANTENIMIENTO.  LINK DE CEDULA DE PROYECTOS https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AobMHo1P0jzedFpIUXJYWEVlX1R1WlJsd0RTeEJyQVE&usp=sharing  ','','CM253','MXO','SAC143',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-17 15:52:41','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-17 00:00:00','Requiero saber si el siguiente equipo se puede conseguir en un menor tiempo de entrega con  Ottomotores.  TE3XCS104XAM 240/120V 3Ø, 4W Plus Ground High Leg Delta ( 3 Hots, 1 Neutral, 1 Ground) 03  = 240/120V High Leg Delta (B High) (Fig 3)  Saludos','','NA','QRO','SAC144',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-17 20:49:36','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-05-21 00:00:00','1 MODULO DE POTENCIA para symmetra px MOD. SYPM10KF PARA TAR OAXACA, OS. 1401','','CM150','MXO','SAC145',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-20 14:23:21','jorge.martinez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-21 00:00:00','Mesa de ayuda,  Buena tarde, por medio del presente solicito el precio y tiempo de entrega de una bateria con las siguientes caracteristicas:  Modelo: 19 VRPP 36, 2 cell blocks, 36AH, 1.2V  como referencia ya suministramos 8 piezas de esta bateria en el 2011 junto con un UPS Controled Power Mod. LT1600 y la factura que se les dio fue la M-14,  Quedo a tus ordenes en espera de tu prontar respuesta, gracias  saludos','','CM339','MXO','SAC146',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-20 17:26:31','alberto.suarez@gposac.com.mx','Implementación y Servicio','','Pregnta Técnica','','2013-05-21 00:00:00','Se diagnostico un UPS Galaxy 3500, de capacidad: 15 KVA, en Pemex TAR Uruapan. PREGUNTA: ¿ Tenemos en almacen ?:                          Parte: Modulo Principal de Poder.                         Modelo: OG-SUVTPM15KF-P  Cualquier pregunta estoy a sus ordenes.  Saludos.  ','','CM150','GDA','SAC147',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-21 18:20:00','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisiciòn de Parte o refacción (Indicar al final el numero de proyecto)','','2013-05-21 00:00:00','4 piezas  Ventiladores Narca NIDEC BETA V, Modelo A34438-59 P/N 956500 24Vcd 1.4Amp','','cm150','QRO','SAC148',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-21 20:37:04','luis.andrade@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-05-21 00:00:00','Prueba','','cm150','QRO','SAC149',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-21 23:45:08','jorge.martinez@gposac.com.mx','Ventas','Elaboración de Plano e Imagenes 3D del SITE (se deben anexar planos del edificio y dibujos de levantamiento)','','','2013-05-23 00:00:00','Mesa de Ayuda,  Buena tarde, por medio del presente solicito de favor la elaboracion en 3D de el plano para la propuesta de RCI de implementacion de Equipos Inrow en su actual SITE una vez que el cliente acomode los Racks en pasillo caliente y frio,  En el correo que me llegue de esta requisicion les enviare:  - Plano actual del sembrado de los equipos (elaborado por Ing. Joel Paz) - Plano de primera propuesta de implementacion de Aire Inrow reacomodando los Racks (elaborado por Ing. Joel Paz), solo que en esta propuesta se tiene un pasillo frio al centro y 2 pasillos frios en los extremos, lo que se busca ahora es poner un pasillo caliente al centro y 2 frios en los extremos con 2 equipos de Aire Inrow de 60cm cada uno, uno en cada fila de Racks, - Fotos del SITE actual,  Quedo a sus ordenes para cualquier comentario y/o duda, gracias  saludos','','CM302','MXO','SAC150',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-22 16:30:10','salvador.ruvalcaba@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-05-28 00:00:00','3 TC''s 1500/5 amp. con precio de 164 USD + IVA en Kitron.','','CM150','GDA','SAC151',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-23 12:39:23','luis.andrade@gposac.com.mx','Gerentes al Area de Compras','','','','2013-05-28 00:00:00','Computadora para Jose Luis de Servicio (considerar una computadora como las Ghia que se han comprado).  La computadora que actualmente tiene, no tiene batería y además se calienta mucho por lo que es necesario ponerle ventiladores. Considero que tiene buena capacidad por lo que esa pudiera usarse en personas que no necesiten portabilidad.   ','Requerimiento de Compra de Activos','NA','GDA','SAC152',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-23 17:32:21','eduardo.gonzalez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-24 00:00:00','Se requiere cotización de acuerdo a la siguiente descripción:  Suministro e instalación de CHILLER de 30 toneladas con dos circuitos, bombas redundantes y una instalación hidraúlica de 60 m a rematar en un CDU. Una instalación eléctrica de 30 m, incluyendo pastilla y tablero, ó incluyendo pastilla con gabinete a intemperie.  Maniobras:  Considerar grúa para montaje en un tercer piso y una base.  El lugar de suministro es Villahermosa-Tabasco. El Cliente es Petroleos Mexicanos.','','CM343','MXO','SAC153',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-24 01:49:14','salvador.ruvalcaba@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-07 00:00:00','Favor de suministrar los siguientes equipos faltantes para el Demo Room: 1- Gabinete de baterías para 1100A 64- Baterías 12v 7Ah para dicho banco de baterías 2- Interruptores 20amp ABB (uno con contacto auxiliar) para dicho banco de baterías. 1- transformador aislamiento 10Kva 220/480VAC 3 fases. 1- Gabinete PDU para 1100 (incluir interruptor principal y tablero de distribución) 1 - Variac Manual 3 fases 220/127VAC 15amp. 32- baterías 12v 7Ah para rehabilitar 4 unidades (1 banco) para SyPX','','SAC Demo Room Qro','QRO','SAC154',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-24 11:03:34','jose.osorio@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-03 00:00:00','CINCO TARJETAS 66074 TARJETA DE RED PARA UPS APC GALAXY 5000 PARA IMPLEMENTACION DE MONITOREO, PARA SALINA CRUZ.','','CM-150','GDA','SAC155',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-24 11:08:02','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-05-24 00:00:00','1 COMPRESOR DANFOSS MOD.HRM038U1U1LP6 PARA PEMEX EL ROSAL O.S.2763, YA SE TIENE COTIZACION POR $13,500 ENTREGA 1 DIA, AUTORIZAR COMPRA.','','CM122','MXO','SAC156',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-27 13:05:37','marlem.samano@gposac.com.mx','Gerentes al Area de Compras','','','','2013-05-31 00:00:00',' compra de overoles Paso la lista  48 - 1 44 - 5 42- 7 40- 11 38 - 10 36 - 8 46  - 1  se Adquirieron en Uniformes de Tampico. El telefono es: 442  2158773 Los overoles son de color naranja con cintare flejante.','Requerimiento de Compra de Activos','NA','QRO','SAC157',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-27 13:25:44','rogelio.valadez@gposac.com.mx','Gerentes al Area de Compras','','','','2013-05-27 00:00:00','Se requiere la compra de un teléfono IP fijo para Eduardo.  Gracias','Requerimiento de Compra de Activos','NA','MXO','SAC158',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-27 17:04:39','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-05-31 00:00:00','1 TARJETA DE BARD MOD. MC4000-BC YA COTIZADA EN $1245 CON TIEMPO DE ENTREGA 4 SEMANAS, FAVOR DE CONFIRMAR SI NO ESTA EN INVENTARIO O SE TIENE UNA MEJOR OPCIÓN EN TIEMPO, ES PARA SUMINISTRO EN SITIO ARROYO MORENO, VER. ','','CM122','MXO','SAC159',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-28 09:33:34','jorge.martinez@gposac.com.mx','Ventas','Levantamiento','','','2013-05-30 00:00:00','Mesa de Ayuda,   Buen dia por medio del presente solicito de favor una visita de levantamiento de un Ingeniero de Servicio junto con el proveedor Human factor a las Instalaciones de PEMEX en el edificio C, piso 4, del corporativo de PEMEX en Av. Marina Nacional, Mexico DF. para revisar y poder cotizar:  1. Integracion de una camara de Video vigilancia a una consola BOSCH Mod. DR21650 de 16 puertos tipo BNC. Esta consola BOSCH  es el CPU de una computadora, tiene falla en una tarjeta de su fiuente de alimentacion por lo tanto se requiere que el proveedor realize una visita de levantamiento para cotizar la reparacion de dicha consola.   2. Se tiene un control de acceso con un sitema Mayfer Guardian que es donde esta la base de datos de los usuarios que estan registrados, esta base de datos esta en una PC con Windows XP, pero se debe de cambiar todo el sistema a otra con Windows 7, tambien requerimos cotize este servicio,   Referencia de solicitud anterior: Requisición General SAC141  Quedo a sus ordenes en espera de su pronta respuesta y/o comentarios, gracias saludos,  ','','CM121','MXO','SAC160',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-28 11:12:51','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-05-28 00:00:00','Tarjeta opcional para poder tener contactos secos de su estado de operación del mitsubishi 1100 para el proyecto de HDI   su número de es PCB10318  ','','CQ327','QRO','SAC161',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-28 11:27:43','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-05-28 00:00:00','Batería 12 Volts 7aH, para instalación en la Refinería Cadereyta, este poryecto fue vendido el año pasado y se quedo con un saldo a favor por parte del cliente.','','CQ236','QRO','SAC162',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-28 11:50:15','eduardo.gonzalez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-06-04 00:00:00','Se solicita apoyo de un Ingeniero del área de Ingeniería o Servicio, para visitar y realizar un levantamiento de las instalaciones de la SEP. Trata de UPS, Plantas Eléctricas y Subestaciones Eléctricas. El principal propósito: participar en la licitación correspondiente: LA-011000999-N701-2013.  El apoyo se requiere para el día Martes 4 de Junio de 2013. La visita se realizaría preferentemente por la mañana, en un horario aproximado de 10:00-11:00 ó de 11:00-12:00','','LICITACIÓN SEP: LA-011000999-N701-2013','MXO','SAC163',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-28 14:16:36','jorge.martinez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-30 00:00:00','Mesa de Ayuda,  Buena tarde, de favor me pueden cotizar un Regulador de tension de 200kva, trifasico a 208V, para entrega en Carretera a Estación Juárez S/N km 1.5 Zona 5 Dentro de la Zona Industrial. VILLAHERMOSA, TAB   Quedo a sus ordenes en espera de su pronta respuesta gracias  saludos','','NA','MXO','SAC164',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-28 17:05:35','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-28 00:00:00','Buenos dias.  Solicito precio de baterias para UPS Mitsubishi  2033C,  Capacidad del UPS: 15kVA,20kVA         Tipo:  PM12-18,      Marca:   Power Battery Inc.     ó  Tipo:  NP18-12B,     Marca:   Yuasa Corp.   Cantidad de baterias:    30   Quedo al pendiente, saludos ','','NA','QRO','SAC165',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-28 18:01:20','eduardo.gonzalez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-05-30 00:00:00','Se solicita apoyo de un Ingeniero del área de Ingeniería o Servicio, para visitar y realizar un levantamiento de las instalaciones de la SEP. Trata de UPS, Plantas Eléctricas y Subestaciones Eléctricas. El principal propósito: participar en la licitación correspondiente: LA-011000999-N701-2013. El apoyo se requiere para el día Jueves 30 de Mayo de 2013, ya que el acto de presentación y apertura de proposiciones es el día Viernes 7 de Junio. La visita se realizaría preferentemente por la mañana para ocupar la mayor parte del día.','','LICITACIÓN SEP: LA-011000999-N701-2013','MXO','SAC166',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-28 18:06:03','juanjose.espinoza@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-05-31 00:00:00','Buen día solicito de su apoyo. El cliente de ciudad judicial (con el cual tenemos 2 contratos de póliza de mantenimiento) nos esta pidiendo que este personal de SAC presente ya que realizaran una prueba de corte de energía y necesita que  supervisemos que el equipo hace su función correctamente al momento de hacer el corte de energía. ','','PG404','GDA','SAC167',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-29 13:38:59','ivan.martin@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-05-31 00:00:00','Se solicita cedula de costos para cotizar Bypass de Mantenimiento externo de UPS Symmetra PX (dos equipos) de acuerdo a lo visto en la ultima visita de mantenimiento en SITE de Caja Morelia Valladolid','','CQ421','QRO','SAC168',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-29 14:14:24','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-05-31 00:00:00','Buen dia me pueden apoyarn con una Cedula de costos para la integración al central  para 2 equipos MGE Modelo; EPS7000 con capacidad de 500KVA y 1 equipo APC modelo; Galaxy 3500 con capacidad de 30KVA, así como la configuración de sus alarmas para notificación via correo (informativas al cliente y emergencias al call-center)','','cg404','GDA','SAC169',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-29 20:04:41','salvador.ruvalcaba@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-10 00:00:00','Interfase para control de planta de emergencia 7320 (Dale3200), Modelo DSE892 SNMP Gateway. Precio: $6,177.50 pesos - 20% de descuento + iva Proveedor: Grupo Idimex  octavio.tovar@grupoidimex.com.mx ww.grupoidimex.com.mx (55) 5 588 95 49','','NA (para SAC demo room Qro)','QRO','SAC170',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-30 15:51:45','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-04 00:00:00','SE REQUIERE DEL APOYO PARA PROPORCIONAR EL PRECIO QUE TENDRÍA UNA TARJETA DE CONTROL PARA UN EQUIPO MARCA LIEBERT MODELO NXB30 DE 30KVAS DICHO EQUIPO SE ENCUENTRA EN CONTRATO DE MNTTO. EL MODELO EXACTO DE LA TARJETA LO PROPORCIONARA PERSONAL DE SERVICIO MEXICO (JUAN PABLO PROCOPIO)','','CM23','MXO','SAC171',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-30 17:04:59','juanjose.espinoza@gposac.com.mx','Ventas','Levantamiento','','','2013-06-03 00:00:00','Me pueden apoyar con una persona para realizar un levantamiento en el edificio gubernamental del ayuntamiento de Tlajmulco de Zuñiga seria el lunes 03 de Junio y necesitamos estar en sitio a las 4:00 pm','','NA','GDA','SAC172',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-30 18:17:14','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-31 00:00:00','Me pueden apoyar con el precio de 3 modulos de baterias marca APC modelo: RBC43 descripción; APC Replacement Battery Cartridge #43.  Para UPS  APC modelo; SUA3000RM2U, es para el cliente sanmina  ','','CG418','GDA','SAC173',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-05-30 18:21:21','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional), Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-05-31 00:00:00','Me pueden apoyar con una cédula de costos para el suministro e instalación de: 1 (pza.) Fusible de 1250A, 600V. 1 (pza.) Fusible de 3A, 600V. 2 (pza.) Módulos Inversores. 1 (pza.) Modulo de Capacitores de DC.  1 (pza.) Placa Aislante.  1 (pza.) Tarjeta CRIZ. 1 (pza.) Tarjeta CROZ.   Esto para un Equipos MGE modelo; EPS7000, con capacidad de 500KVA, para el cliente CIUDAD JUDICIAL','','cg404','GDA','SAC174',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-03 11:50:20','juanjose.espinoza@gposac.com.mx','Ventas','Levantamiento','','','2013-05-04 00:00:00','Buen día Me pueden apoyar con una persona de servicio o ingenieria ya que necesito realizar un levantamiento en la empresa UREBLOCK para un sistema de detección. Seria el Martes 04-mayo a las 10:00 am','','NA','GDA','SAC175',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-04 09:34:13','ivan.ramirez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-06-05 00:00:00','Buen dia Raul me puedes ayudar a consultar con Roberto o Salvador Ruvalcaba los requisitos que se requieren para poder instalar un netcom2 de un 9900A y que a su vez las alarmas generadas lleguen a un correo del usuario y este a su vez las reenvié automáticamente al call center de grupo sac.','','CM253','MXO','SAC176',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-04 11:32:07','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional), Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-06 00:00:00','BUEN DIA ME PUEDEN APOYAR CON UN PRECIO PARA   *Suministro, instalación y puesta en operación de una planta generadora de energía eléctrica con capacidad de 600 kW, para uso continuo (sistema electrógeno),   *Suministro, instalación y puesta en operación de una planta generadora de energía eléctrica de emergencia, con capacidad de 350 kW, 535 BHP incluyendo  tablero de control con transferencia automática, en transición abierta (sistema electrógeno),   *Suministro, instalación y puesta en operación de un tablero general de baja tensión con un interruptor electromagnético montaje removible de 1200  amperes y equipo de medición PM850 o de calidad equivalente.  *Suministro, instalación y puesta en operación de una planta generadora de energía eléctrica con capacidad de 50 kW, para servicio de emergencia incluyendo  tablero de control con transferencia automática, en transición abierta (sistema electrógeno).  ES PARA UNA CÉDULA PARA ESTUDIO DE MERCADO DE INEGI. SE NECESITA CONSIDERAR MANIOBRAS, INSTALACIÓN Y DESINSTALACIÓN DE EQUIPO YA EXISTENTE. ANEXO EL LINK CON LOS PLANOS Y LA INFORMACIÓN REQUERIDA PARA COTIZAR EL EQUIPO REQUERIDO  https://drive.google.com/a/gposac.com.mx/?tab=mo&pli=1#folders/0B2jQgfvQJ9a0dkh6T0g3WENCOW8 ','','NA','GDA','SAC177',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-04 15:26:26','berenice.martinez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-04 00:00:00','Buen día, Solicito de favor la siguiente refacción.  TAR MAZATLAN OS-0261 CILINDRO HUMIDIFICADOR CYLINDER 202 IN UNIT AA, MARCA DATA AIRE, DTAD-0532-AO, 5 TR  CM150  FAVOR DE ENVIAR A CAMILO PEÑA FRANCO  DOMICILIO: MARIANO ESCOBEDO #1133 COL. LAS VEGAS CULIACAN, SINALOA OFICINA 1:. 667-455-69-95 MOVIL :. 667-191-01-16  ','','CM150','GDA','SAC178',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-05 11:30:51','jorge.martinez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-06 00:00:00','Mesa de ayuda,  Buen dia de favor me pueden cotizar con su mejor precio y su mejor tiempo de entrega las siguientes baterias que son para una licitacion:  60 Piezas del Modelo UPS12-400MR (12V, 103AH) Mca. Dynasty 28 Piezas del Modelo UPS12-150MR (12V, 34.6AH) Mca. Dynasty 80 Piezas del Modelo UPS12-490SR (12V, 138AH) Mca. Dynasty 40 Piezas del Modelo UPS12-540MR (12V, 147AH) Mca. Dynasty  Quedo a sus ordenes en espera de sus comentarios, gracias  saludos','','CM306','MXO','SAC179',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-06 10:49:06','juanjose.espinoza@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-05-07 00:00:00','Buen día. Me pueden  apoyar con personal para realizar el diagnostico de 2 UPS de PEMEX (los cuales no esta en contrato), que tenemos en  nuestras instalaciones.','','NA','GDA','SAC180',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-06 12:24:30','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-10 00:00:00','1 Módulo de ventiladores modelo OG-0901311.  Es para una equipo APC SL80KF originado del reporte 13-145, confirmar si se puede enviar directo a Isec Ingeniería o se envía a oficina.','','CM150','MXO','SAC181',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-06 17:43:11','jorge.martinez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-06-10 00:00:00','Mesa de Ayuda,   Buena tarde de favor me pueden cotizar un mantenimiento preventivo y una poliza de mantenimiento anual a una subestacion ubicada en la Cd. de Mexico en el Cerro del Chiquihuite, para presentar ambas opciones el cliente es Grupo Radio Centro  Los datos de la subestacion son:  - Tablero Normal con interruptor principal de 500Amp de capacidad - Tablero I- Line que distribuye a la carga - Transformador Mca Voltarn de 500 Kva - Subestacion Mca FDI SA. de CV, de 300kva  Se requiere costo de servicios y costo del tramite de la libranza con CFE,  Oscar Huerta (Ing. de Servicio, Oficina Mexico) realizo el levantamiento y tambien conoce de dar estos servicios ya que ha tarbajado en eso y puede conseguirnos quien nos cotize o que nos renten los equipos para el servicio y orientarnos para saber cuanto cobrar,  quedo a sus ordenes en espera de su respuesta, gracias  saludos','','NA','MXO','SAC182',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-07 16:56:23','ivan.ramirez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-06-10 00:00:00','Se requiere cédula de costos para instalación de un equipo mitsu 7011-60 solo considerar remate de tubería y cableado para la instalación eléctrica  (solo conexión de puntas al equipo) el equipo incluye tarjeta netcom favor de considerar su instalación y configuración la cedula de proyectos se encuentra como 4-VE-05 CEDULA DE PROYECTOS FEZACON CM313 2','','CM313','GDA','SAC183',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-07 18:09:05','ivan.martin@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-06-11 00:00:00','Se solicita cédula de costos para la ubicación de condensadora del AAP  de Siemens conforme al levantamiento que realizo personal de servicio en mantenimiento preventivo.  Este el el levantamiento para cambiar la condensadora del Aire de Precisión APC del lugar donde esta hacia la porte de la azotea.  Peso condensadora aproximado: 200 Kg. Altura de lugar donde se ubicara la condensadora: 5 Mts.  Requerimientos para la instalación eléctrica:  Cable Cal. #12: 30 Mts. Cable Cal. #10: 60 Mts. Cable Cal. #18: 60 Mts. Cable Cal. #14: 150 Mts. 4 Condulets LB 1 Condulet LL 1 Condulet LR 4 tramos de tubo conduit pared gruesa 1"  Este arreglo es una propuesta que puede variar dependiendo de quien haga la instalación. (Grupo SAC o Sr. Carlos)   Requerimientos para la instalación tubería de cobre:  Refrigerante R22. 4 Tramos de tubo de cobre 1/2" 4 Tramos de tubo de cobre 3/4" Soldadura de la tubería de cobre.   ','','CQ453','QRO','SAC184',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-07 18:32:30','ivan.martin@gposac.com.mx','Ventas','Pregunta técnica','','','2013-06-11 00:00:00','Se solicita el historico de cargas de las UPS de izcalli y polanco, para determinar si es conveniente reubicar un SC de izcalli a polanco.','','NA','QRO','SAC185',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-10 10:25:44','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-12 00:00:00','Buen día. Me pueden apoyar con: El tipo y costo de un bypass externo para un equipo UPS Mitsubishi 1100A con capacidad de 20KVA. Y el tipo, costo y dimensiones de un gabinete para colocar el bypass y 128 baterías con capacidad de 12v-7Ah. Necesito lo mismo (bypass externo y gabinete) para un equipo UPS APC symmetra PX con MODELO: ISX20K20F con capacidad de 20KVA.  De antemano gracias por su apoyo.','','CG419 y CG422	','GDA','SAC186',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-10 16:21:40','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-10 00:00:00','4 BATERIAS 27 PLACAS MOD.L8D-1125 MARCA LTH, YA SE TIENE COTIZACION DE SITE, SE ENVIO POR MAIL A JORGE CHAVEZ, OS0064 y OS0065, DIAGNOSTICO EN VISITA PARA SITIO PARAISO, DOS BOCAS','','CM150','MXO','SAC187',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-10 19:39:51','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-15 00:00:00','2 LECTORAS BIOMETRICAS TERMINAL NITGEN NAC-2500, INCLUYE SOFTWARE DE ADMINISTRACION EN RED ACCESS MANAGER, PARA WINDOWS XP, VISTA, SEVEN, PARA 3000 USUARIOS, APERTURA DE PUERTA A TRAVES DE SOFTWARE $ 7,500.00 C/U   1 LECTOR HAMSTER II, PARA DAR DE ALTA USUARIOS MOD. HAMII $ 1,690.00    1 BOTON DE SALIDA SECO-ALARM MODELO SD-927PKC-NSQ SIN CONTACTO, RANGO DE PRESENCIA HASTA 10 CM, BICOLOR, METAL, SALIDA DE RELEVADOR, EMPOTRABLE, 12 VCD, DIMENSIONES 76X11X29 MM $ 650.00   2 CHAPAS MAGNETICAS DE 750 LB, LIBRE DE MAGNETISMO, SUJECION 340 KG, BRACKET AJUSTABLE, 12 VCD. $ 2,850.00 C/U   1 FUENTE DE RESPALDO CON FUENTE Y CARGADOR DE BATERIA, INLCUYE BATERIA 12-7AH DE RESPALDO $ 1,850.00   CORRESPONDEN A ORDEN 0353 DE USUMACINTA, COTIZACION DE ISEC INGENIERIA','','CM150','MXO','SAC188',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-11 12:55:35','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-11 00:00:00','Buen dia me pueden apoyar con el precio y tiempo de entrega de un software  el cual permita monitorear y controlar (Manipular) la temperatura de un aire acondicionado Data Aire  DAP III, el cual tiene instalada una tarjeta de red con protocolo de comunicación SNMP.','','cg356','GDA','SAC189',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-11 14:16:46','jorge.martinez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-06-12 00:00:00','Mesa de Ayuda,   Buena tarde, favor de proporcionarme la ficha tecnica de la bateria UPS12-490SR, Marca DYNASTY, URGEE este requerimiento a mas tardar para mañana a medio dia, ya que es para anexar a una licitacion que se entrega el Jueves a las 10:00am en Compranet,  quedo a sus ordenes en espera de su pronta respuesta, gracias  saludos ','','CM306','MXO','SAC190',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-11 16:55:52','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-06-11 00:00:00','Buenos dias.  Solicito apoyo con una cedula de costos por al instalación de un AAP de 5 Tons, con la siguiente descripción: MINI PLUS AIRE REFRIGERADO 5 TON 1 PH 208-230 VW / DRCU, FASE 1, TENSIÓN-208, FLUJO DE AIRE - STANDARD, Refrigerante R-410A, COIL-MINIPLUS 4T-5T, RECALIENTE-ELEC 6KW 208/230V, MTR-1PH 208V 1.5HP, Mini dap4 w / sensor remoto, DISPLAY CABLE-35 '', DAP4, FILTRO-MINI 4 y 5 T MERV8, OUTDOOR unidad de condensación UNIDAD 5 TON 1 PH 208-230 V, FASE 1, TENSIÓN-208, AMBIENTE-95, Refrigerante R-410A, COIL-CONDENSER/CONDENSING 5T, COMPRSR-SCR 5T 1PH 230V R410A.1  Las imagenes y dibujos con distancias se encuentran en la carpeta 2013Jun - Proy Aire Acondicionada de Precision, el link es el siguiente:  https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0B2V3w6yIjEiQMVNGSG1xTmpGV1E  Si requieren mas información, por favor comentenlo.  Saludos y Gracias.','','CQ463','QRO','SAC191',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-13 09:58:12','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-14 00:00:00','Buen dia me pueden apoyar con el precio de una TARJETA ETHERNET PARA DAP III, CON PROTOCOLO DE COMUNICACIÓN SNMP MODELO:160-400-385	POR FAVOR	','','NA','GDA','SAC192',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-13 14:38:13','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-15 00:00:00','2 SENSORES DE HUMEDAD STULZ NO. DE PARTE M24094, EN LA ORDEN DE SERVICIO VIENE ETIQUETA CON MAS DATOS TECNICOS.  PARA OS-0316, REPORTE 13-147, AGUA DULCE, ENVIAR A ISEC VILLAHERMOSA','','CM150','MXO','SAC193',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-13 14:45:42','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-15 00:00:00','2 CAMARAS MH-3520 MARCA MICRO HIGH TECH, 1 CAMARA CNB-GN605-KC1 MARCA CNB PARA OS-0408 AGUA DULCE, ENVIAR A ISEC VILLAHERMOSA','','CM150','MXO','SAC194',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-13 14:53:17','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-15 00:00:00','1 SERVICIO DE REVISION Y PROGRAMACION DE TARJETA DE MONITOREO A 3 EQUIPOS LIEBERT $1619.04 DLLS, COTIZADO POR SITE, PARA REPORTE 13-149 OS-0176 EN CD DEL CARMEN ','','CM150','MXO','SAC195',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-14 09:29:05','ivan.ramirez@gposac.com.mx','Ventas','Levantamiento','','','2013-06-18 00:00:00','DANDO SEGUIMIENTO A LA REQUISICION SAC171 REQUIERO DE LA AYUDA NECESARIA PARA QUE PERSONAL DE SERVICIO ASISTA A SITIO A SACAR EL MODELO DE LA TARJETA DE CONTROL DEL SIGUIENTE EQUIPO NXB30 DE 30KVAS DE LA EMPRESA TRUPER JILOTEPEC Y ASI MISMO SE DETERMINE LA FALLA CORRECTA QUE PRESENTA EL EQUIPO','','CM23','MXO','SAC196',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-14 10:24:08','jose.osorio@gposac.com.mx','Implementación y Servicio','','Soporte en Monitoreo, Requisición de elaboración de Mapeo, etc.(Incluir la marca y modelo del dispositivo y de preferencia las MIBS)','','2013-06-17 00:00:00','Equipos para la implementación de monitoreo para el contrato CM-150  15 TGW- 715 convertidor ModBus TCP a Modbus RTU,  16 Fuentes de poder 24V/1.04 A montaje de riel din input 100-240 VAC, 12 Kitrones B2000, 18 Transformadores de corriente de núcleo partido 250/5A, 9   Transformadores de corriente de núcleo partido 800/5A, 3   Transformadores de corriente de núcleo partido 1000/5A, 12 Transformadores de corriente de núcleo partido 2000/5A.  ','','CM-150','GDA','SAC197',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-14 16:02:37','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional), Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-17 00:00:00','Buen día me pueden apoyar con el precio de refacciones y mano de obra por la instalación para un UPS de 500KVA marca MGE.  anexo archivo con la información y lista de refacciones requeridas.   https://docs.google.com/a/gposac.com.mx/file/d/1FZC_PkXGGv_rbDtbUYqxqbYh1s0yp8-j6xfoWvxTHzC9ZkWSO-UYBmFrbDWO/edit','','PG93','GDA','SAC198',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-17 16:24:49','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-17 00:00:00','2 tarjetas A006 POWER SUPPLY para sitio Cárdenas, entregar en Isec Villahermosa','','CM150','MXO','SAC199',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-18 10:30:03','berenice.martinez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-18 00:00:00','Buen día, solicito un modelo de poder principal, modelo:OG-SUVTPM15KF-P para un UPS, Apc, Galaxy 3500, de 15 KVA. TAR URUAPAN  contrato CM150','','CM150','GDA','SAC200',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-18 11:25:05','raul.perez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-18 00:00:00','Solicito la siguiente compra Switch Rotatorio:  esté como tal es un Switch para Bypass de Mantenimiento, que va montado en un UPS Marca: MGE, Modelo: EX 11 RT y la capacidad de esté  es de 11 KVA , Sobre el Switch: el Numero de Polos: (Son cuatro), el Numero de posiciones: (Son Dos). Se consultar en Internet el Modelo o Tipo de parte es ( C42), y es de la Marca: Kraus & Naimer. Aunado a lo anterior te envio fotografias en un archivo adjunto.','','CM150','GDA','SAC201',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-18 13:43:42','ivan.martin@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-06-18 00:00:00','Realizamos una visita tecnica  a las instalaciones de la TAR Queretaro para revisar una Planta de emergencia que al parecer no arranca en modo automatico, ni en modo manual. Inspeccionamos la maquina y encontramos la solenoide de la marcha dañada y la bateria tambien.  Hay que enviarle una cotizacion al Ing Patron de: Una SOLENOIDE PARA MARCHA 12Vcd Mca MURPHY Un ACUMULADOR Mca ROBINSION 30H-15 12V ','','NA','QRO','SAC202',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-18 18:05:59','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-19 00:00:00','1 BOMBA DE CONDENSADOS MOD. ON-7166 PARA INROW ACSC100 REP.13-154 OS-2788 ','','CM146','MXO','SAC203',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-19 11:56:13','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-20 00:00:00','2 TARJETA BY PASS MOD.21441-3 NO. DE PARTE 0200040000872204 2 TARJETA POWER SUPLY MOD.2099 NO DE PARTE 0200180000568486 1 TARJETA DE INTERFAZ MOD.21391-3 NO. DE PARTE 0200070000891893 2 FUSIBLE KTK-2 PARA TRANSFORMADOR FUENTE    PARA SITIO CARDENAS, SE ORIGINO DE VISITA MENSUAL OS-0403 Y 0404  SE ENVIA A ISEC VILLAHERMOSA, CS INDICA MANDARA COTIZACION','','CM150','MXO','SAC204',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-19 12:38:32','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-21 00:00:00','Me pueden apoyar con el precio para una:  PÓLIZA DE MANTENIMIENTO ANUAL PARA SISTEMA DE DETECCIÓN Y EXTENSIÓN A BASE DE ECARO-25 CON 2 DETECTORES Y UNA BOQUILLA DE ASPERSOR O ROCIADOR, TANQUE DE 30LTS.  INCLUYE; 2 VISITAS PROGRAMADAS CON RESPUESTA DE 12 HORAS EN SITIO NO INCLUYE; RECARGA DE AGENTE LIMPIO INERGEN N/S: RP-1002 VERSION 4XAMB.PCB REV.F ','','CG370','GDA','SAC205',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-19 12:44:40','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-06-19 00:00:00','Solicito cedula de costos para la elaboración de diagrama unifilar en Casa de Moneda México, ubicada en San Luis Potosí. Se anexan planos eléctricos y de alumbrado, asi como un unifilar desactualizado.  https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0B2V3w6yIjEiQeGg4aVh2WlJhVk0  Si se necesita mas información por favor, indiquen que requerimos para la elaboración de este unifilar.  Quedo al pendiente, saludos.','','NA','QRO','SAC206',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-19 14:10:31','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-21 00:00:00','SE REQUIERE DE CEDULA DE COSTOS PARA DETERMINAR QUE PRECIO TENDRÍA LA INSTALACIÓN DE DOS CAMARAS NETBOTZ POD160 A UNA DISTANCIA DE MAXIMO 15 METROS DE UN NETBOTZ 400','','NA','MXO','SAC207',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-19 17:42:01','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-19 00:00:00','SE REQUIERE DEL COSTO DEL CONTROL DE TRANSFERENCIA MARCA IGSA MODELO GENCON ESTO PARA QUE SE LLEVE ACABO LA REPARACIÓN DE LA PLANTA DE EMERGENCIA DE 25KW MARCA IGSA QUE SE ENCUENTRA EN CONTRATO DE MANTENIMIENTO. FAVOR DE SOLICITAR ESTE COSTO A JOEL BARRON (PERSONAL DE SERVICIO MEXICO)','','CM122','MXO','SAC208',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-20 10:38:51','joseluis.esteva@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-28 00:00:00','Se requiere válvula de entrada de agua para humidificador que esta tapada para un Data Temp de 5 Tr el No. de parte es: 1321061 o.5 L/min marca invensys. mando correo con fotos adjuntas de la refacción.','','CG209','GDA','SAC209',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-21 08:41:07','julio.lara@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-28 00:00:00','SOLICITO ME ENVIEN UN CONVERTIDOR RS-485. YA QUE LO TIENEN EN EL INVENTARIO Y SE ENCUENTRA EN LA BODEGA DE GUADALAJARA.  CUALQUIER DUDA PREGUNTARLE A ROBERTO, EL SABE CUAL ES. ','','NA','MXO','SAC210',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-21 08:53:42','julio.lara@gposac.com.mx','Implementación y Servicio','','Elaboración de Plano o diagrama en CAD (Incluir Liga de Archivo de plano original en cad o de levantamiento a mano)','','2013-06-28 00:00:00','SOLICITO SE CORRIJA EL DIAGRAMA UNIFILAR DE DAIMLER, YA QUE LOS CALIBRES DE LOS CONDUCTORES NO SON. SE DEJO LA MISMA INSTALACIÓN.  CUALQUIER DUDA ME PREGUNTARME A MI. ','','CM253','MXO','SAC211',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-21 16:30:30','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-21 00:00:00','Bomba de elevación  para motor Cummins No. parte 4988751 de acuerdo a PE-0168 de SF industrial','','CM150','QRO','SAC212',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-24 11:47:51','felipe.campos@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-25 00:00:00','SENSOR TEMPERATURA PARA INROW RC MODELO ACRC100  DATOS DEL SENSOR:  CODIGO DEL SISTEMA 60157 RC CABLE ASSY THERMISTOR/PROBE EMU 8 FT CODIGO DEL PROVEEDOR W0W3163  YA EXISTE EN INVENTARIO  EN OFICINA QUERETARO. ','','CQ345','QRO','SAC213',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-24 15:33:07','rogelio.valadez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-24 00:00:00','Se requiere el precio de lista de UPS y motogeneradores para instalación en plataforma, según el archivo:  https://docs.google.com/a/gposac.com.mx/file/d/0BxpwtIK26_pSbFhDMWo2V0ZDY0k/edit?usp=sharing  gracias','','CM364','MXO','',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-24 15:33:09','rogelio.valadez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-24 00:00:00','Se requiere el precio de lista de UPS y motogeneradores para instalación en plataforma, según el archivo:  https://docs.google.com/a/gposac.com.mx/file/d/0BxpwtIK26_pSbFhDMWo2V0ZDY0k/edit?usp=sharing  gracias','','CM364','MXO','SAC215',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-24 17:54:14','rogelio.valadez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-05-24 00:00:00','Se requiere el precio de renta de un UPS de 40 Kva por dos días, incluyendo personal en sitio (SAC Energía).  Gracias','','CM363','MXO','SAC216',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-24 18:34:48','jorge.martinez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-06-26 00:00:00','Mesa de ayuda,  Buena tarde, una consulta en AFORE XXI se tiene un equipo Inrow ACRC100 instalado que hemos tenido en poliza de Mantenimiento, este equipo tiene cerca de 4 años operando, el año pasado se suministro uno igual ACRC100, una duda que tiene el cliente es que porque en el flujo de agua en ocasiones el que ya tiene mas tiempo operando marca 0.0 y el equipo nuevo marca 0.2, 0.3, etc, es decir tambien un flujo bajo pero no 0.0 en una visita que realize con el Ing. Joel Paz el les comento que era debido a que los equipos nuevos tienen mas sencibilidad y por eso no reporta 0.0 si no muy cercano a el valor real del flujo aunque este sea bajo, a diferencia del equipo con mas tiempo que es menos sencible a los cambios de este valor e incluso hasta mas lento en dar las medidas o actualizar a el valor correcto,  La pregunta aqui es ¿En los equipos mas viejos se puede actualizar alguna tarjeta de modo que ambos den las mismas lecturas?  si esto es posible que costo tiene y que tarjeta es la que se requiere actualizar,  quedo a sus ordenes en espera de su pronta respuesta, gracias  saludos','','CM238','MXO','SAC217',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-24 18:45:03','jorge.martinez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-06-27 00:00:00','Mesa de Ayuda,  Buena tarde, de favor me pueden asignar un Ingeniero de servicio que sepa utilizar la plataforma web de monitoreo que utiliza APC para los equipos INROW ACRC100 para dar una breve induccion del uso y configuracion de esta plataforma a la persona encargada en AFORE XXI de dar reportes del funcionamiento y valores que reportan estos equipos,  Ellos ya tienen una idea de su uso pero les falta algunos conocimientos de como configurarla bien, sobre todo ver si la herramienta se puede estar actualizando de forma automatica ya que actualmente lo realizan de forma manual y que cuando el valor de alguna variable importante se salga de rango les avise con un correo para poder tomar una accion.  si esto se puede realizar via remota y dando la asesoria por telefono tambien es posible tratarlo asi con el cliente,  quedo a sus ordenes en espera de su pronta respuesta, gracias  saludos','','CM238','MXO','SAC218',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-24 21:22:28','rogelio.valadez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-24 00:00:00','Precio de lista de Acondicionador de aire tipo industrial para montaje vertical sobre pared de 36,000 y 24,000 BTU´s de refrigeración y habilitado con controlador de temperatura tipo bard. La opción más económica y  sin monitoreo.','','CM346','MXO','SAC219',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-24 22:18:32','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-25 00:00:00','Buen dia Me pueden apoyar con el precio de la bateria NPX-35 PARA UN UPS TOSHIBA SERIE 1600EP CON CAPACIDAD DE 10KVA.','','CG370','GDA','SAC220',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-25 13:27:46','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-06-28 00:00:00','se requiere del precio que tendria las refacciones que se solicitan en el archivo que se adjunta esto tomando en cuenta el modelo de UPS que se menciona para cada partida (solo de la partida 43 a la 126)   solo considerad:  Fusibles 150A a 500v Fusibles 100A a 500v fusibles de 660v-32A Transistores de potencia (IGBT Y SCR) Bibina de filtrado P.O.D hardware tarjeta para snnubber tarjeta buss monitor Targeta Charger tarjeta controller  Display Unit  esto segun sea el caso de cada partida.  COTIZACION MANTENIMIENTO A 40 UPS GIT','','na','MXO','SAC221',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-26 09:45:05','ivan.ramirez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-06-26 00:00:00','SE REQUIERE DEL APOYO DE PERSONAL DE SERVICIO O DE INGENIERIA PARA LA REVISIÓN DE EQUIPO UPS SYMETRA DE 80KVA EL CLIENTE QUIERE ADQUIRIR 4 MODULOS DE BATERÍAS PARA ESTE EQUIPO PERO REQUIERE SE REVISE PREVIAMENTE PARA ASEGURAR EL CORRECTO FUNCIONAMIENTO DEL MISMO. ','','CM342','MXO','SAC222',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-26 09:52:43','jose.osorio@gposac.com.mx','Gerentes al Area de Compras','','','','2013-06-26 00:00:00','Solicitar equipo de comunicación celular, esto estar en comunicación con ingeniera, servicio se me a dificultado la comunicación cuando salgo fuera y al momento de pedir apoyo. ','','NA','GDA','SAC223',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-26 13:37:23','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-26 00:00:00','1 CONTROL DE TRANSFERENCIA GENCON PARA PE IGSA SITIO ROSALES, SE TIENEN 2 COTIZACIONES, SE ENVIAN POR MAIL Y EL PRECIO LO CUBRE LA PARTIDA 80 DEL CONTRATO YA AUTORIZADO POR CLIENTE, URGE EL SUMINISTRO HOY, PROVEEDORES PIDEN PAGO DE CONTADO.','','CM122','MXO','SAC224',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-26 17:51:37','luis.andrade@gposac.com.mx','Gerentes al Area de Compras','','','','2013-07-01 00:00:00','Computadora y Celular para Hector Casillas nuevo personal de Servicio','Requerimiento de Compra de Activos','NA','GDA','SAC225',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-26 18:06:26','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-27 00:00:00','1 BATERIA DE LTH DE 27PLACAS MOD. L8D-1125 $3701 COTIZADO POR SITE, SE REQUIERE PARA EL 28/05/13 FISICA. ENVIAR A SITE CD. DEL CARMEN','','CM150','MXO','SAC226',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-27 09:03:17','joel.barron@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-27 00:00:00','La transferencia para el control  Gencon MCA IGSA tiene una tarjeta con relebadores auxiliares identificado como REXLER 94   BOARD 10A ','','cm-122','MXO','SAC227',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-27 17:55:17','raul.perez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-27 00:00:00','Se solicita en modo URGENTE la siguiente targeta con la siguientes caracteristicas modelo:  0P0018 PSU (0500151) se adjunta la foto para su localizacion rapida.','','CM237','MXO','SAC228',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-27 19:53:43','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-06-27 00:00:00','EL UPS MARCA APC MOD SYMMETRA PX 10KVA SERIE PD0617142097 UBICADO EN DUCTOS SECTOR MADERO AV TAMAULIPAS ESQ. CALLEJÓN DE BARRILES EN CIUDAD MADERO, EN LA VISITA REALIZADA EL DÍA DE HOY, SE ENCONTRÓ ALARMADO POR FALLA DE MODULO DE BYPASS, LA LIBRANZA PARA EL SERVICIO ESTA PROGRAMADO PARA EL PRÓXIMO MIÉRCOLES 3 DE JULIO POR LO QUE REQUIERO:  LOS 3 FUSIBLES DE PROTECCIÓN DE LA TARJETA DE DISPARO DEL MODULO DE BYPASS.  EN CASO DE QUE NO LOS TUVIESEN AVISARME DE INMEDIATO (T.E DOS DÍAS) PARA PEDIRLOS Y PODER REALIZAR LAS PRUEBAS EL DÍA DE LA LIBRANZA.  SOLICITAMOS EL APOYO PARA EL DIA E MAÑANA AVISARLE A NUESTRO CENTRO DE SERVICIO','','CM150','QRO','SAC229',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-28 12:29:21','juanjose.espinoza@gposac.com.mx','Ventas','Levantamiento','','','2013-06-28 00:00:00','Buen día Me puede apoyar con una persona para realizar un levantamiento, para la empresa Dynamica.  NOTA; ESTE LEVANTAMIENTO LO HABÍA REALIZADO RAFAEL, PERO NO DEJO INFORMACIÓN A NADIE. ','','NA','GDA','SAC230',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-06-30 21:31:00','luis.andrade@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-29 00:00:00','Necesitamos pedir 2 Equipos Bard de 5 Toneladas trifásicos a 460 V, para sustituir un Equipo dañado en CPQ Morelos. El modelo es W61A1-C. El ticket del que precede dicha reparación es el 12-32 ','','CM150','MXO','SAC231',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-01 16:56:09','juanjose.espinoza@gposac.com.mx','Ventas','Levantamiento','','','2014-03-20 17:05:08','Me peden apoyar con un levantamiento en: Cda. de Av. Toluca #60  Col. Olivar de los Padres  Del. Alvaro Obregon  C.P. 01780  México, D.F.  Contacto; Felipe Rodríguez Valladares  Tel: 5681-4038, 5681-4215  Es para CFE. los alcances son;  1.- Descontaminación de cámara alta, media y baja del site. 2.- Cambio pisos del site. 3.- Cambiar los soportes. 4.- Desconexion de cableado eléctrico, retirar y trasportar equipos desconectados y el cableado a bodega.  Nota; Se realizaran las actividades sin libranza, es decir los equipos estarán activos, es muy importante revisar el tipo de maniobra que se necesitara realizar.  ','','NA','MXO','SAC232',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-01 19:04:57','ivan.martin@gposac.com.mx','Ventas','Levantamiento','','','2014-03-20 17:05:08','PARA EL PROYECTO DE MONITOREO DE CRC´S CABLEMAS SOLICITAN PERSONAL DE GRUPO SAC PARA LEVANTAMIENTOS EN LAS CIUDADES DE TIJUANA, TECATE, ENSENADA Y MEXICALI LOS DIAS 9 Y 10 DE JULIO, PARA GENERAR CEDULAS DE PORYECTOS Y COTIZACIONES CABLEMAS PROPORCIONARA VEHICULO PARA LOS TRASLADOS, EL PUNTO DE PARTIDA SERA TIJUANA, POR PARTE DE CABLEMAS EL RESPONSABLE ES EL ING. JOSE LUIS GONZALEZ.  FAVOR DE CONFIRMAR A LA BREVEDAD EL NOMBRE DE PERSONAL DE GRUPO SAC QUE ACUDIRA AL LEVANTAMIENTO.','','CQ395','QRO','SAC233',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-01 19:07:31','ivan.martin@gposac.com.mx','Ventas','Levantamiento','','','2014-03-20 17:05:08','PARA EL PROYECTO DE MONITOREO DE CRC´S CABLEMAS SOLICITAN PERSONAL DE GRUPO SAC PARA LEVANTAMIENTOS EN LAS CIUDADES DE CD JUAREZ, CHIHUAHUA, CIUDAD CUAHUTEMOC, CAMARGO, DELICIAS Y PARRAL LOS DIAS 29 DE JULIO AL 2 DE AGOSTO, PARA GENERAR CEDULAS DE PORYECTOS Y COTIZACIONES GRUPO SAC DEBERA CONSIDERAR LA RENTA DE UN  VEHICULO PARA LOS TRASLADOS, EL PUNTO DE PARTIDA SERA CD JUAREZ, POR PARTE DE CABLEMAS EL RESPONSABLE ES EL ING. JOSE LUIS GONZALEZ. FAVOR DE CONFIRMAR A LA BREVEDAD EL NOMBRE DE PERSONAL DE GRUPO SAC QUE ACUDIRA AL LEVANTAMIENTO.','','CQ395','QRO','SAC234',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-02 16:11:38','liliana.diaz@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2012-07-03 00:00:00','Se solicitar el precio de lista de "conector donde se ensambla módulos de poder de 10kva del Symmetra PX" el cliente referencia el siguiente num y descripción:   0J-0P4230      POWER MODULE OUTPUT BACK PLANE - SPARE PART','','NA','MXO','SAC235',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-02 20:12:53','rogelio.valadez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional), Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-05 00:00:00','Se requiere precio de lista de una solución para distribución electrica para el SITE de Reynosa, los datos los tiene Salvador (5 RPP con 3 tableros de distribución (A1, A2 y STS) y monitoreo via web/SNMP, opción medición de corriente x polo)  Adicional se requiere el precio de lista de:  30 Lozas de piso falso alma de cemento de 2''X2'' (ftXft) perfil plano Descontaminación 216m2 arriba y abajo. (con Ana María) 10 Ventiladores de gabinetes cerrados (600 pesos costo c/u) 20 Chimeneas con ducto y aire forzado (etapa 1, o implementar contención). DSTS 200Amp 208VCA 60Hz Cyberex, monitoreo web/SNMP Software para control de acceso (Control Module Inc. Genus G1 term, 40MB,232,Aux,Sbio).  El sitio es en Reynosa, Tamp. Para que se consideren viáticos en su presupuesto.  Se reporta para cotización mediante lista de precios (No se requiere nada) 2 gabinetes o racks 2 postes con tapas ciegas (APC) 250 U de tapas ciegas. (APC)','','CM291','QRO','SAC236',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-03 10:51:51','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional), Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-08 00:00:00','Buen día Requiero de su apoyo para el catalogo de conceptos de INEGI (anexo abajo el link, con catalogo y diagramas necesarios.) es el estudio de mercado para el proyecto de patriotismo, ya incluye todo el alcance.  Les comento que ya tengo el precio de las partidas 18 y 20 que corresponden a los UPS mitsu y los AAP DAta Aire.                                                                                                                                                                            https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0B2jQgfvQJ9a0X1NhUm13TTBzNzA  ','','CG350','GDA','SAC237',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-03 11:45:43','berenice.martinez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-03 00:00:00','Se requiere Modulo de poder, SYPM10KF, POWER MODULE, PDO824330687, PARA UPS APC, SYMMETRA DE 30 KVA.   FAVOR DE ENVIAR A: CARLOS BORUNDA, ENERGÍA REGULADA S.A. DE C.V. C. PINO #511 COL. GRANJAS, CHIHUAHUA, CHIH., CP 31100, TEL. (614) 417-15-32 /417-06-70','','CM150','GDA','SAC238',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-03 12:30:46','rufino.moctezuma@gposac.com.mx','Ventas','Levantamiento','','','2013-07-03 00:00:00','Buenos dias.  Se solicita levantamiento para la instalación de Planta de Emergencia de 30KVA, en Farm Direct Food LatinAmerica SA, atención Ing Ricardo Barajas, en direccion Av. Constituyentes No. 206 - 801, Jardines de la Hacienda, Qro., fecha propuesta para realizar el levantamiento: 10-Jul-2013 11:00am.  Quedo al pendiente de sus comentarios. Saludos y gracias. ','','NA','QRO','SAC239',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-03 14:23:59','jorge.martinez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-07-04 00:00:00','Mesa de Ayuda,  Buena tarde, de favor requiero me ayuden a identificar o saber que requiero para seleccionar un equipo de Aire adecuado a esta necesidad,  El prospecto SEPINSA solicita un equipo de Aire  para un cuarto en donde se emsanblaran motores de hasta 500hp, (la persona que me dio los datos me dice que el usuario final es PEMEX, en Cd. del Carmen Campeche, lo cual dudo un poco mas bien pienso que sera una empresa que hara motores para pemex y su proceso de manufactura debe apegarse y ser supervisado por PEMEX), este equipo de aire requiere controlar temperatura y la humedad en un rango de un 50 a un 65%  Y requieren un tiempo de entrega de 3-4 semanas ya que el 1ro de Agosto tendran una revision por parte de PEMEX,  Ellos estan dimensionando un equipo de 20TR por el espacio que es una nave de 196mts2 y solicitaban uno de presicion,  yo estaba considerando proponer equipo industrial bard, pero seria bueno saber si contamos con algo en stock que podamos proponer y sea adecuado para esta aplicacion,   en el correo que me llegue de esta solicitud anexare la informacion que me han hecho llegar como planos y fotos,  quedo a sus ordenes en espera de su pronta respuesta ya que urge esta respuesta por el poco tiempo con el que cuentan,  para saber si proponemos o les informo que no podemos dar una solucion por los tiempos tan cortos,gracias  saludos','','NA','MXO','SAC240',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-04 18:22:21','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-05 00:00:00','Se requiere del precio de un block de terminales eléctricas con numero de  parte AP 885-1821/1 para un equipo UPS SYA8K16P de la marca APC','','CM342','MXO','SAC241',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-04 18:46:36','rufino.moctezuma@gposac.com.mx','Ventas','Elaboración diagrama en CAD (Se entregarán diagramas Genéricos, si se desea solicitar uno exacto se deberá incluir la cedula de proyectos)','','','2013-06-04 00:00:00','Raul,  Solicito la elaboración de un dibujo de plano eléctrico para Seguros El Potosí según diagrama autorizado por Luis Andrade el cual te entregare en papel de manera personal.  Saludos.','','cq419','QRO','SAC242',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-04 23:39:23','rogelio.valadez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-07-05 00:00:00','El cliente (PEMEX) pregunta si el armado de las baterías conforme a la figura  19B es el adecuado para la PCD de la partida Microondas AKAL-B del pedido de referencia.  https://docs.google.com/a/gposac.com.mx/file/d/0BxpwtIK26_pSSDloYzViNnkwTEE/edit?usp=sharing','','CM197, 2012','MXO','SAC243',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-05 10:42:07','jose.osorio@gposac.com.mx','Gerentes al Area de Compras','','','','2013-07-05 00:00:00','Se ocupan  8 TCs de 250/5A para la instalación de monitoreo del contrato CM-150 en el sitio Paraíso. ','Requerimiento de Compra de Activos','CM-150','GDA','SAC244',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-05 16:58:08','raul.perez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-07-02 00:00:00','Se solicita presencia del Ing. Salvador Ruvalcaba para acudir en la instalacion de un UPS PowerWare en empresa Arcelor Mitta','','CG386','GDA','SAC245',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-08 10:57:25','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-09 00:00:00','Buen dia. ME PUEDEN APOYAR CON EL PRECIO DE UNA PLANTA GENERADORA DE ENERGÍA ELÉCTRICA SISTEMA DE EMERGENCIA DE 750 KW-937.5KVA,3F-4H+PT,480/277V, 60HZ., F.P= 0.8, INTERRUPTOR DE 3P-1200A. MCA. OTOMOTORES GRADO MEDICO 1 PZA. INCLUIR TAMBIEN PRECIO DE ARRANQUE. ESTE ES PARA UNA LICITACIÓN PARA EL ISSSTE ','','NA','GDA','SAC246',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-08 11:39:28','felipe.campos@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-09 00:00:00','sensor de temperatura:  RC Cable Assembly Thermistor/Probe EMU 13FT APC LUGAR DE ENTREGA QUERETARO','','CQ345','QRO','SAC247',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-08 17:45:54','jorge.martinez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-07-09 00:00:00','Mesa de Ayuda,  Buena tarde, me informa el Ing. Leonardo Velazquez de Motorola que 1 equipo de Aire Inrow ubicado en Villahermosa y otro de la Cd. de Mexico en la Torre Ejecutiva se calientan en su clavija,  La pregunta es: Por medio del monitoreo que se tiene en estos equipos se puede visualizar, desde nuestra oficina  ¿cual ha trabajado por arriba del 100% en sus ventiladores, ?  ¿Si estos equipos estan recibiendo un voltaje de entrada por arriba de su rango especificado?  de modo que detectemos el problema antes de que el equipo pueda recibir un daño,  quedo a sus ordenes en espera de sus comentarios, gracias  saludos','','MX11-0027','MXO','SAC248',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-08 18:34:55','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-08 00:00:00','1 TERMOSTATO DIGITAL 1 COMPRESOR HICHLY MOD.SHW73TC2UP1 208-230V 50-60HZ 1PH $3900 1 COMPRESOR MOD.IECB165111HS0405Y02080 208-230V 60HZ LRS 38.0 R22 $3900, SE TIENE ENTREGA INMEDIATA, CONFIRMAR COMPRA  PARA 2 EQUIPOS DE SITIO ALTACE, URGENTE!!','','CM122','MXO','SAC249',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-08 18:38:20','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-08 00:00:00','Buenas tardes.  Requiero precio de lista de 1 pieza de Transformador de Islamiento tipo K13. De características similares al MGM (MGMHT30A3B2-K13), aluminio, 30Kva, 150°C pico, factor K-13. Uso interior. Entrada 480Vac, 3 fases en delta, 60Hz. Salida 208/120Vac en estrella.  Requiero precio de lista de 1 pieza de Supresor PQ-GLOBAL, Modelo: TE/2C/M, Serie C - 80kA Hard Wire ( non-UL),   Requiero precio de lista de 1 pieza de PQ-GLOBAL, Modelo: TE/1HPS/CX/04/M, 240/120V 1Ø, 3W Plus Ground, 160KA.  Se requiere con proveedor local para buscar el menor tiempo posible.  Saludos','','CQ371','QRO','SAC250',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-09 09:44:23','joel.barron@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-12 00:00:00','Bateria Baja al arranque 9.5Vcd se requiere una de 900Watt 12V  LTH HUMEDA','','cm-122','MXO','SAC251',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-09 09:46:42','joel.barron@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-12 00:00:00','BATERIA DE TLAMACAS LA  "OS" P0918 BATERIA DE 900WATT','','cm-122','MXO','SAC252',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-09 15:26:03','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional), Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-11 00:00:00','Buen día  Me pueden apoyar con el precio para una contención con 1.05 mts de ancho por 2.00 mts. de alto así como la mano de obra por instalación.  Por otro lado el cliente tiene un Chiller de 16tr y 2 Aires de confort lo que necesitamos es que en caso de fallar el Chiller entren los de confort.        Me comento Salvador que podemos utilizar el DARA 4  ($ 1,510 usd, segun PSG)  que duplicáramos el costo y se utilizarlo para el costo de tubería y cableado, solo necesito el costo de mano de obra para la instalación. ','','CG434','GDA','SAC253',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-09 15:49:20','julio.lara@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-12 00:00:00','4 EQUIPOS POWERLINE COMO REFERENCIA ESTA LA MARCA TP-LINK MODELO TL-PA211. ESTE YA LO USE Y SI SIRVE. PERO SI NO LO HAY QUE TENGA ALCANCE DE UNOS 200 O 300 METROS PERO QUE SE ALAMBRICO. QUE NO TENGO WIFI O INALAMBRICO ESTOS NO ME SIRVEN PARA LO QUE LO REQUIERO.  CUALQUIER DUDA COMUNICARSE CON SU SERVIDOR.  GRACIAS.','','CM41','MXO','SAC254',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-09 16:45:14','ivan.ramirez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-07-10 00:00:00','SE REQUIERE DEL APOYO DE INGENIERÍA PARA REVISAR Y VALIDAR EL DICTAMEN QUE GENERO SAC ENERGÍA EN EL ESTUDIO DE CALIDAD DE ENERGIA REALIZADO A INSTALACIONES DE BAXTER MASARIK (ES ESTUDIO SE DERIVA DE LAS CONSTANTES ALARMAS QUE PRESENTA EQUIPO UPS SILCON DE 20KVA A 208VCA) SE ANEXA LINK DE DICHO ESTUDIO  https://docs.google.com/a/gposac.com.mx/file/d/0B4bMHo1P0jzeM3d4cTJQVGx6NjQ/edit?usp=sharing ','','CM251','MXO','SAC255',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-10 02:21:14','jorge.martinez@gposac.com.mx','Ventas','Levantamiento','','','2013-07-15 00:00:00','Mesa de Ayuda,  Buen dia, por medio del presente y referente a el Ticket SAC248 de la requision general solicito una visita de personal técnico en el mejor tiempo posible a Villahermosa(Próxima visita para revisión de equipos CM150) a fin de optimizar costos, para el Centro de Servicio de Villa. El objetivo es corroborar los consumos reales contra os datos de placa, ademas de obtener los porcentajes de uso.  Para coordinar la visita de favor requiero me indiquen que dia se puede realizar para solicitar el acceso mediante el Ing. Leonardo Velzquez de Motorola,  quedo a sus ordenes en espera de su respuesta, gracias  saludos','','MX11-0027','MXO','SAC256',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-10 10:08:51','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-13 00:00:00','1 REGULADOR DE VELOCIDAD P.66 PARA REPORTE 13-162 OS-0319, ENVIAR A ISEC VILLAHERMOSA, ES PARA SITIO NUEVO PEMEX','','CM150','MXO','SAC257',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-10 18:35:02','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-11 00:00:00','1 MODULO DE CAPACITORES DE AA APC NO. DE PARTE OK0020 (24 CAPACITORES DE 80MFD A 240VCA MARCA AEROVOX) PARA NUEVO PEMEX, ENVIAR A ISEC VILLAHERMOSA OS-4006','','CM150','MXO','SAC258',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-11 09:26:37','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional), Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-12 00:00:00','Buen dia  Como lo comentamos por teléfono necesito que me apoyen con una solución de Detección y supresión para un cliente el cual anexo el croquis de sus instalaciones.  https://drive.google.com/a/gposac.com.mx/?tab=mo&pli=1#folders/0B2jQgfvQJ9a0dThhQWVvYi1OcFU  ','','CG436','GDA','SAC259',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-12 09:05:52','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-15 00:00:00','3 ASPAS DE ALUMINIO 4 ALABES 26" X 1/2" PARA CARDENAS, ENVIAR A ISEC VILLAHERMOSA, CS ENVIO COTIZACION $3,660 C/U COT. NO. 045-AAP-10-STULZ-CARDOS  ORDEN AA-1683 ','','CM150','MXO','',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-12 09:12:56','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-15 00:00:00','1 TARJETA PCP-221C-ECR-3435Y 1 TARJETA 3214 B-BB03 PARA UN UPS BEST POWER MOD. FE10KVA FERRUPS, PARA CPQ PAJARITOS, COATZACOALCOS, ENVIAR A ISEC VILLAHERMOSA OS-0405','','CM150','MXO','SAC261',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-12 12:11:36','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-15 00:00:00','1 MOTOR A.O. SMITH MOD. F48AA14A01 3/4 HP 220V RPM1075 PARA PARAISO OS-4018 ENVIAR A ISEC VILLAHERMOSA','','CM150','MXO','SAC262',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-12 12:16:47','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-15 00:00:00','1 DISPLAY MOD. AP9215RM PARA SITIO VHS, UPS-1667 ENVIAR A ISEC VILLAHERMOSA','','CM150','MXO','SAC263',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-12 13:01:16','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-15 00:00:00','3 ASPAS DE ALUMINIO 4 ALABES 26"" X 1/2"" PARA CARDENAS, ENVIAR A ISEC VILLAHERMOSA, CS ENVIO COTIZACION $3,660 C/U COT. NO. 045-AAP-10-STULZ-CARDOS  ORDEN AA-1683 ','','CM150','MXO','SAC264',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-12 13:23:34','juanjose.espinoza@gposac.com.mx','Ventas','Levantamiento','','','2013-04-19 00:00:00','Me pueden apoyar con una persona para realizar levantamiento en las instalaciones del CUAD en Guadalajara por favor.','','NA','GDA','SAC265',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-12 13:58:16','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-12 00:00:00','Buenas tardes.  Solicito precio para mantenimientos preventivo y correctivo para dos motogeneradores,  se debe cotizar de acuerdo al catalogo de conceptos de la siguiente liga.  https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AmV3w6yIjEiQdEx1S1RrNU5JZlRMYXI3U2xkN0JETHc#gid=0  Las capacidades de los motogeneradores son: Marca IGSA con motor Jhon Deere de 40 KW´s, ubicado en Queretaro; y  Marca IGSA con motor Cummins de 25 KW´s, ubicado en C. Cimatario.  Quedo al pendiente.','','CQ482','QRO','SAC266',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-12 17:35:39','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-17 00:00:00','1 MOTOR EMERSON 1/2 HP 220V FLECHA 1/2 (INCLUYE CAPACITOR 10MFD 370 VAC) PARA CPQ COSOLEACAQUE OS. AA-1746, ENVIAR A ISEC VILLAHERMOSA COTIZACION 048-AAP-10-MAYER-CP COSOL','','CM150','MXO','SAC267',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-16 09:05:36','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-16 00:00:00','1 BOMBA DE CONDENSADOS MOD. 0N-7166 110-120V, 208-240V 50-60HZ, AC .2A MAX. 3MM/10FT SUCCION 6M/20FT PARA INROW ACSC100 REP.13-178 ESTA REFACCION SE SUMINISTRO EN SAC203 PERO SE QUEMO, URGENTE!!','','CQ449','MXO','SAC268',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-16 09:46:03','marlem.samano@gposac.com.mx','Gerentes al Area de Compras','','','','2013-07-16 00:00:00','Buen dia solicito la compra de playeras y camisas ,  con borde anexo  cotizacion ya solicitada, solo falta agregar  la compra de chalecos y batas asi como mas overoles para tenerlos es stock Paso la lista  44 - 3 42- 3 40- 3 38 - 2 36 - 4 46 - 3   Uniformes de Tampico. El telefono es: 442 2158773 Los overoles son de color naranja con cintare flejante. la misma talla en batas y chalecos. ','Requerimiento de Compra de Activos','NA','QRO','SAC269',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-16 10:12:11','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-07-16 00:00:00','Raul, buenos dias.  El dia de ayer se puso en contacto el Sr Pablo Conejo de Gpo Antolin-Silao y nos pide actualizar nuestra propuesta para conexión electrica de un UPS  https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0Ao7-Zjpys2JCdHBmQUN2N1JsakJINEZOTHB1U1dGb0E#gid=0   Esta cedula la relizo Martin vazquez.  Quedo al pendiente. Saludos.','','CQ331','QRO','SAC270',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-16 10:46:12','ivan.ramirez@gposac.com.mx','Ventas','Levantamiento','','','2013-07-17 00:00:00',' Se requiere de personal de servicio para que realice un levantamiento en instalaciones de Baxter Masarik esto para complementar la solucion que se ofrecera para solucionar el problema que tienen actualmente con sus  UPS','','na','MXO','SAC271',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-16 16:22:12','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-18 00:00:00','ME PUEDEN APOYAR CON EL PRECIO DE SUMINISTRO DE PLANTA DE EMERGENCIA MARCA OTTOMOTORES CON CAPACIDAD DE 40 KW (50 KVA), CON MOTOR CUMMINS Y GENERADOR ESTAMFORS 1800 RPM, 60 HZ, 220/127 VCA, FACTOR DE POTENCIA 0.80, 3 FASES, 4 HILOS, TANQUE 230LT, CASETA PARA EXTERIOR TACONES DE NEOPRENO,AMORTIGUADORES','','CG439','GDA','SAC272',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-17 10:07:32','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional), Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-18 00:00:00','Me podrian apoyar con una cedula de costos y precio para los sig. equipos e isntalaciónes por favor.  https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0B2jQgfvQJ9a0XzZCUFpsTml6dUU','','cg440','GDA','SAC273',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-17 18:39:23','liliana.diaz@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-17 00:00:00','PCB10318 Tarjeta de contactos secos necesaria para el equipo Mitsubihsi con modelo PCB10318	','','CM367','MXO','SAC274',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-18 10:37:56','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-18 00:00:00','1 modulo de poder SYPM0KF PARA SITIO REFORMA REP.13-181 OS-4023 ENVIAR A ISEC VILLAHERMOSA','','CM150','MXO','SAC275',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-18 16:08:16','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-18 00:00:00','Buenas tardes.  Solicito precio de la siguiente tarjeta: TARJETA DE CONTROL POWER SUPPLY BD ASSY 02-792200-00 PARA SISTEMA UNINTERRUMPIBLE POWER SYSTEM DE 100 KVA MARCA  LIEBERT MODELO AP376  Quedo al pendiente. Saludos y gracias.','','CQ488','QRO','SAC276',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-19 13:34:33','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-19 00:00:00','Por medio del presente solicito las siguientes partes que necesitamos instalar en Pemex Reynosa de acuerdo a las Ordenes de servicio: OS-0696, AO-067 Y 02-0695 *2 baterias Genus G, UPS, 1000 MAH BAT *1 Monitor Acer de 17" modelo AL1706A * 1 Conector para cable coaxial de video * 1 Cable para video de monitor VGA','','CM150','QRO','SAC277',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-19 17:19:17','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-25 00:00:00','1 RELEVADOR DE CORRIENTE SIEMENS MOD.3UA54001 4-6A  2 INTERRUPTORES DE PRESION DE DUAL ALTA Y BAJA CON REESTABLECEDOR MANUAL  2 CONTACTORES SIEMENS MOD.3T844, 3RT 1034 BOBINA 220V 30A 1 CONTACTOR MARCA SIEMENS 3TB42 BOBINA 220V 30A  COT. ISEC 051-AAP-15-MAYER-CP COSOLE PARA SITIO COSOLEACAQUE OS-4019  ESTE REQUERIMEINTO ES POR RECOMENDACION!!!','','CM150','MXO','SAC278',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-19 17:32:11','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-19 00:00:00','1 COMPRESOR ZR24K-PFV-501  1 CAPACITOR 55 MFD 1 FILTRO DESHIDRATADOR 3/8 SOLDABLE  REPORTE 13-184 EL PROVEEDOR SOLICITA SE CAMBIE HOY POR LA ALTA TEMPERATURA EN SU SITE','','CM122','MXO','SAC279',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-23 16:37:40','berenice.martinez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-23 00:00:00','Buen día, Solicito las siguientes refacciones:  TAR TOPOLOBAMPO, CONTACTOR H1 Y H2, P/N C25DND330, PARA DATA AIRE, DTAD-0332-AO.  TAR GUAYMAS, MODULO DE PODER, G35T15KB4F, UPS, APC, GALAXY 3500,CAP15. TAR HERMOSILO, CILINDRO HUMIDIFICADOR 202 IN UNIT, DATA AIRE, DTAD-0332-AO, CAP 3 TR. TAR MAGDALENA, CILINDRO HUMIDIFICADOR, MES-U5 1.7 KW, PARA DATA AIRE, DCAU-0212-AO, CAP. 3 TR. TAR NOGALES, CILINDRO HUMIDIFICADOR MOD:MES-US 1.7 KW, TAR TOPOLOBAMPO, CILINDRO HUMIDIFICADOR 202 IN UNIT, DATA AIRE, DTAD-0332-AO, CAP. 3 TR, CONTRATO CM150, FAVOR DE ENVIAR A CAMILO PEÑA FRANCO, MARIANO ESCOBEDO #1133 COL. LAS VEGAS CULIACAN, SINALOA OFICINA 1:. 667-455-69-95 MOVIL :. 667-191-01-16','','CM150','GDA','SAC280',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-23 19:04:24','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-25 00:00:00','1 System Power Supply (0P4110), 1 Battery Monitor (0P4160), me indican que ambas están disponibles en QRO, favor de enviar a CS Mérida Para reporte 13-167  ','','CM150','MXO','SAC281',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-24 09:19:56','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-25 00:00:00','Me pueden apoyar con el precio de las siguientes plantas de emergencia con caseta acústica por favor.  PNY30 PNY40','','CG441','GDA','SAC282',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-24 17:08:32','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-24 00:00:00','Cámara Pelco, modelo PCM100, para equipo CCTV marca Averdigi, modelo EH5216H, (TAR Cadereyta)','','CM150','QRO','SAC283',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-25 09:37:31','raul.perez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-25 00:00:00','Buen dia necesitamos la reposición de SYCBTMON marca: APC y descripcion: SYMMETRA PX BATTERY MONITORING CARD precio: $353.00 USD    ','','CM150','QRO','SAC284',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-25 12:16:41','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-29 00:00:00','SE REQUIERE DEL PRECIO DE VENTA PARA UNA ACCESORIO PARA UN EQUIPO INRROW SC (SISTEMA DE CONTENCIÓN) CON NUMERO DE PARTE ACCS1003 DE LA MARCA APC ','','NA','MXO','SAC285',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-25 12:21:23','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-26 00:00:00','BUEN DÍA ME PUEDEN APOYAR CON EL PRECIO DE UNA TARJETA DE RED PARA MONITOREAR VIA WEB/SNMP UN UPS CONTROLLED POWER MD5000, EL CUAL VENDIMOS EL AÑO PASADO. ','','CG442','GDA','SAC286',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-25 13:03:03','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-26 00:00:00','BUEN DIA ME PUEDEN APOYAR CON EL PRECIO DE UN STS DE 30 AMPERS BIFASICO, CON SALIDAS MONOFASICAS Y BIFASICAS. TAMBIÉN UN FILTRO RACORD PARA PLANTA DE EMERGENCIA DE 300KW, ASÍ COMO LA TARJETA DE RED SNMP PARA LA PLANTA DE EMERGENCIA MODELO; DSE892 ESTO ES PARA EL CLIENTE ARCELOR MITTAL','','CG443','GDA','SAC287',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-25 18:41:12','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-07-25 00:00:00','Raul, buenas tardes.  Solicito por favor me confirme los precios que Luis me indico para la instalación de los conectores en Grupo Antolin-Silao  Instalacion eléctrica para UPS Matrix de 5KVA,                     1	Servicio      $ 200.00 usd incluye 2 juegos de conectores Nema L6-30		 Viaticos 2 ingenieros 1 dia		                                     1	Servicio      $ 120.00 usd.  Quedo al pendiente, saludos y gracias.','','CQ331','QRO','SAC288',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-25 20:02:32','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-25 00:00:00','Raul,  Se solicita el costo de agregar 4 equipos a nuestro servicio de monitoreo y arrendamiento de un Aire Data Aire DAMA-2.512-AI-DAAC 2.512','','CQ371','QRO','SAC289',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-26 10:13:35','jorge.martinez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-07-30 00:00:00','Raul,   Buen dia, de favor me puedes proporcionar el precio de suministro e instalacion de la tarjeta de Monitoreo Mod. 66074 para un UPS MGE Series Galaxy 3000, Mod. 72-170300-10, 30Kva, 220V, Type 2F.  Te anexo de referencia los datos que me proporciono Filipe Lopes en Marzo pasado  Mod. 66074 	Descripcion: MGE SNMP/Web Card  Precio 409.00 USD + IVA  Instalacion, Configuracion = 311.00 USD + IVA  No incluye cableado  TE 25 DIAS HABILES ','','CM293','MXO','SAC290',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-26 11:36:28','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-26 00:00:00',' 1 AA MOD. YHFFZC036BBAAFX YORK 3 toneladas solo frio. Con R-22 Minisplit equipo nuevo. Reporte 13-184   EL USUARIO OTORGO LOS DATOS DE COMPRA: ACONDICIONAMIENTO DE CLIMAS S.A. DE C.V. Tel. 58-24-74-77 $16,705  SE REQUIERE SUMINISTRAR HOY','','CM122','MXO','SAC291',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-26 13:27:03','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-07-26 00:00:00','Se solicita cedula de costos para la instalación de un AAP de 2.5 Tons (Descripción en el PSG: http://psg.dataaire.com/projects/System.aspx?id=36240) en Seguros El Potosi, en San Luis Potosi.  Liga de Check List de levantamiento: https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AmV3w6yIjEiQdGhDQ0M2WDVDd2ZQLXVDM2d5anU2Vnc#gid=5  Quedo al pendiente.  Saludos','','CQ371','QRO','SAC292',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-29 16:53:10','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-29 00:00:00','UPS Bifasico de 12 Kvas.  Este equipo esta en arrendamiento pero debido a que ya se encuentra bastante deteriorado se esta solicitando uno nuevo para realizar el cambio del mismo.','','CQ320','QRO','SAC293',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-29 17:37:01','liliana.diaz@gposac.com.mx','Ventas','Pregunta técnica','','','2013-07-30 00:00:00','SE LES SÓLITA  ANALIZAR CON  BASE  A LAS IMÁGENES  ENVIADA A MESA DE AYUDA  UN PRE DIAGNOSTICO DE  LO QUE HAGA FALTA,   YA QUE  ESTÁN SOLICITANDO  UNA PÓLIZA DE  MANTENIMIENTO PERO LES HACE FALTA ALGUNOS  DETALLES. ','','CM387','MXO','SAC294',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-29 18:21:59','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-05 00:00:00','3 VENTILADORES PARA MODULO DE PODER APC MOD. SYPM0KF MARCA NIDEC VETA V MODELO B33534-55 P/N 932000, 24 VDC 45A NO.4682065. CORRESPONDE A LA OS.0400 SITIO COATZACOALCOS  ENTREGAR EN ISEC VILLAHERMOSA','','CM150','MXO','SAC295',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-29 18:34:53','rufino.moctezuma@gposac.com.mx','Ventas','Pregunta técnica','','','2013-07-29 00:00:00','Solicito actualización de precios de proyecto CQ307   https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AmV3w6yIjEiQdENUNEhlMy1nOU5uMXJ2dFlrMTRCeGc#gid=0 ','','CQ307','QRO','SAC296',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-30 10:15:55','liliana.diaz@gposac.com.mx','Ventas','Pregunta técnica','','','2013-07-30 00:00:00','SOLICITO MODELO DE  BATERÍAS PARA UN Galaxy 3000 Modelo No: 72-17100-00              15 KVA 208/208 Serie: A03-11484   PRECIO  DE LISTA DE (BATERÍAS)  COMO LA MANO DE OBRA PARA INSTALAR  EN CIUDAD DEL CARMEN ','','CM387','MXO','SAC297',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-30 10:54:14','jorge.martinez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-07-31 00:00:00','Mesa de Ayuda,  Favor de realizar una cedula de costos para la Cotización del alambrado (instalacion electrica) del UPS SYMETRA PX Ubicado en Coatzacoalcos NS: PD0542342778, segun el requerimiento de la Orden de Servicio OS-0400 con fecha del 24 de Junio del 2013,   En el correo que me llega cuando envio esta requisicion les anexo la cotizacion del centro de Servicio ISEC que nos hizo llegar, para poder realizar estos trabajos,  quedo a sus ordenes para cualquier comentario y/o duda, gracias  saludos','','CM338','MXO','SAC298',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-30 13:03:01','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-30 00:00:00','Solicito precio de NEMA para UPS HP de 7 kVAs  Los datos de corriente del UPS 7 Kvas son los siguientes:    F463A   (International) 220, 230*, 240 6300VA/ 6300W @230V input IEC-309 32Amp, 3m cord LS1: 15A CB - 3 x C19 + + one pigtailed receptacle IEC-309 32Amp LS2: 15A CB - 3 x C19 + + one pigtailed receptacle IEC-309 32Amp   Comparto archivo y anexo link del PDF Quick Spec  https://docs.google.com/a/gposac.com.mx/file/d/0B2V3w6yIjEiQNEQzVy1LMHh0Nlk/edit  Quedo al pendiente.','','CQ371','QRO','SAC299',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-30 13:38:48','raul.perez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-07-01 00:00:00','Buen día solicito lo siguiente:  1. Clavija / Macho / Plug / 2 piezas / L6-30 Colgante 2. Receptaculo / Contacto / Hembra / C19 / 20 amp / entrada europea / se adjunta la foto.  Saludos. ','','CM150','GDA','SAC300',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-31 12:57:42','rogelio.valadez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-08-07 00:00:00','buen día, solicito los planos y demas información técnica para los motogeneradores cummins de 44 kva y 50 kva, pues ya no estan las ligas en la pagina de otto.   Esto pues PEMEX nos han estado solicitando info de los equipos suministrados hace dos años.','','MX11-44','MXO','SAC301',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-31 18:19:26','liliana.diaz@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-07-31 00:00:00','SE SOLICITA PRECIO  DE  UN UNIFICADOR  PARA UN ÁREA DE 6 X 5 X 250  ANEXO  ARCHIVO  AL CORREO DE MESA  DE  AYUDA   ','','CM367','MXO','SAC302',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-07-31 23:39:34','ivan.martin@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-02 00:00:00','SE SOLICITA PRECIOS PARA ANEXO C DE LICITACION DE MANTENIMIENTOS A MOTOGENERADORES PARA PEMEX REGION NORTE, SE ENVIA POR CORREO ANEXO C DE REFERENCIA QUE SE USO PARA ESTUDIO DE MERCADO.','','NA','QRO','SAC303',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-01 08:56:16','liliana.diaz@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-01 00:00:00','SE  SOLICITA  PRECIO DE LISTA  DE  UN HUMIDIFICADOR  PARA  AREA  DE 6 X5 X250  SE ANEXO  DIAGRAMA APIVER  AL CORREO DE MESA DE  AYUDA ','','CM367','MXO','SAC304',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-01 12:22:43','rogelio.valadez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-08-01 00:00:00','Por medio del presente se solicita el apoyo para realizar una visita de revisión a dos UPS de la empresa Chedraui, con el objetivo de diagnosticar las probables causas de caída (Ayer no pudieron cobrar por alrededor de 10 min) de los servicios que respaldan dichos equipos.  Al parecer la falla esta en la alimentación eléctrica, pues personal de sitio reporto que los servicios estaban caídos y el UPS operando con normalidad.  La dirección es: AV. DE LA VENTISCA No. 100 COL. SAN LUCAS PATONI C.P. 07270   MEXICO, D.F. DELG. GUSTAVO A. MADERO   Contactos en Tienda:   Jefe de Sistemas Andres Enrique Fuentes  o  Marlem Fuentes  Teléfonos:   55        5367-3373 55        5367-3493  Saludos y gracias  PD: Por causas de fuerza mayor Ivan Ramirez no podrá acompañar (Viaje a Veracruz)','','NA','MXO','SAC305',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-01 13:33:45','jorge.martinez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-08-02 00:00:00','Mesa de Ayuda,  Buena tarde, de favor me puedes cotizar el servicio para limpieza y descontaminacion de el Centro de Datos de IDESA Santa fe, el cual tiene las sig. medidas:  - Piso falso 19mts cuadrados y 23 cm de profundidad de la camara - Plafon falso 19mts cuadrados y 90cm de plafon a loza - camara media 2.6mts de piso falso a falso plafond,  Se debe considerar la limpieza de las placas de piso y falso plafond, limpieza de cancel de 4.5mts de largo por 2.8mts de alto y limpieza solo exterior de 2 gabinetes Rack y 2 Aires Inrow un SC y un RC .  Quedo a sus ordenes para cualquier comentario y/o duda, gracias  saludos','','CM392','MXO','SAC306',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-01 16:57:09','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-01 00:00:00','3 MODULOS DE POTENCIA SYPM10KF 3 VENTILADORES 24VCD  0.45AMP MOD.TA45DO $850 C/U  PARA UPS APC SYMMETRA PX DE BOCA DEL RIO MOD. "I" OS-2926 SE TIENE COT. DE CS, SE ENVIA POR MAIL  ENVIAR A CS VERACRUZ SI ES POSIBLE HOY','','CM150','MXO','SAC307',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-02 10:43:51','rufino.moctezuma@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-08-01 00:00:00','Se solicita el apoyo de un ingeniero de servicio para realizar levantamiento para Proyecto de Site en la UAQ Campus Juriquilla, la visita se realizara a las 2:30 pm.  Quedo al pendiente, gracias.','','NA','QRO','SAC308',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-02 10:45:01','jorge.martinez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-08-05 00:00:00','Mesa de Ayuda,  Buen dia de favor me pueden cotizar el suministro e Instalacion de 2 ventiladores para el transformador de aislamiento de un UPS Liebert de 225kva, de Grupo Radio Centro  Los datos de los ventiladores son:  MARCA: COMAIR ROTRON MAJOR  MODELO: MR2B3  VOLTAJE: 115 VCA  AMPERAJE: .27/.26 A  POTENCIA: 50/60 Hz  FOR EN60950  THERMALLY PROTECTED,  Quedo a sus ordenes en espera de su respuesta y/o comentarios, gracias  saludos','','CM393','MXO','SAC309',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-02 10:48:39','rufino.moctezuma@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-08-02 00:00:00','Se solicita el apoyo de un ingeniero de servicio para realizar levantamiento para la instalación de Planta de Emergencia y  AAP, y UPS.  Esto se realizara en Proyecto de Site de la UAQ Campus Juriquilla,  la visita se realizara a las 12:00 pm, con el Ing Fernando Jimenes, Jefe de TI del campus.  Quedo al pendiente gracias.','','NA','QRO','SAC310',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-02 11:13:15','jorge.martinez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-08-02 00:00:00','Mesa de Ayuda,  Buen dia de favor me pueden ayudar con las siguientes preguntas referenete a el equipo UPS Modular de Mitsubishi 1100A de 50kva  1. Balance de fases:  Tomando de referencia las bases del UPS Mitsu 9900 que se suministro a PEMEX en el 2011, viene el siguiente dato:  * Balanceo de fase de 120º +/- 1º para cargas balanceadas y 120º +/- 3º Para cargas desbalanceadas hasta en un 100%  (EL DATO DE 120° O LO CORRESPONDIENTE PARA ESTE UPS NO LO ENCONTRE SOLO EL +/- 1° Y +/-3° ), de favor me podrian indicar en donde lo encuentro, cual es el correcto para este equipo o si mejor quito ese valor de 120° y solo dejo el +/- 1° Y +/-3°,  2. Como solventamos el RUN TIME  En los documentos de especificaciones de Mitsu no viene el dato del tiempo de respaldo en minutos que se ofrece a una determinada carga (al 50% o al 100%), ¿como podemos solventar el dato de tiempo de respaldo que se indica en la lista de precios?.  3. Sensores de Temperatura  ¿El gabinete de baterias cumple con la siguiente caracteristica? * Cuente con sensores de temperatura de las baterías que compense la recarga de baterías por temperatura.  4. Protecciones para evitar descarga Profunda  ¿El gabinete de baterias cumple con la siguiente caracteristica? * Cuente con protecciones para evitar la descarga profunda de las baterías.  Quedo a sus ordenes en espera de su respuesta y/o comentarios ya que es para una especificacion tecnica que estamos trabajando para PEMEX, gracias  saludos  ','','CM291','MXO','SAC311',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-02 12:31:55','ivan.ramirez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-08-05 00:00:00','SE REQUIERE DEL PRECIO QUE TENDRÍA LA INSTALACIÓN ELÉCTRICA E HIDRÁULICA DE UN EQUIPO DE AIRE ACONDICIONADO TIPO MINI SPLIT DE 3TR MODELO YHFFZC036BBAAFX   CONSIDERAR SOLO REMATE YA QUE SE OCUPARA INSTALACIÓN EXISTENTE. ASÍ MISMO SE REQUIERE DEL COSTO QUE TENDRÍAN LAS MANIOBRAS PARA COLOCAR EN SITIO. NO SE HARA USO DE NINGUN EQUIPO ESPECIAL SOLO PERSONAL PARA QUE CARGUE EL EQUIPO A 8M DE DISTANCIA HACIA ARRIBA ','','CM122','MXO','SAC312',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-02 14:09:27','jorge.martinez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-08-05 00:00:00','Mesa de Ayuda de favor me puedes cotizar  Los siguientes tres requerimientos para adicionar a el proyecto CM302 que es la implementacion de un Aire tipo perimetral en el Site del Cliente RCI  1. Reubicacion y reconexion para la puesta en Marcha de un equipo de Aire tipo perimetral de 10TR de Expansion directa, con dimensiones de 90cm de frente, por 1mts de largo y 1.8mts de alto con un peso aprox de 450kg de peso, Este debera arrastrar dentro del site sobre el piso falso una distancia de 15.3mts de donde esta actualmente a su nueva reubicacion, se debe considerar dentro de los trabajos a realizar: - Apagado - desconexion, - Maniobras de Arrastre, - Adecuacion de para su alimentacion electrica de 15 mts (a 220V, trifasico) a el tablero proporcionado por el cliente, ya se cuenta con interruptor principal pero se desconoce el tiempo que este a estado en funcionamiento el equipo tiene 10 años de antiguedad, favor de determinar si el interruptor puede ya estar degradado y es conveniente considerar uno nuevo. - Adecuacion de la instalacion hidraulica, la tuberia actual queda a 1.5mts de donde sera la nueva ubicacion del equipo. - Arranque y un mantenimiento preventivo para determinar el estado del equipo e informar condiciones en las que se deja operando.  2. Conexion electrica de la nueva evaporadora (Aire Data Temp de 10TR Mca Data Aire) a una distancia de 35mts a los tableros conectados a la planta de emergencia (ya existe una cedula de costos considerando una distancia de 10mts) y la condensadora a una distancia de 40mts a los tableros conectados a la planta de emergencia (la misma cedula de costos considera una distancia de 20mts, para este caso) anexo liga de esta cedula: https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AuE-MkGtG1AudG84Rm9JSDBFd0Vva2JGVzFFcm9QckE#gid=0   3. Instalacion dentro del site de un CANCEL DE 1.5MTS DE LARGO POR 2.4MTS DE ALTO A INSTALARCE DEL LADO DERECHO DE LA PUERTA QUE DA EL ACCESO A EL CENTRO DE DATOS.  Cada uno de los 3 requerimientos se requiere su precio por separado  quedo a sus ordenes en espera de su respuesta y/o comentarios, gracias  saludos','','CM302','MXO','SAC313',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-02 14:18:48','claudia.rivera@gposac.com.mx','Otros','','','COMPRA TELEFONO FIJO','2013-08-10 00:00:00','1 TELEFONO CISCO IP PHONE SPA301 PARA GUILLERMO SANTOS','Requerimiento de Compra de Activos','NA','MXO','SAC314',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-02 15:06:14','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-03 00:00:00','1 MODULO COMPLETO DEL ESTATICO CON ID NO. DE PARTE SYSW40kF PARA UPS SYMMETRA PX REPORTE 13-167, ENVIAR A ARO SISTEMAS, MERIDA. ES URGENTE!','','CM150','MXO','SAC315',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-05 14:08:25','ivan.ramirez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-07-06 00:00:00','SE REQUIERE DEL PRECIO QUE TENDRÍA EL REMPLAZO DE 2 BANCOS DE BATERÍAS PARA UPS. CADA UPS CUENTA CON UN BANCO DE BATERIAS COMPUESTOS POR 10 BATERÍAS MARCA DINASTY CON NUMERO DE PARTE 12-300  FAVOR DE CONSIDERAR EL RETIRO Y CONFINAMIENTO DEL BANCO EXISTENTE  ASI COMO LA INSTALACIÓN DEL BANCO NUEVO. LA DISTANCIA DEL PRIMER UPS ES DE 70 MTS. Y SE NECESITA SUBIR LAS BATERÍAS A UN PRIMER PISO PARA EL CAMBIO DE LAS MISMAS. LA DISTANCIA DEL SEGUNDO UPS ES DE 20MTS. Y LA INSTALACIÓN SERA EN PLANTA BAJA.','','NA','MXO','SAC316',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-05 16:27:50','raul.perez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-05 00:00:00','Que tal Raul buenas tardes.  - 1 modulo de poder para Ups Symmetra Px y  4 unidades de baterias para el mismo ups.  Saludos ','','NA','QRO','SAC317',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-05 20:19:53','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-05 00:00:00','SOLICITO PRECIO DE UNA PLANTA DE EMERGENCIA CON LAS SIGUIENTES CARACTERISTICAS:  PLANTA GENERADORA ELÉCTRICA, TRIFÁSICA ACOPLADA A MOTOR DE DIESEL, ENFRIADO POR AGUA, 1800 RPM, SIN ESCOBILLAS, AUTOEXITADO Y AUTOREGULADO, CON SILENCIADOR TIPO HOSPITAL Y DUCTERÍA PARA CONDUCCIÓN DE GASES DE ESCAPE AL EXTERIOR, SERVICIO INTERIOR, MARCA IGSA O SIMILAR, CON LAS SIGUIENTES CARACTERÍSTICAS: VOLTAJE: 440V, 3 FASES, 60CPS, ALTITUD: 2400 MSNM, 40 KW DE POTEBCIA CONTINUA, 38 KW DE POTENCIA DE EMERGENCIA, TABLERO DE TRANSFERENCIA AUTOMÁTICA PARA CAMBIAR A GENERACIÓN PROPIA CUANDO LA ALIMENTACIÓN NOMINAL BAJE AL 80% DEL VOLTAJE NOMINAL O PIERDA UNA FASE, CON RESTABLECIMIENTO A LA ALIMENTACIÓN NORMAL AL ALCANZAR ESTA EL 90% DEL VOLTAJE NOMINALEN LAS TRES FASES, DESPUES DE TRANSCURRIDOS 5 MINUTOS, MARCA ICSA O SIMILAR. TANQUE DE ALMACENAMIENTO PARA DIESEL FABRICADO A BASE DE PLACA DE ACERO AL CARBÓN ASTM A 53, GR B, CALIBRE 12, DE Ø 1100 MM POR 2,500 MM DE LARGO. CONSTARA DE CINCO ORIFICIOS DE DIFERENTES DIÁMETROS: UNO PARA LA COLOCACIÓN DEL REGISTRO DE INSPECCIÓN, PARA LA INSTALACIÓN DE UNA VÁLVULA DE EXPULCIÓN DE GASES, PARA EL SUMINISTRO PROPIO, PARA EL DRENADO Y EL ÚLTIMO PARA LA LÍNEA DE ALIMENTACIÓN AL TANQUE DE DIARIO. REGISTRO DE INSPECCIÓN FABRICADO A BASE DE PLACA DE ACERO AL CARBÓN ASTM A 53, GR B, CALIBRE 12, DE Ø 800 MM CONTARÁ DE MARCO, CONTRAMARCO Y TAPA, CON UNA BISAGRA DE BARRIL DE 5/8" Y JALADERA DE  OPERACIÓN.   QUEDO AL PENDIENTE, SALUDOS Y GRACIAS.','','CQ510','QRO','SAC318',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-06 13:38:49','luis.andrade@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-08 00:00:00','32 baterías 12V-7Ah, para UPS symmetra PX de 80 kvas ubicado en bica del río, corresponde a la UPS-1158. Es necesario armar 4 unidades de baterías','','CM150','MXO','SAC319',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-06 13:58:52','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-15 00:00:00','1 CARACOL DE MANEJADORA DE AIRE STULZ NO. DE PARTE M44855 TURIN PART. AU083165 PARA SITIO AGUA DULCE OS-4057, ENVIAR A ISEC VILLAHERMOSA ','','CM150','MXO','SAC320',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-06 14:44:00','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-15 00:00:00','2 FUSIBLES FERRAZ MOD. S078331 660V 125A 2 FUSIBLES BUSSMAN 100A IR 500V 200KA PARA BANCO DE BATERIAS OS-4007 PARA CARDENAS, ENVIAR A ISEC VHS','','CM150','MXO','SAC321',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-06 16:05:20','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-12 00:00:00','Buen día Me pueden apoyar por favor con lo precios para las partidas de esta licitación (INEGI PATRIOTISMO), les comento que habíamos realizado el estudio de mercado. En la carpeta que comparto viene la licitación (Convocatoria) y toda la documentación relacionada al estudio de mercado (diagramas, planos cédula etc.). De igual forma le pido podamos considerar el mejor precio para poder  tener posibilidades de llevárnosla.  https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0B2jQgfvQJ9a0X1NhUm13TTBzNzA   Saludos.','','CG350','GDA','SAC322',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-06 16:11:00','liliana.diaz@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-06 00:00:00',' SE SOLICITA  PRECIO  LE LISTA  DE  UNA TARJETA POWER SUPPLY Para un 9800A de 375KVA, 480V/480V  GRACIAS ','','NA','MXO','SAC323',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-06 16:41:20','felipe.campos@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-09 00:00:00','BOMBA DE CONDENSADOS MEDIOS MARCA BECKETT CORPORATION MODELO CB202UL VOLTAJE 208/230 VCA    1.2 AMP   60 HZ  SE ANEXA LINK DE LA PARTE:     http://www.beckettpumps.com/industrial/product.php?productid=20  EL LUGAR DE ENTREGA ES EN LA OFICINA QUERETARO ','','CQ73','QRO','SAC324',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-06 16:51:39','daniel.bravo@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-09 00:00:00','2 PIEZAS  FILTRO PARA AIRE ACONDICIONADO TIPO PLISADO DESECHABLE CON MARCO DE CARTÓN DE 20" x 20" x 1"  AL 40% DE EFICIENCIA ATMOSFÉRICA. ','','CQ-126','QRO','SAC325',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-06 17:46:23','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-09 00:00:00','Buen día Me pueden apoyar por favor con lo precios para las partidas de esta licitación (PEMEX SERVICIO A PLANTA DE EMERGENCIA), les comento que habíamos realizado el estudio de mercado. En la carpeta que comparto viene la licitación (Convocatoria) y toda la documentación relacionada al estudio de mercado. De igual forma le pido podamos considerar el mejor precio para poder tener posibilidades de llevárnosla.  Las fechas para este proceso son la siguientes: * JUNTA DE ACLARACIONES: VIERNES 09-AGOSTO * PRESENTACIÓN PROPUESTA: 14-AGOSTO A  LA 1:00 PM * FALLO: FALLO EL DÍA 20-AGOSTO  https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0B2jQgfvQJ9a0OGlacUYwaFBNZUk    ','','CG446','GDA','SAC326',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-06 18:14:52','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-19 00:00:00','Buen día Me pueden apoyar por favor con lo precios para las partidas de esta licitación (INEGI SUMINISTRO DE 3 PLANTAS DE EMERGENCIA), les comento que habíamos realizado el estudio de mercado. En la carpeta que comparto viene la licitación (Convocatoria) y toda la documentación relacionada al estudio de mercado. De igual forma le pido podamos considerar el mejor precio para poder tener posibilidades de llevárnosla. Las fechas para este proceso son la siguientes: * VISITA: 19-AGOSTO a las 9:30 PARA PARTIDAS 1 Y 2 PARA LA PARTIDA 3 A PARTIR DE HOY Y HASTA EL 16 DE AGOSTO de 2013 de las 9:00 a las 16:00 horas * JUNTA DE ACLARACIONES: 20 DE AGOSTO A LAS 11:00	 * PRESENTACIÓN PROPUESTA: 26-AGOSTO A LAS 10:00  https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0B2jQgfvQJ9a0dkh6T0g3WENCOW8 ','','CG447','GDA','SAC327',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-06 18:57:53','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-07 00:00:00','SE REQUIERE DEL PRECIO QUE TENDRÍA UN TRANSFORMADOR DE AISLAMIENTO DE 20KVA DE CAPACIDAD. CON ENTRADA DE 220VCA A 208VCA DE SALIDA, PARA INTERIOR ESTE SE REQUIERE INSTALAR A LA ENTRADA DE UN UPS DE 20KVA. CONSIDERAR UNA DISTANCIA DE 8 METROS PARA LA INSTALACIÓN ELÉCTRICA. ESTE TRANSFORMADOR SE INSTALARA EN UN 4 PISO Y SE REQUIERE RECORRER UNA DISTANCIA DE 20 M LINEALES  ','','NA','MXO','SAC328',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-07 09:37:42','berenice.martinez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-07 00:00:00','BUEN DÍA, SOLICITO REEMPLAZO DE SENSOR DE ALTA PRESION, P100DA-18, 159-100-400, 6(6)A 240VDC, C0400, 141R10, JONHSON CONTROLS, PMAX 418 PZH, ES PARA UN EQUIPO DATA AIRE, DTAD-0332, LOS DATOS DE LA CONDENSADORA SON DATA AIRE DRCU-0532-3, JOB:32961. CUALQUIER DUDA FAVOR DE CONTACTAR A CAMILO PEÑA 045 6671684069, DOMICILIO PARA ENVIO: MARIANO ESCOBEDO #1133 COL. LAS VEGAS CULIACAN, SINALOA. CONTRATO CM150 TAR NAVOJOA.','','CM150','GDA','SAC329',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-07 18:01:50','ivan.martin@gposac.com.mx','Ventas','Levantamiento','','','2013-08-12 00:00:00','Se solicita visita de ingeniero de MGE para revision de UPS propiedad de Cablemas, la visita debe contemplar el diagnostico de la falla que presenta, posterior elaboracion de cedula de costos para cotizacion de reparacion y puesta en marcha, se anexan datos de la UPS   UPS	UPS MARCA MGE 50 KVA	MODELO 72-160512-22 SERIE B05-12992','','NA','QRO','SAC330',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-07 18:11:25','ivan.martin@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-08-13 00:00:00','Apoyo para visita de levantamiento proyecto de Monitoreo Cablemas en la ciudad de Poza Rica, Veracruz','','cq395','QRO','SAC331',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-07 18:41:54','rogelio.valadez@gposac.com.mx','Ventas','Realización de Cedula de Costos  (Cuando sea necesario instalaciòn o servicio adicional)','','','2013-08-07 00:00:00','SE SOLICITA CEDULA PARA EL SUMINISTRO E INSTALACIÓN DE INTERRUPTOR PRINCIPAL PARA PDU DE 100KVA 480V (TABLERO EXISTENTE EDIFICIO B1 PISO 3 DE PEMEX) Y ALIMENTADOR PARA LA MISMA CAPACIDAD DE 30M (CHAROLA EXISTENTE), INTERCONECCIÓN AL PDU SUMINISTRADO, ASÍ COMO 10 BOAS DE 15 M, INTERRUTORES Y NEMAS POR DEFINIR.','','CM398','MXO','SAC332',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-08 09:22:22','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-12 00:00:00','8 MODULOS DE POTENCIA SYPM10KF,  SWITCH ESTATICO CON ID SYSW80KVS, 1 MODULO DE BATERIAS SYBT4 (EN PRESTAMO) ES PARA MODULO K EN BOCA DEL RIO OS-2913, ENVIAR A CENTRO DE SERVICIO VERACRUZ O A OCURRE EN BOCA DEL RIO, VERACRUZ  ESTE REQUERIMIENTO SE CONFIRMO CON MIGUEL QUE SE TIENE EN GUADALAJARA','','CM150','MXO','SAC333',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-08 13:10:58','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-08 00:00:00','RAUL, BUENOS DIAS.  SOLICITO PRECIO DE VENTA DE UNA PLANTA DE EMERGENCIA OTTOMOTORES 125 KVA, USO CONTINUO, 220/120V, 3F, CON TRANSFERENCIA AUTOMATICA Y CASETA ACÚSTICA, TANQUE EXTERNO DE 500 LTS. SOLICITO TAMBIEN CÉDULA DE COSTOS PARA LA INSTALACIÓN ESTE EQUIPO, LOS PLANOS ARQUITECTONICOS Y  DE CARGAS YA TE LOS EH COMPARTIDO, Y LOS DATOS DE DISTANCIAS Y TRAYECTORIAS SON LOS QUE TOMASTE.  QUEDO AL PENDIENTE, SALUDOS','','CQ513','QRO','SAC334',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-08 15:33:20','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-08-08 00:00:00','RAUL,  Solicito cédula de costos para instalación de 3 AAP APC tipo InRow, y 2 UPS de 20 y 10 KVA Tipo 1100 Estas instalaciones se realizaran en la UAQ Juriquilla, la información como los unifilares, distancias y trayectorias ya los tienes.  Quedo a tus ordenes, saludos','','CQ513','QRO','SAC335',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-09 11:15:02','ivan.martin@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-08-09 00:00:00','Se requier apoyo para cedula de costos instalacion de AAP Gforce Inrow en la ciudad de Cancun','','CQ516','QRO','SAC336',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-09 12:10:41','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-08-09 00:00:00','Raul,  Por favor necesito actualización de precios de la cedula: https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AmV3w6yIjEiQdFhEOFY0c0RTZzRnM05vSGlyYTRab2c#gid=10  y necesito por favor el precio de: Configuración de equipo Infraestruxure Central, adicionamiento de dispositivos SNMP para monitoreo, configuracion de parametros de operacion, pre-alarmas, alarmas, configuración de reportes de estatus, capacitación a personal de Ahorros Bienestar que operara el equipo, Servicio de instalación y configuración de equipo Netbotz con cámara y sensores. Estos equipos estan descritos en la cedula: https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AmV3w6yIjEiQdFhEOFY0c0RTZzRnM05vSGlyYTRab2c#gid=6  Quedo al pendiente, gracias. ','','CQ293','QRO','SAC337',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-09 14:23:18','oscar.huerta@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-12 00:00:00','UNA TARJETA "DAP III DISPLAY MODULE   P/N 160-400-090 REV H, SERIAL: E-06-0671" UNA TARJETA "DAP III CONTROLLER MODULE P/N 160-400-091 REV I, SERIAL: E-01-04741"  ORDEN DE SERVICIO: FOLIO: OS-2074 No. TICKET: 13-194 ','','CM-150','MXO','SAC338',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-12 01:08:03','ivan.martin@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-08-13 00:00:00','Se requiere cedula de costos para cotizar UPS de acuerdo a la especificacion proporcionada por el cliente IEC para licitacion, se anexo dicha especificacion por correo electronico, incluir la informacion adicional solicitada en dicho correo.','','NA','QRO','SAC339',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-12 17:46:53','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-12 00:00:00','Raul, buenas tardes.  Solicito precio tablero de transferencia, para una planta Caterpillar de 210kw a 480 volts y 316 amp, actualmente tienen una trasferencia asco Cat. No. E9403400x7 que se daño  Y por favor apoyáme con una cédula de costos para la instalación de esta transfrencía, la instalación será localmente en el P.I. Bernardo Quintana.  Saludos y gracias.','','CQ510','QRO','SAC340',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-12 17:54:32','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-12 00:00:00','De acuerdo a ticket 13-195, se realizo el cambio de una tarjeta de comunicación la cuál tenia el centro de servicio y se tiene le tiene que reponer, de acuerdo a la orden de servicio OS-0716 No. de parte: W090007 ','','CM150','QRO','SAC341',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-13 01:34:40','salvador.ruvalcaba@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-20 00:00:00','COTIZAR Y ADQUIRIR Software Support Contract para actualizar versión 7.0 a 7.2 un   InfraStruXure Central Basic AP9465  num. de serie FA0909650013, con APC. ','','NA','GDA','SAC342',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-13 10:36:21','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-15 00:00:00','1 RADIADOR ROLAMEX MOD.40003-CUM-3 PARA PE IGSA, REQUERIMIENTO DIAGNOSTICADO POR JOEL BARRON, SITE CD. MENDOZA OS-2076','','CM122','MXO','SAC343',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-13 12:55:47','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-14 00:00:00','1 COMPRESOR MOD. K2-C340GETE-H 1PH,60HZ, 220V R22, SE CAMBIARIA COMO GARANTIA EN NAVEQ, ES URGENTE','','CQ35','MXO','SAC344',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-14 08:54:44','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-18 00:00:00','2 TARJETAS DE CONTROL (FM26192-CA-1474A Y M24469-CA-8796) PARA SITIO CARDENAS OS-4070 REP. 13-199 ENVIAR A ISEC VILLAHERMOSA','','CM150','MXO','SAC345',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-14 11:01:22','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2014-03-20 17:05:21','Raúl, buenos días.  Por favor, solicito precio de las siguientes refacciones: 1 Pieza de MODULO DE CONTROL AUTOMÁTICO MARCA DALE MODELO 3100,	 1 Pieza de KIT DE SENSOR VDO TEMPERATURA,	 1 Pieza de KIT DE SENSOR PRESIÓN DE ACEITE,	 2 Piezas de RELEVADOR DE 8 PIN CON BASE A 127 VOLTS,	 1 Pieza de CABLE Y CONECTORES VARIOS (ARNÉS DE CONTROL)	  Saludos, gracias.','','CQ519','QRO','SAC346',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-14 13:58:43','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-18 00:00:00','1 DESHUMIDIFICADOR DEFROST MDB-09AMN3 1 VALVULA SOLENOIDE MODELO 32450/00, 31313244, S 2450/00, 303 13 E, TM 90 C, AB3 MIN, 80 C, 25 C  PARA REPARACION DE AIRE EN CERRO AZUL OS-2925  ENVIAR A CS VERACRUZ','','CM150','MXO','SAC347',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-14 15:16:06','ivan.martin@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-14 00:00:00','Se solicita precio de lista para SUMINISTRO  DE PLANTA DE EMERGENCIA 60 KVA 3F-4H, 60 HZ, FP 0.8, CAT. CNY60, MCA OTTOMOTORES para integrador  Grupo Constructor Trece S.A deC.Ven Celaya que esta participando en licitacion ','','na','QRO','SAC348',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-14 16:35:58','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-14 00:00:00','Raul,  Se requiere de urgente el precio del siguiente motor: Motor para AAP, marca Emerson, Modelo K55HXJZE-3122, 208/230V, 60Hz, Parte No. 1D21122P1, Frame 48Y  Saludos.','','CQ521','QRO','SAC349',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-15 11:07:46','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-15 00:00:00','Raul, buenos dias.  Requiero precio de una Planta de Emergencia de 2000 kva para uso continuo a un voltaje de 440V trifásica con Tablero de transferencia	  Saludos','','CQ524','QRO','SAC350',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-15 15:38:14','ivan.ramirez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-08-16 00:00:00','SE REQUIERE DEL APOYO DE UN INGENIERO PARA REALIZAR UNA VISITA AL PROSPECTO UNIVERSIDAD IBERO SE REQUIERE MEJORAR EL DESEMPEÑO EN LOS EQUIPOS DE AIRE ACONDICIONADO DEL CLIENTE POR LO CUAL SE REQUIERE REALIZAR UN LEVANTAMIENTO PARA OFRECER UNA BUENA SOLUCION AL CLIENTE.','','NA','MXO','SAC351',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-19 11:59:52','ivan.martin@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-08-21 00:00:00','Respecto a la licitación G-070-05-01 para el “DESARROLLO DE LA INGENIERÍA COMPLEMENTARIA, PROCURA DE EQUIPO Y MATERIALES, SUMINISTRO, INSTALACION, CONSTRUCCION, PRUEBAS, CAPACITACION Y PUESTA EN OPERACION PARA EL NUEVO LABORATORIO DE ANALISIS QUIMICO DEL PROYECTO CALIDAD DE COMBUSTIBLES EN LA REFINERIA "FRANCISCO I. MADERO" DE CD. MADERO, TAMPS". DE LA COMPAÑIA IEC SOLICITA COTIZAR 3 EQUIPOS UPS SE REENVIA CORREO DE ESPECIFICACIONES Y DESCRIPCION DE LOS EQUIPOS SOLICITADOS. ','','CQ526','QRO','SAC352',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-21 09:14:48','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-23 00:00:00','2 CHUMACERAS DE PISO  1/8 MARCA BROWNING, SE ENVIA COTIZACION POR MAIL.  1 minipresostato  o transistor de baja presión  numero de parte PS3-A3S , PCN: 0713842 ,MARCA ALCO. Se requiere de entrega inmediata y tiene un costo aprox de $73 USD.  datos del equipo de Aire en donde se instalará:  Modelo:  2004  marca stulz Tipo: 993A N° de Serie: 0530040397/011','','CM150','MXO','SAC353',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-21 14:30:21','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-27 00:00:00','1 COMPRESOR MARCA COPELAND SCROLL MODELO-ZR72KC-TFS-265 3 FASES 208-230 VOLTS 1 BANDA MODELO A-43 1 FILTRO DESHIDRATADOR C-165-S -5/8¨ 1 MOTOR DE ¾ H.P. 220 VOLTS FLECHA DE ½” -Nota tiene que ser marca AOSMITH 1 ASPA DE ALUMINIO DE 26X ½” de 4 ALABES 1 CONTROL DE VELOCIDAD VARIABLE P-66BAB-1 1 TRANSFORMADOR DE 220-24VOLTS 40VA 1 CONTACTOR TRIFÁSICO 35 AMP. BOBINA 24 VOLTS FURNAS O SIMILAR  PARA REPARACION AIRE MACUSPANA APC MODELO-AF-60-A-BA-D  ENVIAR A ISEC VILLAHERMOSA OS-0461','','CM150','MXO','SAC354',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-22 17:27:21','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-23 00:00:00','1 INTERRUPTOR DE SALIDA MOD. KG150 MARCA KRAUS & NAIMER PARA SITIO CARDENAS, ENVIAR A ISEC VILLAHERMOSA UPS-2554','','CM150','MXO','SAC355',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-22 18:37:29','ivan.martin@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-28 00:00:00','FAVOR DE INDICAR PRECIO DE REFERENCIA PARA SOLUCION DE CASETA DE TELECOMUNICACIONES QUE INCLUYE PE, PCD, EQUIPO DE MONITOREO AMBIENTAL, CCTV, TVSS, ESTRUCTURA DE CASETA. ESTA SOLUCION ES SIMILAR A LA QUE SE SUMINISTRO A PEMEX TELECOM EN POZA RICA','','CQ395','QRO','',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-22 18:37:30','ivan.martin@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-28 00:00:00','FAVOR DE INDICAR PRECIO DE REFERENCIA  CLIENTE CABLEMAS PARA SOLUCION DE CASETA DE TELECOMUNICACIONES QUE INCLUYE PE, PCD, EQUIPO DE MONITOREO AMBIENTAL, CCTV, TVSS, ESTRUCTURA DE CASETA. ESTA SOLUCION ES SIMILAR A LA QUE SE SUMINISTRO A PEMEX TELECOM EN POZA RICA','','CQ395','QRO','SAC357',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-22 18:50:22','ivan.ramirez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-08-23 00:00:00','POR ESTE MEDIO SE SOLICITA DE LA AYUDA DE UN INGENIERO PARA ACUDIR A REALIZAR UN LEVANTAMIENTO EN INSTALACIONES DE PEMEX (TORRE EJECUTIVA) EL OBJETO SERA DETERMNAR LA CAPACIDAD Y TIPO DE AIRE ACONDICIONADO PARA CIERTOS PISOS DE TORRE EJECUTIVA. (LA REUNION SERA A LAS 10AM. EN ESTE CASO SE REQUIERE SEA EL ING. JOEL PAZ QUIEN ACUDA A SITIO)','','CM240','MXO','SAC358',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-23 13:03:18','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2014-03-20 17:05:22','1 MOTOR MARATON TRIFASICO NO. PARTE 25301801 MOD.CWL56T1105538E P, HP 1 1/2 RPM1140 200-230 1 VARIADOR DE VELOCIDAD MOD.P66BAB-1 JHONSON CONTROLS PARA AA DE CARDENAS, ENVIAR A ISEC VILLAHERMOSA ','','CM150','MXO','SAC359',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-26 08:44:17','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-30 00:00:00','1 TARJETA CARGADORA DE BATERIAS MOD.21452-2 TYPE 1 4300 94V0 E99006  1 INTERRUPOTOR DE PERILLA DE BYPASS MANUAL MOD. KG250 KRAUS & NAIMEROS-4034 REP. 13-209  PARA SITIO CARDENAS, ENVIAR A ISEC VILLAHERMOSA ','','CM150','MXO','SAC360',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-26 08:57:07','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-26 00:00:00','1 ASPA DE 28" CON CENTRO DE 5/8", 5 ALAVES. OS-4059 1 COMPRESOR DE 10TN. SCROLL MOD. ZR144KC-TF5-522 200V R22 O. AA-1512  URGENTE!!  SITIO REFORMA, ENVIAR A ISEC VILLAHERMOSA','','CM150','MXO','SAC361',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-26 10:34:51','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-08-26 00:00:00','Buen dia.  Raul, te paso la información del estudio de mercado que nos solicito CFE, como lo comentamos ya le pase la información a Ana Maria Olvera de la empresa Site, la cual me comentaste es tambien con quien tu lo cotizas. En cuanto me paso los precios te los envio para que los tengas.  Te paso el link del requerimiento.  https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0B2jQgfvQJ9a0OW5iaXBxcHZ1eWs ','','CG433','GDA','SAC362',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-26 15:08:29','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-08-27 00:00:00','EN BASE A REQUERIMENTO SAC 328 SE REQUIERE TAMBIEN DEL PRECIO QUE TENDRÍA UN TRANSFORMADOR DE AISLAMIENTO DE 40KVA DE CAPACIDAD. CON ENTRADA DE 220VCA A 208VCA DE SALIDA, PARA INTERIOR ESTE SE REQUIERE INSTALAR A LA ENTRADA DE DOS UPS SILCON DE 20KVA CADA UNO. CONSIDERAR UNA DISTANCIA DE 15 METROS PARA LA INSTALACIÓN ELÉCTRICA. ESTE TRANSFORMADOR SE INSTALARA EN UN 4 PISO Y SE REQUIERE RECORRER UNA DISTANCIA DE 20 M LINEALES ','','CM409','MXO','SAC363',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-26 15:41:25','joel.barron@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-29 00:00:00','LA TRANSFERENCIA DE SAN MIGUEL-PEMEX SE QUEDA TRABADA  POR RECOMENTDACION DE SALVAOR RUBALCAVA  SE REQUIERE DE 2 CONTACTORES DE 100AMP , CADA UNO  CON UN AUXILIAR  NC Y OTRO NA   PARA EL INTERLOCK  LA BOBINA DE OPERACION ACTUAL, ESTA MARCADA CON 220VCA   ATENTAMENTE  JOEL BARRON','','NA','MXO','SAC364',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-26 15:42:11','ivan.ramirez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-08-27 00:00:00','DANDO SEGUIMIENTO A LA REQUISICION SAC358 SE SOLICITA DE LA AYUDA NUEVAMENTE DEL ACOMPAÑAMIENTO DEL ING. JOEL PAZ YA QUE EN LA VISITA ANTERIOR QUEDARON PENDIENTES REVISAR ALGUNAS AREAS EN DONDE SE INSTALARAN ALGUNOS EQUIPOS. LA SITA SERA NUEVAMENTE A LAS 10 HRS','','CM240','MXO','SAC365',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-27 13:31:09','rufino.moctezuma@gposac.com.mx','Ventas','Levantamiento','','','2013-08-27 00:00:00','Buenos dias.  Solicito apoyo de un ingeniero de servicio para hacer un levantamiento para la instalación eléctrica de un UPS de 20 KVA, actualmente hay un equipo bifasico y se esta proponiendo un Mitsubishi trifasico. Este levantamiento se realizara en la oficina de International/Navistar, ubicada en el parque Queretaro. El dia sugerido por el usuario es el dia miercoles 28 de Ago entre 10:30 am y 12:00 pm.   Quedo al pendiente de sus comentarios. Saludos','','CQ473','QRO','SAC366',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-27 16:15:26','marlem.samano@gposac.com.mx','Gerentes al Area de Compras','','','','2013-09-15 00:00:00','Buenas tardes, solicito por favor la compra de 1000 formatos de ordenes de servicio de baterias .  Paso los datos de la imprenta que realizo las anteriores yo sugiero  sea la misma  por que ya tienen  los formatos y los folios que seguirian   IMPRENTA KENZO Expertos en Urgencias!   Tel 295 6925  & 212 9743 Fray Pedro de Gante 55-A, Cimatario lunes a viernes  de  9:30 am a 6:30 pm   www.kenzo.org.mx Twitter @imprentakenzo imprentakenzo@facebook.com  Gracias','Requerimiento de Compra de Activos','NA','QRO','SAC367',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-27 19:31:21','ivan.ramirez@gposac.com.mx','Ventas','Elaboración de Plano e Imagenes 3D del SITE (se deben anexar planos del edificio y dibujos de levantamiento)','','','2009-08-30 00:00:00','EN BASE A LEVANTAMIENTO REALIZADO POR EL ING. JOEL PAZ DERIVADO DE LA REQUISICION SAC 358 Y 365 SE REQUIERE DE LA ELABORACION DE PLANOS Y SEMBRADO DE EQUIPOS A SUMINISTRAR (EL ING JOEL PAZ YA SE ENCUENTRA TRABAJANDO EN ESTOS PLANOS)','','CM403','MXO','SAC368',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-27 19:44:22','ivan.ramirez@gposac.com.mx','Ventas','Levantamiento','','','2013-08-27 00:00:00','SE REQUIERE DEL APOYO DE PERSONAL DE SERVICO DE UNIDAD QUERETARO PARA REALIZAR EL LEVANTAMIENTO EN 3 DIFERENTES TIENDAS CHEDRAUI DE LA MISMA CIUDAD. EL OBJETIVO SERA IDEINTIFICAR EQUIPOS DE INFRAESTRUCTURA COMO PLANTAS UPS Y AIRES ACONDICIONADOS DE PRECISIÓN REALIZANDO UNA RELACIÓN DE LO EXISTENTE Y SU ESTADO O CONDICIÓN ASI MISMO IDENTIFICAR SI CUENTA CON ALGUN PUERTO O TARJETA PARA MONITOREO REMOTO, YA QUE ESTA RELACIÓN SE TOMARA COMO BASE PARA COMENZAR CON PRUEBAS DE MONITORIO PARA ESTAS TIENDAS. LA RELACIÓN DE TIENDAS Y CONTACTO DE LAS MISMAS LAS HARE LLEGAR POR CORREO ELECTRÓNICO ASÍ MISMO INFORMARE DE LAS FECHAS TENTATIVAS PARA REALIZAR ESTOS TRABAJOS.','','CM410','MXO','SAC369',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-28 10:04:28','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-28 00:00:00','1 TVSS DE 80 KA 3PH 208V PARA REP.13-199 CARDENAS, SE CANCELO EL REQUERIMIENTO SAC345 Y DE ALLI SURGIO ESTA OPCION. ENVIAR A ISEC VHS','','CM150','MXO','SAC370',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-28 10:21:36','jorge.martinez@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-08-28 00:00:00','Mesa de Ayuda,  Buen dia, de favor, me pueden cotizar un Gabinete para alojar banco completo de baterías, de 40 baterías tipo UPS12-540MR (12V, 147AH), compatible con UPS Marca Liebert, Mod. U39SA229AAAB552, de 225 KVA.  Debe incluir sus conexiones eléctricas e interruptor principal de baterías, así como sus cables de control y sensores.  El equipo UPS actualmente tiene instalado un banco de baterías (identico al solicitado), se requiere la instalación y configuración para que el equipo cuente con dos bancos de baterías (dos anillos) en paralelo.  Este gabinete de baterias es para instalarse en el centro de cómputo ubicado en Marina Nacional, edificio B1, piso 3, Mexico DF, sobre piso falso.  ','','CM398','MXO','SAC371',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-28 16:00:14','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-08-28 00:00:00','1 TVSS de 80kA 3 fases 4hilos+ tierra 208 vca sellado, COMPLEMENTO PARA REQUISICION SAC361 SITIO REFORMA , ENVIAR A ISEC VHS','','CM150','MXO','SAC372',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-28 19:14:48','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-08-28 00:00:00','Se solicita cédula de costos para la instalación de UPS Mitsu 1100 de 20 KVA en Oficinas de International / Navistar, en base al levantamiento realizado el dia de hoy en las oficinas del cliente.  Quedo al pendiente, saludos.','','cq473','QRO','SAC373',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-28 19:29:21','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-08-28 00:00:00','Se solicita elaboración de cédula de costos para la instalación de: 3 piezas de AAP Marca APC, tipo InRow RC, Modelo: ACRC103, de 5 tons, 200-240V, 50/60 Hz, y 1 pieza de UPS Mitsu 1100 de 10 KVA 1 pieza de UPS Mitsu 1100 de 20 KVA banco de baterias externo dedos anillos la instalación se realizara en la UAQ Campus Juriquilla en base a los datos proporcionados por el cliente y el  levantamiento realizado por Raul en sitio.  Quedo al pendiente, saludos.','','CQ513','QRO','SAC374',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-29 11:21:46','liliana.diaz@gposac.com.mx','Ventas','Pregunta técnica','','','2013-08-29 00:00:00','En el edificio de Halliburton ubicado en Villahermosa Tabasco, se instalo un sistema de alarmas con miras a crecer en el sistema, el dia de hoy requieren colocar en este sistema detectores de humo por lo que requiero de favor una cotización para instalarlos. ','','NA','MXO','SAC375',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-29 13:22:06','rufino.moctezuma@gposac.com.mx','Ventas','Levantamiento','','','2013-07-29 00:00:00','Se solicita apoyo de compañeros de servicio en la Cd de México para hacer en un levantamiento en dos oficinas de Casa de Moneda en la Cd de México (Coorporativo y Apartado), esto para la instalación de 2 AAP de 3 Tons (uno en cada dirección).  Las direcciones son: Corporativo: Paseo de la reforma 295 5º piso, Colonia Cuauhtémoc, Los atendera, Berenice Zarate Apartado: Calle apartado no.13, Colonia Centro, Los atendera, Omar Valverde   Cuando tengan fecha programada avisenme para coordinarlo con la Casa de Moneda, minimo debe de ser un dia de antelación a la visita.  Quedo a sus ordenes para cualquier comentario Saludos y gracias.','','CQ509','QRO','SAC376',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-29 16:28:40','ivan.ramirez@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-09-02 00:00:00','Se requiere de la ayuda para que se realice la cédula de costos para la instalación de los aires acondicionados de el proyecto CM403 esto en base a los levantamientos y planos que realizo el Ing. Joel paz. correspondientes a las requisiciones SAC368, SAC358 Y SAC365 toda la información relacionada ya la tiene el Ing. Joel Paz.    ','','CM403','MXO','SAC377',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-30 12:39:49','ivan.martin@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-09-09 00:00:00','Con la finalidad de llevar a cabo una visita en campo, para el levantamiento técnico que permita elaborar las cotizaciones, de los suministros que se describen a continuación:   •	“SUMINISTRO, INSTALACIÓN Y PUESTA EN OPERACIÓN DE UN INTERRUPTOR DE POTENCIA TRIPOLAR SF6, TIPO  “ TANQUE VIVO ”,   PARA LA SUBESTACIÓN DEL SUMINISTRO DE ENERGIA ELÉCTRICA DE LA CAB POZA RICA DE LA GTDH NORTE”  •	“SUMINISTRO, INSTALACIÓN Y PUESTA EN OPERACIÓN DE MOTO-GENERADOR DE ENERGÍA ELÉCTRICA DE EMERGENCIA 1250 KW PARA LA PLANTA DE INYECCIÓN DE AGUA CONGÉNITA DE LA CENTRAL DE ALMACENAMIENTO Y BOMBEO DE POZA RICA, PERTENECIENTE AL GMOTDH SECTOR POZA RICA –ALTAMIRA DE LA GTDHRN”  •	“SUMINISTRO, INSTALACIÓN Y PUESTA EN OPERACIÓN DE UN MOTOR ELÉCTRICO DE 1000 HP  PARA LA PLANTA DE INYECCIÓN DE AGUA CONGÉNITA DE LA CENTRAL DE ALMACENAMIENTO Y BOMBEO DE POZA RICA, PERTENECIENTE AL GMOTDH SECTOR POZA RICA-ALTAMIRA DE LA GTDHRN”   FAVOR DE INDICAR EL NOMBRE DE LA PERSONA QUE IRA PARA ENVIAR OFICIO Y GENERAR ACCESOS AL AREA, EN DRIVE HAY UNA CARPETA CON LA ESPECIFICACIONES DE CADA UNO DE LOS EQUIPOS SOLICITADOS. https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0BwX_iTthtvk2TlVNaVEwV3hxaGc','','CQ227','QRO','SAC378',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-30 18:26:09','liliana.diaz@gposac.com.mx','Ventas','Pregunta técnica','','','2013-09-02 00:00:00','SOLICITO MODELO DE  BATERÍAS  PARA UN  POWERWARE PRESTIGE  DE 6000 Y  CUANTAS BATERÍAS REQUIERE ESTE  EQUIPO, PRECIO   E INSTALACIÓN PARA VILLAHERMOSA ','','CM414','MXO','SAC379',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-08-30 20:24:54','rogelio.valadez@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-09-06 00:00:00','El proyecto refiere a la construcción de un centro de datos, la liga anexa contiene los productos que se cotizo con EATON. Se tiene poca información aun del proyecto, pero se requiere realizar estimaciones para validar viabilidad económica con nuestros productos.  https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0BxpwtIK26_pSNGtyVUVKaWxKNWs','','CM415','MXO','SAC380',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-02 19:31:42','rogelio.valadez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-03 00:00:00','Se solicita precio de equipos bard, los modelos y capacidades están en la siguiente liga: https://drive.google.com/a/gposac.com.mx/?usp=folder#folders/0BxpwtIK26_pSZHhEdXZ1bzFLeUU ','','CM416','MXO','SAC381',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-03 12:04:14','rufino.moctezuma@gposac.com.mx','Ventas','Elaboración de Plano e Imagenes 3D del SITE (se deben anexar planos del edificio y dibujos de levantamiento)','','','2013-09-03 00:00:00','Raul, buenos dias.  Solicito la elaboración de un plano en 3D para el proyecto de site en Juriquilla de la UAQ. Esto con la finalidad de ser presentado durante la visita del personal de obras de la institución el próximo viernes 6 de Sep.  La información técnica (planos y diagramas) ya están en tu poder.  Quedo a tus ordenes. Saludos','','CQ513','QRO','SAC382',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-03 17:09:24','jorge.martinez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-09-05 00:00:00','Mesa de Ayuda,  Buena tarde, de favor me pueden asignar a Ing. Joel Paz Para acompañarme a una Reunion a RCI el proximo Jueves 5 de Septiembre a las 10:30am, ya que en el proyecto de Implementacion de Aire de Presicion que estamos trabajando con ellos quieren se les plantee la posibilidad de reacomodar su site en base a normas de modo que en algun momento tengan posibilidad de Certificarse,  quedo a sus ordenes en espera de su confirmacion, gracias  saludos','','CM302','MXO','SAC383',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-04 09:52:56','felipe.campos@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-09-05 00:00:00','MODULO DE PODER DE 10 KVA PARA UPS  APC SYMMETRA PX ','','CQ421','QRO','SAC384',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-04 14:18:35','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-04 00:00:00','Buenas tardes.  Me solicitan cotizar 1 pieza de Tarjeta de red para el ups Matrix APC, Modelo: AP9617, en la lista de precios se encuentra el Modelo: AP9618, ¿se puede tomar el mismo precio como referencia?  Quedo al pendiente de sus comentarios,  saludos y gracias.','','cq545','QRO','SAC385',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-04 18:00:15','jose.osorio@gposac.com.mx','Implementación y Servicio','','Solicitud de Costo','','2013-09-05 00:00:00','Solicitud para la compra de material para la creación de sensores secos y detectores de voltaje para el proyecto cablemas.  25 Relevadores a 24 Vcc Bola de Plug RJ45 de 8 contactos. 40 porta fusibles tipo americano. 6 cajas de 5 fusible tipo americano de 0,5 Amperes y 250 Vca. 30 Resistencias de 5.8 KHoms 30 Resistencias de 1 KHoms  ','','Cablemas','GDA','SAC386',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-04 18:13:25','jose.osorio@gposac.com.mx','Gerentes al Area de Compras','','','','2013-09-05 00:00:00','Solicitud de compra de material de trabajo para implementación de monitoreo,   Pinzas de corte, pinzas de pinta, pinzas de ponchar cable UTP, pinzas con medidas para pelar cable, desarmador punta cruz, desarmador punta plana, estuche de puntas Juego de puntas de precisión, estuche de puntas Juego de desarmadores de precisión, probador de cable UTP, pollo verificador de nodos de red, cautin. ','Requerimiento de Compra de Activos','NA','GDA','SAC387',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-05 12:23:12','salvador.ruvalcaba@gposac.com.mx','Ventas','Levantamiento','','','2013-09-06 00:00:00','Pemex Gas Edif. B2 piso 3, ups Mitsubishi 9900A 225Kva serie 10-7M73225-17 dos bancos de baterías en paralelo. Se requiere lo siguiente: - Copia del Formato de arranque por ottomotores. - En sitio, parámetros de configuración y alarmas. - Datos de la memoria SD - Revisión y pruebas con carga de los bancos de baterías (indicar claramente modelo) - Corriente por fase de PDU APC, capacidad de interruptor principal y capacidad interruptiva del mismo.  Gracias','','Garantia','MXO','SAC388',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-05 13:34:16','ivan.martin@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-06 00:00:00','requisición para precio de PE modelo PNY15 o PNY20, esta solicitando el precio Octavio Rodriguez y necesita un tiempo de entrega de 30 días pues comenta ya le liberaron presupuesto y quiere comprar 3 o 5 pero necesita que cumplamos con los tiempos','','NA','QRO','SAC389',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-05 18:01:09','salvador.ruvalcaba@gposac.com.mx','Implementación y Servicio','','Solicitud de Costo','','2013-09-09 00:00:00','Favor de cotizar para monitoreo de control PowerCommand de cummins: A040X126 PowerCommand 500 LAN 0541-1149 PowerCommand ModLon II Gateway LonWorks to Modbus Converter  Se pueden cotizas en Alesso o Megamak Gdl (Tlaquepaque), anexo liga con los datos de los distribuidores: http://www.cumminspower.com/es/locator/mexico/  Gracias','','NA','GDA','SAC390',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-05 19:21:58','rufino.moctezuma@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-09-05 00:00:00','Buenas tardes.  Se solicita apoyo para visita de obra en la UTEQ,  Proyecto Diseño y Construcción de Site Dirección: AV. Pie de la Cuesta No. 2501, Col Unidad Nacional, C.P. 76148, Santiago de Querétaro La visita sera el próximo lunes a las 10:00 am ','','CQ548','QRO','SAC391',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-06 18:31:03','jorge.martinez@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2012-09-10 00:00:00','Mesa de Ayuda, buena tarde de favor me puedes proporcionar los precios para la Adjudicación Directa Electrónica No. AA-018T4I011-N132-2013, de Petroleos Mexicanos, a mas tardar para el martes 10 de Septiembre a medio dia ya que la propuesta se entrega el 11 de Septiembre,   El alcance solo contempla suministro en sitio  Banda de B42 para equipo de Aire Acondicionado de Presicion           40 Piezas  	  	   Banda de B36 para equipo de Aire Acondicionado de Presicion           10 Piezas	   Boya de gas refrigerante R22 	                              10 Piezas  	  	   Sensor de baja presión para equipo de Aire Acondicionado Marca STULZ de 10TR, Mod. MRD-993A 	                                       2 Piezas  	  	   Sensor de alta presión para equipo de Aire Acondicionado Marca STULZ de 10TR, Mod. MRD-993A                                   	    2 Piezas  	  	   Motor de velocidad variable 3/4 HP, NP: B67-0010,	para ventilador de condensadora de equipo de Aire Acondicionado Marca LIEBERT de 30TR, Mod. DS105WUA0   	  	                                             2 Piezas Bomba de agua de 5 HP, equipo de Aire Acondicionado Marca LIEBERT de 30TR, Mod. DS105WUA0   	  	                              2 Piezas 		  	   Cubeta de pintura vinilica 100% lavable 	                     6 Piezas 	  	   Cubeta de recubrimiento retardante al fuego 	             6 Piezas  	  	   Filtro de aire de 4 pulgadas, 24X24 20% 	                     90 Piezas    Anexo liga en Drive de bases de esta adjudicacion   https://docs.google.com/a/gposac.com.mx/file/d/0BxMxMe9e2jD6SmQ1XzZyZUtyRTQ/edit','','CM89','MXO','SAC392',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-09 13:15:20','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-11 00:00:00','Me pueden apoyar en cotizar un cilindro humidificador para un  Aire, Data aire, Mod:DTAD0532,','','CG209','GDA','SAC393',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-10 13:57:04','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-09-17 00:00:00','3 CAMARAS MOD. DS2CC11A5NA HIKVISION PARA SITIO AGUA DULCE, ENVIAR A ISEC VHS','','CM150','MXO','SAC394',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-10 17:21:21','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-10 00:00:00','BUENA TARDE SOLICITO DEL APOYO PARA QUE SE PROPORCIONE EL PRECIO QUE TENDRIA LA LIMPIEZA NIVELACION  Y REFORZAMIENTO DEL PISO FALSO DEL SITE DE BAXTER CIVAC, YA SE CONTACTO A PROVEEDOR Y SE OBTUVO COTIZACION ANEXO LINK DE LAS MISMAS  https://docs.google.com/a/gposac.com.mx/file/d/0B4bMHo1P0jzeY1pzR09vUlB5S3M/edit?usp=sharing  https://docs.google.com/a/gposac.com.mx/file/d/0B4bMHo1P0jzeT21PN25wSlA5SGs/edit?usp=sharing  ','','CM354','MXO','SAC395',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-10 18:21:02','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-09-11 00:00:00','1 BATERIA LTH MOD. L8D-1125 DE 27 PLACAS PARA SITIO CARDENAS, DERIVADO DE PREVENTIVO, AÚN NO SE TIENE ORDEN DE SERVICIO  SUMINISTRARA CS CARMEN, $3701.01','','CM150','MXO','SAC396',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-10 19:06:20','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-11 00:00:00','Se solicita del precio que tendria la siguiente refaccion LT500Y Leak Detection Cable anexo link  http://www.emersonnetworkpower.com/en-US/Products/PrecisionCooling/Cooling-Monitoring/Leak-Detection/Pages/LiebertLT500YLeakDetectionCable.aspx','','CM292','MXO','SAC397',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-10 20:11:21','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-09-10 00:00:00','Buenos días.  Solicito precio los siguientes equipos y cédula de costos para  2 piezas de  Kit de control de acceso marca Rosslare que incluye: 1 Panel de control (AC215) para 2 lectores. 2 lectores de proximidad. 50 tarjetas de proximidad .  -Incluye Gabinete y fuente de 12 VCD, 1.5 Amp para panel de control"	 4 piezas de  Electroiman de 300 lb de fuerza de sujecion, incluye herraje para montaje en puerta.        	 4 piezas de  Boton de peticion de salida con placa.	 2 piezas de  Convertidor de datos para conexion de panel de control a red local para configuracion y administracion remota.        	 1 pieza de  Tarjeta de proximidad ISO Card, imprimible.	   1 servicio de  Servicio de instalación en sitio de paneles de control de acceso que incluye: instalacion de panel, colocacion de electroimanes en puertas de acceso, colocacion de botones de peticion de salida, cableados para interconexion de dispositivos, configuracion, puesta en marcha y capacitacion al usuario.	  La instalación es en Norgren en el Parque Querétaro. Si se requiere información complementaría indiquenlo por favor.  Quedo al pendiente, saludos.','','cq556','QRO','SAC398',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-11 14:14:19','raul.perez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-09-13 00:00:00','Buen dia por medio del presente se solicita de la manera mas amable la adquisición de 5 unidades que remplazaran al los kitrones del pedido para el proyecto de cablemas, comunico que se necesitan para esta semana. Nota: Checamos con proovedor y el tiempo de entrega es de 2 dias. Adjunto cotizacion.  5 unidades de 0541-1149 Power Command ModLong II Gateway LongWorks to modbus converter / LongWorks - Modbus /','','CQ395','QRO','SAC399',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-11 18:15:32','ivan.ramirez@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-09-11 00:00:00','SE REQUIERE DEL APOYO DE PERSONAL DE  SERVICIO PARA QUE  ASISTA A INSTALACIONES DE PISO 2 DE TORRE EJECUTIVA DE PEMEX A RECUPERAR LA CLAVE DE CONFIGURACIÓN DE LOS EQUIPO DE AIRE INRROW SC DE DICHO PISO. EL PROCEDIMIENTO PARA LA RECUPERACION DE DICHA CLAVE LA PUEDE PROPORCIONAR INGENIERIA.','','NA','MXO','SAC400',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-12 11:01:44','ivan.martin@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-12 00:00:00','Se solicita precio de lista para upgrade de tarjeta de Control de un Equipo Data Aire: Mod. DAMA-0212-AO        #serie. 2010-1356-A, ellos tienen actualmente el  MINI-DAPII, que esta dañado, no se requiere instalacion.','','CQ557','QRO','SAC401',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-12 14:03:05','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-09-13 00:00:00','Me pueden apoyar en recomendarme y cotizar una cámara de vídeo vigilancia para site,que sea IP, tenga visión nocturna (se utilizara para reconocimiento de personal) y se pueda integrar al central.   considerar patch cord de 3mts. y cableado para instalación eléctrica de 20 mts. (o la posibilidad de que sea POE), así como la mano de obra para su instalación.','','CG454','GDA','SAC402',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-12 15:43:26','raul.perez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-09-12 00:00:00','Se solicita de la manera mas amable una fuente para inrow SC con características y numero de parte indicadas en el link adjunto en esta solicitud. http://www.apc.com/products/resource/include/techspec_index.cfm?base_sku=W920-0082&tab=models una vez rastreado el proveedor me pueden indicar el tiempo de entrega ¿?. La parte es APC.  Saludos.','','CM150','MXO','SAC403',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-12 18:03:04','juanjose.espinoza@gposac.com.mx','Ventas','Pregunta técnica','','','2013-09-13 00:00:00','Me puede apoyar con un equipo Data Aire que cumpla con estas caracteristicas por favor: Temperatura del aire controlada: 20 ±0.25°C  Humedad relativa controlada: 45% Maximo  Control de particulas de polvo: Clase  8 de acuerdo a norma ISO 14644  Presion interna controlada: 12 a 25 Pa  Cambios de aire:  >20 por hora  Iluminacion:  1000 lux El cuarto mide 30 m2','','cg236','GDA','SAC404',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-13 10:12:16','felipe.campos@gposac.com.mx','Implementación y Servicio','','Elaboración de Plano o diagrama en CAD (Incluir Liga de Archivo de plano original en cad o de levantamiento a mano)','','2012-09-13 00:00:00','Elaboracion de diagrama para pdu de demo room en medidas reales, para su impresion.','','Demo Room','QRO','SAC405',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-13 10:13:52','martin.vazquez@gposac.com.mx','Implementación y Servicio','','Elaboración de Plano o diagrama en CAD (Incluir Liga de Archivo de plano original en cad o de levantamiento a mano)','','2013-09-20 00:00:00','Solicitud de Diseño en 3D: HDI DC Autopronto  DC coorporativo DC Irapuato DC Promomedios','','CQ327','QRO','SAC406',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-13 16:55:49','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-13 00:00:00','Buen dia Me pueden apoyar con la cotización de una PE con las sig. características:                  Capacidad:                      80 KW  Voltaje                           220 / 440.  Tablero de Transferencia     Incluirlo  Instalación en Sitio           Incluir base o cimentación para recibir equipo  Tanque adicional diésel      450 lts ó 500 lts  Incluir base o cimentación para tanque  Canalización de Diésel a equipo que estará retirado unos 6 mts de distancia  ','','C409','GDA','SAC407',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-16 15:37:38','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-16 00:00:00','Buenos dias.  Solicito Precio de los siguientes equipos Ottomotores: PLANTA DE EMERGENCIA 01 1 Pieza PLANTA  GENERADORA DE ENERGIA ELECTRICA PAR DE EMERGENCIA "PE-1"  DE  1000KW CONTINUOS, 3F, 4H, 480/277V, 60Hz, MARCA OTTOMOTORES o EQUIVALENTE CERTIFICADA (LOS VALORES REQUERIDOS SON EFECTIVOS A 1920 m.s.n.m.). 1 Pieza EQUIPO  DE  TRANSFERENCIA   "TT-1a"  AUTOMATICA CON INTERRUPTOR TIPO AUTOMATICOS (SOLO  OPERAN  COMO  DISYUNTORES) DE 3P-1600A, EQUIPO  DE  MEDICION INTEGRADO, 3F-4H,  480/277V, 60Hz, Y 65 KAMP,  SIMETRICOS   DE  CAPACIDAD INTERRUPTIVA  A  480Vca,   PROPORCIONADO   POR   EL  PROVEEDOR  DE   PLANTA  DE EMERGENCIA), PARA OPERA EN MAXIMO 10 SEGUNDOS. 1 Pieza EQUIPO  DE  TRANSFERENCIA   "TT-1b"  AUTOMATICA CON CONTACTORES MAGNETICOS DE 3P-200A, EQUIPO  DE  MEDICION INTEGRADO, 3F-4H,  480/277V, 60Hz, Y 65 KAMP,  SIMETRICOS   DE  CAPACIDAD INTERRUPTIVA  A  480Vca,   PROPORCIONADO   POR   EL  PROVEEDOR  DE   PLANTA  DE EMERGENCIA), PARA OPERA EN MAXIMO 10 SEGUNDOS.  PLANTA DE EMERGENCIA 02 1 Pieza PLANTA  GENERADORA DE ENERGIA ELECTRICA PARA DE EMERGENCIA "PE-2" DE  1250KW CONTINUOS,  3F,  4H, 480/277V ,  60Hz ,  MARCA OTTOMOTORES o  EQUIVALENTE CERTIFICADA (LOS VALORES REQUERIDOS SON EFECTIVOS A 1920 m.s.n.m.). 1 Pieza EQUIPO  DE  TRANSFERENCIA   "TT-2"  AUTOMATICA CON  DOS INTERRUPTORES TIPO AUTOMATICOS (SOLO  OPERAN  COMO  DISYUNTORES) DE 3P-2500A, y BLOQUEO  MECANICO  ENTRE SI, EQUIPO  DE  MEDICION INTEGRADO, 3F-4H,  480/277V, 60Hz, Y 50 KAMP,  SIMETRICOS   DE  CAPACIDAD INTERRUPTIVA  A  480Vca,   PROPORCIONADO   POR   EL  PROVEEDOR  DE   PLANTA  DE EMERGENCIA), PARA OPERA ENTRE 11 a 15 SEGUNDOS MINIMO.  Si se requiere mas información para cotizar indiquenlo,  Quedo al pendiente, saludos. ','','CQ560','QRO','SAC408',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-17 14:08:48','ivan.martin@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-17 00:00:00','SE SOLICITA PRECIO DE LISTA PARA SUMINISTRO  DE PLANTA GENERADORA DE EMERGENCIA 500 KW  220/127 VCA 3 FASES 4 HILOS + TIERRA.  CON TANQUE DE DIESEL PARA 8 HORAS DE OPERACIÓN MARCA OTTO MOTORES: INCLUYE CASETA ACUSTICA, ESCAPE GRADO HOSPITAL ZAPATAS Y CONEXIONES NECESARIAS PARA SU CORRECTA OPERACION. CONSIDERAR FLETE Y MANIBRAS DE ENTREGA A PIE DE CAMION PARA LA CIUDAD DE HERMOSILLO, SONORA.','','CQ561','QRO','SAC409',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-17 23:20:20','rogelio.valadez@gposac.com.mx','Ventas','','','',null,'','','','','SAC410',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-17 23:23:01','rogelio.valadez@gposac.com.mx','Ventas','Elaboración diagrama en CAD (Se entregarán diagramas Genéricos, si se desea solicitar uno exacto se deberá incluir la cedula de proyectos)','','','2013-09-17 00:00:00','Favor de elaborar unifilar electrico para el proyecto de referencia (https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AitCoPIW3IZNdFRsNW43aHVlbEhUd0JhbG9FZEJTckE#gid=0)  ','','CM367','MXO','SAC411',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-18 11:05:49','rogelio.valadez@gposac.com.mx','Ventas','Elaboración diagrama en CAD (Se entregarán diagramas Genéricos, si se desea solicitar uno exacto se deberá incluir la cedula de proyectos)','','','2013-09-20 00:00:00','Raul buen día te solicito realizar unifilar eléctrico tomando en consideración la siguiente info https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AhpwtIK26_pSdFZqTU1RN0FQbXBsc2tLY2R6RkVGYUE#gid=3     ','','CM415','MXO','SAC412',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-18 16:37:50','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-09-18 00:00:00','2 contactos auxiliares para CONTACTOR DE BY PASS MOD. GMC-125 y 2 contactos auxiliares para CONTACTOR DE BY PASS DE INVERSOR MOD.GMC-100  FAVOR DE CONFIRMAR PRECIO ANTES.  OS-2069','','CM376','MXO','SAC413',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-18 18:55:00','saul.andrade@gposac.com.mx','Ventas','Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor','','','2013-09-20 00:00:00','Visita a CJF con el objetivo de explicar las bondades que tiene el Central de APC. También se debe de instalar el programa en la computadora del cliente.  Es importante llevar la dirección IP que se le puso dentro del proyecto de Climas.   Solicitud de que Roberto nos acompañe a la cita','','NA','GDA','SAC414',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-19 18:32:17','juanjose.espinoza@gposac.com.mx','Ventas','Levantamiento','','','2013-09-20 00:00:00','Me pueden apoyar con una persona para realizar una visita para el dia de mañana en INEGI patriotismo. la persona tiene qe ser eléctrico. los datos de la persona con quien se necesita poner en contacto es:  Jorge Snachez. ST Soluciones empresariales nextel. (55) 35 39 58 43','','cg350','GDA','SAC415',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-20 17:28:16','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-09-25 00:00:00','SE REQUIEREN 3 BASES PARA CAMARAS PARA CCTV MOD.SYSCOM GL605 COMO COMPLEMENTO PARA SAC394, SE SOLICITAN EN OS-4041 ENVIAR A ISEC VHS','','CM150','MXO','SAC416',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-20 17:49:08','salvador.ruvalcaba@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-10-20 00:00:00','Buen día, Favor de comprar en Syscom una lente de 1/3", varifocal de 2-6mm (aproximado, ya que varia ligeramente con cada marca) y montaje CS.  Es para el Netbotz 320 actualmente instalado pero sin la lente, ya que se daño. Gracias.  ','','Demo Room SAC Qro','QRO','SAC417',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-23 12:02:10','ivan.martin@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-09-23 00:00:00','Se solicita cedula de costos para elaboracion de cotización, para requerimientos de adecuaciones electricas de Instalacion de nuevos servidores de HDI en los SITES  de Leon e Irapuato, de acuerdo a lo visto por area de implementacion en levantamientos con cliente HDI.','','CQ565','QRO','SAC418',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-23 12:32:40','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-09-25 00:00:00','1 TARJETA PARA DISPLAY MOD. 21391-3 Y 1 MINI-VENTILADOR PARA FUENTE POWER SUPLY MARCA SUNOM MOD. KDE1204PFB2-8 CAPACIDAD DC12V 0.6 W PARA SITIO NUEVO PEMEX OS-0528 ENVIAR A ISEC VHS','','CM150','MXO','SAC419',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-23 13:43:55','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-23 00:00:00','Solicito precio de los siguientes equipos:  1 Pieza de  Impresora para tarjetas en PVC con las siguientes caracteristicas: Impresión de tarjetas de un lado o doble lado.  • Opciones de crecimiento modular.  • Diseño amigable al usuario.  • Avanzado sistema de limpiado.  • Pantalla de LCD.  • Ideal para aplicaciones de medio y alto volumen.  • Método de impresión color por sublimación y transferencia térmica en monocromático.  • Modo de impresión un solo lado o doble lado (opcional).  • Velocidad de impresión a color hasta 144 tarjetas (un solo lado), en monocromático hasta 720 tarjetas (un solo lado)  4 piezas de  Paquete de 100 tarjetas PVC delgadas, imprimibles.	  Quedo al pendiente, saludos ','','CQ556','QRO','SAC420',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-23 14:52:41','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-09-25 00:00:00','1 COMPRESOR MOD. ZP34K5E-PFV-130, SERIE 08F67D7L, 208-230 VCA, GAS R410-A, 60 Hz, 3PH PARA SITIO LOMA BONITA OS-3808, ENVIAR A CS VERACRUZ, SE ENVIA COTIZACION DE REFERENCIA','','CM122','MXO','SAC421',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-23 16:43:31','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-09-24 00:00:00','4 BATERIAS LTH 7 PLACAS 12 VCD PARA SITIO POTRERO, ENVIAR A CS VERACRUZ, ELLOS COTIZAN EN $3177 C/U OS-2808 PE-0952','','CM122','MXO','SAC422',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-23 17:56:10','jorge.martinez@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-09-24 00:00:00','Raul,  Buena tarde, de favor me puedes ayudar a validar los costos de este proyecto que es ya una adjudicacion directa con Petroleos Mexicanos  Te anexo la liga de la Cedula de Proyectos (las 26 subpartidas ahi listadas son las que vienen en el apartado tecnico de la adjudicacion): https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AhMxMe9e2jD6dFhieHZnSUh1MmtkQWtNenpTQW91Umc#gid=0  Te anexo la ultima cotizacion que recibi de el Proveedor TAMEX: https://docs.google.com/a/gposac.com.mx/file/d/0BxMxMe9e2jD6cXl2UEFOQmd4NjA/edit  Anexo la liga del apartado tecnico, en las paginas 4 y 5 vienen el listado de materiales requeridos: https://docs.google.com/a/gposac.com.mx/file/d/0BxMxMe9e2jD6cndzTERCOHl2RWc/edit Disculpa la premura pero esta adjudicacion directa se entrega el dia de mañana a las 4:00pm, por lo tanto requerimos tenerlo y subirlo antes de esa hora  Gracias por tu ayuda, quedo a tus ordenes en espera de tus comentarios, gracias  saludos','','CM388','MXO','SAC423',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-23 18:36:10','rufino.moctezuma@gposac.com.mx','Ventas','Levantamiento','','','2013-09-23 00:00:00','Se solicita apoyo para realizar un levantamiento en Norgren para el proyecto de suministro e instalación de equipo para control de acceso. Agradeceré me indiquen las fechas disponibles para cordinarlo con el usuario. Quedo al pendiente, gracias.','','CQ556','QRO','SAC424',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-24 09:51:06','berenice.martinez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-09-24 00:00:00','Buen día, solicito un contacto auxiliar  o contactos secos de un contactor, marca (cutler-hammer), modelo C320KG13, para un AA del Tar de Guaymas. Favor de enviar a Camilo Peña Franco Cs SICET. CM150. NOTA: En caso de requerir imágenes favor de solicitarlas.','','CM150','GDA','SAC425',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-25 11:46:29','ivan.martin@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-09-25 00:00:00','Se solicita cedula de costos para suministro e intalacion de tierra fisica, de acuerdo a levantamiento de personal de servicio.','','CQ568','QRO','SAC426',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-25 19:32:33','jorge.martinez@gposac.com.mx','Ventas','Pregunta técnica','','','2013-09-26 00:00:00','Mesa de Ayuda,  Buena tarde, de favor me puedes apoyar con esta consulta  en la LICITACIÓN PÚBLICA NACIONAL NO. LA-018T4I006-N105-2013 de “Mantenimiento preventivo y correctivo a los sistemas automáticos de detección y extinción de Incendio por inundación total a base de agentes químicos limpios de los Centros de Cómputo de Petróleos Mexicanos”,  Anexo Link de las bases https://docs.google.com/a/gposac.com.mx/file/d/0BxpwtIK26_pSazhYY0RYNVRQWkk/edit  El la pagina 102 en  iii. Rubro: Propuesta de Trabajo  Pide lo siguiente para la asignacion de Puntos:  - Presentar certificado (D.O.T) vigente a nombre del licitante participante para el Servicio de Trasvase y Pruebas Hidrostáticas.  De favor me pueden apoyar indicandome que es ese certificado DOT y si podemos presentar algo que lo cumpla ya que lo piden para la asignacion de puntos de este Rubro y vale 7 Puntos.  Quedo a sus ordenes en espera de su respuesta y/o comentarios, gracias  saludos','','CM370','MXO','SAC427',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-26 09:24:03','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-09-26 00:00:00','Urgente. requisición de parte No.  	FGES-150K	Kit de tierra, para Grupo Lamesa, la requieren para más tardar el martes de la semana entrante, porque tienen sus equipos de medición parados, no se que se pueda hacer en estos casos.  ','','cq568','QRO','SAC428',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-26 17:43:31','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-27 00:00:00','Me pueden apoyar con el precio de las siguientes partes de InRow APC RC:  W0W3163 Cable Assy Thermistor 8ft. W0M-61005 Turbina-ventilador','','cg457','GDA','SAC429',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-26 17:58:59','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-27 00:00:00','Buen dia me pueden apoyar con el precio del UPGRADE de un DAP III A DAP4, incluir el ZONE MASTER y la terjeta de red ETHERNET para el  DAP4.','','CG458','GDA','SAC430',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-27 18:15:00','jorge.martinez@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-09-28 00:00:00','Mesa de Ayuda,   Buena tarde, de favor me puedes apoyar con la Cedula de costos de la  LICITACIÓN PÚBLICA NACIONAL NO. LA-018T4I006-N105-2013 de “Mantenimiento preventivo y correctivo a los sistemas automáticos de detección y extinción de Incendio por inundación total a base de agentes químicos limpios de los Centros de Cómputo de Petróleos Mexicanos”,   Esta licitacion se entrega el proximo Lunes a las 10:00 am a traves de compranet   Anexo la Liga de la descripcion de mi requerimiento de precios unitarios de las 3 subpartidas de este proceso de licitacion https://docs.google.com/a/gposac.com.mx/document/d/1D7sIEbTQ4O4EDE41XbUQdLYaiPJShKa4YrGdlbye9LU/edit  Una disculpa por la premura y gracias por su apoyo  quedo a sus ordenes  saludos','','CM370','MXO','SAC431',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-27 18:44:00','rogelio.valadez@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-09-27 00:00:00','Suministro e instalación de Cable alimentacion a Carga de 15 m totales con cable Multiconductor flexible 3x10 AWG e Interruptor para desconectar carga de 30 Amps, para instalarse en MIGUEL E. SCHULTZ 140, COL. SAN RAFAEL, DELEGACION CUAUHTEMOC. No incluye Receptaculo P/ alimentar carga ni tablero.  https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AhpwtIK26_pSdHBrRWQ3MVhBMU0wTjlwZVhzSEdoblE#gid=0','','CQ423','QRO','SAC432',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-30 09:01:50','juanjose.espinoza@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-30 00:00:00','Me puedes apoyar con l precio de lo que se pidio en la requisisción  SAC404 por favor','','CG236','GDA','SAC433',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-30 13:34:55','ivan.ramirez@gposac.com.mx','Ventas','Elaboración de Plano e Imagenes 3D del SITE (se deben anexar planos del edificio y dibujos de levantamiento)','','','2013-09-30 00:00:00','Buen día en base a levantamiento realizado por personal de servicio SAC271. se requiere del apoyo para que se realice plano de sembrado para un transformador de 40kva  el levantamiento lo realizo Joel Barron ','','CM409','MXO','SAC434',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-09-30 17:13:53','julio.lara@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2014-03-20 17:05:31','JUEGO DE TRES VENTILADORES PARA MODULO DE PODER DE 10KVA''S MOD: SYM10P PARA UPS SYMMETRA PX. UBICADO EN TUXTLA GUTIÉRREZ.  HACE UN POCO DE RUIDO Y DESPUÉS SE QUITA Y REGRESA, ASI ESTA. SE CAMBIARAN EN EL PRÓXIMO MANTENIMIENTO PREVENTIVO.  NO SE ANOTO EN LA ORDEN DE SERVIO, YA NO AFECTO LA OPERACION DEL EQUIPO.  GACIAS','','CM150','MXO','SAC435',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-01 10:36:41','oscar.huerta@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-10-01 00:00:00','COMPRESOR  MARCA: AMERICAN STANDAR INC. MODELO NUMBER: AL33A-FF1-B SERIAL NUMBER: 2364MFU VOLTS: 200 - 230  AMPS: RL:13.5 LR: 8.7  NOTA: EL COMPRESOR ES PARA UNA CONDENSADORA MARCA TRANE EL MODELO DE LA CONDENSADORA ES EL 2TTB0036A100AA DE  3 T.R.   ','','CM122','MXO','SAC436',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-01 17:49:25','juanjose.espinoza@gposac.com.mx','Ventas','Levantamiento','','','2013-10-02 00:00:00','Me pueden apoyar con una persona para un levantamiento con el Ayuntamiento de GDL','','NA','GDA','SAC437',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-02 09:38:26','ivan.martin@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-10-02 00:00:00','Se requiero precio de lista para 10 piezas de cartucho de bateria modelo RBC55 MARCA APC, para  UPS APC MODELO SUA2200, no se requiere instalacion, solo suministro los equipos son del Instituto de Seguridad Social de Guanajuato.','','CQ572','QRO','SAC438',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-02 12:06:17','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-10-03 00:00:00','SOLICITO DEL APOYO PARA QUE SE PROPORCIONE EL PRECIO DE UNA TARJETA DE RED PARA UN EQUIPO GALAXY3000 SEGUN LA PAGINA DE APC EL MODELO ES EL SIGUIENTE 66074. ANEXO LINK. http://www.apc.com/products/resource/include/techspec_index.cfm?base_sku=66074&ISOCountryCode=mx&tab=features','','CM424','MXO','SAC439',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-02 17:07:07','oscar.huerta@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-10-02 00:00:00','FOLIO REPORTE DE SERVICIO: 1056 REFACCIÓN: 1 BATERÍA MARCA: DURACELL MODELO: BCI 24 VOLTAJE: 12V  CAPACIDAD: CCA 450   ','','CM122','MXO','SAC440',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-03 18:45:31','ivan.martin@gposac.com.mx','Ventas','Levantamiento','','','2013-10-07 00:00:00','Se solicita visita de levantamiento para la Caja de Ahorros de los Telefonistas en la ciudad de México, proyecto de readecuaciones del Data Center Principal para posterior elaboracion de cedula de costos, los aspectos a considerar son: 1.- Lunes 7 de Octubre Colocacion de equipos de medicion para determinar consumo real de la carga conectada al  UPS MGE de 30 kva, determinacion de la carga total de los equipos que aloja el SITE. 2.- Visita de levantamiento para ubicar trayectorias de cableado desde subestacion electrica a tablero electrico de SITE asi como trayectorias para la tuberia de los aires acondicionados a instalar. ','','CQ573','QRO','SAC441',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-03 18:49:44','ivan.martin@gposac.com.mx','Ventas','Levantamiento','','','2013-10-07 00:00:00','Se solicita levantamiento para reubicacion de AAP Inrow actualmente instalado en la planta Tetrapak Izcalli, para ser instalado en Tetrapak Antara Polanco, considerar todo lo necesario para este movimiento: maniobras, cableado electrico, canalizacion de ductos de aire, posterior elaboracion de cedula de costos. los accesos se podran coordinar con Jorge Rivera, Jorge Aguilar y un servidor. ','','CQ574','QRO','SAC442',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-04 15:05:58','rufino.moctezuma@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-09-04 00:00:00','Raul, buenas tardes.  Solicito por favor precio de los siguietes equipos: 2 Piezas de: PLANTA    GENERADORA    DE    ENERGIA    ELECTRICA  SISTEMA   DE     EMERGENCIA     (PE-01), (PE-02),   PARA EL SISTEMA   ELECTRICO   ESCENCIAL   DE   1000kW/1250kVA,  SISTEMA   CONTINUO,  GRADO  HOSPITAL  CON 10%  DE  SOBRE   CARGA   PARA   2  HORAS  3F-4H+PT,   480/277V,  60Hz, F.P=0.80,  CON  INTERRUPTOR  DE 3P-1600A   AL   PIE   DEL   GENERADOR   MARCA   OTTOMOTORES,   IGSA  O  SELMEC   (LOS   VALORES REQUERIDOS    SON   EFECTIVOS   A  521 m.s.n.m.)  CON   BASE   TANQUE INTEGRADO CON CAPACIDAD DE 2 000 lts CON UN  NIVEL DE  RUIDO  = 77 dB  A  10m, (PESO = 11 462kg),  CLASE = 24  Hrs, LOS  365  DIAS  DEL  AÑO  TIPO = 10 SEGUNDOS, NIVEL 1 (SEGURIDAD DE VIDA) DE ACUERDO A LA NFPA110 VIGENTE.	 1 Pieza de  EQUIPO  DE  TRANSFERENCIA  (TT-01)  AUTOMATICA  EN  BAJA TENSION   CON  TRANSICION  CERRADA DE RAMPA  SUAVE  TIPO  AUTOSOPORTADO  CON  DOS  CONTACTORES  O DISYUNTORES   TIPO  ASCO  DE  3P-700A  BLOQUEO   Y  EQUIPO  DE MEDICION  INTEGRADO,  BARRAS   COLECTORAS   DE  800A,   3F-4H+PT   480/277V,   60Hz  Y 50kA,  SIMETRICOS  DE   CAPACIDAD    INTERRUPTIVA  A  480V,  PROPORCIONADO   POR   EL PROVEEDOR DE LA PLANTA GENERADORA DE ENERGIA ELECTRICA (CARGA PLENA EN 10 seg.)	EQUIPO  DE  TRANSFERENCIA  (TT-01)  AUTOMATICA  EN  BAJA TENSION   CON  TRANSICION  CERRADA DE RAMPA  SUAVE  TIPO  AUTOSOPORTADO  CON  DOS  CONTACTORES  O DISYUNTORES   TIPO  ASCO  DE  3P-700A  BLOQUEO   Y  EQUIPO  DE MEDICION  INTEGRADO,  BARRAS   COLECTORAS   DE  800A,   3F-4H+PT   480/277V,   60Hz  Y 50kA,  SIMETRICOS  DE   CAPACIDAD    INTERRUPTIVA  A  480V,  PROPORCIONADO   POR   EL PROVEEDOR DE LA PLANTA GENERADORA DE ENERGIA ELECTRICA (CARGA PLENA EN 10 seg.) 1 pieza de EQUIPO DE TRANSFERENCIA  (TT-SV)    AUTOMATICA  EN   BAJA TENSION  CON  TRANSICION  CERRADA DE  RAMPA  SUAVE  COLOCADO   EN   MURO   CON  DOS CONTACTORES O  DISYUNTORES  TIPO  ASCO  DE  3P-125A Y  EQUIPO  DE  MEDICION   INTEGRADO,  BARRAS   COLECTORAS  DE  225A ,   3F-4H+PT,   480/277V,  60Hz   Y  50kA,    SIMETRICOS    DE    CAPACIDAD    INTERRUPTIVA    A    480V,    PROPORCIONADO   POR   EL PROVEEDOR DE LA PLANTA GENERADORA DE ENERGIA ELECTRICA (CARGA PLENA EN 10 seg.)	EQUIPO DE TRANSFERENCIA  (TT-SV)    AUTOMATICA  EN   BAJA TENSION  CON  TRANSICION  CERRADA DE  RAMPA  SUAVE  COLOCADO   EN   MURO   CON  DOS CONTACTORES O  DISYUNTORES  TIPO  ASCO  DE  3P-125A Y  EQUIPO  DE  MEDICION   INTEGRADO,  BARRAS   COLECTORAS  DE  225A ,   3F-4H+PT,   480/277V,  60Hz   Y  50kA,    SIMETRICOS    DE    CAPACIDAD    INTERRUPTIVA    A    480V,    PROPORCIONADO   POR   EL PROVEEDOR DE LA PLANTA GENERADORA DE ENERGIA ELECTRICA (CARGA PLENA EN 10 seg.) 1 pieza de EQUIPO DE TRANSFERENCIA  (TT-TR)  AUTOMATICA  EN  BAJA  TENSION   CON  TRANSICION   CERRADA DE RAMPA   SUAVE   TIPO    AUTOSOPORTADO  CON   DOS   CONTACTORES  O   DISYUNTORES  TIPO ASCO DE   3P-500A  Y   EQUIPO    DE    MEDICION    INTEGRADO,    BARRAS    COLECTORAS    DE   600A   3F-4H+PT,  480/277V, 60Hz  Y  50kA SIMETRICOS    DE  CAPACIDAD  INTERRUPTIVA  A  480V,  PROPORCIONADO POR  EL PROVEEDOR DE LA PLANTA GENERADORA DE ENERGIA ELECTRICA (CARGA PLENA EN 10 seg.)	EQUIPO DE TRANSFERENCIA  (TT-TR)  AUTOMATICA  EN  BAJA  TENSION   CON  TRANSICION   CERRADA DE RAMPA   SUAVE   TIPO    AUTOSOPORTADO  CON   DOS   CONTACTORES  O   DISYUNTORES  TIPO ASCO DE   3P-500A  Y   EQUIPO    DE    MEDICION    INTEGRADO,    BARRAS    COLECTORAS    DE   600A   3F-4H+PT,  480/277V, 60Hz  Y  50kA SIMETRICOS    DE  CAPACIDAD  INTERRUPTIVA  A  480V,  PROPORCIONADO POR  EL PROVEEDOR DE LA PLANTA GENERADORA DE ENERGIA ELECTRICA (CARGA PLENA EN 10 seg.) 1 pieza de  EQUIPO  DE  TRANSFERENCIA (TT-03) AUTOMATICA EN BAJA TENSION CON  TRANSICION  CERRADA  DE RAMPA SUAVE CON DOS CONTACTORES  O  DISYUNTORES   TIPO  ASCO  DE  3P-1600/1600A  Y  EQUIPO  DE   MEDICION INTEGRADO, BARRAS COLECTORAS  DE  1600A, 3F-4H+PT, 480/ 277V, 60Hz  y  50kA,  SIMETRICOS DE CAPACIDAD INTERRUPTIVA A 480V PROPORCIONADO POR  EL PROVEEDOR  DE  PLANTA GENERADORA  DE  ENERGIA  ELECTRICA,  PARA  OPERAR  EN UN  INTERVALO DE 11 A 15seg.	EQUIPO  DE  TRANSFERENCIA (TT-03) AUTOMATICA EN BAJA TENSION CON  TRANSICION  CERRADA  DE RAMPA SUAVE CON DOS CONTACTORES  O  DISYUNTORES   TIPO  ASCO  DE  3P-1600/1600A  Y  EQUIPO  DE   MEDICION INTEGRADO, BARRAS COLECTORAS  DE  1600A, 3F-4H+PT, 480/ 277V, 60Hz  y  50kA,  SIMETRICOS DE CAPACIDAD INTERRUPTIVA A 480V PROPORCIONADO POR  EL PROVEEDOR  DE  PLANTA GENERADORA  DE  ENERGIA  ELECTRICA,  PARA  OPERAR  EN UN  INTERVALO DE 11 A 15seg.  Listados en la cedula CQ575 y que te eh compartido. En cuanto se reciban los planos unifilares y de trayectorias se solicitara la instalación  Quedo al pendiente, saludos.','','cq575','GDA','SAC443',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-04 17:11:51','ivan.martin@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-10-10 00:00:00','Del levantamiento realizado en la REQUISICION SAC441, se solicita apoyo para realizacion de cedula de costos para cotizar las instalaciones de los siguientes equipos: UPS, AAP, SISTEMA DE DETECCION Y SUPRESION DE FUEGO AUTOMATICO, CONTROL DE ACCESO, MONITOREO AMBIENTAL, ADECUACIONES DE OBRA, en la siguiente liga se estara subiendo la informacion que el cliente nos proporcione, si requieren algo mas de informacion solicitarla para pedirla al cliente.  https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0BwX_iTthtvk2cVlfYlNQUnNxSVU','','CQ573','QRO','SAC444',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-04 17:28:53','ivan.martin@gposac.com.mx','Ventas','Levantamiento','','','2013-10-09 00:00:00','Se solicita apoyo de Ingeniero de servicio para levantamiento en Arneses Electricos Automotrices en Silao, Guanajuato, actualmente es cliente con poliza de servicio vigente, pretenden reubicar el SITE por cambios en la planta, la visita del ingeniero de servicio se realizara junto con el consultor, confirmar la fecha solicitada 9 OCTUBRE 2013 o proporcionar una para validar con el cliente.','','CQ576','QRO','SAC445',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-07 11:24:20','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-09-07 00:00:00','Raúl, buenos días.  Adicional a la solicitud de cotización de las plantas de emergencia para Tradeco, el cliente solicita también que adicionemos caseta acústica para las plantas y la instalación de las mismas, te eh compartido los archivos de los diagramas unifilares que envía el cliente, la instalación se realizara en Ciudad de Villa Alvarez, Colima. Si requieres mas información para cotizar la instalación de las plantas comentame, quedo al pendiente. Saludos','','CQ575','QRO','SAC446',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-08 09:18:31','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-10-08 00:00:00','ORDEN DE SERVICIO OS-3241  ventilador de una condensadora Marca: Liebert Modelo: HBA049.0366 Serie U200200055  El centro de servicio cotizo en Emerson:  De: Marcos.Nochebuena@Emerson.com [mailto:Marcos.Nochebuena@Emerson.com] Enviado el: lunes, 17 de junio de 2013 02:25 p. m. Para: ing.hectorsaulh@hotmail.com Asunto: RE: motor-ventilador   Este es el precio con factura del ventilador.  PRECIO UNITARIO USD 992.52,  TIEMPO DE ENTREGA 4-6 semanas  LUGAR DE ENTREGA  MONTERREY, NUEVO LEON','','CM150','GDA','SAC447',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-08 11:16:31','ivan.martin@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-10-10 00:00:00','Se solicita precio de una tarjeta de control para AAP Liebert Modelo BU067A-CAE118125, con numero de serie N08K740015, el cliente indica que esta tarjeta esta dañada, requiere solo el suministro, se envia correo electronico a mesa de ayuda con las imagenes de la tarjeta dañada y los datos de placa del equipo.','','CQ579','QRO','SAC448',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-08 13:59:56','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-10-08 00:00:00','2 HUMIDIFICADORES PARA EQUIPOS AIRES ACONDICIONADOS CADEREYTA','','CM150','QRO','SAC449',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-08 18:33:19','ivan.martin@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-10-12 00:00:00','Se solicita precio para banco de baterias Niquel Cadmino para UPS 1100 de 30 kva, el tiempo de respaldo debe calcularse para 2 horas a una carga de 25kva, considerar todo lo necesario para el banco de baterias, tornilleria, cables, gabinete, el equipo sera instalado en Poza Rica Veracruz.','','CQ580','QRO','SAC450',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-09 10:44:14','ivan.ramirez@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-10-09 00:00:00','Hola solicito del apoyo para que se pueda dar precio de la configuración e instalación de un equipo Netbotz NBWL0355 y los siguientes accesorios favor de contemplar una distancia standar AP9324 NBES0301 AP7921   https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AobMHo1P0jzedGhDM1RjeGpZUk90Y1JKNk90N2hfQ2c&usp=sharing','','CM430','MXO','SAC451',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-09 15:58:50','liliana.diaz@gposac.com.mx','Ventas','Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio','','','2013-10-09 00:00:00','solicito  costo   de  una tarjeta de System ID para un equipo   SYMMETRA PX STATIC SWITCH MODULE, 208V de 40k','','CM422','MXO','SAC452',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-09 16:13:05','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-10-15 00:00:00','2 CONTACTORES TRIFASICOS SIEMENS NO.42BF35AJAYF BOBINA 24V 40A PARA SITIO NUEVO PEMEX, ENVIAR A ISEC VHS, ES UNA RECOMENDACION','','CM150','MXO','SAC453',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-09 16:55:56','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-10-09 00:00:00','Se solicita lente para cámara pelco, ya que el que tenia la otra cámara no funciono, asi como base de la misma para poder instalarla de acuerdo a Orden de servicio OS-0735. La cámara que se compro para la requisición principal fue la SAC283 	(Cámara Pelco, modelo PCM100, para equipo CCTV marca Averdigi, modelo EH5216H, (TAR Cadereyta))','','CM150','QRO','SAC454',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-10 10:23:19','ivan.ramirez@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-10-10 00:00:00','se requiere de la realización de cédula de costos para la instalación de un equipo de aire inrow ACSC100 MARCA APC CONSIDERAR UNA DISTANCIA DE 10M DEL TABLERO DE ALIMENTACIÓN AL EQUIPO DE AIRE Y UNA ALTURA DE PISO A FALSO PLAFON DE 220 METROS Y DE FALSO PLAFON A TECHO DE CONCRETO DE 90CM. LA DISTANCIA QUE HABRA QUE RECORRER PARA COLOCAR EL EQUIPO DEL AREA DE DESCARGA EN SITIO SERA DE 12M. (POR REQUERIMENTOS DEL CLIENTE SE TENDRÁ QUE PERFORAR EL TECHO DE CONCRETO PARA SACAR LOS DOCTOS DEL AIRE )  https://docs.google.com/a/gposac.com.mx/spreadsheet/ccc?key=0AobMHo1P0jzedHdJTEZHVHVJb0xwcUlkTmRBQXAxSGc&usp=sharing','','CM431','MXO','SAC455',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-10 10:55:53','ivan.martin@gposac.com.mx','Gerentes al Area de Compras','','','','2013-10-11 00:00:00','Se solicita compra de laptop con el proveedor CVA (COMERCIALIZADORA DE VALOR AGREGADO), codigo de producto NOT-2436, el articulo esta disponible en la ciudad de Guadalajara, este equipo es para reponer el que fue robado a Ivan Martin el dia 9 de octubre de 2013 en Silao, favor de enviar equipo a la ciudad de Queretaro a la brevedad.','Requerimiento de Compra de Activos','NA','QRO','SAC456',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-10 11:41:26','rufino.moctezuma@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-10-10 00:00:00','Raul,  Solicito cédula de costos para la instalación de 3 plantas de emergencia y un UPS, las capacidades de las plantas es: 60, 150 y 500 KW, el UPS es un Mitsubishi 1100 de 20 KVA, te comparto diagramas unifilares  enviados por el cliente. Solicito precio de un Cargador de Baterias grado industrial, rectificador de 6 o 12 pulsos (IGBT) o tiristores (SCR´s), puertos de comunicación serial y ethernet,  3F,60 Hz., Capacidad (KVA), 90AH, para ser usado en un Banco de Baterías de 90Ah de capacidad  ','','CQ582','QRO','SAC457',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-10 18:01:47','angeles.avila@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-10-10 00:00:00','Solicito 4 ventiladores para módulos de poder para Saltillo y Cd. Victoria. NOTA: Por el momento no cuento con las ordenes de servicio en cuanto me las hagan llegar se las envio.  Anexo dos proveedores para realizar la compra:  http://www.futureelectronics.com/en/Technologies/Product.aspx?ProductID=AD1224UBF51ADDA9014221&IM=0  Saludos!!','','CM150','QRO','SAC458',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-11 09:35:33','berenice.martinez@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-10-11 00:00:00','SE SOLICITA DISPLAY MODULE FOR APC SILCON, MODELO: WOG-0901175. PARA TAR AMERICAS. CM150','','CM150','GDA','SAC459',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-11 19:52:56','rufino.moctezuma@gposac.com.mx','Ventas','Pregunta técnica','','','2013-10-11 00:00:00','QUE MODELO DE PLANTA DA 1000 KW EFECTIVOS A 521 MTS, ALTURA DE LA CUIDAD DE COLIMA  Saludos','','CQ443','QRO','SAC460',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-15 17:43:44','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-10-16 00:00:00','3 ventiladores para el condensador modelo: PF4820070HB2M 1 ventilador para el evaporador Num. de parte: 490-0079B  PARA MOTOROLA, SITIO VILLAHERMOSA, EQUIPO EN GARANTIA  EL PERSONAL ESTÁ EN SITIO POR LO QUE URGE SE ENVIEN REFACCIONES AL SITIO','','MX11-0026','MXO','SAC461',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-15 18:17:43','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2013-10-20 00:00:00','6 VENTILADORES para dos módulos de potencia Marca NIDEC BETA V MODELO B33534 24VDC, 0.45Amp NO. DE PARTE 932000 CON GIRO CW UPS-2569.  EN EL REQUERIMIENTO SAC295 SE SUMNISTRARON 3 PERO SE DEVOLVIERON PORQUE EL CS DIJO QUE NO SIRVIERON.  ENVIAR A ISEC VHS','','CM150','MXO','SAC462',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-16 09:32:18','claudia.rivera@gposac.com.mx','Otros','','','COMPUTADORA','2013-10-21 00:00:00','1 COMPUTADORA PARA PERSONAL NUEVO, AUXILIAR DE OFICINA.','Requerimiento de Compra de Activos','GASTO FIJO','MXO','SAC463',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-16 10:02:58','ivan.ramirez@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-10-17 00:00:00','Se requiere de la cedula de costos para determinar precio e instalacion de un ventilador modelo  A30135-89 marca Nidec Alpha, 230volts  50/60, este ventilador se instalara en un equipo marca: APC mod. SYMINF de 4KVa. anexo link del ventilador http://www.nidecamerica.com/fanpdfs/ta450ac.pdf','','cm426','MXO','SAC464',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-16 12:03:58','jorge.martinez@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-10-16 00:00:00','Mesa de Ayuda,  Buen dia, de favor me pueden apoyar con una Cedula de costos para la reubicacion de una condensadora Marca DATA AIRE de 20TR expansion Directa,  La condensadora actualmente esta en operacion en la planta baja en un patio a una distancia de 15 mts del equipo de Aire que se ubica dentro del Site (este tambien en planta baja),   La nueva ubicacion es a 11mts de la actual en el mismo patio, esta condensadora se alimenta a 220V y la alimentacion electrica viene de donde se encuentra ubicado el Equipo de Aire en el SITE,  El motivo de la Reubicacion es porque ese espacio se utilizara para una escalera de emergencia que les solicita proteccion Civil.  Los alcances son: - En el site se cuenta con otro equipo de 13 TR Marca Data Aire el cual operara mientras el de 20 TR esta fuera de operacion, por lo cual piden que consideremos proveer al momento de la reubicacion, el suministrar 10TR en equipos tipo pinguino o los que consideremos adecuados.  - La instalacion hidraulica y electrica se deberea colocar antes de realizar el movimiento para solo conectar al momento de la reubicacion,  - En los trabajos se incluye Apagado del equipo, desconexion de la condensadora, desmontaje, traslado o arrastre a la nueva ubicacion y fijacion tanto de la condensadora como de una malla de proteccion con la que actualmente cuenta el equipo, - Despues de la colocacion en el nuevo sitio se deberan realizar los remates tanto de la parte electrica como hidraulica, arranque del equipo y suministro de gas refrigerante en caso de requerirse,  El trabajo se realizaria por la noche.  - NOTA: se debe considerar que el equipo de Aire actual mente esta en poliza de mantenimiento con E&T Solutions, para determinar si nosotros realizaremos los el apagado y arranque o se delegara a los encargados de la poliza,  - Esta poliza finaliza a mediados del proximo mes, pero ellos quieren eralizar estos trabajos en unos 15 dias, por lo tanto todavia estarian dentro de la contrato de mantenimiento.  en el correo que me llega de esta Requisicion anexare 2 fotos y el croquis del levantamiento,  quedo a sus ordenes para cualquier comentario y/o duda, gracias  saludos','','CM436','MXO','SAC465',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-16 13:07:46','jorge.martinez@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-10-17 00:00:00',' Mesa de Ayuda Buena tarde,  De favor me puedes cotizar el suministro y la instalacion de un banco de 30 baterías   Con los sig datos: Baterías marca  Mastersafe, modelo MS12180, Sellada libre de mantenimiento , plomo-Acido, 12V, 18 AH  (o similares que cumplan con la capacidad en Volts y AH, esta capacidad no la tenemos en lista de precios)  Es para un UPS Marca Mitsuishi de 20Kva, Monolitico  Alcances de la cotizacion: - Apagado y arranque del UPS (este UPS esta en contrato de mantenimiento con E&T Solutions, detreminar si el aparago y arranque lo realizamos o se delega a los encargados del contrato) - Suministro e instalacion de baterias nuevas - Desconexion y retiro de las usadas - Confinamiento y traslado de baterias usadas a un Centro de reciclaje autorizado por la SEMARNAT  - La ubicacion del UPS es cerca de la Central de Abastos de Iztapalapa y el cliente final es Farmacias de Similares,  quedo a sus ordenes para cualquier comentario y/o duda, gracias  saludos','','CM437','MXO','SAC466',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-16 16:18:25','claudia.rivera@gposac.com.mx','Implementación y Servicio','','Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)','','2014-03-20 17:05:34','1 DONA DE INDUCCION MARCA ICIX 400 MODELO HC-TF400V4812 F11057 PARA REALIZAR PRUEBAS EN EQUIPO SOBRE EL DISPLAY PARA TERMINAL DOS BOCAS, PARAISO OS-0484 ENVIAR A ISEC VHS','','CM150','MXO','SAC467',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-16 18:29:51','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-10-21 00:00:00','Buen dia. Me pueden apoyar por favor con los precios de los servicios para la licitación de limpieza de site emitido por "CFE". En la liga anexo toda la información necesaria, así como un archivo con precios proporcionados por un proveedor para que los tomen en cuenta o puedan negociarlos.  https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0B2jQgfvQJ9a0OW5iaXBxcHZ1eWs','','CG433','GDA','',null,'','','','','');
insert into `bloomTransferTicket`(`created`,`createdByUsr`,`applicantArea`,`serviceType`,`serviceTypeSS`,`serviceTypeGeneral`,`dueDate`,`description`,`serviceTypeManager`,`project`,`office`,`ticketNumber`,`responseDate`,`responseInTime`,`evaluation`,`responseInHours`,`desviation`,`observations`) values ('2013-10-16 18:29:52','juanjose.espinoza@gposac.com.mx','Ventas','Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)','','','2013-10-21 00:00:00','Buen dia. Me pueden apoyar por favor con los precios de los servicios para la licitación de limpieza de site emitido por "CFE". En la liga anexo toda la información necesaria, así como un archivo con precios proporcionados por un proveedor para que los tomen en cuenta o puedan negociarlos.  https://drive.google.com/a/gposac.com.mx/?tab=mo#folders/0B2jQgfvQJ9a0OW5iaXBxcHZ1eWs','','CG433','GDA','SAC469',null,'','','','','');

insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC1','13/03/13',' Solicitar levantamiento realizado para tenerlos de respaldo y la realizacion del mismo ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC1','13/03/13',' YA SE SOLICITO EL LEVANTAMIENTO PARA COMPLETAR BASE DE DATOS ESPERANDO RESPUESTA...');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC1','14/03/13',' Juan Pablo comenta que dicho levantamiento no sirvio de nada, comenta que fue una hoja de papel que se quedo ivan ramires consultor de la cuenta BAXTER. La unica informacion sobre el levantamiento es la cedula de proyectos siguiente: 4-VE-05 CEDULA DE PROYECTOS BAXTER CM168');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC2','13/03/13',' Se le hablara por telefono si se entrego cedula de costos y de que era. Compartirla para respaldo. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC2','13/03/13',' YA SE SOLICITO LA CEDULA DE COSTOS ESPERANDO INFORMACION PARA COMPLETAR LA BASE DE DATOS... ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC2','25/03/13',' Se hablo por telefono a Ivan Ramirez y me comento que dicha requerimiento fue cerrado solo se esta en espera de la informacion para tener todos los antecedentes.  ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC3','13/03/13',' Hablar a Joel y a Rogelio confirmar precio. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC3','13/03/13',' YA SE SOLICITO EL PRECIO DEL MANTENIEMIENTO ESPERANDO INFORMACION... ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC5','13/03/13',' Pedirle que me comparta la cedula de proyectos. Verificar con Joel si aprobo dicha cedula. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC5','14/03/13',' SE SOLICITO INFORMACION A JORGE MARTINEZ POR CORREO ESPERANDO RESPUESTA... ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC5','21/03/13',' Se le marco Jorge Martinez y me comento que ya se aprobo pero no como un proyecto ya que no te tocaban la tres lineas de los servicios que proporciona Grupo Sac. Y que el numero de cotizacion es CM302 y se aprobo como venta.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC6','13/03/13',' Checar con rufino o Angeles para saber quien realizo el levantamiento. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC6','14/03/13',' Se le pregunto a rufino e informo la persona que tenia la infomacion. SE ENVIO LA SOLICITUD A JOSUE RAMIREZ VIA CORREO ING. DE SOPORTE ESPERANDO INFORMACION...Se tienen los datos del cliente asi como recivos de CFE y se dejo en espera dicho proyecto por falta de presupuesto del cliente.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC7','13/03/13',' Falta que Jorge comparta las especificaciones. Y que Joel confirme el resultado. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC7','14/03/13',' SE SOLICITO INFORMACION A JOE VIA CORREO ESPERANDO RESPUESTA...  Se realizo un estudio de parte de rogelio valadez de la validez del proyeto y se llego a la conclusion junto con joel paz la conclusion fue que si se entraria a la licitacion y se le hizo la cotizacion al cliente con numero CM290 en la actualidad esta en proceso la licitacion.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC8','13/03/13',' Se mando cotizacion y se respondio la cotizacion. Solicitar a Jorge esos precios para la base de datos. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC8','14/03/13',' SE HIZO LA SOLICITUD DE COTIZACION A JORGE CHAVEZ VIA CORREO ESPERANDO RESPUESTA... Se recibio la cedula de costos con la siguiente informacion:  CAT NO: KD3400LDESCRIPTION:  INT.TERMOMAGNETICO 3P. 400A(F) PRICE:  $ 1,280 USD + IVA LEAD TIME:   UNA A DOS SEMANAS                    CAT NO: HLDDC3600DESCRIPTION  HLDDC BKR 3PE 600A THERMAL-MAG 600VDC W/ LINE & LOAD terms  PRICE  :  $  5,810.00 USD LEAD TIME:   6 A 7 SEMANAS');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC9','14/03/13',' SE LES PIDIO LA INFORMACION DEL LEVANTAMIENTO, Y LA PERSONA ASIGNADA PARA REALIZARLO A ROGELIO Y CARLOS HERNANDEZ ESPERANDO RESPUESTA...');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC9','21/03/13',' Se hablo con carlos hernandes y este requerimiento no fue un levantamiento como tal si no una atencion a la falla de equipo donde finalmente al cliente se le cambio el display y se suministro el cable UTP categoria 5E (6 m) como informacion se tiene el correo del Ing Julio Lara para la cordinadora Claudia. Hubo algunas inconsistencias con el cliente pero ya quedo solucionado todo.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC10','14/03/13',' SE LE PIDIO LA CEDULA DE COSTOS A JUAN JOSE VIA EMAIL ESPERANDO RESPUESTA...  Respuesta enviada me comenta que los ing. de soporte son los que tienen esta informacion y que no saben quien genero la cedula de costos. Se le pregunto a Juan Jose y comento que luis tendria informacion al respecto.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC11','14/03/13',' SE ENVIO A ROBERTO VIA EMAIL UNA RETROLIMENTACION DE LA CEDULA DE COSTOS ESPERANDO INFORMACION...La solucion fue que se sugirio un protocolo Modbus de RTU a TC-IP con su fuente de aliemntacion. Y se le cotizo con un precio de $1600 USD');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC12','04/04/13',' Se le pregunto a Ivan Martin y comento que el requerimiento estaba cerrado y que el Ing, Luis Andrade le ayudo a generar tal cotizacion');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC13','4/04/20','13 Me como comento Ivan Martin que el requerimiento ya esta cerrado el Ing salvador colaboro a la generacion de la cedula de costos.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC14','20/03/13',' Se le marco a jorge Martinez el cual me informo que no se necesitaron los planos en cad si no las especifiaciones de los equipos para cotizarlos. La cedula de costos la esta generando Jorge martinez y la presentara este lunes 25 de Marzo a los clientes para informarles de la forma de trabajo.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC15','22/03/13',' Ya se realizo la cotizacion con base al levantamiento que realizo el Ing. Josue Ramirez pero se detuvo por falta del presupuesto del cliente que da en espera solo la informacion que se obtuvo de dicho levantamiento con rufino. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC16','22/03/13',' Se canse lo la realizacion de la cedula de costos porque el cliente se equivoco al realizar su pedidi de equipo, no necesitaba e UPS Mitsu de 50 KVA si no uno de menor capacidad, es por eso que se canselo dicha requisicion. Ademas que se le hizo una visita al cliente y se llego a esa conclusion. solo queda en espera la informacion que proporcionara rufino del la requisicion.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC17','20/03/13',' Se le llamo a Jorge Martinez el cual indica que se realizo el levantamiento por el Ing. Julio Lara y con esa informacion proporcionada por el Ing., el realizo la cedula de costos quedando pendiente de su parte darme el No. de servicio y el No. de proyecto (Cotizacion). Ademas que no pudo acudir Jorge mastinez a cita porque no se encontraba en citio. Solo acudio a la cita el Ing. Julio Lara.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC18','25/03/13',' Me comento que la persona encargada para realizar el levantamiento ya estaba predeterminada pero el cliente al final no tuvo la disponibilidad para que se realizara el levantamiento.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC19','21/03/13',' El cliente cambio la fecha de visita para otro dia, se tiene que esperar a que el cliente confirme el dia que se llevara a cavo el levantamiento... Esta pendiente Carlos Hernandez');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC20','20/03/13',' La informacion que necesito Jorge Martinez para generar la cedula de costos fue proporcionada por el Ing. Joel paz la cual venia en la lista de precios compartida en drive. El pro yecto generado en el programa comercial fue CM48');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC21','20/03/13',' El Ing. Julio Lara asistio a realizar el levantamiento la informacion del levantamiento se la transmitio a Jorge Martinez y el mando cotizar las parte a Jorge Chavez, cuando se obtubieron los precios se le enviaron a Jorge Martinez donde le puso el siguiente numero de proyecto: CM161');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC22','25/03/13',' Me comento Juan Jose que el mismo verifico en la lista de precios por asesoramiento del Ing. Salvador solo esta en espera de que me entrege la informacion via correo electronico para validacion.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC23','21/03/13',' Se acudio a la cita pero el consultor no pudo asistir, la persona que acudio a la cita fue el Ing. Jose luis Esteva el cual realizo un levantamiento pero no le ha proporcionado la informacion a Carlos Hernandez para que el le de respuesta al cliente, el Ing ahora se encuenta en Nayarit y se hablara con el el lunes ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC23','25/03/13',' para que envie informacion a Carlos');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC24','25/03/13',' Se realizo la cotizacion por medio de Jorge Chavez quien le solicito al provedor el precio del motor nuevo solo queda en espera la informacion sobbre el precio que le poporciono Jorge Chavez para tenerlo en la bitacore de refacciones.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC25','25/03/13',' Se le mando cotizar a Jorge Chavez las partes y la mano de obra la cotizo un subcontratista externo Camilo Peña de Culiacan solo hace falta que Juan Jose Espinoza me mande la informacion relevante del requerimiento. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC26','20/03/13',' La persona que brindo el soporte tecnico a este requerimiento fue el Ing. Joel Paz  el cual fue lidereado por Rogelio Valadez se le asigno el numero de proyecto CM153');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC27','14/03/13',' El ingeniero salvador cotizo la subestacion dandole el provedor la siguiente informacion:  01 Pz    Transformador trifasico tipo pedestal de alta eficiencia. Uso en red electrica subterranea. Operacion Radial. Potencia: 500 KVA. Voltaje primario: 23000 V en conexion Delta. Voltaje secundario: 480/277 V en conexion Estrella. Demas caracteristicas y accesorios de acuerdo a las normas NMX-J-285. Incluye certificacion ANCE. Mca. RTE    $ 185,484.00 M.N. + IVA    entrega 5 semanas    flete gratis!    excelente calidad    2 años de garantia ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC27','19/03/13',' Pregunto jorge martinez si la instalacion de dicho equipo lo hacia el provedor y se le comento que no lo realizava que debia buscar otro provedor para realizar maniobra cerrandose asi el requerimiento');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC28','22/03/13',' Se obsevo que dicho equipo se encontraba descontinuado y ademas no existia e lista de pecio, por lo tanto el Ing Salvador Ruvalcaba sugirio el modelo 7011 el cual esta en existencia y tambien en la lista de precios. Las fuentes fueron cotizadas por Miguel Garcia');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC29','22/03/13',' El precio de las partes los solicito miguel garcia solo esta en espera que Rufino comparta la informacion para tener antecedentes de dicha requisicion. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC30','21/03/13',' Se mando al Ing. Joel Paz a dicho levantamiento inicialmente el cliente tenia como numero de proyecto CM291 y  despues se cambio a CM153 se realizo una cedula de costos y se le presento al cliente. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC31','21/03/13',' Se acudio a la visita el mismo dia que se solicito el levantamiento la persona asignada para realizar el levantamiento fue el Ing. Oscar Huerta solo quedo pensiente por parte de Jorge Martinez el numero de Orden y el numero de cotizacion.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC32','22/03/13',' La cotizacion se realizo sin problemas por parte de Jorge Chavez solo queda pendiente que rufino conparta los antecedentes del requerimiento.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC33','21/03/13',' Se acudio al levantamiento, la persona que acudio a la cita fue el Ing. Jose luis Esteva  pero aun no ha proporcionado la informacion a Carlos Hernandez para que el le de respuesta al cliente, el Ing ahora se encuenta en Nayarit y se hablara con el el lunes ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC33','25/03/13',' para que envie informacion a Carlos ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC33','04/04/13',' El Ing. Jose Luis envio un informe de lo que necesitaba Carlos para que lo aprobara, el Ing Salvador hizo unas observaciones al reporte y se estan corrigiendo para nueva aprovacion.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC34','25/03/13',' Se le marco a ivan ramiraz y comento que ya fue generada la cedula de costos con informacion proporcionada por el Ing. Joel Paz y con ayuda de jorge chavez solo estamos en espera de que ivan martinez nos facilite la informacion del procedimiento que siguio para solicitar informacion.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC36','25/03/13',' Ivan Martinez comenta que este requerimiento ya esta cerrado y que no aparecio su descricion del requerimiento  el cual volvio a generar un correo donde volvio a describir lo que necesitaba, dicho correo estaremos en espera para poder tener mas informcaion de este requerimiento.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC37','14/03/13',' El ingeniero salvador comento que necesitabamos el modelo del equipo, el es me lo dijo es: sypm10kf tambien menciono que este equipo se encuentra en la lista de precios. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC37','19/03/13',' Se le envio un correo preguntandole a juan jose si ya se le habia proporcionado cierta informacion...');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC37','25/03/13',' Juan Jose saco el costo de la parte en la lista de precios.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC38','14/03/13',' El ingeniero salvador comento que necesitabamos el modelo del equipo, el es me lo dijo es: SYBT4 tambien menciono que este equipo se encuentra en la lista de precios. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC38','19/03/13',' Se le envio un correo preguntandole a juan jose si ya se le habia proporcionado cierta informacion... Juan Jose Espinoza saco el costo de la lista esperando envie la informacion via e-mail');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC39','14/03/13',' El ingeniero salvador comento que todo lo que esta solicitando Juan Jose se encuetra en lista de precios, ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC39','19/03/13',' Se le pregunto a Juan Jose si ya se hizo la consulta de los precios en la lista... Juan Jose Espinoza saco el costo de la lista esperando envie la informacion via e-mail');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC40','25/03/13',' Me comento Ivan Ramirez que el mismo contacto al provedor de las partes que solicito y por via telefonica adquirio el precio y de la mano de obra lo vio con rogelio valadez y con la reseña de un consultor que trabajaba en grupo sac anteriormente. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC41','25/03/13',' Se cotizo con base a un requerimiento similar solo esta en espera la cedula para archivarla.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC42','25/03/13',' Me comento Ivan Martinez que el envio la cotizacion a Jorge Chavez y recivio la contestaciona a la brevedad.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC43','21/03/13',' Esta refaccion se tenia en stock y fue enviada al cliente por Jorge Chavez y Miguel Garcia el cliente ya tiene el equipo.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC45','25/03/13',' Me comento Ivan Martinez que el envio la cotizacion a Jorge Chavez y recivio la contestaciona a la brevedad.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC46','20/03/13',' Ya se tienen los precios de las partes solo falta realizar la cedula de costos de la cual el Sr. Carlos Alberto Bailon nos dara la cotizacion de la instalacion para añadirla a la cedula de costos. Estamos a espera de la cotizacion del la instalacion, de la valvula solenoide y del filto deshidratador... Se obtuvo respuesta de la valvula solenoide y del filtro deshidratador:__ Filtro marca emerson modelo TD-304 conexion 1/2 precio de venta $300.00 NETO__Valvula solenoide marca emerson modelo 200RB-3T4 conexion 1/2 precio de venta $900.00 NETO. Esperando cotizacion de Sr. Carlos... Se le marco al Ing. Salvador Ruvalcaba el cual realizo un calculo aproximado de la instalacion del compresor, de la valvula solenoide y del filtro deshidratador, el monto fue por $16 000 M.N y la instalacion se le pedira a rufino la saque de la lista de precios.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC47','20/03/13',' Este requerimiento estaba mal dirigido porque es de mexico no de guadalajara.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC48','13/03/13',' Se solicito cotizacion y flete al area de compras con Jorge. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC48','13/03/13',' Jorge mando la informacion solicitada la cual fue la siguiente: PRECIO UNITARIO DE LISTA= $16 USD  LO CUAL NOS DA COMO RESULTADO= 200BATERIASX$16 TOTAL DE=$3200 USD"');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC49','15/03/13',' Se solicito la cotizacion a jorge chaves ebn espera de informacion ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC49','15/03/13',' La informacion del la cotizacion es la siguiente: $604.8 Dolares + IVA  Tiempo de entrega 2 Días ya completado la informacion queda completa la informacion');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC50','15/03/13',' Se le preguntara a claudia quien acudio al levantamiento e informcion del mismo. No se acudio al lugar fisicamente pero Rogelio Valadez lo estuvo checando con Julio lara reyes y se llego a la conclusion por parte de Julio Lara Reyes que no podrian saber mucho si el cliente en este caso pemex no daba unas IP''s para monitorear los equipos via remota y el porque se estaban alarmando por temperatura.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC51','14/03/13',' Se contesto cedula de costos, la informacion referente a dicho requerimiento biene adjunto en un correo que el Ing. salvador envio al correo de mesa de ayuda, Raul Perez Mosqueda. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC52','19/03/13',' Se le preguntara a Rogelio Valadez si se adquirieron las computadoras. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC52','20/03/13',' Rogelio comenta que no han atendido su solicitud y le pidio colaboracion a claudia rivera y a miguel garcia... ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC52','03/04/13',' El miercoles 27 de marzo se compraron los equipos por el area de compras y se enviaron a mexico para que la ocupe el personal.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC53','19/03/13',' Este es un requerimiento generado por el Ing. Martin para verificar que el formulario estaba funcionando correctamente.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC54','19/03/13',' Se solicito a Miguel Valdez el costo de las bateria fue: $379.00 USD por pieza (precio de lista, FOB Pittsiburgh) usar mult. =0.7, tenemos 6 piezas en stock. Con esto queda este requerimiento cerrado');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC55','20/03/13',' Se le marcara a berenice para saber los alcances que tiene el contrato con Servicio SICET para poder suministrar las partes que solicitan. El Ing. Luis andrade corroboro que si cubria el contrato las partes. Se envio el regrerimiento de partes a Jorge Chavez para la compra y el envio. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC55','03/04/13',' La compra fue realizada por Jorge chavez la cual ya fue enviada a la Sra. Berenice');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC57','20/03/13',' Se le marco al Ing. Joel y se le puso al tanto sobre dicha cita para que acudiera con el consultor . Y ademas valorara si es necesario asistir.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC58','20/03/13',' Se le comunico al Ing. Ruvalcaba de dicha solicitud de refaccion pregunto algunas especifiaciones del motor electrico pero al final lo cotizo claudia rivera refaccion comprada ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC59','20/03/13',' Se le solicito la cotizacion a }orge Chavez para solicitar el precio y el provvedor le comento que era necesario tener la capcidad de la bobina se le endico esto a Jorge Martinez persona que solicito la refaccion y este asu vez le envio un mail al cliente que solicito el predido que necesitaba el dato, en espera de lo que conteste el cliente...');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC60','22/03/13',' Se mando la requisicion de la refaccion a Miguel Garcia la cual ya realizo el envio del modulo de poder, comenta que tal vez llegue el lunes proximo ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC60','25/03/13',' por lo tanto el requerimiento queda cerrado');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC61','22/03/13',' Se mando la requisicion de la refaccion a Miguel Garcia la cual ya realizo el envio del modulo de poder, comenta que tal vez llegue el lunes proximo ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC61','25/03/13',' por lo tanto el requerimiento queda cerrado');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC62','22/03/13',' Se mando el levantamiento con claudia para que canalize la visita a los Ing. de Servicio que tengan disponibilidad ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC62','26/03/13',' Claudia asigno el servicio a Oscar Huerta para el dia ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC62','26/03/13',' a las 4:00 pm no se pudo programar un dia anterior por falta de disponibilidad de los Ing. de Servicio');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC63','26/03/13',' Se envio la requisicicon a jorge para que cotizara la parte.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC64','27/03/13',' Se mando un a cotizar con jorge solo estamos a la espera del dato. La cotizacion la hizo miguel garcia el equipo se cotizo como PRECIO DE VENTA PARA EL ACPSC2000 ES DE 802.00 USD la cual se mando via correo a ivan ramirez');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC65','27/03/13',' Se cotizo con el provedor externo Auto Transportes Internacionales el cual lo cotizo a un pecio aproximado de 4200+IVA no lo cotizo exacto porque faltaba realizar una visita la cual el lunes ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC65','','');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC66','01/03/13',' Se mando Jorge Chavez para comprar las partes y las especifiaciones con la cuales se debe cumplir. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC66','02/04/13',' Se le envio un desglose de las partes a pedir a jorge y se le hiciera mas simple realizar la cotizacion estamos en espera de su respuesta.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC66','02/04/13',' Se recivio la cotizacion de parte Jorge Chavez solo estamos a la espera del precio del flete a aguas calientes de las partes. Se le envio a jorge via e-mail que es necesario tener la cotizacion del flte a las partes. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC67','02/04/13',' Se mando el requerimiento Jorge Chavez para que realizara la cotizacion de los equipos asi como fletes y mano de obra..');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC67','02/04/13',' Se conocen los precios de los fletes y el precio unitario de unas de las baterias esprando el precio que falta. Ya fue enviado via correo el precio que faltaba.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC68','02/04/13',' El Ing. Salvado Ruvalcaba y el Ing. Luis Andrade le comentaron que el precio del estudio de calidad y energia que solicito se encuentra en la lista de precio en la pestaña con el nombre de calidad y energia');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC69','03/04/13',' Me comunique con el area de compras Jorge Chavez y me comento que dicha compra se encuentra en proceso ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC69','04/04/13',' Comento Rufino que el equipo ya se compro y el dia de hoy checaran si ya se encuentra en paqueteria.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC70','02/03/13',' Se hablo con ivan ramirez el cual dijo que la persona que tenia la informacion era el Ing. Julio Lara el cual comento estar planeando la distribucion de dicha instalacion cometo que no era necesario como tal realizar un plano pero el me comento que si necesitaba el plano me dira. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC70','03/04/13',' Se hablo con ivan ramirez y comento que si es necesario el plano ya que a e personalmente se los solicito el cliente. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC70','04/04/13',' Se envio correo a ivan ramirez con los datos del levantamiento para que me indique de que y como necesita el plano. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC70','08/04/13',' Me comento ivan ramirez que e Ing Joel Paz hara el plano del sembrado por practicidad ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC70','11/04/13',' El Ing Joel paz envio los planos del sembrado de los equipos.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC71','03/04/13',' Se le indico al Ing. Oscar Huerta que se le especifico que necesitaba indicar la ubicacion de los UPS''s y de los aires, pero no informo la distribucion de los nuevos equipos, se le marco al ing y especifico la nueva distribucion y se modificaron las hojas del levantamiento. Los levantamientos se le enviaron al ing. Salvador para que lo valore y pueda ayudar a Raul a la generacion de cotizacion de la mano de obra. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC71','04/04/13',' Se envio el diagrama de los condensadores a salvador y juan jose para completar la informacion. El Ing Oscar huerta envio las fotos que tomo del citio donde realizo el levantamiento la cedula de costos la genero el Ing. Salvador Ruvalcaba la cuel fue enviada a mesa de ayuda.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC72','04/04/13',' Se le envio el requerimiento del equipo a jorge chavez para que hiciera la compra solo estamos a la espera de que confirme compra. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC72','08/04/13',' Estamos e espera del numero de orden de compra para poderle dar seguimiento con e provedor del compresor.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC72','11/04/13',' Fue aprobada la validacion de garantia asi que el Ing. Miguel Valdez envio el numero de parte y el RMA: p/n: 101-104-230-410A 10TON 230 COMPRESSOR $2253.00EA solo falta que miguel cordine el envio y que claudia confirme el domicilio de envio.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC73','04/04/13',' El Ing. Salvador contesto a rufino que este tipo de equipo no se cotiza ya que grupo sac no es competente en este tipo de equipo. Ademas que la empresa no se encarga de esto.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC74','04/04/13',' Se le envio un mail a claudia para que coordinara la cita con el Ing. Joel Paz y si tenia la disponibilidad para acudir a tal cita. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC75','04/04/13',' Se mando los datos a Jorge para que comprara las refacciones y las envie a villa hermosa. Claudia Rivera se puso en contacto con Erik de ISEC para que le resolviera unas dudas al proveedor que intenta cotizarnos,  por el momento no nos han dado respuesta, estoy en espera de esa información para que nos puedan cotizar.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC76','08/04/13',' Se envio a jorge para que cotizara. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC76','11/04/13',' IVan Ramirez se comunico personalmente con jorge chavez para tener status y el comento requerir un dato mas sobre los equipos, el cual ya fue proporcionado. Solo estamos en espera de la raspuesta de compras. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC76','15/04/13',' Se recivio precio de parte de jorge chavez, $3,880.69');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC77','11/04/13',' Se asignio Jose Luis Esteva como estaba en servicio no pudo axiliar a Juan Jose,entonce Daniel Bravo presonalmente indico las alarmas criticas que erean reseteables automaticamente y maniualmente. Tal informacion ya fue enviada a Juan jose Espinoza.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC78','09/04/13',' La cordinadora administrativa de mexico claudia Rivera realizo la compre directamente con el provedor. Tal compre fue autorizada por el Ing. Luis Andrade.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC79','10/04/13',' Se hablo con el Ing. Salvador Ruvalcaba de la forma mas correcta de realizar la cotizacion el cual platanteo dos opciones las cuales consistian en: 1. Pedir la compra de un Kit el cual integraba todas la parte excepto los dos sensores 2. La otra era comprar todo por separado la cual no fue la mas viable ya que podria aumentar le precio considerablemente. Se le pidio a Jorge de Compras que contemplara la compra del kit y se le especifico que el senso de humedad estaba en stock en el almacen de guadalajara. Estamos en la espera de confirmacion de que Jorge Chavez cotize y compre.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC80','10/04/13',' La cotizcion y la compra se le asigno a Jorge chaves el cual cotizo a la brevedad el precio que el provedor cotizo fue de $ 11,695.70 MNX');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC81','12/04/20','13 Se hablo con el Ing. Salvador Ruvalcaba de la forma mas correcta de realizar la cotizacion el cual platanteo dos opciones las cuales consistian en: 1. Pedir la compra de un Kit el cual integraba todas la parte excepto los dos sensores 2. La otra era comprar todo por separado la cual no fue la mas viable ya que podria aumentar le precio considerablemente. Se le pidio a Jorge de Compras que contemplara la compra del kit y se le especifico que el senso de humedad estaba en stock en el almacen de guadalajara. Estamos en la espera de confirmacion de que Jorge Chavez cotize y compre.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC82','15/04/13',' Juan jose Espeinoza envio cotizar el equipo a Jorge Chavez se esta en espera que jorge chavez envie el precio de la cotizacion. Jorge chavez cotizo precio de baterias, el precio unitario de las baterias fue de: $206.6593 usd c/u+IVA y la mano de obra de instalacion fue delegada a Ing Joel Paz el cual respondio a la vrebedad y fue de: $306.76 usd sin incluir viaticos.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC83','15/04/13',' El Ing. Luis Andrade ayudo a Rufino a genrar la cedula de costos, le facilito el costo de la instalacion, biaticos y diagramas. Rufino ya tiene generada la cedula de costos la cual fue compartida via mail como antecedente.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC84','15/04/13',' Se envio el requerimiento a jorge chavez para la cotizacion, antes de eso el Ing. Salvador comento que nada biene incluido y que lo añadiera a la cotizacion. Tambien se corroboro que las caracteristicad de la planta estaban incompletos y se le marco a Jorge Martinez para que proporcionara los datos que faltaron. La cotizacion fue enviado por Jorge el dia ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC84','22/04/13',' y el precio de la planta fue el siguiente: $53,800.00 USD');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC85','12/04/13',' Se acudio a la cita el dia viernes 12 de abril con el Ing. Joel a realizar el levantamiento');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC86','15/04/13',' SE envio la cotizacion directamente a Miguel Angel Salinas provedor de guadalajara, con copia a jorge chavez y jorge martinez. Solo esta en espera de que el Ing. conteste al correo enviando la informacion competente. Se recivio el precio del Ing. Miguel Salinas PRECIO DE LISTA= $54,350.00 USD');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC87','15/04/13',' Se envio la cotizacion a Jorge Chavez, el Ing. Salvador comento que era necesario tener la capacidad del tanque para poder realizar la cotizacion. Solo estamos en espera de que Jose Luis Esteva mande el dato. Se le marco a Jose Luis y comento que el dia ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC87','22/04/13',' por la tarde enviaria la foto de la placa de caracteristicas y Jorge pueda cotizar ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC87','30/04/13',' Se realizo la orden de compra al provedor y se envio el destino dnde se hara el envio que fue en GDL.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC88','15/04/13',' Se enviaron cotizar con Jorge Chavez el cual cotizo a la brevedad, el Precio de Lista es 0 $357.071 USD+ IVA ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC89','15/04/13',' Se envio a cotizacion con los dos porvedores sugeridos por el Ing Salvador Ruvalacaba Reacsa o Totaline. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC89','22/04/13',' Se obtuvo respuesta de llos dos provedores pero como la coordinadora Claudia ya habia cotizado no fue necesario darle seguimiento con el provedor, ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC90','15/04/13',' Al momento de realizar la cotizacion Ivan ramires automaticamente le envio correo a Jorge Chavez para que cotizara los aires. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC90','22/04/13',' Ivan Ramirez agilizo personalmente la cotizacion con Jorge Chavez el cual la entrego a la brevedad, Ivan quedo en el envio de la informacion.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC91','22/04/13',' Se le envio nuevamente al Ing. Miguel Salinas para que cotizara el equipo con una capacidad mayor el cual envio la cotizacion a la brevedad, el precio del equipo de 72 TR fue el siguiente: $46,477.00 usd');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC92','18/04/13',' Se le envio mail al Ing. Luis para que autorizara la compra del motor, el Ing. Luis autorizo via mail.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC93','22/04/13',' El Ing. Salvador Ruvalacaba le esplico a Jusn Jose la forma de cotizar estas polizas Juan Jose Espinoza Compartio la cedula de costos al cierre del requerimiento. ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC94','22/04/13',' Se envio la solicitud de apoyo a la coordinadora Claudia Rivera para que agendara la cita a sitio. Ivan Ramirez comenta que no se realizo tal visita a sitio ya que no se encontraba disponible ningun ingeniero de servicio y la cita estaba determinada especificamente para ese dia.');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC95','07/05/13',' Se le enviaron los datos de la targeta al Ing. Miguel ');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC99','24/04/13',' Se realizo el envio de las partes requisitadas');
insert into `bloomTransferFollow`(`ticketNumber`,`date`,`comment`) values ('SAC126','07/05/13',' Se envio notifiacacion de visita Claudia Rivera , ademas de preguntar si ya acudieron a la cita');











