-- ----------------------------------------------------------------------------- 
-- Name:	codexDb_StoredProcedures
-- Desc:	Crea o actualiza los Stored procedures operativos de la aplicacion
-- Auth:	Daniel Castillo B
-- Date:	24/06/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    	Author	Description
-- --   --------   -------  ----------------------------------------------------
-- 1    24/06/2014	DCB		Se Integran los SP iniciales:
--								blackstarDb.GetCodexAllStates

use blackstarDb;

DELIMITER $$


-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetAllStates
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetAllStates$$
CREATE PROCEDURE blackstarDb.CodexGetAllStates()
BEGIN

	SELECT DISTINCT loc.state AS state 
    FROM location loc 
    ORDER BY state ASC;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetAllClientTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetAllClientTypes$$
CREATE PROCEDURE blackstarDb.CodexGetAllClientTypes()
BEGIN

	SELECT cct._id AS id, cct.name AS name, cct.description AS description
    FROM codexClientType cct;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetAllOriginTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetAllOriginTypes$$
CREATE PROCEDURE blackstarDb.CodexGetAllOriginTypes()
BEGIN

  SELECT ccot._id AS id, ccot.name AS name, ccot.description AS description 
  FROM codexClientOriginType ccot;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUsersByGroup
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUsersByGroup$$
CREATE PROCEDURE blackstarDb.GetUsersByGroup(pUserGroup VARCHAR(100))
BEGIN

	SELECT 
		u.blackstarUserId AS id, 
		u.email AS userEmail, 
		u.name AS userName
	FROM blackstarUser_userGroup ug
		INNER JOIN blackstarUser u ON u.blackstarUserId = ug.blackstarUserId
		INNER JOIN userGroup g ON g.userGroupId = ug.userGroupId
	WHERE g.externalId = pUserGroup
	ORDER BY u.name;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLocationsByState
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLocationsByState;
CREATE PROCEDURE blackstarDb.GetLocationsByState(pZipCode VARCHAR(5))
BEGIN

   SELECT * 
   FROM location
   WHERE zipCode = pZipCode;

END;

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertClient
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexInsertClient$$
CREATE PROCEDURE blackstardb.`CodexInsertClient`(pClientTypeId int(2), pClientOriginId int(2), pSellerId int(11)
                                                 , pIsProspect tinyint(4), pRfc varchar(13), pCorporateName text, pTradeName text, pPhoneArea varchar(3), pPhoneNumber varchar(10)
                                                 , pPhoneExtension varchar(6), pPhoneAreaAlt varchar(3), pPhoneNumberAlt varchar(10), pPhoneExtensionAlt varchar(6)
                                                 , pEmail varchar(60), pEmailAlt varchar(60), pStreet text, pIntNumber varchar(5), pExtNumber varchar(5)
                                                 , pZipCode int(5), pCountry text, pState varchar(20), pMunicipality text, pCity text, pNeighborhood text
                                                 , pContactName text, pCurp varchar(18), pRetention varchar(20))
BEGIN

	INSERT INTO codexClient (clientTypeId, clientOriginId, sellerId, isProspect, rfc, corporateName,
              tradeName, phoneArea, phoneNumber, phoneExtension, phoneAreaAlt, phoneNumberAlt,
              phoneExtensionAlt, email, emailAlt, street, intNumber, extNumber, zipCode, country,
              state, municipality, city, neighborhood, contactName, curp, retention)
              VALUES
              (pClientTypeId, pClientOriginId, pSellerId, pIsProspect, pRfc, pCorporateName,
              pTradeName, pPhoneArea, pPhoneNumber, pPhoneExtension, pPhoneAreaAlt, pPhoneNumberAlt,
              pPhoneExtensionAlt, pEmail, pEmailAlt, pStreet, pIntNumber, pExtNumber, pZipCode, pCountry,
              pState, pMunicipality, pCity, pNeighborhood, pContactName, pCurp, pRetention);
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetNextClientId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetNextClientId$$
CREATE PROCEDURE blackstardb.`CodexGetNextClientId`()
BEGIN

  SELECT IFNULL(MAX(_ID)  + 1, 1) FROM codexClient;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetClientList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetClientList$$
CREATE PROCEDURE blackstardb.`CodexGetClientList`(pIsProspect tinyint(4))
BEGIN

  SELECT * FROM codexClient WHERE isProspect = pIsProspect;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetEntryTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetEntryTypes$$
CREATE PROCEDURE blackstardb.`CodexGetEntryTypes`()
BEGIN

  SELECT _id id, name name, description description 
  FROM codexProjectEntryTypes;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetEntryItemTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetEntryItemTypes$$
CREATE PROCEDURE blackstardb.`CodexGetEntryItemTypes`()
BEGIN

  SELECT _id id, name name, description description 
  FROM codexProjectItemTypes;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetCurrencyTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetCurrencyTypes$$
