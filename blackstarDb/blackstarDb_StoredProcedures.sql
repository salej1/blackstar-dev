-- -----------------------------------------------------------------------------
-- File:	blackstarDb_StoredProcedures.sql   
-- Name:	blackstarDb_StoredProcedures
-- Desc:	Crea o actualiza los Stored procedures operativos de la aplicacion
-- Auth:	Sergio A Gomez
-- Date:	03/10/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ----------------------------------------------------
-- 1    03/10/2013	SAG		Se Integran los SP iniciales:
--								blackstarDb.GetServicesScheduleStatus
--								blackstarDb.GetServiceOrders
--								blackstarDb.GetTickets
-- 								blackstarDb.UpdateTicketStatus
-- -----------------------------------------------------------------------------
-- 2    04/10/2013	SAG		Se Integra:evaDescription
--								blackstarDb.GetUnassignedTickets
-- -----------------------------------------------------------------------------
-- 3    04/10/2013	SAG		Se Integra:
--								blackstarDb.AssignTicket
-- -----------------------------------------------------------------------------
-- 4    08/10/2013	SAG		Se Integra:
--								blackstarDb.GetAllTickets
--								blackstarDb.UpsertUser
--								blackstarDb.CreateUserGroup
-- 								blackstarDb.GetUserData
-- 								blackstarDb.GetDomainEmployees
-- 								blackstarDb.GetCustomerList
-- 								blackstarDb.GetServicesSchedule sustituye a GetServicesScheduleStatus
-- -----------------------------------------------------------------------------
-- 5    14/10/2013	SAG		Se Integra:
-- 								blackstarDb.GetFollowUpByTicket
-- 								blackstarDb.GetBigTicketTable
-- 								blackstarDb.GetTickets se sustituye por GetTicketsByStatus
-- 								blackstarDb.GetTickets
-- 								blackstarDb.GetFollowUpByServiceOrder
-- 								blackstarDb.UpsertScheduledService
-- -----------------------------------------------------------------------------
-- 6    17/10/2013	SAG		Se Integra:
-- 								blackstarDb.AddFollowUpToTicket
-- 								blackstarDb.AddFollowUpToOS
-- -----------------------------------------------------------------------------
-- 7    18/10/2013	SAG		Se Integra:
-- 								blackstarDb.CloseTicket
-- -----------------------------------------------------------------------------
-- 8   19/10/2013	SAG		Se Integra:
-- 								blackstarDb.ReopenTicket
-- -----------------------------------------------------------------------------
-- 9   24/10/2013	SAG		Se Integra:
-- 								blackstarDb.AssignServiceOrder
-- 								blackstarDb.GetEquipmentByCustomer
-- -----------------------------------------------------------------------------
-- 10   20/11/2013	JAGH	Se Integra:
-- 								blackstarDb.GetAirCoServiceByIdService
-- 								blackstarDb.GetBatteryServiceByIdService
--                              blackstarDb.GetCellBatteryServiceByIdBatteryService
-- 								blackstarDb.GetEmergencyPlantServiceByIdService
-- 								blackstarDb.GetPlainServiceServiceByIdService
-- 								blackstarDb.GetUPSServiceByIdService
-- -----------------------------------------------------------------------------
-- 11   25/11/2013	JAGH	Se Integra:
-- 								blackstarDb.GetPolicyBySerialNo
-- -----------------------------------------------------------------------------
-- 12   13/11/2013	SAG		Se Integra:
-- 								blackstarDb.GetOfficesList
-- -----------------------------------------------------------------------------
-- 13   13/11/2013	SAG		Se Sustituye:
-- 								blackstarDb.GetEquipmentByCustomer por
-- 								blackstarDb.GetEquipmentList
--							Se Integra:
-- 								blackstarDb.GetProjectList
-- 								blackstarDb.GetDomainEmployeesByGroup
--								blackstarDb.AddScheduledServicePolicy
--								blackstarDb.AddScheduledServiceEmployee
--								blackstarDb.AddScheduledServiceDate
-- 								blackstarDb.GetFutureServicesSchedule
--							Se Reescribe:
-- 								blackstarDb.GetServicesSchedule
-- -----------------------------------------------------------------------------
-- 14   21/11/2013	SAG		Se Integra:
-- 								blackstarDb.GetAllServiceOrders
-- 								blackstarDb.CloseOS
-- -----------------------------------------------------------------------------
-- 15   26/11/2013	JAGH	Se Integra:
-- 								blackstarDb.AddAAservice
-- 								blackstarDb.AddBBcellservice
-- 								blackstarDb.AddBBservice
-- 								blackstarDb.AddepService
--                              blackstarDb.AddepServiceSurvey
--                              blackstarDb.AddepServiceWorkBasic
--                              blackstarDb.AddepServiceDynamicTest
-- 								blackstarDb.AddepServiceTestProtection
-- 								blackstarDb.AddepServiceTransferSwitch
-- 								blackstarDb.AddepServiceLectures
-- 								blackstarDb.AddepServiceParams
-- 								blackstarDb.AddplainService
-- 								blackstarDb.AddupsService
-- 								blackstarDb.AddupsServiceBatteryBank
--								blackstarDb.AddupsServiceGeneralTest
-- 								blackstarDb.AddupsServiceParams
-- 								blackstarDb.AddserviceOrder
-- 								blackstarDb.UpdateServiceOrder
-- -----------------------------------------------------------------------------
-- 16   25/11/2013	SAG		Se Integra:
-- 								blackstarDb.GetUserGroups
-- -----------------------------------------------------------------------------
-- 17   12/12/2013	SAG		Se Integra:
-- 								blackstarDb.GetNextServiceOrderNumber 
-- 								blackstarDb.CommitServiceOrderNumber 
-- 								blackstarDb.LoadNewSequencePoolItems 
-- 								blackstarDb.GetAndIncreaseSequence 
-- 								blackstarDb.GetNextServiceNumberForEquipment 
-- -----------------------------------------------------------------------------
-- 18   26/12/2013	SAG		Se Integra:
-- 								blackstarDb.GetScheduledServices 
-- 								blackstarDb.GetAssignedTickets 
-- -----------------------------------------------------------------------------
-- 19   31/12/2013	SAG		Fix:
-- 								blackstarDb.GetUserData 
-- -----------------------------------------------------------------------------
-- 21   02/01/2014	SAG		Se Integra:
-- 								blackstarDb.GetPersonalServiceOrders 
-- -----------------------------------------------------------------------------
-- 22   03/01/2014	SAG		Se Integra:
-- 								blackstarDb.GetAllServiceOrders 
-- 								blackstarDb.GetEquipmentByType 
-- -----------------------------------------------------------------------------
-- 23   05/01/2014	SAG		Se Integra:
-- 								blackstarDb.GetServiceTypeList
-- 								blackstarDb.GetServiceTypeById
-- 								blackstarDb.GetEquipmentTypeBySOId
-- -----------------------------------------------------------------------------
-- 24   07/01/2014	SAG		Se Integra:
-- 								blackstarDb.GetServiceStatusList
--							Se actualiza:
--								blackstarDb.AddFollowUpToOS
-- -----------------------------------------------------------------------------
-- 25   13/01/2014	SAG		Se Integra:
-- 								blackstarDb.GetNextServiceNumberForTicket
--							Se modifica:
--								blackstarDb.AddserviceOrder
-- -----------------------------------------------------------------------------
-- 26   23/01/2014	DCB		Se Integra:
-- 								blackstarDb.GetTicketsKPI
--                              blackstarDb.GetPoliciesKPI
--                              blackstarDb.GetConcurrentFailuresKPI
--                              blackstarDb.GetMaxReportsByUserKPI
--                              blackstarDb.GetReportOSTableKPI
--                              blackstarDb.GetReportOSResumeKPI
--                              blackstarDb.GetResumeOSKPI
--                              blackstarDb.GetReportsByEquipmentTypeKPI
--                              blackstarDb.GetTicketsByServiceCenterKPI
--                              blackstarDb.GetStatusKPI
--                              blackstarDb.GetServiceCenterIdList
--                              blackstarDb.GetUserAverageKPI
--                              blackstarDb.GetGeneralAverageKPI
--                              blackstarDb.GetStatisticsKPI
-- -----------------------------------------------------------------------------
-- 27   26/01/2014	LERV	Se Integra:
-- 								blackstarDb.GetServiceOrderByUser
--								blackstarDb.AddSurveyService
--										
-- -----------------------------------------------------------------------------
-- 28   30/01/2014	SAG		Se Integra:
-- 								blackstarDb.LastError
-- -----------------------------------------------------------------------------
-- 29   09/02/2014	SAG		Se Corrigen:
-- 								blackstarDb.GetServiceOrders
-- 								blackstarDb.GetPersonalServiceOrders
--							Se Integra:
--								blackstarDb.GetServiceOrderById
--								blackstarDb.GetServiceOrderByNumber
--								blackstarDb.GetServiceOrderEmployeeList
--								blackstarDb.AddServiceOrderEmployee
--								blackstarDb.GetAutocompleteEmployeeList
-- -----------------------------------------------------------------------------
-- 30   10/02/2014	SAG		Se Corrigen:
-- 								blackstarDb.GetAirCoServiceByIdService
--								blackstarDb.GetBatteryServiceByIdService
--								blackstarDb.GetEmergencyPlantServiceByIdService
--								blackstarDb.GetUPSServiceByIdService
-- -----------------------------------------------------------------------------
-- 31	11/02/2014	SAG 	Se modifica:
--								blackstarDb.GetPersonalServiceOrders
-- -----------------------------------------------------------------------------
-- 32	12/02/2014	SAG 	Se reemplaza:
--								blackstarDb.GetEquipmentTypeBySOId por
--								blackstarDb.GetServiceOrderTypeBySOId
-- -----------------------------------------------------------------------------
-- 33	20/02/2014	SAG 	Se integra:
--								blackstarDb.GetPersonalSurveyServiceList
--								blackstarDb.GetAllSurveyServiceList
--								blackstarDb.AddSurveyToServiceOrder
--								blackstarDb.GetSurveyServiceLinkedServices
-- -----------------------------------------------------------------------------
-- 34	02/03/2014	SAG 	Se modifican:
--								blackstarDb.GetStatisticsKPI
--								blackstarDb.GetReportsByEquipmentTypeKPI
--								blackstarDb.GetTicketsByServiceCenterKPI
--								blackstarDb.GetStatusKPI
-- -----------------------------------------------------------------------------
-- 35	12/03/2014	SAG 	Se Agregan:
--								blackstarDb.AddOpenCustomer
--								blackstarDb.GetOpenCustomerById
-- -----------------------------------------------------------------------------
-- 36	18/03/2014	SAG 	Se Agregan:
--								blackstarDb.GetOpenLimitedTickets
--								blackstarDb.GetLimitedTicketList
--								blackstarDb.GetLimitedServiceOrders
--								blackstarDb.GetLimitedServiceOrderList
-- -----------------------------------------------------------------------------
-- 35	20/03/2014	SAG 	Se Agregan:
--								blackstarDb.GetLimitedSurveyServiceList
--								blackstarDb.GetLimitedProjectList
--							Se modifican:
--								blackstarDb.GetStatusKPI
--								blackstarDb.GetReportsByEquipmentTypeKPI
--								blackstarDb.GetTicketsByServiceCenterKPI
-- -----------------------------------------------------------------------------
-- 36	02/04/2014	SAG 	Se agrega:
-- 								blackstarDb.GetAvailabilityKPI
-- -----------------------------------------------------------------------------
-- 37	08/04/2014	SAG 	Se agrega:
--								blackstarDb.GetEquipmentTypeList
--								blackstarDb.UpdateTicketArrival
--							Se  modifica:
--								blackstarDb.CloseTicket
-- 37	20/04/2014	SAG 	Se reemplaza:
--								blackstarDb.AddOpenCustomer por SaveOpenCustomer
-- -----------------------------------------------------------------------------
-- 38	21/04/2014	SAG 	Se agrega:
--								blackstarDb.GetScheduledServiceById
--								blackstarDb.GetScheduledServiceEmployees
--								blackstarDb.GetScheduledServicePolicies
--								blackstarDb.GetScheduledServiceDates
--								blackstarDb.GetUserPendingIssues
--								blackstarDb.GetUserWatchingIssues
--								blackstarDb.GetIssueById
--								blackstarDb.GetFollowUpByIssue
--								blackstarDb.GetFollowUpReferenceTypes
--								blackstarDb.SaveIssue
--								blackstarDb.AddFollowUpToIssue
--								blackstarDb.AssignIssue
--								blackstarDb.GetNextIssueNumber
--								blackstarDb.GetIssueStatusList
--							Se modifican:
-- 								blackstarDb.AddFollowUpToTicket
-- 								blackstarDb.AddFollowUpToOS
-- -----------------------------------------------------------------------------
-- 39	16/05/2014 	SAG 	Se corrige:
--								blackstarDb.GetMaxReportsByUserKPI
--								blackstarDb.GetConcurrentFailuresKPI
-- -----------------------------------------------------------------------------
-- 40 	19/05/2014	SAG 	Se actualiza:
--								blackstarDb.AddserviceOrder
-- -----------------------------------------------------------------------------
-- 41 	20/05/2014	SAG 	Se actualiza:
--								blackstarDb.GetLimitedTicketList
--								blackstarDb.GetAllSurveyServiceList
--								blackstarDb.GetGeneralAverageKPI
--								blackstarDb.GetUserAverageKPI
--							Se agrega:
--								blackstarDb.GetLimitedServicesSchedule	
--								blackstarDb.GetLimitedFutureServicesSchedule
--								blackstarDb.GetServiceOrderDetails
-- -----------------------------------------------------------------------------
-- 42	26/05/2014	SAG 	Se reemplaza:
--								blackstarDb.GetNextServiceNumberForEquipment por:
--								blackstarDb.GetNextServiceNumberForType
-- -----------------------------------------------------------------------------
-- 43	03/06/2014	SAG 	Se modifica:
--                              blackstarDb.GetPoliciesKPI
-- -----------------------------------------------------------------------------
-- 44	04/06/2014	SAG 	Se modifica:
--                              blackstarDb.GetAllServiceOrders
-- -----------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$



-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrderDetails
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrderDetails$$
CREATE PROCEDURE blackstarDb.GetServiceOrderDetails (serviceOrderNumber VARCHAR(100))
BEGIN

	SELECT 
		so.serviceOrderNumber,
		IFNULL(p.customer, c.customerName) AS company,
		so.receivedBy AS name,
		so.receivedByEmail AS email,
		IFNULL(p.contactPhone, c.phone) AS phone
	FROM serviceOrder so 
		LEFT OUTER JOIN policy p ON p.policyId = so.policyId
		LEFT OUTER JOIN openCustomer c ON c.openCustomerId = so.openCustomerId
	WHERE so.serviceOrderNumber = serviceOrderNumber;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedFutureServicesSchedule
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedFutureServicesSchedule$$
CREATE PROCEDURE blackstarDb.GetLimitedFutureServicesSchedule (user VARCHAR(100), pServiceDate DATETIME)
BEGIN

	SELECT DISTINCT
		s.scheduledServiceId AS scheduledServiceId,
		serviceDate AS scheduledDate,
		equipmentType AS equipmentType,
		ifnull(p.customer, oc.customerName) AS customer,
		s.project AS project,
		ifnull(p.serialNumber, oc.serialNumber) AS serialNumber,
		officeName AS officeName,
		ifnull(p.brand, oc.brand) AS brand,
		us.name AS employee
	FROM blackstarDb.scheduledService s
		LEFT OUTER JOIN blackstarDb.scheduledServicePolicy sp ON sp.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER JOIN blackstarDb.openCustomer oc ON oc.openCustomerId = s.openCustomerId
		LEFT OUTER  JOIN blackstarDb.scheduledServiceDate sd ON sd.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER  JOIN blackstarDb.policy p ON sp.policyId = p.policyId
		LEFT OUTER  JOIN blackstarDb.serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER  JOIN blackstarDb.equipmentType et ON et.equipmentTypeId = ifnull(p.equipmentTypeId, oc.equipmentTypeId)
		LEFT OUTER  JOIN blackstarDb.scheduledServiceEmployee em ON em.scheduledServiceId = s.scheduledServiceId AND em.isDefault = 1
		LEFT OUTER  JOIN blackstarDb.blackstarUser us ON us.email = em.employeeId
		LEFT OUTER  JOIN blackstarDb.office o ON o.officeId = ifnull(p.officeId, oc.officeId)
	WHERE s.serviceStatusId = 'P'
		AND serviceDate >= pServiceDate
		AND p.equipmentUser = user
	ORDER BY equipmentType;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedScheduledServices
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedServicesSchedule$$
CREATE PROCEDURE blackstarDb.GetLimitedServicesSchedule (user VARCHAR(100), pServiceDate DATETIME)
BEGIN

	SELECT DISTINCT
		s.scheduledServiceId AS scheduledServiceId,
		serviceDate AS scheduledDate,
		equipmentType AS equipmentType,
		ifnull(p.customer, oc.customerName) AS customer,
		s.project AS project,
		ifnull(p.serialNumber, oc.serialNumber) AS serialNumber,
		us.name AS defaultEmployee
	FROM blackstarDb.scheduledService s
		LEFT OUTER JOIN blackstarDb.scheduledServicePolicy sp ON sp.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER JOIN blackstarDb.openCustomer oc ON oc.openCustomerId = s.openCustomerId
		LEFT OUTER JOIN blackstarDb.scheduledServiceDate sd ON sd.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER JOIN blackstarDb.policy p ON sp.policyId = p.policyId
		LEFT OUTER JOIN blackstarDb.serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER JOIN blackstarDb.equipmentType et ON et.equipmentTypeId = ifnull(p.equipmentTypeId, oc.equipmentTypeId)
		LEFT OUTER JOIN blackstarDb.scheduledServiceEmployee em ON em.scheduledServiceId = s.scheduledServiceId AND em.isDefault = 1
		LEFT OUTER JOIN blackstarDb.blackstarUser us ON us.email = em.employeeId
	WHERE s.serviceStatusId = 'P'
		AND serviceDate > pServiceDate AND serviceDate < DATE_ADD(pServiceDate, INTERVAL 1 DAY)
		AND p.equipmentUser = user
	ORDER BY equipmentType;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetIssueStatusList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetIssueStatusList$$
CREATE PROCEDURE blackstarDb.GetIssueStatusList ()
BEGIN

	SELECT *
	FROM issueStatus;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextIssueNumber
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextIssueNumber$$
CREATE PROCEDURE blackstarDb.GetNextIssueNumber()
BEGIN

	DECLARE nextId INTEGER;
	DECLARE nextNumber VARCHAR(100);
	SET @seqNumberTypeId := 'I';

	-- Cargar nuevos numeros
	CALL blackstarDb.LoadNewSequencePoolItems(@seqNumberTypeId);
	
	-- Recuperar el siguiente numero en la secuencia y su ID
	SELECT min(sequenceNumber) into nextNumber
	FROM sequenceNumberPool 
	WHERE sequenceNumberTypeId = @seqNumberTypeId
		AND sequenceNumberStatus = 'U';

	SELECT sequenceNumberPoolId into nextId
	FROM sequenceNumberPool 
	WHERE sequenceNumber = nextNumber 
		AND sequenceNumberTypeId = @seqNumberTypeId;

	-- Bloquear el numero
	UPDATE sequenceNumberPool SET sequenceNumberStatus = 'L'
	WHERE sequenceNumberPoolId = nextId;

	SELECT concat('AS-', nextNumber);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AssignIssue
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AssignIssue$$
CREATE PROCEDURE blackstarDb.AssignIssue (pIssueId INTEGER, pEmployee VARCHAR(100), usr VARCHAR(100), proc VARCHAR(100))
BEGIN

	-- Asignacion del empleado responsable
	UPDATE issue i SET
		i.asignee = pEmployee,
		i.modified = NOW(),
		i.modifiedBy = proc,
		i.modifiedByUsr = usr
	WHERE i.issueId = pIssueId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.SaveIssue
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.SaveIssue$$
CREATE PROCEDURE blackstarDb.SaveIssue(issueId INT, issueNumber VARCHAR(100), issueStatusId CHAR(1), title VARCHAR(1000), detail TEXT, project VARCHAR(100),
	customer VARCHAR(1000), asignee VARCHAR(100), created DATETIME, createdBy VARCHAR(100), createdByUsr VARCHAR(100))
