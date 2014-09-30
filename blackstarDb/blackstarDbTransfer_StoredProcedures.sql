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
-- 3    13/03/2014  SAG  	Soporte para un equipo en mas de una poliza
-- -----------------------------------------------------------------------------
-- 4	01/04/2014	SAG		Se implementa modelo STTP para tickets
-- -----------------------------------------------------------------------------
-- 5	28/05/2014	SAG		Correcciones de duplicacion en OS
-- -----------------------------------------------------------------------------
-- 6	23/06/2014	SAG		Se agrega referencia a open customer para OS importadas
-- -----------------------------------------------------------------------------
-- 7 	24/07/2014	SAG 	Se implementa multi usuario cliente de poliza
-- -----------------------------------------------------------------------------
-- 8 	30/07/2014	SAG 	Se implementa UpsertPolicy
-- -----------------------------------------------------------------------------
-- 9 	30/07/2014	SAG 	Se implementa UpsertServiceOrder
-- -----------------------------------------------------------------------------
-- 10 	20/08/2014	SAG 	Se incorpora proyecto Bloom
-- -----------------------------------------------------------------------------
-- 11 	22/09/2014	SAG 	Se agrega UpsertbloomTicket
-- -----------------------------------------------------------------------------

use blackstarDbTransfer;


DELIMITER $$


