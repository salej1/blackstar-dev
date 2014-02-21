use blackstarDb;

DELIMITER $$

-- -----------------------------------------------------------------------------
-- blackstarDb.AddCustomer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddCustomer$$
CREATE PROCEDURE blackstarDb.AddCustomer(
  customerId int(11),
  rfc varchar(14),
  companyName varchar(60),
  tradeName varchar(40),
  phoneCode1 varchar(3),
  phoneCode2 varchar(3),
  phone1 varchar(7),
  phone2 varchar(7),
  extension1 varchar(6),
  extension2 varchar(6),
  email1 varchar(50),
  email2 varchar(50),
  street varchar(30),
  externalNumber varchar(5),
  internalNumber varchar(3),
  colony varchar(30),
  town varchar(30),
  country varchar(20),
  postcode varchar(5),
  advance double,
  timeLimit varchar(20),
  settlementTimeLimit varchar(20),
  curp varchar(18),
  contactPerson varchar(50),
  retention decimal(3, 2),
  cityId int(11),
  paymentTermsId int(11),
  currencyId varchar(3),
  ivaId int(11),
  classificationId int(11),
  originId int(11),
  seller int(11))
BEGIN
INSERT INTO customer
(
customerId, customerType, rfc, companyName, tradeName, phoneCode1, phoneCode2, phone1, phone2, extension1, extension2, email1, email2, street, externalNumber, internalNumber, colony, town, country, postcode, advance, timeLimit, settlementTimeLimit, curp, contactPerson, retention, cityId, paymentTermsId, currencyId, ivaId, classificationId, originId, seller
)
VALUES
(
customerId, 'P', rfc, companyName, tradeName, phoneCode1, phoneCode2, phone1, phone2, extension1, extension2, email1, email2, street, externalNumber, internalNumber, colony, town, country, postcode, advance, timeLimit, settlementTimeLimit, curp, contactPerson, retention, cityId, paymentTermsId, currencyId, ivaId, classificationId, originId, seller
);
select LAST_INSERT_ID();
END$$

-- -----------------------------------------------------------------------------
-- blackstarDb.GetAllCustomers
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllCustomers$$
CREATE PROCEDURE blackstarDb.GetAllCustomers(customerType enum('P', 'C'))
BEGIN
SELECT cu.customerId AS customerId, cu.customerType AS customerType, cu.companyName AS companyName, concat(ci.name, ', ', go.name) AS city, cu.contactPerson AS contactPerson, cu.email1 AS contactEmail FROM customer cu INNER JOIN city ci ON cu.cityId = ci.cityId INNER JOIN government go ON ci.governmentId = go.governmentId WHERE cu.customerType = customerType ORDER BY cu.customerId ASC;
END$$

-- -----------------------------------------------------------------------------
-- blackstarDb.UpdateCustomer
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpdateCustomer$$
CREATE PROCEDURE blackstarDb.UpdateCustomer(
  customerId int(11),
  rfc varchar(14),
  companyName varchar(60),
  tradeName varchar(40),
  phoneCode1 varchar(3),
  phoneCode2 varchar(3),
  phone1 varchar(7),
  phone2 varchar(7),
  extension1 varchar(6),
  extension2 varchar(6),
  email1 varchar(50),
  email2 varchar(50),
  street varchar(30),
  externalNumber varchar(5),
  internalNumber varchar(3),
  colony varchar(30),
  town varchar(30),
  country varchar(20),
  postcode varchar(5),
  advance double,
  timeLimit varchar(20),
  settlementTimeLimit varchar(20),
  curp varchar(18),
  contactPerson varchar(50),
  retention decimal(3, 2),
  cityId int(11),
  paymentTermsId int(11),
  currencyId varchar(3),
  ivaId int(11),
  classificationId int(11),
  originId int(11),
  seller int(11))
BEGIN
Update customer set
rfc=rfc,
companyName=companyName,
tradeName=tradeName,
phoneCode1=phoneCode1,
phoneCode2=phoneCode2,
phone1=phone1,
phone2=phone2,
extension1=extension1,
extension2=extension2,
email1=email1,
email2=email2,
street=street,
externalNumber=externalNumber,
internalNumber=internalNumber,
colony=colony,
town=town,
country=country,
postcode=postcode,
advance=advance,
timeLimit=timeLimit,
settlementTimeLimit=settlementTimeLimit,
curp=curp,
contactPerson=contactPerson,
retention=retention,
cityId=cityId,
paymentTermsId=paymentTermsId,
currencyId=currencyId,
ivaId=ivaId,
classificationId=classificationId,
originId=originId,
seller=seller
where customerId=customerId;
END$$

-- -----------------------------------------------------------------------------
-- blackstarDb.GetAllGovernments
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllGovernments$$
CREATE PROCEDURE blackstarDb.GetAllGovernments()
BEGIN
SELECT go.governmentId AS governmentId, go.name AS name FROM government go ORDER BY go.name ASC;
END$$

-- -----------------------------------------------------------------------------
-- blackstarDb.GetAllCities
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllCities$$
CREATE PROCEDURE blackstarDb.GetAllCities(governmentId int(11))
BEGIN
SELECT ci.cityId AS cityId, ci.name AS name FROM city ci WHERE ci.governmentId = governmentId ORDER BY ci.name ASC;
END$$

-- -----------------------------------------------------------------------------
-- blackstarDb.GetAllPaymentTerms
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllPaymentTerms$$
CREATE PROCEDURE blackstarDb.GetAllPaymentTerms()
BEGIN
SELECT pt.paymentTermsId AS paymentTermsId, pt.name AS name FROM paymentTerms pt ORDER BY pt.name ASC;
END$$

-- -----------------------------------------------------------------------------
-- blackstarDb.GetAllCurrency
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllCurrency$$
CREATE PROCEDURE blackstarDb.GetAllCurrency()
BEGIN
SELECT cu.currencyId AS currencyId, cu.singleName AS singleName, cu.pluralName AS pluralName FROM currency cu ORDER BY cu.pluralName ASC;
END$$

-- -----------------------------------------------------------------------------
-- blackstarDb.GetAllClassifications
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllClassifications$$
CREATE PROCEDURE blackstarDb.GetAllClassifications()
BEGIN
SELECT cl.classificationId AS classificationId, cl.name AS name FROM classification cl ORDER BY cl.name ASC;
END$$

-- -----------------------------------------------------------------------------
-- blackstarDb.GetAllIVA
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllIVA$$
CREATE PROCEDURE blackstarDb.GetAllIVA()
BEGIN
SELECT ivaId, percentage FROM iva ORDER BY percentage ASC;
END$$

-- -----------------------------------------------------------------------------
-- blackstarDb.GetAllOrigins
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllOrigins$$
CREATE PROCEDURE blackstarDb.GetAllOrigins()
BEGIN
SELECT o.originId AS originId, o.name AS name FROM origin o ORDER BY o.name ASC;
END$$

-- -----------------------------------------------------------------------------
-- blackstarDb.GetAllSellers
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllSellers$$
SELECT bsu.blackstarUserId AS blackstarUserId, bsu.name AS name, bsu.email AS email FROM blackstarUser bsu
inner join blackstarUser_userGroup bsug
on bsu.blackstarUserId=bsug.blackstarUserId 
inner join userGroup ug
on ug.userGroupId=bsug.userGroupId
where ug.userGroupId=(select userGroupID from userGroup ug where ug.externalId='sysSales')
ORDER BY bsu.name ASC;
END$$

DELIMITER ;