BEGIN

	IF issueId > 0 THEN
		UPDATE issue i SET
			i.issueStatusId = issueStatusId,
			i.detail = detail,
			i.project = project,
			i.customer = customer,
			i.asignee = asignee,
			i.modified = created,
			i.modifiedBy = createdBy,
			i.modifiedByUsr = createdByUsr
		WHERE i.issueid = issueid;
	ELSE
		INSERT INTO issue
			(issueId, issueNumber, issueStatusId, title, detail, project, customer, asignee, created, createdBy, createdByUsr)
		VALUES
			(issueId, issueNumber, issueStatusId, title, detail, project, customer, asignee, created, createdBy, createdByUsr);

		SET issueId = LAST_INSERT_ID();

		-- Agragar el followUp inicial
		INSERT INTO blackstarDb.followUp(
			followUpReferenceTypeId,
			issueId,
			asignee,
			followup,
			created,
			createdBy,
			createdByUsr
		)
		SELECT 
			'I',
			issueid,
			asignee,
			detail,
			created,
			createdBy,
			createdByUsr;
	END IF;

	SELECT issueId;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToIssue
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpToIssue$$
CREATE PROCEDURE blackstarDb.AddFollowUpToIssue(pIssueId INTEGER, pCreated DATETIME, pCreatedBy VARCHAR(100), pAsignee VARCHAR(100), pMessage TEXT)
BEGIN

	-- INSERTAR EL REGISTRO DE SEGUIMIENTO
	INSERT INTO blackstarDb.followUp(
		followUpReferenceTypeId,
		issueId,
		asignee,
		followup,
		created,
		createdBy,
		createdByUsr
	)
	SELECT 
		'I',
		pIssueId,
		pAsignee,
		pMessage,
		pCreated,
		'AddFollowUpToIssue',
		pCreatedBy;

	UPDATE issue SET
		issueStatusId = 'A',
		modified = NOW(),
		modifiedBy = 'AddFollowUpToIssue',
		modifiedByUsr = pCreatedBy
	WHERE issueId = pIssueId;
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFollowUpReferenceTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFollowUpReferenceTypes$$
CREATE PROCEDURE blackstarDb.GetFollowUpReferenceTypes()
BEGIN

	SELECT 
		f.*
	FROM followUpReferenceType f;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFollowUpByIssue
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFollowUpByIssue$$
CREATE PROCEDURE blackstarDb.GetFollowUpByIssue(pIssueId INT)
BEGIN

	SELECT 
		created AS timeStamp,
		u2.name AS createdBy,
		u.name AS asignee,
		followup AS followUp
	FROM followUp f
		LEFT OUTER JOIN blackstarUser u ON f.asignee = u.email
		LEFT OUTER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE issueId = pIssueId
	ORDER BY created;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetIssueById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetIssueById$$
CREATE PROCEDURE blackstarDb.GetIssueById(pIssueId INT)
BEGIN

	SELECT 
		*
	FROM issue
	WHERE issueid = pIssueId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUserWatchingIssues
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserWatchingIssues$$
CREATE PROCEDURE blackstarDb.GetUserWatchingIssues(pUser VARCHAR(100))
BEGIN

	SET @prevRefId := 0;
	SET @rowNumber := 0;

	SELECT 
		f.followUpReferenceTypeId AS referenceTypeId, 
		r.followupreferencetype AS referenceType,
		coalesce(t.ticketId, s.serviceOrderId, i.issueId) AS referenceId, 
		coalesce(t.ticketNumber, s.serviceOrderNumber, i.issueNumber) AS referenceNumber,
		coalesce(p.project, c.project, i.project) AS project,
		coalesce(p.customer, c.customerName, i.customer) AS customer,
		f.created AS created,
		CASE 
			WHEN f.followUpReferenceTypeId = 'T' THEN 'Seguimiento a Ticket'
			WHEN f.followUpReferenceTypeId = 'O' THEN 'Seguimiento a Orden de Servicio'
			WHEN f.followUpReferenceTypeId = 'I' THEN 'Asignacion SAC'
		END AS title,
		followUp AS detail,
		coalesce(ts.ticketStatus, ss.serviceStatus, ist.issueStatus) as status
	FROM (
		SELECT * FROM (
			SELECT @rowNumber := IF(coalesce(ticketId, serviceOrderId, issueId) = @prevRefId, @rowNumber + 1, 1) AS RowNum,
				f.*, 
				@prevRefId := coalesce(ticketId, serviceOrderId, issueId) AS PrevRef
			FROM followUp f
			ORDER BY followUpReferenceTypeId, coalesce(ticketId, serviceOrderId, issueId), created DESC
		) a WHERE a.RowNum = 1  -- a: todos los followUps asignados por usuario, numerados por id de (ticket, so, issue)
	) f -- f: el ultimo comentario de cada (ticket, so, issue) y que esta asignado al usuario
		INNER JOIN followUpReferenceType r ON f.followUpReferenceTypeId = r.followUpReferenceTypeId
		LEFT OUTER JOIN ticket t ON f.ticketId = t.ticketId
		LEFT OUTER JOIN serviceOrder s ON s.serviceOrderId = f.serviceOrderId
		LEFT OUTER JOIN issue i ON i.issueId = f.issueId
		LEFT OUTER JOIN policy p ON coalesce(t.policyId, s.policyId) = p.policyId
		LEFT OUTER JOIN openCustomer c ON s.openCustomerId = c.openCustomerId
		LEFT OUTER JOIN ticketStatus ts ON ts.ticketStatusId = t.ticketStatusId
		LEFT OUTER JOIN serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER JOIN issueStatus ist ON ist.issueStatusId = i.issueStatusId
	WHERE coalesce(t.createdByUsr, s.createdByUsr, i.createdByUsr) = pUser
	AND coalesce(t.ticketStatusId, s.serviceStatusId, i.issueStatusId) NOT IN ('C', 'F')
	ORDER BY f.created;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUserPendingIssues
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserPendingIssues$$
CREATE PROCEDURE blackstarDb.GetUserPendingIssues(pUser VARCHAR(100))
BEGIN

	SET @prevRefId := 0;
	SET @rowNumber := 0;

	SELECT 
		f.followUpReferenceTypeId AS referenceTypeId, 
		r.followupreferencetype AS referenceType,
		coalesce(t.ticketId, s.serviceOrderId, i.issueId) AS referenceId, 
		coalesce(t.ticketNumber, s.serviceOrderNumber, i.issueNumber) AS referenceNumber,
		coalesce(p.project, c.project, i.project) AS project,
		coalesce(p.customer, c.customerName, i.customer) AS customer,
		f.created AS created,
		CASE 
			WHEN f.followUpReferenceTypeId = 'T' THEN 'Seguimiento a Ticket'
			WHEN f.followUpReferenceTypeId = 'O' THEN 'Seguimiento a Orden de Servicio'
			WHEN f.followUpReferenceTypeId = 'I' THEN 'Asignacion SAC'
		END AS title,
		followUp AS detail,
		coalesce(ts.ticketStatus, ss.serviceStatus, ist.issueStatus) as status
	FROM (
		SELECT * FROM (
			SELECT @rowNumber := IF(coalesce(ticketId, serviceOrderId, issueId) = @prevRefId, @rowNumber + 1, 1) AS RowNum,
				f.*, 
				@prevRefId := coalesce(ticketId, serviceOrderId, issueId) AS PrevRef
			FROM followUp f
			ORDER BY followUpReferenceTypeId, coalesce(ticketId, serviceOrderId, issueId), created DESC
		) a WHERE a.RowNum = 1 AND asignee = pUser -- a: todos los followUps asignados al usuario, numerados por id de (ticket, so, issue)
	) f -- f: el ultimo comentario de cada (ticket, so, issue) y que esta asignado al usuario
		INNER JOIN followUpReferenceType r ON f.followUpReferenceTypeId = r.followUpReferenceTypeId
		LEFT OUTER JOIN ticket t ON f.ticketId = t.ticketId
		LEFT OUTER JOIN serviceOrder s ON s.serviceOrderId = f.serviceOrderId
		LEFT OUTER JOIN issue i ON i.issueId = f.issueId
		LEFT OUTER JOIN policy p ON coalesce(t.policyId, s.policyId) = p.policyId
		LEFT OUTER JOIN openCustomer c ON s.openCustomerId = c.openCustomerId
		LEFT OUTER JOIN ticketStatus ts ON ts.ticketStatusId = t.ticketStatusId
		LEFT OUTER JOIN serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER JOIN issueStatus ist ON ist.issueStatusId = i.issueStatusId
	WHERE coalesce(t.asignee, s.asignee, i.asignee) = pUser
	AND coalesce(t.ticketStatusId, s.serviceStatusId, i.issueStatusId) NOT IN ('C', 'F')
	ORDER BY f.created;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetScheduledServiceDates
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetScheduledServiceDates$$
CREATE PROCEDURE blackstarDb.GetScheduledServiceDates(pScheduledServiceId INT)
BEGIN

	SELECT 
		s.serviceDate as serviceDate
	FROM scheduledServiceDate s 
	WHERE s.scheduledServiceId = pScheduledServiceId
	ORDER BY s.serviceDate;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetScheduledServicePolicies
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetScheduledServicePolicies$$
CREATE PROCEDURE blackstarDb.GetScheduledServicePolicies(pScheduledServiceId INT)
BEGIN

	SELECT 
		s.policyId as policyId
	FROM scheduledServicePolicy s 
	WHERE s.scheduledServiceId = pScheduledServiceId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetScheduledServiceEmployees
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetScheduledServiceEmployees$$
CREATE PROCEDURE blackstarDb.GetScheduledServiceEmployees(pScheduledServiceId INT)
BEGIN

	SELECT 
		e.employeeId as employeeId
	FROM scheduledService s 
		INNER JOIN scheduledServiceEmployee e ON s.scheduledServiceId = e.scheduledServiceId
	WHERE s.scheduledServiceId = pScheduledServiceId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetScheduledServiceById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetScheduledServiceById$$
CREATE PROCEDURE blackstarDb.GetScheduledServiceById(pScheduledServiceId INT)
BEGIN
	
	SELECT * 
	FROM scheduledService 
	WHERE scheduledServiceId = pScheduledServiceId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.UpdateTicketArrival
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpdateTicketArrival$$
CREATE PROCEDURE blackstarDb.UpdateTicketArrival(pTicketId INT, pArrival DATETIME, pModifiedBy VARCHAR(100), pUser VARCHAR(100))
BEGIN

	UPDATE ticket t 
		INNER JOIN policy p ON t.policyId = p.policyId SET
		t.arrival = pArrival,
		t.realResponseTime = TIMESTAMPDIFF(HOUR, t.created, pArrival),
		t.responseTimeDeviationHr = CASE WHEN(TIMESTAMPDIFF(HOUR, t.created, pArrival) < responseTimeHR) THEN 0 ELSE (TIMESTAMPDIFF(HOUR, t.created, pArrival) - responseTimeHR) END,
		t.modified = NOW(),
		t.modifiedBy = pModifiedBy,
		t.modifiedByUsr = pUser
	WHERE ticketId = pTicketId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEquipmentTypeList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentTypeList$$
CREATE PROCEDURE blackstarDb.GetEquipmentTypeList()
BEGIN

	SELECT * 
	FROM equipmentType
	ORDER BY equipmentType;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAvailabilityKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAvailabilityKPI$$
CREATE PROCEDURE blackstarDb.GetAvailabilityKPI(pProject VARCHAR(100), pStartDate DATETIME, pEndDate DATETIME, customer VARCHAR(100))
BEGIN
	-- Variables auxiliares para calculos
	DECLARE elapsedHr INT; 
	DECLARE equipmentNum INT; 
	DECLARE downTimeSum INT; 
	DECLARE equipmentHr INT; 
	DECLARE availability DECIMAL(5,2); 
	DECLARE averageSolutionTime INT;
	DECLARE totalTickets INT;
	DECLARE totalClosedTickets INT;
	DECLARE totalAttendedTickets INT;
	DECLARE onTimeResolvedTickets	DECIMAL(5,2);
	DECLARE onTimeAttendedTickets DECIMAL(5,2);

	-- Tabla temporal con los equipos en scope
	CREATE TEMPORARY TABLE IF NOT EXISTS selectedEquipment(
		policyId INT,
		solutionTimeHR INT,
		responseTimeHR INT,
		timeAlive	INT
	) ENGINE = MEMORY;

	IF customer = '' THEN 
		IF pProject = 'All' THEN
			INSERT INTO selectedEquipment(policyId, solutionTimeHR, responseTimeHR, timeAlive) 
			SELECT policyId, solutionTimeHR, responseTimeHR,
				(DATEDIFF(CASE WHEN (endDate < pEndDate) THEN endDate ELSE pEndDate END, CASE WHEN (pStartDate > startDate) THEN pStartDate ELSE startDate END) * 24)
			FROM policy 
			WHERE NOT (endDate < pStartDate OR startDate > pEndDate);
		ELSE
			INSERT INTO selectedEquipment(policyId, solutionTimeHR, responseTimeHR, timeAlive) 
			SELECT policyId, solutionTimeHR, responseTimeHR,
				(DATEDIFF(CASE WHEN (endDate < pEndDate) THEN endDate ELSE pEndDate END, CASE WHEN (pStartDate > startDate) THEN pStartDate ELSE startDate END) * 24)
			FROM policy 
			WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
				AND project = pProject;
		END IF;
	ELSE
		IF pProject = 'All' THEN
			INSERT INTO selectedEquipment(policyId, solutionTimeHR, responseTimeHR, timeAlive) 
			SELECT policyId, solutionTimeHR, responseTimeHR,
				(DATEDIFF(CASE WHEN (endDate < pEndDate) THEN endDate ELSE pEndDate END, CASE WHEN (pStartDate > startDate) THEN pStartDate ELSE startDate END) * 24)
			FROM policy 
			WHERE equipmentUser = customer 
				AND NOT (endDate < pStartDate OR startDate > pEndDate);
		ELSE
			INSERT INTO selectedEquipment(policyId, solutionTimeHR, responseTimeHR, timeAlive) 
			SELECT policyId, solutionTimeHR, responseTimeHR,
				(DATEDIFF(CASE WHEN (endDate < pEndDate) THEN endDate ELSE pEndDate END, CASE WHEN (pStartDate > startDate) THEN pStartDate ELSE startDate END) * 24)
			FROM policy 
			WHERE equipmentUser = customer 
				AND NOT (endDate < pStartDate OR startDate > pEndDate)
				AND project = pProject;
		END IF;
	END IF;

	-- CALCULOS DISPONIBILIDAD

	-- tiempo transcurrido en horas
	SELECT sum(timeAlive) FROM selectedEquipment INTO equipmentHr;

	-- sumatoria de horas-equipo fuera
	SELECT sum(solutionTime) INTO downTimeSum
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate;

	-- porcentaje de disponibilidad
	SELECT ((equipmentHr - ifnull(downTimeSum, 0)) / equipmentHr) * 100 INTO availability;

	-- tiempo promedio de solucion
	SELECT avg(solutionTime) INTO averageSolutionTime
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate;

	-- TICKETS SOLUCIONADOS EN TIEMPO

	-- numero total de tickets
	SELECT count(*) INTO totalTickets
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate;

	-- numero de tickets cerrados en scope 
	SELECT count(*) INTO totalClosedTickets
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate
			AND t.solutionTime IS NOT NULL;

	-- numero de tickets atendidos en scope
	SELECT count(*) INTO totalAttendedTickets
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate
			AND t.realResponseTime IS NOT NULL;

	SELECT (count(*) / totalClosedTickets) * 100 INTO onTimeResolvedTickets
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate
			AND t.solutionTime <= e.solutionTimeHR;

	-- tickets atendidos a tiempo
	SELECT (count(*) / totalAttendedTickets) * 100 INTO onTimeAttendedTickets
		FROM ticket t
			INNER JOIN selectedEquipment e ON t.policyId = e.policyId
		WHERE t.created > pStartDate
			AND t.created < pEndDate
			AND t.realResponseTime <= e.responseTimeHR;

	-- se elimina la tabla temporal
	DROP TABLE selectedEquipment;
	
	-- datos de retorno
	SELECT 	availability AS availability,
			averageSolutionTime AS solutionAverageTime,
			onTimeResolvedTickets AS onTimeResolvedTickets,
			onTimeAttendedTickets AS onTimeAttendedTickets,
			totalTickets AS totalTickets;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedProjectList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedProjectList$$
CREATE PROCEDURE blackstarDb.GetLimitedProjectList(pUser VARCHAR(100))
BEGIN

	SELECT DISTINCT 
		p.project as project
	FROM blackstarDb.policy p
	WHERE p.startDate <= NOW() AND NOW() <= p.endDate
	AND p.equipmentUser = pUser
	ORDER BY project;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedSurveyServiceList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedSurveyServiceList$$
CREATE PROCEDURE blackstarDb.GetLimitedSurveyServiceList(pUser VARCHAR(100))
BEGIN
	
	SELECT DISTINCT
		s.surveyServiceId AS DT_RowId,
		s.surveyServiceId AS surveyServiceNumber,
		p.customer AS customer,
		p.project AS project,
		s.surveyDate AS surveyDate,
		s.score AS score
	FROM surveyService s
		INNER JOIN serviceOrder o ON o.surveyServiceId = s.surveyServiceId
		INNER JOIN policy p ON o.policyId = p.policyId
    WHERE p.equipmentUser = pUser
	ORDER BY surveyDate DESC;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedServiceOrderList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedServiceOrderList$$
CREATE PROCEDURE blackstarDb.GetLimitedServiceOrderList(pUser VARCHAR(100))
BEGIN
	SELECT 
		so.ServiceOrderId AS DT_RowId,
		so.serviceOrderNumber AS serviceOrderNumber,
		'' AS placeHolder,
		IFNULL(t.ticketNumber, '') AS ticketNumber,
		st.serviceType AS serviceType,
		DATE(so.serviceDate) AS serviceDate,
		p.customer AS customer,
		et.equipmentType AS equipmentType,
		p.project AS project,
		of.officeName AS officeName,
		p.brand AS brand,
		p.serialNumber AS serialNumber,
		ss.serviceStatus AS serviceStatus,
		so.hasPdf AS hasPdf
	FROM serviceOrder so 
		INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
		INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
		INNER JOIN policy p ON so.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
		INNER JOIN office of on p.officeId = of.officeId
    LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
    WHERE p.equipmentUser = pUser
	ORDER BY so.serviceDate DESC;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedServiceOrders
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedServiceOrders$$
CREATE PROCEDURE blackstarDb.GetLimitedServiceOrders(status VARCHAR(200), pUser VARCHAR(100))
BEGIN

	SELECT 
		so.ServiceOrderId AS DT_RowId,
		so.serviceOrderNumber AS serviceOrderNumber,
		'' AS placeHolder,
		IFNULL(t.ticketNumber, '') AS ticketNumber,
		st.serviceType AS serviceType,
		DATE(so.created) AS created,
		p.customer AS customer,
		et.equipmentType AS equipmentType,
		p.project AS project,
		of.officeName AS officeName,
		p.brand AS brand,
		p.serialNumber AS serialNumber,
		ss.serviceStatus AS serviceStatus,
		so.hasPdf AS hasPdf
	FROM serviceOrder so 
		INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
		INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
		INNER JOIN policy p ON so.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
		INNER JOIN office of on p.officeId = of.officeId
     LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
	WHERE ss.serviceStatus IN(status) 
	AND p.equipmentUser = pUser
	ORDER BY serviceDate DESC ;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLimitedTicketList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLimitedTicketList$$
