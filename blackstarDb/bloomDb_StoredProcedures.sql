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
-- 29   20/08/2014  SAG   Se integra proyecto bloom 
--                        Se agrega AssignBloomTicket
--                        Se agrega UserCanAssignBloomTicket
-- ------------------------------------------------------------------------------
-- 30   16/09/2014  SAG   Se agrega:
--                        Se agrega bloomTicketAutoclose
-- ------------------------------------------------------------------------------
-- 31   06/10/2014  SAG   Se cambia:
--                          bloomTicketAutoclose por bloomTicketAutoProcess
-- ------------------------------------------------------------------------------
-- 32   07/10/2014  SAG   Se modifica:
--                          GetBloomHistoricalTickets - se agrega opcion 0 - Abiertos y retrasados
-- ------------------------------------------------------------------------------
-- 33   17/11/2014  SAG   Se agrega:
--                          bloomGetTicketsServiceOrdersMixed
-- ------------------------------------------------------------------------------
-- 34   17/12/2014  SAG   Se modifica:
--                          GetBloomStatisticsByAreaSupport
-- ------------------------------------------------------------------------------

use blackstarDb;


DELIMITER $$


-- -----------------------------------------------------------------------------
  -- blackstarDb.bloomGetTicketsServiceOrdersMixed
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.bloomGetTicketsServiceOrdersMixed$$
CREATE PROCEDURE blackstarDb.bloomGetTicketsServiceOrdersMixed()
BEGIN
 
  SELECT * FROM (
    SELECT DISTINCT ticketNumber AS label, ticketNumber AS value FROM ticket UNION
    SELECT DISTINCT serviceOrderNumber AS label, serviceOrderNumber AS value FROM serviceOrder
  ) A ORDER BY label;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.bloomTicketAutoclose
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.bloomTicketAutoclose$$
DROP PROCEDURE IF EXISTS blackstarDb.bloomTicketAutoProcess$$
CREATE PROCEDURE blackstarDb.bloomTicketAutoProcess()
BEGIN
  -- Auto close
  UPDATE bloomTicket SET 
    statusId = 6,
    modified = CONVERT_TZ(now(),'+00:00','-5:00'),
    modifiedBy = 'bloomTicketAutoProcess',
    modifiedByUsr = 'Jobs'
  WHERE serviceTypeId NOT IN (13, 15)
    AND statusId = 5
    AND responseDate < DATE_ADD(now(), INTERVAL -2 DAY);

  -- Auto status - Retrasado
  UPDATE bloomTicket SET 
    statusId = 3,
    modified = CONVERT_TZ(now(),'+00:00','-5:00'),
    modifiedBy = 'bloomTicketAutoProcess',
    modifiedByUsr = 'Jobs'
  WHERE CONVERT_TZ(now(),'+00:00','-5:00') > dueDate
    AND statusId = 1;

END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.UserCanAssignBloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UserCanAssignBloomTicket$$
CREATE PROCEDURE blackstarDb.UserCanAssignBloomTicket(pTicketId INT, pUser VARCHAR(100))
BEGIN
  SELECT count(*) FROM blackstarDb.blackstarUser bu
    INNER JOIN blackstarDb.blackstarUser_userGroup j ON bu.blackstarUserId = j.blackstarUserId
    INNER JOIN blackstarDb.userGroup g ON j.userGroupId = g.userGroupId
    INNER JOIN bloomTicketTeam tt ON tt.userGroup = g.externalId
  WHERE bu.email = pUser
    AND tt.ticketId = pTicketId
  AND tt.workerRoleTypeId = 1;

