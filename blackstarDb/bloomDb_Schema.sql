-- -----------------------------------------------------------------------------
-- Desc:	Cambia el esquema de la bd
-- Auth:	Daniel Castillo B.
-- Date:	19/05/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    19/05/2014  DCB  	Carga de esquema Bloom
--                              * bloomServiceType
--                              * bloomWorkerRoleType
--                              * bloomStatusType
--                              * bloomApplicantArea
--                              * bloomDeliverableType
--                              * bloomRequiredDeliverable
--                              * bloomTicket
--                              * bloomTicketTeam
--                              * bloomDeliverableTrace
-- ---------------------------------------------------------------------------
-- 2    22/06/2014  OMA  	Cambios adicionales para el nuevo manejo de tickets internos
--                              * bloomAdvisedGroup Nueva tabla
--                              * bloomServiceType Actualizacion de campos
--                              * bloomDeliverableType Actualizacion de campos
--                              * bloomTicket Actualizacion de campos
-- ---------------------------------------------------------------------------
-- 3 	10/07/2014	SAG 	Se agrega desiredDate a bloomTicket
--							Se agrega hidden a bloomServiceType
--							Se agrega docId a bloomDeliverableTrace
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.upgradeBloomSchema$$
CREATE PROCEDURE blackstarDb.upgradeBloomSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

-- AGREGANDO TABLA bloomServiceType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceType') = 0 THEN
		 CREATE TABLE blackstarDb.bloomServiceType(
            _id Int(3) NOT NULL,
            name Varchar(150) NOT NULL,
            description Varchar(400) NOT NULL,
            responseTime Int(2) NOT NULL,
			applicantAreaId Int(11) NOT NULL,
			PRIMARY KEY (_id)
         ) ENGINE=INNODB;
	END IF;

	
-- Agregando hidden a bloomServiceType
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceType' AND COLUMN_NAME = 'hidden') = 0  THEN
		ALTER TABLE bloomServiceType ADD hidden INT NULL;
	END IF;


-- AGREGANDO TABLA bloomWorkerRoleType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomWorkerRoleType') = 0 THEN
		 CREATE TABLE blackstarDb.bloomWorkerRoleType(
           _id Int(11) NOT NULL,
           name Varchar(150) NOT NULL,
           description Varchar(400) NOT NULL,
		   PRIMARY KEY (_id),
		   UNIQUE UQ_bloomWorkerRoleType(name)
         )ENGINE=INNODB;
	END IF;	