CREATE PROCEDURE blackstarDb.GetLimitedTicketList(pUser VARCHAR(100))
BEGIN
	SELECT 
		t.ticketId AS DT_RowId,
		t.ticketNumber AS ticketNumber,
		t.created AS created,
		p.contactName AS contactName,
		p.serialNumber AS serialNumber,
		p.customer AS customer,
		e.equipmentType AS equipmentType,
		p.responseTimeHR AS responseTimeHR,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		IFNULL(bu.name, t.employee) AS asignee,
		'' AS asignar,
		IFNULL(t.serviceOrderNumber, '') AS serviceOrderNumber
	FROM ticket t
		INNER JOIN policy p ON p.policyId = t.policyId
		INNER JOIN equipmentType e ON e.equipmentTypeId = p.equipmentTypeId
		INNER JOIN ticketStatus ts ON t.ticketStatusId = ts.ticketStatusId
		LEFT OUTER JOIN blackstarUser bu ON bu.email = t.asignee
	WHERE p.equipmentUser = pUser
	ORDER BY created;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetOpenLimitedTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetOpenLimitedTickets$$
CREATE PROCEDURE blackstarDb.GetOpenLimitedTickets(pUser VARCHAR(100))
BEGIN
	SELECT 
		t.ticketId AS DT_RowId,
		t.ticketNumber AS ticketNumber,
		t.created AS ticketDate,
		p.customer AS customer,
		e.equipmentType AS equipmentType,
		p.responseTimeHR AS responseTime,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		'' AS placeHolder
	FROM ticket t
		INNER JOIN policy p ON p.policyId = t.policyId
		INNER JOIN equipmentType e ON e.equipmentTypeId = p.equipmentTypeId
		INNER JOIN ticketStatus ts ON t.ticketStatusId = ts.ticketStatusId
	WHERE p.equipmentUser = pUser
	AND t.closed IS NULL
	ORDER BY ticketDate;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetOpenCustomerById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetOpenCustomerById$$
CREATE PROCEDURE blackstarDb.GetOpenCustomerById(pOpenCustomerId INT)
BEGIN
	SELECT *
	FROM blackstarDb.openCustomer
	WHERE openCustomerId = pOpenCustomerId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.SaveOpenCustomer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddOpenCustomer$$
DROP PROCEDURE IF EXISTS blackstarDb.SaveOpenCustomer$$
CREATE PROCEDURE blackstarDb.SaveOpenCustomer(
	openCustomerId INT,
	customerName VARCHAR(200),
	address VARCHAR(500),
	phone VARCHAR(100),
	equipmentTypeId CHAR(1),
	brand VARCHAR(100),
	model VARCHAR(100),
	capacity VARCHAR(100),
	serialNumber VARCHAR(100),
	contactName VARCHAR(100),
	contactEmail VARCHAR(100),
	project VARCHAR(100),
	officeId VARCHAR(1),
	createdBy NVARCHAR(50),
	createdByUsr NVARCHAR(50),
	modifiedBy NVARCHAR(50),
	modifiedByUsr NVARCHAR(50)
)
BEGIN
	IF openCustomerId > 0 THEN
		UPDATE openCustomer c SET
			c.customerName = customerName,
			c.address = address,
			c.phone = phone,
			c.equipmentTypeId = equipmentTypeId,
			c.brand = brand,
			c.model = model,
			c.capacity = capacity,
			c.serialNumber = serialNumber,
			c.contactName = contactName,
			c.contactEmail = contactEmail,
			c.project = project,
			c.officeId = officeId,
			c.modified = NOW(),
			c.modifiedBy = modifiedBy,
			c.modifiedByUsr = modifiedByUsr	
		WHERE c.openCustomerId = openCustomerId;
		SELECT openCustomerId;
	ELSE
		INSERT INTO blackstarDb.openCustomer(
			customerName, address, phone, equipmentTypeId, brand, model, capacity, serialNumber, contactName, contactEmail, project, officeId, created, createdBy, createdByUsr
		)
		VALUES(
			customerName, address, phone, equipmentTypeId, brand, model, capacity, serialNumber, contactName, contactEmail, project, officeId, NOW(), createdBy, createdByUsr
		);
		SELECT LAST_INSERT_ID();
	END IF;
	

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetStatisticsKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetStatisticsKPI$$
CREATE PROCEDURE blackstarDb.GetStatisticsKPI(pProject varchar(100), pStartDate DATETIME, pEndDate DATETIME)
BEGIN

DECLARE totalTickets INT;
DECLARE totalPolicies INT;

IF pProject = 'All' THEN
	SELECT count(DISTINCT serialNumber) FROM policy WHERE NOT (endDate < pStartDate OR startDate > pEndDate) INTO totalPolicies;
	SELECT count(*) FROM ticket WHERE (created >= pStartDate AND created <= pEndDate) INTO totalTickets;

	-- RECUPERACION DE DATOS POR PARTES:
	-- A: polizas por proyecto y su contribucion al total
	-- B: tickets por proyecto y su contribucion al total
	-- C: tickets por oficina

	-- SI NO HAY FILTRO POR PROYECTO
	SELECT officeName, 0 AS isTotal, A.project, customer, policyCount AS pNumber, cast(policyContribution AS decimal(5,2)) AS tPolicies, ifnull(ticketCount, 0) AS nReports, ifnull(cast(ticketContribution AS decimal(5,2)), 0) AS tReports, NULL AS oReports
	FROM(
		SELECT p.officeId, officeName, project, customer, count(DISTINCT serialNumber) AS policyCount, (count(DISTINCT serialNumber)/totalPolicies) * 100 AS policyContribution
		FROM policy p
			INNER JOIN office o ON o.officeId = p.officeId
		WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
		GROUP BY project
	) A
	LEFT OUTER JOIN (
		SELECT project, count(*) AS ticketCount, (count(*) / totalTickets) * 100 AS ticketContribution
		FROM ticket t
			INNER JOIN policy p ON t.policyId = p.policyId
		WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
			AND (t.created >= pStartDate AND t.created <= pEndDate)
		GROUP BY project
	) B ON A.project = B.project
	UNION SELECT officeName, 1 AS isTotal, NULL, NULL, NULL, NULL, NULL, NULL, officeReports AS oReports FROM  (
		SELECT officeName, count(*) AS officeReports
		FROM ticket t
			INNER JOIN policy p ON t.policyId = p.policyId
			INNER JOIN office o ON o.officeId = p.officeId
		WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
			AND (t.created >= pStartDate AND t.created <= pEndDate)
		GROUP BY officeName
	) C
	ORDER BY officeName, isTotal, project;
ELSE
	-- SI EXISTE FILTRO POR PROYECTO
	SELECT count(DISTINCT serialNumber) FROM policy WHERE NOT (endDate < pStartDate OR startDate > pEndDate) INTO totalPolicies;
	SELECT count(*) FROM ticket WHERE (created >= pStartDate AND created <= pEndDate) INTO totalTickets;

	SELECT officeName, 0 AS isTotal, A.project, customer, policyCount AS pNumber, cast(policyContribution AS decimal(5,2)) AS tPolicies, ifnull(ticketCount, 0) AS nReports, ifnull(cast(ticketContribution AS decimal(5,2)), 0) AS tReports, NULL AS oReports
	FROM(
		SELECT p.officeId, officeName, project, customer, count(DISTINCT serialNumber) AS policyCount, (count(DISTINCT serialNumber)/totalPolicies) * 100 AS policyContribution
		FROM policy p
			INNER JOIN office o ON o.officeId = p.officeId
		WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
			AND project = pProject 
		GROUP BY project
	) A
	LEFT OUTER JOIN (
		SELECT project, count(*) AS ticketCount, (count(*) / totalTickets) * 100 AS ticketContribution
		FROM ticket t
			INNER JOIN policy p ON t.policyId = p.policyId
		WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
			AND (t.created >= pStartDate AND t.created <= pEndDate)
			AND project = pProject
		GROUP BY project
	) B ON A.project = B.project
	UNION SELECT officeName, 1 AS isTotal, NULL, NULL, NULL, NULL, NULL, NULL, officeReports AS oReports FROM  (
		SELECT officeName, count(*) AS officeReports
		FROM ticket t
			INNER JOIN policy p ON t.policyId = p.policyId
			INNER JOIN office o ON o.officeId = p.officeId
		WHERE NOT (endDate < pStartDate OR startDate > pEndDate)
			AND (t.created >= pStartDate AND t.created <= pEndDate)
			AND project = pProject 
		GROUP BY officeName
	) C 
	ORDER BY officeName, isTotal, project;
END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetGeneralAverageKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetGeneralAverageKPI$$
CREATE PROCEDURE blackstarDb.`GetGeneralAverageKPI`(pProject varchar(100), pStartDate DATETIME, pEndDate DATETIME)
BEGIN
	IF pProject = 'All' THEN
		SELECT * FROM (
			SELECT 
				sc.serviceCenter as office, 
				count(*) as services,
				IFNULL(AVG(ss.score),0) as average
			FROM serviceOrder so
				INNER JOIN surveyService ss ON so.surveyServiceId = ss.surveyServiceId
				INNER JOIN policy p ON p.policyId = so.policyId
				INNER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
			WHERE so.created >= pStartDate and so.created <= pEndDate
			GROUP BY sc.serviceCenter
			ORDER BY sc.serviceCenter
		) A 
		UNION
		SELECT 
			'GENERAL' as office,
			count(*) as services,
			IFNULL(AVG(ss.score),0) as average
		FROM serviceOrder so
			INNER JOIN surveyService ss ON so.surveyServiceId = ss.surveyServiceId
			INNER JOIN policy p ON p.policyId = so.policyId
			INNER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
		WHERE so.created >= pStartDate and so.created <= pEndDate;
	ELSE
		SELECT * FROM (
			SELECT 
				sc.serviceCenter as office, 
				count(*) as services,
				IFNULL(AVG(ss.score),0) as average
			FROM serviceOrder so
				INNER JOIN surveyService ss ON so.surveyServiceId = ss.surveyServiceId
				INNER JOIN policy p ON p.policyId = so.policyId
				INNER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
			WHERE so.created >= pStartDate and so.created <= pEndDate
				AND p.project = pProject
			GROUP BY sc.serviceCenter
			ORDER BY sc.serviceCenter
		) A 
		UNION
		SELECT 
			'GENERAL' as office,
			count(*) as services,
			IFNULL(AVG(ss.score),0) as average
		FROM serviceOrder so
			INNER JOIN surveyService ss ON so.surveyServiceId = ss.surveyServiceId
			INNER JOIN policy p ON p.policyId = so.policyId
			INNER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
		WHERE so.created >= pStartDate and so.created <= pEndDate
			AND p.project = pProject;
	END IF;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUserAverageKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserAverageKPI$$
CREATE PROCEDURE blackstarDb.`GetUserAverageKPI`(pProject varchar(100), pStartDate DATETIME, pEndDate DATETIME)
BEGIN
	IF pProject = 'All' THEN
		SELECT 
			se.employeeId as employeeId, 
			bu.name as name,
			AVG(ss.score) as average, 
			SUM(so.isWrong) as wrongOs,
			COUNT(*) as services,
			((COUNT(*) * 5) - SUM(ss.questionTreatment) - SUM(ss.questionIdentificationPersonal) - SUM(questionIdealEquipment) - SUM(questionTime) - SUM(questionUniform)) AS badComments
		FROM serviceOrder so 
			INNER JOIN serviceOrderEmployee se on so.serviceOrderId = se.serviceOrderId
			INNER JOIN surveyService ss ON so.surveyServiceId = ss.surveyServiceId
			INNER JOIN blackstarUser bu ON bu.email = se.employeeId
			WHERE so.created >= pStartDate and so.created <= pEndDate
		GROUP BY se.employeeId;
	ELSE
		SELECT 
			se.employeeId as employeeId, 
			bu.name as name,
			AVG(ss.score) as average, 
			SUM(so.isWrong) as wrongOs,
			COUNT(*) as services,
			((COUNT(*) * 5) - SUM(ss.questionTreatment) - SUM(ss.questionIdentificationPersonal) - SUM(questionIdealEquipment) - SUM(questionTime) - SUM(questionUniform)) AS badComments
		FROM serviceOrder so 
			INNER JOIN serviceOrderEmployee se on so.serviceOrderId = se.serviceOrderId
			INNER JOIN surveyService ss ON so.surveyServiceId = ss.surveyServiceId
			INNER JOIN blackstarUser bu ON bu.email = se.employeeId
			LEFT OUTER JOIN policy p ON p.policyId = so.policyId
			LEFT OUTER JOIN openCustomer c ON c.openCustomerId = so.openCustomerId
			WHERE so.created >= pStartDate and so.created <= pEndDate
				AND IFNULL(p.project, c.project) = pProject
		GROUP BY se.employeeId;
	END IF;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetSurveyServiceLinkedServices
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetSurveyServiceLinkedServices$$
CREATE PROCEDURE blackstarDb.GetSurveyServiceLinkedServices(pSurveyServiceId INT)
BEGIN

	SELECT 
		serviceOrderNumber AS serviceOrderNumber,
		serviceOrderId AS serviceOrderId
	FROM serviceOrder
	WHERE surveyServiceId = pSurveyServiceId;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddSurveyToServiceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddSurveyToServiceOrder$$
CREATE PROCEDURE blackstarDb.AddSurveyToServiceOrder(pServiceOrderNumber VARCHAR(100), pSurveyServiceId INT, pModifiedBy VARCHAR(100), user VARCHAR(100))
BEGIN

	UPDATE serviceOrder SET
		surveyServiceId = pSurveyServiceId,
		modified = NOW(),
		modifiedBy = pModifiedBy,
		modifiedByUsr = user
	WHERE 
		serviceOrderNumber = pServiceOrderNumber;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAllSurveyServiceList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllSurveyServiceList$$
CREATE PROCEDURE blackstarDb.GetAllSurveyServiceList()
BEGIN

	SELECT DISTINCT
		s.surveyServiceId AS DT_RowId,
		s.surveyServiceId AS surveyServiceNumber,
		COALESCE(p.customer, c.customerName, '') AS customer,
		COALESCE(p.project, c.project, '') AS project,
		s.surveyDate AS surveyDate,
		s.score AS score
	FROM surveyService s
		INNER JOIN serviceOrder o ON o.surveyServiceId = s.surveyServiceId
		LEFT OUTER JOIN policy p ON o.policyId = p.policyId
		LEFT OUTER JOIN openCustomer c ON c.openCustomerId = o.openCustomerId
	ORDER BY surveyDate DESC;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetPersonalSurveyServiceList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPersonalSurveyServiceList$$
CREATE PROCEDURE blackstarDb.GetPersonalSurveyServiceList(pUser VARCHAR(100))
BEGIN

	SELECT 
		s.surveyServiceId AS DT_RowId,
		s.surveyServiceNumber AS surveyServiceNumber,
		p.customer AS customer,
		p.project AS project,
		s.surveyDate AS surveyDate,
		s.score AS score
	FROM surveyService s
		INNER JOIN serviceOrder o ON o.surveyServiceId = s.surveyServiceId
		INNER JOIN policy p ON o.policyId = p.policyId
		INNER JOIN serviceOrderEmployee e ON e.serviceOrderId = o.serviceOrderId
	WHERE
		e.employeeId = pUser;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAutocompleteEmployeeList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAutocompleteEmployeeList$$
CREATE PROCEDURE blackstarDb.GetAutocompleteEmployeeList(pUserGroup VARCHAR(100))
BEGIN

	SELECT 
		u.name AS label,
		u.email AS value
	FROM blackstarUser_userGroup ug
		INNER JOIN blackstarUser u ON u.blackstarUserId = ug.blackstarUserId
		INNER JOIN userGroup g ON g.userGroupId = ug.userGroupId
	WHERE g.name = pUserGroup
	ORDER BY u.name;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddServiceOrderEmployee
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddServiceOrderEmployee$$
CREATE PROCEDURE blackstarDb.AddServiceOrderEmployee(pSoId INTEGER, pEmployee VARCHAR(100), pCreated DATETIME, pCreatedBy VARCHAR(100), pCreatedByUsr VARCHAR(100))
BEGIN

	INSERT INTO serviceOrderEmployee(
		serviceOrderId,
		employeeId,
		created,
		createdBy,
		createdByUsr
	)
	SELECT
		pSoId,
		pEmployee,
		pCreated,
		pCreatedBy,
		pCreatedByUsr;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrderEmployeeList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrderEmployeeList$$
CREATE PROCEDURE blackstarDb.GetServiceOrderEmployeeList(pSoId INTEGER)
BEGIN

	SELECT 
		email as email,
		name as name
	FROM serviceOrderEmployee s
		INNER JOIN blackstarUser u ON s.employeeId = u.email
	WHERE serviceOrderId = pSoId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrderByNumber
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrderByNumber$$
CREATE PROCEDURE blackstarDb.GetServiceOrderByNumber(pSoNumber VARCHAR(100))
BEGIN

	SELECT *
	FROM serviceOrder s
	WHERE serviceOrderNumber = pSoNumber;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrderById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrderById$$
CREATE PROCEDURE blackstarDb.GetServiceOrderById(pId INTEGER)
BEGIN

	SELECT *
	FROM serviceOrder s
	WHERE serviceOrderId = pId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.LastError
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.LastError$$
CREATE PROCEDURE blackstarDb.LastError()
BEGIN

	SELECT error FROM blackstarManage.errorLog
	ORDER BY errorLogId DESC 
	LIMIT 2;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceCenterIdList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceCenterIdList$$
CREATE PROCEDURE blackstarDb.`GetServiceCenterIdList`()
BEGIN
SELECT *
FROM serviceCenter;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetStatusKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetStatusKPI$$
CREATE PROCEDURE blackstarDb.`GetStatusKPI`(pType CHAR(1), pProject varchar(100), startDate DATETIME, endDate DATETIME, pUser VARCHAR(100))
BEGIN
IF pProject = 'All' THEN
	IF pUser = '' THEN
		SELECT ts.ticketStatus as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND sc.serviceCenterId LIKE pType
		GROUP BY tk.ticketStatusId
		ORDER BY ticketStatus;
	ELSE
		SELECT ts.ticketStatus as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND sc.serviceCenterId LIKE pType
			AND py.equipmentUser = pUser
		GROUP BY tk.ticketStatusId
		ORDER BY ticketStatus;
	END IF;
ELSE
	IF pUser = '' THEN
		SELECT ts.ticketStatus as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND sc.serviceCenterId LIKE pType
			AND py.project = pProject
		GROUP BY tk.ticketStatusId
		ORDER BY ticketStatus;
	ELSE
		SELECT ts.ticketStatus as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND sc.serviceCenterId LIKE pType
			AND py.project = pProject
			AND py.equipmentUser = pUser
		GROUP BY tk.ticketStatusId
		ORDER BY ticketStatus;
	END IF;
END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetTicketsByServiceCenterKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetTicketsByServiceCenterKPI$$
CREATE PROCEDURE blackstarDb.GetTicketsByServiceCenterKPI(pProject varchar(100), startDate DATETIME, endDate DATETIME, pUser VARCHAR(100))
BEGIN
IF pProject = 'All' THEN
	IF pUser = '' THEN
		SELECT sc.serviceCenter as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
		WHERE tk.created >= startDate AND tk.created <= endDate
		GROUP BY sc.serviceCenter;
	ELSE
		SELECT sc.serviceCenter as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND py.equipmentUser = pUser
		GROUP BY sc.serviceCenter;
	END IF;
ELSE
	IF pUser = '' THEN
		SELECT sc.serviceCenter as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND py.project = pProject
		GROUP BY sc.serviceCenter;
	ELSE
		SELECT sc.serviceCenter as name, count(*) as value
		FROM ticket tk
			INNER JOIN policy py on tk.policyId = py.policyId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND py.project = pProject
			AND py.equipmentUser = pUser
		GROUP BY sc.serviceCenter;
	END IF;