END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.AssignBloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AssignBloomTicket$$
CREATE PROCEDURE blackstarDb.AssignBloomTicket(pTicketId INT, pAsignee VARCHAR(100), pUser VARCHAR(100))
BEGIN
  UPDATE bloomTicket SET 
    asignee = pAsignee,
    statusId = 1,
    modified = CONVERT_TZ(now(),'+00:00','-5:00'),
    modifiedBy = 'AssignBloomTicket',
    modifiedByUsr = pUser
  WHERE _id = pTicketId;
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetBloomTicketId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomTicketId$$
CREATE PROCEDURE blackstarDb.GetBloomTicketId(pTicketNumber VARCHAR(100))
BEGIN
  SELECT _id FROM bloomTicket WHERE ticketNumber = pTicketNumber;
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
       LEFT JOIN (SELECT st._id refId, st.name as serviceTypeName, st.resolverCanClose as resolverCanClose 
           FROM bloomServiceType st) AS j3
           ON ticketDetail.serviceTypeId = j3.refId           
       LEFT JOIN (SELECT sp._id refId, sp.name as statusName 
           FROM bloomStatusType sp) AS j4
           ON ticketDetail.statusId = j4.refId           
       LEFT JOIN (SELECT aa._id refId, aa.name as applicantAreaName 
           FROM bloomApplicantArea aa) AS j5
           ON ticketDetail.applicantAreaId = j5.refId            
       LEFT JOIN (SELECT bu.email refId, bu.name createdByUsrName
           FROM blackstarUser bu) AS j6
           ON ticketDetail.createdByUsr = j6.refId
       LEFT JOIN (SELECT bu.email refId, bu.name modifiedByUsrName
           FROM blackstarUser bu) AS j7
           ON ticketDetail.modifiedByUsr = j7.refId);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetbloomTicketTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketTeam$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketTeam`(ticket INTEGER)
BEGIN

SELECT 
  t._id AS id,
  ticketId AS ticketId,
  workerRoleTypeId AS workerRoleTypeId,
  t.blackstarUserId AS blackstarUserId,
  u.email AS userEmail,
  assignedDate AS assignedDate
FROM bloomTicketTeam t
  INNER JOIN blackstarUser u ON t.blackstarUserId = u.blackstarUserId
  INNER JOIN bloomWorkerRoleType w ON t.workerRoleTypeId = w._id
WHERE t.ticketId = ticket;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpTobloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpTobloomTicket$$
CREATE PROCEDURE blackstarDb.`AddFollowUpTobloomTicket`(pTicketId INTEGER, asignee VARCHAR(50), pCreatedByUsrMail VARCHAR(50), pMessage TEXT)
BEGIN
  
  IF asignee = '' THEN
    SET asignee = pCreatedByUsrMail;
  END IF;

	INSERT INTO blackstarDb.followUp(bloomTicketId, followup, followUpReferenceTypeId, asignee, created, createdBy, createdByUsr)
	VALUES(pTicketId, pMessage, 'R', asignee, CONVERT_TZ(now(),'+00:00','-5:00'), 'AddFollowUpTobloomTicket', pCreatedByUsrMail);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertbloomTicketTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertbloomTicketTeam$$
DROP PROCEDURE IF EXISTS blackstarDb.AddMemberTicketTeam$$
CREATE PROCEDURE blackstarDb.`AddMemberTicketTeam`(pTicketId INTEGER, pWorkerRoleTypeId INTEGER, pblackstarUser VARCHAR(50), pUserGroup VARCHAR(50))
BEGIN

SET @blackstarUserId = (SELECT blackstarUserId FROM blackstarDb.blackstarUser WHERE email = pblackstarUser);

IF NOT EXISTS (SELECT * FROM bloomTicketTeam WHERE ticketId = pTicketId AND blackstarUserId = @blackstarUserId) THEN
    INSERT INTO blackstarDb.bloomTicketTeam(ticketId, workerRoleTypeId, blackstarUserId, userGroup, assignedDate)
    VALUES(pTicketId, pWorkerRoleTypeId, @blackstarUserId, pUserGroup, CONVERT_TZ(now(),'+00:00','-5:00'));   
ELSE
   UPDATE blackstarDb.bloomTicketTeam SET 
      assignedDate = CONVERT_TZ(now(),'+00:00','-5:00'), 
      workerRoleTypeId = IF(workerRoleTypeId < pWorkerRoleTypeId, workerRoleTypeId, pWorkerRoleTypeId)
   WHERE ticketId = pTicketId 
    AND blackstarUserId = @blackstarUserId;
END IF;
    
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomFollowUpByTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomFollowUpByTicket$$
CREATE PROCEDURE blackstarDb.`GetBloomFollowUpByTicket`(pTicketId INTEGER)
BEGIN
	SELECT 
    created AS created, 
    u2.name AS createdByUsr, 
    u2.email AS createdByUsrEmail,
    u.name AS asignee, 
    followup AS followup
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
CREATE PROCEDURE blackstarDb.`AddBloomDelivarable`(pTicketId INTEGER, pDeliverableTypeId INTEGER, pDocId VARCHAR(200), pName VARCHAR(400))
BEGIN
DECLARE counter INTEGER;

  SET counter = (SELECT count(*) 
                 FROM bloomDeliverableTrace 
                 WHERE bloomTicketId = pTicketId 
                  AND deliverableTypeId = pDeliverableTypeId
                  AND deliverableTypeId NOT IN(SELECT _id FROM bloomDeliverableType WHERE name = 'Otro'));

  IF (counter > 0) THEN
    UPDATE bloomDeliverableTrace SET delivered = 1, date = CONVERT_TZ(now(),'+00:00','-5:00'), docId = pDocId;
  ELSE 
	  INSERT INTO bloomDeliverableTrace (bloomTicketId, deliverableTypeId, delivered, date, docId, name)
    VALUES (pTicketId, pDeliverableTypeId, 1, CONVERT_TZ(now(),'+00:00','-5:00'), pDocId, pName);
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
    bu.name AS createdUserName,
    ba.name as areaName,
    ti.serviceTypeId,
    st.name as serviceName,
    st.responseTime,
    ti.responseDate,
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
       INNER JOIN blackstarUser bu ON ti.createdByUsr = bu.email
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
		WHERE startDate <= CONVERT_TZ(now(),'+00:00','-5:00') AND CONVERT_TZ(now(),'+00:00','-5:00') <= endDate
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
  createdByUsr VARCHAR(50),
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

  SET @today := (CONVERT_TZ(now(),'+00:00','-5:00'));

  UPDATE blackstarDb.bloomTicket t
    INNER JOIN blackstarDb.bloomServiceType ty ON t.serviceTypeId = ty._id
  SET
    statusId = pStatusId,
    reponseInTime = if(ty.responseTime < (TO_DAYS(@today) - TO_DAYS(t.created)), 0, 1),
    resolvedOnTime = if(ty.responseTime < (TO_DAYS(@today) - TO_DAYS(t.created)), 0, 1),
    desviation = ((TO_DAYS(@today) - TO_DAYS(t.created)) - ty.responseTime),
    responseDate = @today,
    t.modified = now(),
    t.modifiedBy = 'ClosebloomTicket',
    t.modifiedByUsr = (SELECT email FROM blackstarUser WHERE blackstarUserId = pUserId)
  WHERE t._id = pTicketId;

END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketByUserKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByUserKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByUserKPI`()
BEGIN

