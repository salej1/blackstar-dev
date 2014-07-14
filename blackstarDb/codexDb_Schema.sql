-- -----------------------------------------------------------------------------
-- Desc:	Cambia el esquema de la bd
-- Auth:	Daniel Castillo Bermúdez
-- Date:	11/11/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ------------------------------------
-- 1    20/06/2014  DCB  	Version inicial
-- ---------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

CREATE TABLE IF NOT EXISTS blackstarDb.location(
  _id Int(6) NOT NULL AUTO_INCREMENT,
  zipCode Varchar(5) NOT NULL,
  country Text NOT NULL,
  state Text NOT NULL,
  municipality Text NOT NULL,
  city Text ,
  neighborhood Text NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexClientType(
  _id Int(2) NOT NULL AUTO_INCREMENT,
  name Varchar(40) NOT NULL,
  description Varchar(100) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexClientOrigin(
  _id Int(2) NOT NULL AUTO_INCREMENT,
  name Varchar(40) NOT NULL,
  description Varchar(100) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexClient(
  _id Int(11) NOT NULL AUTO_INCREMENT,
  clientTypeId Int(2),
  clientOriginId Int(2),
  sellerId Int(11),
  isProspect Tinyint,
  rfc Varchar(13),
  corporateName Text,
  tradeName Text,
  phoneArea Varchar(3),
  phoneNumber Varchar(10),
  phoneExtension Varchar(6),
  phoneAreaAlt Varchar(3),
  phoneNumberAlt Varchar(10),
  phoneExtensionAlt Varchar(6),
  email Varchar(60),
  emailAlt Varchar(60),
  street Text,
  intNumber Varchar(5),
  extNumber Varchar(5),
  zipCode Int(5),
  country Text,
  state Varchar(20),
  municipality Text,
  city Text,
  neighborhood Text,
  contactName Text,
  curp Varchar(18),
  retention Varchar(20),
  PRIMARY KEY (_id),
  FOREIGN KEY (clientTypeId) REFERENCES codexClientType (_id),
  FOREIGN KEY (clientOriginId) REFERENCES codexClientOrigin (_id),
  FOREIGN KEY (sellerId) REFERENCES blackstaruser (blackstarUserId)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexStatusType( 
  _id Int(1) NOT NULL AUTO_INCREMENT,
  name Varchar(40) NOT NULL,
  description Varchar(60) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexPaymentType(
  _id Int(1) NOT NULL AUTO_INCREMENT,
  name Varchar(40) NOT NULL,
  description Varchar(60) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexCurrencyType(
  _id Int(2) NOT NULL AUTO_INCREMENT,
  name Varchar(40) NOT NULL,
  description Varchar(40) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexTaxesTypes(
  _id Int(1) NOT NULL AUTO_INCREMENT,
  name Varchar(40) NOT NULL,
  description Varchar(60) NOT NULL,
  value Float(2,2) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexProject(
  _id Int(11) NOT NULL AUTO_INCREMENT,
  clientId Int(11) NOT NULL,
  taxesTypeId Int(1) NOT NULL,
  statusId Int(1) NOT NULL,
  paymentTypeId Int(1) NOT NULL,
  currencyTypeId Int(2) NOT NULL,
  projectNumber Varchar(8) NOT NULL,
  costCenter Varchar(8) NOT NULL,
  changeType Float(2,2) NOT NULL,
  created Varchar(20) NOT NULL,
  contactName Text NOT NULL,
  location Varchar(20),
  advance Float(7,2),
  timeLimit Int(3),
  settlementTimeLimit Int(3),
  deliveryTime Int(3),
  intercom Varchar(5),
  productsNumber Int(7),
  financesNumber Int(7),
  servicesNumber Int(7),
  totalProjectNumber Int(8),
  PRIMARY KEY (_id),
  FOREIGN KEY (statusId) REFERENCES codexStatusType (_id),
  FOREIGN KEY (paymentTypeId) REFERENCES codexPaymentType (_id),
  FOREIGN KEY (currencyTypeId) REFERENCES codexCurrencyType (_id),
  FOREIGN KEY (taxesTypeId) REFERENCES codexTaxesTypes (_id),
  FOREIGN KEY (clientId) REFERENCES codexClient (_id)
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS blackstarDb.codexProjectEntryTypes(
  _id Int(2) NOT NULL AUTO_INCREMENT,
  name Varchar(40) NOT NULL,
  description Varchar(60) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexProjectEntry(
  _id Int(11) NOT NULL AUTO_INCREMENT,
  projectId Int(11) NOT NULL,
  entryTypeId Int(2) NOT NULL,
  description Text NOT NULL,
  discount Float(6,2) NOT NULL,
  totalPrice Float(9,2) NOT NULL,
  comments Text NOT NULL,
  PRIMARY KEY (_id),
  FOREIGN KEY (projectId) REFERENCES codexProject (_id),
  FOREIGN KEY (entryTypeId) REFERENCES codexProjectEntryTypes (_id)
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS blackstarDb.codexProjectItemTypes(
  _id Int(2) NOT NULL AUTO_INCREMENT,
  name Varchar(40) NOT NULL,
  description Varchar(60) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexEntryItem(
  _id Int(11) NOT NULL AUTO_INCREMENT,
  entryId Int(11) NOT NULL,
  itemTypeId Int(2) NOT NULL,
  reference Text ,
  description Text NOT NULL,
  quantity Int(7) NOT NULL,
  priceByUnit Float(8,2) NOT NULL,
  discount Float(6,2) NOT NULL,
  totalPrice Float(10,2) NOT NULL,
  comments Text,
  PRIMARY KEY (_id),
  FOREIGN KEY (entryId) REFERENCES codexProjectEntry (_id),
  FOREIGN KEY (itemTypeId) REFERENCES codexProjectItemTypes (_id)
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS blackstarDb.codexPriceList(
  _id Int(3) NOT NULL AUTO_INCREMENT,
  name Varchar(40) NOT NULL,
  description Varchar(60) NOT NULL,
  price Float(7,2) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.workerRoleType(
   _id Int(11) NOT NULL AUTO_INCREMENT,
   name Varchar(150) NOT NULL,
   description Varchar(400) NOT NULL,
   PRIMARY KEY (_id),
   UNIQUE UQ_bloomWorkerRoleType(name)
)ENGINE=INNODB;

CREATE TABLE blackstarDb.workTeam(
  _id Int(11) NOT NULL AUTO_INCREMENT,
  ticketId Int(11),
  codexProjectId Int(11),
  workerRoleTypeId Int(11) NOT NULL,
  blackstarUserId Int(11) NOT NULL,
	assignedDate Datetime NOT NULL,
  PRIMARY KEY (`_id`),
	FOREIGN KEY (ticketId) REFERENCES bloomTicket (_id),
  FOREIGN KEY (workerRoleTypeId) REFERENCES bloomWorkerRoleType (_id),
  FOREIGN KEY (blackstarUserId) REFERENCES blackstarUser (blackstarUserId)
)ENGINE=INNODB;
		 
CREATE TABLE blackstarDb.codexDeliverableType(
    _id Int(11) NOT NULL AUTO_INCREMENT,
    name Varchar(150) NOT NULL,
    description Varchar(400) NOT NULL,
    PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE blackstarDb.codexDeliverableTrace(
    _id Int(11) NOT NULL AUTO_INCREMENT,
	codexProjectId Int(11) NOT NULL,
    deliverableTypeId Int(11) NOT NULL,
	created Date NOT NULL,
	userId Int(11) NOT NULL,
	PRIMARY KEY (_id),
    FOREIGN KEY (deliverableTypeId) REFERENCES codexDeliverableType (_id),
	FOREIGN KEY (codexProjectId) REFERENCES codexProject (_id)
)ENGINE=INNODB;
		 
		 
ALTER TABLE blackstarDb.followUp ADD codexProjectId Int(11);
ALTER TABLE blackstarDb.followUp ADD CONSTRAINT R121 FOREIGN KEY (codexProjectId) REFERENCES codexProject (_id);
ALTER TABLE blackstarDb.workTeam ADD CONSTRAINT R122 FOREIGN KEY (codexProjectId) REFERENCES codexProject (_id);
		 
-- -----------------------------------------------------------------------------
-- FIN SECCION DE CAMBIOS - NO CAMBIAR CODIGO FUERA DE ESTA SECCION
-- -----------------------------------------------------------------------------

END$$

DELIMITER ;
