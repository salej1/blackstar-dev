-- -----------------------------------------------------------------------------
-- File:	bloomDb_StoredProcedures.sql   
-- Name:	bloomDb_StoredProcedures
-- Desc:	Crea o actualiza los Stored procedures operativos de la aplicacion
-- Auth:	Sergio A Gomez
-- Date:	20/03/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ----------------------------------------------------
-- 1    20/03/2014	DCB		Se Integran los SP iniciales:
--								bloomDb.BloomUpdateTickets
--								bloomDb.BloomUpdateTransferFollow
--								bloomDb.BloomUpdateTransferTeam
-- 								bloomDb.BloomUpdateTransferUsers
-- 								bloomDb.BloomTransfer
-- 2    24/03/2014	DCB		Se Integra blackstarDb.GetBloomTicketDetail
-- 3    24/03/2014	DCB		Se Integra blackstarDb.GetBloomTicketTeam
-- 4    28/03/2014	DCB		Se Integra blackstarDb.AddFollowUpToBloomTicket
--                          Se Integra blackstarDb.UpsertBloomTicketTeam
--                          Se Integra blackstarDb.GetBloomFollowUpByTicket
-- 5    31/03/2014  DCB     Se integra blackstarDb.GetBloomDeliverableType  
--                  DCB     Se integra blackstarDb.AddBloomDelivarable  
-- 5    02/04/2014  DCB     Se integra blackstarDb.GetBloomTicketResponsible
--                  DCB     Se integra blackstarDb.GetUserById
-- 6    03/04/2014  DCB     Se integra blackstarDb.CloseBloomTicket

-- 7     08/05/2014  OMA	bloomDb.getBloomPendingTickets
-- 8     08/05/2014  OMA	bloomDb.getBloomTickets
-- 9     08/05/2014  OMA	bloomDb.getBloomDocumentsByService
-- 10    08/05/2014  OMA 	bloomDb.getBloomProjects
-- 11    08/05/2014  OMA 	bloomDb.getBloomApplicantArea
-- 12    08/05/2014  OMA 	bloomDb.getBloomServiceType
-- 13    08/05/2014  OMA 	bloomDb.getBloomOffice
-- 14    08/05/2014  OMA 	bloomDb.GetNextInternalTicketNumber
-- 15    08/05/2014  OMA 	bloomDb.AddInternalTicket
-- 16    08/05/2014  OMA 	bloomDb.AddMemberTicketTeam
-- 17    08/05/2014  OMA 	bloomDb.AddDeliverableTrace
-- 18    08/05/2014  OMA	bloomDb.GetUserData (MODIFICADO:Sobrescribimos la version anterior)
-- 19    08/05/2014  OMA	bloomDb.getBloomEstatusTickets

-- 19    16/05/2014  OMA	bloomDb.GetBloomSupportAreasWithTickets
-- 20    16/05/2014  OMA	bloomDb.GetBloomStatisticsByAreaSupport
-- 21    16/05/2014  OMA	bloomDb.GetBloomPercentageTimeClosedTickets
-- 22    16/05/2014  OMA	bloomDb.GetBloomPercentageEvaluationTickets
-- 23    16/05/2014  OMA	bloomDb.GetBloomNumberTicketsByArea
-- 24    16/05/2014  OMA	bloomDb.GetBloomUnsatisfactoryTicketsByUserByArea
-- 25    16/05/2014  OMA	bloomDb.GetBloomHistoricalTickets

--------------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$


