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
-- 1    08/04/2014	DCB		Se Integran los SP iniciales:
--							bloomDb.getBloomPendingTickets
--							bloomDb.getBloomTickets
--							bloomDb.getBloomDocumentsByService
-- 							bloomDb.getBloomProjects
-- 							bloomDb.getBloomApplicantArea
-- 							bloomDb.getBloomServiceType
-- 							bloomDb.getBloomOffice

-- 							bloomDb.GetNextInternalTicketNumber
-- 							bloomDb.AddInternalTicket
-- 							bloomDb.AddMemberTicketTeam
-- 							bloomDb.AddDeliverableTrace


--		08/04/2014			bloomDb.GetUserData (MODIFICADO:Sobrescribimos la version anterior)
--							bloomDb.getBloomEstatusTickets
-- 19    16/05/2014  OMA	bloomDb.GetBloomSupportAreasWithTickets
-- 20    16/05/2014  OMA	bloomDb.GetBloomStatisticsByAreaSupport
-- 21    16/05/2014  OMA	bloomDb.GetBloomPercentageTimeClosedTickets
-- 22    16/05/2014  OMA	bloomDb.GetBloomPercentageEvaluationTickets
-- 23    16/05/2014  OMA	bloomDb.GetBloomNumberTicketsByArea
-- 24    16/05/2014  OMA	bloomDb.GetBloomUnsatisfactoryTicketsByUserByArea
-- 25    16/05/2014  OMA	bloomDb.GetBloomHistoricalTickets
-- 26    22/06/2014  OMA	bloomDb.getBloomAdvisedUsers
--
-- ------------------------------------------------------------------------------


use blackstarDb;



DELIMITER $$


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

select a._id as id, a.name as label from bloomDeliverableType a
WHERE a.serviceTypeId =paramServiceTypeId
AND a._id != -1
ORDER BY a._id;

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
	problemDescriptionGPTR Varchar(2500)
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
problemDescriptionGPTR)
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
problemDescriptionGPTR);
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
(ticketId,workerRoleTypeId,blackstarUserId,assignedDate)
VALUES
(ticketId,workerRoleTypeId,blackstarUserId,CURRENT_TIMESTAMP());
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
								AND t.statusId=5 -- ticktes cerrados
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

select u.blackstarUserId as id,u.name name, u.email email from blackstarUser u
inner join blackstarUser_userGroup ug on (u.blackstarUserId=ug.blackstarUserId)
inner join userGroup g on (g.userGroupId=ug.userGroupId)
inner join bloomAdvisedGroup ag on (ag.userGroup=g.externalId)
where ag.applicantAreaId=applicantAreaIdParam
and ag.serviceTypeId=serviceTypeIdParam;
	
END$$
