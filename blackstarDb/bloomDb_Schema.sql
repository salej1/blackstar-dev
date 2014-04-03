-- -----------------------------------------------------------------------------
-- File:	bloomDb_ChangeSchema.sql    
-- Name:	bloomDb_ChangeSchema
-- Desc:	Cambia el esquema de la bd
-- Auth:	Daniel Castillo B.
-- Date:	20/03/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    20/03/2014  DCB  	Version inicial.
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$
DROP PROCEDURE IF EXISTS blackstarDb.upgradeBloomSchema$$
CREATE PROCEDURE blackstarDb.upgradeBloomSchema()
BEGIN
-- AGREGANDO TABLA bloomServiceType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceType') = 0 THEN
		 CREATE TABLE blackstarDb.bloomServiceType(
            _id Int(3) NOT NULL,
            name Varchar(150) NOT NULL,
            description Varchar(400) NOT NULL,
            responseTime Int(2) NOT NULL
         ) ENGINE=INNODB;
		ALTER TABLE blackstarDb.bloomServiceType ADD PRIMARY KEY (_id);
        ALTER TABLE blackstarDb.bloomServiceType ADD CONSTRAINT U4 UNIQUE(name);
	END IF;
	
-- AGREGANDO TABLA bloomWorkerRoleType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomWorkerRoleType') = 0 THEN
		 CREATE TABLE bloomWorkerRoleType(
           _id Int(11) NOT NULL,
           name Varchar(150) NOT NULL,
           description Varchar(400) NOT NULL
         )ENGINE=INNODB;
         ALTER TABLE bloomWorkerRoleType ADD PRIMARY KEY (_id);
         ALTER TABLE bloomWorkerRoleType ADD CONSTRAINT U5 UNIQUE(name);
	END IF;	
	
-- AGREGANDO TABLA bloomStatusType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomStatusType') = 0 THEN
		 CREATE TABLE bloomStatusType(
           _id Int(11) NOT NULL,
           name Varchar(150) NOT NULL,
           description Varchar(400) NOT NULL
         )ENGINE=INNODB;
         ALTER TABLE bloomStatusType ADD PRIMARY KEY (_id);
         ALTER TABLE bloomStatusType ADD CONSTRAINT U6 UNIQUE(name);
	END IF;	

 -- AGREGANDO TABLA bloomApplicantArea
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomApplicantArea') = 0 THEN
		 CREATE TABLE bloomApplicantArea(
           _id Int(11) NOT NULL,
           name Varchar(150) NOT NULL,
           description Varchar(400) NOT NULL
         )ENGINE=INNODB;
         ALTER TABLE bloomApplicantArea ADD PRIMARY KEY (_id);
         ALTER TABLE bloomApplicantArea ADD CONSTRAINT U7 UNIQUE(name);
	END IF;	
	
 -- AGREGANDO TABLA bloomDeliverableType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomDeliverableType') = 0 THEN
		 CREATE TABLE bloomDeliverableType(
           _id Int(11) NOT NULL,
           name Varchar(150) NOT NULL,
           description Varchar(400) NOT NULL
         )ENGINE=INNODB;
         ALTER TABLE bloomDeliverableType ADD PRIMARY KEY (_id);
         ALTER TABLE bloomDeliverableType ADD CONSTRAINT U8 UNIQUE(name);
	END IF;	

 -- AGREGANDO TABLA bloomRequiredDeliverable
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomRequiredDeliverable') = 0 THEN
		 CREATE TABLE bloomRequiredDeliverable(
           _id Int(11) NOT NULL,
           serviceTypeId Int(3) NOT NULL,
           deliverableTypeId Int(11) NOT NULL
         )ENGINE=INNODB;
         ALTER TABLE bloomRequiredDeliverable ADD PRIMARY KEY (_id);
         ALTER TABLE bloomRequiredDeliverable ADD CONSTRAINT U1 UNIQUE(serviceTypeId, deliverableTypeId);
	END IF;	

 -- AGREGANDO TABLA bloomTicket
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomTicket') = 0 THEN
		 CREATE TABLE bloomTicket(
           _id Int(11) NOT NULL AUTO_INCREMENT,
           applicantUserId Int(11) NOT NULL,
           officeId Char(1) NOT NULL,
           serviceTypeId Int(3) NOT NULL,
           statusId Int(11) NOT NULL,
           applicantAreaId Int(11) NOT NULL,
           dueDate Date NOT NULL,
           project Varchar(50) NOT NULL,
           ticketNumber Varchar(15) NOT NULL,
           description Text NOT NULL,
           reponseInTime Tinyint,
           evaluation Int(2),
           desviation Float(30,20),
           responseDate Datetime,
           created Datetime NOT NULL,
           createdBy Varchar(50) NOT NULL,
           createdByUsr Int(11) NOT NULL,
           modified Datetime,
           modifiedBy Varchar(50),
           modifiedByUsr Int(11),
           PRIMARY KEY (`_id`)
         )ENGINE=INNODB;
         ALTER TABLE bloomTicket ADD CONSTRAINT U2 UNIQUE(ticketNumber);
	END IF;	

 -- AGREGANDO TABLA bloomTicketTeam
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomTicketTeam') = 0 THEN
		 CREATE TABLE bloomTicketTeam(
           _id Int(11) NOT NULL AUTO_INCREMENT,
           ticketId Int(11) NOT NULL,
           workerRoleTypeId Int(11) NOT NULL,
           blackstarUserId Int(11) NOT NULL,
		   assignedDate Datetime NOT NULL,
           PRIMARY KEY (`_id`)
         )ENGINE=INNODB;
	END IF;

 -- AGREGANDO TABLA bloomDeliverableTrace
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomDeliverableTrace') = 0 THEN
		 CREATE TABLE bloomDeliverableTrace(
           _id Int(11) NOT NULL AUTO_INCREMENT,,
           bloomTicketId Int(11) NOT NULL,
           deliverableTypeId Int(11) NOT NULL,
           delivered Int(11) DEFAULT 0,
           date Datetime NOT NULL
         )ENGINE=INNODB;
         ALTER TABLE bloomDeliverableTrace ADD PRIMARY KEY (_id);
         ALTER TABLE bloomDeliverableTrace ADD CONSTRAINT U9 UNIQUE(bloomTicketId,deliverableTypeId);
	END IF;	
	