-- AGREGANDO TABLA bloomStatusType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomStatusType') = 0 THEN
		 CREATE TABLE blackstarDb.bloomStatusType(
           _id Int(11) NOT NULL,
           name Varchar(150) NOT NULL,
           description Varchar(400) NOT NULL,
		   PRIMARY KEY (_id),
		   UNIQUE UQ_bloomStatusType(name)
         )ENGINE=INNODB;
	END IF;	

 -- AGREGANDO TABLA bloomApplicantArea
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomApplicantArea') = 0 THEN
		 CREATE TABLE blackstarDb.bloomApplicantArea(
           _id Int(11) NOT NULL,
           name Varchar(150) NOT NULL,
           description Varchar(400) NOT NULL,
		   PRIMARY KEY (_id),
		   UNIQUE UQ_bloomApplicantArea(name)
         )ENGINE=INNODB;
	END IF;	

 -- AGREGANDO TABLA bloomDeliverableType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomDeliverableType') = 0 THEN
		 CREATE TABLE blackstarDb.bloomDeliverableType(
           _id Int(11) NOT NULL,
           name Varchar(150) NOT NULL,
           description Varchar(400) NOT NULL,
		   serviceTypeId Int(3) NOT NULL,
		   PRIMARY KEY (_id),
		   FOREIGN KEY (serviceTypeId) REFERENCES bloomServiceType (_id)
         )ENGINE=INNODB;
	END IF;	

 -- AGREGANDO TABLA bloomRequiredDeliverable
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomRequiredDeliverable') = 0 THEN
		 CREATE TABLE blackstarDb.bloomRequiredDeliverable(
           _id Int(11) NOT NULL,
           serviceTypeId Int(3) NOT NULL,
           deliverableTypeId Int(11) NOT NULL,
		   PRIMARY KEY (_id),
		   UNIQUE UQ_bloomRequiredDeliverable(serviceTypeId, deliverableTypeId),
		   FOREIGN KEY (serviceTypeId) REFERENCES bloomServiceType (_id),
           FOREIGN KEY (deliverableTypeId) REFERENCES bloomDeliverableType (_id)
         )ENGINE=INNODB;
	END IF;	

 -- AGREGANDO TABLA bloomTicket
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomTicket') = 0 THEN
		 CREATE TABLE blackstarDb.bloomTicket(
           _id Int(11) NOT NULL AUTO_INCREMENT,
           applicantUserId Int(11) NOT NULL,
           officeId char(1) NOT NULL,
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
			purposeVisitVL TEXT,
			purposeVisitVISAS TEXT,
			draftCopyDiagramVED TEXT,
			formProjectVED TEXT,
			observationsVEPI TEXT,
			draftCopyPlanVEPI TEXT,
			formProjectVEPI TEXT,
			observationsVRCC TEXT,
			checkListVRCC TEXT,
			formProjectVRCC TEXT,
			questionVPT TEXT,
			observationsVSA TEXT,
			formProjectVSA TEXT,
			productInformationVSP TEXT,
			observationsISED TEXT,
			draftCopyPlanISED TEXT,
			observationsISRC TEXT,
			attachmentsISRC TEXT,
			apparatusTraceISSM TEXT,
			observationsISSM TEXT,
			questionISSM TEXT,
			ticketISRPR TEXT,
			modelPartISRPR TEXT,
			observationsISRPR TEXT,
			productInformationISSPC TEXT,
			positionPGCAS TEXT,
			collaboratorPGCAS TEXT,
			justificationPGCAS TEXT,
			salaryPGCAS TEXT,
			positionPGCCP TEXT,
			commentsPGCCP TEXT,
			developmentPlanPGCCP TEXT,
			targetPGCCP TEXT,
			salaryPGCCP TEXT,
			positionPGCNC TEXT,
			developmentPlanPGCNC TEXT,
			targetPGCNC TEXT,
			salaryPGCNC TEXT,
			justificationPGCNC TEXT,
			positionPGCF TEXT,
			collaboratorPGCF TEXT,
			justificationPGCF TEXT,
			positionPGCAA TEXT,
			collaboratorPGCAA TEXT,
			justificationPGCAA TEXT,
			requisitionFormatGRC TEXT,
			linkDocumentGM TEXT,
			suggestionGSM TEXT,
			documentCodeGSM TEXT,
			justificationGSM TEXT,
			problemDescriptionGPTR TEXT,	
			resolvedOnTime INT,	   
	   
           PRIMARY KEY (_id),
           FOREIGN KEY (serviceTypeId) REFERENCES bloomServiceType (_id),
           FOREIGN KEY (statusId) REFERENCES bloomStatusType (_id),
           FOREIGN KEY (applicantUserId) REFERENCES blackstarUser (blackstarUserId),
           FOREIGN KEY (applicantAreaId) REFERENCES bloomApplicantArea (_id),
           FOREIGN KEY (createdByUsr) REFERENCES blackstarUser (blackstarUserId),
           FOREIGN KEY (modifiedByUsr) REFERENCES blackstarUser (blackstarUserId),
		   UNIQUE UQ_bloomTicket(ticketNumber)
         )ENGINE=INNODB;

		
	END IF;	

-- Agregando desiredDate a bloomTicket
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomTicket' AND COLUMN_NAME = 'desiredDate') = 0  THEN
		ALTER TABLE bloomTicket ADD desiredDate DATETIME NULL;
	END IF;