-- -----------------------------------------------------------------------------
	-- blackstarDb.BloomUpdateTickets
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS blackstardb.BloomUpdateTickets$$
CREATE FUNCTION blackstardb.`BloomUpdateTickets`() RETURNS int(11)
BEGIN

  DECLARE counter INTEGER;
  DECLARE done BOOLEAN DEFAULT 0;

  DECLARE applicantUserId Int(11);
  DECLARE officeL Char(1);
  DECLARE serviceTypeId Int(3);
  DECLARE applicantAreaId Int(11);
  DECLARE createdByUsrId Int(11);
  DECLARE bolResponseInTime Tinyint;

  DECLARE created Varchar(100);
  DECLARE createdByUsr Varchar(100);
  DECLARE applicantArea Varchar(100);
  DECLARE serviceType Varchar(200);
  DECLARE serviceTypeSS Varchar(200);
  DECLARE serviceTypeGeneral Varchar(100);
  DECLARE dueDateStr Varchar(100);
  DECLARE description Text;
  DECLARE serviceTypeManager Varchar(100);
  DECLARE project Varchar(100);
  DECLARE officeStr Varchar(20);
  DECLARE ticketNumber Varchar(20);
  DECLARE responseDateStr Varchar(100);
  DECLARE responseInTime Varchar(100);
  DECLARE evaluation Varchar(2);
  DECLARE responseInHours Varchar(50);
  DECLARE desviation Varchar(50);
  DECLARE observations Text;

  DECLARE dueDate DateTime;
  DECLARE responseDate DateTime;
  DECLARE status Int;

  DECLARE transfer_cursor CURSOR FOR 
    SELECT * FROM blackstarDbTransfer.bloomTransferTicket;
    
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;

  SET counter = 0;
  OPEN transfer_cursor;

  loop_lbl: LOOP
      FETCH transfer_cursor INTO created, createdByUsr, applicantArea, serviceType, serviceTypeSS
                               , serviceTypeGeneral, dueDateStr, description, serviceTypeManager, project
                               , officeStr, ticketNumber, responseDateStr, responseInTime, evaluation
                               , responseInHours, desviation, observations;
      IF done = 1 THEN 
			   LEAVE loop_lbl;
		  END IF;                           
      SET bolResponseInTime = 0;
      SET createdByUsrId = IFNULL((SELECT blackStarUserId from blackstaruser where email = 'portal-servicios@gposac.com.mx'), -1);                               
      SET applicantUserId = IFNULL((SELECT blackStarUserId from blackstaruser where email = createdByUsr), -1);
      SET officeL = IFNULL((SELECT officeId from office where officeName = officeStr), '?');
      SET serviceTypeId = IFNULL((SELECT _id from bloomServiceType where name = serviceType), -1);
      SET applicantAreaId = IFNULL((SELECT _id from bloomApplicantArea where name = applicantArea), -1);
      IF project IS NULL THEN
        SET project = 'UNKNOWN';
      END IF;
      IF responseInTime = 'SI' THEN
        SET bolResponseInTime = 1;
        SET status = 5;
      ELSEIF responseInTime IS NULL THEN
        SET bolResponseInTime = null;
        SET status = 2;
      ELSE SET status = 2;
      END IF;
      IF dueDateStr IS NULL THEN
         SET dueDate = NOW();
      ELSE SET dueDate = STR_TO_DATE(dueDateStr, '%Y-%m-%d %T');
      END IF;
      IF responseDateStr IS NULL THEN
         SET responseDate = NULL;
      ELSE SET responseDate = STR_TO_DATE(responseDateStr, '%Y-%m-%d %T');
      END IF;
      IF evaluation = '' THEN
         SET evaluation = '0';
      END IF;   
      IF desviation = '' THEN
         SET desviation = '0';
      END IF;
      INSERT INTO bloomticket(applicantUserId, officeId, serviceTypeId, statusId, applicantAreaId
                  , dueDate, project, ticketNumber, description, reponseInTime, evaluation, desviation
                  , responseDate, created, createdBy, createdByUsr, modified, modifiedBy, modifiedByUsr) 
             VALUES(applicantUserId, officeL, serviceTypeId, status, applicantAreaId, dueDate, project
                    , ticketNumber, description, bolResponseInTime, CAST(evaluation AS UNSIGNED INTEGER) , desviation, responseDate
                    , STR_TO_DATE(created, '%Y-%m-%d %T'), 'BloomDataLoader', createdByUsrId, null, null, null);
      SET counter = counter + 1;
  END LOOP loop_lbl;

  CLOSE transfer_cursor;    
  RETURN counter;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.BloomUpdateTransferFollow
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS blackstardb.BloomUpdateTransferFollow$$
CREATE FUNCTION blackstardb.`BloomUpdateTransferFollow`() RETURNS int(11)
BEGIN

  DECLARE counter INTEGER;
  DECLARE ticketId Int(11);
  DECLARE ticket Varchar(20);
  DECLARE createdStr Varchar(100);
  DECLARE comment Text;
  DECLARE done BOOLEAN DEFAULT 0;
 
  DECLARE transfer_cursor CURSOR FOR 
    SELECT * FROM blackstarDbTransfer.bloomtransferfollow;
    
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;

  SET counter = 0;
  OPEN transfer_cursor;
  loop_lbl: LOOP
      FETCH transfer_cursor INTO ticket, createdStr, comment;
      IF done = 1 THEN 
			   LEAVE loop_lbl;
		  END IF;  
      SET ticketId =(SELECT _id from bloomTicket where ticketNumber = ticket);
      INSERT INTO followUp(bloomTicketId,followup, created, createdBy, createdByUsr) 
             VALUES(ticketId, comment, STR_TO_DATE(createdStr, '%y/%m/%d'), 'BloomDataLoader', 'portal-servicios@gposac.com.mx');
      SET counter = counter + 1;
  END LOOP loop_lbl;

  CLOSE transfer_cursor;    
  RETURN counter;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.BloomUpdateTransferTeam
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS blackstardb.BloomUpdateTransferTeam$$
CREATE FUNCTION blackstardb.`BloomUpdateTransferTeam`() RETURNS int(11)
BEGIN

  DECLARE counter INTEGER;
  DECLARE ticketId Int(11);
  DECLARE ticket Varchar(20);
  DECLARE userName Varchar(100);
  DECLARE userId Varchar(100);
  DECLARE done BOOLEAN DEFAULT 0;

  DECLARE transfer_cursor CURSOR FOR 
    SELECT * FROM blackstarDbTransfer.bloomTransferTicketTeam;
    
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;

  SET counter = 0;
  OPEN transfer_cursor;
  --INSERT INTO messages VALUES ('INICIO');
  loop_lbl: LOOP
      FETCH transfer_cursor INTO ticket, userName;
      IF done = 1 THEN 
			   LEAVE loop_lbl;
		  END IF;
      --INSERT INTO messages VALUES (CONCAT('TICKET: ', ticket));
      SET ticketId =(SELECT _id from bloomTicket where ticketNumber = ticket);
      --INSERT INTO messages VALUES (CONCAT('TICKET_ID: ', ticketId));
      --INSERT INTO messages VALUES (CONCAT('USER: ', userName));
      SET userId = IFNULL((SELECT blackStarUserId from blackstaruser where name LIKE CONCAT(userName,'%')), -1);
      --INSERT INTO messages VALUES (CONCAT('USER_ID: ', userId));
      INSERT INTO bloomTicketTeam(ticketId,workerRoleTypeId, blackstarUserId) 
             VALUES(ticketId,1, userId);
      SET counter = counter + 1;
  END LOOP loop_lbl;

  CLOSE transfer_cursor;    
  RETURN counter;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.BloomUpdateTransferUsers
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS blackstardb.BloomUpdateTransferUsers$$
CREATE FUNCTION blackstardb.`BloomUpdateTransferUsers`() RETURNS int(11)
BEGIN

  DECLARE done BOOLEAN DEFAULT 0;

  DECLARE bloomCreatedByUsrMail Varchar(100);
  DECLARE bloomCreatedByUsrName Varchar(100);
  DECLARE bloomCreatedByUsrLastName Varchar(100);
  DECLARE iniSplitPos INTEGER;
  DECLARE endSplitPos INTEGER;
  DECLARE splitValue VARCHAR(100);
  DECLARE counter INTEGER;
    
  DECLARE user_cursor CURSOR FOR 
     SELECT DISTINCT createdByUsr FROM blackstarDbTransfer.bloomTransferTicket
     WHERE createdByUsr NOT IN (SELECT email FROM blackstaruser);

  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;

  OPEN user_cursor;

  SET counter = 0;
  fill_users: LOOP
      FETCH user_cursor INTO bloomCreatedByUsrMail; 
      IF done = 1 THEN 
			   LEAVE fill_users;
		  END IF;  
      SET endSplitPos = LOCATE('\@', bloomCreatedByUsrMail, 1);
      SET splitValue = SUBSTR(bloomCreatedByUsrMail, 1, endSplitPos -1);
      SET endSplitPos = LOCATE('\.', splitValue, 1);
      SET bloomCreatedByUsrName = SUBSTR(splitValue, 1, endSplitPos -1);
      SET bloomCreatedByUsrName = CONCAT(UCASE(LEFT(bloomCreatedByUsrName, 1)), 
                                         SUBSTRING(bloomCreatedByUsrName, 2));
      SET bloomCreatedByUsrLastName = SUBSTR(splitValue, endSplitPos +1);
      SET bloomCreatedByUsrLastName = CONCAT(UCASE(LEFT(bloomCreatedByUsrLastName, 1)), 
                                              SUBSTRING(bloomCreatedByUsrLastName, 2));                                         
      INSERT INTO blackstarUser (email, name) VALUES (bloomCreatedByUsrMail, CONCAT(bloomCreatedByUsrName, ' ', bloomCreatedByUsrLastName));
      SET counter = counter + 1;
  END LOOP fill_users;
  CLOSE user_cursor;
  RETURN counter;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.BloomTransfer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.BloomTransfer$$
