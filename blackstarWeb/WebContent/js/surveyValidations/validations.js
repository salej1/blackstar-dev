// JavaScript Document

$(document).ready(function(){
$("#telephone").keydown(function(event) {
   if(event.shiftKey)
   {
        event.preventDefault();
   }
 
   if (event.keyCode == 46 || event.keyCode == 8)    {
   }
   else {
        if (event.keyCode < 95) {
          if (event.keyCode < 48 || event.keyCode > 57) {
                event.preventDefault();
          }
        }
        else {
              if (event.keyCode < 96 || event.keyCode > 105) {
                  event.preventDefault();
              }
        }
      }
   });

	$("#date").datetimepicker();

	
	$('#sign').signature({syncField: '#sign'});
	$('#leftSign').signature({disabled: true}); 
	$("#signCapDialog").dialog({
		autoOpen: false,
		height: 220,
		width: 370,
		modal: true,
		buttons: {
			"Aceptar": function() {
				$('#leftSign').signature('draw', $('#sign').val()); 
				$( this ).dialog( "close" );
			},
			
			"Borrar": function() {
				$('#sign').signature('clear'); 
			},
			
			"Cancelar": function() {
			$( this ).dialog( "close" );
		}}
	});

	$('#leftSign').signature('draw', '${surveyService.sign}'); 

	
});