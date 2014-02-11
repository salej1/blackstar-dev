<script type="text/javascript">
	
	// Inicializacion de tabla
	function scheduledPersonalServices_init(){

		// Tabla de servicios programados
		getScheduledServices();
	}	
	
	// Funcion de redireccion a pagina de captura de OS especifica
	function moveToCaptureScreen_scheduled(type, eq){
		var urlTemplate = "PAGE/show.do?operation=3&idObject=SN";

		switch(type){
			case 'AA': urlTemplate = urlTemplate.replace("PAGE", "/aircoService");
				break;
			case 'BATERIAS': urlTemplate = urlTemplate.replace("PAGE", "/batteryService");
				break;
			case 'PE': urlTemplate = urlTemplate.replace("PAGE", "/emergencyPlantService");
				break;
			case 'UPS': urlTemplate = urlTemplate.replace("PAGE", "/upsService");
				break;
			default: urlTemplate = urlTemplate.replace("PAGE", "/plainService");
				break;
		}

		urlTemplate = urlTemplate.replace("SN", eq);

		window.location = urlTemplate;
	}

	function getScheduledServices(){
		$.getJSON("/dashboard/scheduledPersonalServicesJson.do", function(data){
			// Inicializacion de servicios programados
			$('#dtOrdenesProgramadas').dataTable({	
					"bProcessing": true,
					"bFilter": true,
					"bLengthChange": false,
					"iDisplayLength": 10,
					"bInfo": false,
					"sPaginationType": "full_numbers",
					"aaData": data,
					"sDom": '<"top"i>rt<"bottom"flp><"clear">',
					"aoColumns": [
								  { "mData": "serviceDate" },
								  { "mData": "customer" },
								  { "mData": "equipmentType" },
								  { "mData": "project" },
								  { "mData": "officeName" },
								  { "mData": "brand" },
								  { "mData": "serialNumber" },
								  { "mData": "serialNumber" }
							  ],
					"aoColumnDefs" : [
										{"mRender" : function(data, type, row){return "<div align='center'><a href='#' onclick=\"moveToCaptureScreen_scheduled('"+ row.equipmentType +"', '"+ row.serialNumber +"');return false;\">Crear O.S.</a></div>";}, "aTargets" : [7]}
									 ]
			});
		});
	}
	
</script>

<!--
	Seccion tabla ordenes de servicio con pendientes
-->
	<div class="grid_16">
		<div class="box">
			<h2>Servicios programados</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtOrdenesProgramadas">
				<thead>
					<tr>
						<th>Fecha</th>
						<th>Cliente</th>
						<th>Equipo</th>
						<th>Proyecto</th>
						<th>Oficina</th>
						<th>Marca</th>
						<th>No. Serie</th>
						<th>Crear O.S.</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	</div>

<!--
	FIN - Seccion tabla ordenes de servicio con pendientes
-->
