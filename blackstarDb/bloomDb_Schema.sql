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
-- 4 	23/07/2014	SAG 	Se agrega autoClose a bloomServiceType
--							Se agrega workerRoleTypeId a bloomAdvisedGroup
--							Se agrega bloomServiceArea
--							Se agrega bloomServiceAreaId a bloomServiceType
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.upgradeBloomSchema$$
CREATE PROCEDURE blackstarDb.upgradeBloomSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

-- AGREGANDO TABLA bloomServiceArea
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceArea') = 0 THEN
		 CREATE TABLE blackstarDb.bloomServiceArea(
            bloomServiceAreaId CHAR(1) NOT NULL,
            bloomServiceArea VARCHAR(200) NOT NULL,
			PRIMARY KEY (bloomServiceAreaId)
         ) ENGINE=INNODB;
	END IF;

-- AGREGANDO TABLA bloomServiceType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceType') = 0 THEN
		 CREATE TABLE blackstarDb.bloomServiceType(
            _id INT(3) NOT NULL,
            name VARCHAR(150) NOT NULL,
            description VARCHAR(400) NOT NULL,
            responseTime INT(2) NOT NULL,
			applicantAreaId INT(11) NOT NULL,
			PRIMARY KEY (_id)
         ) ENGINE=INNODB;
	END IF;

	
-- Agregando hidden a bloomServiceType
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceType' AND COLUMN_NAME = 'hidden') = 0  THEN
		ALTER TABLE bloomServiceType ADD hidden INT NULL;
	END IF;
	
-- Agregando autoclose a bloomServiceType
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceType' AND COLUMN_NAME = 'autoClose') = 0  THEN
		ALTER TABLE bloomServiceType ADD autoClose INT NULL;
	END IF;

-- Agregando bloomServiceAreaId a bloomServiceType
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomServiceType' AND COLUMN_NAME = 'bloomServiceAreaId') = 0  THEN
		ALTER TABLE bloomServiceType ADD bloomServiceAreaId CHAR(1) NOT NULL DEFAULT 'I';
		ALTER TABLE bloomServiceType ADD CONSTRAINT bloomServiceType_bloomServiceArea FOREIGN KEY (bloomServiceAreaId) REFERENCES bloomServiceArea(bloomServiceAreaId);
		UPDATE bloomServiceType SET bloomServiceAreaId = 'I' WHERE _id >= 1 AND _id <= 14;
		UPDATE bloomServiceType SET bloomServiceAreaId = 'C' WHERE _id = 15;
		UPDATE bloomServiceType SET bloomServiceAreaId = 'H' WHERE _id >= 16 AND _id <= 20;
		UPDATE bloomServiceType SET bloomServiceAreaId = 'A' WHERE _id >= 16 AND _id <= 21;
		UPDATE bloomServiceType SET bloomServiceAreaId = 'R' WHERE _id = 24;
	END IF;

-- AGREGANDO TABLA bloomWorkerRoleType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomWorkerRoleType') = 0 THEN
		 CREATE TABLE blackstarDb.bloomWorkerRoleType(
           _id INT(11) NOT NULL,
           name VARCHAR(150) NOT NULL,
           description VARCHAR(400) NOT NULL,
		   PRIMARY KEY (_id),
		   UNIQUE UQ_bloomWorkerRoleType(name)
         )ENGINE=INNODB;
	END IF;	

