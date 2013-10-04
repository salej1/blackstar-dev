function getEquipmentCollection(customer){
	var html = "";
	
	$.getJSON( "equipmentCollectionByCustomer?customer=" + customer, function( data ) {
		  var items = [];
		  $.each( data, function( key, val ) {
			items.push( "<option value = '" + key + "'>" + val + "</option>" );
		  });
		 
		  html = items.join("");
	}).fail(function() {
		html = "<option value="Error al recuperar equipos"></option>"
	});
	
	return html;
}

