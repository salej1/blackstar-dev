-- -----------------------------------------------------
-- File:	blackstarDbTransfer_CreateSchema.sql    
-- Name:	blackstarDbTransfer_CreateSchema
-- Desc:	crea una version inicial de la base de datos de transferencia
-- Auth:	Sergio A Gomez
-- Date:	08/08/2013
-- -----------------------------------------------------
-- Change History
-- -----------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    08/08/2013  SAG  	Version inicial: BD, policy, ticket
-- 2	01/09/2013	SAG		Campo policy.exceptionParts extendido a 100 chars
-- 3	17/09/2013	SAG		Cambia el nombre de la BD a blackstarDeTransfer
--							Se homologaron tipos de equipos
-- -----------------------------------------------------
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `blackstarDbTransfer` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `blackstarDbTransfer` ;

-- -----------------------------------------------------
-- Table `blackstarDbTransfer`.`equipmentType`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstarDbTransfer`.`equipmentType` (
  `equipmentTypeId` CHAR(1) NOT NULL ,
  `equipmentType` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`equipmentTypeId`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;


-- -----------------------------------------------------
-- Table `blackstarDbTransfer`.`fieldPtr`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstarDbTransfer`.`fieldPtr` (
  `fieldPointerId` INT(11) NOT NULL AUTO_INCREMENT ,
  `entity` VARCHAR(45) NULL DEFAULT NULL ,
  `desc` VARCHAR(45) NULL DEFAULT NULL ,
  `field` VARCHAR(45) NULL DEFAULT NULL ,
  `hdr` VARCHAR(45) NULL DEFAULT NULL ,
  `created` DATETIME NULL DEFAULT NULL ,
  `createdBy` VARCHAR(45) NULL DEFAULT NULL ,
  PRIMARY KEY (`fieldPointerId`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;


-- -----------------------------------------------------
-- Table `blackstarDbTransfer`.`policy`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstarDbTransfer`.`policy` (
  `policyId` INT(11) NOT NULL AUTO_INCREMENT ,
  `office` VARCHAR(50) NULL DEFAULT NULL ,
  `policyType` VARCHAR(50) NULL DEFAULT NULL ,
  `customerContract` VARCHAR(50) NULL DEFAULT NULL ,
  `customer` VARCHAR(100) NULL DEFAULT NULL ,
  `finalUser` VARCHAR(50) NULL DEFAULT NULL ,
  `project` VARCHAR(50) NULL DEFAULT NULL ,
  `cst` VARCHAR(50) NULL DEFAULT NULL ,
  `equipmentTypeId` CHAR(1) NOT NULL ,
  `brand` VARCHAR(50) NULL DEFAULT NULL ,
  `model` VARCHAR(100) NULL DEFAULT NULL ,
  `serialNumber` VARCHAR(100) NULL DEFAULT NULL ,
  `capacity` VARCHAR(50) NULL DEFAULT NULL ,
  `equipmentAddress` VARCHAR(250) NULL DEFAULT NULL ,
  `equipmentLocation` VARCHAR(250) NULL DEFAULT NULL ,
  `contact` VARCHAR(100) NULL DEFAULT NULL ,
  `contactEmail` VARCHAR(200) NULL DEFAULT NULL ,
  `contactPhone` VARCHAR(200) NULL DEFAULT NULL ,
  `startDate` DATETIME NULL DEFAULT NULL ,
  `endDate` DATETIME NULL DEFAULT NULL ,
  `visitsPerYear` INT(11) NULL DEFAULT NULL ,
  `responseTimeHr` INT(11) NULL DEFAULT NULL ,
  `solutionTimeHr` INT(11) NULL DEFAULT NULL ,
  `penalty` TEXT NULL DEFAULT NULL ,
  `service` VARCHAR(50) NULL DEFAULT NULL ,
  `includesParts` TINYINT(1) NULL DEFAULT NULL ,
  `exceptionParts` VARCHAR(100) NULL DEFAULT NULL ,
  `serviceCenter` VARCHAR(50) NULL DEFAULT NULL ,
  `observations` TEXT NULL DEFAULT NULL ,
  `created` DATETIME NOT NULL ,
  `createdBy` VARCHAR(45) NOT NULL ,
  `createdByUsr` VARCHAR(45) NOT NULL ,
  `modified` DATETIME NULL DEFAULT NULL ,
  `modifiedBy` VARCHAR(45) NULL DEFAULT NULL ,
  `modifiedByUsr` VARCHAR(45) NULL DEFAULT NULL ,
  PRIMARY KEY (`policyId`) ,
  INDEX `SERIAL` (`serialNumber` ASC) ,
  INDEX `equipmentTypeID_POLICY_equipmentTypeID_equipmentType` (`equipmentTypeId` ASC) ,
  CONSTRAINT `equipmentTypeID_POLICY_equipmentTypeID_equipmentType`
    FOREIGN KEY (`equipmentTypeId` )
    REFERENCES `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;


-- -----------------------------------------------------
-- Table `blackstarDbTransfer`.`serviceType`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstarDbTransfer`.`serviceType` (
  `serviceTypeId` CHAR(1) NOT NULL ,
  `serviceType` VARCHAR(50) NOT NULL ,
  PRIMARY KEY (`serviceTypeId`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;


-- -----------------------------------------------------
-- Table `blackstarDbTransfer`.`ticketStatus`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstarDbTransfer`.`ticketStatus` (
  `ticketStatusId` CHAR(1) NOT NULL ,
  `ticketStatus` VARCHAR(10) NOT NULL ,
  PRIMARY KEY (`ticketStatusId`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;


-- -----------------------------------------------------
-- Table `blackstarDbTransfer`.`ticket`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstarDbTransfer`.`ticket` (
  `ticketId` INT(11) NOT NULL AUTO_INCREMENT ,
  `ticketNumber` VARCHAR(10) NOT NULL ,
  `policyId` INT(11) NULL DEFAULT NULL ,
  `user` VARCHAR(45) NULL DEFAULT NULL ,
  `contact` VARCHAR(45) NULL DEFAULT NULL ,
  `contactPhone` VARCHAR(100) NULL DEFAULT NULL ,
  `contactEmail` VARCHAR(100) NULL DEFAULT NULL ,
  `serialNumber` VARCHAR(45) NULL DEFAULT NULL ,
  `observations` TEXT NULL DEFAULT NULL ,
  `phoneResolved` TINYINT(1) NULL DEFAULT NULL ,
  `arrival` DATETIME NULL DEFAULT NULL ,
  `realResponseTime` INT(11) NULL DEFAULT NULL ,
  `responseTimeDeviation` INT(11) NULL DEFAULT NULL ,
  `followUp` TEXT NULL DEFAULT NULL ,
  `closed` DATETIME NULL DEFAULT NULL ,
  `serviceOrderNumber` VARCHAR(45) NULL DEFAULT NULL ,
  `employee` VARCHAR(200) NULL DEFAULT NULL ,
  `asignee` VARCHAR(45) NULL DEFAULT NULL ,
  `solutionTime` INT(11) NULL DEFAULT NULL ,
  `solutionTimeDeviationHr` INT(11) NULL DEFAULT NULL ,
  `ticketStatusId` CHAR(1) NULL DEFAULT NULL ,
  `created` DATETIME NULL DEFAULT NULL ,
  `createdBy` VARCHAR(45) NULL DEFAULT NULL ,
  `createdByUsr` VARCHAR(45) NULL DEFAULT NULL ,
  `modified` DATETIME NULL DEFAULT NULL ,
  `modifiedBy` VARCHAR(45) NULL DEFAULT NULL ,
  `modifiedByUsr` VARCHAR(45) NULL DEFAULT NULL ,
  PRIMARY KEY (`ticketId`) ,
  UNIQUE INDEX `ticketNumber_UNIQUE` (`ticketNumber` ASC) ,
  INDEX `TICKET_SERIAL_POLICY_SERIAL` (`serialNumber` ASC) ,
  INDEX `TICKET_STATUSID_ticketStatus_STATUSID` (`ticketStatusId` ASC) ,
  INDEX `TICKET_POLICYID_POLICY_POLICYID` (`policyId` ASC) ,
  INDEX `TICKET_ticketStatusID_ticketStatus_ticketStatusID` (`ticketStatusId` ASC) ,
  CONSTRAINT `TICKET_POLICYID_POLICY_POLICYID`
    FOREIGN KEY (`policyId` )
    REFERENCES `blackstarDbTransfer`.`policy` (`policyId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `TICKET_SERIAL_POLICY_SERIAL`
    FOREIGN KEY (`serialNumber` )
    REFERENCES `blackstarDbTransfer`.`policy` (`serialNumber` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `TICKET_ticketStatusID_ticketStatus_ticketStatusID`
    FOREIGN KEY (`ticketStatusId` )
    REFERENCES `blackstarDbTransfer`.`ticketStatus` (`ticketStatusId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;


-- -----------------------------------------------------
-- Table `blackstarDbTransfer`.`serviceTx`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstarDbTransfer`.`serviceTx` (
  `serviceTxId` INT(11) NOT NULL AUTO_INCREMENT ,
  `serviceNumber` VARCHAR(50) NULL DEFAULT NULL ,
  `ticketNumber` VARCHAR(50) NULL DEFAULT NULL ,
  `serviceUnit` VARCHAR(10) NULL DEFAULT NULL ,
  `project` VARCHAR(50) NULL DEFAULT NULL ,
  `customer` VARCHAR(50) NULL DEFAULT NULL ,
  `city` VARCHAR(50) NULL DEFAULT NULL ,
  `address` VARCHAR(200) NULL DEFAULT NULL ,
  `serviceTypeId` CHAR(1) NULL DEFAULT NULL ,
  `serviceDate` DATETIME NULL DEFAULT NULL ,
  `serialNumber` VARCHAR(100) NULL DEFAULT NULL ,
  `responsible` VARCHAR(100) NULL DEFAULT NULL ,
  `receivedBy` VARCHAR(100) NULL DEFAULT NULL ,
  `serviceComments` TEXT NULL DEFAULT NULL ,
  `closed` DATETIME NULL DEFAULT NULL ,
  `followUp` TEXT NULL DEFAULT NULL ,
  `spares` TEXT NULL DEFAULT NULL ,
  `consultant` VARCHAR(100) NULL DEFAULT NULL ,
  `contractorCompany` VARCHAR(100) NULL DEFAULT NULL ,
  `serviceRate` INT(11) NULL DEFAULT NULL ,
  `customerComments` TEXT NULL DEFAULT NULL ,
  `created` DATETIME NULL DEFAULT NULL ,
  `createdBy` VARCHAR(45) NULL DEFAULT NULL ,
  `createdByUsr` VARCHAR(45) NULL DEFAULT NULL ,
  `modified` DATETIME NULL DEFAULT NULL ,
  `modifiedBy` VARCHAR(45) NULL DEFAULT NULL ,
  `modifiedByUsr` VARCHAR(45) NULL DEFAULT NULL ,

  PRIMARY KEY (`serviceTxId`) ,
  INDEX `serviceNumber` (`serviceNumber` ASC) ,
  INDEX `serviceTx_ticketNumber_TICKET_ticketNumber` (`ticketNumber` ASC) ,
  INDEX `SERVICETS_serviceTypeID_serviceType_serviceTypeID` (`serviceTypeId` ASC) ,
  CONSTRAINT `SERVICETS_serviceTypeID_serviceType_serviceTypeID`
    FOREIGN KEY (`serviceTypeId` )
    REFERENCES `blackstarDbTransfer`.`serviceType` (`serviceTypeId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/*******************************************************************************
** ENDS SCHEMA SECTION 
*******************************************************************************/






/*******************************************************************************
** BEGINS DATA SECTION 
*******************************************************************************/

INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('U','UPS' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('M','MONITOREO' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('A','AA' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('P','PE' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('C','CA' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('F','FUEGO' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('V','VIDEO' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('D','PDU' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('O','MODULO DE POTENCIA' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('S','SERVICIO DE DESCONTAMINACIÓN DATA CENTER' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('B','BATERIAS' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('E','SUBESTACION' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('T','BATERIAS' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('R','TARJETA ETHERNET' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('Y','BYPASS' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('H','MODULO SWITCH' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('N','TRANSFORMADOR' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('I','SUPRESOR' );  
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('G','TRANSFERENCIA' );   
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('J','CONDENSADORA' );    
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('K','EVAPORADORA' );    
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('L','SUBESTACION' );    
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('W','TVSS ' );    
INSERT INTO `blackstarDbTransfer`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('Q','PCD' );    

INSERT INTO `blackstarDbTransfer`.`ticketStatus` (`ticketStatusId`, `ticketStatus`) VALUES ('A','ABIERTO' );  
INSERT INTO `blackstarDbTransfer`.`ticketStatus` (`ticketStatusId`, `ticketStatus`) VALUES ('C','CERRADO' );  
INSERT INTO `blackstarDbTransfer`.`ticketStatus` (`ticketStatusId`, `ticketStatus`) VALUES ('R','RETRASADO' );  
INSERT INTO `blackstarDbTransfer`.`ticketStatus` (`ticketStatusId`, `ticketStatus`) VALUES ('F','CERRADO FT' );  

INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('A','ARRANQUE' );  
INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('P','PREVENTIVO' );  
INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('C','CORRECTIVO' );  
INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('I','INSPECCION' );  
INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('T','INSTALACION' );  
INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('L','LIMPIEZA' );  
INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('V','VISITA' );  
INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('D','DIAGNOSTICO' );  
INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('E','LEVANTAMIENTO' );  
INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('O','INSPECCION Y CORRECTIVO' );  
INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('M','PUESTA EN MARCHA' );  
INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('N','MANTENIMIENTO' );  
INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('R','REVISION' );  
INSERT INTO `blackstarDbTransfer`.`serviceType` (`serviceTypeId`, `serviceType`) VALUES ('F','CONFIGURACION' );  




