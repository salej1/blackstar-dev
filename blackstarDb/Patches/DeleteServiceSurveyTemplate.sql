USE blackstarDb;

-- SERVICE SURVEY DELETE TEMPLATE
DELIMITER $$
DROP PROCEDURE IF EXISTS blackstarDb.DeleteServiceSurvey$$
CREATE PROCEDURE blackstarDb.DeleteServiceSurvey()
BEGIN
	
	-- Tabla temporal de Ids
	CREATE TEMPORARY TABLE deletingSurveyIds(surveyId INT);

	-- Obteniendo los ids de encuestas
	INSERT INTO deletingSurveyIds(surveyId)
	SELECT surveyServiceId FROM blackstarDb.serviceOrder WHERE serviceOrderNumber IN(
		'OS-05481','AA-0372','OS-2127','UPS-0703','AA-0372','OS-2127','OS-05481'
	);

	-- Desasociando encuestas
	UPDATE blackstarDb.serviceOrder SET
		surveyServiceId = NULL,
		surveyScore = NULL,
		modified = CONVERT_TZ(now(),'+00:00','-5:00'),
		modifiedBy = 'DeleteServiceSurvey'
	WHERE surveyServiceId IN(
		SELECT surveyId FROM deletingSurveyIds
	);
	
	-- Borrando las encuestas
	DELETE FROM blackstarDb.surveyService WHERE surveyServiceId IN(
		SELECT surveyId FROM deletingSurveyIds
	);

	-- Borrando tabla temporal
	DROP TABLE deletingSurveyIds;

END$$

CALL blackstarDb.DeleteServiceSurvey$$

DROP PROCEDURE IF EXISTS blackstarDb.DeleteServiceSurvey$$

DELIMITER ;

