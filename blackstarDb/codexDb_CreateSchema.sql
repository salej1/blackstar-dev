-- -----------------------------------------------------------------------------
-- Desc:	Cambia el esquema de la bd
-- Auth:	Daniel Castillo Bermúdez
-- Date:	11/11/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author   	Description
-- --   --------   -------  ------------------------------------
-- 1    20/06/2014  DCB   	Version inicial
-- --   --------   -------  ------------------------------------
-- 2    13/08/2014  SAG     Se agrega blackstarDb.cstOffice
-- --   --------   -------  ------------------------------------
-- 3    01/10/2014  SAG     Se agrega blackstarDb.codexIncoterm
-- ---------------------------------------------------------------------------

USE blackstarDb;

DELIMITER ;

CREATE TABLE IF NOT EXISTS blackstarDb.location(
  _id INT NOT NULL AUTO_INCREMENT,
  zipCode VARCHAR(20) NOT NULL,
  country TEXT NOT NULL,
  state TEXT NOT NULL,
  municipality TEXT NOT NULL,
  city TEXT,
  neighborhood TEXT NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexClientType(
  _id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexClientOrigin(
  _id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexClient(
  _id INT NOT NULL AUTO_INCREMENT,
  clientTypeId INT,
  clientOriginId INT,
  sellerId INT(100),
  sellerName VARCHAR(200),
  isProspect Tinyint,
  rfc VARCHAR(100),
  corporateName TEXT,
  tradeName TEXT,
  phoneArea VARCHAR(50),
  phoneNumber VARCHAR(100),
  phoneExtension VARCHAR(50),
  phoneAreaAlt VARCHAR(50),
  phoneNumberAlt VARCHAR(50),
  phoneExtensionAlt VARCHAR(50),
  email VARCHAR(200),
  emailAlt VARCHAR(200),
  street TEXT,
  intNumber VARCHAR(100),
  extNumber VARCHAR(100),
  zipCode INT(100),
  country TEXT,
  state VARCHAR(100),
  municipality TEXT,
  city TEXT,
  neighborhood TEXT,
  contactName TEXT,
  curp VARCHAR(100),
  retention VARCHAR(100),
  PRIMARY KEY (_id),
  FOREIGN KEY (clientTypeId) REFERENCES codexClientType (_id),
  FOREIGN KEY (clientOriginId) REFERENCES codexClientOrigin (_id),
  FOREIGN KEY (sellerId) REFERENCES blackstarUser (blackstarUserId)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexStatusType( 
  _id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexPaymentType(
  _id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexCurrencyType(
  _id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexTaxesTypes(
  _id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  value DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexCostCenter(
  _id INT NOT NULL AUTO_INCREMENT,
  costCenter VARCHAR(200),
  created DATETIME NULL,
  createdBy NVARCHAR(100) NULL,
  createdByUsr INT NULL,
  modified DATETIME NULL,
  modifiedBy NVARCHAR(100) NULL,
  modifiedByUsr INT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexProject(
  _id INT NOT NULL AUTO_INCREMENT,
  clientId INT NOT NULL,
  taxesTypeId INT NOT NULL,
  statusId INT NOT NULL,
  paymentTypeId INT NOT NULL,
  currencyTypeId INT NOT NULL,
  projectNumber VARCHAR(100) NOT NULL,
  costCenterId INT NOT NULL,
  changeType Float NOT NULL,
  contactName TEXT NOT NULL,
  location VARCHAR(400),
  advance Float(7,2),
  timeLimit INT,
  settlementTimeLimit INT,
  deliveryTime INT,
  incoterm VARCHAR(50),
  productsNumber FLOAT(15,2),
  financesNumber FLOAT(15,2),
  servicesNumber FLOAT(15,2),
  totalProjectNumber FLOAT(15,2),
  created DATETIME NULL,
  createdBy NVARCHAR(100) NULL,
  createdByUsr INT NULL,
  modified DATETIME NULL,
  modifiedBy NVARCHAR(100) NULL,
  modifiedByUsr INT NULL,
  PRIMARY KEY (_id),
  FOREIGN KEY (statusId) REFERENCES codexStatusType (_id),
  FOREIGN KEY (paymentTypeId) REFERENCES codexPaymentType (_id),
  FOREIGN KEY (currencyTypeId) REFERENCES codexCurrencyType (_id),
  FOREIGN KEY (taxesTypeId) REFERENCES codexTaxesTypes (_id),
  FOREIGN KEY (clientId) REFERENCES codexClient (_id),
  FOREIGN KEY (createdByUsr) REFERENCES blackstarUser (blackstarUserId),
  FOREIGN KEY (modifiedByUsr) REFERENCES blackstarUser (blackstarUserId),
  FOREIGN KEY (costCenterId) REFERENCES codexCostCenter (_id)
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS blackstarDb.codexProjectEntryTypes(
  _id INT NOT NULL,
  name VARCHAR(200) NOT NULL,
  productType CHAR(1) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexProjectEntry(
  _id INT NOT NULL AUTO_INCREMENT,
  projectId INT NOT NULL,
  entryTypeId INT NOT NULL,
  description TEXT NOT NULL,
  discount FLOAT(15,2) NOT NULL,
  totalPrice FLOAT(15,2) NOT NULL,
  comments TEXT NOT NULL,
  PRIMARY KEY (_id),
  FOREIGN KEY (projectId) REFERENCES codexProject (_id),
  FOREIGN KEY (entryTypeId) REFERENCES codexProjectEntryTypes (_id)
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS blackstarDb.codexProjectItemTypes(
  _id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(200) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexEntryItem(
  _id INT NOT NULL AUTO_INCREMENT,
  entryId INT NOT NULL,
  itemTypeId INT NOT NULL,
  reference TEXT ,
  description TEXT NOT NULL,
  quantity INT NOT NULL,
  priceByUnit FLOAT(15,2) NOT NULL,
  discount FLOAT(15,2) NOT NULL,
  totalPrice FLOAT(15,2) NOT NULL,
  comments TEXT,
  PRIMARY KEY (_id),
  FOREIGN KEY (entryId) REFERENCES codexProjectEntry (_id),
  FOREIGN KEY (itemTypeId) REFERENCES codexProjectItemTypes (_id)
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS blackstarDb.codexPriceList(
  _id INT NOT NULL AUTO_INCREMENT,
  code VARCHAR(200) NOT NULL,
  name VARCHAR(400) NOT NULL,
  price FLOAT(15,2) NOT NULL,
  PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.workTeam(
  _id INT NOT NULL AUTO_INCREMENT,
  ticketId INT,
  codexProjectId INT,
  workerRoleTypeId INT NOT NULL,
  blackstarUserId INT NOT NULL,
	assignedDate Datetime NOT NULL,
  PRIMARY KEY (`_id`),
  -- FOREIGN KEY (ticketId) REFERENCES bloomTicket (_id),
  -- FOREIGN KEY (workerRoleTypeId) REFERENCES bloomWorkerRoleType (_id),
  FOREIGN KEY (blackstarUserId) REFERENCES blackstarUser (blackstarUserId),
  FOREIGN KEY (codexProjectId) REFERENCES codexProject (_id)
)ENGINE=INNODB;
		 
CREATE TABLE IF NOT EXISTS blackstarDb.codexDeliverableType(
    _id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(400) NOT NULL,
    PRIMARY KEY (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexDeliverableTrace(
    _id INT NOT NULL AUTO_INCREMENT,
	codexProjectId INT NOT NULL,
    deliverableTypeId INT NOT NULL,
	created Date NOT NULL,
	userId INT NOT NULL,
	PRIMARY KEY (_id),
    FOREIGN KEY (deliverableTypeId) REFERENCES codexDeliverableType (_id),
	FOREIGN KEY (codexProjectId) REFERENCES codexProject (_id)
)ENGINE=INNODB;
		 
CREATE TABLE IF NOT EXISTS blackstarDb.codexPriceProposal(
  _id INT NOT NULL AUTO_INCREMENT,
  projectId INT NOT NULL,
  priceProposalNumber VARCHAR(11) NOT NULL,
  clientId INT NOT NULL,
  taxesTypeId INT NOT NULL,
  paymentTypeId INT NOT NULL,
  currencyTypeId INT NOT NULL,
  costCenter VARCHAR(50) NOT NULL,
  changeType Float NOT NULL,
  contactName TEXT NOT NULL,
  location VARCHAR(400) NOT NULL,
  advance FLOAT(15,2) NOT NULL,
  timeLimit INT NOT NULL,
  settlementTimeLimit INT NOT NULL,
  deliveryTime INT NOT NULL,
  incoterm VARCHAR(5) NOT NULL,
  productsNumber FLOAT(15,2) NOT NULL,
  financesNumber FLOAT(15,2) NOT NULL,
  servicesNumber FLOAT(15,2) NOT NULL,
  totalProjectNumber FLOAT(15,2) NOT NULL,
  created DATETIME NOT NULL,
  PRIMARY KEY (_id),
  FOREIGN KEY (projectId) REFERENCES codexProject (_id),
  FOREIGN KEY (paymentTypeId) REFERENCES codexPaymentType (_id),
  FOREIGN KEY (currencyTypeId) REFERENCES codexCurrencyType (_id),
  FOREIGN KEY (taxesTypeId) REFERENCES codexTaxesTypes (_id),
  FOREIGN KEY (clientId) REFERENCES codexClient (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexPriceProposalEntry(
  _id INT NOT NULL AUTO_INCREMENT,
  priceProposalId INT NOT NULL,
  entryTypeId INT NOT NULL,
  description TEXT NOT NULL,
  discount FLOAT(15,2) NOT NULL,
  totalPrice FLOAT(15,2) NOT NULL,
  comments TEXT NOT NULL,
  PRIMARY KEY (_id),
  FOREIGN KEY (priceProposalId) REFERENCES codexPriceProposal (_id),
  FOREIGN KEY (entryTypeId) REFERENCES codexProjectEntryTypes (_id)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS blackstarDb.codexPriceProposalItem(
  _id INT NOT NULL AUTO_INCREMENT,
  priceProposalEntryId INT NOT NULL,
  itemTypeId INT NOT NULL,
  reference TEXT ,
  description TEXT NOT NULL,
  quantity INT NOT NULL,
  priceByUnit FLOAT(15,2) NOT NULL,
  discount FLOAT(15,2) NOT NULL,
  totalPrice FLOAT(15,2) NOT NULL,
  comments TEXT,
  PRIMARY KEY (_id),
  FOREIGN KEY (priceProposalEntryId) REFERENCES codexPriceProposalEntry (_id),
  FOREIGN KEY (itemTypeId) REFERENCES codexProjectItemTypes (_id)
)ENGINE=INNODB;		 

CREATE TABLE IF NOT EXISTS blackstarDb.cstOffice(
  _id INT NOT NULL AUTO_INCREMENT,
  cstId VARCHAR(200) NOT NULL,
  officeId CHAR(1) NOT NULL,
  PRIMARY KEY (_id),
  UNIQUE (cstId)
  -- FOREIGN KEY (officeId) REFERENCES office (officeId)
)ENGINE=INNODB;

