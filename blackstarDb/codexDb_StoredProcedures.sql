-- ----------------------------------------------------------------------------- 
-- Name:	codexDb_StoredProcedures
-- Desc:	Crea o actualiza los Stored procedures operativos de la aplicacion
-- Auth:	Daniel Castillo B
-- Date:	24/06/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date        Author	 Description
-- --   --------   -------  ------------------------------------
-- 1    24/06/2014  DCB		  Se Integran los SP iniciales:
--								              blackstarDb.GetCodexAllStates
-- --   --------   -------  ------------------------------------
-- 2    13/08/2014  SAG     Se agrega:
--                              blackstarDb.GetCostCenterList
--                              blackstarDb.GetCSTOffice
-- -----------------------------------------------------------------------------
-- 3    01/09/2014  SAG     Se modifica:
--                              blackstarDb.CodexGetProjectsByStatusAndUser
--                              blackstarDb.CodexGetAllProjectsByUsr
--                              blackstarDb.CodexGetProjectsByStatus
--                              blackstarDb.CodexUpsertProject
--                              blackstarDb.CodexUpsertProjectEntry
--                          Se agrega: 
--                              blackstarDb.UpsertCodexCostCenter
--                              blackstarDb.GetCodexPriceList
--                          Se elimina:
--                              blackstarDb.GetNextEntryId
-- -----------------------------------------------------------------------------
-- 4  24/09/2014    SAG     Se agrega:
--                              blackstarDb.GetCstByEmail
--                          Se modifica:
--                              blackstarDb.GetCSTOffice
-- -----------------------------------------------------------------------------
-- 5  22/10/2014    SAG     Se agrega:
--                              blackstarDb.UpsertCodexVisit
--                              blackstarDb.GetAllVisitStatus
--                              blackstarDb.GetVisitList
--                              blackstarDb.GetAllCst
--                              blackstarDb.GetVisitById
-- -----------------------------------------------------------------------------
-- 6  28/10/2014    SAG     Se agrega:
--                              blackstarDb.getCodexInvoicingKpi
--                              blackstarDb.getCodexEffectiveness
--                              blackstarDb.getCodexProposals
--                              blackstarDb.getCodexProjectsByStatus
--                              blackstarDb.getCodexProjectsByOrigin
--                              blackstarDb.getCodexClientVisits
--                              blackstarDb.getCodexNewCustomers
--                              blackstarDb.getCodexProductFamilies
--                              blackstarDb.getCodexComerceCodes
--                              blackstarDb.getAutocompleteClientList
-- -----------------------------------------------------------------------------
-- 7  15/01/2015  SAG     Se agrega:
--                              blackstarDb.GetPriceProposalList
-- -----------------------------------------------------------------------------
-- 8  29/01/2015  SAG     Se modifica:
--                              blackstarDb.CodexGetAllProjectsByUsr
-- -----------------------------------------------------------------------------
-- 9 13/02/2015   SAG     Se agrega:
--                              blackstarDb.RecordSalesCall
--                              blackstarDb.getSalesCallRecords
-- -----------------------------------------------------------------------------
-- 10 23/02/2015  SAG     Se modifica:
--                              blackstarDb.CodexUpsertProjectEntryItem
-- -----------------------------------------------------------------------------

use blackstarDb;

DELIMITER $$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getSalesCallRecords
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getSalesCallRecords$$
CREATE PROCEDURE blackstarDb.getSalesCallRecords(startDate DATETIME, endDate DATETIME, cstEmail VARCHAR(500))
BEGIN
  
  SELECT c.name AS cst,
    s.month AS month,
    s.year AS year,
    count(s.codexSalesCallId) AS callCount
  FROM cst c
    LEFT OUTER JOIN codexSalesCall s ON s.cstId = c.cstId
  WHERE if(cstEmail = 'All', 1=1, c.email = cstEmail)
    AND callDate >= startDate 
    AND callDate <= endDate
  GROUP BY c.name, s.month, s.year;

END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.RecordSalesCall
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.RecordSalesCall$$
CREATE PROCEDURE blackstarDb.RecordSalesCall(cstEmail VARCHAR(500), callDate DATETIME)
BEGIN
  
  INSERT INTO codexSalesCall(cstId, month, year, callDate)
  SELECT cstId, month(callDate), year(callDate), callDate FROM cst
  WHERE email = cstEmail;

