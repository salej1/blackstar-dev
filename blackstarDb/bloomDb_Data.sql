-- -----------------------------------------------------------------------------
-- Desc:Carga de datos inicial
-- Auth:OSCAR MARTINEZ
-- Date:20/03/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    AuthorDescription
-- --   --------   -------  ------------------------------------
-- 1    08/04/2014  DCB  	Version inicial. 
-- ---------------------------------------------------------------------------
use blackstarDb;

-- -----------------------------------------------------------------------------
	-- SECUENCIA
-- -----------------------------------------------------------------------------
--secuencia para tinckets internos
	IF(SELECT COUNT(*) FROM blackstarDb.sequence WHERE sequenceTypeId='I') = 0 THEN
		INSERT INTO blackstarDb.sequence (sequenceTypeId,sequenceNumber) values('I',1);	
	END IF;	


-- -----------------------------------------------------------------------------
	-- PERFIL
-- -----------------------------------------------------------------------------
--Pantalla DashBoard MA
--dara seguimiento a los tickets y los asignara a una area de apoyo..
	IF(SELECT COUNT(*) FROM blackstarDb.usergroup WHERE externalId='sysHelpDesk') = 0 THEN
		INSERT INTO blackstarDb.usergroup (externalId,name) values('sysHelpDesk','Mesa de Ayuda');
	END IF;	