CREATE PROCEDURE blackstardb.`BloomTransfer`()
BEGIN

  DECLARE auxInt INTEGER;

  --DELETE FROM messages;
  SET auxInt = BloomUpdateTransferUsers();
  --INSERT INTO messages VALUES (CONCAT('USERS FROM TRANSFER: ', auxInt));
  SET auxInt = BloomUpdateTickets();
  --INSERT INTO messages VALUES (CONCAT('TICKETS FROM TRANSFER: ', auxInt));
  SET auxInt = BloomUpdateTransferTeam();
  --INSERT INTO messages VALUES (CONCAT('TEAMS FROM TRANSFER: ', auxInt));
  SET auxInt = BloomUpdateTransferFollow();
  --INSERT INTO messages VALUES (CONCAT('FOLLOWS FROM TRANSFER: ', auxInt));
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomTicketDetail
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.GetBloomTicketDetail$$
CREATE PROCEDURE blackstardb.`GetBloomTicketDetail`(ticketId INTEGER)
BEGIN

SELECT *
FROM ((SELECT _id id, applicantUserId applicantUserId, officeId officeId, serviceTypeId serviceTypeId
             , statusId statusId, applicantAreaId applicantAreaId, dueDate, project, ticketNumber ticketNumber
             , description description, reponseInTime reponseInTime, evaluation evaluation
             , desviation desviation, responseDate responseDate, created created, createdBy createdBy
             , createdByUsr createdByUsr, modified modified, modifiedBy modifiedBy, modifiedByUsr modifiedByUsr
       FROM bloomticket WHERE _ID = ticketId) AS ticketDetail
       LEFT JOIN (SELECT bu.blackstarUserId refId, bu.name applicantUserName
           FROM blackstaruser bu) AS j1
           ON ticketDetail.applicantUserId = j1.refId
       LEFT JOIN (SELECT of.officeId refId, of.officeName as officeName 
           FROM office of) AS j2
           ON ticketDetail.officeId = j2.refId
       LEFT JOIN (SELECT st._id refId, st.name as serviceTypeName 
           FROM bloomServiceType st) AS j3
           ON ticketDetail.serviceTypeId = j3.refId           
       LEFT JOIN (SELECT sp._id refId, sp.name as statusName 
           FROM bloomStatusType sp) AS j4
           ON ticketDetail.statusId = j4.refId           
       LEFT JOIN (SELECT aa._id refId, aa.name as applicantAreaName 
           FROM bloomApplicantArea aa) AS j5
           ON ticketDetail.applicantAreaId = j5.refId            
       LEFT JOIN (SELECT bu.blackstarUserId refId, bu.name createdByUsrName
           FROM blackstaruser bu) AS j6
           ON ticketDetail.createdByUsr = j6.refId
       LEFT JOIN (SELECT bu.blackstarUserId refId, bu.name modifiedByUsrName
           FROM blackstaruser bu) AS j7
           ON ticketDetail.modifiedByUsr = j7.refId);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomTicketTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.GetBloomTicketTeam$$
