-- -----------------------------------------------------------------------------
-- File:blackstarDb_startupData.sql
-- Name:blackstarDb_startupData
-- Desc:Hace una carga inicial de usuarios para poder operar el sistema
-- Auth:Sergio A Gomez
-- Date:22/10/2013
-- -----------------------------------------------------------------------------
-- Change History
-- -----------------------------------------------------------------------------
-- PR   Date    AuthorDescription
-- --   --------   -------  ------------------------------------
-- 1    22/10/2013  SAG  	Version inicial. Usuarios basicos de GPO Sac
-- --   --------   -------  ------------------------------------
-- 2    12/11/2013  SAG  	Version 1.1. Se agrega ExecuteTransfer
-- ---------------------------------------------------------------------------




-- -----------------------------------------------------------------------------
-- FIN - SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------

use blackstarDb;
-- -----------------------------------------------------------------------------
	-- BLOOM CATALOGS
-- -----------------------------------------------------------------------------
INSERT INTO bloomServiceType VALUES (1,'Levantamiento', 'Mesa de Ayuda detona a Ingeniero de Soporte vía coordinador administrativo', 7);
INSERT INTO bloomServiceType VALUES (2,'Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor', 'Mesa de Ayuda detona a Ingeniero de Soporte vía coordinador administrativo', 7);
INSERT INTO bloomServiceType VALUES (3,'Realización de Cedula de Costos', 'Mesa de Ayuda detona la acción y Recaba la Información de Cedula de Costos con el Ingeniero de Soporte así como el unifilar propuesto en borrador (papel), y esta lo pasa a CAD y lo manda al Ing. de Calidad Electrica y Climatización para su validación, una vez que esta se tenga se entregará toda la Información al consultor', 2);
INSERT INTO bloomServiceType VALUES (4,'Elaboración de Plano e Imagenes 3D del SITE (se deben anexar planos del edificio y dibujos de levantamiento)', 'Mesa de Ayuda realiza el dibujo en 3D en el programa floor planner', 2);
INSERT INTO bloomServiceType VALUES (5,'Popuesta de Unifilares', 'Mesa de Ayuda solicita el diagrama al Ingeniero de Calidad Electrica y Climatización en borrador y este lo pasa a CAD y PDF', 2);
INSERT INTO bloomServiceType VALUES (6,'Pregunta Técnica', 'Mesa de ayuda Responde si sabe la respuesta o pide apoyo a Ingeniero de Calidad Eléctrica y Climatización para Responderla', 1);
INSERT INTO bloomServiceType VALUES (7,'Solicitud de aprobación de proyectos mayores a 50 KUSD', 'La mesa de ayuda turnará el proyecto al Ingeniero de Calidad Eléctrica y Climatización y si es mayor a 100KUSD lo turnará al Gerente de Ingeniería', 2);
INSERT INTO bloomServiceType VALUES (8,'Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio', 'Mesa de Ayuda corrobora que la informaciòn este completa y retransmite la informaciòn a Compras quien entregarà el precio de lista, mesa de ayuda corrobora de nueva cuenta que la informaciòn sea correcta y se la retransmite al consultor', 2);
INSERT INTO bloomServiceType VALUES (9,'Solicitud de Costo', 'Mesa de Ayuda corrobora que la informaciòn este completa y retransmite la informaciòn a Compras quien entregarà el costo del material o producto, mesa de ayuda corrobora de nueva cuenta que la informaciòn sea correcta y se la retransmite al Ingeniero de Soporte o Tècnico de servicio', 2);
INSERT INTO bloomServiceType VALUES (10,'Solicitud de Parte o Refacciòn', 'Mesa de Ayuda corrobora que la informaciòn este completa y retransmite la informaciòn a Compras quien se encargarà de comprar la parte o refacciòn y entregarla en el lugar indicado. mesa de ayuda le darà seguimiento', 42);

INSERT INTO bloomWorkerRoleType VALUES (1,'Responsable', 'Responsable de dar seguimiento al Ticket');
INSERT INTO bloomWorkerRoleType VALUES (2,'Colaborador', 'Personal de apoyo');

