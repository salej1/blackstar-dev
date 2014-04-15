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


-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomUpdateTickets
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS blackstarDbTransfer.BloomUpdateTickets$$
CREATE FUNCTION blackstarDbTransfer.`BloomUpdateTickets`() RETURNS int(11)
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
      INSERT INTO blackstarDb.bloomticket(applicantUserId, officeId, serviceTypeId, statusId, applicantAreaId
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
	-- blackstarDbTransfer.BloomUpdateTransferFollow
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS blackstarDbTransfer.BloomUpdateTransferFollow$$
CREATE FUNCTION blackstarDbTransfer.`BloomUpdateTransferFollow`() RETURNS int(11)
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
      INSERT INTO blackstarDb.followUp(bloomTicketId,followup, created, createdBy, createdByUsr) 
             VALUES(ticketId, comment, STR_TO_DATE(createdStr, '%y/%m/%d'), 'BloomDataLoader', 'portal-servicios@gposac.com.mx');
      SET counter = counter + 1;
  END LOOP loop_lbl;

  CLOSE transfer_cursor;    
  RETURN counter;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomUpdateTransferTeam
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS blackstarDbTransfer.BloomUpdateTransferTeam$$
CREATE FUNCTION blackstarDbTransfer.`BloomUpdateTransferTeam`() RETURNS int(11)
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
  RETURN counter;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomUpdateTransferUsers
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS blackstarDbTransfer.BloomUpdateTransferUsers$$
CREATE FUNCTION blackstarDbTransfer.`BloomUpdateTransferUsers`() RETURNS int(11)
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
  RETURN counter;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDbTransfer.BloomTransfer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDbTransfer.BloomTransfer$$
CREATE PROCEDURE blackstarDbTransfer.`BloomTransfer`()
BEGIN

  DECLARE auxInt INTEGER;

  SET auxInt = BloomUpdateTransferUsers();
  SET auxInt = BloomUpdateTickets();
  SET auxInt = BloomUpdateTransferTeam();
  SET auxInt = BloomUpdateTransferFollow();
END$$


DELIMITER ;