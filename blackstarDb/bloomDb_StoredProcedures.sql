-- -----------------------------------------------------------------------------
-- Desc:	Crea o actualiza los Stored procedures operativos de la aplicacion
-- Auth:	Daneil Castillo B.
-- Date:	20/03/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ----------------------------------------------------
-- 01	23/03/2014	 DCB 	Se agrega el campo blackstarUserId a blackstarDb.GetDomainEmployees
-- -----------------------------------------------------------------------------
-- 02   24/03/2014	 DCB	Se Integra blackstarDb.GetBloomTicketDetail
-- -----------------------------------------------------------------------------
-- 03   24/03/2014	 DCB	Se Integra blackstarDb.GetBloomTicketTeam
-- -----------------------------------------------------------------------------
-- 04   28/03/2014	 DCB	Se Integra blackstarDb.AddFollowUpToBloomTicket
--                                     blackstarDb.UpsertBloomTicketTeam
--                                     blackstarDb.GetBloomFollowUpByTicket
-- -----------------------------------------------------------------------------
-- 05   31/03/2014   DCB    Se integra blackstarDb.GetBloomDeliverableType  
--                   DCB               blackstarDb.AddBloomDelivarable  
-- -----------------------------------------------------------------------------
-- 06   02/04/2014   DCB    Se integra blackstarDb.GetBloomTicketResponsible
--                   DCB               blackstarDb.GetUserById
-- -----------------------------------------------------------------------------
-- 07   03/04/2014   DCB    Se integra blackstarDb.CloseBloomTicket
-- -----------------------------------------------------------------------------
-- 08	08/04/2014			Se integra	
--                              bloomDb.GetUserData (MODIFICADO:Sobrescribimos la version anterior)
--								bloomDb.getBloomEstatusTickets
-- 09   15/05/2014  DCB     Se integra 
--                              blackstarDb.getBloomPendingAppointments
-- 10   15/05/2014  DCB     Se integra 
--                              blackstarDb.getBloomPendingAppointments
-- 11   19/05/2014  DCB     Se integran:
--                               blackstarDb.GetBloomTicketUserForResponse
--                               blackstarDb.GetBloomTicketByUserKPI
--                               blackstarDb.GetBloomTicketByOfficeKPI
--                               blackstarDb.GetBloomTicketByAreaKPI
--                               blackstarDb.GetBloomTicketByDayKPI
--                               blackstarDb.GetBloomTicketByProjectKPI
--                               blackstarDb.GetBloomTicketByServiceAreaKPI
--                               blackstarDb.getBloomPendingTickets
--                               blackstarDb.getBloomTickets
--                               blackstarDb.getCatalogEmployeeByGroup
--                               blackstarDb.getBloomDocumentsByService
--                               blackstarDb.getBloomProjects
--                               blackstarDb.getBloomApplicantArea
--                               blackstarDb.getBloomServiceType
--                               blackstarDb.getBloomOffice
--                               blackstarDb.GetNextInternalTicketNumber
--                               blackstarDb.getBloomTicketId
--                               blackstarDb.AddInternalTicket
--                               blackstarDb.AddMemberTicketTeam
--                               blackstarDb.AddDeliverableTrace
-- -----------------------------------------------------------------------------
--------------------------------------------------------------------------------


use blackstarDb;

DELIMITER $$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomTicketDetail
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomTicketDetail$$
CREATE PROCEDURE blackstarDb.`GetBloomTicketDetail`(ticketId INTEGER)
BEGIN