END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetReportsByEquipmentTypeKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetReportsByEquipmentTypeKPI$$
CREATE PROCEDURE blackstarDb.GetReportsByEquipmentTypeKPI(pProject varchar(100), startDate DATETIME, endDate DATETIME, pUser VARCHAR(100))
BEGIN
IF pProject = 'All' THEN
	IF pUser = '' THEN
		SELECT et.equipmentType as name , count(*) as value
		FROM ticket tk
			INNER JOIN policy py on py.policyId = tk.policyId
			INNER JOIN equipmentType et ON et.equipmentTypeId = py.equipmentTypeId
		WHERE tk.created >= startDate AND tk.created <= endDate
		GROUP BY py.equipmentTypeId;
	ELSE
		SELECT et.equipmentType as name , count(*) as value
		FROM ticket tk
		INNER JOIN policy py on py.policyId = tk.policyId
		INNER JOIN equipmentType et ON et.equipmentTypeId = py.equipmentTypeId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND py.equipmentUser = pUser
		GROUP BY py.equipmentTypeId;
	END IF;
ELSE
	IF pUser = '' THEN
		SELECT et.equipmentType as name , count(*) as value
		FROM ticket tk
			INNER JOIN policy py on py.policyId = tk.policyId
			INNER JOIN equipmentType et ON et.equipmentTypeId = py.equipmentTypeId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND py.project = pProject
		GROUP BY py.equipmentTypeId;
	ELSE
		SELECT et.equipmentType as name , count(*) as value
		FROM ticket tk
			INNER JOIN policy py on py.policyId = tk.policyId
			INNER JOIN equipmentType et ON et.equipmentTypeId = py.equipmentTypeId
		WHERE tk.created >= startDate AND tk.created <= endDate
			AND py.project = pProject
			AND py.equipmentUser = pUser
		GROUP BY py.equipmentTypeId;
	END IF;
END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetResumeOSKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetResumeOSKPI$$
CREATE PROCEDURE blackstarDb.`GetResumeOSKPI`()
BEGIN
SELECT so.serviceUnit as serviceUnit,
       py.project as project,
       py.customer as customer,
       py.equipmentLocation as equipmentLocation,
       py.equipmentAddress as equipmentAddress,
       so.serviceTypeId as serviceTypeId,
       so.serviceOrderNumber as serviceOrderNumber,
       so.ticketId as ticketId,
       so.created as created,
       py.equipmentTypeId as equipmentTypeId,
       py.brand as brand,
       py.model as model,
       py.serialNumber as serialNumber,
       py.capacity as capacity,
       so.responsible as responsible,
       so.receivedBy as receivedBy,
       so.serviceComments as serviceComments,
       IFNULL(so.closed, '') as closed,
       IFNULL(so.hasErrors, '0') as hasErrors,
       '' as materialUsed,
       py.cst as cst,
       py.finalUser as finalUser,
       ss.qualification as qualification,
       ss.comments as comments
FROM serviceOrder so
INNER JOIN surveyService ss on so.serviceOrderId = ss.serviceOrderId
INNER JOIN policy py on so.policyId = py.policyId
WHERE so.created >= STR_TO_DATE(CONCAT('01-01-',YEAR(NOW())),'%d-%m-%Y');
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetReportOSResumeKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetReportOSResumeKPI$$
CREATE PROCEDURE blackstarDb.`GetReportOSResumeKPI`()
BEGIN
SELECT so.serviceUnit office, count(*) numServiceOrders, survey.obCount numObervations
FROM serviceOrder so
INNER JOIN (SELECT so.serviceUnit, count(*) obCount
            FROM surveyService ss
            INNER JOIN serviceOrder so on so.serviceOrderId = ss.serviceOrderId
            WHERE ss.datePerson >= STR_TO_DATE(CONCAT('01-01-',YEAR(NOW())),'%d-%m-%Y')
            GROUP BY so.serviceUnit) AS survey ON so.serviceUnit = survey.serviceUnit 
WHERE so.closed >= STR_TO_DATE(CONCAT('01-01-',YEAR(NOW())),'%d-%m-%Y')
GROUP BY so.serviceUnit;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetReportOSTableKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetReportOSTableKPI$$
CREATE PROCEDURE blackstarDb.`GetReportOSTableKPI`()
BEGIN
SELECT os.serviceOrderId as serviceOrderId
       , ss.comments as comments
       , ss.serviceComments as serviceComments
       , os.responsible as responsible
       , os.serviceUnit as office
FROM serviceOrder os
INNER JOIN surveyService ss on os.serviceOrderId = ss.serviceOrderId
ORDER BY office ASC;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetMaxReportsByUserKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetMaxReportsByUserKPI$$
CREATE PROCEDURE blackstarDb.GetMaxReportsByUserKPI(project varchar(200), startDate datetime, endDate datetime)
BEGIN
IF(project = 'All') THEN
	SELECT ifnull(tk.contactEmail, 'Sin usuario') as employee,
	       py.customer as customer,
	       tk.created as created,
	       count(*) counter,
	       group_concat(tk.ticketNumber separator ', ') as ticketList
	FROM ticket tk
		INNER JOIN policy py ON tk.policyId = py.policyId
	WHERE tk.employee != ''
		AND tk.created >= startDate AND tk.created <= endDate
	GROUP BY ifnull(tk.contactEmail, 'Sin usuario'), MONTH(tk.created)
	HAVING counter >= 2
	ORDER BY MONTH(tk.created) ASC, counter DESC;
ELSE
	SELECT ifnull(tk.contactEmail, 'Sin usuario') as employee,
	       py.customer as customer,
	       tk.created as created,
	       count(*) counter,
	       group_concat(tk.ticketNumber separator ', ') as ticketList
	FROM ticket tk
		INNER JOIN policy py ON tk.policyId = py.policyId
	WHERE tk.employee != ''
		AND tk.created >= startDate AND tk.created <= endDate
		AND py.project = project
	GROUP BY ifnull(tk.contactEmail, 'Sin usuario'), MONTH(tk.created)
	HAVING counter >= 2
	ORDER BY MONTH(tk.created) ASC, counter DESC;
END IF;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetConcurrentFailuresKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetConcurrentFailuresKPI$$
CREATE PROCEDURE blackstarDb.`GetConcurrentFailuresKPI`(project varchar(200), startDate datetime, endDate datetime, user VARCHAR(100))
BEGIN
	IF project = 'All' THEN
		IF user = '' THEN
			SELECT 
				t1.ticketId, 
				t1.created as created,
				t1.ticketNumber as ticketNumber, 
				p1.customer as customer,
				et.equipmentType as equipmentTypeId,
				p1.brand as brand,
				p1.serialNumber as serialNumber,
				t1.observations as observations,
				t2.ticketNumber as lastTicketNumber,
				t2.closed as lastTicketClosed,
				t2.employee as employee
			FROM ticket t1
			INNER JOIN policy p1 on t1.policyId = p1.policyId
			INNER JOIN equipmentType et ON p1.equipmentTypeId = et.equipmentTypeId
			INNER JOIN policy p2 on p1.equipmentTypeId = p2.equipmentTypeId 
				AND p1.brand = p2.brand 
				AND p1.serialNumber = p2.serialNumber
			INNER JOIN ticket t2  on t2.policyId = p2.policyId 
				AND t2.ticketId = (SELECT t3.ticketId FROM ticket t3 WHERE t3.policyId = p2.policyId AND t3.ticketId < t1.ticketId ORDER BY created DESC LIMIT 1)
				AND DATEDIFF(t1.created, t2.created) <= 15
			WHERE t1.created >= startDate and t1.created <= endDate
			ORDER BY t1.created DESC;
		ELSE
			SELECT
				t1.ticketId, 
				t1.created as created,
				t1.ticketNumber as ticketNumber, 
				p1.customer as customer,
				et.equipmentType as equipmentTypeId,
				p1.brand as brand,
				p1.serialNumber as serialNumber,
				t1.observations as observations,
				t2.ticketNumber as lastTicketNumber,
				t2.closed as lastTicketClosed,
				t2.employee as employee
			FROM ticket t1
			INNER JOIN policy p1 on t1.policyId = p1.policyId
			INNER JOIN equipmentType et ON p1.equipmentTypeId = et.equipmentTypeId
			INNER JOIN policy p2 on p1.equipmentTypeId = p2.equipmentTypeId 
				AND p1.brand = p2.brand 
				AND p1.serialNumber = p2.serialNumber
			INNER JOIN ticket t2  on t2.policyId = p2.policyId 
				AND t2.ticketId = (SELECT t3.ticketId FROM ticket t3 WHERE t3.policyId = p2.policyId AND t3.ticketId < t1.ticketId ORDER BY created DESC LIMIT 1)
				AND DATEDIFF(t1.created, t2.created) <= 15
			WHERE t1.created >= startDate and t1.created <= endDate
				AND p1.equipmentUser = user
			ORDER BY t1.created DESC;
		END IF;
	ELSE
		IF user = '' THEN
			SELECT 
				t1.ticketId, 
				t1.created as created,
				t1.ticketNumber as ticketNumber, 
				p1.customer as customer,
				et.equipmentType as equipmentTypeId,
				p1.brand as brand,
				p1.serialNumber as serialNumber,
				t1.observations as observations,
				t2.ticketNumber as lastTicketNumber,
				t2.closed as lastTicketClosed,
				t2.employee as employee
			FROM ticket t1
			INNER JOIN policy p1 on t1.policyId = p1.policyId
			INNER JOIN equipmentType et ON p1.equipmentTypeId = et.equipmentTypeId
			INNER JOIN policy p2 on p1.equipmentTypeId = p2.equipmentTypeId 
				AND p1.brand = p2.brand 
				AND p1.serialNumber = p2.serialNumber
			INNER JOIN ticket t2  on t2.policyId = p2.policyId 
				AND t2.ticketId = (SELECT t3.ticketId FROM ticket t3 WHERE t3.policyId = p2.policyId AND t3.ticketId < t1.ticketId ORDER BY created DESC LIMIT 1)
				AND DATEDIFF(t1.created, t2.created) <= 15
			WHERE t1.created >= startDate and t1.created <= endDate
			AND p1.project = project
			ORDER BY t1.created DESC;
		ELSE
			SELECT 
				t1.ticketId, 
				t1.created as created,
				t1.ticketNumber as ticketNumber, 
				p1.customer as customer,
				et.equipmentType as equipmentTypeId,
				p1.brand as brand,
				p1.serialNumber as serialNumber,
				t1.observations as observations,
				t2.ticketNumber as lastTicketNumber,
				t2.closed as lastTicketClosed,
				t2.employee as employee
			FROM ticket t1
			INNER JOIN policy p1 on t1.policyId = p1.policyId
			INNER JOIN equipmentType et ON p1.equipmentTypeId = et.equipmentTypeId
			INNER JOIN policy p2 on p1.equipmentTypeId = p2.equipmentTypeId 
				AND p1.brand = p2.brand 
				AND p1.serialNumber = p2.serialNumber
			INNER JOIN ticket t2  on t2.policyId = p2.policyId 
				AND t2.ticketId = (SELECT t3.ticketId FROM ticket t3 WHERE t3.policyId = p2.policyId AND t3.ticketId < t1.ticketId ORDER BY created DESC LIMIT 1)
				AND DATEDIFF(t1.created, t2.created) <= 15
			WHERE t1.created >= startDate and t1.created <= endDate
			AND p1.project = project
			AND p1.equipmentUser = user 
			ORDER BY t1.created DESC;
		END IF;
		
	END IF;
	

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetPoliciesKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPoliciesKPI$$
CREATE PROCEDURE blackstarDb.`GetPoliciesKPI`(search VARCHAR(100), pProject VARCHAR(100), pStartDate DATETIME, pEndDate DATETIME, pUser VARCHAR(100))
BEGIN
	IF pProject = 'ALL' THEN
		IF pUser = '' THEN
			SELECT py.policyId as policyId,
		       IFNULL(of.officeName, '') as officeName,
		       IFNULL(py.policyTypeId, '') as  policyTypeId,
		       IFNULL(py.customerContract, '') as customerContract,
		       IFNULL(py.customer, '') as customer,
		       IFNULL(py.finalUser, '') as finalUser,
		       IFNULL(py.project, '') as project,
		       IFNULL(py.cst, '') as cst,
		       IFNULL(eq.equipmentType, '') as equipmentType,
		       IFNULL(py.brand, '') as brand,
		       IFNULL(py.model, '') as model,
		       IFNULL(py.serialNumber, '') as serialNumber,
		       IFNULL(py.capacity, '') as capacity,
		       IFNULL(py.equipmentAddress, '') as equipmentAddress,
		       IFNULL(py.equipmentLocation, '') as equipmentLocation,
		       IFNULL(py.contactName, '') as contactName,
		       IFNULL(py.contactEmail, '') as contactEmail,
		       IFNULL(py.contactPhone, '') as contactPhone,
		       IFNULL(py.startDate, '') as startDate,
		       IFNULL(py.endDate, '') as endDate,
		       IFNULL(py.visitsPerYear, '') as visitsPerYear,
		       IFNULL(py.responseTimeHR, '') as responseTimeHR,
		       IFNULL(py.solutionTimeHR, '') as solutionTimeHR,
		       IFNULL(py.penalty, '') as penalty,
		       IFNULL(py.service, '') as service,
		       IFNULL(py.includesParts, '') as includesParts,
		       IFNULL(py.exceptionParts, '') as exceptionParts,
		       IFNULL(sc.serviceCenter, '') as serviceCenter
			FROM policy py
			INNER JOIN office of ON py.officeId = of.officeId
			INNER JOIN equipmentType eq ON eq.equipmentTypeId = py.equipmentTypeId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			WHERE py.endDate >= DATE_ADD(pStartDate, INTERVAL -2 MONTH) AND py.startDate < pEndDate
				AND (of.officeName LIKE CONCAT('%', search, '%') OR
				py.customerContract LIKE CONCAT('%', search, '%') OR
				py.customer LIKE CONCAT('%', search, '%') OR
				py.project LIKE CONCAT('%', search, '%') OR
				py.cst LIKE CONCAT('%', search, '%') OR
				py.brand LIKE CONCAT('%', search, '%') OR
				py.model LIKE CONCAT('%', search, '%') OR
				py.serialNumber LIKE CONCAT('%', search, '%') OR
				py.contactName LIKE CONCAT('%', search, '%')) 
			ORDER BY py.endDate ASC;
		ELSE
			SELECT py.policyId as policyId,
		       IFNULL(of.officeName, '') as officeName,
		       IFNULL(py.policyTypeId, '') as  policyTypeId,
		       IFNULL(py.customerContract, '') as customerContract,
		       IFNULL(py.customer, '') as customer,
		       IFNULL(py.finalUser, '') as finalUser,
		       IFNULL(py.project, '') as project,
		       IFNULL(py.cst, '') as cst,
		       IFNULL(eq.equipmentType, '') as equipmentType,
		       IFNULL(py.brand, '') as brand,
		       IFNULL(py.model, '') as model,
		       IFNULL(py.serialNumber, '') as serialNumber,
		       IFNULL(py.capacity, '') as capacity,
		       IFNULL(py.equipmentAddress, '') as equipmentAddress,
		       IFNULL(py.equipmentLocation, '') as equipmentLocation,
		       IFNULL(py.contactName, '') as contactName,
		       IFNULL(py.contactEmail, '') as contactEmail,
		       IFNULL(py.contactPhone, '') as contactPhone,
		       IFNULL(py.startDate, '') as startDate,
		       IFNULL(py.endDate, '') as endDate,
		       IFNULL(py.visitsPerYear, '') as visitsPerYear,
		       IFNULL(py.responseTimeHR, '') as responseTimeHR,
		       IFNULL(py.solutionTimeHR, '') as solutionTimeHR,
		       IFNULL(py.penalty, '') as penalty,
		       IFNULL(py.service, '') as service,
		       IFNULL(py.includesParts, '') as includesParts,
		       IFNULL(py.exceptionParts, '') as exceptionParts,
		       IFNULL(sc.serviceCenter, '') as serviceCenter
			FROM policy py
			INNER JOIN office of ON py.officeId = of.officeId
			INNER JOIN equipmentType eq ON eq.equipmentTypeId = py.equipmentTypeId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			WHERE py.endDate >= DATE_ADD(pStartDate, INTERVAL -2 MONTH) AND py.startDate < pEndDate
				AND (of.officeName LIKE CONCAT('%', search, '%') OR
				py.customerContract LIKE CONCAT('%', search, '%') OR
				py.customer LIKE CONCAT('%', search, '%') OR
				py.project LIKE CONCAT('%', search, '%') OR
				py.cst LIKE CONCAT('%', search, '%') OR
				py.brand LIKE CONCAT('%', search, '%') OR
				py.model LIKE CONCAT('%', search, '%') OR
				py.serialNumber LIKE CONCAT('%', search, '%') OR
				py.contactName LIKE CONCAT('%', search, '%')) 
				AND	py.equipmentUser = pUser
			ORDER BY py.endDate ASC;
		END IF;
		
	ELSE
		IF pUser = '' THEN
			SELECT py.policyId as policyId,
			       IFNULL(of.officeName, '') as officeName,
			       IFNULL(py.policyTypeId, '') as  policyTypeId,
			       IFNULL(py.customerContract, '') as customerContract,
			       IFNULL(py.customer, '') as customer,
			       IFNULL(py.finalUser, '') as finalUser,
			       IFNULL(py.project, '') as project,
			       IFNULL(py.cst, '') as cst,
			       IFNULL(eq.equipmentType, '') as equipmentType,
			       IFNULL(py.brand, '') as brand,
			       IFNULL(py.model, '') as model,
			       IFNULL(py.serialNumber, '') as serialNumber,
			       IFNULL(py.capacity, '') as capacity,
			       IFNULL(py.equipmentAddress, '') as equipmentAddress,
			       IFNULL(py.equipmentLocation, '') as equipmentLocation,
			       IFNULL(py.contactName, '') as contactName,
			       IFNULL(py.contactEmail, '') as contactEmail,
			       IFNULL(py.contactPhone, '') as contactPhone,
			       IFNULL(py.startDate, '') as startDate,
			       IFNULL(py.endDate, '') as endDate,
			       IFNULL(py.visitsPerYear, '') as visitsPerYear,
			       IFNULL(py.responseTimeHR, '') as responseTimeHR,
			       IFNULL(py.solutionTimeHR, '') as solutionTimeHR,
			       IFNULL(py.penalty, '') as penalty,
			       IFNULL(py.service, '') as service,
			       IFNULL(py.includesParts, '') as includesParts,
			       IFNULL(py.exceptionParts, '') as exceptionParts,
			       IFNULL(sc.serviceCenter, '') as serviceCenter
			FROM policy py
			INNER JOIN office of ON py.officeId = of.officeId
			INNER JOIN equipmentType eq ON eq.equipmentTypeId = py.equipmentTypeId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			WHERE py.endDate >= DATE_ADD(pStartDate, INTERVAL -2 MONTH) AND py.startDate < pEndDate
			AND (of.officeName LIKE CONCAT('%', search, '%') OR
				py.customerContract LIKE CONCAT('%', search, '%') OR
				py.customer LIKE CONCAT('%', search, '%') OR
				py.project LIKE CONCAT('%', search, '%') OR
				py.cst LIKE CONCAT('%', search, '%') OR
				py.brand LIKE CONCAT('%', search, '%') OR
				py.model LIKE CONCAT('%', search, '%') OR
				py.serialNumber LIKE CONCAT('%', search, '%') OR
				py.contactName LIKE CONCAT('%', search, '%')) 
			AND project = pProject
			ORDER BY py.endDate ASC;
		ELSE
			SELECT py.policyId as policyId,
			       IFNULL(of.officeName, '') as officeName,
			       IFNULL(py.policyTypeId, '') as  policyTypeId,
			       IFNULL(py.customerContract, '') as customerContract,
			       IFNULL(py.customer, '') as customer,
			       IFNULL(py.finalUser, '') as finalUser,
			       IFNULL(py.project, '') as project,
			       IFNULL(py.cst, '') as cst,
			       IFNULL(eq.equipmentType, '') as equipmentType,
			       IFNULL(py.brand, '') as brand,
			       IFNULL(py.model, '') as model,
			       IFNULL(py.serialNumber, '') as serialNumber,
			       IFNULL(py.capacity, '') as capacity,
			       IFNULL(py.equipmentAddress, '') as equipmentAddress,
			       IFNULL(py.equipmentLocation, '') as equipmentLocation,
			       IFNULL(py.contactName, '') as contactName,
			       IFNULL(py.contactEmail, '') as contactEmail,
			       IFNULL(py.contactPhone, '') as contactPhone,
			       IFNULL(py.startDate, '') as startDate,
			       IFNULL(py.endDate, '') as endDate,
			       IFNULL(py.visitsPerYear, '') as visitsPerYear,
			       IFNULL(py.responseTimeHR, '') as responseTimeHR,
			       IFNULL(py.solutionTimeHR, '') as solutionTimeHR,
			       IFNULL(py.penalty, '') as penalty,
			       IFNULL(py.service, '') as service,
			       IFNULL(py.includesParts, '') as includesParts,
			       IFNULL(py.exceptionParts, '') as exceptionParts,
			       IFNULL(sc.serviceCenter, '') as serviceCenter
			FROM policy py
			INNER JOIN office of ON py.officeId = of.officeId
			INNER JOIN equipmentType eq ON eq.equipmentTypeId = py.equipmentTypeId
			INNER JOIN serviceCenter sc ON py.serviceCenterId = sc.serviceCenterId
			WHERE py.endDate >= DATE_ADD(pStartDate, INTERVAL -2 MONTH) AND py.startDate < pEndDate
			AND (of.officeName LIKE CONCAT('%', search, '%') OR
				py.customerContract LIKE CONCAT('%', search, '%') OR
				py.customer LIKE CONCAT('%', search, '%') OR
				py.project LIKE CONCAT('%', search, '%') OR
				py.cst LIKE CONCAT('%', search, '%') OR
				py.brand LIKE CONCAT('%', search, '%') OR
				py.model LIKE CONCAT('%', search, '%') OR
				py.serialNumber LIKE CONCAT('%', search, '%') OR
				py.contactName LIKE CONCAT('%', search, '%'))
			AND py.equipmentUser = pUser
			AND project = pProject
			ORDER BY py.endDate ASC;
		END IF;
		
	END IF;
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.GetTicketsKPI
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetTicketsKPI$$
CREATE PROCEDURE blackstarDb.GetTicketsKPI(pProject VARCHAR(100), pStartDate DATETIME, pEndDate DATETIME, pUser VARCHAR(100))
BEGIN

