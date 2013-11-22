-- -----------------------------------------------------------------------------
-- File:	blackstarDb_ChangeSchema.sql    
-- Name:	blackstarDb_ChangeSchema
-- Desc:	Cambia el esquema de la bd
-- Auth:	Sergio A Gomez
-- Date:	11/11/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    11/11/2013  SAG  	Version inicial. Modificaciones a OS
-- --   --------   -------  ------------------------------------
-- 2    12/11/2013  SAG  	Modificaciones a followUp - isSource
-- --   --------   -------  ------------------------------------
-- 3    13/11/2013  SAG  	Se agrega scheduledService
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.upgradeSchema$$
CREATE PROCEDURE blackstarDb.upgradeSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

-- AGREGANDO COLUMNA isWrong A serviceOrder
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'serviceOrder' AND COLUMN_NAME = 'isWrong') = 0 THEN
		ALTER TABLE serviceOrder ADD isWrong TINYINT NOT NULL DEFAULT 0;
	END IF;
	
-- AGREGANDO COLUMNA isSource A followUp -- ESTA COLUMN INDICA SI EL FOLLOW UP ES IMPORTADO DE LA HOJA ORIGINAL DE TICKETS
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'followUp' AND COLUMN_NAME = 'isSource') =0  THEN
		ALTER TABLE followUp ADD isSource TINYINT NOT NULL DEFAULT 0;
	END IF;
	
-- CREANDO TABLA scheduledService
	IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'scheduledService') = 0 THEN
		CREATE TABLE blackstarDb.scheduledService(
			scheduledServiceId INTEGER NOT NULL AUTO_INCREMENT,
			serviceStatusId CHAR(1) NOT NULL,
			created DATETIME NULL,
			createdBy NVARCHAR(50) NULL,
			createdByUsr NVARCHAR(50) NULL,
			modified DATETIME NULL,
			modifiedBy NVARCHAR(50) NULL,
			modifiedByUsr NVARCHAR(50) NULL,	
			PRIMARY KEY (scheduledServiceId),
			UNIQUE UQ_scheduledService_scheduledServiceId(scheduledServiceId),
			KEY(serviceStatusId)
		) ENGINE=INNODB;
		
		ALTER TABLE blackstarDb.scheduledService ADD CONSTRAINT FK_scheduledService_serviceStatus
		FOREIGN KEY (serviceStatusId) REFERENCES serviceStatus (serviceStatusId);
	END IF;


-- CREANDO TABLA scheduledServicePolicy
	IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'scheduledServicePolicy') = 0 THEN
		CREATE TABLE blackstarDb.scheduledServicePolicy(
			scheduledServicePolicyId INTEGER NOT NULL AUTO_INCREMENT,
			scheduledServiceId INTEGER NOT NULL,
			policyId INTEGER NOT NULL,
			created DATETIME NULL,
			createdBy NVARCHAR(50) NULL,
			createdByUsr NVARCHAR(50) NULL,
			PRIMARY KEY (scheduledServicePolicyId),
			UNIQUE UQ_scheduledServicePolicy_scheduledServicePolicyId(scheduledServicePolicyId),
			KEY(scheduledServiceId),
			KEY(policyId)
		) ENGINE=INNODB;
		
		ALTER TABLE blackstarDb.scheduledServicePolicy ADD CONSTRAINT FK_scheduledServicePolicy_scheduledService
		FOREIGN KEY (scheduledServiceId) REFERENCES scheduledService (scheduledServiceId);
		
		ALTER TABLE blackstarDb.scheduledServicePolicy ADD CONSTRAINT FK_scheduledServicePolicy_policy
		FOREIGN KEY (policyId) REFERENCES policy (policyId);
	END IF;
	