-- -----------------------------------------------------------------------------
	-- blackstarDb.upsertbloomTicket
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS upsertbloomTicket $$
CREATE PROCEDURE upsertbloomTicket(
	pCreated DATETIME,
	pCreatedByUsr VARCHAR(100),
	pTicketType INT,
	pDueDate DATETIME,
	pDescription VARCHAR(4000),
	pProject VARCHAR(100),
	pOffice VARCHAR(100),
	pTicketNumber VARCHAR(100),
	pfollowUp VARCHAR(2000),
	pResponseTime DATETIME,
	pResolved INT,
	pStatus CHAR(1),
	processed INT
)
BEGIN
	IF(SELECT count(*) FROM blackstarDbTransfer.bloomTicket WHERE ticketNumber = pTicketNumber)  = 0 THEN
		INSERT INTO blackstarDbTransfer.bloomTicket(
			created,  createdByUsr,  ticketType,  dueDate,  description,  project,  office,  ticketNumber,  followUp,  responseTime,  resolved,  status, processed )
		SELECT 
			pCreated, pCreatedByUsr, pTicketType, pDueDate, pDescription, pProject, pOffice, pTicketNumber, pfollowUp, pResponseTime, pResolved, pStatus, 0;
	ELSE
		UPDATE blackstarDbTransfer.bloomTicket SET
			created = pCreated,
			createdByUsr = pCreatedByUsr,
			ticketType = pTicketType,
			dueDate = pDueDate,
			description = pDescription,
			project = pProject,
			office = pOffice,
			ticketNumber = pTicketNumber,
			followUp = pfollowUp,
			responseTime = pResponseTime,
			resolved = pResolved,
			status = pStatus,
			processed = 0
		WHERE ticketNumber = pTicketNumber;
	END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertServiceOrder
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS upsertServiceOrder $$
CREATE PROCEDURE upsertServiceOrder(
	pServiceNumber varchar(50),
	pTicketNumber varchar(50),
	pServiceUnit varchar(10),
	pProject varchar(50),
	pCustomer varchar(200),
	pCity varchar(50),
	pAddress varchar(300),
	pServiceTypeId char(1),
	pServiceDate datetime,
	pSerialNumber varchar(200),
	pResponsible varchar(100),
	pReceivedBy varchar(100),
	pServiceComments text,
	pClosed datetime,
	pfollowUp text,
	pSpares text,
	pConsultant varchar(100),
	pContractorCompany varchar(100),
	pServiceRate int(11),
	pCustomerComments text,
	pCreated datetime,
	pCreatedBy varchar(45),
	pCreatedByUsr varchar(45),
	pEquipmentTypeId char(1),
	pBrand varchar(100),
	pModel varchar(100),
	pCapacity varchar(100),
	pEmployeeId varchar(400)
)
BEGIN
	IF(SELECT count(*) FROM serviceTx WHERE serviceNumber = pServiceNumber) = 0 THEN
		INSERT INTO blackstarDbTransfer.serviceTx(
			serviceNumber,  ticketNumber,  serviceUnit,  project,  customer,  city,  address,  serviceTypeId,  serviceDate,  serialNumber,  responsible,  receivedBy,  serviceComments,  closed,  followUp,  spares,  consultant,  contractorCompany,  serviceRate,  customerComments,  created,  createdBy,  createdByUsr,  equipmentTypeId,  brand,  model,  capacity,  employeeId )
		SELECT
			pServiceNumber, pTicketNumber, pServiceUnit, pProject, pCustomer, pCity, pAddress, pServiceTypeId, pServiceDate, pSerialNumber, pResponsible, pReceivedBy, pServiceComments, pClosed, pfollowUp, pSpares, pConsultant, pContractorCompany, pServiceRate, pCustomerComments, pCreated, pCreatedBy, pCreatedByUsr, pEquipmentTypeId, pBrand, pModel, pCapacity, pEmployeeId;
	ELSE
		UPDATE serviceTx SET
			employeeId = pEmployeeId
		WHERE serviceNumber = pServiceNumber;
	END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.upsertPolicy
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS upsertPolicy $$
CREATE PROCEDURE upsertPolicy(
	  pOffice VARCHAR(50),
	  pPolicyType VARCHAR(50),
	  pCustomerContract VARCHAR(50),
	  pCustomer VARCHAR(100),
	  pFinalUser VARCHAR(200),
	  pProject VARCHAR(50),
	  pCst VARCHAR(50),
	  pEquipmentTypeId CHAR(1),
	  pBrand VARCHAR(50),
	  pModel VARCHAR(100),
	  pSerialNumber VARCHAR(100),
	  pCapacity VARCHAR(50),
	  pEquipmentAddress VARCHAR(250),
	  pEquipmentLocation VARCHAR(250),
	  pContact VARCHAR(100),
	  pContactEmail VARCHAR(200),
	  pContactPhone VARCHAR(200),
	  pStartDate DATETIME,
	  pEndDate DATETIME,
	  pVisitsPerYear INT(11),
	  pResponseTimeHr INT(11),
	  pSolutionTimeHr INT(11),
	  pPenalty TEXT,
	  pService VARCHAR(50),
	  pIncludesParts TINYINT(1),
	  pExceptionParts VARCHAR(100),
	  pServiceCenter VARCHAR(50),
	  pObservations TEXT,
	  pEquipmentUser VARCHAR(200),
	  pCreated DATETIME,
	  pCreatedBy VARCHAR(45),
	  pCreatedByUsr VARCHAR(45))
