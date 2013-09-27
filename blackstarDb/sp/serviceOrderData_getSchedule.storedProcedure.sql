-- -----------------------------------------------------------------------------
-- File:    serviceOrderData_getSchedule.storedProcedure.sql
-- Name:	serviceOrderData_getSchedule
-- Desc:	Regresa el calendario de ordenes de servicio a partir del dia de hoy
-- Auth:	SAG
-- Date:
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date	    Author  Description	
-- --   --------   -------   ------------------------------------
-- 1    2013-09-26	SAG      Version Inicial
-- -----------------------------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE serviceOrderData_getSchedule()
BEGIN
	
	SELECT serviceOrderId, effectiveDate, equipmentType, po.customer, serialNumber, responsible, additionalEmployees
	FROM serviceOrder so
		INNER JOIN policy po ON so.policyId = po.policyId
		INNER JOIN equipmentType et ON et.equipmentTypeId = po.equipmentTypeId
	WHERE 
		effectiveDate >= CURRENT_DATE();
END$$

DELIMITER ;