IF pProject = 'ALL' THEN
	IF pUser = '' THEN
		SELECT 
			tk.ticketId AS DT_RowId,
			tk.ticketNumber AS ticketNumber,
			tk.created AS created,
			p.customer AS customer,
			et.equipmentType AS equipmentType,
			ts.ticketStatus AS ticketStatus,
			IFNULL(bu.name, tk.employee) AS asignee,
		    IFNULL(p.equipmentLocation, '') AS equipmentLocation,
		    IFNULL(p.brand, '') AS equipmentBrand,
		    IFNULL(tk.arrival, '') AS arrival,
		    IFNULL(tk.closed, '') AS closed
		FROM ticket tk 
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
			INNER JOIN policy p ON tk.policyId = p.policyId
			INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office of on p.officeId = of.officeId
			LEFT OUTER JOIN blackstarUser bu ON bu.email = tk.asignee
		WHERE tk.created >= pStartDate AND tk.created <= pEndDate
	    ORDER BY tk.created ASC;
	ELSE
		SELECT 
			tk.ticketId AS DT_RowId,
			tk.ticketNumber AS ticketNumber,
			tk.created AS created,
			p.customer AS customer,
			et.equipmentType AS equipmentType,
			ts.ticketStatus AS ticketStatus,
			IFNULL(bu.name, tk.employee) AS asignee,
		    IFNULL(p.equipmentLocation, '') AS equipmentLocation,
		    IFNULL(p.brand, '') AS equipmentBrand,
		    IFNULL(tk.arrival, '') AS arrival,
		    IFNULL(tk.closed, '') AS closed
		FROM ticket tk 
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
			INNER JOIN policy p ON tk.policyId = p.policyId
			INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office of on p.officeId = of.officeId
			LEFT OUTER JOIN blackstarUser bu ON bu.email = tk.asignee
		WHERE tk.created >= pStartDate AND tk.created <= pEndDate
		AND p.equipmentUser = pUser
	    ORDER BY tk.created ASC;
	END IF;
	
ELSE
	IF pUser = '' THEN
		SELECT 
			tk.ticketId AS DT_RowId,
			tk.ticketNumber AS ticketNumber,
			tk.created AS created,
			p.customer AS customer,
			et.equipmentType AS equipmentType,
			ts.ticketStatus AS ticketStatus,
			IFNULL(bu.name, tk.employee) AS asignee,
		    IFNULL(p.equipmentLocation, '') AS equipmentLocation,
		    IFNULL(p.brand, '') AS equipmentBrand,
		    IFNULL(tk.arrival, '') AS arrival,
		    IFNULL(tk.closed, '') AS closed
		FROM ticket tk 
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
			INNER JOIN policy p ON tk.policyId = p.policyId
			INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office of on p.officeId = of.officeId
			LEFT OUTER JOIN blackstarUser bu ON bu.email = tk.asignee
		WHERE tk.created >= pStartDate AND tk.created <= pEndDate
		AND p.project = pProject
	    ORDER BY tk.created ASC;
	ELSE
		SELECT 
			tk.ticketId AS DT_RowId,
			tk.ticketNumber AS ticketNumber,
			tk.created AS created,
			p.customer AS customer,
			et.equipmentType AS equipmentType,
			ts.ticketStatus AS ticketStatus,
			IFNULL(bu.name, tk.employee) AS asignee,
		    IFNULL(p.equipmentLocation, '') AS equipmentLocation,
		    IFNULL(p.brand, '') AS equipmentBrand,
		    IFNULL(tk.arrival, '') AS arrival,
		    IFNULL(tk.closed, '') AS closed
		FROM ticket tk 
			INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
			INNER JOIN policy p ON tk.policyId = p.policyId
			INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office of on p.officeId = of.officeId
			LEFT OUTER JOIN blackstarUser bu ON bu.email = tk.asignee
		WHERE tk.created >= pStartDate AND tk.created <= pEndDate
		AND p.project = pProject
		AND p.equipmentUser = pUser
	    ORDER BY tk.created ASC;
	END IF;
END IF;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextServiceNumberForTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextServiceNumberForTicket$$
CREATE PROCEDURE blackstarDb.GetNextServiceNumberForTicket()
BEGIN

	DECLARE newNumber INTEGER;

	-- Obteniendo el numero de folio
	CALL blackstarDb.GetNextServiceOrderNumber('O', newNumber);

	-- Regresando el numero de folio completo
	SELECT CONCAT('OS-', lpad(cast(newNumber AS CHAR(50)), 5, '0'), '-e') AS ServiceNumber;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceStatusList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceStatusList$$
CREATE PROCEDURE blackstarDb.GetServiceStatusList()
BEGIN

	SELECT
		serviceStatusId AS serviceStatusId,
		serviceStatus AS serviceStatus
	FROM serviceStatus
	ORDER BY serviceStatus;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrderTypeBySOId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentTypeBySOId$$
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrderTypeBySOId$$
CREATE PROCEDURE blackstarDb.GetServiceOrderTypeBySOId(pServiceOrderId INT)
BEGIN

	IF(SELECT COUNT(*) FROM aaService WHERE serviceOrderId = pServiceOrderId) > 0 THEN
		SELECT 'A' AS SoTypeId;
	ELSE
		IF(SELECT COUNT(*) FROM bbService WHERE serviceOrderId = pServiceOrderId) > 0 THEN
			SELECT 'B' AS SoTypeId;
		ELSE
			IF(SELECT COUNT(*) FROM epService WHERE serviceOrderId = pServiceOrderId) > 0 THEN
				SELECT 'P' AS SoTypeId;
			ELSE
				IF(SELECT COUNT(*) FROM upsService WHERE serviceOrderId = pServiceOrderId) > 0 THEN
					SELECT 'U' AS SoTypeId;
				ELSE
					SELECT 'X' AS SoTypeId;
				END IF;
			END IF;
		END IF;
	END IF;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceTypeById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceTypeById$$
CREATE PROCEDURE blackstarDb.GetServiceTypeById(pType CHAR(1))
BEGIN

	-- TODO: codigo heredado, revisar SELECT
	SELECT * FROM serviceType WHERE serviceTypeId = pType;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceTypeList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceTypeList$$
CREATE PROCEDURE blackstarDb.GetServiceTypeList()
BEGIN

	SELECT 
		serviceTypeId AS serviceTypeId,
		serviceType AS serviceType
	FROM serviceType
	ORDER BY serviceType;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CloseOS
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CloseOS$$
CREATE PROCEDURE blackstarDb.CloseOS(pServiceOrderId INTEGER, pUser VARCHAR(100))
BEGIN

	UPDATE serviceOrder SET
		serviceStatusId = 'C',
		closed = NOW(),
		modified = NOW(),
		modifiedBy = 'CloseOS',
		modifiedByUsr = pUser
	WHERE
		serviceOrderId = pServiceOrderId;
END$$
	
-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEquipmentByType
	--
	-- Este SP se utiliza especificamente para recuperar valores destinados
	-- a poblar un campo autocomplete. No cambiar las etiquetas
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentByType$$
CREATE PROCEDURE blackstarDb.GetEquipmentByType(pEquipmentTypeId CHAR(1))
BEGIN
	IF(pEquipmentTypeId = 'T' OR pEquipmentTypeId = 'X') THEN
		SELECT 
			concat_ws(' - ', brand, model, serialNumber) AS label,
			serialNumber AS value
		FROM policy p
		WHERE p.startDate < CURDATE() AND p.endDate > CURDATE()
		ORDER BY brand, model, serialNumber;
	ELSE
		SELECT 
			concat_ws(' - ', brand, model, serialNumber) AS label,
			serialNumber AS value
		FROM policy p
		WHERE equipmentTypeId = pEquipmentTypeId
		AND p.startDate < CURDATE() AND p.endDate > CURDATE()
		ORDER BY brand, model, serialNumber;
	END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAllServiceOrders
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllServiceOrders$$
CREATE PROCEDURE blackstarDb.GetAllServiceOrders()
BEGIN

	SELECT * FROM(
		SELECT 
			so.ServiceOrderId AS DT_RowId,
			so.serviceOrderNumber AS serviceOrderNumber,
			'' AS placeHolder,
			IFNULL(t.ticketNumber, '') AS ticketNumber,
			st.serviceType AS serviceType,
			DATE(so.serviceDate) AS serviceDate,
			p.customer AS customer,
			et.equipmentType AS equipmentType,
			p.project AS project,
			of.officeName AS officeName,
			p.brand AS brand,
			p.serialNumber AS serialNumber,
			ss.serviceStatus AS serviceStatus,
			so.hasPdf AS hasPdf
		FROM serviceOrder so 
			INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
			INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
			INNER JOIN policy p ON so.policyId = p.policyId
			INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office of on p.officeId = of.officeId
	     LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
	     UNION
	     SELECT 
			so.ServiceOrderId AS DT_RowId,
			so.serviceOrderNumber AS serviceOrderNumber,
			'' AS placeHolder,
			IFNULL(t.ticketNumber, '') AS ticketNumber,
			st.serviceType AS serviceType,
			DATE(so.serviceDate) AS serviceDate,
			oc.customerName AS customer,
			et.equipmentType AS equipmentType,
			oc.project AS project,
			o.officeName AS officeName,
			oc.brand AS brand,
			oc.serialNumber AS serialNumber,
			ss.serviceStatus AS serviceStatus,
			so.hasPdf AS hasPdf
		FROM serviceOrder so 
			INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
			INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
			INNER JOIN openCustomer oc ON so.openCustomerId = oc.openCustomerId
			INNER JOIN equipmentType et ON oc.equipmentTypeId = et.equipmentTypeId
			INNER JOIN office o ON oc.officeId = o.officeId
	     LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
	) A
	ORDER BY A.serviceDate DESC;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFutureServicesSchedule
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFutureServicesSchedule$$
CREATE PROCEDURE blackstarDb.GetFutureServicesSchedule(pServiceDate DATETIME)
BEGIN

	SELECT DISTINCT
		s.scheduledServiceId AS scheduledServiceId,
		serviceDate AS scheduledDate,
		equipmentType AS equipmentType,
		ifnull(p.customer, oc.customerName) AS customer,
		s.project AS project,
		ifnull(p.serialNumber, oc.serialNumber) AS serialNumber,
		officeName AS officeName,
		ifnull(p.brand, oc.brand) AS brand,
		us.name AS employee
	FROM blackstarDb.scheduledService s
		LEFT OUTER JOIN blackstarDb.scheduledServicePolicy sp ON sp.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER JOIN blackstarDb.openCustomer oc ON oc.openCustomerId = s.openCustomerId
		LEFT OUTER  JOIN blackstarDb.scheduledServiceDate sd ON sd.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER  JOIN blackstarDb.policy p ON sp.policyId = p.policyId
		LEFT OUTER  JOIN blackstarDb.serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER  JOIN blackstarDb.equipmentType et ON et.equipmentTypeId = ifnull(p.equipmentTypeId, oc.equipmentTypeId)
		LEFT OUTER  JOIN blackstarDb.scheduledServiceEmployee em ON em.scheduledServiceId = s.scheduledServiceId AND em.isDefault = 1
		LEFT OUTER  JOIN blackstarDb.blackstarUser us ON us.email = em.employeeId
		LEFT OUTER  JOIN blackstarDb.office o ON o.officeId = ifnull(p.officeId, oc.officeId)
	WHERE s.serviceStatusId = 'P'
		AND serviceDate >= pServiceDate
	ORDER BY equipmentType;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddScheduledServiceDate
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddScheduledServiceDate$$
CREATE PROCEDURE blackstarDb.AddScheduledServiceDate(pScheduledServiceId INTEGER, pDate DATETIME, pCreatedBy VARCHAR(100), pUser VARCHAR(100))
BEGIN

	INSERT INTO scheduledServiceDate(
			scheduledServiceId,
			serviceDate,
			created,
			createdBy,
			createdByUsr
	)
	SELECT 
		pScheduledServiceId,
		pDate,
		NOW(),
		pCreatedBy,
		pUser;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetPersonalServiceOrders
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPersonalServiceOrders$$
CREATE PROCEDURE blackstarDb.GetPersonalServiceOrders(pUser VARCHAR(100))
BEGIN

	SELECT 
		so.serviceOrderId AS DT_RowId,
		so.serviceOrderNumber AS serviceOrderNumber,
		'' AS placeHolder,
		ifnull(t.ticketNumber, '') AS ticketNumber,
		st.serviceType AS serviceType,
		date(so.serviceDate) AS serviceDate,
		p.customer AS customer,
		et.equipmentType AS equipmentType,
		p.project AS project,
		o.officeName AS officeName,
		p.brand AS brand,
		p.serialNumber AS serialNumber
	FROM serviceOrder so
		INNER JOIN serviceStatus ss ON ss.serviceStatusId = so.serviceStatusId
		LEFT OUTER JOIN ticket t ON t.ticketId = so.ticketId
		INNER JOIN serviceType st ON st.serviceTypeId = so.serviceTypeId
		INNER JOIN policy p ON p.policyId = so.policyId
		INNER JOIN equipmentType et ON et.equipmentTypeId = p.equipmentTypeId
		INNER JOIN office o ON p.officeId = o.officeId
		LEFT OUTER JOIN serviceOrderEmployee se ON so.serviceOrderId = se.serviceOrderId
	WHERE serviceStatus IN ('NUEVO', 'PENDIENTE')
	AND (so.asignee = pUser OR se.employeeId = pUser)
	ORDER BY serviceDate DESC;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAssignedTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAssignedTickets$$
CREATE PROCEDURE blackstarDb.GetAssignedTickets(pUser VARCHAR(100))
BEGIN

	SELECT 
		t.ticketId AS DT_RowId,
		t.ticketNumber AS ticketNumber,
		t.created AS ticketDate,
		p.customer AS customer,
		e.equipmentType AS equipmentType,
		p.responseTimeHR AS responseTime,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		'' AS placeHolder
	FROM ticket t
		INNER JOIN policy p ON p.policyId = t.policyId
		INNER JOIN equipmentType e ON e.equipmentTypeId = p.equipmentTypeId
		INNER JOIN ticketStatus ts ON t.ticketStatusId = ts.ticketStatusId
	WHERE t.asignee = pUser
	AND t.closed IS NULL
	ORDER BY ticketDate;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddScheduledServiceEmployee
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddScheduledServiceEmployee$$
CREATE PROCEDURE blackstarDb.AddScheduledServiceEmployee(pScheduledServiceId INTEGER, pEmployeeId VARCHAR(100), pIsDefault INT, pCreatedBy VARCHAR(100), pUser VARCHAR(100))
BEGIN

	INSERT INTO scheduledServiceEmployee(
			scheduledServiceId,
			employeeId,
			isDefault,
			created,
			createdBy,
			createdByUsr
	)
	SELECT 
		pScheduledServiceId,
		pEmployeeId,
		pIsDefault,
		NOW(),
		pCreatedBy,
		pUser;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddScheduledServicePolicy
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddScheduledServicePolicy$$
CREATE PROCEDURE blackstarDb.AddScheduledServicePolicy(pScheduledServiceId INTEGER, pPolicyId INTEGER, pCreatedBy VARCHAR(100), pUser VARCHAR(100))
BEGIN

	INSERT INTO scheduledServicePolicy(
			scheduledServiceId,
			policyId,
			created,
			createdBy,
			createdByUsr
	)
	SELECT 
		pScheduledServiceId,
		pPolicyId,
		NOW(),
		pCreatedBy,
		pUser;
END$$
	
-- -----------------------------------------------------------------------------
	-- blackstarDb.GetScheduledServices
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetScheduledServices$$
CREATE PROCEDURE blackstarDb.GetScheduledServices(pUser VARCHAR(100))
BEGIN

SELECT 
	ss.scheduledServiceId AS DT_RowId,
	sd.serviceDate AS serviceDate,
	p.customer AS customer,
	e.equipmentType AS equipmentType,
	p.project AS project,
	o.officeName AS officeName,
	p.brand AS brand,
	p.serialNumber AS serialNumber
	FROM 
		scheduledService ss
		INNER JOIN scheduledServiceDate sd ON ss.scheduledServiceId = sd.scheduledServiceId
		INNER JOIN scheduledServiceEmployee se ON se.scheduledServiceId = ss.scheduledServiceId
		INNER JOIN scheduledServicePolicy sp ON sp.scheduledServiceId = ss.scheduledServiceId
		INNER JOIN policy p ON p.policyId = sp.policyId
		INNER JOIN equipmentType e ON e.equipmentTypeId = p.equipmentTypeId
		INNER JOIN office o ON o.officeId = p.officeId
	WHERE employeeId = pUser
	ORDER BY serviceDate;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextServiceNumberForType
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextServiceNumberForEquipment$$
DROP PROCEDURE IF EXISTS blackstarDb.GetNextServiceNumberForType$$
CREATE PROCEDURE blackstarDb.GetNextServiceNumberForType(eqType VARCHAR(10))
BEGIN
	DECLARE prefix VARCHAR(10);
	DECLARE newNumber INTEGER;

	-- Cambiando a O por default
	IF eqType NOT IN('A', 'B', 'P', 'U') THEN
		SELECT 'O' into eqType;
	END IF;

	SET prefix = (SELECT CASE 
		WHEN eqType = 'A' THEN 'AA-' 
		WHEN eqType = 'B' THEN 'BB-'
		WHEN eqType = 'P' THEN 'PE-'
		WHEN eqType = 'U' THEN 'UPS-'
		ELSE 'OS-' END);

	-- Obteniendo el numero de folio
	CALL blackstarDb.GetNextServiceOrderNumber(eqType, newNumber);

	-- Regresando el numero de folio completo
	SELECT CONCAT(prefix, lpad(cast(newNumber AS CHAR(50)), 5, '0'), '-e') AS ServiceNumber;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetDomainEmployeesByGroup
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetDomainEmployeesByGroup$$
CREATE PROCEDURE blackstarDb.GetDomainEmployeesByGroup(pUserGroup VARCHAR(100))
BEGIN

	SELECT 
		u.email AS DT_RowId, 
		u.email AS email, 
		u.name AS employee
	FROM blackstarUser_userGroup ug
		INNER JOIN blackstarUser u ON u.blackstarUserId = ug.blackstarUserId
		INNER JOIN userGroup g ON g.userGroupId = ug.userGroupId
	WHERE g.name = pUserGroup
	ORDER BY u.name;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetProjectList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetProjectList$$
