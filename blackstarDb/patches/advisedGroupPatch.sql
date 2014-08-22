	USE blackstarDb;

	TRUNCATE TABLE bloomAdvisedGroup;

	-- Levantamiento
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,1,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,1,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,1,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,1,'sysSalesManager',2);
	-- Apoyo de Ingeniero de Soprte o Apoyo de Servicio
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,2,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,2,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,2,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,2,'sysSalesManager',2);
	-- Elaboración de Diagrama CAD
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,3,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,3,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,3,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,3,'sysSalesManager',2);
	-- Elaboración de Plano e Imágenes 3D del SITE
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,4,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,4,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,4,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,4,'sysSalesManager',2);
	-- Realización de Cédula de Costos
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,5,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,5,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,5,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,5,'sysSalesManager',2);
	-- Pregunta técnica
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,6,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,6,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,6,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,6,'sysSalesManager',2);
	-- Solicitud de Aprobación de Proyectos Mayores a 50KUSD y con mínimo 3 líneas diferentes
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,7,'sysEngManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,7,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,7,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,7,'sysSalesManager',2);
	-- Solicitud de Precio de Lista de algún producto que no se encuentre en lista de precio 
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,8,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,8,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,8,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(1,8,'sysSalesManager',2);
	-- Elaboración de Diagrama CAD o de Plano en 3D
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,9,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,9,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,9,'sysHelpDeskGroup',2);
	-- Reporte de Calidad de Energía
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,10,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,10,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,10,'sysHelpDeskGroup',2);
	-- Soporte en Monitoreo y/o desarrollo de mapeo
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,11,'sysNetworkManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,11,'sysHelpDeskGroup',2);
	-- Pregunta técnica
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,12,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,12,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,12,'sysHelpDeskGroup',2);
	-- Requisición de Parte o Refacción
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,13,'sysPurchaseManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,13,'sysPurchase',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,13,'sysHelpDeskGroup',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,13,'sysCallCenter',2);
	-- Solicitud de Precio de Costo
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,14,'sysSupportEng',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,14,'sysEngLead',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(2,14,'sysHelpDeskGroup',2);
	-- Requerimiento de Compra de Activos
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,15,'sysPurchaseManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,15,'sysPurchase',1);
	-- Aumento de sueldo
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,16,'sysHRManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,16,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,16,'sysHR',2);
	-- Contratación de personal
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,17,'sysHRManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,17,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,17,'sysHR',2);
	-- Nueva Creación
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,18,'sysHRManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,18,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,18,'sysHR',2);
	-- Finiquito
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,19,'sysHRManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,19,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(4,19,'sysHR',2);
	-- Acta Adminsitrativa
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,20,'sysHRManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,20,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,20,'sysHR',2);
	-- Req. de Curso
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,21,'sysHRManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,21,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,21,'sysHR',2);
	-- Modificación del SGC
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,22,'sysQAManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,22,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,22,'sysQA',2);
	-- Sugerencia de Modificación
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,23,'sysQAManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,23,'sysCeo',2);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,23,'sysQA',2);
	-- Problemas con telefonía o con la red
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(3,24,'sysPurchaseManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(3,24,'sysNetworkManager',1);
