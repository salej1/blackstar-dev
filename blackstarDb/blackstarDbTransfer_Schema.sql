-- ---------------------------------------------------------------------------
-- File:	blackstarDbTransfer_Schema.sql    
-- Name:	blackstarDbTransfer_Schema
-- Desc:	Implementa cambios en el esquema de la BD blackstarDbTransfer
-- Auth:	Sergio A Gomez
-- Date:	20/12/2013
-- ---------------------------------------------------------------------------
-- Change History
-- ---------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- ---------------------------------------------------------------------------
-- 1    08/08/2013  SAG  	Se aumenta el tamaño de ticket.serialNumber
-- ---------------------------------------------------------------------------
-- 2    04/03/2014  SAG  	Se agregan columnas de portal
-- ---------------------------------------------------------------------------
-- 3    19/03/2014  SAG  	Se agrega tabla equipmentUserSync
-- ---------------------------------------------------------------------------
-- 4	01/04/2014	SAG		Se agrega processed a ticket 
-- ---------------------------------------------------------------------------
-- 5 	03/04/2014	SAG 	Se incrementa tamaño de campos de contacto
-- ---------------------------------------------------------------------------
-- 6 	10/04/2014	SAG 	Se incrementa tamaño de numero de serie
--							Se incrementa tamaño de finalUser
-- ---------------------------------------------------------------------------
-- 7	26/02/2014	SAG 	Se incremeta tamaño de numero de serie (serviceTx)
-- ---------------------------------------------------------------------------
-- 8	28/05/2014	SAG 	Se incremeta tamaño de customer (serviceTx)
-- ---------------------------------------------------------------------------
-- 9	23/06/2014	SAG		Se agregan campos de detalle del equipo a serviceTx
-- ---------------------------------------------------------------------------
-- 10	30/06/2014	SAG		Se incrementa tamaño de equipmentUser y contact en policy
-- ---------------------------------------------------------------------------
-- 11 	22/09/2014	SAG 	Se agrega tabla de transferencia bloom ticket
-- ---------------------------------------------------------------------------
-- 12 	28/01/2014	SAG 	Se aumenta capacidad de brand en policy
-- ---------------------------------------------------------------------------


USE blackstarDbTransfer;


DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDbTransfer.upgradeSchema$$
CREATE PROCEDURE blackstarDbTransfer.upgradeSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

	-- Aumentando capacidad de brand a 200
	ALTER TABLE policy MODIFY brand VARCHAR(200);

	-- Agregando bloomTicket
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'bloomTicket') = 0 THEN
		CREATE TABLE blackstarDbTransfer.bloomTicket(
			bloomTicketId INT AUTO_INCREMENT,
			created DATETIME,
			createdByUsr VARCHAR(100),
			ticketType INT,
			dueDate DATETIME,
			description VARCHAR(4000),
			project VARCHAR(100),
			office VARCHAR(100),
			ticketNumber VARCHAR(100),
			followUp VARCHAR(2000),
			responseTime DATETIME,
			resolved INT,
			status INT(1),
			processed INT,
			KEY(bloomTicketId)
		)ENGINE=INNODB;
	END IF;

	-- Aumentando capacidad de description
	ALTER TABLE bloomTicket MODIFY description VARCHAR(4000);

	-- Aumentando capacidad de equipmentUser de policy
	ALTER TABLE policy MODIFY equipmentUser VARCHAR(400);
	ALTER TABLE policy MODIFY contact VARCHAR(200);

	-- Agregando detalle del equipo a serviceTx
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'serviceTx' AND COLUMN_NAME = 'equipmentTypeId') = 0  THEN
		ALTER TABLE serviceTx ADD equipmentTypeId CHAR(1);
	END IF;
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'serviceTx' AND COLUMN_NAME = 'brand') = 0  THEN
		ALTER TABLE serviceTx ADD brand VARCHAR(100);
	END IF;
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'serviceTx' AND COLUMN_NAME = 'model') = 0  THEN
		ALTER TABLE serviceTx ADD model VARCHAR(100);
	END IF;
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'serviceTx' AND COLUMN_NAME = 'capacity') = 0  THEN
		ALTER TABLE serviceTx ADD capacity VARCHAR(100);
	END IF;
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'serviceTx' AND COLUMN_NAME = 'employeeId') = 0  THEN
		ALTER TABLE serviceTx ADD employeeId VARCHAR(400);
	END IF;

	-- Aumentando capacidad de campos de serviceTx
	ALTER TABLE serviceTx MODIFY customer VARCHAR(200);

	-- Aumentando capacidad de campos de serviceTx
	ALTER TABLE serviceTx MODIFY serialNumber VARCHAR(200);

	-- Aumentando capacidad de campos de policy
	ALTER TABLE policy MODIFY serialNumber VARCHAR(200);
	ALTER TABLE policy MODIFY finalUser VARCHAR(200);

	-- Aumentando capacidad de campos de contacto
	ALTER TABLE ticket MODIFY contact VARCHAR(200);
	ALTER TABLE ticket MODIFY contactPhone VARCHAR(200);
	ALTER TABLE ticket MODIFY contactEmail VARCHAR(200);
	
	-- Agregando ticket.processed
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'ticket' AND COLUMN_NAME = 'processed') = 0  THEN
		ALTER TABLE blackstarDbTransfer.ticket ADD processed INT NULL DEFAULT 1;
	END IF;

	-- Agregando equipmentUserSync
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'equipmentUserSync') = 0 THEN
		 CREATE TABLE blackstarDbTransfer.equipmentUserSync(
			equipmentUserSyncId INTEGER NOT NULL AUTO_INCREMENT,
			customerName VARCHAR(500),
			equipmentUser VARCHAR(100) NULL,
			KEY(equipmentUserSyncId)
		) ENGINE=INNODB;

	END IF;

	ALTER TABLE blackstarDbTransfer.ticket MODIFY serialNumber VARCHAR(100) NULL DEFAULT NULL;

	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'policy' AND COLUMN_NAME = 'equipmentUser') = 0  THEN
		ALTER TABLE blackstarDbTransfer.policy ADD equipmentUser VARCHAR(100) NULL DEFAULT NULL;
	END IF;

	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDbTransfer' AND TABLE_NAME = 'ticket' AND COLUMN_NAME = 'project') = 0  THEN
		ALTER TABLE blackstarDbTransfer.ticket ADD project  VARCHAR(100) NULL DEFAULT NULL;
	END IF;


-- -----------------------------------------------------------------------------
-- FIN SECCION DE CAMBIOS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDbTransfer.upgradeSchema();

DROP PROCEDURE blackstarDbTransfer.upgradeSchema;