-- AGREGANDO TABLA bloomStatusType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomStatusType') = 0 THEN
		 CREATE TABLE blackstarDb.bloomStatusType(
           _id INT(11) NOT NULL,
           name VARCHAR(150) NOT NULL,
           description VARCHAR(400) NOT NULL,
		   PRIMARY KEY (_id),
		   UNIQUE UQ_bloomStatusType(name)
         )ENGINE=INNODB;
	END IF;	

 -- AGREGANDO TABLA bloomApplicantArea
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomApplicantArea') = 0 THEN
		 CREATE TABLE blackstarDb.bloomApplicantArea(
           _id INT(11) NOT NULL,
           name VARCHAR(150) NOT NULL,
           description VARCHAR(400) NOT NULL,
		   PRIMARY KEY (_id),
		   UNIQUE UQ_bloomApplicantArea(name)
         )ENGINE=INNODB;
	END IF;	

 -- AGREGANDO TABLA bloomDeliverableType
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomDeliverableType') = 0 THEN
		 CREATE TABLE blackstarDb.bloomDeliverableType(
           _id INT(11) NOT NULL,
           name VARCHAR(150) NOT NULL,
           description VARCHAR(400) NOT NULL,
		   serviceTypeId INT(3) NOT NULL,
		   PRIMARY KEY (_id),
		   FOREIGN KEY (serviceTypeId) REFERENCES bloomServiceType (_id)
         )ENGINE=INNODB;
	END IF;	

 -- AGREGANDO TABLA bloomRequiredDeliverable
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomRequiredDeliverable') = 0 THEN
		 CREATE TABLE blackstarDb.bloomRequiredDeliverable(
           _id INT(11) NOT NULL,
           serviceTypeId INT(3) NOT NULL,
           deliverableTypeId INT(11) NOT NULL,
		   PRIMARY KEY (_id),
		   UNIQUE UQ_bloomRequiredDeliverable(serviceTypeId, deliverableTypeId),
		   FOREIGN KEY (serviceTypeId) REFERENCES bloomServiceType (_id),
           FOREIGN KEY (deliverableTypeId) REFERENCES bloomDeliverableType (_id)
         )ENGINE=INNODB;
	END IF;	

 -- AGREGANDO TABLA bloomTicket
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomTicket') = 0 THEN
		 CREATE TABLE blackstarDb.bloomTicket(
           _id INT(11) NOT NULL AUTO_INCREMENT,
           applicantUserId INT(11) NOT NULL,
           officeId char(1) NOT NULL,
           serviceTypeId INT(3) NOT NULL,
           statusId INT(11) NOT NULL,
           applicantAreaId INT(11) NOT NULL,
           dueDate Date NOT NULL,
           project VARCHAR(50) NOT NULL,
           ticketNumber VARCHAR(15) NOT NULL,
           description Text NOT NULL,
           reponseInTime Tinyint,
           evaluation INT(2),
           desviation Float(30,20),
           responseDate Datetime,
           asignee VARCHAR(100),
           created Datetime NOT NULL,
           createdBy VARCHAR(50) NOT NULL,
           createdByUsr VARCHAR(50) NOT NULL,
           modified Datetime,
           modifiedBy VARCHAR(50),
           modifiedByUsr VARCHAR(50),
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
           _id INT(11) NOT NULL AUTO_INCREMENT,
           bloomTicketId INT(11) NOT NULL,
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
           _id INT(11) NOT NULL AUTO_INCREMENT,
           ticketId INT(11) NOT NULL,
           workerRoleTypeId INT(11) NOT NULL,
           blackstarUserId INT(11) NOT NULL,
           userGroup VARCHAR(50) NOT NULL,
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
           _id INT(11) NOT NULL AUTO_INCREMENT,
           bloomTicketId INT(11) NOT NULL,
           deliverableTypeId INT(11) NOT NULL,
           delivered INT(11) DEFAULT 0,
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
		 ALTER TABLE blackstarDb.followUp ADD bloomTicketId INT(11);
		 ALTER TABLE blackstarDb.followUp ADD CONSTRAINT R11 FOREIGN KEY (bloomTicketId) REFERENCES bloomTicket (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
	END IF;


-- AGREGANDO TABLA bloomAdvisedGroup
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomAdvisedGroup') = 0 THEN
			CREATE TABLE blackstarDb.bloomAdvisedGroup
			(
			  advicedGroupId INT(11) NOT NULL AUTO_INCREMENT,
			  applicantAreaId INT(3) NOT NULL,
			  serviceTypeId INT(3) NOT NULL,
			  userGroup VARCHAR(150) NOT NULL,
			  PRIMARY KEY (advicedGroupId)
			);
			ALTER TABLE blackstarDb.bloomAdvisedGroup ADD CONSTRAINT bloomRelationAdvisedGroup UNIQUE(applicantAreaId,serviceTypeId,userGroup);

	END IF;

-- Agregando docId a bloomDeliverableTrace
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'bloomAdvisedGroup' AND COLUMN_NAME = 'workerRoleTypeId') = 0  THEN
		ALTER TABLE bloomAdvisedGroup ADD workerRoleTypeId INT NULL;
		ALTER TABLE blackstarDb.bloomAdvisedGroup ADD CONSTRAINT bloomAdvisedGroup_workerRoleType FOREIGN KEY (workerRoleTypeId) REFERENCES bloomWorkerRoleType (_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
	END IF;
	
-- -----------------------------------------------------------------------------
-- FIN SECCION DE CAMBIOS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDb.upgradeBloomSchema();

DROP PROCEDURE blackstarDb.upgradeBloomSchema;