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
use blackstarDbTransfer;


DELIMITER $$
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
			INNER JOIN blackstarDb.policy p2 ON p1.serialNumber = p2.serialNumber AND p1.project = p2.project
		WHERE IFNULL(p1.equipmentUser, '') != '';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    TRUNCATE TABLE blackstarDb.policyEquipmentUser;
   
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

          INSERT INTO blackstarDb.policyEquipmentUser(policyId, equipmentUserId) VALUES (id, splitted_value);
          SET i = i + 1;

        END WHILE;
      END LOOP;

    CLOSE cur1;
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
		bp.serviceCenterId = s.serviceCenterId;

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
		followup,
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
		followup,
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
		LEFT OUTER JOIN blackstarDb.blackstarUser u ON p.equipmentUser = u.email
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
	    	Call blackstarDb.UpsertUser(@access, @customer,null);
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
DELIMITER ;