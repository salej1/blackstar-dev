USE blackstarDb;

CALL blackstarDb.UpsertUser('daniela.gutierrez@gposac.com.mx','Daniela Gutierrez');
CALL blackstarDb.CreateuserGroup('sysInvoicing','Facturacion','daniela.gutierrez@gposac.com.mx');