-- -----------------------------------------------------------------------------
-- File:	bloomDb_StoredProcedures.sql   
-- Name:	bloomDb_StoredProcedures
-- Desc:	Crea o actualiza los Stored procedures operativos de la aplicacion
-- Auth:	Oscar Martinez
-- Date:	08/04/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ----------------------------------------------------
-- 1    20/03/2014	DCB		Se Integran los SP iniciales:
--								blackstarDb.BloomUpdateTickets
--								blackstarDb.BloomUpdateTransferFollow
--								blackstarDb.BloomUpdateTransferTeam
-- 								blackstarDb.BloomUpdateTransferUsers
-- 								blackstarDb.BloomTransfer
-- 2    24/03/2014	DCB		Se Integra blackstarDb.GetbloomTicketDetail
-- 3    24/03/2014	DCB		Se Integra blackstarDb.GetbloomTicketTeam
-- 4    28/03/2014	DCB		Se Integra blackstarDb.AddFollowUpTobloomTicket
--                          Se Integra blackstarDb.UpsertbloomTicketTeam
--                          Se Integra blackstarDb.GetBloomFollowUpByTicket
-- 5    31/03/2014  DCB     Se integra blackstarDb.GetBloomDeliverableType  
--                  DCB     Se integra blackstarDb.AddBloomDelivarable  
-- 5    02/04/2014  DCB     Se integra blackstarDb.GetbloomTicketResponsible
--                  DCB     Se integra blackstarDb.GetUserById
-- 6    03/04/2014  DCB     Se integra blackstarDb.ClosebloomTicket

-- 7     08/05/2014  OMA	blackstarDb.getBloomPendingTickets
-- 8     08/05/2014  OMA	blackstarDb.getbloomTickets
-- 9     08/05/2014  OMA	blackstarDb.getBloomDocumentsByService
-- 10    08/05/2014  OMA 	blackstarDb.getBloomProjects
-- 11    08/05/2014  OMA 	blackstarDb.getbloomApplicantArea
-- 12    08/05/2014  OMA 	blackstarDb.getBloomServiceType
-- 13    08/05/2014  OMA 	blackstarDb.getBloomOffice
-- 14    08/05/2014  OMA 	blackstarDb.GetNextInternalTicketNumber
-- 15    08/05/2014  OMA 	blackstarDb.AddInternalTicket
-- 16    08/05/2014  OMA 	blackstarDb.AddMemberTicketTeam
-- 17    08/05/2014  OMA 	blackstarDb.AddDeliverableTrace
-- 18    08/05/2014  OMA	blackstarDb.GetUserData (MODIFICADO:Sobrescribimos la version anterior)
-- 19    08/05/2014  OMA	blackstarDb.getBloomEstatusTickets

-- 19    16/05/2014  OMA	blackstarDb.GetBloomSupportAreasWithTickets
-- 20    16/05/2014  OMA	blackstarDb.GetBloomStatisticsByAreaSupport
-- 21    16/05/2014  OMA	blackstarDb.GetBloomPercentageTimeClosedTickets
-- 22    16/05/2014  OMA	blackstarDb.GetBloomPercentageEvaluationTickets
-- 23    16/05/2014  OMA	blackstarDb.GetBloomNumberTicketsByArea
-- 24    16/05/2014  OMA	blackstarDb.GetBloomUnsatisfactoryTicketsByUserByArea
-- 25    16/05/2014  OMA	blackstarDb.GetBloomHistoricalTickets
-- 26    22/06/2014  OMA	blackstarDb.getBloomAdvisedUsers
--
-- ------------------------------------------------------------------------------
-- 27   29/06/2014  SAG   Correcciones de integracion:
--                          blackstarDb.AddMemberTicketTeam
-- ------------------------------------------------------------------------------
-- 28   10/07/2014  SAG   Se modifica:
--                          blackstarDb.AddInternalTicket
-- ------------------------------------------------------------------------------

use blackstarDb;


