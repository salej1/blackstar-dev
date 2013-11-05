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
-- 1    22/10/2013  SAG  Version inicial. Usuarios basicos de GPO Sac
-- ---------------------------------------------------------------------------
use blackstarDb;

Call UpsertUser('alberto.lopez.gomez@gposac.com.mx','Alberto Lopez Gomez');
Call UpsertUser('alejandra.diaz@gposac.com.mx','Alejandra Diaz');
Call UpsertUser('alejandro.monroy@gposac.com.mx','Alejandro Monroy');
Call UpsertUser('marlem.samano@gposac.com.mx','Marlem Samano');
Call UpsertUser('armando.perez.pinto@gposac.com.mx','Armando Perez Pinto');
Call UpsertUser('gonzalo.ramirez@gposac.com.mx','Gonzalo Ramirez');
Call UpsertUser('jose.alberto.jonguitud.gallardo@gposac.com.mx','Jose Alberto Jonguitud Gallardo');
Call UpsertUser('marlem.samano@gposac.com.mx','Marlem Samano');
Call UpsertUser('martin.vazquez@gposac.com.mx','Martin Vazquez');
Call UpsertUser('reynaldo.garcia@gposac.com.mx','Reynaldo Garcia');
Call UpsertUser('sergio.gallegos@gposac.com.mx','Sergio  Gallegos');
Call UpsertUser('angeles.avila@gposac.com.mx','Angeles Avila');
Call UpsertUser('sergio.aga@gmail.com','Sergio A. Gomez');
Call UpsertUser('portal-servicios@gposac.com.mx','Portal Servicios');
Call UpsertUser('josue.ramirez@gposac.com.mx','Josue Fernando Ramirez Rosas');
Call UpsertUser('martin.vazquez@gposac.com.mx','Martin Vazquez Vargas');
Call UpsertUser('daniel.bravo@gposac.com.mx','Daniel Bravo Muñoz');
Call UpsertUser('felipe.campos@gposac.com.mx','Felipe Campos Morales');
Call UpsertUser('guillermo.santos@gposac.com.mx','Guillermo Santos Cruz');
Call UpsertUser('joel.paz@gposac.com.mx','Joel Paz Torres');
Call UpsertUser('juanpablo.procopio@gposac.com.mx','Juan Pablo Procopio Wences');
Call UpsertUser('julio.lara@gposac.com.mx','Julio Enrique Lara Reyes');
Call UpsertUser('joel.barron@gposac.com.mx','Joel Barron Moreno');
Call UpsertUser('oscar.huerta@gposac.com.mx','Oscar Huerta González');
Call UpsertUser('victor.hubert@gposac.com.mx','Victor Manuel Hubert Pérez');
Call UpsertUser('salvador.ruvalcaba@gposac.com.mx','Salvador Ruvalcaba Plascencia');
Call UpsertUser('joseluis.esteva@gposac.com.mx','Jose Luis Esteva Angel');
Call UpsertUser('alberto.suarez@gposac.com.mx','Alberto Suarez Naranjo');
Call UpsertUser('hector.casillas@gposac.com.mx','Hector Tobías Casillas Aguilera');
Call UpsertUser('jose.osorio@gposac.com.mx','Jose Roberto Osorio López');


Call CreateUserGroup('sysServicio','Implementacion y Servicio','alberto.lopez.gomez@gposac.com.mx');
Call CreateUserGroup('sysCallCenter','Call Center','alejandra.diaz@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','alejandro.monroy@gposac.com.mx');
Call CreateUserGroup('sysCallCenter','Call Center','marlem.samano@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','armando.perez.pinto@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','gonzalo.ramirez@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','jose.alberto.jonguitud.gallardo@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','martin.vazquez@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','reynaldo.garcia@gposac.com.mx');
Call CreateUserGroup('sysServicio','Implementacion y Servicio','sergio.gallegos@gposac.com.mx');
Call CreateUserGroup('sysCoordinador','Coordinador','angeles.avila@gposac.com.mx');
Call CreateUserGroup('sysCallCenter','Call Center','sergio.aga@gmail.com');
Call CreateUserGroup('sysCallCenter','Call Center','portal-servicios@gposac.com.mx');