BEGIN
	IF (SELECT count(*) FROM policy p WHERE p.serialNumber = pSerialNumber AND p.project = pProject) = 0 THEN
		INSERT INTO blackstarDbTransfer.policy(office,  policyType,  customerContract,  customer,  finalUser,  project,  cst,  equipmentTypeId,  brand,  model,  serialNumber,  capacity,  equipmentAddress,  equipmentLocation,  contact,  contactEmail,  contactPhone,  startDate,  endDate,  visitsPerYear,  responseTimeHr,  solutionTimeHr,  penalty,  service,  includesParts,  exceptionParts,  serviceCenter,  observations,  created,  createdBy,  createdByUsr,  equipmentUser)
										SELECT 	pOffice, pPolicyType, pCustomerContract, pCustomer, pFinalUser, pProject, pCst, pEquipmentTypeId, pBrand, pModel, pSerialNumber, pCapacity, pEquipmentAddress, pEquipmentLocation, pContact, pContactEmail, pContactPhone, pStartDate, pEndDate, pVisitsPerYear, pResponseTimeHr, pSolutionTimeHr, pPenalty, pService, pIncludesParts, pExceptionParts, pServiceCenter, pObservations, pCreated, pCreatedBy, pCreatedByUsr, pEquipmentUser;
	ELSE
		UPDATE blackstarDbTransfer.policy SET 
			startDate = pStartDate,
			endDate = pEndDate,
			serviceCenter = pServiceCenter,
			equipmentUser = pEquipmentUser,
			equipmentAddress = equipmentAddress,
			contact = pContact,
			contactEmail = pContactEmail,
			contactPhone = pContactPhone,
			modified = now(),
			capacity = pCapacity,
			modifiedBy = 'UpsertPolicy'
		WHERE serialNumber = pSerialNumber AND project = pProject;
	END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.syncPolicyUsers
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS syncPolicyUsers $$
CREATE PROCEDURE syncPolicyUsers()
BEGIN

    DECLARE id INT DEFAULT 0;
    DECLARE value TEXT;
    DECLARE occurance INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE splitted_value VARCHAR(1000);
    DECLARE done INT DEFAULT 0;
    DECLARE cur1 CURSOR FOR 
    	SELECT p2.policyId, p1.equipmentUser
		FROM blackstarDbTransfer.policy p1
			INNER JOIN blackstarDb.policy p2 ON p1.serialNumber = p2.serialNumber AND p1.brand = p2.brand AND p1.model = p2.model
		WHERE IFNULL(p1.equipmentUser, '') != '';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
   
	CREATE TEMPORARY TABLE rawPolicyEquipment(policyId INT, user VARCHAR(200));

    OPEN cur1;
      read_loop: LOOP
        FETCH cur1 INTO id, value;
        IF done THEN
          LEAVE read_loop;
        END IF;

        SET value = REPLACE(value,' ','');
        SET occurance = (SELECT LENGTH(value)
                                 - LENGTH(REPLACE(value, ',', ''))
                                 +1);
        SET i=1;
        WHILE i <= occurance DO
          SET splitted_value =
          (SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(value, ',', i),
          LENGTH(SUBSTRING_INDEX(value, ',', i - 1)) + 1), ',', ''));

          INSERT INTO rawPolicyEquipment(policyId, user) VALUES (id, splitted_value);
          SET i = i + 1;

        END WHILE;
      END LOOP;

    CLOSE cur1;

    -- Insertando los valores reales
    TRUNCATE TABLE blackstarDb.policyEquipmentUser;

    INSERT INTO blackstarDb.policyEquipmentUser(policyId, equipmentUserId)
    SELECT DISTINCT policyId, user 
    FROM rawPolicyEquipment;

    DROP TEMPORARY TABLE rawPolicyEquipment;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.ExecuteTransfer
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
		equipmentUser,
		created,
		createdBy,
		crratedByUsr
	)
	SELECT o.officeId, p.policyType, p.customerContract, p.customer, p.finalUser, p.project, p.cst, p.equipmentTypeId, p.brand, p.model,
		p.serialNumber, p.capacity, p.equipmentAddress, p.equipmentLocation, p.contact, p.contactPhone, p.contactEmail, p.startDate, p.endDate, p.visitsPerYear,
		p.responseTimeHR, p.solutionTimeHR, p.penalty, p.service, p.includesParts, p.exceptionParts, s.serviceCenterId, p.observations, p.equipmentUser,
		CURRENT_DATE(), 'PolicyTransfer', 'portal-servicios'
	FROM blackstarDbTransfer.policy p
		INNER JOIN blackstarDb.office o ON p.office = o.officeName
		INNER JOIN blackstarDb.serviceCenter s ON s.serviceCenter = p.serviceCenter
		LEFT OUTER JOIN blackstarDb.policy bp on p.serialNumber = bp.serialNumber AND p.project = bp.project
	WHERE bp.policyId IS NULL;

	-- ACTUALIZAR LAS POLIZAS
	UPDATE blackstarDb.policy bp 
		INNER JOIN blackstarDbTransfer.policy p ON p.serialNumber = bp.serialNumber AND p.project = bp.project
		INNER JOIN blackstarDb.serviceCenter s ON s.serviceCenter = p.serviceCenter
	SET
		bp.startDate = p.startDate,
		bp.endDate = p.endDate,
		bp.serviceCenterId = s.serviceCenterId,
		bp.equipmentAddress = p.equipmentAddress,
		bp.contactName = p.contact,
		bp.contactPhone = p.contactPhone,
		bp.contactEmail = p.contactEmail;

	-- ACTUALIZAR LOS CORREOS DE ACCESO A CLIENTES
	CALL syncPolicyUsers();

