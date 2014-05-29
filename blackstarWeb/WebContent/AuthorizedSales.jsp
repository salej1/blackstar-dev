<script type="text/javascript">
	
	// Inicializacion de tabla
	function AuthorizedSales_init(){

		// Tabla de ventas autorizadas
		getAuthorizedSales();
	}	
	
	
	function getAutorizedSales(){
		$.getJSON("/ventas/AutorizedSalesJson.do", function(data){
			// Inicializacion de ventas autorizadas
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
			<h2>C. de Proyecto Autorizadas</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtVentasAutorizadas">
				<thead>
					<tr>
						<th>Proyecto</th>
						<th>Cliente</th>
						<th>�ltima Actividad</th>
						<th>Ubicaci�n</th>
						<th>Estatus</th>
						<th>Acci�n</th>						
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