CREATE PROCEDURE blackstarDb.GetProjectList()
BEGIN

	SELECT DISTINCT 
		project as project
	FROM blackstarDb.policy
		WHERE startDate <= NOW() AND NOW() <= endDate
	ORDER BY project;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetOfficesList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetOfficesList$$
CREATE PROCEDURE blackstarDb.GetOfficesList()
BEGIN

	SELECT DISTINCT
		officeName as officeName
	FROM blackstarDb.office 
	ORDER BY officeName;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAndIncreaseSequence
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAndIncreaseSequence$$
CREATE PROCEDURE blackstarDb.GetAndIncreaseSequence(pSequenceTypeId CHAR(1), OUT nextNum INTEGER)
BEGIN

	-- Recuperar el numero de secuencia actual
	DECLARE seqNum INTEGER;
	SELECT sequenceNumber into seqNum FROM sequence WHERE sequenceTypeId = pSequenceTypeId;

	-- Incrementar el numero en la BD
	UPDATE sequence SET
		sequenceNumber = (seqNum + 1)
	WHERE sequenceTypeId = pSequenceTypeId;

	-- Regresar el numero actual
	SELECT seqNum into nextNum;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.LoadNewSequencePoolItems
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.LoadNewSequencePoolItems$$
CREATE PROCEDURE blackstarDb.LoadNewSequencePoolItems(pSequenceNumberTypeId CHAR(1))
BEGIN

	-- Verificar cuantos numeros hay actualmente
	DECLARE poolItems INTEGER;
	DECLARE newNumber INTEGER;

	SELECT count(*) into poolItems FROM sequenceNumberPool WHERE sequenceNumberTypeId = pSequenceNumberTypeId AND sequenceNumberStatus = 'U';

	-- Cargar nuevo numero en el pool
	CALL blackstarDb.GetAndIncreaseSequence(pSequenceNumberTypeId, newNumber);

	INSERT INTO sequenceNumberPool(sequenceNumberTypeId, sequenceNumber, sequenceNumberStatus)
	SELECT pSequenceNumberTypeId, newNumber, 'U';

	SELECT count(*) into poolItems FROM sequenceNumberPool WHERE sequenceNumberTypeId = pSequenceNumberTypeId AND sequenceNumberStatus = 'U';

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CommitServiceOrderNumber
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CommitServiceOrderNumber$$
CREATE PROCEDURE blackstarDb.CommitServiceOrderNumber(pSequenceNumber INTEGER, pSequenceNumberTypeId CHAR(1))
BEGIN

	-- Borrar numero del pool
	DELETE FROM sequenceNumberPool WHERE sequenceNumber = pSequenceNumber AND sequenceNumberTypeId = pSequenceNumberTypeId;

	-- Cargar nuevos numeros
	CALL blackstarDb.LoadNewSequencePoolItems(pSequenceNumberTypeId);
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextServiceOrderNumber
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextServiceOrderNumber$$
CREATE PROCEDURE blackstarDb.GetNextServiceOrderNumber(pSequenceNumberTypeId CHAR(1), OUT nextNumber INTEGER)
BEGIN

	DECLARE nextId INTEGER;

	-- Cargar nuevos numeros
	CALL blackstarDb.LoadNewSequencePoolItems(pSequenceNumberTypeId);
	
	-- Recuperar el siguiente numero en la secuencia y su ID
	SELECT min(sequenceNumber) into nextNumber
	FROM sequenceNumberPool 
	WHERE sequenceNumberTypeId = pSequenceNumberTypeId
		AND sequenceNumberStatus = 'U';

	SELECT sequenceNumberPoolId into nextId
	FROM sequenceNumberPool 
	WHERE sequenceNumber = nextNumber 
		AND sequenceNumberTypeId = pSequenceNumberTypeId;

	-- Bloquear el numero
	UPDATE sequenceNumberPool SET sequenceNumberStatus = 'L'
	WHERE sequenceNumberPoolId = nextId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUserGroups
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserGroups$$
CREATE PROCEDURE blackstarDb.GetUserGroups(pEmail VARCHAR(100))
BEGIN

	SELECT g.name AS groupName
	FROM blackstarUser_userGroup ug
		INNER JOIN blackstarUser u ON u.blackstarUserId = ug.blackstarUserId
		LEFT OUTER JOIN userGroup g ON g.userGroupId = ug.userGroupId
	WHERE u.email = pEmail;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEquipmentByCustomer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentByCustomer$$
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentList$$
CREATE PROCEDURE blackstarDb.GetEquipmentList()
BEGIN

	SELECT
		policyId as DT_RowId,
		equipmentType as equipmentType,
		serialNumber as serialNumber,
		project as project
	FROM policy p
		INNER JOIN equipmentType e on e.equipmentTypeId = p.equipmentTypeId
	WHERE 
		NOW() > p.startDate and NOW() < p.endDate
	ORDER BY serialNumber;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AssignServiceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AssignServiceOrder$$
CREATE PROCEDURE blackstarDb.AssignServiceOrder (pOsId INTEGER, pEmployee VARCHAR(100), usr VARCHAR(100), proc VARCHAR(100))
BEGIN

	UPDATE serviceOrder SET
		asignee = pEmployee,
		modified = NOW(),
		modifiedBy = proc,
		modifiedByUsr = usr
	WHERE serviceOrderId = pOsId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.ReopenTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.ReopenTicket$$
CREATE PROCEDURE blackstarDb.ReopenTicket(pTicketId INTEGER, pModifiedBy VARCHAR(100))
BEGIN
	
	-- ACTUALIZAR EL ESTATUS DEL TICKET Y NUMERO DE ORDEN DE SERVICIO
	UPDATE ticket t 
		INNER JOIN policy p ON p.policyId = t.policyId
	SET 
		t.ticketStatusId = IF(TIMESTAMPDIFF(HOUR, t.created, NOW()) > p.solutionTimeHR, 'R', 'A'),
		t.modified = NOW(),
		t.modifiedBy = 'ReopenTicket',
		t.modifiedByUsr = pModifiedBy
	WHERE t.ticketId = pTicketId;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.CloseTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CloseTicket$$
CREATE PROCEDURE blackstarDb.CloseTicket(pTicketId INTEGER, pOsId VARCHAR(100), pClosed DATETIME, pModifiedBy VARCHAR(100), pEmployee VARCHAR(200))
BEGIN
	
	-- ACTUALIZAR EL ESTATUS DEL TICKET Y NUMERO DE ORDEN DE SERVICIO
	UPDATE ticket t 
		INNER JOIN ticket t2 on t.ticketId = t2.ticketId
		INNER JOIN blackstarDb.policy p on p.policyId = t.policyId
	SET 
		t.ticketStatusId = IF(t2.ticketStatusId = 'R', 'F', 'C'),
		-- t.serviceOrderId = pOsId,
		t.serviceOrderNumber = pOsId,
		t.closed = pClosed,
		t.solutionTime = TIMESTAMPDIFF(HOUR, t.created, pClosed),
		t.solutionTimeDeviationHr = CASE WHEN(TIMESTAMPDIFF(HOUR, t.created, pClosed) < solutionTimeHR) THEN 0 ELSE (TIMESTAMPDIFF(HOUR, t.created, pClosed) - solutionTimeHR) END,
		t.employee = pEmployee,
		t.modified = NOW(),
		t.modifiedBy = 'CloseTicket',
		t.modifiedByUsr = pModifiedBy
	WHERE t.ticketId = pTicketId;


	-- Poner la OS como correctivo
	UPDATE serviceOrder SET serviceTypeId = 'C'
	WHERE serviceOrderNumber = osId
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToOS
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpToOS$$
CREATE PROCEDURE blackstarDb.AddFollowUpToOS(pOsId INTEGER, pCreated DATETIME, pCreatedBy VARCHAR(100), pAsignee VARCHAR(100), pMessage TEXT)
BEGIN

	-- INSERTAR EL REGISTRO DE SEGUIMIENTO
	INSERT INTO blackstarDb.followUp(
		followUpReferenceTypeId,
		serviceOrderId,
		asignee,
		followup,
		created,
		createdBy,
		createdByUsr
	)
	SELECT 
		'O',
		pOsId,
		pAsignee,
		pMessage,
		pCreated,
		'AddFollowUpToOS',
		pCreatedBy;

	-- ACTUALIZAR LA OS
	UPDATE serviceOrder SET
		serviceStatusId = 'E',
		asignee = pAsignee,
		modified = pCreated,
		modifiedBy = 'AddFollowUpToOS',
		modifiedByUsr = pCreatedBy
	WHERE serviceOrderId = pOsId;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpToTicket$$
CREATE PROCEDURE blackstarDb.AddFollowUpToTicket(pTicketId INTEGER, pCreated DATETIME, pCreatedBy VARCHAR(100), pAsignee VARCHAR(100), pMessage TEXT)
BEGIN

	-- INSERTAR EL REGISTRO DE SEGUIMIENTO
	INSERT INTO blackstarDb.followUp(
		followUpReferenceTypeId,
		ticketId,
		asignee,
		followup,
		created,
		createdBy,
		createdByUsr
	)
	SELECT 
		'T',
		pTicketId,
		pAsignee,
		pMessage,
		pCreated,
		'AddFollowUpToTicket',
		pCreatedBy;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertScheduledService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertScheduledService$$
CREATE PROCEDURE blackstarDb.UpsertScheduledService(pScheduledServiceId INTEGER, pDescription VARCHAR(1000), pOpenCustomerId INT, pProject VARCHAR(100), pServiceContact VARCHAR(100), pServiceContactEmail VARCHAR(100), pCreatedBy VARCHAR(100), pUser VARCHAR(100) )
BEGIN

	IF pScheduledServiceId = 0 THEN
		INSERT INTO scheduledService(
			serviceStatusId,
			description,
			openCustomerId,
			project,
			serviceContact,
			serviceContactEmail,
			created,
			createdBy,
			createdByUsr
		)
		SELECT 
			'P', pDescription, pOpenCustomerId, pProject, pServiceContact, pServiceContactEmail, NOW(), pCreatedBy, pUser;
			
		SET pScheduledServiceId = LAST_INSERT_ID();
	ELSE
		UPDATE scheduledService SET
				serviceStatusId = 'P',
				description = pDescription,
				openCustomerId = pOpenCustomerId,
				project = pProject,
				serviceContact = pServiceContact,
				serviceContactEmail = pServiceContactEmail,
				modified = NOW(),
				modifiedBy = pCreatedBy,
				modifiedByUsr = pUser
		WHERE scheduledServiceId = pScheduledServiceId;
	END IF;
	
	
	-- Se eliminan los hijos del scheduledService. Se asume que se actualizaran equipos y empleados usando:
	-- AddScheduledServicePolicy y AddScheduledServiceEmployee
	DELETE FROM scheduledServiceEmployee WHERE scheduledServiceId = pScheduledServiceId;
	
	DELETE FROM scheduledServicePolicy WHERE scheduledServiceId = pScheduledServiceId;
	
	DELETE FROM scheduledServiceDate WHERE scheduledServiceId = pScheduledServiceId;
	
	SELECT pScheduledServiceId as scheduledServiceId;
		
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFollowUpByServiceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFollowUpByServiceOrder$$
CREATE PROCEDURE blackstarDb.GetFollowUpByServiceOrder(pServiceOrderId INTEGER)
BEGIN

	SELECT 
		created AS timeStamp,
		u2.name AS createdBy,
		u.name AS asignee,
		followup AS followUp
	FROM followUp f
		LEFT OUTER JOIN blackstarUser u ON f.asignee = u.email
		LEFT OUTER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE serviceOrderId = pServiceOrderId
	ORDER BY f.created;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBigTicketTable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBigTicketTable$$
CREATE PROCEDURE blackstarDb.GetBigTicketTable()
BEGIN

	SELECT 
		'' AS num,
		t.ticketId AS DT_RowId,
		t.created AS created,
		t.user AS createdBy,
		p.contactName AS contactName,
		p.contactPhone AS contactPhone,
		p.contactEmail AS contactEmail,
		p.serialNumber AS serialNumber,
		t.observations AS observations,
		p.customer AS customer,
		et.equipmentType AS equipmentType,
		p.brand AS brand,
		p.model AS model,
		p.capacity AS capacity,
		p.responseTimeHr AS responseTimeHr,
		p.solutionTimeHr AS solutionTimeHr,
		p.equipmentAddress AS equipmentAddress,
		p.equipmentLocation AS equipmentLocation,
		IF(p.includesParts, 'SI', 'NO') AS includesParts,
		p.exceptionParts AS exceptionParts,
		sc.serviceCenter AS serviceCenter,
		o.officeName AS office,
		p.project AS project,
		t.ticketNumber AS ticketNumber,
		IF(t.phoneResolved, 'SI', 'NO') AS phoneResolved,
		IFNULL(t.arrival, '') AS arrival,
		t.responseTimeDeviationHr AS responseTimeDeviationHr,
		'FollowUp' AS followUp,
		IFNULL(t.closed, '') AS closed,
		IFNULL(so.serviceOrderNumber, '') AS serviceOrderNumber,
		IFNULL(t.employee, '') AS employee,
		t.solutionTime AS solutionTime,
		t.solutionTimeDeviationHr AS solutionTimeDeviationHr,
		ts.ticketStatus AS ticketStatus,
		t.ticketNumber AS Cerrar
	FROM ticket t
		INNER JOIN policy p ON p.policyId = t.policyId	
		INNER JOIN ticketStatus ts on ts.ticketStatusId = t.ticketStatusId
		INNER JOIN office o ON p.officeId = o.officeId
		INNER JOIN serviceCenter sc ON sc.serviceCenterId = p.serviceCenterId
		INNER JOIN equipmentType et ON et.equipmentTypeId = p.equipmentTypeId
		LEFT OUTER JOIN serviceOrder so ON so.serviceOrderId = t.serviceOrderId
	ORDER BY created DESC;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFollowUpByOS
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFollowUpByOS$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFollowUpByTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFollowUpByTicket$$
CREATE PROCEDURE blackstarDb.GetFollowUpByTicket(pTicketId INTEGER)
BEGIN

	SELECT 
		created AS timeStamp,
		u2.name AS createdBy,
		u.name AS asignee,
		followup AS followUp
	FROM followUp f
		LEFT OUTER JOIN blackstarUser u ON f.asignee = u.email
		LEFT OUTER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE ticketId = pTicketId
	ORDER BY created;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServicesByPolicyId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServicesByPolicyId$$
CREATE PROCEDURE blackstarDb.GetServicesByPolicyId(pPolicyId INTEGER)
BEGIN

	SELECT serviceOrderId AS ServiceOrderId,
		   serviceOrderNumber AS serviceOrderNumber
	FROM blackstarDb.serviceOrder
	WHERE policyId = pPolicyId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetCustomerList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetCustomerList$$
CREATE PROCEDURE blackstarDb.GetCustomerList()
BEGIN

	SELECT DISTINCT customer
	FROM blackstarDb.policy
		WHERE startDate <= NOW() AND NOW() <= endDate
	ORDER BY customer;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServicesSchedule
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServicesSchedule$$
CREATE PROCEDURE blackstarDb.GetServicesSchedule(pServiceDate DATETIME)
BEGIN

	SELECT DISTINCT
		s.scheduledServiceId AS scheduledServiceId,
		serviceDate AS scheduledDate,
		equipmentType AS equipmentType,
		ifnull(p.customer, oc.customerName) AS customer,
		s.project AS project,
		ifnull(p.serialNumber, oc.serialNumber) AS serialNumber,
		us.name AS defaultEmployee
	FROM blackstarDb.scheduledService s
		LEFT OUTER JOIN blackstarDb.scheduledServicePolicy sp ON sp.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER JOIN blackstarDb.openCustomer oc ON oc.openCustomerId = s.openCustomerId
		LEFT OUTER JOIN blackstarDb.scheduledServiceDate sd ON sd.scheduledServiceId = s.scheduledServiceId
		LEFT OUTER JOIN blackstarDb.policy p ON sp.policyId = p.policyId
		LEFT OUTER JOIN blackstarDb.serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		LEFT OUTER JOIN blackstarDb.equipmentType et ON et.equipmentTypeId = ifnull(p.equipmentTypeId, oc.equipmentTypeId)
		LEFT OUTER JOIN blackstarDb.scheduledServiceEmployee em ON em.scheduledServiceId = s.scheduledServiceId AND em.isDefault = 1
		LEFT OUTER JOIN blackstarDb.blackstarUser us ON us.email = em.employeeId
	WHERE s.serviceStatusId = 'P'
		AND serviceDate > pServiceDate AND serviceDate < DATE_ADD(pServiceDate, INTERVAL 1 DAY)
	ORDER BY equipmentType;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetDomainEmployees
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetDomainEmployees$$
CREATE PROCEDURE blackstarDb.GetDomainEmployees()
BEGIN

	SELECT DISTINCT u.email AS email, u.name AS name
	FROM blackstarUser u 	
		LEFT OUTER JOIN blackstarUser_userGroup ug ON u.blackstarUserId = ug.blackstarUserId
		LEFT OUTER JOIN userGroup g ON g.userGroupId = ug.userGroupId
	WHERE g.name != 'Cliente'
	ORDER BY name;
	
END$$


-- -----------------------------------------------------------------------------
        -- blackstarDb.GetUserData
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserData$$
CREATE PROCEDURE blackstarDb.GetUserData(pEmail VARCHAR(100))
BEGIN

        SELECT u.email AS userEmail, u.name AS userName, g.name AS groupName
        FROM blackstarUser_userGroup ug
                INNER JOIN blackstarUser u ON u.blackstarUserId = ug.blackstarUserId
                LEFT OUTER JOIN userGroup g ON g.userGroupId = ug.userGroupId
        WHERE u.email = pEmail;
        
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CreateUserGroup
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CreateUserGroup$$
CREATE PROCEDURE blackstarDb.CreateUserGroup(pGroupId VARCHAR(100), pGroupName VARCHAR(100), pUserEmail VARCHAR(100))
BEGIN

		-- Crear el grupo si no existe
		INSERT INTO blackstarDb.userGroup(externalId, name)
		SELECT a.id, a.name
		FROM (
			SELECT pGroupId AS id, pGroupName AS name
		) a
			LEFT OUTER JOIN blackstarDb.userGroup u ON a.id = u.externalId
		WHERE u.userGroupId IS NULL;
		
		-- Crear la relacion con usuario
		INSERT INTO blackstarUser_userGroup(blackstarUserId, userGroupId)
		SELECT a.blackstarUserId, a.userGroupId
		FROM (
        SELECT
			(SELECT blackstarUserId	FROM blackstarDb.blackstarUser WHERE email = pUserEmail) AS blackstarUserId,
			(SELECT userGroupId FROM blackstarDb.userGroup WHERE externalId = pGroupId) as userGroupId
		) a
			LEFT OUTER JOIN blackstarDb.blackstarUser_userGroup ug ON a.blackstarUserId = ug.blackstarUserId and a.userGroupId = ug.userGroupId
		WHERE ug.blackstarUser_userGroupId IS NULL;
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertUser
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertUser$$
CREATE PROCEDURE blackstarDb.UpsertUser(pEmail VARCHAR(100), pName VARCHAR(100))
BEGIN

	INSERT INTO blackstarDb.blackstarUser(email, name)
	SELECT a.email, a.name
	FROM (
		SELECT pEmail AS email, pName AS name
	) a
		LEFT OUTER JOIN blackstarDb.blackstarUser u ON a.email = u.email
	WHERE u.email IS NULL;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUnassignedTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUnassignedTickets$$