DELIMITER $$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetBloomTicketId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomTicketId$$
CREATE PROCEDURE blackstarDb.GetBloomTicketId(pTicketNumber VARCHAR(100))
BEGIN
  SELECT _id FROM bloomTicket WHERE ticketNumber = pTicketNumber;
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.BloomUpdateTickets
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS blackstarDb.BloomUpdateTickets$$
CREATE FUNCTION blackstarDb.`BloomUpdateTickets`() RETURNS int(11)
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
      SET createdByUsrId = IFNULL((SELECT blackstarUserId from blackstarUser WHERE email = 'portal-servicios@gposac.com.mx'), -1);                               
      SET applicantUserId = IFNULL((SELECT blackstarUserId from blackstarUser WHERE email = createdByUsr), -1);
      SET officeL = IFNULL((SELECT officeId from office WHERE officeName = officeStr), '?');
      SET serviceTypeId = IFNULL((SELECT _id from bloomServiceType WHERE name = serviceType), -1);
      SET applicantAreaId = IFNULL((SELECT _id from bloomApplicantArea WHERE name = applicantArea), -1);
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
      INSERT INTO bloomTicket(applicantUserId, officeId, serviceTypeId, statusId, applicantAreaId
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
DROP FUNCTION IF EXISTS blackstarDb.BloomUpdateTransferFollow$$
CREATE FUNCTION blackstarDb.`BloomUpdateTransferFollow`() RETURNS int(11)
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
      SET ticketId =(SELECT _id from bloomTicket WHERE ticketNumber = ticket);
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
DROP FUNCTION IF EXISTS blackstarDb.BloomUpdateTransferTeam$$
CREATE FUNCTION blackstarDb.`BloomUpdateTransferTeam`() RETURNS int(11)
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
  -- INSERT INTO messages VALUES ('INICIO');
  loop_lbl: LOOP
      FETCH transfer_cursor INTO ticket, userName;
      IF done = 1 THEN 
			   LEAVE loop_lbl;
		  END IF;
      -- INSERT INTO messages VALUES (CONCAT('TICKET: ', ticket));
      SET ticketId =(SELECT _id from bloomTicket WHERE ticketNumber = ticket);
      -- INSERT INTO messages VALUES (CONCAT('TICKET_ID: ', ticketId));
      -- INSERT INTO messages VALUES (CONCAT('USER: ', userName));
      SET userId = IFNULL((SELECT blackstarUserId from blackstarUser WHERE name LIKE CONCAT(userName,'%')), -1);
      -- INSERT INTO messages VALUES (CONCAT('USER_ID: ', userId));
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
DROP FUNCTION IF EXISTS blackstarDb.BloomUpdateTransferUsers$$
CREATE FUNCTION blackstarDb.`BloomUpdateTransferUsers`() RETURNS int(11)
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
     WHERE createdByUsr NOT IN (SELECT email FROM blackstarUser);

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
DROP PROCEDURE IF EXISTS blackstarDb.BloomTransfer$$
CREATE PROCEDURE blackstarDb.`BloomTransfer`()
BEGIN

  DECLARE auxInt INTEGER;

  -- DELETE FROM messages;
  SET auxInt = BloomUpdateTransferUsers();
  -- INSERT INTO messages VALUES (CONCAT('USERS FROM TRANSFER: ', auxInt));
  SET auxInt = BloomUpdateTickets();
  -- INSERT INTO messages VALUES (CONCAT('TICKETS FROM TRANSFER: ', auxInt));
  SET auxInt = BloomUpdateTransferTeam();
  -- INSERT INTO messages VALUES (CONCAT('TEAMS FROM TRANSFER: ', auxInt));
  SET auxInt = BloomUpdateTransferFollow();
  -- INSERT INTO messages VALUES (CONCAT('FOLLOWS FROM TRANSFER: ', auxInt));
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetbloomTicketDetail
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketDetail$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketDetail`(ticketId INTEGER)
BEGIN

SELECT *
FROM ((SELECT *
       FROM bloomTicket WHERE _ID = ticketId) AS ticketDetail
       LEFT JOIN (SELECT bu.blackstarUserId refId, bu.name applicantUserName
           FROM blackstarUser bu) AS j1
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
           FROM blackstarUser bu) AS j6
           ON ticketDetail.createdByUsr = j6.refId
       LEFT JOIN (SELECT bu.blackstarUserId refId, bu.name modifiedByUsrName
           FROM blackstarUser bu) AS j7
           ON ticketDetail.modifiedByUsr = j7.refId);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetbloomTicketTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketTeam$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketTeam`(ticket INTEGER)
BEGIN

SELECT *
FROM (
  (SELECT _id id, ticketId ticketId, workerRoleTypeId workerRoleTypeId, blackstarUserId blackstarUserId, assignedDate assignedDate
       FROM bloomTicketTeam WHERE ticketId = ticket
  ) AS ticketTeam
       LEFT JOIN (SELECT bu.blackstarUserId refId, bu.name blackstarUserName
           FROM blackstarUser bu
        ) AS j1 ON ticketTeam.blackstarUserId = j1.refId
       LEFT JOIN (SELECT wrt._id refId, wrt.name as workerRoleTypeName 
           FROM bloomWorkerRoleType wrt
        ) AS j2 ON ticketTeam.workerRoleTypeId = j2.refId
);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpTobloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpTobloomTicket$$
CREATE PROCEDURE blackstarDb.`AddFollowUpTobloomTicket`(pTicketId INTEGER, pCreatedByUsrId INTEGER, pMessage TEXT)
BEGIN
  DECLARE pCreatedByUsrMail VARCHAR(100);
  
  SET pCreatedByUsrMail = (SELECT email FROM blackstarUser WHERE blackstarUserId = pCreatedByUsrId);
	INSERT INTO blackstarDb.followUp(bloomTicketId, followup, created, createdBy, createdByUsr)
	VALUES(pTicketId, pMessage, NOW(), 'AddFollowUpTobloomTicket', pCreatedByUsrMail);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertbloomTicketTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertbloomTicketTeam$$
CREATE PROCEDURE blackstarDb.`UpsertbloomTicketTeam`(pTicketId INTEGER, pWorkerRoleTypeId INTEGER, pblackstarUserId INTEGER)
BEGIN

IF NOT EXISTS (SELECT * FROM bloomTicketTeam 
               WHERE ticketId = pTicketId AND blackstarUserId = pblackstarUserId) THEN
    INSERT INTO blackstarDb.bloomTicketTeam(ticketId, workerRoleTypeId, blackstarUserId, assignedDate)
    VALUES(pTicketId, pWorkerRoleTypeId, pblackstarUserId, NOW());   
ELSE
   UPDATE blackstarDb.bloomTicketTeam SET 
      assignedDate = NOW(), 
      workerRoleTypeId = pWorkerRoleTypeId
   WHERE ticketId = pTicketId 
    AND blackstarUserId = pblackstarUserId;
END IF;
    
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomFollowUpByTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomFollowUpByTicket$$
CREATE PROCEDURE blackstarDb.`GetBloomFollowUpByTicket`(pTicketId INTEGER)
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
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomDeliverableType$$
CREATE PROCEDURE blackstarDb.`GetBloomDeliverableType`(pServiceTypeId INTEGER)
BEGIN
	SELECT 
    _id id, name name, description description 
  FROM bloomDeliverableType
  WHERE serviceTypeId = pServiceTypeId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddBloomDelivarable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddBloomDelivarable$$
CREATE PROCEDURE blackstarDb.`AddBloomDelivarable`(pTicketId INTEGER, pDeliverableTypeId INTEGER, docId VARCHAR(200))
BEGIN
DECLARE counter INTEGER;

  SET counter = (SELECT count(*) 
                 FROM bloomDeliverableTrace 
                 WHERE bloomTicketId = pTicketId AND deliverableTypeId = pDeliverableTypeId);
  IF (counter > 0) THEN
    UPDATE bloomDeliverableTrace SET delivered = 1, date = NOW();
  ELSE 
	  INSERT INTO bloomDeliverableTrace (bloomTicketId, deliverableTypeId, delivered, date, docId)
    VALUES (pTicketId, pDeliverableTypeId, 1, NOW(), docId);
  END IF;  
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetbloomTicketResponsible
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketResponsible$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketResponsible`(pTicketId INTEGER)
BEGIN

DECLARE responsableId INTEGER;

SET responsableId = (SELECT blackstarUserId 
                     FROM bloomTicketTeam 
                     WHERE ticketId = pTicketId
                           AND workerRoleTypeId = 1
                     LIMIT 1);
SELECT * 
FROM blackstarUser
WHERE blackstarUserId = responsableId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetbloomTicketResponsible
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketUserForResponse$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketUserForResponse`(pTicketId INTEGER)
BEGIN

DECLARE responseUserId INTEGER;

SET responseUserId = (SELECT blackstarUserId 
                     FROM bloomTicketTeam 
                     WHERE ticketId = pTicketId
                           AND workerRoleTypeId = 2
                     ORDER BY assignedDate DESC
                     LIMIT 1);
SELECT * 
FROM blackstarUser
WHERE blackstarUserId = responseUserId;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetbloomTicketResponsible
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserById$$
CREATE PROCEDURE blackstarDb.`GetUserById`(pId INTEGER)
BEGIN

        SELECT u.blackstarUserId blackstarUserId, u.email userEmail, u.name userName
        FROM blackstarUser u
        WHERE u.blackstarUserId = pId;
        
END$$



-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomPendingTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomPendingTickets$$
CREATE PROCEDURE blackstarDb.`getBloomPendingTickets`(UserId INTEGER)
BEGIN
  SELECT DISTINCT
    ti._id as id,
    ti.ticketNumber,
    ti.created,
    ti.applicantAreaId, 
    ti.dueDate, 
    ti.desiredDate, 
    ba.name as areaName,
    ti.serviceTypeId,
    st.name as serviceName,
    st.responseTime,
    ti.project,
    ti.officeId, 
    o.officeName,
    ti.statusId,
    s.name as statusTicket,
    a.bloomServiceArea as serviceArea
  FROM bloomTicket ti
       INNER JOIN bloomTicketTeam tm on (ti._id = tm.ticketId)
       INNER JOIN bloomApplicantArea ba on (ba._id = ti.applicantAreaId)
       INNER JOIN bloomServiceType st on (st._id = ti.serviceTypeId)
       INNER JOIN office o on (o.officeId = ti.officeId)
       INNER JOIN bloomStatusType s on (s._id = ti.statusId)
       INNER JOIN bloomServiceArea a ON a.bloomServiceAreaId = st.bloomServiceAreaId
  WHERE tm.blackstarUserId = UserId 
      AND tm.workerRoleTypeId = 1
      AND ti.statusId < 6 
      AND ti.statusId != 4
  ORDER BY ti.statusId, ti.created;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.getbloomTickets vista para el coordinador.
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getbloomTickets$$
CREATE PROCEDURE blackstarDb.getbloomTickets(UserId INTEGER)
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
	-- blackstarDb.getbloomApplicantArea
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getbloomApplicantArea$$
CREATE PROCEDURE blackstarDb.getbloomApplicantArea()
BEGIN
SELECT _ID as id ,NAME AS label FROM bloomApplicantArea
WHERE _ID != -1
ORDER BY _ID;
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomServiceType       SE MODIFICO PARA LA FASE 2
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomServiceType$$
CREATE PROCEDURE blackstarDb.getBloomServiceType(applicantAreaIdParam INTEGER)
BEGIN
SELECT _ID as id ,NAME AS label, responseTime FROM bloomServiceType
WHERE _ID != -1
AND applicantAreaId = applicantAreaIdParam
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
	-- blackstarDb.AddInternalTicket   SE MODIFICO PARA LA FASE 2
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
  reponseInTime Tinyint,
	purposeVisitVL Varchar(2500),
	purposeVisitVISAS Varchar(2500),
	draftCopyDiagramVED Varchar(2500),
	formProjectVED Varchar(2500),
	observationsVEPI Varchar(2500),
	draftCopyPlanVEPI Varchar(2500),
	formProjectVEPI Varchar(2500),
	observationsVRCC Varchar(2500),
	checkListVRCC Varchar(2500),
	formProjectVRCC Varchar(2500),
	questionVPT Varchar(2500),
	observationsVSA Varchar(2500),
	formProjectVSA Varchar(2500),
	productInformationVSP Varchar(2500),
	observationsISED Varchar(2500),
	draftCopyPlanISED Varchar(2500),
	observationsISRC Varchar(2500),
	attachmentsISRC Varchar(2500),
	apparatusTraceISSM Varchar(2500),
	observationsISSM Varchar(2500),
	questionISSM Varchar(2500),
	ticketISRPR Varchar(2500),
	modelPartISRPR Varchar(2500),
	observationsISRPR Varchar(2500),
	productInformationISSPC Varchar(2500),
	positionPGCAS Varchar(2500),
	collaboratorPGCAS Varchar(2500),
	justificationPGCAS Varchar(2500),
	salaryPGCAS Varchar(2500),
	positionPGCCP Varchar(2500),
	commentsPGCCP Varchar(2500),
	developmentPlanPGCCP Varchar(2500),
	targetPGCCP Varchar(2500),
	salaryPGCCP Varchar(2500),
	positionPGCNC Varchar(2500),
	developmentPlanPGCNC Varchar(2500),
	targetPGCNC Varchar(2500),
	salaryPGCNC Varchar(2500),
	justificationPGCNC Varchar(2500),
	positionPGCF Varchar(2500),
	collaboratorPGCF Varchar(2500),
	justificationPGCF Varchar(2500),
	positionPGCAA Varchar(2500),
	collaboratorPGCAA Varchar(2500),
	justificationPGCAA Varchar(2500),
	requisitionFormatGRC Varchar(2500),
	linkDocumentGM Varchar(2500),
	suggestionGSM Varchar(2500),
	documentCodeGSM Varchar(2500),
	justificationGSM Varchar(2500),
	problemDescriptionGPTR Varchar(2500),
  desiredDate DATETIME
  )