SELECT 
  bu.name name, 
  bu.email email, 
  count(*) counter
FROM bloomTicket bt, blackstarUser bu, bloomApplicantArea aa
WHERE bt.applicantUserId = bu.blackstarUserId
      AND bt.applicantAreaId = aa._id
GROUP BY bt.applicantUserId
ORDER BY counter desc;

END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketByOfficeKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByOfficeKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByOfficeKPI`()
BEGIN

SELECT of.officeName officeName, count(*) counter
FROM bloomTicket bt, office of
WHERE bt.officeId = of.officeId
GROUP BY bt.officeId
ORDER BY counter desc;

END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketByAreaKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByAreaKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByAreaKPI`()
BEGIN
SELECT aa.name applicantArea, count(*) counter
FROM bloomTicket bt, bloomApplicantArea aa
WHERE  bt.applicantAreaId = aa._id
GROUP BY bt.applicantAreaId
ORDER BY counter desc;
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketByDayKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByDayKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByDayKPI`()
BEGIN

  SELECT 
    DATE(created) AS created,
    DATE_FORMAT(created,'%d/%m/%Y') createdStr, 
    count(*) counter
  FROM bloomTicket
GROUP BY DATE(created)
ORDER BY created;
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketByProjectKPI
-- -----------------------------------------------------------------------------
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


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketByServiceAreaKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketByServiceAreaKPI$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketByServiceAreaKPI`()
BEGIN
SELECT aa.bloomServiceArea applicantArea, count(*) counter
FROM bloomTicket bt, bloomServiceArea aa, bloomServiceType st
WHERE bt.serviceTypeId = st._id
      AND st.bloomServiceAreaId = aa.bloomServiceAreaId
