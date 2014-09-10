-- -----------------------------------------------------------------------------
-- Desc:Carga de datos inicial
-- Auth:oscar martinez
-- Date:22/06/2014
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    AuthorDescription
-- --   --------   -------  ----------------------------------------------------
-- 1    20/03/2014  DCB  	Version inicial. 
-- --   --------   -------  ----------------------------------------------------
-- 2    08/05/2014  OMA  	ID secuencia tickets internos 
-- --   --------   -------  ----------------------------------------------------
-- 3    08/05/2014  OMA  	Perfil Mesa de ayuda
-- --   --------   -------  ----------------------------------------------------
-- 4    22/06/2014  OMA  	nueva actualizacion de perfiles y catalogos
-- --   --------   -------  ----------------------------------------------------
-- 5 	11/07/2014	SAG 	Script para poblar hidden en bloomServiceType
-- --   --------   -------  ----------------------------------------------------
-- 6	09/09/2014	SAG 	Se establece SAC600 como inicio secuencia de requisiciones
-- -----------------------------------------------------------------------------
use blackstarDb;


DELIMITER $$

DROP PROCEDURE IF EXISTS blackstarDb.updateDataBloom$$
CREATE PROCEDURE blackstarDb.updateDataBloom()
BEGIN
-- Estableciendo contador inicial para Requisiciones
IF(SELECT sequenceNumber FROM blackstarDb.sequence WHERE sequenceTypeId='I') < 600 THEN
	UPDATE blackstarDb.sequence SET sequenceNumber = 600 WHERE sequenceTypeId='I';
END IF;

-- Agregando FollowUpReferenceType
IF(SELECT count(*) FROM blackstarDb.followUpReferenceType WHERE followUpReferenceTypeId = 'R') = 0 THEN
	INSERT INTO blackstarDb.followUpReferenceType(followUpReferenceTypeId, followUpReferenceType)
	SELECT 'R', 'Requisicion';
END IF;

-- Poblando bloomServiceType.hidden
UPDATE bloomServiceType 
SET
	hidden = 1 
WHERE _id in(16,17,18,19,20,21);

-- -----------------------------------------------------------------------------
	-- SECUENCIA
-- -----------------------------------------------------------------------------
IF(SELECT COUNT(*) FROM blackstarDb.sequence WHERE sequenceTypeId='I') = 0 THEN
	INSERT INTO blackstarDb.sequence (sequenceTypeId,sequenceNumber) values('I',1);	
END IF;	

-- -----------------------------------------------------------------------------
	-- CATALOGOS
-- -----------------------------------------------------------------------------

IF(SELECT count(*) FROM bloomWorkerRoleType) = 0 THEN
	INSERT INTO bloomWorkerRoleType VALUES (1,'Responsable', 'Responsable de dar seguimiento al Ticket');
	INSERT INTO bloomWorkerRoleType VALUES (2,'Colaborador', 'Personal de apoyo');
END IF;

IF(SELECT count(*) FROM bloomStatusType) = 0 THEN
	INSERT INTO bloomStatusType VALUES (1,'Abierto', 'Ingreso de solicitud');
	INSERT INTO bloomStatusType VALUES (2,'En proceso', 'Asignado, en proceso de solucion');
	INSERT INTO bloomStatusType VALUES (3,'Retrasado', 'Retrasado');
	INSERT INTO bloomStatusType VALUES (4,'Cancelado', 'Cancelado');
	INSERT INTO bloomStatusType VALUES (5,'Resuelto', 'Resuelto');
	INSERT INTO bloomStatusType VALUES (6,'Cerrado', 'Cerrado');
END IF;