BEGIN
	INSERT INTO bloomTicket
(applicantUserId,officeId,serviceTypeId,statusId,
applicantAreaId,dueDate,project,ticketNumber,
description,created,createdBy,createdByUsr,reponseInTime,
purposeVisitVL,purposeVisitVISAS,draftCopyDiagramVED,formProjectVED,observationsVEPI,
draftCopyPlanVEPI,formProjectVEPI,observationsVRCC,checkListVRCC,formProjectVRCC,
questionVPT,observationsVSA,formProjectVSA,productInformationVSP,observationsISED,
draftCopyPlanISED,observationsISRC,attachmentsISRC,apparatusTraceISSM,observationsISSM,
questionISSM,ticketISRPR,modelPartISRPR,observationsISRPR,productInformationISSPC,
positionPGCAS,collaboratorPGCAS,justificationPGCAS,salaryPGCAS,positionPGCCP,
commentsPGCCP,developmentPlanPGCCP,targetPGCCP,salaryPGCCP,positionPGCNC,
developmentPlanPGCNC,targetPGCNC,salaryPGCNC,justificationPGCNC,positionPGCF,
collaboratorPGCF,justificationPGCF,positionPGCAA,collaboratorPGCAA,justificationPGCAA,
requisitionFormatGRC,linkDocumentGM,suggestionGSM,documentCodeGSM,justificationGSM,
problemDescriptionGPTR, desiredDate)
VALUES
(applicantUserId,officeId,serviceTypeId,statusId,
applicantAreaId,dueDate,project,ticketNumber,
description,created,createdBy,createdByUsr,reponseInTime,
purposeVisitVL,purposeVisitVISAS,draftCopyDiagramVED,formProjectVED,observationsVEPI,
draftCopyPlanVEPI,formProjectVEPI,observationsVRCC,checkListVRCC,formProjectVRCC,
questionVPT,observationsVSA,formProjectVSA,productInformationVSP,observationsISED,
draftCopyPlanISED,observationsISRC,attachmentsISRC,apparatusTraceISSM,observationsISSM,
questionISSM,ticketISRPR,modelPartISRPR,observationsISRPR,productInformationISSPC,
positionPGCAS,collaboratorPGCAS,justificationPGCAS,salaryPGCAS,positionPGCCP,
commentsPGCCP,developmentPlanPGCCP,targetPGCCP,salaryPGCCP,positionPGCNC,
developmentPlanPGCNC,targetPGCNC,salaryPGCNC,justificationPGCNC,positionPGCF,
collaboratorPGCF,justificationPGCF,positionPGCAA,collaboratorPGCAA,justificationPGCAA,
requisitionFormatGRC,linkDocumentGM,suggestionGSM,documentCodeGSM,justificationGSM,
problemDescriptionGPTR, desiredDate);
select LAST_INSERT_ID();
END$$




