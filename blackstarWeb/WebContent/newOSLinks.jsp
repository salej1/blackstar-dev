<!-- Seccion de links que permiten crear nueva orden de servicio -->
<div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="showEquipmentSelect('X'); return false;">Crear Orden de Servicio</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="showEquipmentSelect('A'); return false;">Crear Reporte de Aire Acondicionado</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="showEquipmentSelect('B'); return false;">Crear Reporte de Baterias</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="showEquipmentSelect('P'); return false;">Crear Reporte de Planta de emergencia</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="showEquipmentSelect('U'); return false;">Crear Reporte de UPS</a>
	</div>
</div>
<!-- FIN - Seccion de links que permiten crear nueva orden de servicio -->

<!-- Seccion de dialgo que se muestra para seleccionar el equipo -->
<script>
	var loadedType="";
    var selected = false;
	// Init
	function newOSLinks_init(){
		//Inicializacion del cuadro de dialogo para seleccionar el equipo
		$("#selectSNDialog").dialog({
			autoOpen: false,
			height: 200,
			width: 360,
			modal: true,
			buttons: {
				"Aceptar": function() {
					if(selected){
					  moveToCaptureScreen(loadedType);
					} else {
						$( this ).dialog( "close" );
					}
				},
				
				"Cancelar": function() {
				$( this ).dialog( "close" );
			}}
		});	
	}

	// Funcion de redireccion a pagina de captura de OS especifica
	function moveToCaptureScreen(type){
		var urlTemplate = "PAGE/show.do?operation=3&idObject=SN";
		var eq = $("#eqSearch").val();

		switch(type){
			case 'A': urlTemplate = urlTemplate.replace("PAGE", "/aircoService");
				break;
			case 'B': urlTemplate = urlTemplate.replace("PAGE", "/batteryService");
				break;
			case 'P': urlTemplate = urlTemplate.replace("PAGE", "/emergencyPlantService");
				break;
			case 'U': urlTemplate = urlTemplate.replace("PAGE", "/upsService");
				break;
			default: urlTemplate = urlTemplate.replace("PAGE", "/plainService");
				break;
		}

		urlTemplate = urlTemplate.replace("SN", eq);

		window.location = urlTemplate;
	}

	// Funcion de recuperacion de la lista de equipos
	function showEquipmentSelect(type){
		$("#eqSearch").attr("disabled", "");
		$("#eqSearch").val("Cargando equipos...");

		getEquipmentList(type);
		
		var dlgTitle = "Orden de servicio para ";
		switch(type){
			case 'A': dlgTitle = dlgTitle + "Aire acondicionado";
				break;
			case 'B': dlgTitle = dlgTitle + "Baterias";
				break;
			case 'P': dlgTitle = dlgTitle + "Planta de emergencia";
				break;
			case 'U': dlgTitle = dlgTitle + "UPS";
				break;
			default: dlgTitle = dlgTitle + "equipo";
				break;
		}

		selected = false;
		$( "#eqSearch" ).val("");
		$("#selectSNDialog").dialog('option', 'title', dlgTitle);
		$("#selectSNDialog").dialog('open');
	}

	// Estableciendo el origen para autocomplete
	function setEquipmentListSource(data){
		$("#eqSearch").autocomplete({
			minLength: 0,
			source: data,
			select: function( event, ui ) {
				$( "#eqSearch" ).val( ui.item.value );
				selected = true;
				return false;
			}
		});

		$("#eqSearch").removeAttr("disabled");
		$("#eqSearch").val("");
	}

	function getEquipmentList(type){
		var lookupType = type;
		if(type == 'B'){
			lookupType = 'U';
		}

		if(loadedType != type){
			$.getJSON("/serviceOrders/getEquipmentByTypeJson.do?type=" + lookupType, function(data){
				setEquipmentListSource(data);
				loadedType = type;
			});
		}
		else{
			$("#eqSearch").removeAttr("disabled");
			$("#eqSearch").val("");
		}
	}
	
	
	function getNewInternalTickets(){
	    var url = '/bloom/newInternalTicket.do';
	    var data = new Array();
	    redirect(url, data, "GET");
		
	}

</script>
<div id="selectSNDialog">
	<p>Escriba el numero de serie del equipo</p>
	<input type="text" id="eqSearch" style="width:95%;">
	<input type="hidden" id="selectedSerialNumber">
</div>
<!-- FIN - Seccion de dialgo que se muestra para seleccionar el equipo -->