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
	<p><small>&nbsp;</small></p>
</div>
<!-- FIN - Seccion de links que permiten crear nueva orden de servicio -->

<!-- Seccion de dialgo que se muestra para seleccionar el equipo -->
<script>
	var loadedType="";

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
					moveToCaptureScreen(loadedType);
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
			case 'a': urlTemplate = urlTemplate.replace("PAGE", "/aircoservice");
				break;
			case 'b': urlTemplate = urlTemplate.replace("PAGE", "/batteryservice");
				break;
			case 'p': urlTemplate = urlTemplate.replace("PAGE", "/emergencyplantservice");
				break;
			case 'u': urlTemplate = urlTemplate.replace("PAGE", "/upsservice");
				break;
			default: urlTemplate = urlTemplate.replace("PAGE", "/plainservice");
				break;
		}

		urlTemplate = urlTemplate.replace("SN", eq);

		window.location = urlTemplate;
	}

	// Funcion de recuperacion de la lista de equipos
	function showEquipmentSelect(type){
		getEquipmentList(type);

		var dlgTitle = "Orden de servicio para ";
		switch(type){
			case 'a': dlgTitle = dlgTitle + "Aire acondicionado";
				break;
			case 'b': dlgTitle = dlgTitle + "Baterias";
				break;
			case 'p': dlgTitle = dlgTitle + "Planta de emergencia";
				break;
			case 'u': dlgTitle = dlgTitle + "UPS";
				break;
			default: dlgTitle = dlgTitle + "equipo";
				break;
		}

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
 
				return false;
			}
		})
	}

	function getEquipmentList(type){
		if(loadedType != type){
			$.getJSON("/serviceOrders/getEquipmentByTypeJson.do?type=" + type, function(data){
				setEquipmentListSource(data);
				loadedType = type;
			});
		}
	}

</script>
<div id="selectSNDialog">
	<p>Escriba el numero de serie del equipo</p>
	<input type="text" id="eqSearch" style="width:95%;">
	<input type="hidden" id="selectedSerialNumber">
</div>
<!-- FIN - Seccion de dialgo que se muestra para seleccionar el equipo -->