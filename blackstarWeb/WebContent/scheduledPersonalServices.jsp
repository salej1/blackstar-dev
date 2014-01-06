<script type="text/javascript">
	
	// Inicializacion de tabla
	function scheduledPersonalServices_init(){

		// Tabla de servicios programados
		getScheduledServices();
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
								  { "mData": "scheduledDate" },
								  { "mData": "customer" },
								  { "mData": "equipmentType" },
								  { "mData": "project" },
								  { "mData": "officeName" },
								  { "mData": "brand" },
								  { "mData": "serialNumber" },
								  { "mData": "equipmentType" }
							  ],
					"aoColumnDefs" : [
										{"mRender" : function(data, type, row){return "<div align='center'><a href='${pageContext.request.contextPath}/dashboard/createServiceOrder.do?equipmentType=" + data + "'>Crear O.S.</a></div>";}, "aTargets" : [0]}
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