-- CREANDO TABLA scheduledServiceEmployee
	IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'scheduledServiceEmployee') = 0 THEN
		CREATE TABLE blackstarDb.scheduledServiceEmployee(
			scheduledServiceEmployeeId INTEGER NOT NULL AUTO_INCREMENT,
			scheduledServiceId INTEGER NOT NULL,
			employeeId VARCHAR(100) NOT NULL,
			isDefault TINYINT NOT NULL DEFAULT 0,
			created DATETIME NULL,
			createdBy NVARCHAR(50) NULL,
			createdByUsr NVARCHAR(50) NULL,
			PRIMARY KEY (scheduledServiceEmployeeId),
			KEY(scheduledServiceId),
			UNIQUE UQ_scheduledServiceEmployee_scheduledServiceEmployeeId(scheduledServiceEmployeeId)
		) ENGINE=INNODB;
		
		ALTER TABLE blackstarDb.scheduledServiceEmployee ADD CONSTRAINT FK_scheduledServiceEmployee_scheduledService
		FOREIGN KEY (scheduledServiceId) REFERENCES scheduledService (scheduledServiceId);
	END IF;
	
-- CREANDO TABLA scheduledServiceDate
	IF (SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'scheduledServiceDate') = 0 THEN
		CREATE TABLE blackstarDb.scheduledServiceDate(
			scheduledServiceDateId INTEGER NOT NULL AUTO_INCREMENT,
			scheduledServiceId INTEGER NOT NULL,
			serviceDate DATE NOT NULL,
			created DATETIME NULL,
			createdBy NVARCHAR(50) NULL,
			createdByUsr NVARCHAR(50) NULL,
			PRIMARY KEY (scheduledServiceDateId),
			KEY(scheduledServiceId),
			UNIQUE UQ_scheduledServiceDate_scheduledServiceDateId(scheduledServiceDateId)
		) ENGINE=INNODB;
		
		ALTER TABLE blackstarDb.scheduledServiceDate ADD CONSTRAINT FK_scheduledServiceDate_scheduledService
		FOREIGN KEY (scheduledServiceId) REFERENCES scheduledService (scheduledServiceId);
	END IF;
	
-- -----------------------------------------------------------------------------
-- FIN SECCION DE CAMBIOS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDb.upgradeSchema();

DROP PROCEDURE blackstarDb.upgradeSchema;

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
-- 2    04/10/2013	SAG		Se Integra:
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
-- 10   13/11/2013	SAG		Se Integra:
-- 								blackstarDb.GetOfficesList
-- -----------------------------------------------------------------------------
-- 11   13/11/2013	SAG		Se Sustituye:
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
-- 11   21/11/2013	SAG		Se Integra:
-- 								blackstarDb.GetAllServiceOrders
-- 								blackstarDb.CloseOS
-- -----------------------------------------------------------------------------

use blackstarDb;


DELIMITER $$


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
	-- blackstarDb.GetAllServiceOrders
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllServiceOrders$$
CREATE PROCEDURE blackstarDb.GetAllServiceOrders()
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
		ss.serviceStatus AS serviceStatus
	FROM serviceOrder so 
		INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
		INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
		INNER JOIN policy p ON so.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmenttypeId = et.equipmenttypeId
		INNER JOIN office of on p.officeId = of.officeId
     LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
	ORDER BY so.ServiceOrderId DESC;
	
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
		customer AS customer,
		project AS project,
		serialNumber AS serialNumber,
		officeName AS officeName,
		brand AS brand,
		us.name AS employee
	FROM blackstarDb.scheduledService s
		INNER JOIN blackstarDb.scheduledServicePolicy sp ON sp.scheduledServiceId = s.scheduledServiceId
		INNER JOIN blackstarDb.scheduledServiceDate sd ON sd.scheduledServiceId = s.scheduledServiceId
		INNER JOIN blackstarDb.policy p ON sp.policyId = p.policyId
		INNER JOIN blackstarDb.serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		INNER JOIN blackstarDb.equipmentType et ON et.equipmentTypeId = p.equipmentTypeId
		INNER JOIN blackstarDb.scheduledServiceEmployee em ON em.scheduledServiceId = s.scheduledServiceId AND em.isDefault = 1
		INNER JOIN blackstarDb.blackstarUser us ON us.email = em.employeeId
		INNER JOIN blackstarDb.office o ON o.officeId = p.officeId
	WHERE s.serviceStatusId = 'P'
		AND serviceDate >= pServiceDate
	ORDER BY equipmentType;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddScheduledServiceEmployee
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddScheduledServiceDate$$
CREATE PROCEDURE blackstarDb.AddScheduledServiceDate(pScheduledServiceId INTEGER, pDate DATETIME, pUser VARCHAR(100))
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
		'AddScheduledServiceDate',
		pUser;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddScheduledServiceEmployee
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddScheduledServiceEmployee$$
CREATE PROCEDURE blackstarDb.AddScheduledServiceEmployee(pScheduledServiceId INTEGER, pEmployeeId VARCHAR(100), pIsDefault TINYINT, pUser VARCHAR(100))
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
		'AddScheduledServiceEmployee',
		pUser;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddScheduledServicePolicy
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddScheduledServicePolicy$$
CREATE PROCEDURE blackstarDb.AddScheduledServicePolicy(pScheduledServiceId INTEGER, pPolicyId INTEGER, pUser VARCHAR(100))
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
		'AddScheduledServicePolicy',
		pUser;
	
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
	WHERE g.externalId = pUserGroup
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
CREATE PROCEDURE blackstarDb.CloseTicket(pTicketId INTEGER, pOsId INTEGER, pModifiedBy VARCHAR(100))
BEGIN
	
	-- ACTUALIZAR EL ESTATUS DEL TICKET Y NUMERO DE ORDEN DE SERVICIO
	UPDATE ticket t 
		INNER JOIN ticket t2 on t.ticketId = t2.ticketId
	SET 
		t.ticketStatusId = IF(t2.ticketStatusId = 'R', 'F', 'C'),
		t.serviceOrderId = pOsId,
		t.modified = NOW(),
		t.modifiedBy = 'CloseTicket',
		t.modifiedByUsr = pModifiedBy
	WHERE t.ticketId = pTicketId;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpToOS$$
