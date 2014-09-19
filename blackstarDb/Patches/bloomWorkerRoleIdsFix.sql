-- Fix workerRoleTypes for BloomTickets
USE blackstarDb;

UPDATE bloomTicketTeam SET
	workerRoleTypeId = 1 
WHERE userGroup IN('sysEngLead','sysSupportEng');

update bloomStatusType SET name = UPPER(name);