CREATE PROCEDURE blackstarDb.GetUnassignedTickets ()
BEGIN

	SELECT 
		tk.ticketId AS DT_RowId,
		tk.ticketNumber AS ticketNumber,
		tk.created AS created,
		p.contactName AS contactName,
		p.serialNumber AS serialNumber,
		p.customer AS customer,
		et.equipmentType AS equipmentType,
		p.responseTimeHR AS responseTimeHR,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		tk.ticketNumber AS Asignar
	FROM ticket tk 
		INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		INNER JOIN policy p ON tk.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
		INNER JOIN office of on p.officeId = of.officeId
	WHERE IFNULL(employee, '') = ''
		AND closed IS NULL;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAllTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllTickets$$
CREATE PROCEDURE blackstarDb.GetAllTickets ()
BEGIN

	SELECT 
		tk.ticketId AS DT_RowId,
		tk.ticketNumber AS ticketNumber,
		tk.created AS created,
		p.contactName AS contactName,
		p.serialNumber AS serialNumber,
		p.customer AS customer,
		et.equipmentType AS equipmentType,
		p.responseTimeHR AS responseTimeHR,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		IFNULL(bu.name, tk.employee) AS asignee,
		tk.ticketNumber AS asignar,
		IFNULL(tk.serviceOrderNumber, '') AS serviceOrderNumber
	FROM ticket tk 
		INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		INNER JOIN policy p ON tk.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
		INNER JOIN office of on p.officeId = of.officeId
		LEFT OUTER JOIN blackstarUser bu ON bu.email = tk.employee
	WHERE tk.created > '01-01' + YEAR(NOW())
    ORDER BY tk.created DESC;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrders
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrders$$
CREATE PROCEDURE blackstarDb.GetServiceOrders(IN status VARCHAR(200))
BEGIN

	SELECT 
		so.ServiceOrderId AS DT_RowId,
		so.serviceOrderNumber AS serviceOrderNumber,
		'' AS placeHolder,
		IFNULL(t.ticketNumber, '') AS ticketNumber,
		st.serviceType AS serviceType,
		DATE(so.created) AS created,
		p.customer AS customer,
		et.equipmentType AS equipmentType,
		p.project AS project,
		of.officeName AS officeName,
		p.brand AS brand,
		p.serialNumber AS serialNumber,
		ss.serviceStatus AS serviceStatus,
		SO.hasPdf AS hasPdf
	FROM serviceOrder so 
		INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
		INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
		INNER JOIN policy p ON so.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
		INNER JOIN office of on p.officeId = of.officeId
     LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
	WHERE ss.serviceStatus IN(status) 
	ORDER BY serviceDate DESC ;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetTicketsByStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetTicketsByStatus$$
CREATE PROCEDURE blackstarDb.GetTicketsByStatus (IN status VARCHAR(20))
BEGIN

	SELECT 
		tk.ticketId AS DT_RowId,
		tk.ticketNumber AS ticketNumber,
		tk.created AS created,
		p.contactName AS contactName,
		p.serialNumber AS serialNumber,
		p.customer AS customer,
		et.equipmentType AS equipmentType,
		tk.solutionTimeDeviationHr AS solutionTimeDeviationHr,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		'Crear OS' AS OS 
	FROM ticket tk 
		INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		INNER JOIN policy p ON tk.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmentTypeId = et.equipmentTypeId
		INNER JOIN office of on p.officeId = of.officeId
	WHERE ts.ticketStatus = status;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEquipmentCollectionByCustomer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEquipmentCollectionByCustomer$$
CREATE PROCEDURE blackstarDb.GetEquipmentCollectionByCustomer (IN pCustomer VARCHAR(100))
BEGIN

	SELECT serialNumber, brand, model 
	FROM blackstarDb.policy
	WHERE customer = pCustomer
		AND endDate > NOW()
	ORDER BY serialNumber;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.UpdateTicketStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpdateTicketStatus$$
CREATE PROCEDURE blackstarDb.UpdateTicketStatus ()
BEGIN

	-- ACTUALIZACION ESTATUS DEL TICKET
	-- ABIERTOS
	UPDATE blackstarDb.ticket t
		INNER JOIN policy p on t.policyId = p.policyId
	SET
		ticketStatusId = 'A'
	WHERE closed IS NULL
		AND TIMESTAMPDIFF(HOUR, t.created, NOW()) <= p.solutionTimeHR;
			
	-- RETRASADOS
	UPDATE blackstarDb.ticket t
		INNER JOIN policy p on t.policyId = p.policyId
	SET
		ticketStatusId = 'R'
	WHERE closed IS NULL
		AND TIMESTAMPDIFF(HOUR, t.created, NOW()) > p.solutionTimeHR;

	-- CERRADOS
	UPDATE blackstarDb.ticket SET
		ticketStatusId = 'C'
	WHERE closed IS NOT NULL
			AND solutionTimeDeviationHr <= 0;
			
	-- CERRADOS FUERA DE TIEMPO
	UPDATE blackstarDb.ticket SET
		ticketStatusId = 'F'
	WHERE closed IS NOT NULL
		AND solutionTimeDeviationHr > 0;
		
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AssignTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AssignTicket$$
CREATE PROCEDURE blackstarDb.AssignTicket (pTicketId INTEGER, pEmployee VARCHAR(100), usr VARCHAR(100), proc VARCHAR(100))
BEGIN

	-- Asignacion del dueño del ticket
	UPDATE ticket SET
		employee = pEmployee
	WHERE ticketId = pTicketId
		AND IFNULL(employee, '') = '';
		
	-- Asignacion del empleado responsable
	UPDATE ticket SET
		employee = pEmployee,
		asignee = pEmployee,
		modified = NOW(),
		modifiedBy = proc,
		modifiedByUsr = usr
	WHERE ticketId = pTicketId;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetAirCoServiceByIdService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAirCoServiceByIdService$$
CREATE PROCEDURE blackstarDb.GetAirCoServiceByIdService (idService INTEGER)
BEGIN	
	select 
		aaServiceId, serviceOrderId, evaDescription, evaValTemp, evaValHum, evaSetpointTemp, evaSetpointHum, 
		evaFlagCalibration, evaReviewFilter, evaReviewStrip, evaCleanElectricSystem, evaCleanControlCard, evaCleanTray, 
		evaLectrurePreasureHigh, evaLectrurePreasureLow, evaLectureTemp, evaLectureOilColor, evaLectureOilLevel, evaLectureCoolerColor, 
		evaLectureCoolerLevel, evaCheckOperatation, evaCheckNoise, evaCheckIsolated, evaLectureVoltageGroud, evaLectureVoltagePhases, 
		evaLectureVoltageControl, evaLectureCurrentMotor1, evaLectureCurrentMotor2, evaLectureCurrentMotor3, evaLectureCurrentCompressor1, 
		evaLectureCurrentCompressor2, evaLectureCurrentCompressor3, evaLectureCurrentHumidifier1, evaLectureCurrentHumidifier2, 
		evaLectureCurrentHumidifier3, evaLectureCurrentHeater1, evaLectureCurrentHeater2, evaLectureCurrentHeater3, evaCheckFluidSensor,
		evaRequirMaintenance, condReview, condCleanElectricSystem, condClean, condLectureVoltageGroud, condLectureVoltagePhases,
		condLectureVoltageControl, condLectureMotorCurrent, condReviewThermostat, condModel, condSerialNumber, condBrand, observations
	from aaService 
	where 
		serviceOrderId = idService;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetBatteryServiceByIdService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetBatteryServiceByIdService$$
CREATE PROCEDURE blackstarDb.GetBatteryServiceByIdService (idService INTEGER)
BEGIN
	select 
		bbServiceId, serviceOrderId, plugClean, plugCleanStatus, plugCleanComments, coverClean, coverCleanStatus, 
		coverCleanComments, capClean, capCleanStatus, capCleanComments, groundClean, groundCleanStatus, groundCleanComments, 
		rackClean, rackCleanStatus, rackCleanComments, serialNoDateManufact, batteryTemperature, voltageBus, temperature
	from bbService 
	where 
		serviceOrderId = idService;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetCellBatteryServiceByIdBatteryService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetCellBatteryServiceByIdBatteryService$$
CREATE PROCEDURE blackstarDb.GetCellBatteryServiceByIdBatteryService (idBatteryService INTEGER)
BEGIN
	select 
		bbCellServiceId, bbServiceId, cellNumber, floatVoltage, chargeVoltage
	from bbCellService 
	where 
		bbServiceId = idBatteryService;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEmergencyPlantServiceByIdService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetEmergencyPlantServiceByIdService$$
CREATE PROCEDURE blackstarDb.GetEmergencyPlantServiceByIdService (idService INTEGER)
BEGIN
	select 
		A.epServiceId, serviceOrderId, brandPE,modelPE,serialPE, transferType, modelTransfer, modelControl, modelRegVoltage, modelRegVelocity, 
		modelCharger, oilChange, brandMotor, modelMotor, serialMotor, cplMotor, brandGenerator, modelGenerator, serialGenerator, 
		powerWattGenerator, tensionGenerator, tuningDate, tankCapacity, pumpFuelModel, filterFuelFlag, filterOilFlag, filterWaterFlag, 
		filterAirFlag, brandGear, brandBattery, clockLecture, serviceCorrective, observations, 

		epServiceSurveyId, levelOilFlag, levelWaterFlag, levelBattery, tubeLeak, batteryCap, batterySulfate, levelOil, 
		heatEngine, hoseOil, hoseWater, tubeValve, stripBlades, 

		epServiceWorkBasicId, washEngine, washRadiator, cleanWorkArea, conectionCheck, cleanTransfer, cleanCardControl, 
		checkConectionControl, checkWinding, batteryTests, checkCharger, checkPaint, cleanGenerator, 

		epServiceDynamicTestId, vacuumFrequency, chargeFrequency, bootTryouts, vacuumVoltage, chargeVoltage, qualitySmoke, 
		startTime, transferTime, stopTime, 

		epServiceTestProtectionId, tempSensor, oilSensor, voltageSensor, overSpeedSensor, oilPreasureSensor, waterLevelSensor, 
		
		epServiceTransferSwitchId, mechanicalStatus, boardClean, lampTest, screwAdjust, conectionAdjust, systemMotors, electricInterlock, 
		mechanicalInterlock, capacityAmp, 

		epServiceLecturesId, voltageABAN, voltageACCN, voltageBCBN, voltageNT, currentA, currentB, currentC, frequency, oilPreassure, temp, 

		epServiceParamsId, adjsutmentTherm, current, batteryCurrent, clockStatus, trasnferTypeProtection, generatorTypeProtection

	from epService A
	inner join  epServiceSurvey  B on  A.epServiceId  = B.epServiceId 
	inner join  epServiceWorkBasic  C on  A.epServiceId  = C.epServiceId 
	inner join  epServiceDynamicTest  D on  A.epServiceId  = D.epServiceId 
	inner join  epServiceTestProtection E on  A.epServiceId  = E.epServiceId 
	inner join  epServiceTransferSwitch F on  A.epServiceId  = F.epServiceId 
	inner join  epServiceLectures G on  A.epServiceId  = G.epServiceId 
	inner join  epServiceParams H on  A.epServiceId  = H.epServiceId 
	where 
		A.serviceOrderId  = idService;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetPlainServiceServiceByIdService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPlainServiceServiceByIdService$$
CREATE PROCEDURE blackstarDb.GetPlainServiceServiceByIdService (idService INTEGER)
BEGIN	
	select 
		plainServiceId, serviceOrderId, troubleDescription, techParam, workDone, materialUsed, observations
	from plainService ps
	where 
		serviceOrderId = idService;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUPSServiceByIdService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUPSServiceByIdService$$
CREATE PROCEDURE blackstarDb.GetUPSServiceByIdService (idService INTEGER)
BEGIN

	select 
		A.upsServiceId, serviceOrderId, estatusEquipment, cleaned, hooverClean, verifyConnections, capacitorStatus, verifyFuzz, 
		chargerReview, fanStatus,
		
		upsServiceBatteryBankId, checkConnectors, cverifyOutflow, numberBatteries, manufacturedDateSerial, damageBatteries, 
		other, temp, chargeTest, brandModel, batteryVoltage, 
		
		upsServiceGeneralTestId, trasferLine, transferEmergencyPlant, backupBatteries, verifyVoltage, 
		
		upsServiceParamsId, inputVoltagePhase, inputVoltageNeutro, inputVoltageNeutroGround, percentCharge, outputVoltagePhase, 
		outputVoltageNeutro, inOutFrecuency, busVoltage
	from upsService A
	inner join  upsServiceBatteryBank  B on  A.upsServiceId = B.upsServiceId
	inner join  upsServiceGeneralTest  C on  A.upsServiceId = C.upsServiceId
	inner join  upsServiceParams  D on  A.upsServiceId = D.upsServiceId
	where 
		A.serviceOrderId = idService;

END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.GetPolicyBySerialNo
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPolicyBySerialNo$$
CREATE PROCEDURE blackstarDb.GetPolicyBySerialNo (noSerial VARCHAR(100))
BEGIN
	SELECT * FROM blackstarDb.policy
	WHERE startDate < CURDATE() AND endDate > CURDATE() AND serialNumber = noSerial;
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddAAservice
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddAAservice$$
CREATE PROCEDURE blackstarDb.AddAAservice (  
  serviceOrderId int(11) ,
  evaDescription varchar(250) ,
  evaValTemp decimal(10,0) ,
  evaValHum decimal(10,0) ,
  evaSetpointTemp decimal(10,0) ,
  evaSetpointHum decimal(10,0) ,
  evaFlagCalibration bit(1) ,
  evaReviewFilter bit(1) ,
  evaReviewStrip bit(1) ,
  evaCleanElectricSystem bit(1) ,
  evaCleanControlCard bit(1) ,
  evaCleanTray bit(1) ,
  evaLectrurePreasureHigh decimal(10,0) ,
  evaLectrurePreasureLow decimal(10,0) ,
  evaLectureTemp decimal(10,0) ,
  evaLectureOilColor varchar(10) ,
  evaLectureOilLevel decimal(10,0) ,
  evaLectureCoolerColor varchar(10) ,
  evaLectureCoolerLevel decimal(10,0) ,
  evaCheckOperatation varchar(10) ,
  evaCheckNoise varchar(10) ,
  evaCheckIsolated varchar(10) ,
  evaLectureVoltageGroud decimal(10,0) ,
  evaLectureVoltagePhases decimal(10,0) ,
  evaLectureVoltageControl decimal(10,0) ,
  evaLectureCurrentMotor1 decimal(10,0) ,
  evaLectureCurrentMotor2 decimal(10,0) ,
  evaLectureCurrentMotor3 decimal(10,0) ,
  evaLectureCurrentCompressor1 decimal(10,0) ,
  evaLectureCurrentCompressor2 decimal(10,0) ,
  evaLectureCurrentCompressor3 decimal(10,0) ,
  evaLectureCurrentHumidifier1 decimal(10,0) ,
  evaLectureCurrentHumidifier2 decimal(10,0) ,
  evaLectureCurrentHumidifier3 decimal(10,0) ,
  evaLectureCurrentHeater1 decimal(10,0) ,
  evaLectureCurrentHeater2 decimal(10,0) ,
  evaLectureCurrentHeater3 decimal(10,0) ,
  evaCheckFluidSensor bit(1) ,
  evaRequirMaintenance bit(1) ,
  condReview varchar(50) ,
  condCleanElectricSystem bit(1) ,
  condClean bit(1) ,
  condLectureVoltageGroud decimal(10,0) ,
  condLectureVoltagePhases decimal(10,0) ,
  condLectureVoltageControl decimal(10,0) ,
  condLectureMotorCurrent decimal(10,0) ,
  condReviewThermostat varchar(50) ,
  condModel varchar(50) ,
  condSerialNumber varchar(50) ,
  condBrand varchar(50) ,
  observations varchar(255) ,
  created datetime ,
  createdBy varchar(50) ,
  createdByUsr varchar(50))
BEGIN
	INSERT INTO aaService
(serviceOrderId,evaDescription,evaValTemp,evaValHum,evaSetpointTemp,
evaSetpointHum,evaFlagCalibration,evaReviewFilter,evaReviewStrip,evaCleanElectricSystem,
evaCleanControlCard,evaCleanTray,evaLectrurePreasureHigh,evaLectrurePreasureLow,evaLectureTemp,
evaLectureOilColor,evaLectureOilLevel,evaLectureCoolerColor,evaLectureCoolerLevel,
evaCheckOperatation,evaCheckNoise,evaCheckIsolated,evaLectureVoltageGroud,evaLectureVoltagePhases,
evaLectureVoltageControl,evaLectureCurrentMotor1,evaLectureCurrentMotor2,evaLectureCurrentMotor3,
evaLectureCurrentCompressor1,evaLectureCurrentCompressor2,evaLectureCurrentCompressor3,
evaLectureCurrentHumidifier1,evaLectureCurrentHumidifier2,evaLectureCurrentHumidifier3,
evaLectureCurrentHeater1,evaLectureCurrentHeater2,evaLectureCurrentHeater3,evaCheckFluidSensor,
evaRequirMaintenance,condReview,condCleanElectricSystem,condClean,condLectureVoltageGroud,
condLectureVoltagePhases,condLectureVoltageControl,condLectureMotorCurrent,condReviewThermostat,
condModel,condSerialNumber,condBrand,observations,created,createdBy,createdByUsr)
VALUES
(
serviceOrderId,evaDescription,evaValTemp,evaValHum,evaSetpointTemp,
evaSetpointHum,evaFlagCalibration,evaReviewFilter,evaReviewStrip,
evaCleanElectricSystem,evaCleanControlCard,evaCleanTray,evaLectrurePreasureHigh,
evaLectrurePreasureLow,evaLectureTemp,evaLectureOilColor,evaLectureOilLevel,
evaLectureCoolerColor,evaLectureCoolerLevel,evaCheckOperatation,evaCheckNoise,
evaCheckIsolated,evaLectureVoltageGroud,evaLectureVoltagePhases,evaLectureVoltageControl,
evaLectureCurrentMotor1,evaLectureCurrentMotor2,evaLectureCurrentMotor3,evaLectureCurrentCompressor1,
evaLectureCurrentCompressor2,evaLectureCurrentCompressor3,evaLectureCurrentHumidifier1,
evaLectureCurrentHumidifier2,evaLectureCurrentHumidifier3,evaLectureCurrentHeater1,
evaLectureCurrentHeater2,evaLectureCurrentHeater3,evaCheckFluidSensor,
evaRequirMaintenance,condReview,condCleanElectricSystem,condClean,
condLectureVoltageGroud,condLectureVoltagePhases,condLectureVoltageControl,
condLectureMotorCurrent,condReviewThermostat,condModel,condSerialNumber,
condBrand,observations,created,createdBy,createdByUsr
);
select LAST_INSERT_ID();
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddBBcellservice
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddBBcellservice$$
CREATE PROCEDURE blackstarDb.AddBBcellservice (bbServiceId int(11) , cellNumber int(11) , floatVoltage int(11) , chargeVoltage int(11))
BEGIN
INSERT INTO bbCellService
(bbServiceId,cellNumber,floatVoltage,chargeVoltage)
VALUES
(bbServiceId,cellNumber,floatVoltage,chargeVoltage);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddBBservice
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddBBservice$$
CREATE PROCEDURE blackstarDb.AddBBservice (
   serviceOrderId  int(11)  ,
   plugClean  bit(1)  ,
   plugCleanStatus  varchar(50) , 
   plugCleanComments  varchar(50) , 
   coverClean  bit(1)  ,
   coverCleanStatus  varchar(50)  ,
   coverCleanComments  varchar(50) , 
   capClean  bit(1)  ,
   capCleanStatus  varchar(50)  ,
   capCleanComments  varchar(50) , 
   groundClean  bit(1)  ,
   groundCleanStatus  varchar(50) , 
   groundCleanComments  varchar(50) , 
   rackClean  bit(1)  ,
   rackCleanStatus  varchar(50) , 
   rackCleanComments  varchar(50) , 
   serialNoDateManufact  varchar(50)  ,
   batteryTemperature  varchar(50)  ,
   voltageBus  int(11)  ,
   temperature  int(11)  ,
   created  datetime , 
   createdBy  varchar(50)  ,
   createdByUsr  varchar(50)
)
BEGIN
INSERT INTO bbService
(serviceOrderId,plugClean,plugCleanStatus,plugCleanComments,coverClean,coverCleanStatus,coverCleanComments,
capClean,capCleanStatus,capCleanComments,groundClean,groundCleanStatus,groundCleanComments,rackClean,
rackCleanStatus,rackCleanComments,serialNoDateManufact,batteryTemperature,voltageBus,temperature,
created,createdBy,createdByUsr)
VALUES
(serviceOrderId ,plugClean ,plugCleanStatus ,plugCleanComments ,coverClean ,coverCleanStatus ,
coverCleanComments ,capClean ,capCleanStatus ,capCleanComments ,groundClean ,groundCleanStatus ,
groundCleanComments ,rackClean ,rackCleanStatus ,rackCleanComments ,serialNoDateManufact ,batteryTemperature ,
voltageBus ,temperature ,created ,createdBy ,createdByUsr );
select LAST_INSERT_ID();
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepService$$
CREATE PROCEDURE blackstarDb.AddepService (
   serviceOrderId  int(11)  ,
   brandPE varchar(50) ,
   modelPE varchar(50) ,
   serialPE varchar(50) ,
   transferType  varchar(50)  ,
   modelTransfer  varchar(50)  ,
   modelControl  varchar(50)  ,
   modelRegVoltage  varchar(50)  ,
   modelRegVelocity  varchar(50)  ,
   modelCharger  varchar(50)  ,
   oilChange  date  ,
   brandMotor  varchar(50)  ,
   modelMotor  varchar(50)  ,
   serialMotor  varchar(50)  ,
   cplMotor  varchar(50)  ,
   brandGenerator  varchar(50)  ,
   modelGenerator  varchar(50)  ,
   serialGenerator  varchar(50)  ,
   powerWattGenerator  int(11)  ,
   tensionGenerator  int(11)  ,
   tuningDate  date  ,
   tankCapacity  int(11)  ,
   pumpFuelModel  varchar(50)  ,
   filterFuelFlag  bit(1)  ,
   filterOilFlag  bit(1)  ,
   filterWaterFlag  bit(1)  ,
   filterAirFlag  bit(1)  ,
   brandGear  varchar(50)  ,
   brandBattery  varchar(50)  ,
   clockLecture  varchar(50)  ,
   serviceCorrective  date  ,
   observations  varchar(50)  ,
   created  datetime  ,
   createdBy  varchar(50)  ,
   createdByUsr  varchar(50)
)
BEGIN