SELECT *
FROM ((SELECT _id id, applicantUserId applicantUserId, officeId officeId, serviceTypeId serviceTypeId
             , statusId statusId, applicantAreaId applicantAreaId, dueDate, project, ticketNumber ticketNumber
             , description description, reponseInTime reponseInTime, evaluation evaluation
             , desviation desviation, responseDate responseDate, created created, createdBy createdBy
             , createdByUsr createdByUsr, modified modified, modifiedBy modifiedBy, modifiedByUsr modifiedByUsr
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
	-- blackstarDb.GetBloomTicketTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomTicketTeam$$
CREATE PROCEDURE blackstarDb.`GetBloomTicketTeam`(ticket INTEGER)
BEGIN

SELECT *
FROM ((SELECT _id id, ticketId ticketId, workerRoleTypeId workerRoleTypeId, blackstarUserId blackstarUserId, assignedDate assignedDate
       FROM bloomTicketTeam WHERE ticketId = ticket) AS ticketTeam
       LEFT JOIN (SELECT bu.blackstarUserId refId, bu.name blackstarUserName
           FROM blackstarUser bu) AS j1
           ON ticketTeam.blackstarUserId = j1.refId
       LEFT JOIN (SELECT wrt._id refId, wrt.name as workerRoleTypeName 
           FROM bloomWorkerRoleType wrt) AS j2
           ON ticketTeam.workerRoleTypeId = j2.refId);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToBloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpToBloomTicket$$
CREATE PROCEDURE blackstarDb.`AddFollowUpToBloomTicket`(pTicketId INTEGER, pCreatedByUsrId INTEGER, pMessage TEXT)
BEGIN
  DECLARE pCreatedByUsrMail VARCHAR(100);
  
  SET pCreatedByUsrMail = (SELECT email FROM blackstarUser WHERE blackstarUserId = pCreatedByUsrId);
	INSERT INTO blackstarDb.followUp(bloomTicketId, followup, created, createdBy, createdByUsr)
	VALUES(pTicketId, pMessage, NOW(), 'AddFollowUpToBloomTicket', pCreatedByUsrMail);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertBloomTicketTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertBloomTicketTeam$$
CREATE PROCEDURE blackstarDb.`UpsertBloomTicketTeam`(pTicketId INTEGER, pWorkerRoleTypeId INTEGER, pBlackstarUserId INTEGER)
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
CREATE PROCEDURE blackstarDb.`GetBloomDeliverableType`()
BEGIN
	SELECT _id id, name name, description description FROM bloomDeliverableType;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddBloomDelivarable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddBloomDelivarable$$
CREATE PROCEDURE blackstarDb.`AddBloomDelivarable`(pTicketId INTEGER, pDeliverableTypeId INTEGER)
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
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomTicketResponsible$$
CREATE PROCEDURE blackstarDb.`GetBloomTicketResponsible`(pTicketId INTEGER)
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
	-- blackstarDb.GetBloomTicketUserForResponse
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomTicketUserForResponse$$
CREATE PROCEDURE blackstarDb.`GetBloomTicketUserForResponse`(pTicketId INTEGER)
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
	-- blackstarDb.GetUserById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserById$$
CREATE PROCEDURE blackstarDb.`GetUserById`(pId INTEGER)
BEGIN

        SELECT u.blackstarUserId blackstarUserId, u.email userEmail, u.name userName
        FROM blackstarUser u
        WHERE u.blackstarUserId = pId;
        
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CloseBloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CloseBloomTicket$$
CREATE PROCEDURE blackstarDb.`CloseBloomTicket`(pTicketId INTEGER, pUserId INTEGER)
BEGIN

DECLARE inTime TINYINT DEFAULT 1;
DECLARE desv FLOAT (30,20);
DECLARE endDate DATETIME;
DECLARE today DATETIME DEFAULT NOW();

DELETE FROM messages;

INSERT INTO messages values (pTicketId);
SET endDate = (SELECT dueDate FROM bloomTicket WHERE _id = pTicketId);
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
	-- blackstarDb.GetBloomTicketByUserKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomTicketByUserKPI$$
CREATE PROCEDURE blackstarDb.`GetBloomTicketByUserKPI`()
BEGIN

SELECT bu.name name, bu.email email, aa.name applicantArea, count(*) counter
FROM bloomTicket bt, blackstarUser bu, bloomApplicantArea aa
WHERE bt.applicantUserId = bu.blackstarUserId
      AND bt.applicantAreaId = aa._id
GROUP BY bt.applicantUserId
ORDER BY counter desc;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomTicketByOfficeKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomTicketByOfficeKPI$$
CREATE PROCEDURE blackstarDb.`GetBloomTicketByOfficeKPI`()
BEGIN

SELECT of.officeName name, count(*) counter
FROM bloomTicket bt, office of
WHERE bt.officeId = of.officeId
GROUP BY bt.officeId
ORDER BY counter desc;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomTicketByAreaKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomTicketByAreaKPI$$
CREATE PROCEDURE blackstarDb.`GetBloomTicketByAreaKPI`()
BEGIN
SELECT aa.name applicantArea, count(*) counter
FROM bloomTicket bt, bloomApplicantArea aa
WHERE  bt.applicantAreaId = aa._id
GROUP BY bt.applicantAreaId
ORDER BY counter desc;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomTicketByDayKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomTicketByDayKPI$$
CREATE PROCEDURE blackstarDb.`GetBloomTicketByDayKPI`()
BEGIN
SELECT DATE_FORMAT(created,'%d/%m/%Y') created, count(*) counter
FROM bloomTicket
GROUP BY DATE_FORMAT(created,'%d/%m/%Y');
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomTicketByProjectKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomTicketByProjectKPI$$
CREATE PROCEDURE blackstarDb.`GetBloomTicketByProjectKPI`()
BEGIN
SELECT bt.project project, count(*) counter
FROM bloomTicket bt
GROUP BY bt.project
ORDER BY counter DESC
LIMIT 5;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomTicketByServiceAreaKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomTicketByServiceAreaKPI$$
CREATE PROCEDURE blackstarDb.`GetBloomTicketByServiceAreaKPI`()
BEGIN
SELECT aa.name applicantArea, st.name serviceType , count(*) counter
FROM bloomTicket bt, bloomApplicantArea aa, bloomServiceType st
WHERE bt.serviceTypeId = st._id
      AND bt.applicantAreaId = aa._id
GROUP BY bt.applicantAreaId, bt.serviceTypeId;
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
INNER JOIN bloomTicketteam tm on (ti._id = tm.ticketId)
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
	-- blackstarDb.getBloomTicketId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomTicketId$$
CREATE PROCEDURE blackstarDb.getBloomTicketId(pTicketNumber VARCHAR(100))
BEGIN

SELECT bt._id
FROM bloomTicket bt
WHERE bt.ticketNumber = pTicketNumber;

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
CREATE PROCEDURE blackstarDb.`AddMemberTicketTeam`(  
  ticketId Int(11),
  workerRoleTypeId Int(11),
  blackstarUserId Int(11))
BEGIN
	INSERT INTO bloomTicketTeam (ticketId,workerRoleTypeId,blackstarUserId, assignedDate)
VALUES (ticketId,workerRoleTypeId,blackstarUserId, NOW());
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
SELECT _ID as id ,NAME AS label FROM bloomstatustype
WHERE _ID != -1
ORDER BY _ID;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.getBloomPendingAppointments
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getBloomPendingAppointments$$
CREATE PROCEDURE blackstarDb.getBloomPendingAppointments()
BEGIN
SELECT bt._id ticketId, bt.ticketNumber ticketNumber, bt.dueDate dueDate, bt.description description
      , btt.assignedDate assignedDate, bwrt.name responsibleName, bu.email responsibleMail
      , bu.name responsibleType
FROM bloomTicket bt, bloomTicketTeam btt, bloomWorkerRoleType bwrt
     , blackstarUser bu
WHERE  bt._id = btt.ticketId
       AND btt.workerRoleTypeId = bwrt._id
       AND btt.blackstarUserId = bu.blackstarUserId
       AND bt.dueDate < DATE_ADD(NOW(), INTERVAL 1 DAY);
END$$
-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;