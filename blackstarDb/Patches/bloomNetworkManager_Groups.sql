USE blackstarDb;

Call blackstarDb.UpsertUser('call-center@gposac.com.mx','Call Center', NULL);
Call blackstarDb.CreateuserGroup('sysCallCenterGroup','Call Center','call-center@gposac.com.mx');
Call blackstarDb.UpsertUser('compras@gposac.com.mx','Compras', NULL);
Call blackstarDb.CreateuserGroup('sysPurchaseGroup','Compras','compras@gposac.com.mx');
Call blackstarDb.UpsertUser('capital-humano@gposac.com.mx','Capital Humano', NULL);
Call blackstarDb.CreateuserGroup('sysHRGroup','Compras','capital-humano@gposac.com.mx');

UPDATE userGroup SET 
	externalId = 'sysNetworkEng'
WHERE externalId = 'sysNetworkManager';

UPDATE userGroup SET 
	externalId = 'sysNetworkManager'
WHERE externalId = 'sysNetworkMan';

UPDATE bloomAdvisedGroup SET 
	userGroup = 'sysNetworkEng'
WHERE serviceTypeId = 11 AND userGroup = 'sysNetworkManager';

UPDATE bloomAdvisedGroup SET
	userGroup = 'sysCallCenterGroup'
WHERE userGroup = 'sysCallCenter' AND workerRoleTypeId = 2;

UPDATE bloomAdvisedGroup SET
	userGroup = 'sysPurchaseGroup'
WHERE userGroup = 'sysPurchase' AND workerRoleTypeId = 2;

UPDATE bloomAdvisedGroup SET
	userGroup = 'sysHRGroup'
WHERE userGroup = 'sysHR' AND workerRoleTypeId = 2;

UPDATE bloomTicketTeam SET
	blackstarUserId = 29968
WHERE ticketId IN(35,37) AND blackstarUserId = 29959;

INSERT INTO bloomAdvisedGroup(applicantAreaId, serviceTypeId, userGroup, workerRoleTypeId) SELECT 2, 13, 'sysPurchaseGroup', 2;