CREATE PROCEDURE blackstardb.`CodexGetCurrencyTypes`()
BEGIN

  SELECT _id id, name name, description description 
  FROM codexCurrencyType;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetCurrencyTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetTaxesTypes$$
CREATE PROCEDURE blackstardb.`CodexGetTaxesTypes`()
BEGIN

  SELECT _id id, name name, description description , value value
  FROM codexTaxesTypes;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetFollowUpByProjectId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetFollowUpByProjectId$$
CREATE PROCEDURE blackstarDb.GetFollowUpByProjectId(pProjectId INTEGER)
BEGIN

	SELECT 
		created AS created,
		u2.name AS createdByUsr,
		u.name AS asignee,
		followup AS followUp
	FROM followUp f
		LEFT OUTER JOIN blackstarUser u ON f.asignee = u.email
		LEFT OUTER JOIN blackstarUser u2 ON f.createdByUsr = u2.email
	WHERE codexProjectId = pProjectId
	ORDER BY created;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetWorkTeamByProjectId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetWorkTeamByProjectId$$
CREATE PROCEDURE blackstarDb.`GetWorkTeamByProjectId`(pProjectId INTEGER)
BEGIN

SELECT *
FROM (
  (SELECT _id id, ticketId ticketId, workerRoleTypeId workerRoleTypeId, blackstarUserId blackstarUserId, assignedDate assignedDate
       FROM workTeam WHERE codexProjectId = pProjectId
  ) AS ticketTeam
       LEFT JOIN (SELECT bu.blackstarUserId refId, bu.name blackstarUserName
           FROM blackstarUser bu
        ) AS j1 ON ticketTeam.blackstarUserId = j1.refId
       LEFT JOIN (SELECT wrt._id refId, wrt.name as workerRoleTypeName 
           FROM workerRoleType wrt
        ) AS j2 ON ticketTeam.workerRoleTypeId = j2.refId
);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetResponsibleByProjectId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetResponsibleByProjectId$$
CREATE PROCEDURE blackstarDb.`GetResponsibleByProjectId`(pProjectId INTEGER)
BEGIN

DECLARE responsableId INTEGER;

SET responsableId = (SELECT blackstarUserId 
                     FROM workTeam 
                     WHERE codexProjectId = pProjectId
                           AND workerRoleTypeId = 1
                     LIMIT 1);
SELECT * 
FROM blackstarUser
WHERE blackstarUserId = responsableId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetUserForResponseByProjectId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetUserForResponseByProjectId$$
CREATE PROCEDURE blackstarDb.`GetUserForResponseByProjectId`(pProjectId INTEGER)
BEGIN

DECLARE responseUserId INTEGER;

SET responseUserId = (SELECT blackstarUserId 
                     FROM workTeam 
                     WHERE codexProjectId = pProjectId
                           AND workerRoleTypeId = 2
                     ORDER BY assignedDate DESC
                     LIMIT 1);
SELECT * 
FROM blackstarUser
WHERE blackstarUserId = responseUserId;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.AddFollowUpToCodexProject
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.AddFollowUpToCodexProject$$
CREATE PROCEDURE blackstarDb.`AddFollowUpToCodexProject`(pProjectId INTEGER, pCreatedByUsrId INTEGER, pAssignedUsrId INTEGER, pMessage TEXT)
BEGIN
  DECLARE pCreatedByUsrMail VARCHAR(100);
  DECLARE pAsigneeUsrMail VARCHAR(100);
  
  SET pCreatedByUsrMail = (SELECT email FROM blackstarUser WHERE blackstarUserId = pCreatedByUsrId);
  SET pAsigneeUsrMail = (SELECT email FROM blackstarUser WHERE blackstarUserId = pAssignedUsrId);
	INSERT INTO blackstarDb.followUp(codexProjectId, followup, created, createdBy, createdByUsr, asignee)
	VALUES(pProjectId, pMessage, NOW(), 'AddFollowUpToCodexProject', pCreatedByUsrMail, pAsigneeUsrMail);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.UpsertWorkTeamByCodexProject
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertWorkTeamByCodexProject$$
CREATE PROCEDURE blackstarDb.`UpsertWorkTeamByCodexProject`(pProjectId INTEGER, pWorkerRoleTypeId INTEGER, pblackstarUserId INTEGER)
BEGIN

IF NOT EXISTS (SELECT * FROM workTeam 
               WHERE codexProjectId = pProjectId AND blackstarUserId = pblackstarUserId) THEN
    INSERT INTO blackstarDb.workTeam(codexProjectId, workerRoleTypeId, blackstarUserId, assignedDate)
    VALUES(pProjectId, pWorkerRoleTypeId, pblackstarUserId, NOW());   
