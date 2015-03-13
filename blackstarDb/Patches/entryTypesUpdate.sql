update codexProjectEntry SET entryTypeId = 9011 where entryTypeId = 9005;
update codexProjectEntry SET entryTypeId = 9011 where entryTypeId = 40004;
update codexProjectEntry SET entryTypeId = 9042 where entryTypeId = 9016;
update codexProjectEntry SET entryTypeId = 9042 where entryTypeId = 9023;
update codexProjectEntry SET entryTypeId = 9032 where entryTypeId = 9041;
update codexProjectEntry SET entryTypeId = 9049 where entryTypeId = 9037;
update codexProjectEntry SET entryTypeId = 40010 where entryTypeId = 9090;

update codexProjectEntryTypes SET productType = 'P' where _id = 9049;

update codexProjectEntryTypes SET active = 1 where _id IN(9042,9011,40001,40002,40003,40010,9032,9033,9034,9035,9049,9038);
update codexProjectEntryTypes SET active = 0 where _id NOT IN(9042,9011,40001,40002,40003,40010,9032,9033,9034,9035,9049,9038);
