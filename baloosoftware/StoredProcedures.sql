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
SELECT cu.customerId AS DT_RowId, cu.customerType AS customerType, cu.companyName AS companyName, concat(ci.name, ', ', go.name) AS city, cu.contactPerson AS contactPerson, cu.email1 AS contactEmail FROM customer cu INNER JOIN city ci ON cu.cityId = ci.cityId INNER JOIN government go ON ci.governmentId = go.governmentId WHERE cu.customerType = customerType ORDER BY cu.customerId ASC;
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

DELIMITER ;

