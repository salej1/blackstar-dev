function postAssignedTicket(pTicketId, pEmployee){
	
	$.post( "assignTicket", { 
			ticketId: pTicketId, 
			employee: pEmployee
	})
	.done(function( data ) {
		alert( "Data Loaded: " + data );
	});
}