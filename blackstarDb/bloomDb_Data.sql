-- -----------------------------------------------------------------------------
-- Desc:Carga de datos inicial
-- Auth:oscar martinez
-- Date:22/06/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    AuthorDescription
-- --   --------   -------  ------------------------------------
-- 1    20/03/2014  DCB  	Version inicial. 
-- 2    08/05/2014  OMA  	ID secuencia tickets internos 
-- 3    08/05/2014  OMA  	Perfil Mesa de ayuda
-- 4    22/06/2014  OMA  	nueva actualizacion de perfiles y catalogos
-- ---------------------------------------------------------------------------
use blackstarDb;


DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.updateDataBloom$$
CREATE PROCEDURE blackstarDb.updateDataBloom()
BEGIN


-- -----------------------------------------------------------------------------
	-- SECUENCIA
-- -----------------------------------------------------------------------------
IF(SELECT COUNT(*) FROM blackstarDb.sequence WHERE sequenceTypeId='I') = 0 THEN
	INSERT INTO blackstarDb.sequence (sequenceTypeId,sequenceNumber) values('I',1);	
END IF;	


-- -----------------------------------------------------------------------------
	-- PERFILES
	
-- -----------------------------------------------------------------------------
IF(SELECT COUNT(*) FROM blackstarDb.usergroup WHERE externalId='sysHelpDeskManager') = 0 THEN 
	INSERT INTO blackstarDb.usergroup (externalId,name) values('sysHelpDeskManager','Mesa de ayuda (Ingenieria)'); 
END IF;
IF(SELECT COUNT(*) FROM blackstarDb.usergroup WHERE externalId='sysPurchaseManager') = 0 THEN 
	INSERT INTO blackstarDb.usergroup (externalId,name) values('sysPurchaseManager','Jefe de Compras'); 
END IF;
IF(SELECT COUNT(*) FROM blackstarDb.usergroup WHERE externalId='sysHRManage') = 0 THEN 
	INSERT INTO blackstarDb.usergroup (externalId,name) values('sysHRManage','Jefe de Capital Humano'); 
END IF;
IF(SELECT COUNT(*) FROM blackstarDb.usergroup WHERE externalId='sysNetworkManager') = 0 THEN 
	INSERT INTO blackstarDb.usergroup (externalId,name) values('sysNetworkManager','Ingeniero de Redes y Monitoreo'); 
END IF;
IF(SELECT COUNT(*) FROM blackstarDb.usergroup WHERE externalId='sysQAManager') = 0 THEN 
	INSERT INTO blackstarDb.usergroup (externalId,name) values('sysQAManager','Gerente de Calidad'); 
END IF;
IF(SELECT COUNT(*) FROM blackstarDb.usergroup WHERE externalId='sysSalesManager') = 0 THEN 
	INSERT INTO blackstarDb.usergroup (externalId,name) values('sysSalesManager','Gerente comercial'); 
END IF;
IF(SELECT COUNT(*) FROM blackstarDb.usergroup WHERE externalId='sysCeo') = 0 THEN 
	INSERT INTO blackstarDb.usergroup (externalId,name) values('sysCeo','Direccion'); 
END IF;
IF(SELECT COUNT(*) FROM blackstarDb.usergroup WHERE externalId='sysPurchase') = 0 THEN 
	INSERT INTO blackstarDb.usergroup (externalId,name) values('sysPurchase','Compras'); 
END IF;
IF(SELECT COUNT(*) FROM blackstarDb.usergroup WHERE externalId='sysHR') = 0 THEN 
	INSERT INTO blackstarDb.usergroup (externalId,name) values('sysHR','Capital Humano'); 
END IF;
IF(SELECT COUNT(*) FROM blackstarDb.usergroup WHERE externalId='sysQA') = 0 THEN 
	INSERT INTO blackstarDb.usergroup (externalId,name) values('sysQA','Calidad'); 
END IF;




-- -----------------------------------------------------------------------------
	-- CATALOGS
-- -----------------------------------------------------------------------------


INSERT INTO bloomWorkerRoleType VALUES (1,'Responsable', 'Responsable de dar seguimiento al Ticket');
INSERT INTO bloomWorkerRoleType VALUES (2,'Colaborador', 'Personal de apoyo');

INSERT INTO bloomStatusType VALUES (1,'Abierto', 'Ingreso de solicitud');
INSERT INTO bloomStatusType VALUES (2,'En proceso', 'Asignado, en proceso de solucion');
INSERT INTO bloomStatusType VALUES (3,'Suspendido', 'Suspendido');
INSERT INTO bloomStatusType VALUES (4,'Cancelado', 'Cancelado');
INSERT INTO bloomStatusType VALUES (5,'Cerrado', 'Cerrado');