-- -----------------------------------------------------------------------------
	-- blackstarDb.AddMemberTicketTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddMemberTicketTeam$$
CREATE PROCEDURE blackstarDb.AddMemberTicketTeam (pTicketId Int(11),  pWorkerRoleTypeId Int(11),  pBlackstarUserId Int(11))
BEGIN

  IF (SELECT count(*) FROM bloomTicketTeam WHERE ticketId = pTicketId AND blackstarUserId = pBlackstarUserId) = 0 THEN
    INSERT INTO bloomTicketTeam
      (ticketId,workerRoleTypeId,blackstarUserId,assignedDate)
    VALUES 
      (pTicketId,pWorkerRoleTypeId,pBlackstarUserId,CURRENT_TIMESTAMP());
    SELECT LAST_INSERT_ID();
  ELSE
    UPDATE bloomTicketTeam SET
      workerRoleTypeId = pWorkerRoleTypeId,
      assignedDate = now()
    WHERE ticketId = pTicketId AND blackstarUserId = pBlackstarUserId;
    SELECT 0;
  END IF;
	
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
  -- blackstarDb.ClosebloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.ClosebloomTicket$$
CREATE PROCEDURE blackstarDb.`ClosebloomTicket`(pTicketId INTEGER, pUserId INTEGER, pStatusId INTEGER)
BEGIN

