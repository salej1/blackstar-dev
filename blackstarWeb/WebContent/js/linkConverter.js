function convertToLink(referenceType, reference){
	var link = reference;

	if(reference != null){
		var refCmp = reference.toUpperCase();
		if(refCmp != "" && refCmp != "NA" && refCmp != "N/A" && refCmp != "N A"){
			reference = reference.trim();

			switch(referenceType){
				case "O": // Orden de servicio
					link = "<a href='/osDetail/show.do?serviceOrderId=0&serviceOrderNumber=" + reference + "'>" + reference + "</a>";
					break;
				case "T": // Ticket
					link = "<a href='/ticketDetail?ticketNumber=" + reference + "'>" + reference + "</a>";
					break;
				case "E": // Encuesta de servicio
					break;
			}
		} 
	}

	return link;
}