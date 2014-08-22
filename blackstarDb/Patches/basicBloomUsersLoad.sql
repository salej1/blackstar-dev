
-- creacion de usuarios segun la confi,applicantAreaIdguracion del excel en la columna de enterados.
Call blackstarDb.UpsertUser('nicolas.andrade@gposac.com.mx','Nicolas Andrade', NULL);
Call blackstarDb.CreateuserGroup('sysSalesManager','Gerente comercial','nicolas.andrade@gposac.com.mx');
     
Call blackstarDb.UpsertUser('mesa-de-ayuda@gposac.com.mx','Mesa de ayuda', NULL);
Call blackstarDb.CreateuserGroup('sysHelpDeskGroup','Mesa de ayuda','mesa-de-ayuda@gposac.com.mx');
     
Call blackstarDb.UpsertUser('roberto.osorio@gposac.com.mx','Roberto Osorio', NULL);
Call blackstarDb.CreateuserGroup('sysNetworkManager','Ingeniero de Redes y Monitoreo','roberto.osorio@gposac.com.mx');
  
Call blackstarDb.UpsertUser('martin.vazquez@gposac.com.mx','Martín Vazquez', 'luis.andrade@gposac.com.mx');
Call blackstarDb.CreateuserGroup('sysEngLead','Lider de Ingenieria','martin.vazquez@gposac.com.mx');

Call blackstarDb.UpsertUser('saul.andrade@gposac.com.mx','Saul Andrade', NULL);
Call blackstarDb.CreateuserGroup('sysSalesManager','Gerente comercial','saul.andrade@gposac.com.mx');
Call blackstarDb.CreateuserGroup('sysQAManager','Gerente de Calidad','saul.andrade@gposac.com.mx');

Call blackstarDb.UpsertUser('salvador.ruvalcaba@gposac.com.mx','Salvador Ruvalcaba', 'luis.andrade@gposac.com.mx');
Call blackstarDb.CreateuserGroup('sysEngManager','Gerente de Implementacion y Servicio','salvador.ruvalcaba@gposac.com.mx');

Call blackstarDb.UpsertUser('luis.andrade@gposac.com.mx','Luis Andrade', NULL);
Call blackstarDb.CreateuserGroup('sysCeo','Direccion','luis.andrade@gposac.com.mx');

Call blackstarDb.UpsertUser('cesar.castro@gposac.com.mx','Cesar Castro', 'miguel.garcia@gposac.com.mx');
Call blackstarDb.CreateuserGroup('sysPurchase','Compras','cesar.castro@gposac.com.mx');

Call blackstarDb.UpsertUser('miguel.garcia@gposac.com.mx','Miguel García', NULL);
Call blackstarDb.CreateuserGroup('sysPurchaseManager','Jefe de Compras','miguel.garcia@gposac.com.mx');

Call blackstarDb.UpsertUser('beatriz.preciado@gposac.com.mx','Beatriz Preciado', NULL);
Call blackstarDb.CreateuserGroup('sysHRManager','Jefe de Capital Humano','beatriz.preciado@gposac.com.mx');

Call blackstarDb.UpsertUser('alejandra.díaz@gposac.com.mx','Alejandra Díaz', 'saul.andrade@gposac.com.mx');
Call blackstarDb.CreateuserGroup('sysQA','Calidad','alejandra.díaz@gposac.com.mx');

Call blackstarDb.UpsertUser('luisa.lucas@gposac.com.mx','Luisa Lucas', 'luis.andrade@gposac.com.mx');
Call blackstarDb.CreateuserGroup('sysSupportEng','Ingeniero de Soporte','luisa.lucas@gposac.com.mx');

Call blackstarDb.UpsertUser('call-center@gposac.com.mx','Call Center', NULL);
Call blackstarDb.CreateuserGroup('sysCallCenter','Call Center','call-center@gposac.com.mx');