DECLARE inTime TINYINT DEFAULT 1;
DECLARE elapsed FLOAT (30,20);
DECLARE createdDate DATETIME;
DECLARE today DATETIME DEFAULT NOW();
DECLARE required INT;

SET createdDate = (SELECT created FROM bloomTicket WHERE _id = pTicketId);
SET elapsed =  TO_DAYS(today) - TO_DAYS(createdDate);
SET required = (SELECT bst.responseTime 
                FROM bloomTicket bt, bloomServiceType bst
                WHERE bt.serviceTypeId = bst._id 
                       AND bt._id = pTicketId);

IF(elapsed > required) THEN
   SET inTime = 0;
END IF;

UPDATE bloomTicket 
SET statusId = pStatusId, reponseInTime = inTime, desviation = (elapsed - required), modified = today
  , responseDate = today, modifiedBy = "ClosebloomTicket", modifiedByUsr = pUserId
WHERE _ID = pTicketId;

END$$

DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByUserKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByUserKPI`()
BEGIN

SELECT bu.name name, bu.email email, aa.name applicantArea, count(*) counter
FROM bloomTicket bt, blackstarUser bu, bloomApplicantArea aa
WHERE bt.applicantUserId = bu.blackstarUserId
      AND bt.applicantAreaId = aa._id
GROUP BY bt.applicantUserId
ORDER BY counter desc;

END$$


DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByOfficeKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByOfficeKPI`()
BEGIN