-- lista solicitantes
IF(SELECT count(*) FROM bloomApplicantArea) = 0 THEN
	INSERT INTO blackstarDb.bloomApplicantArea VALUES (1,'Ventas', 'Ventas');
	INSERT INTO blackstarDb.bloomApplicantArea VALUES (2,'Implementacion y Servicio', 'Implementacion y Servicio');
	INSERT INTO blackstarDb.bloomApplicantArea VALUES (3,'Gerentes o Coordinadoras al Area de Compras', 'Gerentes o Coordinadoras al Area de Compras');
	INSERT INTO blackstarDb.bloomApplicantArea VALUES (4,'Personal con gente a su cargo', 'Personal con gente a su cargo');
	INSERT INTO blackstarDb.bloomApplicantArea VALUES (5,'General', 'General');
END IF;
 
-- Lista de Areas de servicio
IF(SELECT count(*) FROM bloomServiceArea) = 0 THEN
	INSERT INTO blackstarDb.bloomServiceArea(bloomServiceAreaId, bloomServiceArea) VALUES('I','Ingenieria');
	INSERT INTO blackstarDb.bloomServiceArea(bloomServiceAreaId, bloomServiceArea) VALUES('C','Compras');
	INSERT INTO blackstarDb.bloomServiceArea(bloomServiceAreaId, bloomServiceArea) VALUES('R','Redes');
	INSERT INTO blackstarDb.bloomServiceArea(bloomServiceAreaId, bloomServiceArea) VALUES('H','Capital Humano');
	INSERT INTO blackstarDb.bloomServiceArea(bloomServiceAreaId, bloomServiceArea) VALUES('A','Calidad');
END IF;   

