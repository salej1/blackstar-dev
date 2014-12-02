-- Insertamos los registros sysQA en advisedGroup

INSERT INTO bloomAdvisedGroup(applicantAreaId, serviceTypeId, userGroup, workerRoleTypeId)
SELECT applicantAreaId, serviceTypeId, 'sysQA', 2
FROM bloomAdvisedGroup
WHERE userGroup = 'sysQAManager'
AND (SELECT count(*) FROM bloomAdvisedGroup WHERE userGroup = 'sysQA') = 0 ;

-- Insertamos los usuarios sysQA en ticketTeam para tickets actuales

INSERT INTO bloomTicketTeam(ticketId, workerRoleTypeId, blackstarUserId, userGroup, assignedDate)
SELECT _id, 1, blackstarUserId, 'sysQA', now()
FROM bloomTicket t 
	INNER JOIN bloomAdvisedGroup a ON t.serviceTypeId = a.serviceTypeId
	INNER JOIN userGroup g ON g.externalId = a.userGroup
	INNER JOIN blackstarUser_userGroup u ON u.userGroupId = g.userGroupId
WHERE t.serviceTypeId IN(22,23)
AND blackstarUserId NOT IN (SELECT blackstarUserId FROM bloomTicketTeam m INNER JOIN bloomTicket bt ON bt._id = m.ticketId WHERE bt.serviceTypeId IN(22,23));