SELECT of.officeName officeName, count(*) counter
FROM bloomTicket bt, office of
WHERE bt.officeId = of.officeId
GROUP BY bt.officeId
ORDER BY counter desc;

END$$

DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByAreaKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByAreaKPI`()
BEGIN
SELECT aa.name applicantArea, count(*) counter
FROM bloomTicket bt, bloomApplicantArea aa
WHERE  bt.applicantAreaId = aa._id
GROUP BY bt.applicantAreaId
ORDER BY counter desc;
END$$


DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByDayKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByDayKPI`()
BEGIN
  SELECT DATE_FORMAT(created,'%d/%m/%Y') created, count(*) counter
  FROM bloomTicket
GROUP BY DATE_FORMAT(created,'%d/%m/%Y');
END$$

DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByProjectKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByProjectKPI`()
BEGIN
SELECT bt.project project, count(*) counter
FROM bloomTicket bt
WHERE bt.project IS NOT NULL
      AND bt.project <> ''
      AND bt.project <> 'NA'
      AND bt.project <> 'N/A'
GROUP BY bt.project
ORDER BY counter DESC
LIMIT 5;
END$$

DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByServiceAreaKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByServiceAreaKPI`()
BEGIN
SELECT aa.name applicantArea, st.name serviceType , count(*) counter
FROM bloomTicket bt, bloomApplicantArea aa, bloomServiceType st
WHERE bt.serviceTypeId = st._id
      AND bt.applicantAreaId = aa._id
GROUP BY bt.applicantAreaId, bt.serviceTypeId;
END$$

DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketDeliverable$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketDeliverable`(pTicketId INTEGER)
BEGIN

  SELECT 
    bdt._id id, 
    bdt.name name, 
    IF(bd._id IS NOT NULL, true, false) AS delivered,
    bd.docId docId
  FROM bloomTicket bt
    INNER JOIN bloomDeliverableType bdt ON bt.serviceTypeId = bdt.serviceTypeId
    LEFT OUTER JOIN  bloomDeliverableTrace bd ON bd.bloomTicketId = bt._id AND bd.deliverableTypeId = bdt._id
  WHERE bt._id = pTicketId;

END$$ 

DROP PROCEDURE IF EXISTS blackstarDb.GetbloomSurveyTable$$
CREATE PROCEDURE blackstarDb.`GetbloomSurveyTable`(pTicketId INTEGER)
BEGIN
SELECT bs._id id, bt.ticketNumber ticketNumber, baa.name applicantArea
       , bt.project project, bs.created created, bs.evaluation evaluation
FROM bloomTicket bt , bloomSurvey bs, bloomApplicantArea baa
WHERE bt._id = bs.bloomTicketId
      AND baa._id = bt.applicantAreaId
      AND bt.createdByUsr = pTicketId;
END$$

DROP PROCEDURE IF EXISTS blackstarDb.GetBloomPendingSurveyTable$$
CREATE PROCEDURE blackstarDb.`GetBloomPendingSurveyTable`(pTicketId INTEGER)
BEGIN
SELECT distinct bt.ticketNumber ticketNumber, baa.name applicantArea, bt.project project,
       GROUP_CONCAT(DISTINCT bu.name ORDER BY bu.name SEPARATOR ', ') AS risponsableName
FROM bloomTicket bt, bloomApplicantArea baa, blackstarUser bu, bloomTicketTeam btt
WHERE createdByUsr = pTicketId
      AND bt.applicantAreaId = baa._id
      AND btt.ticketId = bt._id
      AND btt.workerRoleTypeId = 1
      AND btt.blackstarUserId = bu.blackstarUserId
      AND NOT EXISTS (SELECT * 
                      FROM bloomSurvey bs 
                      WHERE bt._id = bs.bloomTicketId)
      GROUP BY bt._id;
END$$

DROP PROCEDURE IF EXISTS blackstarDb.InsertbloomSurvey$$
CREATE PROCEDURE blackstarDb.`InsertbloomSurvey`(pTicketId INTEGER, pEvaluation INTEGER, pComments TEXT, pCreated DATE)
BEGIN
  INSERT INTO bloomSurvey (bloomTicketId, evaluation, comments, created ) 
  VALUES(pTicketId, pEvaluation, pComments, pCreated);
END$$

DROP PROCEDURE IF EXISTS blackstarDb.GetBloomPendingSurveys$$
CREATE PROCEDURE blackstarDb.`GetBloomPendingSurveys`()
BEGIN

SELECT bt._id id, bt.ticketNumber ticketNumber, bt.description description,
       bt.responseDate responseDate, bu.email email, bu.name name
FROM bloomTicket bt, blackstarUser bu
WHERE bt.statusId = 6
     AND bt.applicantUserId = bu.blackstarUserId
     AND bt.responseDate < DATE_ADD(NOW(), INTERVAL -2 DAY);
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
					AND t.statusId=6
					AND bu.blackstarUserId <> t.createdByUsr -- que no sea el creador
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
								AND t.statusId=6 -- ticktes cerrados
								AND ug.userGroupId= userGroupIdParam -- id perfil groupId
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
		WHERE t.statusId=6 -- tickets cerrados
		AND t.created>= startCreationDate
		AND t.created <= endCreationDate
		and date(t.responseDate) <= t.dueDate) as satisfactory);

	SET noTicketsUnsatisfactory = (select count(id) from (
		select t._id as id, t.created ,t.dueDate,t.responseDate,date(t.responseDate),t.statusId from bloomTicket t
		WHERE t.statusId=6 -- tickets cerrados 
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
		WHERE t.evaluation>=initEvaluationValue
		AND t.statusId=6 -- tickets cerrados
		AND t.created>= startCreationDate
		AND t.created <= endCreationDate
		) as evaluation);

	SET noTicketsEvaluationUnsatisfactory = (select count(id) from (
		select t._id as id, t.evaluation, t.created ,t.dueDate,t.responseDate,date(t.responseDate),t.statusId from bloomTicket t
		WHERE t.evaluation<initEvaluationValue
		AND t.statusId=6 -- tickets cerrados
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
						AND t.statusId=6 -- tickets cerrados
						AND t.created>= startCreationDate
						AND t.created <= endCreationDate
						AND bu.blackstarUserId <> t.createdByUsr -- que no sea el creador
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
									AND t.statusId=6     -- tickets cerrados
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
CREATE PROCEDURE blackstarDb.GetBloomHistoricalTickets(statusTicket INT, startCreationDate DATETIME, endCreationDate DATETIME, showHidden INT)
BEGIN

  IF(statusTicket <= 0) THEN
    SELECT 
      ti._id AS id, 
      ti.ticketNumber, 
      ti.created AS created,
      ti.applicantAreaId, 
      ba.name AS areaName, 
      ti.serviceTypeId, 
      st.name AS serviceName, 
      st.responseTime, 
      ti.project, 
      ti.officeId, 
      o.officeName,
      ti.statusId, 
      s.name AS statusTicket,
      ti.dueDate AS dueDate,
      ti.desiredDate AS desiredDate,
      a.bloomServiceArea AS serviceArea
    FROM bloomTicket ti 
      INNER JOIN bloomApplicantArea ba on (ba._id = ti.applicantAreaId) 
      INNER JOIN bloomServiceType st on (st._id = ti.serviceTypeId) 
      INNER JOIN office o on (o.officeId = ti.officeId) 
      INNER JOIN bloomStatusType s on (s._id = ti.statusId)
      INNER JOIN bloomServiceArea a ON st.bloomServiceAreaId = a.bloomServiceAreaId 
    WHERE ti.created >= startCreationDate -- AND ti.created <= endCreationDate
      AND IFNULL(st.hidden, 0) <= showHidden
    ORDER BY ti.created DESC;
  ELSE
    SELECT 
      ti._id AS id, 
      ti.ticketNumber, 
      ti.created AS created,
      ti.applicantAreaId, 
      ba.name AS areaName, 
      ti.serviceTypeId, 
      st.name AS serviceName, 
      st.responseTime, 
      ti.project, 
      ti.officeId, 
      o.officeName,
      ti.statusId, 
      s.name AS statusTicket,
      ti.dueDate AS dueDate,
      ti.desiredDate AS desiredDate,
      a.bloomServiceArea AS serviceArea
    FROM bloomTicket ti 
      INNER JOIN bloomApplicantArea ba on (ba._id = ti.applicantAreaId) 
      INNER JOIN bloomServiceType st on (st._id = ti.serviceTypeId) 
      INNER JOIN office o on (o.officeId = ti.officeId) 
      INNER JOIN bloomStatusType s on (s._id = ti.statusId) 
      INNER JOIN bloomServiceArea a ON st.bloomServiceAreaId = a.bloomServiceAreaId 
    WHERE ti.created >= startCreationDate -- AND ti.created <= endCreationDate
      AND IFNULL(st.hidden, 0) <= showHidden
      AND ti.statusId = statusTicket
    ORDER BY ti.created DESC;
  END IF;

END$$

-- ---------------------------------------------------------------------------------------------------------------------------------------------
	-- FASE DOS DE TICKETS INTERNOS CAMBIO D ESQUEMA A MANEJO DE 4 CORDIANDORES DONDE SE INCLUYE MESA DE AYUDA.
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomAdvisedUsers
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomAdvisedUsers$$
CREATE PROCEDURE blackstarDb.getBloomAdvisedUsers(applicantAreaIdParam INTEGER,serviceTypeIdParam INTEGER)
BEGIN

SELECT DISTINCT 
    u.blackstarUserId as id,
    u.name name,
    u.email email,
    workerRoleTypeId workerRoleTypeId 
FROM blackstarUser u
  INNER JOIN blackstarUser_userGroup ug on (u.blackstarUserId=ug.blackstarUserId)
  INNER JOIN userGroup g on (g.userGroupId=ug.userGroupId)
  INNER JOIN bloomAdvisedGroup ag on (ag.userGroup=g.externalId)
WHERE ag.applicantAreaId=applicantAreaIdParam
  AND ag.serviceTypeId=serviceTypeIdParam;
	
END$$

DELIMITER ;