GROUP BY st.bloomServiceAreaId;
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomTicketDeliverable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomTicketDeliverable$$
CREATE PROCEDURE blackstarDb.`GetbloomTicketDeliverable`(pTicketId INTEGER)
BEGIN

  SELECT 
    bdt._id id, 
    bd.name name, 
    IF(bd._id IS NOT NULL, true, false) AS delivered,
    bd.docId docId
  FROM bloomTicket bt
    INNER JOIN bloomDeliverableType bdt ON bt.serviceTypeId = bdt.serviceTypeId
    LEFT OUTER JOIN  bloomDeliverableTrace bd ON bd.bloomTicketId = bt._id AND bd.deliverableTypeId = bdt._id
  WHERE bt._id = pTicketId;

END$$ 


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetbloomSurveyTable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetbloomSurveyTable$$
CREATE PROCEDURE blackstarDb.`GetbloomSurveyTable`(userId INTEGER)
BEGIN
  SELECT 
    bs._id id, 
    bt.ticketNumber ticketNumber, 
    baa.name applicantArea, 
    bt.project project, 
    bs.created created, 
    bs.evaluation evaluation
  FROM bloomSurvey bs
    INNER JOIN bloomTicket bt ON bloomTicketId = bt._id
    INNER JOIN bloomTicketTeam btt ON btt.ticketId = bt._id
    INNER JOIN blackstarUser bu ON bu.blackstarUserId = btt.blackstarUserId
    INNER JOIN bloomApplicantArea baa ON bt.applicantAreaId = baa._id
  WHERE 
    btt.blackstarUserId = userId
    AND workerRoleTypeId = 1;
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetBloomPendingSurveyTable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomPendingSurveyTable$$
CREATE PROCEDURE blackstarDb.`GetBloomPendingSurveyTable`(userId INTEGER)
BEGIN
SELECT DISTINCT 
  bt.ticketNumber ticketNumber, 
  baa.name applicantArea, 
  bt.project project,
  GROUP_CONCAT(DISTINCT bu.name ORDER BY bu.name SEPARATOR ', ') AS risponsableName,
  bt.createdByUsr as createdByUsr
FROM bloomTicket bt
  INNER JOIN bloomApplicantArea baa ON bt.applicantAreaId = baa._id
  INNER JOIN bloomTicketTeam btt ON btt.ticketId = bt._id
  INNER JOIN blackstarUser bu ON btt.blackstarUserId = bu.blackstarUserId
  INNER JOIN blackstarUser bu2 ON bu2.email = bt.createdByUsr
  LEFT OUTER JOIN bloomSurvey bs ON bs.bloomTicketId = bt._id
WHERE bu2.blackstarUserId = userId
      AND btt.workerRoleTypeId = 1
      AND bs._id IS NULL