INSERT INTO bloomStatusType VALUES (1,'Abierto', 'Ingreso de solicitud');
INSERT INTO bloomStatusType VALUES (2,'En proceso', 'Asignado, en proceso de solucion');
INSERT INTO bloomStatusType VALUES (3,'Suspendido', 'Suspendido');
INSERT INTO bloomStatusType VALUES (4,'Cancelado', 'Cancelado');
INSERT INTO bloomStatusType VALUES (5,'Cerrado', 'Cerrado');

INSERT INTO bloomApplicantArea VALUES (1,'Ventas', 'Ventas');
INSERT INTO bloomApplicantArea VALUES (2,'Gerente de Area', 'Gerente de Area');
INSERT INTO bloomApplicantArea VALUES (3,'Implementación y Servicio', 'Implementacion y Servicios');
INSERT INTO bloomApplicantArea VALUES (4,'Gerentes al Area de Compras', 'Gerentes al Area de Compras');
INSERT INTO bloomApplicantArea VALUES (5,'Otros', 'Otros');

INSERT INTO bloomDeliverableType VALUES (1,'CheckList de levantamiento', 'CheckList de levantamiento');
INSERT INTO bloomDeliverableType VALUES (2,'Encuesta de Satisfaccion', 'Encuesta de Satisfaccion');
INSERT INTO bloomDeliverableType VALUES (3,'Cédula de Costos y Validación del proyecto por parte de Ingeniería en caso de ser necesario', 'Cédula de Costos y Validación del proyecto por parte de Ingeniería en caso de ser necesario');
INSERT INTO bloomDeliverableType VALUES (4,'Unifilar eléctrico y/o Hidráulico a proponer al cliente ya validado en CAD y PDF', 'Unifilar eléctrico y/o Hidráulico a proponer al cliente ya validado en CAD y PDF');
INSERT INTO bloomDeliverableType VALUES (5,'Imagenes 3D del SITE propuesto', 'Imagenes 3D del SITE propuesto');
INSERT INTO bloomDeliverableType VALUES (6,'Propuesta de Unifilar en CAD y PDF', 'Propuesta de Unifilar en CAD y PDF');
INSERT INTO bloomDeliverableType VALUES (7,'Respuesta', 'Respuesta');
INSERT INTO bloomDeliverableType VALUES (8,'Visto Bueno del proyecto', 'Visto Bueno del proyecto');
INSERT INTO bloomDeliverableType VALUES (9,'Entrega de Precio de Lista', 'Entrega de Precio de Lista');
INSERT INTO bloomDeliverableType VALUES (10,'Entrega de Precio de Costo', 'Entrega de Precio de Costo');
INSERT INTO bloomDeliverableType VALUES (11,'Entrega de Parte o refacciòn', 'Entrega de Parte o refacciòn');

INSERT INTO bloomRequiredDeliverable VALUES (1,1,1);
INSERT INTO bloomRequiredDeliverable VALUES (2,1,2);
INSERT INTO bloomRequiredDeliverable VALUES (3,2,2);
INSERT INTO bloomRequiredDeliverable VALUES (4,3,3);
INSERT INTO bloomRequiredDeliverable VALUES (5,3,4);
INSERT INTO bloomRequiredDeliverable VALUES (6,4,5);
INSERT INTO bloomRequiredDeliverable VALUES (7,5,6);
INSERT INTO bloomRequiredDeliverable VALUES (8,6,7);
INSERT INTO bloomRequiredDeliverable VALUES (9,7,8);
INSERT INTO bloomRequiredDeliverable VALUES (10,8,9);
INSERT INTO bloomRequiredDeliverable VALUES (11,9,10);
INSERT INTO bloomRequiredDeliverable VALUES (12,10,11);

-- -----------------------------------------------------------------------------
	-- UNKNOWN REFERENCES
-- -----------------------------------------------------------------------------
INSERT INTO office VALUES('?', 'DESCONOCIDA', null);
INSERT INTO blackstaruser VALUES (-1, 'unknown@gposac.com.mx', 'Usuario Bloom sin correspondencia');
INSERT INTO bloomServiceType VALUES (-1,'DESCONOCIDO', 'Tipo de servicio no registrado', 0);
INSERT INTO bloomApplicantArea VALUES (-1,'DESCONOCIDO', 'Area no registrada');

-- -----------------------------------------------------------------------------
-- SINCRONIZACION DE DATOS
-- -----------------------------------------------------------------------------
use blackstarDbTransfer;

CALL ExecuteTransfer();
CALL BloomTransfer();