CREATE PROCEDURE blackstardb.`GetBloomTicketTeam`(ticket INTEGER)
BEGIN

SELECT *
FROM ((SELECT _id id, ticketId ticketId, workerRoleTypeId workerRoleTypeId, blackstarUserId blackstarUserId, assignedDate assignedDate
       FROM bloomTicketTeam WHERE ticketId = ticket) AS ticketTeam
       LEFT JOIN (SELECT bu.blackstarUserId refId, bu.name blackstarUserName
           FROM blackstaruser bu) AS j1
           ON ticketTeam.applicantUserId = j1.refId
       LEFT JOIN (SELECT wrt._id refId, wrt.name as workerRoleTypeName 
           FROM bloomWorkerRoleType wrt) AS j2
           ON ticketTeam.workerRoleTypeId = j2.refId);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToBloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.AddFollowUpToBloomTicket$$
CREATE PROCEDURE blackstardb.`AddFollowUpToBloomTicket`(pTicketId INTEGER, pCreatedByUsrId INTEGER, pMessage TEXT)
BEGIN
  DECLARE pCreatedByUsrMail VARCHAR(100);
  
  SET pCreatedByUsrMail = (SELECT email FROM blackstaruser WHERE blackstarUserId = pCreatedByUsrId);
	INSERT INTO blackstarDb.followUp(bloomTicketId, followup, created, createdBy, createdByUsr)
	VALUES(pTicketId, pMessage, NOW(), 'AddFollowUpToBloomTicket', pCreatedByUsrMail);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertBloomTicketTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.UpsertBloomTicketTeam$$
