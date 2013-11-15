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

CREATE TABLE epService
(
epServiceId INTEGER NOT NULL AUTO_INCREMENT,
serviceOrderId Integer not null,
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

CREATE TABLE epServiceTransferSwitch
(
epServiceTransferSwitchId INTEGER NOT NULL AUTO_INCREMENT,
epServiceId INTEGER NOT NULL ,
mechanicalStatus nvarchar(10) not null,
boardClean bit not null,
screwAdjust bit not null,
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