-- MODIFICANDO TABLA followUp
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'followUp') = 0 THEN
		 ALTER TABLE followUp ADD bloomTicketId Int(11);
	END IF;		

-- REFERENCIAS

ALTER TABLE bloomTicket ADD CONSTRAINT R1 FOREIGN KEY (officeId) REFERENCES office (officeId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE bloomTicket ADD CONSTRAINT R2 FOREIGN KEY (serviceTypeId) REFERENCES bloomServiceType (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE bloomTicketTeam ADD CONSTRAINT R4 FOREIGN KEY (ticketId) REFERENCES bloomTicket (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE bloomTicketTeam ADD CONSTRAINT R5 FOREIGN KEY (workerRoleTypeId) REFERENCES bloomWorkerRoleType (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE bloomTicket ADD CONSTRAINT R6 FOREIGN KEY (statusId) REFERENCES bloomStatusType (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE followUp ADD CONSTRAINT R11 FOREIGN KEY (bloomTicketId) REFERENCES bloomTicket (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE bloomTicketTeam ADD CONSTRAINT R12 FOREIGN KEY (blackstarUserId) REFERENCES blackstaruser (blackstarUserId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE bloomTicket ADD CONSTRAINT R13 FOREIGN KEY (applicantUserId) REFERENCES blackstaruser (blackstarUserId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE bloomTicket ADD CONSTRAINT R14 FOREIGN KEY (applicantAreaId) REFERENCES bloomApplicantArea (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE bloomRequiredDeliverable ADD CONSTRAINT R16 FOREIGN KEY (serviceTypeId) REFERENCES bloomServiceType (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE bloomRequiredDeliverable ADD CONSTRAINT R17 FOREIGN KEY (deliverableTypeId) REFERENCES bloomDeliverableType (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE bloomDeliverableTrace ADD CONSTRAINT R18 FOREIGN KEY (bloomTicketId) REFERENCES bloomTicket (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE bloomDeliverableTrace ADD CONSTRAINT R19 FOREIGN KEY (deliverableTypeId) REFERENCES bloomDeliverableType (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE bloomTicket ADD CONSTRAINT R20 FOREIGN KEY (createdByUsr) REFERENCES blackstaruser (blackstarUserId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE bloomTicket ADD CONSTRAINT R21 FOREIGN KEY (modifiedByUsr) REFERENCES blackstaruser (blackstarUserId) ON DELETE NO ACTION ON UPDATE NO ACTION;

END$$

DELIMITER ;

CALL blackstarDb.upgradeBloomSchema();

DROP PROCEDURE blackstarDb.upgradeBloomSchema;