GROUP BY bt._id;
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.InsertbloomSurvey
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.InsertbloomSurvey$$
CREATE PROCEDURE blackstarDb.`InsertbloomSurvey`(pTicketId INTEGER, pEvaluation INTEGER, pComments TEXT, pCreated DATE)
BEGIN
  INSERT INTO bloomSurvey (bloomTicketId, evaluation, comments, created ) 
  VALUES(pTicketId, pEvaluation, pComments, pCreated);
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetBloomPendingSurveys
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomPendingSurveys$$
CREATE PROCEDURE blackstarDb.`GetBloomPendingSurveys`()
BEGIN

SELECT bt._id id, bt.ticketNumber ticketNumber, bt.description description,
       bt.responseDate responseDate, bu.email email, bu.name name
FROM bloomTicket bt, blackstarUser bu
WHERE bt.statusId = 6
     AND bt.applicantUserId = bu.blackstarUserId
     AND bt.responseDate < DATE_ADD(CONVERT_TZ(now(),'+00:00','-5:00'), INTERVAL -2 DAY);
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
					AND bu.email <> t.createdByUsr -- que no sea el creador
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
CREATE PROCEDURE blackstarDb.GetBloomStatisticsByAreaSupport(startCreationDate DATETIME, endCreationDate DATETIME)
BEGIN
  SELECT
     bloomServiceArea as area,
     count(*) as total,
     min(respTime) as minRespTime,
     round(avg(respTime), 0) as avgRespTime,
     max(respTime) as maxRespTime,
     sum(onTime) as onTime,
     sum(outTime) as outTime,
     sum(ok) as ok,
     sum(notOk) as notOk
  FROM(
    SELECT 
      a.bloomServiceAreaId, 
      bloomServiceArea, 
      t.created, 
      t.responseDate, 
      @respTime:=TIMESTAMPDIFF(HOUR, if(t.created < t.responseDate, t.created, t.responseDate), t.responseDate) as respTime, 
      if(@respTime <= (responseTime * 24), 1, 0) as onTime, 
      if(@respTime > (responseTime * 24), 1, 0) as outTime, 
      if(ifnull(s.evaluation, 1) > 0, 1, 0) as ok,
      if(s.evaluation < 1, 1, 0) as notOk
    FROM bloomTicket t
      INNER JOIN bloomServiceType y ON y._id = t.serviceTypeId
      INNER JOIN bloomServiceArea a ON y.bloomServiceAreaId = a.bloomServiceAreaId
      LEFT OUTER JOIN bloomSurvey s ON t._id = s.bloomTicketId
    WHERE t.statusId > 5
      AND responseDate IS NOT NULL
      AND t.created >= startCreationDate
      AND t.created <= endCreationDate
  ) a
  GROUP BY a.bloomServiceArea;

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
						AND bu.email <> t.createdByUsr -- que no sea el creador
						GROUP BY f.bloomTicketId
	) AS ticketsByArea
	GROUP BY userGroup;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomUnsatisfactoryTicketsByUserByArea
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomUnsatisfactoryTicketsByUserByArea$$
CREATE PROCEDURE blackstarDb.GetBloomUnsatisfactoryTicketsByUserByArea(startDate Datetime, endDate Datetime)

BEGIN

	SELECT 
    u.blackstarUserId,
    u.name as name,
    sum(if(s.evaluation < 1, 1, 0)) as notOk,
    count(*) as total,
    round(sum(if(s.evaluation < 1, 1, 0))*100/count(*), 1) as ratio
  FROM bloomSurvey s
    INNER JOIN bloomTicket t ON t._id = s.bloomTicketId
    INNER JOIN bloomTicketTeam tt ON tt.ticketId = t._id
    INNER JOIN blackstarUser u ON u.blackstarUserId = tt.blackstarUserId
  WHERE tt.workerRoleTypeId = 2
    AND userGroup != 'creator' 
  GROUP BY u.blackstarUserId, u.name
  ORDER BY notOk DESC;

END$$