-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
	-- INSERTAR TICKETS NUEVOS
	INSERT INTO blackstarDb.ticket(
		policyId,
		ticketNumber,
		createdBy,
		createdByUsr
	)
	SELECT p.policyId, tt.ticketNumber, 'TicketTransfer', 'portal-servicios'
	FROM blackstarDbTransfer.ticket tt
		INNER JOIN blackstarDbTransfer.policy pt ON tt.policyId = pt.policyId	
		INNER JOIN blackstarDb.policy p ON p.serialNumber = pt.serialNumber AND pt.serialNumber != 'NA' AND p.project = pt.project
	WHERE tt.ticketNumber NOT IN (SELECT ticketNumber FROM blackstarDb.ticket);

	-- ACTUALIZAR CERRADO SELECTIVO DE TICKETS
	UPDATE blackstarDb.ticket t 
		INNER JOIN blackstarDbTransfer.ticket tt ON t.ticketNumber = tt.ticketNumber SET
		t.closed = tt.closed
	WHERE tt.processed = 0
	AND t.closed IS NULL AND tt.closed IS NOT NULL;

	-- ACTUALIZACION DEL SERVICE ID DE CIERRE DEL TICKET
	UPDATE blackstarDb.ticket t
		INNER JOIN blackstarDbTransfer.ticket tt ON t.ticketNumber = tt.ticketNumber
		INNER JOIN blackstarDb.serviceOrder so ON tt.serviceOrderNumber = so.serviceOrderNumber	
	SET
		t.serviceOrderId = so.serviceOrderId
	WHERE tt.processed = 0;	

	-- ACTUALIZAR ESTATUS TICKETS EXISTENTES
	UPDATE blackstarDb.ticket t 
		INNER JOIN blackstarDbTransfer.ticket tt ON t.ticketNumber = tt.ticketNumber SET
		t.observations = tt.observations,
		t.phoneResolved = tt.phoneResolved,
		t.arrival = tt.arrival,
		t.employee = tt.employee,
		t.user = tt.user,
		t.created = tt.created,
		t.contact = tt.contact,
		t.contactPhone = tt.contactPhone,
		t.contactEmail = tt.contactEmail,
		tt.processed = 1
	WHERE tt.processed = 0;

	-- ACTUALIZAR TIEMPOS DE RESPUESTA
	UPDATE blackstarDb.ticket SET 
		realResponseTime =  TIMESTAMPDIFF(HOUR, created, arrival)
	WHERE arrival IS NOT NULL;
		
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
		followUp,
		isSource,
		created,
		createdBy,
		createdByUsr
	)
	SELECT bt.ticketId, 'marlem.samano@gposac.com.mx', tt.followUp, 1, NOW(), 'TicketTransfer', 'portal-servicios'
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
		ot.serviceComments, ot.closed, ot.consultant, CURRENT_DATE(), 'ServiceOrderTransfer', 'portal-servicios'
	FROM blackstarDbTransfer.serviceTx ot
		LEFT OUTER JOIN blackstarDb.ticket t ON t.ticketNumber = ot.ticketNumber
		LEFT OUTER JOIN blackstarDb.policy p ON p.serialNumber = ot.serialNumber 
			AND ot.serialNumber != 'NA' 
			AND ot.serialNumber != 'XXXXXXXX' 
			AND ot.project = p.project 
			AND ot.serviceDate >= p.startDate 
			AND ot.serviceDate <= p.endDate
	WHERE ot.serviceNumber NOT IN (SELECT serviceOrderNumber FROM blackstarDb.serviceOrder);
		
	-- ACTUALIZACION DEL STATUS
	UPDATE blackstarDb.serviceOrder SET
		serviceStatusId = 'C'
	WHERE closed IS NOT NULL;
		
	-- CAMBIAR OBSERVATIONS POR FOLLOW UPS SOLO EN LOS TICKETS QUE NO TIENEN
	INSERT INTO blackstarDb.followUp(
		serviceOrderId,
		asignee,
		followUp,
		isSource,
		created,
		createdBy,
		createdByUsr
	)
	SELECT o.serviceOrderId, 'angeles.avila@gposac.com.mx', st.followUp, 1, NOW(), 'TicketTransfer', 'portal-servicios'
	FROM blackstarDbTransfer.serviceTx st 
		INNER JOIN blackstarDb.serviceOrder o ON st.serviceNumber = o.serviceOrderNumber
		LEFT OUTER JOIN blackstarDb.followUp f ON o.serviceOrderId = f.serviceOrderId
	WHERE st.followUp IS NOT NULL
	AND f.followUpId IS NULL;

	-- ACTUALIZACION DEL ESTADO DE LOS TICKETS
	CALL blackstarDb.UpdateTicketStatus();

	-- TRANSFERENCIA DE LOS TICKETS BLOOM
	INSERT INTO blackstarDb.bloomTicket(ticketNumber, applicantUserId, officeId, serviceTypeId, statusId, applicantAreaId, dueDate, project, description, created, createdby, createdByUsr)
	SELECT t1.ticketNumber, bu.blackstarUserId, SUBSTRING(t1.office, 1, 1), t1.ticketType, t1.status, st.applicantAreaId, t1.dueDate, t1.project, t1.description, t1.created, 'bloomTicketTransfer', t1.createdByUsr
	FROM blackstarDbTransfer.bloomTicket t1
		INNER JOIN blackstarDb.blackstarUser bu ON t1.createdByUsr = bu.email
		INNER JOIN blackstarDb.bloomServiceType st ON st._id = t1.ticketType
		LEFT OUTER JOIN blackstarDb.bloomTicket t2 ON t1.ticketNumber =t2.ticketNumber
	WHERE t2._id IS NULL
	AND t1.processed = 0;

	-- ACTUALIZACION DE ESTATUS DE LOS TICKETS
	UPDATE blackstarDb.bloomTicket t2
		INNER JOIN blackstarDbTransfer.bloomTicket t1 ON t1.ticketNumber = t2.ticketNumber
		INNER JOIN blackstarDb.blackstarUser bu ON t1.createdByUsr = bu.email
		INNER JOIN blackstarDb.bloomServiceType st ON st._id = t1.ticketType
	SET 
		t2.applicantUserId = bu.blackstarUserId,
		t2.officeId = SUBSTRING(t1.office, 1, 1),
		t2.serviceTypeId = t1.ticketType,
		t2.statusId = t1.status,
		t2.applicantAreaId = st.applicantAreaId,
		t2.dueDate = t1.dueDate,
		t2.project = t1.project,
		t2.description = t1.description,
		t2.responseDate = t1.responseTime,
		t2.createdByUsr = t1.createdByUsr,
		t2.modified = now(),
		t2.modifiedBy = 'bloomTicketTransfer',
		t2.modifiedByUsr = 'portal-servicios@gposac.com.mx',
		t2.created = t1.created
	WHERE t1.processed = 0;

	-- INSERCION DE LOS USUARIOS RESPONSABLES DE CERRAR
	INSERT INTO blackstarDb.bloomTicketTeam(ticketId, workerRoleTypeId, blackstarUserId, userGroup, assignedDate)
	SELECT t._id, a.workerRoleTypeId, bg.blackStarUserId, a.userGroup, now() 
	FROM blackstarDb.bloomTicket t
		INNER JOIN blackstarDb.bloomAdvisedGroup a ON t.serviceTypeId = a.serviceTypeId
		INNER JOIN blackstarDb.userGroup g ON a.userGroup = g.externalId
		INNER JOIN blackstarDb.blackstarUser_userGroup bg ON bg.userGroupId = g.userGroupId
		LEFT OUTER JOIN blackstarDb.bloomTicketTeam tt ON tt.ticketId = t._id
	WHERE tt._id IS NULL;

	-- INSERCION DE followUps de tickets bloom
	INSERT INTO blackstarDb.followUp(followUp, created, createdBy, createdByUsr, isSource, followUpReferenceTypeId, bloomTicketId)
	SELECT  t1.followUp, now(), 'bloomTicketTransfer', 'portal-servicios@gposac.com.mx', 1, 'R', t2._id
	FROM blackstarDbTransfer.bloomTicket t1
		INNER JOIN blackstarDb.bloomTicket t2 ON t1.ticketNumber = t2.ticketNumber
		LEFT OUTER JOIN blackstarDb.followUp f ON t2._id = f.bloomTicketId
	WHERE f.followUpId IS NULL;

	-- INSERCION DE ENCUESTAS DE TICKETS BLOOM
	INSERT INTO blackstarDb.bloomSurvey(bloomTicketId, evaluation, comments, created)
	SELECT t2._id, if(t1.resolved = 1, 10, 5), 'N/A', now()
	FROM blackstarDbTransfer.bloomTicket t1
		INNER JOIN blackstarDb.bloomTicket t2 ON t1.ticketNumber = t2.ticketNumber
		LEFT OUTER JOIN blackstarDb.bloomSurvey s ON t2._id = s.bloomTicketId
	WHERE s._id IS NULL;

	-- ACTUALIZACION DEL ESTATUS
	UPDATE blackstarDb.bloomTicket t2
		INNER JOIN blackstarDb.bloomServiceType ty ON t2.serviceTypeId = ty._id
		INNER JOIN blackstarDbTransfer.bloomTicket t1 ON t1.ticketNumber = t2.ticketNumber
	SET
		reponseInTime = if(ty.responseTime < (TO_DAYS(t2.responseDate) - TO_DAYS(t2.created)), 0, 1),
		desviation = ((TO_DAYS(t2.responseDate) - TO_DAYS(t2.created)) - ty.responseTime),
		t2.modified = now(),
	    t2.modifiedBy = 'bloomTicketTransfer',
	    t2.modifiedByUsr = 'portal-servicios@gposac.com.mx'
	WHERE responseDate IS NOT NULL
		AND statusId = 6;

	-- PROCESSED
	UPDATE blackstarDbTransfer.bloomTicket SET
		processed = 1
	WHERE processed = 0 
		AND ticketNumber IN(SELECT DISTINCT ticketNumber FROM blackstarDb.bloomTicket);


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
	
	UPDATE blackstarDb.ticket SET	
		employee = REPLACE( employee,'\n','');

	UPDATE blackstarDb.followUp SET	
		followUp = REPLACE( followUp,'\n','');
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
	-- SINCRONIZACION Y ACCESO A USUARIOS DE CLIENTES
	INSERT INTO blackstarDbTransfer.equipmentUserSync (customerName, equipmentUser)
	SELECT DISTINCT customer, equipmentUserId 
	FROM blackstarDb.policy p 
		INNER JOIN blackstarDb.policyEquipmentUser e ON p.policyId = e.policyId
		LEFT OUTER JOIN blackstarDb.blackstarUser u ON e.equipmentUserId = u.email
	WHERE ifnull(equipmentUser, '') != ''
	AND u.blackstarUserId IS NULL;

	IF (SELECT count(*) FROM equipmentUserSync) > 1 THEN
	    SET @c = (SELECT min(equipmentUserSyncId) FROM equipmentUserSync) ;   
	    SET @max = (SELECT max(equipmentUserSyncId) FROM equipmentUserSync) ;   
	    SET @customer = '';
	    SET @access = '';
	    WHILE @c <= @max DO
	    	SET  @customer = (SELECT customerName FROM blackstarDbTransfer.equipmentUserSync WHERE equipmentUserSyncId = @c);
	    	SET  @access = (SELECT equipmentUser FROM blackstarDbTransfer.equipmentUserSync WHERE equipmentUserSyncId = @c);
	    	Call blackstarDb.UpsertUser(@access, @customer, null);
			Call blackstarDb.CreateUserGroup('sysCliente','Cliente',@access);

	      	SET @c = @c + 1 ;
	    END WHILE ;

	    DELETE FROM blackstarDbTransfer.equipmentUserSync;
    END IF;
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
	-- ACTUALIZACION DE OPEN CUSTOMER CON ORDENES DE SERVICIO IMPORTADAS
	INSERT INTO blackstarDb.openCustomer (customerName, address, equipmentTypeId, brand, model, capacity, serialNumber, contactName, officeId, project, transferSo, created, createdBy, createdByUsr)
	SELECT customer, address, equipmentTypeId, brand, model, capacity, serialNumber, receivedBy, officeId, project, serviceNumber, now(), 'ServiceOrderMigrationScript', 'sergio.aga'
	FROM blackstarDbTransfer.serviceTx s
		INNER JOIN blackstarDb.office o ON o.officeName = s.serviceUnit
	WHERE serviceNumber IN (
		SELECT serviceOrderNumber FROM blackstarDb.serviceOrder WHERE policyId is NULL AND openCustomerId is NULL
		AND createdby = 'ServiceOrderTransfer'
	);

	UPDATE blackstarDb.serviceOrder so
		INNER JOIN blackstarDb.openCustomer oc ON oc.transferSo = so.serviceOrderNumber
	SET so.openCustomerId = oc.openCustomerId
	WHERE so.policyId IS NULL AND so.openCustomerId IS NULL;