CREATE PROCEDURE blackstarDb.AddFollowUpToOS(pOsId INTEGER, pCreated DATETIME, pCreatedBy VARCHAR(100), pAsignee VARCHAR(100), pMessage TEXT)
BEGIN

	-- INSERTAR EL REGISTRO DE SEGUIMIENTO
	INSERT INTO blackstarDb.followUp(
		serviceOrderId,
		asignee,
		followup,
		created,
		createdBy,
		createdByUsr
	)
	SELECT 
		pOsId,
		pAsignee,
		pMessage,
		pCreated,
		'AddFollowUpToTicket',
		pCreatedBy;

END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpToTicket$$
CREATE PROCEDURE blackstarDb.AddFollowUpToTicket(pTicketId INTEGER, pCreated DATETIME, pCreatedBy VARCHAR(100), pAsignee VARCHAR(100), pMessage TEXT)
BEGIN

	-- INSERTAR EL REGISTRO DE SEGUIMIENTO
	INSERT INTO blackstarDb.followUp(
		ticketId,
		asignee,
		followup,
		created,
		createdBy,
		createdByUsr
	)
	SELECT 
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
CREATE PROCEDURE blackstarDb.UpsertScheduledService(pScheduledServiceId INTEGER, pUser VARCHAR(100) )
BEGIN

	IF pScheduledServiceId = 0 THEN
		INSERT INTO scheduledService(
			serviceStatusId,
			created,
			createdBy,
			createdByUsr
		)
		SELECT 
			'P', NOW(), 'UpsertScheduledService', pUser;
			
		SET pScheduledServiceId = LAST_INSERT_ID();
	END IF;
	
	UPDATE scheduledService SET
			serviceStatusId = 'P',
			modified = NOW(),
			modifiedBy = 'UpsertScheduledService',
			modifiedByUsr = pUser
	WHERE scheduledServiceId = pScheduledServiceId;
	
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
		created AS created,
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
	ORDER BY created;
	
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
		created AS created,
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
		customer AS customer,
		project AS project,
		serialNumber AS serialNumber,
		us.name AS employee
	FROM blackstarDb.scheduledService s
		INNER JOIN blackstarDb.scheduledServicePolicy sp ON sp.scheduledServiceId = s.scheduledServiceId
		INNER JOIN blackstarDb.scheduledServiceDate sd ON sd.scheduledServiceId = s.scheduledServiceId
		INNER JOIN blackstarDb.policy p ON sp.policyId = p.policyId
		INNER JOIN blackstarDb.serviceStatus ss ON ss.serviceStatusId = s.serviceStatusId
		INNER JOIN blackstarDb.equipmentType et ON et.equipmentTypeId = p.equipmentTypeId
		INNER JOIN blackstarDb.scheduledServiceEmployee em ON em.scheduledServiceId = s.scheduledServiceId AND em.isDefault = 1
		INNER JOIN blackstarDb.blackstarUser us ON us.email = em.employeeId
	WHERE s.serviceStatusId = 'P'
		AND serviceDate = pServiceDate
	ORDER BY equipmentType;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetDomainEmployees
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetDomainEmployees$$
CREATE PROCEDURE blackstarDb.GetDomainEmployees()
BEGIN

	SELECT DISTINCT email AS email, name AS name
	FROM blackstarUser
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
		et.equipmenttype AS equipmentType,
		p.responseTimeHR AS responseTimeHR,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		tk.ticketNumber AS Asignar
	FROM ticket tk 
		INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		INNER JOIN policy p ON tk.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmenttypeId = et.equipmenttypeId
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
		et.equipmenttype AS equipmentType,
		p.responseTimeHR AS responseTimeHR,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		IFNULL(bu.name, '') AS asignee,
		tk.ticketNumber AS asignar
	FROM ticket tk 
		INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		INNER JOIN policy p ON tk.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmenttypeId = et.equipmenttypeId
		INNER JOIN office of on p.officeId = of.officeId
		LEFT OUTER JOIN blackstarUser bu ON bu.email = tk.asignee
	WHERE tk.created > '01-01' + YEAR(NOW())
    ORDER BY tk.created DESC;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.GetServiceOrders
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetServiceOrders$$
CREATE PROCEDURE blackstarDb.GetServiceOrders(IN status VARCHAR(20))
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
		ss.serviceStatus AS serviceStatus
	FROM serviceOrder so 
		INNER JOIN serviceType st ON so.servicetypeId = st.servicetypeId
		INNER JOIN serviceStatus ss ON so.serviceStatusId = ss.serviceStatusId
		INNER JOIN policy p ON so.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmenttypeId = et.equipmenttypeId
		INNER JOIN office of on p.officeId = of.officeId
     LEFT OUTER JOIN ticket t on t.ticketId = so.ticketId
	WHERE ss.serviceStatus = status
	ORDER BY serviceOrderNumber ;
	
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
		et.equipmenttype AS equipmentType,
		tk.solutionTimeDeviationHr AS solutionTimeDeviationHr,
		p.project AS project,
		ts.ticketStatus AS ticketStatus,
		'Crear OS' AS OS 
	FROM ticket tk 
		INNER JOIN ticketStatus ts ON tk.ticketStatusId = ts.ticketStatusId
		INNER JOIN policy p ON tk.policyId = p.policyId
		INNER JOIN equipmentType et ON p.equipmenttypeId = et.equipmenttypeId
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

	UPDATE ticket SET
		employee = IFNULL(employee, pEmployee),
		asignee = pEmployee,
		modified = NOW(),
		modifiedBy = proc,
		modifiedByUsr = usr
	WHERE ticketId = pTicketId;
	
