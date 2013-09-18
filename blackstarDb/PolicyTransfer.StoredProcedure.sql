/******************************************************************************
** File:	PolicyTransfer.StoredProcedure.sql   
** Name:	PolicyTransfer
** Desc:	Transfiere los datos de la BD temporal de polizas a la BD de produccion
** Auth:	Sergio A Gomez
** Date:	17/09/2013
*******************************************************************************
** Change History
*******************************************************************************
** PR   Date    	Author	Description
** --   --------   -------  ------------------------------------
** 1    17/09/2013  SAG  	Version inicial: Transfiere los datos de polizas a la BD real
*****************************************************************************/

USE blackstarDbTransfer;

DELIMITER $$

DROP PROCEDURE IF EXISTS `PolicyTransfer` $$
CREATE PROCEDURE `PolicyTransfer`()
BEGIN

  SELECT 'Hello, Goodbye'

END $$

DELIMITER ;