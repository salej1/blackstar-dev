USE blackstarDb;

CALL blackstarDb.UpsertUser('daniela.gutierrez@gposac.com.mx','Daniela Gutierrez');
CALL blackstarDb.CreateuserGroup('sysInvoicing','Facturacion','daniela.gutierrez@gposac.com.mx');
CALL blackstarDb.UpsertUser('pilar.cardenas@gposac.com.mx','Pilar Cárdenas');
CALL blackstarDb.CreateuserGroup('sysInvoicing','Facturacion','pilar.cardenas@gposac.com.mx');

DELETE FROM blackstarUser_userGroup
WHERE userGroupId != (SELECT userGroupId FROM userGroup WHERE externalId = 'sysInvoicing')
	AND blackstarUserId IN (SELECT blackstarUserId FROM blackstarUser WHERE email IN('daniela.gutierrez@gposac.com.mx', 'pilar.cardenas@gposac.com.mx'));
