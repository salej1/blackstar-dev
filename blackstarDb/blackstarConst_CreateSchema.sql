-- -----------------------------------------------------------------------------
-- File:	blackstarConst_CreateSchema.sql    
-- Name:	blackstarConst_CreateSchema
-- Desc:	Crea una version inicial de la base de datos de constatnes
-- Auth:	Sergio A Gomez
-- Date:	20/12/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    20/12/2014  SAG  	Version inicial.
-- ---------------------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS blackstarConst ;

CREATE TABLE IF NOT EXISTS blackstarConst.location(
  _id INT NOT NULL AUTO_INCREMENT,
  zipCode VARCHAR(20) NOT NULL,
  country TEXT NOT NULL,
  state TEXT NOT NULL,
  municipality TEXT NOT NULL,
  city TEXT,
  neighborhood TEXT NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;