-- -----------------------------------------------------------------------------
	-- FIN 
-- -----------------------------------------------------------------------------
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomUpdateTickets
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDbTransfer.BloomUpdateTickets$$
CREATE PROCEDURE blackstarDbTransfer.BloomUpdateTickets() 
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
    SELECT * FROM bloomTransferTicket;
    
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
      SET createdByUsrId = IFNULL((SELECT blackStarUserId from blackstarDb.blackstaruser where email = 'portal-servicios@gposac.com.mx'), -1);                               
      SET applicantUserId = IFNULL((SELECT blackStarUserId from blackstarDb.blackstaruser where email = createdByUsr), -1);
      SET officeL = IFNULL((SELECT officeId from blackstarDb.office where officeName = officeStr), '?');
      SET serviceTypeId = IFNULL((SELECT _id from blackstarDb.bloomServiceType where name = serviceType), -1);
      SET applicantAreaId = IFNULL((SELECT _id from blackstarDb.bloomApplicantArea where name = applicantArea), -1);
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
      INSERT INTO blackstarDb.bloomTicket(applicantUserId, officeId, serviceTypeId, statusId, applicantAreaId
                  , dueDate, project, ticketNumber, description, reponseInTime, evaluation, desviation
                  , responseDate, created, createdBy, createdByUsr, modified, modifiedBy, modifiedByUsr) 
             VALUES(applicantUserId, officeL, serviceTypeId, status, applicantAreaId, dueDate, project
                    , ticketNumber, description, bolResponseInTime, CAST(evaluation AS UNSIGNED INTEGER) , desviation, responseDate
                    , STR_TO_DATE(created, '%Y-%m-%d %T'), 'BloomDataLoader', createdByUsrId, null, null, null);
      SET counter = counter + 1;
  END LOOP loop_lbl;

  CLOSE transfer_cursor;    
  
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomUpdateTransferFollow
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDbTransfer.BloomUpdateTransferFollow$$
CREATE PROCEDURE blackstarDbTransfer.BloomUpdateTransferFollow()
BEGIN

  DECLARE counter INTEGER;
  DECLARE ticketId Int(11);
  DECLARE ticket Varchar(20);
  DECLARE createdStr Varchar(100);
  DECLARE comment Text;
  DECLARE done BOOLEAN DEFAULT 0;
 
  DECLARE transfer_cursor CURSOR FOR 
    SELECT * FROM bloomTransferFollow;
    
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;

  SET counter = 0;
  OPEN transfer_cursor;
  loop_lbl: LOOP
      FETCH transfer_cursor INTO ticket, createdStr, comment;
      IF done = 1 THEN 
			   LEAVE loop_lbl;
		  END IF;  
      SET ticketId =(SELECT _id from blackstarDb.bloomTicket where ticketNumber = ticket);
      INSERT INTO blackstarDb.followUp(bloomTicketId,followUp, created, createdBy, createdByUsr) 
             VALUES(ticketId, comment, STR_TO_DATE(createdStr, '%y/%m/%d'), 'BloomDataLoader', 'portal-servicios@gposac.com.mx');
      SET counter = counter + 1;
  END LOOP loop_lbl;

  CLOSE transfer_cursor;    
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomUpdateTransferTeam
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDbTransfer.BloomUpdateTransferTeam$$
CREATE PROCEDURE blackstarDbTransfer.BloomUpdateTransferTeam()
BEGIN

  DECLARE counter INTEGER;
  DECLARE ticketId Int(11);
  DECLARE ticket Varchar(20);
  DECLARE userName Varchar(100);
  DECLARE userId Varchar(100);
  DECLARE done BOOLEAN DEFAULT 0;

  DECLARE transfer_cursor CURSOR FOR 
    SELECT * FROM bloomTransferTicketTeam;
    
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;

  SET counter = 0;
  OPEN transfer_cursor;
  loop_lbl: LOOP
      FETCH transfer_cursor INTO ticket, userName;
      IF done = 1 THEN 
			   LEAVE loop_lbl;
		  END IF;
      SET ticketId =(SELECT _id from blackstarDb.bloomTicket where ticketNumber = ticket);
      SET userId = IFNULL((SELECT blackStarUserId from blackstarDb.blackstaruser where name LIKE CONCAT(userName,'%')), -1);
      INSERT INTO blackstarDb.bloomTicketTeam(ticketId,workerRoleTypeId, blackstarUserId, assignedDate) 
             VALUES(ticketId,1, userId, NOW());
      SET counter = counter + 1;
  END LOOP loop_lbl;

  CLOSE transfer_cursor;    
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomUpdateTransferUsers
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDbTransfer.BloomUpdateTransferUsers$$
CREATE PROCEDURE blackstarDbTransfer.BloomUpdateTransferUsers()
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
     SELECT DISTINCT createdByUsr FROM bloomTransferTicket
     WHERE createdByUsr NOT IN (SELECT email FROM blackstarDb.blackstaruser);

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
      INSERT INTO blackstarDb.blackstarUser (email, name) VALUES (bloomCreatedByUsrMail, CONCAT(bloomCreatedByUsrName, ' ', bloomCreatedByUsrLastName));
      SET counter = counter + 1;
  END LOOP fill_users;
  CLOSE user_cursor;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomTransfer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDbTransfer.BloomTransfer$$
CREATE PROCEDURE blackstarDbTransfer.BloomTransfer()
BEGIN
	CALL BloomUpdateTransferUsers();
  	CALL BloomUpdateTickets();
  	CALL BloomUpdateTransferTeam();
  	CALL BloomUpdateTransferFollow();
END$$


DELIMITER ;