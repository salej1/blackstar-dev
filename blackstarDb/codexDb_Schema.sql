-- ---------------------------------------------------------------------------
-- Desc:	Cambia el esquema de la bd
-- Auth:	Daniel Castillo Bermúdez
-- Date:	11/11/2013
-- ---------------------------------------------------------------------------
-- Change History
-- ---------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- ---------------------------------------------------------------------------
-- 1    20/06/2014  DCB  	Version inicial
-- ---------------------------------------------------------------------------
-- 2    13/08/2014  SAG  	Separacion CreateSchema y Schema
-- ---------------------------------------------------------------------------
-- 3	21/10/2014	SAG 	Se agrega tabla codexProductFamily
--							Se agrega codexProductFamilyId a codexPriceList
--							Se agrega discountNumber a codexProject
--							Se agrega codexVisit
--							Se agrega codexVisitStatus
-- ---------------------------------------------------------------------------
-- 4	28/10/2014 SAG 		Se agrega yearQuota a cst
--							Se agrega turnedCustomerDate a codexClient
--							Se agrega priceListId a codexEntryItem
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.upgradeCodexSchema$$
CREATE PROCEDURE blackstarDb.upgradeCodexSchema()
BEGIN

-- -----------------------------------------------------------------------------
-- INICIO SECCION DE CAMBIOS
-- -----------------------------------------------------------------------------

-- AGREGANDO priceListId a codexEntryItem
IF(SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexEntryItem' AND COLUMN_NAME = 'priceListId') = 0 THEN
	ALTER TABLE blackstarDb.codexEntryItem ADD priceListId INT NULL;
	ALTER TABLE blackstarDb.codexEntryItem ADD CONSTRAINT FK_codexEntyItem_priceList FOREIGN KEY (priceListId) REFERENCES codexPriceList(_id);
END IF;

-- AGREGANDO turnedCustomerDate a codexClient
IF(SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexClient' AND COLUMN_NAME = 'turnedCustomerDate') = 0 THEN
	ALTER TABLE blackstarDb.codexClient ADD turnedCustomerDate DATETIME NULL;
END IF;

-- AGREGANDO yearQuota a cst
IF(SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'cst' AND COLUMN_NAME = 'yearQuota') = 0 THEN
	ALTER TABLE blackstarDb.cst ADD yearQuota INT NOT NULL DEFAULT 0;
END IF;

-- AGREGANDO TABLA codexVisitStatus
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexVisitStatus') = 0 THEN
		CREATE TABLE blackstarDb.codexVisitStatus(
			visitStatusId CHAR(1),
			visitStatus VARCHAR(100),
			PRIMARY KEY(visitStatusId)
		)ENGINE=INNODB;
	END IF;

-- AGREGANDO TABLA codexVisit
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexVisit') = 0 THEN
		CREATE TABLE blackstarDb.codexVisit(
			codexVisitId INTEGER NOT NULL AUTO_INCREMENT,
			cstId INT,
			codexClientId INT NULL,
			customerName VARCHAR(400),
			visitDate DATETIME,
			description TEXT,
			visitStatusId CHAR(1),
			closure TEXT,
			created DATETIME NULL,
			createdBy VARCHAR(100) NULL,
			createdByUsr VARCHAR(100) NULL,
			modified DATETIME NULL,
			modifiedBy VARCHAR(100) NULL,
			modifiedByUsr VARCHAR(100) NULL,
			PRIMARY KEY (codexVisitId)
		) ENGINE=INNODB;

		ALTER TABLE codexVisit ADD CONSTRAINT FK_codexVisit_cst FOREIGN KEY(cstId) REFERENCES cst(cstId);
		ALTER TABLE codexVisit ADD CONSTRAINT FK_codexVisit_codexClient FOREIGN KEY(codexClientId) REFERENCES codexClient(_id);
		ALTER TABLE codexVisit ADD CONSTRAINT FK_codexVisit_codexVisitStatus FOREIGN KEY(visitStatusId) REFERENCES codexVisitStatus(visitStatusId);
	END IF;

-- AGREGANDO COLUMNA discountNumber a codexProject
  IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexProject' AND COLUMN_NAME = 'discountNumber') = 0  THEN
    ALTER TABLE blackstarDb.codexProject ADD discountNumber FLOAT(15,2) NULL;
  END IF;    

-- AGREGANDO TABLA codexProductFamily
	IF(SELECT count(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexProductFamily') = 0 THEN
		CREATE TABLE blackstarDb.codexProductFamily(
			codexProductFamilyId INTEGER NOT NULL AUTO_INCREMENT,
			productFamily VARCHAR(100),
			PRIMARY KEY (codexProductFamilyId)
		) ENGINE=INNODB;
	END IF;

-- AGREGANDO COLUMNA codexProductFamilyId a codexPriceList
	IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'codexPriceList' AND COLUMN_NAME = 'codexProductFamilyId') = 0  THEN
		ALTER TABLE codexPriceList ADD codexProductFamilyId INT NOT NULL;

		ALTER TABLE blackstarDb.codexPriceList ADD CONSTRAINT FK_codexPriceList_codexProductFamily
		FOREIGN KEY (codexProductFamilyId) REFERENCES codexProductFamily (codexProductFamilyId);
	END IF;

-- AGREGANDO COLUMNA codexProjectId a followUp
  IF (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'blackstarDb' AND TABLE_NAME = 'followUp' AND COLUMN_NAME = 'codexProjectId') = 0  THEN
    ALTER TABLE blackstarDb.followUp ADD codexProjectId INT(11) NULL;
    ALTER TABLE blackstarDb.followUp ADD CONSTRAINT R121 FOREIGN KEY (codexProjectId) REFERENCES codexProject (_id);
  END IF;     

-- -----------------------------------------------------------------------------
-- FIN SECCION DE CAMBIOS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;

CALL blackstarDb.upgradeCodexSchema();

DROP PROCEDURE blackstarDb.upgradeCodexSchema;