/******************************************************************************
** File:	createDatabse.sql    
** Name:	createDatabase
** Desc:	crea una version inicial de la base de datos
** Auth:	Sergio A Gomez
** Date:	08/08/2013
*******************************************************************************
** Change History
*******************************************************************************
** PR   Date    	Author	Description
** --   --------   -------  ------------------------------------
** 1    08/08/2013  SAG  	Version inicial: BD, policy, ticket
** 20	01/09/2013	SAG		Campo policy.exceptionParts extendido a 100 chars
******************************************************************************/
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `blackstardb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `blackstardb` ;

-- -----------------------------------------------------
-- Table `blackstardb`.`equipmenttype`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstardb`.`equipmenttype` (
  `equipmentTypeId` CHAR(1) NOT NULL ,
  `equipmentType` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`equipmentTypeId`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;


-- -----------------------------------------------------
-- Table `blackstardb`.`fieldptr`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstardb`.`fieldptr` (
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
-- Table `blackstardb`.`policy`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstardb`.`policy` (
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
  INDEX `EQUIPMENTTYPEID_POLICY_EQUIPMENTTYPEID_EQUIPMENTTYPE` (`equipmentTypeId` ASC) ,
  CONSTRAINT `EQUIPMENTTYPEID_POLICY_EQUIPMENTTYPEID_EQUIPMENTTYPE`
    FOREIGN KEY (`equipmentTypeId` )
    REFERENCES `blackstardb`.`equipmenttype` (`equipmentTypeId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;


-- -----------------------------------------------------
-- Table `blackstardb`.`servicetype`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstardb`.`servicetype` (
  `serviceTypeId` INT(11) NOT NULL AUTO_INCREMENT ,
  `serviceType` VARCHAR(20) NOT NULL ,
  PRIMARY KEY (`serviceTypeId`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;


-- -----------------------------------------------------
-- Table `blackstardb`.`ticketstatus`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstardb`.`ticketstatus` (
  `ticketStatusId` CHAR(1) NOT NULL ,
  `ticketStatus` VARCHAR(10) NOT NULL ,
  PRIMARY KEY (`ticketStatusId`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;


-- -----------------------------------------------------
-- Table `blackstardb`.`ticket`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstardb`.`ticket` (
  `ticketId` INT(11) NOT NULL AUTO_INCREMENT ,
  `ticketNumber` VARCHAR(10) NOT NULL ,
  `policyId` INT(11) NULL DEFAULT NULL ,
  `user` VARCHAR(45) NULL DEFAULT NULL ,
  `contact` VARCHAR(45) NULL DEFAULT NULL ,
  `contactPhone` VARCHAR(45) NULL DEFAULT NULL ,
  `contactEmail` VARCHAR(45) NULL DEFAULT NULL ,
  `serialNumber` VARCHAR(45) NULL DEFAULT NULL ,
  `observations` TEXT NULL DEFAULT NULL ,
  `phoneResolved` BIT(1) NULL DEFAULT NULL ,
  `arrival` DATETIME NULL DEFAULT NULL ,
  `realResponseTime` INT(11) NULL DEFAULT NULL ,
  `responseTimeDeviation` INT(11) NULL DEFAULT NULL ,
  `followUp` TEXT NULL DEFAULT NULL ,
  `closed` DATETIME NULL DEFAULT NULL ,
  `serviceOrderNumber` VARCHAR(45) NULL DEFAULT NULL ,
  `employee` VARCHAR(45) NULL DEFAULT NULL ,
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
  INDEX `TICKET_STATUSID_TICKETSTATUS_STATUSID` (`ticketStatusId` ASC) ,
  INDEX `TICKET_POLICYID_POLICY_POLICYID` (`policyId` ASC) ,
  INDEX `TICKET_TICKETSTATUSID_TICKETSTATUS_TICKETSTATUSID` (`ticketStatusId` ASC) ,
  CONSTRAINT `TICKET_POLICYID_POLICY_POLICYID`
    FOREIGN KEY (`policyId` )
    REFERENCES `blackstardb`.`policy` (`policyId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `TICKET_SERIAL_POLICY_SERIAL`
    FOREIGN KEY (`serialNumber` )
    REFERENCES `blackstardb`.`policy` (`serialNumber` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `TICKET_TICKETSTATUSID_TICKETSTATUS_TICKETSTATUSID`
    FOREIGN KEY (`ticketStatusId` )
    REFERENCES `blackstardb`.`ticketstatus` (`ticketStatusId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COLLATE = latin1_swedish_ci;


-- -----------------------------------------------------
-- Table `blackstardb`.`servicetx`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `blackstardb`.`servicetx` (
  `serviceTxId` INT(11) NOT NULL AUTO_INCREMENT ,
  `serviceNumber` VARCHAR(50) NULL DEFAULT NULL ,
  `tickeId` INT(11) NULL DEFAULT NULL ,
  `serviceUnit` VARCHAR(10) NULL DEFAULT NULL ,
  `project` VARCHAR(10) NULL DEFAULT NULL ,
  `customer` VARCHAR(50) NULL DEFAULT NULL ,
  `city` VARCHAR(50) NULL DEFAULT NULL ,
  `address` VARCHAR(200) NULL DEFAULT NULL ,
  `serviceTypeId` INT(11) NULL DEFAULT NULL ,
  `serviceDate` DATETIME NULL DEFAULT NULL ,
  `serialNumber` VARCHAR(50) NULL DEFAULT NULL ,
  `responsible` VARCHAR(100) NULL DEFAULT NULL ,
  `receivedBy` VARCHAR(100) NULL DEFAULT NULL ,
  `serviceComments` TEXT NULL DEFAULT NULL ,
  `closed` DATETIME NULL DEFAULT NULL ,
  `follwUp` TEXT NULL DEFAULT NULL ,
  `spares` VARCHAR(100) NULL DEFAULT NULL ,
  `consultant` VARCHAR(100) NULL DEFAULT NULL ,
  `contractorCompany` VARCHAR(100) NULL DEFAULT NULL ,
  `serviceRate` INT(11) NULL DEFAULT NULL ,
  `customerComments` TEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`serviceTxId`) ,
  INDEX `serviceNumber` (`serviceNumber` ASC) ,
  INDEX `SERVICETX_TICKETID_TICKET_TICKETID` (`tickeId` ASC) ,
  INDEX `SERVICETS_SERVICETYPEID_SERVICETYPE_SERVICETYPEID` (`serviceTypeId` ASC) ,
  CONSTRAINT `SERVICETS_SERVICETYPEID_SERVICETYPE_SERVICETYPEID`
    FOREIGN KEY (`serviceTypeId` )
    REFERENCES `blackstardb`.`servicetype` (`serviceTypeId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `SERVICETX_TICKETID_TICKET_TICKETID`
    FOREIGN KEY (`tickeId` )
    REFERENCES `blackstardb`.`ticket` (`ticketId` )
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

INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('U','UPS' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('M','MONITOREO' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('A','AA' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('P','PE' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('C','CA' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('F','FUEGO' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('V','VIDEO' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('D','PDU' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('O','MODULO DE POTENCIA' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('S','SERVICIO DE DESCONTAMINACIÓN DATA CENTER' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('B','BANCO DE BATERIAS' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('E','SUBESTACION' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('T','BATERIAS' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('R','TARJETA ETHERNET' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('Y','MODULO BYPASS' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('H','MODULO SWITCH' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('N','TRANSFORMADOR' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('I','SUPRESOR' );  
INSERT INTO `blackstarDb`.`equipmentType` (`equipmentTypeId`, `equipmentType`) VALUES ('G','GABINETE BY PASS' );  

INSERT INTO `blackstarDb`.`ticketStatus` (`ticketStatusId`, `ticketStatus`) VALUES ('A','ABIERTO' );  
INSERT INTO `blackstarDb`.`ticketStatus` (`ticketStatusId`, `ticketStatus`) VALUES ('C','CERRADO' );  
INSERT INTO `blackstarDb`.`ticketStatus` (`ticketStatusId`, `ticketStatus`) VALUES ('R','RETRASADO' );  
INSERT INTO `blackstarDb`.`ticketStatus` (`ticketStatusId`, `ticketStatus`) VALUES ('F','CERRADO FT' );  