ELSE
   UPDATE blackstarDb.workTeam SET assignedDate = NOW(), workerRoleTypeId = pWorkerRoleTypeId
   WHERE codexProjectId = pProjectId AND blackstarUserId = pblackstarUserId;
END IF;
IF (pWorkerRoleTypeId = 1) THEN
    UPDATE blackstarDb.workTeam SET workerRoleTypeId = 2
    WHERE codexProjectId = pProjectId AND blackstarUserId != pblackstarUserId;
END IF;
    
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetProjectById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetProjectById$$
CREATE PROCEDURE blackstardb.`CodexGetProjectById`(pProjectId int(11))
BEGIN
SELECT cp._id id, cp.projectNumber projectNumber, cp.clientId clientId, cp.taxesTypeId taxesTypeId, cp.statusId statusId
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, cst.name statusDescription
      , cc.tradeName clientDescription, cp.costCenter costCenter, cp.changeType changeType, cp.created created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.intercom intercom
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber
FROM codexProject cp, codexClient cc, codexStatusType cst, codexPaymentType cpt, codexCurrencyType cct
WHERE cp.statusId = cst._id
      AND cp.clientId = cc._id
      AND cp.paymentTypeId = cpt._id
      AND cp.currencyTypeId = cct._id
      AND cp._id = pProjectId ;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextProjectId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.GetNextProjectId$$
CREATE PROCEDURE blackstardb.`GetNextProjectId`()
BEGIN
	DECLARE newNumber INTEGER;
	CALL blackstarDb.GetNextServiceOrderNumber('C', newNumber);
	SELECT newNumber projectNumber;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetDeliverableTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetDeliverableTypes$$
CREATE PROCEDURE blackstardb.`CodexGetDeliverableTypes`()
BEGIN
	SELECT cdt._id id, cdt.name name, cdt.description description 
  FROM codexDeliverableType cdt;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertDeliverableTrace
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexInsertDeliverableTrace$$
CREATE PROCEDURE blackstardb.`CodexInsertDeliverableTrace`(pProjectId int(11), pDeliverableId int(2), pUserId int(11))
BEGIN
	INSERT INTO codexDeliverableTrace (codexProjectId, deliverableTypeId, created, userId)
  VALUES (pProjectId, pDeliverableId, NOW(), pUserId);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetReferenceTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetReferenceTypes$$
CREATE PROCEDURE blackstardb.`CodexGetReferenceTypes`(pItemTypeId int(2))
BEGIN
  IF (pItemTypeId = 1) THEN
      SELECT * FROM codexPriceList;
  END IF;
  IF (pItemTypeId = 2) THEN
     SELECT bt._id as _id, bt.ticketNumber as name FROM bloomTicket bt;
  END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetPaymentTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetPaymentTypes$$
