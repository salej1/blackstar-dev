<script type="text/javascript">
	
	// Inicializacion de tabla
	function pendingSales_init(){

		// Tabla de ventas en cotizacion
		getPendingSales();
	}	
	
	function getPendingSales(){
		$.getJSON("/ventas/pendingSales.do", function(data){
			// Inicializacion de tabla ventas en cotizacion
			$('#dtVentasPendientes').dataTable({	
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
					"aoColumnDefs" : [ ]}
			);
		});
	}
	
</script>

<!--
	Seccion tabla p en cotizacion
-->
	<div class="grid_16">
		<div class="box">
			<h2></h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtVentasPendientes">
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