-- AGREGANDO TABLA bloomSurvey
IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomSurvey') = 0 THEN
		 CREATE TABLE blackstarDb.bloomSurvey(
           _id Int(11) NOT NULL AUTO_INCREMENT,
           bloomTicketId Int(11) NOT NULL,
           evaluation Tinyint NOT NULL,
           comments Text NOT NULL,
           created Date NOT NULL,
		   PRIMARY KEY (_id),
		   FOREIGN KEY (bloomTicketId) REFERENCES bloomTicket (_id)
         )ENGINE=INNODB;
	END IF;	
	
 -- AGREGANDO TABLA bloomTicketTeam
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomTicketTeam') = 0 THEN
		 CREATE TABLE blackstarDb.bloomTicketTeam(
           _id Int(11) NOT NULL AUTO_INCREMENT,
           ticketId Int(11) NOT NULL,
           workerRoleTypeId Int(11) NOT NULL,
           blackstarUserId Int(11) NOT NULL,
		   assignedDate Datetime NOT NULL,
           PRIMARY KEY (`_id`),
		   FOREIGN KEY (ticketId) REFERENCES bloomTicket (_id),
           FOREIGN KEY (workerRoleTypeId) REFERENCES bloomWorkerRoleType (_id),
           FOREIGN KEY (blackstarUserId) REFERENCES blackstarUser (blackstarUserId)
         )ENGINE=INNODB;
	END IF;

 -- AGREGANDO TABLA bloomDeliverableTrace
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomDeliverableTrace') = 0 THEN
		 CREATE TABLE blackstarDb.bloomDeliverableTrace(
           _id Int(11) NOT NULL AUTO_INCREMENT,
           bloomTicketId Int(11) NOT NULL,
           deliverableTypeId Int(11) NOT NULL,
           delivered Int(11) DEFAULT 0,
           date Datetime NOT NULL,
		   PRIMARY KEY (_id),
		   UNIQUE UQ_bloomDeliverableTrace(bloomTicketId,deliverableTypeId),
		   FOREIGN KEY (bloomTicketId) REFERENCES bloomTicket (_id),
           FOREIGN KEY (deliverableTypeId) REFERENCES bloomDeliverableType (_id)
         )ENGINE=INNODB;
	END IF;		

-- Agregando docId a bloomDeliverableTrace
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomDeliverableTrace' AND COLUMN_NAME = 'docId') = 0  THEN
		ALTER TABLE bloomDeliverableTrace ADD docId VARCHAR(400) NULL;
	END IF;

-- AGREGANDO COLUMNA bloomTicketId A followUp
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'followUp' AND COLUMN_NAME = 'bloomTicketId') =0  THEN
		 ALTER TABLE blackstarDb.followUp ADD bloomTicketId Int(11);
		 ALTER TABLE blackstarDb.followUp ADD CONSTRAINT R11 FOREIGN KEY (bloomTicketId) REFERENCES bloomTicket (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
	END IF;


-- AGREGANDO TABLA bloomAdvisedGroup
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomAdvisedGroup') = 0 THEN
			CREATE TABLE blackstarDb.bloomAdvisedGroup
			(
			  advicedGroupId Int(11) NOT NULL AUTO_INCREMENT,
			  applicantAreaId Int(3) NOT NULL,
			  serviceTypeId Int(3) NOT NULL,
			  userGroup Varchar(150) NOT NULL,
			  PRIMARY KEY (advicedGroupId)
			);
			ALTER TABLE blackstarDb.bloomAdvisedGroup ADD CONSTRAINT bloomRelationAdvisedGroup UNIQUE(applicantAreaId,serviceTypeId,userGroup);

	END IF;


	
-- -----------------------------------------------------------------------------
-- FIN SECCION DE CAMBIOS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDb.upgradeBloomSchema();

DROP PROCEDURE blackstarDb.upgradeBloomSchema;