CREATE PROCEDURE blackstardb.`CodexGetPaymentTypes`()
BEGIN
	SELECT cpt._id id, cpt.name name, cpt.description description 
  FROM codexPaymentType cpt;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertProjectEntry
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexInsertProjectEntry$$
CREATE PROCEDURE blackstardb.`CodexInsertProjectEntry`(pEntryId int(11), pProjectId int(11), pEntryTypeId int(11), pDescription TEXT, pDiscount FLOAT(6,2), pTotalPrice FLOAT(9,2), pComments TEXT)
BEGIN
  INSERT INTO codexProjectEntry (_id, projectId, entryTypeId, description, discount, totalPrice, comments)
  VALUES (pEntryId, pProjectId, pEntryTypeId, pDescription, pDiscount, pTotalPrice, pComments);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertProjectEntryItem
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexInsertProjectEntryItem$$
CREATE PROCEDURE blackstardb.`CodexInsertProjectEntryItem`(pEntryId int(11), pItemTypeId int(11), pReference TEXT, pDescription TEXT, pQuantity int(11), pPriceByUnit float(8,2), pDiscount float(6,2), pTotalPrice float(10,2), pComments TEXT)
BEGIN
  INSERT INTO codexEntryItem (entryId, itemTypeId, reference, description, quantity, priceByUnit, discount, totalPrice, comments)
  VALUES (pEntryId, pItemTypeId, pReference, pDescription, pQuantity, pPriceByUnit, pDiscount, pTotalPrice, pComments);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertProject
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexInsertProject$$
CREATE PROCEDURE blackstardb.`CodexInsertProject`(pProjectId int(11), pClientId int(11), pTaxesTypeId int(1), pStatusId int(1), pPaymentTypeId int(1),pCurrencyTypeId int(2), pProjectNumber varchar(8), pCostCenter varchar(8), pChangeType float(2,2), pCreated varchar(20), pContactName text, pLocation varchar(20), pAdvance float(7,2), pTimeLimit int(3), pSettlementTimeLimit int(3), pDeliveryTime int(3), pIntercom varchar(5), pProductsNumber int(7), pFinancesNumber int(7), pServicesNumber int(7), pTotalProjectNumber int(8))
BEGIN
  INSERT INTO codexProject (_id, clientId , taxesTypeId , statusId , paymentTypeId ,currencyTypeId , projectNumber , costCenter , changeType , created , contactName , location , advance , timeLimit , settlementTimeLimit , deliveryTime , intercom , productsNumber , financesNumber , servicesNumber , totalProjectNumber)
  VALUES (pProjectId, pClientId , pTaxesTypeId , pStatusId , pPaymentTypeId ,pCurrencyTypeId , pProjectNumber , pCostCenter , pChangeType , pCreated , pContactName , pLocation , pAdvance , pTimeLimit , pSettlementTimeLimit , pDeliveryTime , pIntercom , pProductsNumber , pFinancesNumber , pServicesNumber , pTotalProjectNumber);
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextEntryId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.GetNextEntryId$$
CREATE PROCEDURE blackstardb.`GetNextEntryId`()
BEGIN

	DECLARE newNumber INTEGER;

	CALL blackstarDb.GetNextServiceOrderNumber('D', newNumber);
	SELECT newNumber projectNumber;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetAllClients
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetAllClients$$
CREATE PROCEDURE blackstardb.`CodexGetAllClients`()
BEGIN
  SELECT _id id, clientTypeId clientTypeId, clientOriginId clientOriginId, sellerId sellerId
         , isProspect isProspect, rfc rfc, corporateName corporateName, tradeName tradeName
         , phoneArea phoneArea, phoneNumber phoneNumber, phoneExtension phoneExtension
         , phoneAreaAlt phoneAreaAlt, phoneNumberAlt phoneNumberAlt, phoneExtensionAlt phoneExtensionAlt
         , email email, emailAlt emailAlt, street street, intNumber intNumber, extNumber extNumber
         , zipCode zipCode, country country, state state, municipality municipality, city city
         , neighborhood neighborhood, contactName contactName, curp curp, retention retention
  FROM codexclient
  WHERE isProspect = 0;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetAllProjects
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetAllProjects$$
CREATE PROCEDURE blackstardb.`CodexGetAllProjects`()
BEGIN
SELECT cp._id id, cp.projectNumber projectNumber, cp.clientId clientId, cp.taxesTypeId taxesTypeId, cp.statusId statusId
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, cst.name statusDescription
      , cc.tradeName clientDescription, cp.costCenter costCenter, cp.changeType changeType, cp.created created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.intercom intercom
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber
FROM codexProject cp, codexClient cc, codexStatusType cst, codexPaymentType cpt, codexCurrencyType cct
WHERE cp.statusId = cst._id
      AND cp.clientId = cc._id
      AND cp.paymentTypeId = cpt._id
      AND cp.currencyTypeId = cct._id;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetEntriesByProject
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetEntriesByProject$$
CREATE PROCEDURE blackstardb.`CodexGetEntriesByProject`(pProjectId int(11))
BEGIN
	SELECT cpe._id id, cpe.projectId projectId, cpe.entryTypeId entryTypeId, cpe.description description
         , cpe.discount discount, cpe.totalPrice totalPrice, cpe.comments comments, cpet.name entryTypeDescription
    FROM codexProjectEntry cpe, codexProjectEntryTypes cpet
    WHERE projectId = pProjectId
          AND  cpe.entryTypeId = cpet._id;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetItemsByEntry
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstardb.CodexGetItemsByEntry$$
CREATE PROCEDURE blackstardb.`CodexGetItemsByEntry`(pEntryId int(11))
BEGIN
	SELECT cei._id id, cei.entryId entryId, cei.itemTypeId itemTypeId, cei.reference reference
         , cei.description description, cei.quantity quantity, cei.priceByUnit priceByUnit
         , cei.discount discount, cei.totalPrice totalPrice, cei.comments comments, cpit.name itemTypeDescription
  FROM codexEntryItem cei, codexProjectItemTypes cpit
  WHERE cei.entryId = pEntryId
        AND cei.itemTypeId = cpit._id;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetDeliverables
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetDeliverables$$
CREATE PROCEDURE blackstarDb.CodexGetDeliverables(pProjectId INTEGER)
BEGIN	
  SELECT cdt._id id, cdt.codexProjectId projectId, cp.projectNumber projectNumber
        ,cdt.deliverableTypeId deliverableTypeId, cdty.name deliverableTypeDescription
        , cdt.created created, cdt.userId userId, bu.name userName
	FROM codexDeliverableTrace	cdt, codexProject cp, codexDeliverableType cdty, blackstarUser bu
  WHERE cdt.codexProjectId = 1
        AND cdt.codexProjectId = cp._id
        AND cdt.deliverableTypeId = cdty._id
        AND cdt.userId = bu.blackstarUserId;
END$$  

-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;