CREATE PROCEDURE blackstardb.`UpsertBloomTicketTeam`(pTicketId INTEGER, pWorkerRoleTypeId INTEGER, pBlackstarUserId INTEGER)
BEGIN

IF NOT EXISTS (SELECT * FROM bloomTicketTeam 
               WHERE ticketId = pTicketId AND blackstarUserId = pBlackstarUserId) THEN
    INSERT INTO blackstarDb.bloomTicketTeam(ticketId, workerRoleTypeId, blackstarUserId, assignedDate)
    VALUES(pTicketId, pWorkerRoleTypeId, pBlackstarUserId, NOW());   
ELSE
   UPDATE blackstarDb.bloomTicketTeam SET assignedDate = NOW(), workerRoleTypeId = pWorkerRoleTypeId
   WHERE ticketId = pTicketId AND blackstarUserId = pBlackstarUserId;
END IF;
IF (pWorkerRoleTypeId = 1) THEN
    UPDATE blackstarDb.bloomTicketTeam SET workerRoleTypeId = 2
    WHERE ticketId = pTicketId AND blackstarUserId != pBlackstarUserId;
END IF;
    
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomFollowUpByTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.GetBloomFollowUpByTicket$$
CREATE PROCEDURE blackstardb.`GetBloomFollowUpByTicket`(pTicketId INTEGER)
BEGIN
	SELECT created AS created, u2.name AS createdByUsr, u.name AS asignee, followup AS followup
	FROM followUp f
		   LEFT OUTER JOIN blackstarUser u ON f.asignee = u.email
		   LEFT OUTER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE bloomTicketId = pTicketId
	ORDER BY created;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomDeliverableType
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.GetBloomDeliverableType$$
CREATE PROCEDURE blackstardb.`GetBloomDeliverableType`()
BEGIN
	SELECT _id id, name name, description description FROM bloomDeliverableType;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddBloomDelivarable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.AddBloomDelivarable$$
CREATE PROCEDURE blackstardb.`AddBloomDelivarable`(pTicketId INTEGER, pDeliverableTypeId INTEGER)
BEGIN
DECLARE counter INTEGER;

  SET counter = (SELECT count(*) 
                 FROM bloomDeliverableTrace 
                 WHERE bloomTicketId = pTicketId AND deliverableTypeId = pDeliverableTypeId);
  IF (counter > 0) THEN
    UPDATE bloomDeliverableTrace SET delivered = 1, date = NOW();
  ELSE 
	  INSERT INTO bloomDeliverableTrace (bloomTicketId, deliverableTypeId, delivered, date)
    VALUES (pTicketId, pDeliverableTypeId, 1, NOW());
  END IF;  
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomTicketResponsible
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.GetBloomTicketResponsible$$
CREATE PROCEDURE blackstardb.`GetBloomTicketResponsible`(pTicketId INTEGER)
BEGIN