END$$

-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;

-- -----------------------------------------------------------------------------
-- File:	blackstarDbTransfer_LoadTransferData.sql   
-- Name:	blackstarDbTransfer_LoadTransferData
-- Desc:	Transfiere los datos de la BD temporal a la BD de produccion
-- Auth:	Sergio A Gomez
-- Date:	29/09/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    29/09/2013  SAG  	Version inicial: Transfiere los datos de blackstarTransferDb a blackstarDb
-- -----------------------------------------------------------------------------
-- 2    08/11/2013  SAG  	Se convierte a SP
-- -----------------------------------------------------------------------------

use blackstarDbTransfer;


DELIMITER $$
-- -----------------------------------------------------------------------------
	-- blackstarDb.GetEquipmentByCustomer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDbTransfer.ExecuteTransfer$$
CREATE PROCEDURE blackstarDbTransfer.ExecuteTransfer()
BEGIN

  -- LLENAR CATALOGO DE POLIZAS
	INSERT INTO blackstarDb.policy(
		officeId,
		policyTypeId,
		customerContract,
		customer,
		finalUser,
		project,
		cst,
		equipmentTypeId,
		brand,
		model,
		serialNumber,
		capacity,
		equipmentAddress,
		equipmentLocation,
		contactName,
		contactPhone,
		contactEmail,
		startDate,
		endDate,
		visitsPerYear,
		responseTimeHR,
		solutionTimeHR,
		penalty,
		service,
		includesParts,
		exceptionParts,
		serviceCenterId,
		observations,
		created,
		createdBy,
		crratedByUsr
	)
	SELECT o.officeId, policyType, customerContract, customer, finalUser, project, cst, equipmentTypeId, brand, model, 
			serialNumber, capacity, equipmentAddress, equipmentLocation, contact, contactPhone, contactEmail, startDate, endDate, visitsPerYear, 
			responseTimeHR, solutionTimeHR, penalty, service, includesParts, exceptionParts, serviceCenterId, observations,
			CURRENT_DATE(), 'PolicyTransfer', 'sergio.aga'
	FROM blackstarDbTransfer.policy p
		INNER JOIN blackstarDb.office o ON p.office = o.officeName
		INNER JOIN blackstarDb.serviceCenter s ON s.serviceCenter = p.serviceCenter
	WHERE p.serialNumber NOT IN (SELECT DISTINCT serialNumber FROM blackstarDb.policy);
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
	-- LLENAR BASE DE DATOS DE TICKETS
	INSERT INTO blackstarDb.ticket(
		policyId,
		ticketNumber,
		user,
		observations,
		phoneResolved,
		arrival,
		employee,
		closed,
		created,
		createdBy,
		createdByUsr
	)
	SELECT p.policyId, tt.ticketNumber, tt.user, tt.observations, phoneResolved, tt.arrival, tt.employee, tt.closed, tt.created, 'TicketTransfer', 'sergio.aga'
	FROM blackstarDbTransfer.ticket tt
		INNER JOIN blackstarDbTransfer.policy pt ON tt.policyId = pt.policyId	
		INNER JOIN blackstarDb.policy p ON p.serialNumber = pt.serialNumber AND pt.serialNumber != 'NA'
	WHERE tt.ticketNumber NOT IN (SELECT ticketNumber FROM blackstarDb.ticket);
	
	-- ACTUALIZAR TIEMPOS DE RESPUESTA
	UPDATE blackstarDb.ticket SET 
		realResponseTime =  TIMESTAMPDIFF(HOUR, created, IFNULL(arrival, CURRENT_DATE()));
		
	-- ACTUALIZAR DESVIACIONES DE TIEMPO DE RESPUESTA
	UPDATE blackstarDb.ticket t 
		INNER JOIN blackstarDb.policy p on p.policyId = t.policyId
	SET 
		responseTimeDeviationHr = CASE WHEN(realResponseTime < responseTimeHR) THEN 0 ELSE (realResponseTime - responseTimeHR) END;

	-- ACTUALIZAR TIEMPOS DE SOLUCION
	UPDATE blackstarDb.ticket SET 
		solutionTime =  CASE WHEN (closed IS NULL) THEN NULL ELSE (TIMESTAMPDIFF(HOUR, created, closed)) END;
		
	-- ACTUALIZAR DESVIACIONES DE TIEMPO DE SOLUCION
	UPDATE blackstarDb.ticket t 
		INNER JOIN blackstarDb.policy p on p.policyId = t.policyId
	SET 
		solutionTimeDeviationHr = CASE WHEN(solutionTime < solutionTimeHR) THEN 0 ELSE (solutionTime - solutionTimeHR) END;
		
	-- CAMBIAR OBSERVATIONS POR FOLLOW UPS SOLO EN LOS TICKETS QUE NO TIENEN
	INSERT INTO blackstarDb.followUp(
		ticketId,
		asignee,
		followup,
		isSource,
		created,
		createdBy,
		createdByUsr
	)
	SELECT bt.ticketId, 'marlem.samano@gposac.com.mx', tt.followUp, 1, NOW(), 'TicketTransfer', 'sergio.aga'
	FROM blackstarDbTransfer.ticket tt 
		INNER JOIN blackstarDb.ticket bt ON tt.ticketNumber = bt.ticketNumber
		LEFT OUTER JOIN blackstarDb.followUp f ON bt.ticketId = f.ticketId
	WHERE tt.followUp IS NOT NULL
	AND f.followUpId IS NULL;
	
	-- ACTUALIZAR LOS FOLLOW UPS
	UPDATE blackstarDb.followUp bf
		INNER JOIN blackstarDb.ticket bt ON bt.ticketId = bf.ticketId
		INNER JOIN blackstarDbTransfer.ticket tt ON  tt.ticketNumber = bt.ticketNumber
	SET	
		bf.followUp = tt.followUp
	WHERE bf.isSource = 1;
	
	
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
	-- INSERTAR LAS ORDENES DE SERVICIO
	INSERT INTO blackstarDb.serviceOrder(
		serviceOrderNumber,
		serviceTypeId,
		ticketId,
		policyId,
		serviceUnit,
		serviceDate,
		responsible,
		receivedBy,
		serviceComments,
		closed,
		consultant,
		created,
		createdBy,
		createdByUsr
	)
	SELECT ot.serviceNumber, ot.serviceTypeId, t.ticketId, p.policyId, ot.serviceUnit, ot.serviceDate, ot.responsible, ot.receivedBy, 
		ot.serviceComments, ot.closed, ot.consultant, CURRENT_DATE(), 'ServiceOrderTransfer', 'sergio.aga'
	FROM blackstarDbTransfer.serviceTx ot
		LEFT OUTER JOIN blackstarDb.ticket t ON t.ticketNumber = ot.ticketNumber
		LEFT OUTER JOIN blackstarDb.policy p ON p.serialNumber = ot.serialNumber AND ot.serialNumber != 'NA'
	WHERE ot.serviceNumber NOT IN (SELECT serviceOrderNumber FROM blackstarDb.serviceOrder);
		
	-- ACTUALIZACION DEL STATUS
	UPDATE blackstarDb.serviceOrder SET
		serviceStatusId = CASE WHEN (closed IS NULL) THEN 'E' ELSE 'C' END;
		
	-- CAMBIAR OBSERVATIONS POR FOLLOW UPS SOLO EN LOS TICKETS QUE NO TIENEN
	INSERT INTO blackstarDb.followUp(
		serviceOrderId,
		asignee,
		followup,
		isSource,
		created,
		createdBy,
		createdByUsr
	)
	SELECT o.serviceOrderId, 'angeles.avila@gposac.com.mx', st.followUp, 1, NOW(), 'TicketTransfer', 'sergio.aga'
	FROM blackstarDbTransfer.serviceTx st 
		INNER JOIN blackstarDb.serviceOrder o ON st.serviceNumber = o.serviceOrderNumber
		LEFT OUTER JOIN blackstarDb.followUp f ON o.serviceOrderId = f.serviceOrderId
	WHERE st.followUp IS NOT NULL
	AND f.followUpId IS NULL;
	
	-- ACTUALIZACION DEL SERVICE ID DE CIERRE DEL TICKET
	UPDATE blackstarDb.ticket t
		INNER JOIN blackstarDbTransfer.ticket tt ON t.ticketNumber = tt.ticketNumber
		INNER JOIN blackstarDb.serviceOrder so ON tt.serviceOrderNumber = so.serviceOrderNumber	
	SET
		t.serviceOrderId = so.serviceOrderId;	
	
	-- ACTUALIZACION DEL ESTADO DE LOS TICKETS
	CALL blackstarDb.UpdateTicketStatus();
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
	-- ELIMINACION DE COMILLAS QUE PROVOCAN PROBLEMAS AL CONVERTIR A JSON
	UPDATE blackstarDb.policy SET	
		equipmentAddress = REPLACE( equipmentAddress,'"','');
		
	UPDATE blackstarDb.policy SET	
		equipmentLocation = REPLACE( equipmentLocation,'"','');
		
	UPDATE blackstarDb.policy SET	
		penalty = REPLACE( penalty,'"','');
		
	UPDATE blackstarDb.policy SET	
		observations = REPLACE( observations,'"','');
		
	UPDATE blackstarDb.serviceOrder SET	
		serviceComments = REPLACE( serviceComments,'"','');
		
	UPDATE blackstarDb.ticket SET	
		observations = REPLACE( observations,'"','');

	UPDATE blackstarDb.followUp SET	
		followUp = REPLACE( followUp,'"','');
	
	-- ELIMINACION DE TABS QUE PROVOCAN PROBLEMAS AL CONVERTIR A JSON

	UPDATE blackstarDb.policy SET	
		observations = REPLACE( observations,'\t',' ');
		
	UPDATE blackstarDb.serviceOrder SET	
		serviceComments = REPLACE( serviceComments,'\t',' ');
		
	UPDATE blackstarDb.ticket SET	
		observations = REPLACE( observations,'\t',' ');

	UPDATE blackstarDb.followUp SET	
		followUp = REPLACE( followUp,'\t','');
		
	-- ELIMINACION DE RETORNOS DE CARRO QUE PROVOCAN PROBLEMAS AL CONVERTIR A JSON
	UPDATE blackstarDb.policy SET	
		equipmentAddress = REPLACE( equipmentAddress,'\n','');
		
	UPDATE blackstarDb.policy SET	
		equipmentLocation = REPLACE( equipmentLocation,'\n','');
		
	UPDATE blackstarDb.policy SET	
		penalty = REPLACE( penalty,'\n','');
		
	UPDATE blackstarDb.policy SET	
		observations = REPLACE( observations,'\n','');
		
	UPDATE blackstarDb.policy SET	
		contactPhone = REPLACE( contactPhone,'\n','');
		
	UPDATE blackstarDb.policy SET	
		contactEmail = REPLACE( contactEmail,'\n','');

	UPDATE blackstarDb.serviceOrder SET	
		serviceComments = REPLACE( serviceComments,'\n','');
		
	UPDATE blackstarDb.ticket SET	
		observations = REPLACE( observations,'\n','');

	UPDATE blackstarDb.followUp SET	
		followUp = REPLACE( followUp,'\n','');
