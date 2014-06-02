USE blackstarDb;

CREATE TEMPORARY TABLE dupPolicy(p1id INT, s1 VARCHAR(300), p1 VARCHAR(100), p2id INT, s2 VARCHAR(300), p2 VARCHAR(100));
INSERT INTO dupPolicy(p1id, s1, p1, p2id, s2, p2)
select p1.policyId AS P1Id, p1.serialNumber as S1, p1.project as P1, p2.policyId AS P2Id, p2.serialNumber as S2, p2.project as P2
from policy p1 
	inner join policy p2 where p1.serialNumber = p2.serialNumber and p1.project = p2.project and p1.policyId != p2.policyId and p2.policyId > p1.policyId;

update ticket t 
inner join dupPolicy p on p.p1id = t.policyId
set t.policyId = p.p2Id;

update serviceOrder t 
inner join dupPolicy p on p.p1id = t.policyId
set t.policyId = p.p2Id;

update scheduledServicePolicy t 
inner join dupPolicy p on p.p1id = t.policyId
set t.policyId = p.p2Id;

delete from policy where policyId in(select p1id from dupPolicy);

drop table dupPolicy;