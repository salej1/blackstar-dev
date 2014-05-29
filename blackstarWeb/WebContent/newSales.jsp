<script type="text/javascript">
	
	// Inicializacion de tabla
	function newSales_init(){

		// Tabla de ventas autorizadas
		getNewSales();
	}	
	
	
	function getAutorizedSales(){
		$.getJSON("/ventas/NewSalesJson.do", function(data){
			// Inicializacion de nuevas ventas 
			$('#dtVentasAutorizadas').dataTable({	
					"bProcessing": true,
					"bFilter": true,
					"bLengthChange": false,
					"iDisplayLength": 10,
					"bInfo": false,
					"sPaginationType": "full_numbers",
					"aaData": data,
					"sDom": '<"top"i>rt<"bottom"flp><"clear">',
					"aoColumns": [
								  { "mData": "projectID" },
								  { "mData": "customer" },
								  { "mData": "lastActivity" },
								  { "mData": "location" },
								  { "mData": "status" },
								  { "mData": "action" }								  
							  ],
					"aoColumnDefs" : [
										{"mRender" : }, "aTargets" : [7]}
									 ]
			});
		});
	}
	
</script>

<!--
	Seccion tabla ventas autorizadas
-->

	<div class="grid_16">
		<div class="box">
			<h2>C. de Proyecto Nuevas</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtVentasAutorizadas">
				<thead>
					<tr>
						<th>Proyecto</th>
						<th>Cliente</th>
						<th>Última Actividad</th>
						<th>Ubicación</th>
						<th>Estatus</th>
						<th>Acción</th>						
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
