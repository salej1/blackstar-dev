-- TICKET DELETE TEMPLATE
DELIMITER $$
DROP PROCEDURE IF EXISTS blackstarDb.DeleteTicket$$
CREATE PROCEDURE blackstarDb.DeleteTicket()
BEGIN
	SET @ticketNumber = '14-244';
	SET @ticketId = (SELECT ticketId FROM blackstarDb.ticket WHERE ticketNumber = @ticketNumber);

	-- ServiceOrder
	IF(SELECT count(*) FROM blackstarDb.serviceOrder WHERE ticketId = @ticketId) > 0 THEN
		SELECT 'No se puede eliminar el ticket, ya ha sido usado en una OS';
	ELSE
		SELECT 'Eliminando...';
		DELETE FROM blackstarDbTransfer.ticket WHERE ticketNumber = @ticketNumber;
		DELETE FROM blackstarDb.ticket WHERE ticketId = @ticketId;
	END IF;
END$$

CALL blackstarDb.DeleteTicket()$$

DROP PROCEDURE blackstarDb.DeleteTicket$$

DELIMITER ;