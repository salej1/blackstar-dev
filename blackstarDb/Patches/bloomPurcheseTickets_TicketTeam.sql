INSERT INTO bloomTicketTeam(ticketId, workerRoleTypeId, blackstarUSerId, userGroup, assignedDate)
SELECT t._id, 1, gr.blackstarUserId, g.userGroup, now()
FROM bloomTicket t
	INNER JOIN  bloomAdvisedGroup g ON g.serviceTypeId = t.serviceTypeId
	INNER JOIN userGroup ug ON ug.externalId = g.userGroup
	INNER JOIN blackstarUser_userGroup gr ON gr.userGroupId = ug.userGroupId
	LEFT OUTER JOIN bloomTicketTeam tt ON t._id = tt.ticketId AND tt.workerRoleTypeId = 1
WHERE g.workerRoleTypeId = 1
	AND t.serviceTypeId = 15
	AND tt._id IS NULL
ORDER BY t._id;

UPDATE bloomAdvisedGroup SET
	userGroup = 'sysQAGroup'
WHERE userGroup = 'sysQA'
AND serviceTypeId IN(22,23);

DELETE FROM bloomAdvisedGroup
WHERE userGroup = 'sysCeo'
AND serviceTypeId IN(22,23)
AND workerRoleTypeId = 2; 