insert into epService
(serviceOrderId,brandPE,modelPE,serialPE,transferType,modelTransfer,modelControl,modelRegVoltage,modelRegVelocity,modelCharger,oilChange,brandMotor,modelMotor,serialMotor,cplMotor,brandGenerator,modelGenerator,serialGenerator,powerWattGenerator,tensionGenerator,tuningDate,tankCapacity,pumpFuelModel,filterFuelFlag,filterOilFlag,filterWaterFlag,filterAirFlag,brandGear,brandBattery,clockLecture,serviceCorrective,observations,created,createdBy,createdByUsr)
VALUES
(serviceOrderId,brandPE,modelPE,serialPE,transferType,modelTransfer,modelControl,modelRegVoltage,modelRegVelocity,modelCharger,oilChange,brandMotor,modelMotor,serialMotor,cplMotor,brandGenerator,modelGenerator,serialGenerator,powerWattGenerator,tensionGenerator,tuningDate,tankCapacity,pumpFuelModel,filterFuelFlag,filterOilFlag,filterWaterFlag,filterAirFlag,brandGear,brandBattery,clockLecture,serviceCorrective,observations,created,createdBy,createdByUsr);
select LAST_INSERT_ID();
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceSurvey
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceSurvey$$
CREATE PROCEDURE blackstarDb.AddepServiceSurvey (
	epServiceId  int(11)  ,
   levelOilFlag  bit(1)  ,
   levelWaterFlag  bit(1)  ,
   levelBattery  int(11)  ,
   tubeLeak  bit(1)  ,
   batteryCap  varchar(50)  ,
   batterySulfate  varchar(50)  ,
   levelOil  int(11)  ,
   heatEngine  varchar(50)  ,
   hoseOil  varchar(50)  ,
   hoseWater  varchar(50)  ,
   tubeValve  varchar(50)  ,
   stripBlades  varchar(50) 
)
BEGIN
insert into epServiceSurvey
(epServiceId,levelOilFlag,levelWaterFlag,levelBattery,tubeLeak,batteryCap,batterySulfate,levelOil,heatEngine,hoseOil,hoseWater,tubeValve,stripBlades)
values
(epServiceId,levelOilFlag,levelWaterFlag,levelBattery,tubeLeak,batteryCap,batterySulfate,levelOil,heatEngine,hoseOil,hoseWater,tubeValve,stripBlades);

END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceWorkBasic
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceWorkBasic$$
CREATE PROCEDURE blackstarDb.AddepServiceWorkBasic (
   epServiceId  int(11)  ,
   washEngine  bit(1)  ,
   washRadiator  bit(1)  ,
   cleanWorkArea  bit(1)  ,
   conectionCheck  bit(1)  ,
   cleanTransfer  bit(1)  ,
   cleanCardControl  bit(1)  ,
   checkConectionControl  bit(1)  ,
   checkWinding  bit(1)  ,
   batteryTests  bit(1)  ,
   checkCharger  bit(1)  ,
   checkPaint  bit(1)  ,
   cleanGenerator  bit(1) 
)
BEGIN
insert into epServiceWorkBasic
(epServiceId,washEngine,washRadiator,cleanWorkArea,conectionCheck,cleanTransfer,cleanCardControl,checkConectionControl,checkWinding,batteryTests,checkCharger,checkPaint,cleanGenerator)
values
(epServiceId,washEngine,washRadiator,cleanWorkArea,conectionCheck,cleanTransfer,cleanCardControl,checkConectionControl,checkWinding,batteryTests,checkCharger,checkPaint,cleanGenerator);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceDynamicTest
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceDynamicTest$$
CREATE PROCEDURE blackstarDb.AddepServiceDynamicTest (
   epServiceId  int(11)  ,
   vacuumFrequency  decimal(10,0)  ,
   chargeFrequency  decimal(10,0)  ,
   bootTryouts  int(11)  ,
   vacuumVoltage  decimal(10,0)  ,
   chargeVoltage  decimal(10,0)  ,
   qualitySmoke  decimal(10,0)  ,
   startTime  int(11)  ,
   transferTime  int(11)  ,
   stopTime  int(11) 
)
BEGIN
insert into epServiceDynamicTest
(epServiceId,vacuumFrequency,chargeFrequency,bootTryouts,vacuumVoltage,chargeVoltage,qualitySmoke,startTime,transferTime,stopTime)
values
(epServiceId,vacuumFrequency,chargeFrequency,bootTryouts,vacuumVoltage,chargeVoltage,qualitySmoke,startTime,transferTime,stopTime);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceTestProtection
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceTestProtection$$
CREATE PROCEDURE blackstarDb.AddepServiceTestProtection (
   epServiceId  int(11)  ,
   tempSensor  int(11)  ,
   oilSensor  int(11)  ,
   voltageSensor  int(11)  ,
   overSpeedSensor  int(11)  ,
   oilPreasureSensor  int(11) ,
    waterLevelSensor  int(11) 
)
BEGIN
insert into epServiceTestProtection
(epServiceId,tempSensor,oilSensor,voltageSensor,overSpeedSensor,oilPreasureSensor,waterLevelSensor)
values
(epServiceId,tempSensor,oilSensor,voltageSensor,overSpeedSensor,oilPreasureSensor,waterLevelSensor);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceTransferSwitch
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceTransferSwitch$$
CREATE PROCEDURE blackstarDb.AddepServiceTransferSwitch (
   epServiceId  int(11)  ,
   mechanicalStatus  varchar(10)  ,
   boardClean  bit(1)  ,
	lampTest  bit(1)  ,
   screwAdjust  bit(1)  ,
   conectionAdjust  bit(1)  ,
   systemMotors  varchar(10)  ,
   electricInterlock  varchar(10)  ,
   mechanicalInterlock  varchar(10)  ,
   capacityAmp  int(11)  
)
BEGIN
insert into epServiceTransferSwitch
(epServiceId,mechanicalStatus,boardClean,screwAdjust,lampTest,conectionAdjust,systemMotors,electricInterlock,mechanicalInterlock,capacityAmp)
values
(epServiceId,mechanicalStatus,boardClean,screwAdjust,lampTest,conectionAdjust,systemMotors,electricInterlock,mechanicalInterlock,capacityAmp);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceLectures
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceLectures$$
CREATE PROCEDURE blackstarDb.AddepServiceLectures (
   epServiceId  int(11)  ,
   voltageABAN  int(11)  ,
   voltageACCN  int(11)  ,
   voltageBCBN  int(11)  ,
   voltageNT  int(11)  ,
   currentA  int(11)  ,
   currentB  int(11)  ,
   currentC  int(11)  ,
   frequency  int(11)  ,
   oilPreassure  int(11)  ,
   temp  int(11)  
)
BEGIN
insert into epServiceLectures
(epServiceId,voltageABAN,voltageACCN,voltageBCBN,voltageNT,currentA,currentB,currentC,frequency,oilPreassure,temp)
values
(epServiceId,voltageABAN,voltageACCN,voltageBCBN,voltageNT,currentA,currentB,currentC,frequency,oilPreassure,temp);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddepServiceParams
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddepServiceParams$$
CREATE PROCEDURE blackstarDb.AddepServiceParams (
   epServiceId  int(11)  ,
   adjsutmentTherm  varchar(10)  ,
   current  varchar(10)  ,
   batteryCurrent  varchar(10)  ,
   clockStatus  varchar(10)  ,
   trasnferTypeProtection  varchar(10)  ,
   generatorTypeProtection  varchar(10)  
)
BEGIN
insert into epServiceParams
(epServiceId,adjsutmentTherm,current,batteryCurrent,clockStatus,trasnferTypeProtection,generatorTypeProtection)
values
(epServiceId,adjsutmentTherm,current,batteryCurrent,clockStatus,trasnferTypeProtection,generatorTypeProtection);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddplainService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddplainService$$
CREATE PROCEDURE blackstarDb.AddplainService (
   serviceOrderId  int(11)  ,
   troubleDescription  TEXT,
   techParam  TEXT,
   workDone  TEXT,
   materialUsed  TEXT,
   observations  TEXT,
   created  datetime  ,
   createdBy  varchar(50)  ,
   createdByUsr  varchar(50) 
)
BEGIN
insert into plainService
(serviceOrderId,troubleDescription,techParam,workDone,materialUsed,observations,created,createdBy,createdByUsr)
values
(serviceOrderId,troubleDescription,techParam,workDone,materialUsed,observations,created,createdBy,createdByUsr);
select LAST_INSERT_ID();
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddupsService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddupsService$$
CREATE PROCEDURE blackstarDb.AddupsService (
  serviceOrderId int(11) ,
  estatusEquipment varchar(50) ,
  cleaned bit(1) ,
  hooverClean bit(1) ,
  verifyConnections bit(1) ,
  capacitorStatus varchar(50) ,
  verifyFuzz bit(1) ,
  chargerReview bit(1) ,
  fanStatus varchar(50) ,
	observations nvarchar(250),
  created datetime ,
  createdBy varchar(50) ,
  createdByUsr varchar(50) 
)
BEGIN
insert into upsService
(serviceOrderId,estatusEquipment,cleaned,hooverClean,verifyConnections,capacitorStatus,verifyFuzz,chargerReview,fanStatus,observations,created,createdBy,createdByUsr)
values
(serviceOrderId,estatusEquipment,cleaned,hooverClean,verifyConnections,capacitorStatus,verifyFuzz,chargerReview,fanStatus,observations,created,createdBy,createdByUsr);
select LAST_INSERT_ID();
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddupsServiceBatteryBank
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddupsServiceBatteryBank$$
CREATE PROCEDURE blackstarDb.AddupsServiceBatteryBank (
   upsServiceId int(11) ,
  checkConnectors bit(1) ,
  cverifyOutflow bit(1) ,
  numberBatteries int(11) ,
  manufacturedDateSerial varchar(10) ,
  damageBatteries varchar(50) ,
  other varchar(250) ,
  temp decimal(10,0) ,
  chargeTest bit(1) ,
  brandModel varchar(250) ,
  batteryVoltage decimal(10,0) 
)
BEGIN
insert into upsServiceBatteryBank
(upsServiceId,checkConnectors,cverifyOutflow,numberBatteries,manufacturedDateSerial,damageBatteries,other,temp,chargeTest,brandModel,batteryVoltage)
values
(upsServiceId,checkConnectors,cverifyOutflow,numberBatteries,manufacturedDateSerial,damageBatteries,other,temp,chargeTest,brandModel,batteryVoltage);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddupsServiceGeneralTest
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddupsServiceGeneralTest$$
CREATE PROCEDURE blackstarDb.AddupsServiceGeneralTest (
  upsServiceId int(11) ,
  trasferLine decimal(10,0) ,
  transferEmergencyPlant decimal(10,0) ,
  backupBatteries decimal(10,0) ,
  verifyVoltage decimal(10,0) 
)
BEGIN
insert into upsServiceGeneralTest
(upsServiceId,trasferLine,transferEmergencyPlant,backupBatteries,verifyVoltage)
values
(upsServiceId,trasferLine,transferEmergencyPlant,backupBatteries,verifyVoltage);
END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.AddupsServiceParams
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddupsServiceParams$$
CREATE PROCEDURE blackstarDb.AddupsServiceParams (
  upsServiceId int(11) ,
  inputVoltagePhase decimal(10,0) ,
  inputVoltageNeutro decimal(10,0) ,
  inputVoltageNeutroGround decimal(10,0) ,
  percentCharge decimal(10,0) ,
  outputVoltagePhase decimal(10,0) ,
  outputVoltageNeutro decimal(10,0) ,
  inOutFrecuency decimal(10,0) ,
  busVoltage decimal(10,0) 
)
BEGIN
insert into upsServiceParams
(upsServiceId,inputVoltagePhase,inputVoltageNeutro,inputVoltageNeutroGround,percentCharge,outputVoltagePhase,outputVoltageNeutro,inOutFrecuency,busVoltage)
values
(upsServiceId,inputVoltagePhase,inputVoltageNeutro,inputVoltageNeutroGround,percentCharge,outputVoltagePhase,outputVoltageNeutro,inOutFrecuency,busVoltage);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddserviceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddserviceOrder$$
CREATE PROCEDURE blackstarDb.AddserviceOrder (
  serviceOrderNumber varchar(50) ,
  serviceTypeId char(1) ,
  ticketId int(11) ,
  policyId int(11) ,
  serviceUnit varchar(10) ,
  serviceDate datetime ,
  responsible varchar(100) ,
  additionalEmployees varchar(400) ,
  receivedBy varchar(100) ,
  serviceComments text,
  serviceStatusId char(1) ,
  closed datetime ,
  consultant varchar(100) ,
  coordinator varchar(100) ,
  asignee varchar(50) ,
  hasErrors tinyint(4) ,
  isWrong tinyint(4) ,
  signCreated text,
  signReceivedBy text,
  receivedByPosition varchar(50) ,
  created datetime ,
  createdBy varchar(50) ,
  createdByUsr varchar(50) ,
  receivedByEmail varchar(100),
  openCustomerId int(11),
  serviceEndDate datetime,
  hasPdf int
)
BEGIN
insert into serviceOrder
(serviceOrderNumber,serviceTypeId,ticketId,policyId,serviceUnit,serviceDate,responsible,additionalEmployees,receivedBy,serviceComments,serviceStatusId,closed,consultant,coordinator,asignee,hasErrors,isWrong,signCreated,signReceivedBy,receivedByPosition,created,createdBy,createdByUsr,receivedByEmail,openCustomerId,serviceEndDate,hasPdf)
values
(serviceOrderNumber,serviceTypeId,ticketId,policyId,serviceUnit,serviceDate,responsible,additionalEmployees,receivedBy,serviceComments,serviceStatusId,closed,consultant,coordinator,asignee,hasErrors,isWrong,signCreated,signReceivedBy,receivedByPosition,created,createdBy,createdByUsr,receivedByEmail,openCustomerId,serviceEndDate,hasPdf);
select LAST_INSERT_ID();

END$$
-- -----------------------------------------------------------------------------
	-- blackstarDb.UpdateServiceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpdateServiceOrder$$
CREATE PROCEDURE blackstarDb.UpdateServiceOrder (
  serviceOrderId int(11),
  serviceStatusId char(1) ,
  closed datetime ,
  asignee varchar(50) ,
  isWrong tinyint(4) ,
  modified datetime ,
  modifiedBy varchar(50) ,
  modifiedByUsr varchar(50),
  hasPdf int
)
BEGIN
	UPDATE serviceOrder s SET
	s.serviceStatusId = serviceStatusId ,
	s.closed = closed ,
	s.asignee = asignee ,
	s.isWrong = isWrong,
	s.modified = modified ,
	s.modifiedBy = modifiedBy ,
	s.modifiedByUsr = modifiedByUsr,
	s.hasPdf = hasPdf
	WHERE s.serviceOrderId = serviceOrderId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrderByUser
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrderByUser$$
CREATE PROCEDURE blackstarDb.GetServiceOrderByUser ()
BEGIN

	SELECT 
		serviceOrderId,
		serviceOrderNumber 
	FROM serviceOrder 
	WHERE created >= CURDATE() 
	ORDER BY createdByUsr;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddSurveyService
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddSurveyService$$
CREATE PROCEDURE blackstarDb.AddSurveyService(
	company varchar(255),
	namePerson varchar(255),
	email varchar(255),
	phone varchar(45),
	surveyDate datetime,
	questiontreatment varchar(255),
	reasontreatment varchar(255),
	questionIdentificationPersonal varchar(255),
	questionIdealEquipment varchar(255),
	reasonIdealEquipment varchar(255),
	questionTime varchar(255),
	reasonTime varchar(255),
	questionUniform varchar(255),
	reasonUniform varchar(255),
	score int,
	sign text,
	suggestion varchar(255),
	created datetime,
	createdBy varchar(100),
	createdByUsr varchar(100)
)
BEGIN 
	INSERT INTO surveyService 
		(company,namePerson,email,phone,surveyDate,questiontreatment,reasontreatment,questionIdentificationPersonal,questionIdealEquipment,reasonIdealEquipment,questionTime,reasonTime,questionUniform,reasonUniform,score,sign,suggestion,created,createdBy,createdByUsr)
	VALUES
		(company,namePerson,email,phone,surveyDate,questiontreatment,reasontreatment,questionIdentificationPersonal,questionIdealEquipment,reasonIdealEquipment,questionTime,reasonTime,questionUniform,reasonUniform,score,sign,suggestion,created,createdBy,createdByUsr);
select LAST_INSERT_ID();
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetsurveyServiceById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetsurveyServiceById$$
CREATE PROCEDURE blackstarDb.GetsurveyServiceById(pSurveyServiceId INTEGER)
BEGIN
	SELECT 
		surveyServiceId,
		company,
		namePerson as name,
		email,
		phone,
		surveyDate as date,
		questionTreatment,
		reasonTreatment,
		questionIdentificationPersonal,
		questionIdealEquipment,
		reasonIdealEquipment,
		questionTime,
		reasonTime,
		questionUniform,
		reasonUniform,
		score,
		sign,
		suggestion
	FROM surveyService 
	WHERE surveyServiceId = pSurveyServiceId;
END$$
-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;