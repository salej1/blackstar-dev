use blackstarDb;

delete from workTeam where codexProjectId = 55;
delete from codexEntryItem where entryId IN (select _id from codexProjectEntry where projectId = 55);
delete from codexProjectEntry where projectId = 55;
delete from codexProject where _id = 55;

delete from workTeam where codexProjectId = 23;
delete from codexEntryItem where entryId IN (select _id from codexProjectEntry where projectId = 23);
delete from codexProjectEntry where projectId = 23;
delete from codexProject where _id = 23;

delete from workTeam where codexProjectId = 36;
delete from codexEntryItem where entryId IN (select _id from codexProjectEntry where projectId = 36);
delete from codexProjectEntry where projectId = 36;
delete from codexProject where _id = 36;	

delete from workTeam where codexProjectId = 45;
delete from codexEntryItem where entryId IN (select _id from codexProjectEntry where projectId = 45);
delete from codexProjectEntry where projectId = 45;
delete from codexProject where _id = 45;		

delete from workTeam where codexProjectId = 47;
delete from codexEntryItem where entryId IN (select _id from codexProjectEntry where projectId = 47);
delete from codexProjectEntry where projectId = 47;
delete from codexProject where _id = 47;		

delete from workTeam where codexProjectId = 57;
delete from codexEntryItem where entryId IN (select _id from codexProjectEntry where projectId = 57);
delete from codexProjectEntry where projectId = 57;
delete from codexProject where _id = 57;		

delete from workTeam where codexProjectId = 73;
delete from codexEntryItem where entryId IN (select _id from codexProjectEntry where projectId = 73);
delete from codexProjectEntry where projectId = 73;
delete from codexProject where _id = 73;		

delete from workTeam where codexProjectId = 75;
delete from codexEntryItem where entryId IN (select _id from codexProjectEntry where projectId = 75);
delete from codexProjectEntry where projectId = 75;
delete from codexProject where _id = 75;

delete from workTeam where codexProjectId = 6;
delete from codexEntryItem where entryId IN (select _id from codexProjectEntry where projectId = 6);
delete from codexProjectEntry where projectId = 6;
delete from codexProject where _id = 6;	

delete from workTeam where codexProjectId = 80;
delete from codexEntryItem where entryId IN (select _id from codexProjectEntry where projectId = 80);
delete from codexProjectEntry where projectId = 80;
delete from codexProject where _id = 80;	

delete from workTeam where codexProjectId = 81;
delete from codexEntryItem where entryId IN (select _id from codexProjectEntry where projectId = 81);
delete from codexProjectEntry where projectId = 81;
delete from codexProject where _id = 81;		