-- -----------------------------------------------------------------------------
END$$

-- -----------------------------------------------------------------------------
	-- FIN 
-- -----------------------------------------------------------------------------
DELIMITER ;

-- -----------------------------------------------------------------------------
-- File:	blackstarManage_StoredProcedures.sql   
-- Name:	blackstarManage_StoredProcedures
-- Desc:	Crea o actualiza los Stored procedures administrativos de la aplicacion
-- Auth:	Sergio A Gomez
-- Date:	03/10/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    03/10/2013	SAG		Se Integran los SP iniciales:
--								blackstarManage.WriteLog
-- -----------------------------------------------------------------------------
use blackstarManage;


DELIMITER $$

-- -----------------------------------------------------------------------------
	-- blackstarManage.WriteLog
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarManage.WriteLog$$
CREATE PROCEDURE blackstarManage.WriteLog (
	pLevel		VARCHAR(20),
	pError		VARCHAR(400),
	pSender		TEXT,
	pStackTrace	TEXT
)
BEGIN

	INSERT INTO blackstarManage.errorLog(
		severity,		
		created, 	
		error,		
		sender,		
		stackTrace
	)
	SELECT 
		pLevel, NOW(), pError, pSender, pStackTrace;
	
END$$


-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;

-- -----------------------------------------------------------------------------
-- File:blackstarDb_startupData.sql
-- Name:blackstarDb_startupData
-- Desc:Hace una carga inicial de usuarios para poder operar el sistema
-- Auth:Sergio A Gomez
-- Date:22/10/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    AuthorDescription
-- --   --------   -------  ------------------------------------
-- 1    22/10/2013  SAG  	Version inicial. Usuarios basicos de GPO Sac
-- --   --------   -------  ------------------------------------
-- 2    12/11/2013  SAG  	Version 1.1. Se agrega ExecuteTransfer
-- ---------------------------------------------------------------------------
use blackstarDb;


-- -----------------------------------------------------------------------------
-- SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------
use blackstarDbTransfer;

CALL ExecuteTransfer();
-- -----------------------------------------------------------------------------
-- FIN - SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------