-- Solicitante:Ventas, Lista de tipo de servicios
IF(SELECT count(*) FROM bloomServiceType) = 0 THEN
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (1,1,7,'Levantamiento', 'Levantamiento','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (2,1,7,'Apoyo de Ingeniero de Soprte o Apoyo de Servicio', 'Apoyo de Ingeniero de Soprte o Apoyo de Servicio','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (3,1,4,'Elaboracion de Diagrama CAD', 'Elaboracion de Diagrama CAD','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (4,1,4,'Elaboracion de Plano e Imagenes 3D del SITE', 'Elaboracion de Plano e Imagenes 3D del SITE','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (5,1,4,'Realizacion de Cedula de Costos', 'Realizacion de Cedula de Costos','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (6,1,2,'Pregunta tecnica', 'Pregunta tecnica','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (7,1,4,'Solicitud de Aprobacion de Proyectos Mayores a 50KUSD y con minimo 3 lineas diferentes', 'Solicitud de Aprobacion de Proyectos Mayores a 50KUSD y con minimo 3 lineas diferentes','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (8,1,4,'Solicitud de Precio de Lista de algun producto que no se encuentre en lista de precio', 'Solicitud de Precio de Lista de algun producto que no se encuentre en lista de precio','I');

                                                                   
-- Solicitante:Implementacion y Servicio, Lista de tipo de servicios                                  
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (9, 2,4,'Elaboracion de Diagrama CAD o de Plano en 3D', 'Elaboracion de Diagrama CAD o de Plano en 3D','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (10,2,4,'Reporte de Calidad de Energia', 'Reporte de Calidad de Energia','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (11,2,8,'Soporte en Monitoreo y/o desarrollo de mapeo', 'Soporte en Monitoreo y/o desarrollo de mapeo','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (12,2,2,'Pregunta tecnica', 'Pregunta tecnica','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (13,2,8,'Requisicion de Parte o Refaccion', 'Requisicion de Parte o Refaccion','I');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (14,2,4,'Solicitud de Precio de Costo', 'Solicitud de Precio de Costo','I');
                                                  
                                                  
-- Solicitante:Gerentes o Coordinadoras al Area de Compras, Lista de tipo de servicios                                                   
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (15,3,15,'Requerimiento de Compra de Activos', 'Requerimiento de Compra de Activos','C');
                                                      
-- Solicitante:Personal con gente a su cargo, Lista de tipo de servicios                                                
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (16,4,5,'Aumento de sueldo', 'Aumento de sueldo','H');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (17,4,30,'Contratacion de personal', 'Contratacion de personal','H');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (18,4,5,'Nueva Creacion', 'Nueva Creacion','H');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (19,4,3,'Finiquito', 'Finiquito','H');
	INSERT INTO blackstarDb.bloomServiceType (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (20,4,2,'Acta Adminsitrativa', 'Acta Adminsitrativa','H');
                                                      
                                                      
-- Solicitante:General, Lista de tipo de servicios                                                    
	INSERT INTO blackstarDb.bloomServiceType  (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (21,5,5,'Req. de Curso', 'Req. de Curso','H');
	INSERT INTO blackstarDb.bloomServiceType  (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (22,5,5,'Modificacion del SGC', 'Modificacion del SGC','A');
	INSERT INTO blackstarDb.bloomServiceType  (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (23,5,5,'Sugerencia de Modificacion', 'Sugerencia de Modificacion','A');
	INSERT INTO blackstarDb.bloomServiceType  (_id,applicantAreaId,responseTime,name,description,bloomServiceAreaId) VALUES (24,5,1,'Problemas con telefonia o con la red', 'Problemas con telefonia o con la red','R');
END IF;

IF(SELECT count(*) FROM bloomDeliverableType) = 0 THEN
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (1,1,'CheckList de levantamiento', 'CheckList de levantamiento');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (4,3,'Diagrama en CAD', 'Diagrama en CAD');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (5,3,'Diagrama en PDF', 'Diagrama en PDF');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (7,4,'Imagenes de Plano en 3D', 'Imagenes de Plano en 3D');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (9,5,'Cedula de Costos', 'Cedula de Costos');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (11,6,'Respuesta', 'Respuesta');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (13,7,'Aprobacion o retroalimentacion', 'Aprobacion o retroalimentacion');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (15,8,'Precio de Lista y Condiciones comerciales', 'Precio de Lista y Condiciones comerciales');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (17,9,'Diagrama en CAD o Imagenes de Plano en 3D', 'Diagrama en CAD o Imagenes de Plano en 3D');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (18,9,'Diagrama en PDF', 'Diagrama en PDF');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (20,10,'Reporte de Calidad', 'Reporte de Calidad');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (22,11,'Respuesta o desarrollo', 'Respuesta o desarrollo');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (24,12,'Respuesta', 'Respuesta');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (26,13,'Entrega de la parte', 'Entrega de la parte');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (27,13,'Orden de Compra', 'Orden de Compra');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (29,14,'Precio de Costo', 'Precio de Costo');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (31,15,'Entrega de Activos', 'Entrega de Activos');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (33,16,'Respuesta del incremento', 'Respuesta del incremento');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (35,17,'Nuevo personal', 'Nuevo personal');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (37,18,'Respuesta', 'Respuesta');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (39,19,'Baja del colaborador', 'Baja del colaborador');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (41,20,'Acta Administrativa personalizada', 'Acta Administrativa personalizada');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (42,21,'RESPUESTA DEL REQ.', 'RESPUESTA DEL REQ.');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (43,22,'RESPUESTA DEL REQ.', 'RESPUESTA DEL REQ.');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (44,23,'RESPUESTA DEL REQ.', 'RESPUESTA DEL REQ.');
	INSERT INTO blackstarDb.bloomDeliverableType(_id,serviceTypeId,name,description) VALUES (45,24,'Respuesta', 'Respuesta');
END IF;

IF(SELECT count(*) FROM bloomAdvisedGroup) = 0 THEN
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
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,24,'sysPurchaseManager',1);
	insert into blackstarDb.bloomAdvisedGroup(applicantAreaId,serviceTypeId,userGroup,workerRoleTypeId) values(5,24,'sysNetworkManager',1);
END IF;

-- Eliminando Encuesta de satisfaccion de salidas requeridas
DELETE FROM bloomDeliverableType WHERE name = 'Encuesta de Satisfaccion';


END$$

DELIMITER ;

CALL blackstarDb.updateDataBloom();

DROP PROCEDURE blackstarDb.updateDataBloom;