<!-- Seccion de links que permiten crear nueva orden de servicio -->
<div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="moveToOpenCaptureScreen('X'); return false;">Crear Orden de Servicio</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="moveToOpenCaptureScreen('A'); return false;">Crear Reporte de Aire Acondicionado</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="moveToOpenCaptureScreen('B'); return false;">Crear Reporte de Baterias</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="moveToOpenCaptureScreen('P'); return false;">Crear Reporte de Planta de emergencia</a>
	</div>
	<div>
		<img src="/img/navigate-right.png"/><a href="" onclick="moveToOpenCaptureScreen('U'); return false;">Crear Reporte de UPS</a>
	</div>
	<p><small>&nbsp;</small></p>
</div>
<!-- FIN - Seccion de links que permiten crear nueva orden de servicio -->

<!-- Seccion de dialgo que se muestra para seleccionar el equipo -->
<script>

	// Funcion de redireccion a pagina de captura de OS abierta
	function moveToOpenCaptureScreen(type){
		var urlTemplate = "PAGE/show.do?operation=4&idObject=Open";
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
		window.location = urlTemplate;
	}


</script>
<div id="selectSNDialog">
	<p>Escriba el numero de serie del equipo</p>
	<input type="text" id="eqSearch" style="width:95%;">
	<input type="hidden" id="selectedSerialNumber">
</div>
<!-- FIN - Seccion de dialgo que se muestra para seleccionar el equipo -->