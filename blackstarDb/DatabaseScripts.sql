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
-- 26    22/06/2014  OMA	bloomDb.getBloomAdvisedUsers
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
	problemDescriptionGPTR Varchar(2500)
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
problemDescriptionGPTR)
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
problemDescriptionGPTR);
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
inner join bloomAdvisedGroup ag on (ag.userGroup=g.externalId)
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




