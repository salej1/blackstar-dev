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


DELIMITER ;