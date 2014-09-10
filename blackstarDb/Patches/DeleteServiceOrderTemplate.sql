-- SERVICE ORDER DELETE TEMPLATE
DELIMITER $$
DROP PROCEDURE IF EXISTS blackstarDb.DeleteServiceOrder$$
CREATE PROCEDURE blackstarDb.DeleteServiceOrder()
BEGIN
	SELECT @pServiceOrderNumber:= 'UPS-00061-e';
	SELECT @id:= serviceOrderId FROM blackstarDb.serviceOrder WHERE serviceOrderNumber = @pServiceOrderNumber;

	IF(@id IS NOT NULL) THEN
		-- ticket
		UPDATE blackstarDb.ticket SET 
			serviceOrderNumber = NULL, 
			modified = now(), 
			modifiedBy = 'DeleteServiceOrder'
		WHERE serviceOrderNumber = @pServiceOrderNumber;

		-- serviceOrderEmployee
		DELETE FROM blackstarDb.serviceOrderEmployee WHERE serviceOrderId = @id;

		-- aa
		IF left(@pServiceOrderNumber, 2) = 'AA' THEN
			DELETE FROM blackstarDb.aaService WHERE serviceOrderId = @id;
		END IF;

		-- bb
		IF left(@pServiceOrderNumber, 2) = 'BB' THEN
			SELECT @bbId:= bbServiceId FROM blackstarDb.bbService WHERE serviceOrderId = @id;

			DELETE FROM blackstarDb.bbCellService WHERE bbServiceId = @bbId;
			DELETE FROM blackstarDb.bbService WHERE bbServiceId = @bbId;
		END IF;

		-- ep
		IF left(@pServiceOrderNumber, 2) = 'PE' THEN
			SELECT @peId:= epServiceId FROM blackstarDb.epService WHERE serviceOrderId = @id;

			DELETE FROM blackstarDb.epServiceDynamicTest WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epServiceLectures WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epServiceParams WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epServiceSurvey WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epServiceTestProtection WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epServiceTransferSwitch WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epServiceWorkBasic WHERE epServiceId = @peId;
			DELETE FROM blackstarDb.epService WHERE epServiceId = @peId;
		END IF;

		-- ups
		IF left(@pServiceOrderNumber, 3) = 'UPS' THEN
			SELECT @upsId:= upsServiceId FROM blackstarDb.upsService WHERE serviceOrderId = @id;

			DELETE FROM blackstarDb.upsServiceBatteryBank WHERE upsServiceId = @upsId;
			DELETE FROM blackstarDb.upsServiceGeneralTest WHERE upsServiceId = @upsId;
			DELETE FROM blackstarDb.upsServiceParams WHERE upsServiceId = @upsId;
			DELETE FROM blackstarDb.upsService WHERE upsServiceId = @upsId;
		END IF;

		-- serviceOrder
		DELETE FROM blackstarDb.serviceOrder WHERE serviceOrderId = @id;
	END IF;
	
END$$

CALL blackstarDb.DeleteServiceOrder$$

DROP PROCEDURE IF EXISTS blackstarDb.DeleteServiceOrder$$

DELIMITER ;

