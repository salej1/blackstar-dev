/******************************************************************************
** File:	createDatabse.sql    
** Name:	createDatabase
** Desc:	crea una version inicial de la base de datos
** Auth:	Sergio A Gomez	
** Date:	08/08/2013
*******************************************************************************
** Change History
*******************************************************************************
** PR   Date	    Author  	Description	
** --   --------   	-------   	------------------------------------
** 1    08/08/2013  SAG      	Version inicial: BD, policy, ticket
******************************************************************************/


-- CREACION DE LA BASE DE DATOS
CREATE DATABASE IF NOT EXISTS `blackstarDb`;

-- CREACION DEL FIELD POINTER
CREATE TABLE IF NOT EXISTS `blackstarDb`.`fieldPtr` (
  `fieldPointerId` INT NOT NULL ,
  `entity` VARCHAR(45) NULL ,
  `field` VARCHAR(45) NULL ,
  `desc` VARCHAR(45) NULL ,
  `sizeLimit` INT NULL ,
  `created` DATETIME NULL ,
  `createdBy` VARCHAR(45) NULL ,
  PRIMARY KEY (`fieldPointerId`) )
ENGINE = InnoDB;

-- CREACION DE LA TABLA DE POLIZAS
CREATE TABLE IF NOT EXISTS `blackstarDb`.`policy` (
  `policyId` int(11) NOT NULL DEFAULT '0',
  `office` varchar(10) DEFAULT NULL,
  `policyType` varchar(10) DEFAULT NULL,
  `customerContract` varchar(50) DEFAULT NULL,
  `customer` varchar(50) DEFAULT NULL,
  `finalUser` varchar(50) DEFAULT NULL,
  `project` varchar(10) DEFAULT NULL,
  `cst` varchar(50) DEFAULT NULL,
  `equipmentType` varchar(10) DEFAULT NULL,
  `brand` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `serialNumber` varchar(50) DEFAULT NULL,
  `capacity` varchar(10) DEFAULT NULL,
  `equipmentAddress` varchar(100) DEFAULT NULL,
  `equipmentLocation` varchar(100) DEFAULT NULL,
  `contact` varchar(100) DEFAULT NULL,
  `contactEmail` varchar(100) DEFAULT NULL,
  `contactPhone` varchar(50) DEFAULT NULL,
  `startDate` datetime DEFAULT NULL,
  `endDate` datetime DEFAULT NULL,
  `visitsPerYear` int(11) DEFAULT NULL,
  `responseTimeHr` int(11) DEFAULT NULL,
  `solutionTimeHr` int(11) DEFAULT NULL,
  `penalty` varchar(100) DEFAULT NULL,
  `service` varchar(10) DEFAULT NULL,
  `includesParts` tinyint(1) DEFAULT NULL,
  `exceptionParts` varchar(10) DEFAULT NULL,
  `serviceCenter` varchar(10) DEFAULT NULL,
  `observations` text,
  `created` datetime NOT NULL,
  `createdBy` varchar(45) NOT NULL,
  `createdByUsr` varchar(45) NOT NULL,
  `modified` datetime DEFAULT NULL,
  `modifiedBy` varchar(45) DEFAULT NULL,
  `modifiedByUsr` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`policyId`),
  KEY `SERIAL` (`serialNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- CREACION DE LA TABLA DE ESTATUS TICKETS
CREATE TABLE IF NOT EXISTS `blackstarDb`.`ticketStatus` (
  `ticketStatusId` int(11) NOT NULL,
  `ticketStatus` varchar(10) NOT NULL,
  PRIMARY KEY (`ticketStatusId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- CREACION DE LA TABLA DE TICKETS
CREATE TABLE IF NOT EXISTS `blackstarDb`.`ticket` (
  `ticketId` int(11) NOT NULL,
  `ticketNumber` varchar(10) NOT NULL,
  `user` varchar(45) DEFAULT NULL,
  `contact` varchar(45) DEFAULT NULL,
  `contactPhone` varchar(45) DEFAULT NULL,
  `contactEmail` varchar(45) DEFAULT NULL,
  `serialNumber` varchar(45) DEFAULT NULL,
  `observations` text,
  `phoneResolved` bit(1) DEFAULT NULL,
  `arrival` datetime DEFAULT NULL,
  `realResponseTime` int(11) DEFAULT NULL,
  `responseTimeDeviation` int(11) DEFAULT NULL,
  `followUp` text,
  `closed` datetime DEFAULT NULL,
  `serviceOrderNumber` varchar(45) DEFAULT NULL,
  `employee` varchar(45) DEFAULT NULL,
  `asignee` varchar(45) DEFAULT NULL,
  `solutionTime` int(11) DEFAULT NULL,
  `solutionTimeDeviationHr` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `createdBy` varchar(45) DEFAULT NULL,
  `createdByUsr` varchar(45) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `modifiedBy` varchar(45) DEFAULT NULL,
  `modifiedByUsr` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ticketId`),
  UNIQUE KEY `ticketNumber_UNIQUE` (`ticketNumber`),
  KEY `TICKET_SERIAL_POLICY_SERIAL` (`serialNumber`),
  CONSTRAINT `TICKET_SERIAL_POLICY_SERIAL` FOREIGN KEY (`serialNumber`) REFERENCES `policy` (`serialNumber`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- END