END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getAutocompleteClientList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getAutocompleteClientList$$
CREATE PROCEDURE blackstarDb.getAutocompleteClientList()
BEGIN

  SELECT 
    _id AS value,
    corporateName AS label
  FROM codexClient
  ORDER BY corporateName;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexInvoicingKpi
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexInvoicingKpi$$
CREATE PROCEDURE blackstarDb.getCodexInvoicingKpi(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN

  IF(ifnull(cst, '') != '') THEN
    SELECT
      c.name AS cstName,
      sum(p.totalProjectNumber) AS amount,
      o.name AS origin,
      '0 %' AS coverage
    FROM codexProject p
      INNER JOIN cst c ON p.createdByUsr = c.email
      INNER JOIN codexClient cl ON cl._id = p.clientId
      INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
    WHERE p.created >= startDate
      AND p.created <= endDate
      AND c.email = cst
      AND cl.clientOriginId = originId
    GROUP BY c.name, o.name;
  ELSE
     SELECT
      c.name AS cstName,
      sum(p.totalProjectNumber) AS amount,
      o.name AS origin,
      CONVERT((sum(p.totalProjectNumber) / yearQuota) * 100, CHAR) AS coverage
    FROM codexProject p
      INNER JOIN cst c ON p.createdByUsr = c.email
      INNER JOIN codexClient cl ON cl._id = p.clientId
      INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
    WHERE p.created >= startDate
      AND p.created <= endDate
      AND cl.clientOriginId = originId
    GROUP BY c.name, o.name;
  END IF;
  
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexEffectiveness
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexEffectiveness$$
CREATE PROCEDURE blackstarDb.getCodexEffectiveness(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN
  
  CREATE TEMPORARY TABLE cstProjects(cstEmail VARCHAR(200), originId INT, projectCount INT, soldCount INT);

  INSERT INTO cstProjects(cstEmail, originId, projectCount, soldCount)
  SELECT createdByUsr, cl.clientOriginId, count(*), 0
  FROM codexProject p
    INNER JOIN codexClient cl ON p.clientId = cl._id
  WHERE p.created >= startDate
      AND p.created <= endDate
  GROUP BY createdByUsr, clientOriginId;

  UPDATE cstProjects SET
    soldCount = (
      SELECT count(*) FROM codexProject p
        INNER JOIN codexClient cl ON p.clientId = cl._id
      WHERE createdByUsr = cstEmail
        AND p.created >= startDate
        AND p.created <= endDate
        AND cl.clientOriginId = originId
        AND p.statusId >=4);

  SELECT
    c.name AS cstName,
    o.name AS origin,
    (soldCount/projectCount) * 100 AS effectiveness
  FROM cstProjects p
    INNER JOIN cst c ON p.cstEmail = c.email
    INNER JOIN codexClientOrigin o ON p.originId = o._id;

  DROP TABLE cstProjects;
  
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexProposals
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexProposals$$
CREATE PROCEDURE blackstarDb.getCodexProposals(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN

  SELECT
    c.name AS cstName,
    o.name AS origin,
    s.name AS status,
    sum(totalProjectNumber) AS amount
  FROM codexProject p
    INNER JOIN cst c ON p.createdByUsr = c.email
    INNER JOIN codexClient cl ON p.clientId = cl._id
    INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
    INNER JOIN codexStatusType s ON p.statusId = s._id
  WHERE p.created >= startDate
    AND p.created <= endDate
  GROUP BY c.name, o.name, s.name;

  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexProjectsByStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexProjectsByStatus$$
CREATE PROCEDURE blackstarDb.getCodexProjectsByStatus(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN

  SET @projectCount = (SELECT count(*) FROM codexProject WHERE created >= startDate AND created <= endDate);

  SELECT
    c.name AS cstName,
    o.name AS origin,
    s.name AS status,
    count(*) AS count,
    (count(*) / @projectCount) * 100 AS contribution
  FROM codexProject p
    INNER JOIN cst c ON p.createdByUsr = c.email
    INNER JOIN codexClient cl ON p.clientId = cl._id
    INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
    INNER JOIN codexStatusType s ON p.statusId = s._id
  WHERE p.created >= startDate
    AND p.created <= endDate
  GROUP BY c.name, o.name, s.name;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexProjectsByOrigin
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexProjectsByOrigin$$
CREATE PROCEDURE blackstarDb.getCodexProjectsByOrigin(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN

  SET @projectTotal = (SELECT sum(totalProjectNumber) FROM codexProject WHERE created >= startDate AND created <= endDate);

  SELECT
    o.name AS origin,
    sum(totalProjectNumber) AS amount,
    (sum(totalProjectNumber) / @projectTotal) * 100 AS contribution
  FROM codexProject p
    INNER JOIN codexClient cl ON p.clientId = cl._id
    INNER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
  WHERE p.created >= startDate
    AND p.created <= endDate
  GROUP BY o.name;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexClientVisits
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexClientVisits$$
CREATE PROCEDURE blackstarDb.getCodexClientVisits(startDate DATETIME, endDate DATETIME, cst VARCHAR(200), originId INT)
BEGIN

  SELECT 
    c.name AS cstName,
    ifnull(o.name, '') AS origin,
    count(*) AS count
  FROM codexVisit v 
    INNER JOIN cst c ON v.cstId = c.cstId
    LEFT OUTER JOIN codexClient cl ON cl._id = v.codexClientId
    LEFT OUTER JOIN codexClientOrigin o ON o._id = cl.clientOriginId
  WHERE v.created >= startDate
    AND v.created <= endDate
    AND v.visitStatusId = 'R'
  GROUP BY c.name, o.name;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexNewCustomers
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexNewCustomers$$
CREATE PROCEDURE blackstarDb.getCodexNewCustomers(startDate DATETIME, endDate DATETIME, cst VARCHAR(200))
BEGIN

  SELECT
    u.name AS cstName,
    count(*) AS count
  FROM codexClient c
    INNER JOIN blackstarUser u ON u.blackstarUserId = c.cstId
  WHERE turnedCustomerDate >= startDate 
    AND turnedCustomerDate <= endDate
  GROUP BY u.name;
   
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexProductFamilies
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexProductFamilies$$
CREATE PROCEDURE blackstarDb.getCodexProductFamilies(startDate DATETIME, endDate DATETIME)
BEGIN

  SET @projectTotal = (
      SELECT sum(totalProjectNumber) 
      FROM codexProject p
        INNER JOIN codexProjectEntry e ON e.projectId = p._id
        INNER JOIN codexEntryItem i ON i.entryId = e._id
      WHERE p.created >= startDate AND p.created <= endDate);

  SELECT 
    f.productFamily,
    sum(totalProjectNumber) AS totalamount,
    (sum(totalProjectNumber) / @projectTotal) * 100 AS contribution
  FROM codexProject p
    INNER JOIN codexProjectEntry e ON e.projectId = p._id
    INNER JOIN codexEntryItem i ON i.entryId = e._id
    INNER JOIN codexPriceList l ON i.priceListId = l._id
    INNER JOIN codexProductFamily f ON f.codexProductFamilyId = l.codexProductFamilyId
  WHERE p.created >= startDate AND p.created <= endDate
  GROUP BY productFamily;

END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.getCodexComerceCodes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.getCodexComerceCodes$$
CREATE PROCEDURE blackstarDb.getCodexComerceCodes(startDate DATETIME, endDate DATETIME)
BEGIN

  SELECT
    t.name AS code,
    sum(e.totalPrice) AS amount
  FROM codexProject p
    INNER JOIN codexProjectEntry e ON e.projectId = p._id
    INNER JOIN codexEntryItem i ON i.entryId = e._id
    INNER JOIN codexProjectEntryTypes t ON t._id = e.entryTypeId
  WHERE p.created >= startDate AND p.created <= endDate
  GROUP BY t.name;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetVisitById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetVisitById$$
CREATE PROCEDURE blackstarDb.GetVisitById(pVisitId INT)
BEGIN

  SELECT 
      v.codexVisitId,
      v.cstId,
      ifnull(v.codexClientId, 0),
      v.visitDate,
      v.description,
      v.closure,
      v.visitStatusId,
      v.created,
      v.createdBy,
      v.createdByUsr,
      v.modified,
      v.modifiedBy,
      v.modifiedByUsr,
      c.name AS cstName,
      c.email AS cstEmail,
      v.customerName AS customerName,
      s.visitStatus
    FROM blackstarDb.codexVisit v
        INNER JOIN blackstarDb.cst c ON v.cstId = c.cstId
        INNER JOIN blackstarDb.codexVisitStatus s ON s.visitStatusId = v.visitStatusId
  WHERE codexVisitId = pVisitId;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetAllCst
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllCst$$
CREATE PROCEDURE blackstarDb.GetAllCst()
BEGIN

  SELECT * FROM blackstarDb.cst ORDER BY name;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetAllVisitStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetVisitList$$
CREATE PROCEDURE blackstarDb.GetVisitList(pcstEmail VARCHAR(100))
BEGIN

  SELECT 
      v.codexVisitId,
      v.cstId,
      v.codexClientId,
      v.visitDate,
      v.description,
      v.closure,
      v.visitStatusId,
      v.created,
      v.createdBy,
      v.createdByUsr,
      v.modified,
      v.modifiedBy,
      v.modifiedByUsr,
      c.name AS cstName,
      c.email AS cstEmail,
      v.customerName,
      s.visitStatus
    FROM blackstarDb.codexVisit v
        INNER JOIN blackstarDb.cst c ON v.cstId = c.cstId
        INNER JOIN blackstarDb.codexVisitStatus s ON s.visitStatusId = v.visitStatusId
    WHERE v.visitStatusId != 'D'
  AND if(ifnull(pcstEmail, '') != '', c.email = pcstEmail, 1=1 );

  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetAllVisitStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetAllVisitStatus$$
CREATE PROCEDURE blackstarDb.GetAllVisitStatus()
BEGIN

  SELECT visitStatusId, visitStatus FROM blackstarDb.codexVisitStatus;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.UpsertCodexVisit
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertCodexVisit$$
CREATE PROCEDURE blackstarDb.UpsertCodexVisit(pCodexVisitId INT, pCstId INT, pCodexClientId INT, pCustomerName VARCHAR(400), pVisitDate DATETIME, pDescription TEXT, pClosure TEXT, pVisitStatusId CHAR(1), pCreated DATETIME, pCreatedBy NVARCHAR(100), pCreatedByUsr VARCHAR(100), pModified DATETIME, pModifiedBy NVARCHAR(100), pModifiedByUsr VARCHAR(100))
BEGIN

  IF(SELECT count(*) FROM codexVisit WHERE codexVisitId = pCodexVisitId) > 0 THEN
    UPDATE blackstarDb.codexVisit SET
      cstId = pCstId,
      codexClientId = if(pCodexClientId = 0, NULL, pCodexClientId),
      customerName = pCustomerName,
      visitDate = pVisitDate,
      description = pDescription,
      closure = pClosure,
      visitStatusId = pVisitStatusId,
      modified = now(),
      modifiedBy = pModifiedBy,
      modifiedByUsr = pModifiedByUsr
    WHERE codexVisitId = pCodexVisitId;
    SELECT pCodexVisitId;
  ELSE
    INSERT INTO blackstarDb.codexVisit(cstId, codexClientId,                                customerName,  visitDate,  description,  closure,  visitStatusId,  created,  createdBy,  createdByUsr) VALUES(
                                      pCstId, if(pCodexClientId = 0, NULL, pCodexClientId), pCustomerName, pVisitDate, pDescription, pClosure, pVisitStatusId, pCreated, pCreatedBy, pCreatedByUsr);

    SELECT LAST_INSERT_ID();
  END IF;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetCstByEmail
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetCstByEmail$$
CREATE PROCEDURE blackstarDb.GetCstByEmail(pcstEmail VARCHAR(400))
BEGIN

  SELECT *
  FROM blackstarDb.cst
  WHERE email = pcstEmail
  LIMIT 1;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetCodexPriceList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetCodexPriceList$$
CREATE PROCEDURE blackstarDb.GetCodexPriceList()
BEGIN

  SELECT 
    _id AS id,
    code AS model,
    REPLACE(name, '''', '') AS name,
    price AS price
  FROM blackstarDb.codexPriceList
  ORDER BY id;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.UpsertCodexCostCenter
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.UpsertCodexCostCenter$$
CREATE PROCEDURE blackstarDb.UpsertCodexCostCenter(pCostCenter VARCHAR(200), pUsrId INT)
BEGIN

  IF(SELECT count(*) FROM codexCostCenter WHERE costCenter = pCostCenter) = 0 THEN
    INSERT INTO codexCostCenter(costCenter, created, createdBy, createdByUsr)
    SELECT pCostCenter, now(), 'UpsertCodexCostCenter', pUsrId;
  END IF;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetCSTOffice
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetCSTOffice$$
CREATE PROCEDURE blackstarDb.GetCSTOffice(pCst VARCHAR(200))
BEGIN

  SELECT officeId FROM blackstarDb.cst WHERE email = pCst LIMIT 1;
  
END$$

-- -----------------------------------------------------------------------------
  -- blackstarDb.GetCostCenterList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetCostCenterList$$
CREATE PROCEDURE blackstarDb.GetCostCenterList()
BEGIN

  SELECT * 
  FROM codexCostCenter
  ORDER BY costCenter DESC;
  
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetAllStates
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetAllStates$$
CREATE PROCEDURE blackstarDb.CodexGetAllStates()
BEGIN

	SELECT DISTINCT loc.state AS state 
  FROM blackstarConst.location loc 
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
  FROM codexClientOrigin ccot;
	
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
DROP PROCEDURE IF EXISTS blackstarDb.GetLocationsByState$$
CREATE PROCEDURE blackstarDb.GetLocationsByState(pZipCode VARCHAR(5))
BEGIN

   SELECT * 
   FROM blackstarConst.location
   WHERE zipCode = pZipCode;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertClient
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexInsertClient$$
CREATE PROCEDURE blackstarDb.`CodexInsertClient`(pClientTypeId int(2), pClientOriginId int(2), pCstId int(11)
                                                 , pIsProspect tinyint(4), pRfc varchar(13), pCorporateName text, pTradeName text, pPhoneArea varchar(3), pPhoneNumber varchar(10)
                                                 , pPhoneExtension varchar(6), pPhoneAreaAlt varchar(3), pPhoneNumberAlt varchar(10), pPhoneExtensionAlt varchar(6)
                                                 , pEmail varchar(60), pEmailAlt varchar(60), pStreet text, pIntNumber varchar(5), pExtNumber varchar(5)
                                                 , pZipCode int(5), pCountry text, pState varchar(20), pMunicipality text, pCity text, pNeighborhood text
                                                 , pContactName text, pCurp varchar(18), pRetention varchar(20))
BEGIN

	INSERT INTO codexClient (clientTypeId, clientOriginId, cstId, isProspect, rfc, corporateName,
              tradeName, phoneArea, phoneNumber, phoneExtension, phoneAreaAlt, phoneNumberAlt,
              phoneExtensionAlt, email, emailAlt, street, intNumber, extNumber, zipCode, country,
              state, municipality, city, neighborhood, contactName, curp, retention)
              VALUES
              (pClientTypeId, pClientOriginId, pCstId, pIsProspect, pRfc, pCorporateName,
              pTradeName, pPhoneArea, pPhoneNumber, pPhoneExtension, pPhoneAreaAlt, pPhoneNumberAlt,
              pPhoneExtensionAlt, pEmail, pEmailAlt, pStreet, pIntNumber, pExtNumber, pZipCode, pCountry,
              pState, pMunicipality, pCity, pNeighborhood, pContactName, pCurp, pRetention);
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetNextClientId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetNextClientId$$
CREATE PROCEDURE blackstarDb.`CodexGetNextClientId`()
BEGIN

  DECLARE newNumber INTEGER;
  CALL blackstarDb.GetNextServiceOrderNumber('C', newNumber);
  SELECT newNumber clientNumber;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetClientList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetClientList$$
CREATE PROCEDURE blackstarDb.`CodexGetClientList`(pIsProspect tinyint(4))
BEGIN

  SELECT cc._id id, ct.name clientTypeId ,
         IFNULL(corporateName, '') corporateName, 
         IFNULL(city, '') city, IFNULL(contactName, '') contactName
  FROM codexClient cc
    INNER JOIN codexClientType ct ON cc.clientTypeId = ct._id
  WHERE isProspect = pIsProspect;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetEntryTypes -- optimizado para rendereo en html
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetEntryTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetEntryTypes`()
BEGIN

  SELECT  _id AS id, 
          concat_ws('', replace(rpad(_id, 9, ' '), ' ', "&nbsp;"), name) AS name, 
          productType AS productType
  FROM codexProjectEntryTypes
  ORDER BY _id; 
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetEntryItemTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetEntryItemTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetEntryItemTypes`()
BEGIN

  SELECT _id AS id, 
         name AS name
  FROM codexProjectItemTypes;
	
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetCurrencyTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetCurrencyTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetCurrencyTypes`()
BEGIN

  SELECT _id id, name name, description description 
  FROM codexCurrencyType;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetCurrencyTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetTaxesTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetTaxesTypes`()
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
CREATE PROCEDURE blackstarDb.`AddFollowUpToCodexProject`(pProjectId INTEGER, pCreatedByUsr VARCHAR(200), pAssignedUsr VARCHAR(200), pMessage TEXT)
BEGIN

	INSERT INTO blackstarDb.followUp(codexProjectId, followup, created, createdBy, createdByUsr, asignee)
	VALUES(pProjectId, pMessage, NOW(), 'AddFollowUpToCodexProject', pCreatedByUsr, pAssignedUsr);
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
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetProjectById$$
CREATE PROCEDURE blackstarDb.`CodexGetProjectById`(pProjectId int(11))
BEGIN
SELECT cp._id id, cp.projectNumber projectNumber, cp.clientId clientId, cp.taxesTypeId taxesTypeId, cp.statusId statusId
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, cst.name statusDescription
      , cc.tradeName clientDescription, ccc.costCenter costCenter, cp.changeType changeType, cp.created created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.incoterm incoterm
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber, cp.createdBy createdBy, cp.createdByUsr createdByUsr
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr, cp.discountNumber discountNumber
      , cp.paymentConditions paymentConditions
FROM codexProject cp, codexClient cc, codexStatusType cst, codexPaymentType cpt, codexCurrencyType cct, codexCostCenter ccc
WHERE cp.statusId = cst._id
      AND cp.clientId = cc._id
      AND cp.paymentTypeId = cpt._id
      AND cp.currencyTypeId = cct._id
      AND cp.costCenterId = ccc._id
      AND cp._id = pProjectId ;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetNextProjectId
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetNextProjectId$$
CREATE PROCEDURE blackstarDb.`GetNextProjectId`(pType VARCHAR(10))
BEGIN
	DECLARE newNumber INTEGER;
	CALL blackstarDb.GetNextServiceOrderNumber(pType, newNumber);
	SELECT newNumber projectNumber;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetDeliverableTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetDeliverableTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetDeliverableTypes`()
BEGIN
	SELECT cdt._id id, cdt.name name, cdt.description description 
  FROM codexDeliverableType cdt;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertDeliverableTrace
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexInsertDeliverableTrace$$
CREATE PROCEDURE blackstarDb.`CodexInsertDeliverableTrace`(pProjectId int(11), pDeliverableId int(2), pUserId int(11))
BEGIN
	INSERT INTO codexDeliverableTrace (codexProjectId, deliverableTypeId, created, userId)
  VALUES (pProjectId, pDeliverableId, NOW(), pUserId);
END$$


-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetReferenceTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetReferenceTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetReferenceTypes`(pItemTypeId int(2))
BEGIN
  IF (pItemTypeId = 1) THEN
      SELECT _id AS value, CONCAT_WS(' - ', code, name) AS label FROM codexPriceList;
  END IF;
  IF (pItemTypeId = 2) THEN
     SELECT bt._id as value, bt.ticketNumber as label FROM bloomTicket bt;
  END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetPaymentTypes
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetPaymentTypes$$
CREATE PROCEDURE blackstarDb.`CodexGetPaymentTypes`()
BEGIN
	SELECT cpt._id id, cpt.name name, cpt.description description 
  FROM codexPaymentType cpt;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexUpsertProjectEntry
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexUpsertProjectEntry$$
CREATE PROCEDURE blackstarDb.`CodexUpsertProjectEntry`(pEntryId int(11), pProjectId int(11), pEntryTypeId int(11), pDescription TEXT, pDiscount FLOAT(15,2), pTotalPrice FLOAT(15,2), pComments TEXT, pQty INT, pUnitPrice FLOAT(15,2))
BEGIN
  DECLARE isUpdate INTEGER;
  SET isUpdate = (SELECT COUNT(*) FROM codexProjectEntry WHERE _id = pEntryId);
  
  IF(isUpdate = 0) THEN
    INSERT INTO codexProjectEntry (projectId, entryTypeId, description, discount, totalPrice, comments, qty, unitPrice)
    VALUES (pProjectId, pEntryTypeId, pDescription, pDiscount, pTotalPrice, pComments, pQty, pUnitPrice);
    
    SELECT LAST_INSERT_ID();
  ELSE
    UPDATE  codexProjectEntry SET 
      comments = pComments
    WHERE _id = pEntryId;

    SELECT pEntryId;
  END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexUpsertProjectEntryItem
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexUpsertProjectEntryItem$$
CREATE PROCEDURE blackstarDb.`CodexUpsertProjectEntryItem`(pItemId int(11),pEntryId int(11), pItemTypeId int(11), pReference TEXT, pDescription TEXT, pQuantity FLOAT(10,2), pPriceByUnit FLOAT(15,2), pDiscount FLOAT(15,2), pTotalPrice FLOAT(15,2), pComments TEXT)
BEGIN
  DECLARE isUpdate INTEGER;
  SET isUpdate = (SELECT COUNT(*) FROM codexEntryItem WHERE _id = pItemId);
 
  IF(isUpdate = 0) THEN
    INSERT INTO codexEntryItem (entryId, itemTypeId, reference, description, quantity, priceByUnit, discount, totalPrice, comments)
    VALUES (pEntryId, pItemTypeId, pReference, pDescription, pQuantity, pPriceByUnit, pDiscount, pTotalPrice, pComments);
  ELSE
    UPDATE  codexEntryItem SET comments = pComments
    WHERE _id = pItemId;
  END IF;
  
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexUpsertProject
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexUpsertProject$$
CREATE PROCEDURE blackstarDb.`CodexUpsertProject`(pProjectId int(11), pClientId int(11), pTaxesTypeId int(1), pStatusId int(1), pPaymentTypeId int(1),pCurrencyTypeId int(2), pProjectNumber varchar(8), pCostCenter varchar(8), pChangeType float, pCreated DATETIME, pContactName text, pLocation varchar(400), pAdvance FLOAT(15,2), pTimeLimit int(3), pSettlementTimeLimit int(3), pDeliveryTime int(3), pincoterm varchar(5), pProductsNumber FLOAT(15,2), pFinancesNumber FLOAT(15,2), pServicesNumber FLOAT(15,2), pTotalProjectNumber FLOAT(15,2), pCreatedByUsr int(11), pModifiedByUsr int(11), pDiscountNumber FLOAT(15,2), pPaymentConditions TEXT)
BEGIN
  DECLARE isUpdate INTEGER;
  SET isUpdate = (SELECT COUNT(*) FROM codexProject WHERE _id = pProjectId);

  CALL UpsertCodexCostCenter(pCostCenter, pCreatedByUsr);
  SET @ccId = (SELECT _id FROM codexCostCenter WHERE costCenter = pCostCenter);

  IF(isUpdate = 0) THEN
     INSERT INTO codexProject (clientId , taxesTypeId , statusId , paymentTypeId ,currencyTypeId , projectNumber , costCenterId , changeType , created , contactName , location , advance , timeLimit , settlementTimeLimit , deliveryTime , incoterm , productsNumber , financesNumber , servicesNumber , totalProjectNumber, createdByUsr, discountNumber, paymentConditions)
     VALUES (pClientId , pTaxesTypeId , pStatusId , pPaymentTypeId ,pCurrencyTypeId , pProjectNumber , @ccId , pChangeType , pCreated , pContactName , pLocation , pAdvance , pTimeLimit , pSettlementTimeLimit , pDeliveryTime , pincoterm , pProductsNumber , pFinancesNumber , pServicesNumber , pTotalProjectNumber, pCreatedByUsr, pDiscountNumber, pPaymentConditions);

     SELECT LAST_INSERT_ID();
  ELSE
     UPDATE codexProject
     SET clientId = pClientId, taxesTypeId = pTaxesTypeId, statusId = pStatusId, paymentTypeId = pPaymentTypeId
         , currencyTypeId = pCurrencyTypeId, projectNumber = pProjectNumber, costCenterId = @ccId
         , changeType = pChangeType, created = pCreated, contactName = pContactName, location = pLocation
         , advance = pAdvance, timeLimit = pTimeLimit, settlementTimeLimit = pSettlementTimeLimit
         , deliveryTime = pDeliveryTime, incoterm = pincoterm, productsNumber = pProductsNumber
         , financesNumber = pFinancesNumber, servicesNumber = pServicesNumber, totalProjectNumber = pTotalProjectNumber
         , discountNumber = pDiscountNumber
         , paymentConditions = pPaymentConditions
		 , modifiedByUsr = pModifiedByUsr, modified = NOW()
     WHERE _id = pProjectId;

     SELECT pProjectId;
  END IF;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetLocationsByZipCode
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetLocationsByZipCode$$
CREATE PROCEDURE blackstarDb.`GetLocationsByZipCode`(pZipCode VARCHAR(5))
BEGIN

   SELECT _id, zipCode, country, state, municipality, IF(city IS NULL OR city = '', municipality, city) AS city, neighborhood
   FROM blackstarConst.location
   WHERE zipCode = pZipCode;

END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexUpsertProspect
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexUpsertProspect$$
CREATE PROCEDURE blackstarDb.`CodexUpsertProspect`(pClientId INT, pClientTypeId int(2), pClientOriginId int(2), pCstId int(11)
                                                 , pIsProspect tinyint(4), pRfc varchar(13), pCorporateName text, pTradeName text, pPhoneArea varchar(3), pPhoneNumber varchar(10)
                                                 , pPhoneExtension varchar(6), pPhoneAreaAlt varchar(3), pPhoneNumberAlt varchar(10), pPhoneExtensionAlt varchar(6)
                                                 , pEmail varchar(60), pEmailAlt varchar(60), pStreet text, pIntNumber varchar(5), pExtNumber varchar(5)
                                                 , pZipCode int(5), pCountry text, pState varchar(20), pMunicipality text, pCity text, pNeighborhood text
                                                 , pContactName text, pCurp varchar(18), pRetention varchar(20))
BEGIN
  DECLARE existsId INTEGER;
  
  SET existsId = (SELECT COUNT(*) FROM codexClient WHERE _id = pClientId);
  IF (existsId = 0) THEN
     INSERT INTO codexClient (_id, clientTypeId, clientOriginId, cstId, isProspect, rfc, corporateName,
                 tradeName, phoneArea, phoneNumber, phoneExtension, phoneAreaAlt, phoneNumberAlt,
                 phoneExtensionAlt, email, emailAlt, street, intNumber, extNumber, zipCode, country,
                 state, municipality, city, neighborhood, contactName, curp, retention)
                 VALUES
                 (pClientId, pClientTypeId, pClientOriginId, pCstId, pIsProspect, pRfc, pCorporateName,
                 pTradeName, pPhoneArea, pPhoneNumber, pPhoneExtension, pPhoneAreaAlt, pPhoneNumberAlt,
                 pPhoneExtensionAlt, pEmail, pEmailAlt, pStreet, pIntNumber, pExtNumber, pZipCode, pCountry,
                 pState, pMunicipality, pCity, pNeighborhood, pContactName, pCurp, pRetention);
  END IF;
  IF (existsId > 0) THEN
      UPDATE codexClient SET _id = pClientId, clientTypeId = pClientTypeId, clientOriginId = pClientOriginId
           , cstId = pCstId, isProspect = pIsProspect, rfc = pRfc, corporateName = pCorporateName
           , tradeName = pTradeName, phoneArea = pPhoneArea, phoneNumber = pPhoneNumber, phoneExtension = pPhoneExtension
           , phoneAreaAlt = pPhoneAreaAlt, phoneNumberAlt = pPhoneNumberAlt, phoneExtensionAlt = pPhoneExtensionAlt
           , email = pEmail, emailAlt = pEmailAlt, street = pStreet, intNumber = pIntNumber, extNumber = pExtNumber
           , zipCode = pZipCode, country = pCountry, state = pState, municipality = pMunicipality, city = pCity
           , neighborhood = pNeighborhood, contactName = pContactName, curp = pCurp, retention = pRetention
      WHERE _id = pClientId;
  END IF;
	
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetAllClients
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetAllClients$$
CREATE PROCEDURE blackstarDb.`CodexGetAllClients`()
BEGIN
  SELECT _id id, clientTypeId clientTypeId, clientOriginId clientOriginId, cstId cstId
         , isProspect isProspect, rfc rfc, corporateName corporateName, tradeName tradeName
         , phoneArea phoneArea, phoneNumber phoneNumber, phoneExtension phoneExtension
         , phoneAreaAlt phoneAreaAlt, phoneNumberAlt phoneNumberAlt, phoneExtensionAlt phoneExtensionAlt
         , email email, emailAlt emailAlt, street street, intNumber intNumber, extNumber extNumber
         , zipCode zipCode, country country, state state, municipality municipality, city city
         , neighborhood neighborhood, contactName contactName, curp curp, retention retention
  FROM codexClient
  ORDER BY corporateName;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetClientById
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetClientById$$
CREATE PROCEDURE blackstarDb.`CodexGetClientById`(pClientId int(11))
BEGIN
  SELECT _id id, clientTypeId clientTypeId, clientOriginId clientOriginId, cstId cstId
         , isProspect isProspect, rfc rfc, corporateName corporateName, tradeName tradeName
         , phoneArea phoneArea, phoneNumber phoneNumber, phoneExtension phoneExtension
         , phoneAreaAlt phoneAreaAlt, phoneNumberAlt phoneNumberAlt, phoneExtensionAlt phoneExtensionAlt
         , email email, emailAlt emailAlt, street street, intNumber intNumber, extNumber extNumber
         , zipCode zipCode, country country, state state, municipality municipality, city city
         , neighborhood neighborhood, contactName contactName, curp curp, retention retention
  FROM codexClient
  WHERE _id = pClientId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetAllProjects
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetAllProjectsByUsr$$
CREATE PROCEDURE blackstarDb.`CodexGetAllProjectsByUsr`(pUserId int(11))
BEGIN
SELECT cp._id id, cp.projectNumber projectNumber, cp.clientId clientId, cp.taxesTypeId taxesTypeId, cp.statusId statusId
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, cst.name statusDescription
      , cc.tradeName clientDescription, ccc.costCenter costCenter, cp.changeType changeType, cp.created created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.incoterm incoterm
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber, cp.createdBy createdBy, cp.createdByUsr createdByUsr
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr
FROM codexProject cp
  INNER JOIN codexClient cc ON cp.clientId = cc._id
  INNER JOIN codexStatusType cst ON cp.statusId = cst._id
  INNER JOIN codexPaymentType cpt ON cp.paymentTypeId = cpt._id
  INNER JOIN codexCurrencyType cct ON cp.currencyTypeId = cct._id
  INNER JOIN codexCostCenter ccc ON cp.costCenterId = ccc._id
WHERE 
      if(pUserId = 0, 1=1, cc.cstId = pUserId);
      
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetProjectsByStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetProjectsByStatus$$
CREATE PROCEDURE blackstarDb.`CodexGetProjectsByStatus`(pStatusId INT(2))
BEGIN
SELECT cp._id id, cp.projectNumber projectNumber, cp.clientId clientId, cp.taxesTypeId taxesTypeId, cp.statusId statusId
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, cst.name statusDescription
      , cc.tradeName clientDescription, ccc.costCenter costCenter, cp.changeType changeType, cp.created created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.incoterm incoterm
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber, cp.createdBy createdBy, cp.createdByUsr createdByUsr
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr
FROM codexProject cp, codexClient cc, codexStatusType cst, codexPaymentType cpt, codexCurrencyType cct, codexCostCenter ccc
WHERE cp.statusId = cst._id
      AND cp.clientId = cc._id
      AND cp.paymentTypeId = cpt._id
      AND cp.currencyTypeId = cct._id
      AND cp.costCenterId = ccc._id
      AND cp.statusId = pStatusId;
END$$ 

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetProjectsByStatusAndUser
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetProjectsByStatusAndUser$$
CREATE PROCEDURE blackstarDb.`CodexGetProjectsByStatusAndUser`(pStatusId INT(2), pUserId INT(11))
BEGIN
SELECT cp._id id, cp.projectNumber projectNumber, cp.clientId clientId, cp.taxesTypeId taxesTypeId, cp.statusId statusId
      , cp.paymentTypeId paymentTypeId, cp.currencyTypeId currencyTypeId, cst.name statusDescription
      , cc.tradeName clientDescription, ccc.costCenter costCenter, cp.changeType changeType, cp.created created
      , cp.contactName contactName, cp.location location, cp.advance advance, cp.timeLimit timeLimit
      , cp.settlementTimeLimit settlementTimeLimit, cp.deliveryTime deliveryTime, cp.incoterm incoterm
      , cp.productsNumber productsNumber, cp.financesNumber financesNumber, cp.servicesNumber servicesNumber
      , cp.totalProjectNumber totalProjectNumber, cp.createdBy createdBy, cp.createdByUsr createdByUsr
      , cp. modified modified, cp.modifiedBy modifiedBy, cp.modifiedByUsr modifiedByUsr
FROM codexProject cp
  INNER JOIN codexClient cc ON cp.clientId = cc._id
  INNER JOIN codexStatusType cst ON cp.statusId = cst._id
  INNER JOIN codexPaymentType cpt ON cp.paymentTypeId = cpt._id
  INNER JOIN codexCurrencyType cct ON cp.currencyTypeId = cct._id
  INNER JOIN codexCostCenter ccc ON cp.costCenterId = ccc._id
WHERE 
      cc.cstId = pUserId
      AND cp.statusId = pStatusId;
END$$ 

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetEntriesByProject
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetEntriesByProject$$
CREATE PROCEDURE blackstarDb.`CodexGetEntriesByProject`(pProjectId int(11))
BEGIN
	SELECT cpe._id id, cpe.projectId projectId, cpe.entryTypeId entryTypeId, cpe.description description, 
         cpe.discount discount, cpe.totalPrice totalPrice, cpe.comments comments, cpet.name entryTypeDescription,
         cpe.qty qty, cpe.unitPrice unitPrice
    FROM codexProjectEntry cpe, codexProjectEntryTypes cpet
    WHERE projectId = pProjectId
          AND  cpe.entryTypeId = cpet._id;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetItemsByEntry
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetItemsByEntry$$
CREATE PROCEDURE blackstarDb.`CodexGetItemsByEntry`(pEntryId int(11))
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
  WHERE cdt.codexProjectId = pProjectId
        AND cdt.codexProjectId = cp._id
        AND cdt.deliverableTypeId = cdty._id
        AND cdt.userId = bu.blackstarUserId;
END$$  

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexAdvanceStatus
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexAdvanceStatus$$
CREATE PROCEDURE blackstarDb.`CodexAdvanceStatus`(pProjectId int(11), pStatusId INTEGER)
BEGIN

  DECLARE status INTEGER;
  SET status = (SELECT cp.statusId FROM codexProject cp WHERE cp._id =  pProjectId);
  UPDATE codexProject SET statusId = pStatusId WHERE _id = pProjectId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetsSalesManger
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetSalesManger$$
CREATE PROCEDURE blackstarDb.`CodexGetSalesManger`()
BEGIN

  SELECT bu.blackstarUserId blackstarUserId, bu.email userEmail, bu.name userName
  FROM blackstarUser_userGroup bug
    INNER JOIN userGroup ug ON  bug.userGroupId = ug.userGroupId
    INNER JOIN blackstarUser bu ON bug.blackstarUserId = bu.blackstarUserId
  WHERE ug.externalId = 'sysSalesManager';
       
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexGetProjectRisponsable
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexGetProjectRisponsable$$
CREATE PROCEDURE blackstarDb.`CodexGetProjectRisponsable`(pProjectId int(11))
BEGIN
SELECT bu.blackstarUserId blackstarUserId, bu.email userEmail, bu.name userName
FROM blackstarUser bu, workTeam wt
WHERE wt.codexProjectId = pProjectId
     AND wt.workerRoleTypeId = 1
     AND bu.blackstarUserId = wt.blackstarUserId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexCleanProjectDependencies
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexCleanProjectDependencies$$
CREATE PROCEDURE blackstarDb.`CodexCleanProjectDependencies`(pProjectId int(11))
BEGIN
   DELETE FROM codexEntryItem
   WHERE entryId IN (SELECT _id FROM codexProjectEntry WHERE projectId = pProjectId);
   DELETE FROM codexProjectEntry WHERE projectId = pProjectId;
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertPriceProposal
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexInsertPriceProposal$$
CREATE PROCEDURE blackstarDb.`CodexInsertPriceProposal`(pProjectId int(11),pPriceProposalNumber varchar(50), pClientId int(11), pTaxesTypeId int(1), pPaymentTypeId int(1),pCurrencyTypeId int(2), pCostCenter varchar(8), pChangeType float, pCreated varchar(40), pContactName text, pLocation varchar(400), pAdvance FLOAT(15,2), pTimeLimit int(3), pSettlementTimeLimit int(3), pDeliveryTime int(3), pincoterm varchar(5), pProductsNumber FLOAT(15,2), pFinancesNumber FLOAT(15,2), pServicesNumber FLOAT(15,2), pTotalProjectNumber FLOAT(15,2), pDocumentId VARCHAR(2000))
BEGIN
     INSERT INTO codexPriceProposal (projectId, priceProposalNumber, clientId , taxesTypeId , paymentTypeId ,currencyTypeId  , costCenter , changeType , created , contactName , location , advance , timeLimit , settlementTimeLimit , deliveryTime , incoterm , productsNumber , financesNumber , servicesNumber , totalProjectNumber, documentId)
     VALUES (pProjectId, pPriceProposalNumber, pClientId , pTaxesTypeId , pPaymentTypeId ,pCurrencyTypeId , pCostCenter , pChangeType , pCreated , pContactName , pLocation , pAdvance , pTimeLimit , pSettlementTimeLimit , pDeliveryTime , pincoterm , pProductsNumber , pFinancesNumber , pServicesNumber , pTotalProjectNumber, pDocumentId);

     SELECT LAST_INSERT_ID();     
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertPriceProposalEntryItem
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexInsertPriceProposalEntryItem$$
CREATE PROCEDURE blackstarDb.`CodexInsertPriceProposalEntryItem`(pPriceProposalEntryId int(11), pItemTypeId int(11), pReference TEXT, pDescription TEXT, pQuantity FLOAT(10,2), pPriceByUnit FLOAT(15,2), pDiscount FLOAT(15,2), pTotalPrice FLOAT(15,2), pComments TEXT)
BEGIN
    INSERT INTO codexPriceProposalItem (priceProposalEntryId, itemTypeId, reference, description, quantity, priceByUnit, discount, totalPrice, comments)
    VALUES (pPriceProposalEntryId, pItemTypeId, pReference, pDescription, pQuantity, pPriceByUnit, pDiscount, pTotalPrice, pComments);  

    SELECT LAST_INSERT_ID();     
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.CodexInsertPriceProposalEntry
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.CodexInsertPriceProposalEntry$$
CREATE PROCEDURE blackstarDb.`CodexInsertPriceProposalEntry`(pPriceProposalId int(11), pEntryTypeId int(11), pDescription TEXT, pDiscount FLOAT(15,2), pTotalPrice FLOAT(15,2), pComments TEXT)
BEGIN
    INSERT INTO codexPriceProposalEntry (priceProposalId, entryTypeId, description, discount, totalPrice, comments)
     VALUES (pPriceProposalId, pEntryTypeId, pDescription, pDiscount, pTotalPrice, pComments);

    SELECT LAST_INSERT_ID();     
END$$

-- -----------------------------------------------------------------------------
	-- blackstarDb.GetProposalNumberForProject
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetProposalNumberForProject$$
CREATE PROCEDURE blackstarDb.`GetProposalNumberForProject`(pProjectId Int(11))
BEGIN
	SELECT COUNT(*) + 1 FROM codexPriceProposal WHERE projectId = pProjectId;
END$$


-- -----------------------------------------------------------------------------
  -- blackstarDb.GetPriceProposalList
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.GetPriceProposalList$$
CREATE PROCEDURE blackstarDb.`GetPriceProposalList`(pProjectId Int(11))
BEGIN
  SELECT
    p.projectId AS projectId,
    p.priceProposalNumber AS priceProposalNumber,
    p.created AS created,
    c.corporateName AS name,
    p.contactName AS contactName,
    p.totalProjectNumber AS total,
    p.documentId AS documentId
  FROM codexPriceProposal p
    INNER JOIN codexClient c ON c._id = p.clientId
  WHERE projectId = pProjectId 
    AND documentId IS NOT NULL
  ORDER BY created;

END$$

-- -----------------------------------------------------------------------------
	-- FIN DE LOS STORED PROCEDURES
-- -----------------------------------------------------------------------------
DELIMITER ;