-- lista solicitantes
INSERT INTO blackstarDb.bloomApplicantArea VALUES (1,'Ventas', 'Ventas');
INSERT INTO blackstarDb.bloomApplicantArea VALUES (2,'Implementación y Servicio', 'Implementación y Servicio');
INSERT INTO blackstarDb.bloomApplicantArea VALUES (3,'Gerentes o Coordinadoras al Area de Compras', 'Gerentes o Coordinadoras al Area de Compras');
INSERT INTO blackstarDb.bloomApplicantArea VALUES (4,'Personal con gente a su cargo', 'Personal con gente a su cargo');
INSERT INTO blackstarDb.bloomApplicantArea VALUES (5,'General', 'General');
 
   
-- Solicitante:Ventas, Lista de tipo de servicios
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (1,1,7,'Levantamiento', 'Levantamiento');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (2,1,7,'Apoyo de Ingeniero de Soprte o Apoyo de Servicio', 'Apoyo de Ingeniero de Soprte o Apoyo de Servicio');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (3,1,4,'Elaboración de Diagrama CAD', 'Elaboración de Diagrama CAD');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (4,1,4,'Elaboración de Plano e Imágenes 3D del SITE', 'Elaboración de Plano e Imágenes 3D del SITE');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (5,1,4,'Realización de Cédula de Costos', 'Realización de Cédula de Costos');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (6,1,2,'Pregunta técnica', 'Pregunta técnica');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (7,1,4,'Solicitud de Aprobación de Proyectos Mayores a 50KUSD y con mínimo 3 líneas diferentes', 'Solicitud de Aprobación de Proyectos Mayores a 50KUSD y con mínimo 3 líneas diferentes');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (8,1,4,'Solicitud de Precio de Lista de algún producto que no se encuentre en lista de precio', 'Solicitud de Precio de Lista de algún producto que no se encuentre en lista de precio');
                                                                   
                                                                   
-- Solicitante:Implementación y Servicio, Lista de tipo de servicios                                                                
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (9, 2,4,'Elaboración de Diagrama CAD o de Plano en 3D', 'Elaboración de Diagrama CAD o de Plano en 3D');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (10,2,4,'Reporte de Cálidad de Energía', 'Reporte de Cálidad de Energía');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (11,2,8,'Soporte en Monitoreo y/o desarrollo de mapeo', 'Soporte en Monitoreo y/o desarrollo de mapeo');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (12,2,2,'Pregunta técnica', 'Pregunta técnica');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (13,2,8,'Requisición de Parte o Refacción', 'Requisición de Parte o Refacción');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (14,2,4,'Solicitud de Precio de Costo', 'Solicitud de Precio de Costo');
                                                  
                                                  
-- Solicitante:Gerentes o Coordinadoras al Area de Compras, Lista de tipo de servicios                                                   
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (15,3,11,'Requerimiento de Compra de Activos', 'Requerimiento de Compra de Activos');
                                                      
-- Solicitante:Personal con gente a su cargo, Lista de tipo de servicios                                                
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (16,4,5,'Aumento de sueldo', 'Aumento de sueldo');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (17,4,30,'Contratación de personal', 'Contratación de personal');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (18,4,5,'Nueva Creación', 'Nueva Creación');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (19,4,3,'Finiquito', 'Finiquito');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (20,4,2,'Acta Adminsitrativa', 'Acta Adminsitrativa');
                                                      
                                                      
-- Solicitante:General, Lista de tipo de servicios                                                    
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (21,5,5,'Req. de Curso', 'Req. de Curso');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (22,5,5,'Modificación del SGC', 'Modificación del SGC');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (23,5,5,'Sugerencia de Modificación', 'Sugerencia de Modificación');
INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description) VALUES (24,5,4,'Problemas con telefonía o con la red', 'Problemas con telefonía o con la red');
									  


INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (1,1,'CheckList de levantamiento', 'CheckList de levantamiento');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (2,1,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (3,2,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (4,3,'Diagrama en CAD', 'Diagrama en CAD');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (5,3,'Diagrama en PDF', 'Diagrama en PDF');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (6,3,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (7,4,'Imágenes de Plano en 3D', 'Imágenes de Plano en 3D');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (8,4,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (9,5,'Cédula de Costos', 'Cédula de Costos');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (10,5,'Cédula de Costos', 'Cédula de Costos');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (11,6,'Respuesta', 'Respuesta');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (12,6,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (13,7,'Aprobación o retroalimentación', 'Aprobación o retroalimentación');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (14,7,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (15,8,'Precio de Lista y Condiciones comerciales', 'Precio de Lista y Condiciones comerciales');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (16,8,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (17,9,'Diagrama en CAD o Imágenes de Plano en 3D', 'Diagrama en CAD o Imágenes de Plano en 3D');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (18,9,'Diagrama en PDF', 'Diagrama en PDF');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (19,9,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (20,10,'Reporte de Cálidad', 'Reporte de Cálidad');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (21,10,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (22,11,'Respuesta o desarrollo', 'Respuesta o desarrollo');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (23,11,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (24,12,'Respuesta', 'Respuesta');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (25,12,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (26,13,'Entrega de la parte', 'Entrega de la parte');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (27,13,'Orden de Compra', 'Orden de Compra');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (28,13,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (29,14,'Precio de Costo', 'Precio de Costo');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (30,14,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (31,15,'Entrega de Activos', 'Entrega de Activos');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (32,15,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (33,16,'Respuesta del incremento', 'Respuesta del incremento');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (34,16,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (35,17,'Nuevo personal', 'Nuevo personal');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (36,17,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (37,18,'Respuesta', 'Respuesta');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (38,18,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (39,19,'Baja del colaborador', 'Baja del colaborador');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (40,19,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (41,20,'Acta Administrativa personalizada', 'Acta Administrativa personalizada');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (42,21,'RESPUESTA DEL REQ.', 'RESPUESTA DEL REQ.');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (43,22,'RESPUESTA DEL REQ.', 'RESPUESTA DEL REQ.');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (44,23,'RESPUESTA DEL REQ.', 'RESPUESTA DEL REQ.');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (45,24,'Respuesta', 'Respuesta');
INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (46,24,'Encuesta de Satisfacción', 'Encuesta de Satisfacción');

insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,1,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,1,'sysSalesManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,2,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,2,'sysSalesManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,3,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,3,'sysSalesManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,4,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,4,'sysSalesManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,5,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,5,'sysSalesManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,6,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,6,'sysSalesManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,7,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,7,'sysSalesManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,8,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(1,8,'sysSalesManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(2,9,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(2,10,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(2,11,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(2,11,'sysNetworkManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(2,12,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(2,13,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(2,13,'sysPurchase');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(2,14,'sysHelpDeskManager');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(3,15,'sysPurchase');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(4,16,'sysHR');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(4,16,'sysCeo');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(4,17,'sysHR');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(4,17,'sysCeo');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(4,18,'sysHR');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(4,18,'sysCeo');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(4,19,'sysHR');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(4,19,'sysCeo');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(4,20,'sysHR');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(4,20,'sysCeo');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(5,21,'sysHR');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(5,21,'sysCeo');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(5,22,'sysQA');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(5,22,'sysCeo');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(5,23,'sysQA');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(5,23,'sysCeo');
insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup) values(5,24,'sysPurchase');


-- creacion de usuarios segun la confi,applicantAreaIdguracion del excel en la columna de enterados.
Call blackstarDb.UpsertUser('nicolas.andrade@gposac.com.mx','Nicolas Andrade');
Call blackstarDb.CreateUserGroup('sysSalesManager','Gerente comercial','nicolas.andrade@gposac.com.mx');
     
Call blackstarDb.UpsertUser('mesa-de-ayuda@gposac.com.mx','Mesa de ayuda');
Call blackstarDb.CreateUserGroup('sysHelpDeskManager','Mesa de ayuda (Ingenieria)','mesa-de-ayuda@gposac.com.mx');
     
Call blackstarDb.UpsertUser('jose.osorio@gposac.com.mx','Ingeniero de Redes y Monitoreo');
Call blackstarDb.CreateUserGroup('sysNetworkManager','Ingeniero de Redes y Monitoreo','jose.osorio@gposac.com.mx');
  
Call blackstarDb.UpsertUser('compras@gposac.com.mx','Compras');
Call blackstarDb.CreateUserGroup('sysPurchase','Compras','compras@gposac.com.mx');
  
Call blackstarDb.UpsertUser('capital.humano@gposac.com.mx','Capital Humano');
Call blackstarDb.CreateUserGroup('sysHR','Capital Humano','capital.humano@gposac.com.mx');
   
Call blackstarDb.UpsertUser('direccion@gposac.com.mx','Direccion');
Call blackstarDb.CreateUserGroup('sysCeo','Direccion','direccion@gposac.com.mx');
  
Call blackstarDb.UpsertUser('calidad@gposac.com.mx','Calidad');
Call blackstarDb.CreateUserGroup('sysQA','Calidad','calidad@gposac.com.mx');


END$$

DELIMITER ;

CALL blackstarDb.updateDataBloom();

DROP PROCEDURE blackstarDb.updateDataBloom;