-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBloomHistoricalTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBloomHistoricalTickets$$
CREATE PROCEDURE blackstarDb.GetBloomHistoricalTickets(statusTicket INT, startCreationDate DATETIME, endCreationDate DATETIME, showHidden INT, pUser VARCHAR(100))
BEGIN

  IF(statusTicket < 0) THEN
    SELECT 
      ti._id AS id, 
      ti.ticketNumber, 
      ti.created AS created,
      bu.name AS createdUserName,
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
      a.bloomServiceArea AS serviceArea,
      ti.responseDate as responseDate
    FROM bloomTicket ti 
      INNER JOIN bloomApplicantArea ba on (ba._id = ti.applicantAreaId) 
      INNER JOIN bloomServiceType st on (st._id = ti.serviceTypeId) 
      INNER JOIN office o on (o.officeId = ti.officeId) 
      INNER JOIN bloomStatusType s on (s._id = ti.statusId)
      INNER JOIN bloomServiceArea a ON st.bloomServiceAreaId = a.bloomServiceAreaId 
      INNER JOIN blackstarUser bu ON ti.createdByUsr = bu.email
    WHERE ti.created >= startCreationDate -- AND ti.created <= endCreationDate
      AND (IFNULL(st.hidden, 0) <= showHidden  OR ti.createdBy = pUser)
    ORDER BY ti.created DESC;
  ELSE
    IF (statusTicket = 0) THEN
      SELECT 
        ti._id AS id, 
        ti.ticketNumber, 
        ti.created AS created,
        bu.name AS createdUserName,
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
        a.bloomServiceArea AS serviceArea,
      ti.responseDate as responseDate
      FROM bloomTicket ti 
        INNER JOIN bloomApplicantArea ba on (ba._id = ti.applicantAreaId) 
        INNER JOIN bloomServiceType st on (st._id = ti.serviceTypeId) 
        INNER JOIN office o on (o.officeId = ti.officeId) 
        INNER JOIN bloomStatusType s on (s._id = ti.statusId) 
        INNER JOIN bloomServiceArea a ON st.bloomServiceAreaId = a.bloomServiceAreaId 
        INNER JOIN blackstarUser bu ON ti.createdByUsr = bu.email
      WHERE ti.created >= startCreationDate -- AND ti.created <= endCreationDate
        AND (IFNULL(st.hidden, 0) <= showHidden  OR ti.createdBy = pUser)
        AND ti.statusId IN(1,3)
      ORDER BY ti.created DESC;
    ELSE
      SELECT 
        ti._id AS id, 
        ti.ticketNumber, 
        ti.created AS created,
        bu.name AS createdUserName,
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
        a.bloomServiceArea AS serviceArea,
        ti.responseDate as responseDate
      FROM bloomTicket ti 
        INNER JOIN bloomApplicantArea ba on (ba._id = ti.applicantAreaId) 
        INNER JOIN bloomServiceType st on (st._id = ti.serviceTypeId) 
        INNER JOIN office o on (o.officeId = ti.officeId) 
        INNER JOIN bloomStatusType s on (s._id = ti.statusId) 
        INNER JOIN bloomServiceArea a ON st.bloomServiceAreaId = a.bloomServiceAreaId 
        INNER JOIN blackstarUser bu ON ti.createdByUsr = bu.email
      WHERE ti.created >= startCreationDate -- AND ti.created <= endCreationDate
        AND (IFNULL(st.hidden, 0) <= showHidden  OR ti.createdBy = pUser)
        AND ti.statusId = statusTicket
      ORDER BY ti.created DESC;
    END IF;
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
    workerRoleTypeId workerRoleTypeId,
    ag.userGroup 
FROM blackstarUser u
  INNER JOIN blackstarUser_userGroup ug on (u.blackstarUserId=ug.blackstarUserId)
  INNER JOIN userGroup g on (g.userGroupId=ug.userGroupId)
  INNER JOIN bloomAdvisedGroup ag on (ag.userGroup=g.externalId)
WHERE ag.applicantAreaId=applicantAreaIdParam
  AND ag.serviceTypeId=serviceTypeIdParam;
	
END$$

DELIMITER ;
