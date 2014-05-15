use blackstarDb;

delete from plainService where serviceOrderId in    (select serviceOrderId from serviceOrder where serviceOrderNumber like '%-e') ;
delete from serviceOrderEmployee where serviceOrderId in    (select serviceOrderId from serviceOrder where serviceOrderNumber like '%-e') ;
update ticket set serviceOrderId =  null  where serviceOrderId in    (select serviceOrderId from serviceOrder where serviceOrderNumber like '%-e') ;
delete from serviceOrder where serviceOrderId in    (select serviceOrderId from(select serviceOrderId from serviceOrder where serviceOrderNumber like '%-e') a) ;
    