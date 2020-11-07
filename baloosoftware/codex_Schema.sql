-- Table for store valid project status
CREATE TABLE `projectstatus` (
  `projectstatus_id` varchar(3) NOT NULL,
  `projectstatus` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`projectstatus_id`),
  UNIQUE KEY `projectstatus_id` (`projectstatus_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table for store project follow up
CREATE TABLE `projectfollowup` (
  `proyectfollowup_id` int(11) NOT NULL,
  `project_id` varchar(20) NOT NULL,
  `followup_date` datetime NOT NULL,
  `user_assigner` int(11) NOT NULL,
  `user_assingned` int(11) NOT NULL,
  `comment` text NOT NULL,
  PRIMARY KEY (`proyectfollowup_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table for store project historical tracking
CREATE TABLE `project_tracking` (
  `project_tracking_id` int(11) NOT NULL,
  `project_id` varchar(20) NOT NULL,
  `project_tracking_file_type` varchar(20) NOT NULL,
  `user` varchar(20) NOT NULL,
  `file_path` varchar(100) NOT NULL,
  `tracking_date` datetime NOT NULL,
  PRIMARY KEY (`project_tracking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- main table for store projects
CREATE TABLE `warrantProject` (
  `warrantProjectId` varchar(30) NOT NULL DEFAULT '',
  `status` varchar(15) NOT NULL,
  `customerId` int(11) NOT NULL,
  `costCenter` varchar(15) NOT NULL,
  `exchangeRate` double NOT NULL,
  `updateDate` date NOT NULL,
  `contactName` varchar(45) NOT NULL,
  `ubicationProject` varchar(45) NOT NULL,
  `paymentTermsId` int(11) NOT NULL,
  `deliveryTime` varchar(15) NOT NULL,
  `intercom` varchar(15) NOT NULL,
  `totalProject` double NOT NULL,
  `bonds` int(11) NOT NULL,
  `totalProductsServices` double NOT NULL,
  `officeId` char(1) NOT NULL,
  PRIMARY KEY (`warrantProjectId`),
  KEY `fk_warrant_project_1` (`customerId`),
  KEY `fk_warrantProject_3` (`paymentTermsId`),
  CONSTRAINT `fk_warrantProject_3` FOREIGN KEY (`paymentTermsId`) REFERENCES `paymentTerms` (`paymentTermsId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_warrant_project_1` FOREIGN KEY (`customerId`) REFERENCES `customer` (`customerId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


 CREATE TABLE `entry` (
  `entryid` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `reference` varchar(50) NOT NULL,
  `description` varchar(50) NOT NULL,
  `amount` double NOT NULL,
  `unitPrice` double NOT NULL,
  `discount` varchar(50) NOT NULL,
  `total` double NOT NULL,
  `observations` varchar(100) NOT NULL,
  `serviceTypeId` char(1) NOT NULL,
  `warrantProjectId` varchar(30) NOT NULL,
  PRIMARY KEY (`entryid`),
  KEY `warrantProjectId` (`warrantProjectId`),
  CONSTRAINT `entry_ibfk_1` FOREIGN KEY (`warrantProjectId`) REFERENCES `warrantProject` (`warrantProjectId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `item` (
  `itemId` int(11) NOT NULL,
  `type` varchar(30) NOT NULL,
  `referenceId` int(11) NOT NULL,
  `description` varchar(50) NOT NULL,
  `unitPrice` double NOT NULL,
  `discount` varchar(50) NOT NULL,
  `observations` varchar(100) NOT NULL,
  `entryId` int(11) NOT NULL,
  `amount` double NOT NULL,
  `total` double NOT NULL,
  PRIMARY KEY (`itemId`),
  KEY `fk_item_1` (`entryId`),
  CONSTRAINT `fk_item_1` FOREIGN KEY (`entryId`) REFERENCES `entry` (`entryid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- tabla para almacenar los centros de costos para la captura de cedula de proyectos
CREATE TABLE `costcenter` (
  `costcenter_id` varchar(20) NOT NULL,
  `office_id` char(1) NOT NULL,
  PRIMARY KEY (`costcenter_id`),
  UNIQUE KEY `costcenter_id` (`costcenter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- tabla para relacionar empleados con la oficina a la que pertenecen
CREATE TABLE `blackstaruser_office` (
  `blackstarUserId` int(11) NOT NULL,
  `officeId` char(1) NOT NULL,
  PRIMARY KEY (`blackstarUserId`,`officeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