DECLARE responsableId INTEGER;

SET responsableId = (SELECT blackstarUserId 
                     FROM bloomTicketTeam 
                     WHERE ticketId = pTicketId
                           AND workerRoleTypeId = 1
                     LIMIT 1);
SELECT * 
FROM blackstaruser
WHERE blackstarUserId = responsableId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomTicketResponsible
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.GetBloomTicketUserForResponse$$
CREATE PROCEDURE blackstardb.`GetBloomTicketUserForResponse`(pTicketId INTEGER)
BEGIN

DECLARE responseUserId INTEGER;

SET responseUserId = (SELECT blackstarUserId 
                     FROM bloomTicketTeam 
                     WHERE ticketId = pTicketId
                           AND workerRoleTypeId = 2
                     ORDER BY assignedDate DESC
                     LIMIT 1);
SELECT * 
FROM blackstaruser
WHERE blackstarUserId = responseUserId;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomTicketResponsible
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.GetUserById$$
CREATE PROCEDURE blackstardb.`GetUserById`(pId INTEGER)
BEGIN

        SELECT u.blackstarUserId blackstarUserId, u.email userEmail, u.name userName
        FROM blackstarUser u
        WHERE u.blackstarUserId = pId;
        
END$$



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

select a.deliverableTypeId as id, b.name as label from bloomRequiredDeliverable a
INNER JOIN bloomDeliverableType b on (b._id =a.deliverableTypeId)
WHERE a.serviceTypeId =paramServiceTypeId
AND a.deliverableTypeId != -1
ORDER BY a.deliverableTypeId;

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
	-- blackstarDb.getBloomServiceType
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomServiceType$$
CREATE PROCEDURE blackstarDb.getBloomServiceType()
BEGIN
SELECT _ID as id ,NAME AS label, responseTime FROM bloomServiceType
WHERE _ID != -1
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
	-- blackstarDb.AddInternalTicket
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
  reponseInTime Tinyint)
BEGIN
	INSERT INTO bloomTicket
(applicantUserId,officeId,serviceTypeId,statusId,
applicantAreaId,dueDate,project,ticketNumber,
description,created,createdBy,createdByUsr,reponseInTime)
VALUES
(applicantUserId,officeId,serviceTypeId,statusId,
applicantAreaId,dueDate,project,ticketNumber,
description,created,createdBy,createdByUsr,reponseInTime);
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
(ticketId,workerRoleTypeId,blackstarUserId)
VALUES
(ticketId,workerRoleTypeId,blackstarUserId);
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
	-- blackstarDb.CloseBloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CloseBloomTicket;
CREATE PROCEDURE blackstardb.`CloseBloomTicket`(pTicketId INTEGER, pUserId INTEGER)
BEGIN
	
DECLARE inTime TINYINT DEFAULT 1;
DECLARE desv FLOAT (30,20);
DECLARE endDate DATETIME;
DECLARE today DATETIME DEFAULT NOW();

DELETE FROM messages;

INSERT INTO messages values (pTicketId);
SET endDate = (SELECT dueDate FROM bloomticket WHERE _id = pTicketId);
INSERT INTO messages values (endDate);
SET desv =  TO_DAYS(today) - TO_DAYS(endDate);


INSERT INTO messages values (TO_DAYS(today));

IF(desv > 0) THEN
   SET inTime = 0;
END IF;

UPDATE bloomTicket 
SET statusId = 5, reponseInTime = inTime, desviation = desv, modified = today
  , responseDate = today, modifiedBy = "CloseBloomTicket", modifiedByUsr = pUserId
WHERE _ID = pTicketId;
	
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
								AND t.statusId=5 --ticktes cerrados
								AND ug.userGroupId= userGroupIdParam --id perfil groupId
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

END;

DELIMITER ;