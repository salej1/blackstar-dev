<script type="text/javascript">
	
	// Inicializacion de tabla
	function pendingServiceOrders_init(){

		// Tabla de ordenes de servicio pendientes
		getPendingServiceOrders();
	}	
	
	// funcion de filtrado por oficina
	function pendingServiceOrders_filter(office){
		// tabla de OS nuevas
		var newSOTable = $('#dtOrdenesPendientes').dataTable();
			newSOTable.fnFilter(office, 8);
	 }

	function getPendingServiceOrders(){
		$.getJSON("/dashboard/pendingServiceOrdersJson.do", function(data){
			// Inicializacion de tabla de ordenes de servicio con algun pendiente
			$('#dtOrdenesPendientes').dataTable({	
					"bProcessing": true,
					"bFilter": true,
					"bLengthChange": false,
					"iDisplayLength": 10,
					"bInfo": false,
					"sPaginationType": "full_numbers",
					"aaData": data,
					"sDom": '<"top"i>rt<"bottom"flp><"clear">',
					"aoColumns": [
							  { "mData": "serviceOrderNumber" },
							  { "mData": "placeHolder" },
							  { "mData": "ticketNumber" },
							  { "mData": "serviceType" },
							  { "mData": "created" },
							  { "mData": "customer" },
							  { "mData": "equipmentType" },
							  { "mData": "project" },
							  { "mData": "officeName" },
							  { "mData": "brand" },
							  { "mData": "serialNumber" }

							  ],
					"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align='center' style='width:70px;' ><a href='${pageContext.request.contextPath}/osDetail/show.do?serviceOrderId=" + row.DT_RowId + "'>" + data + "</a></div>";}, "aTargets" : [0]},
									  {"mRender" : function(data, type, row){return "<img src='${pageContext.request.contextPath}/img/pdf.png' onclick='return false';/>" ;}, "aTargets" : [1]},
									  {"mRender" : function(data, type, row){return "<div align='center'><a href='${pageContext.request.contextPath}/ticketDetail?ticketNumber=" + data + "'>" + data + "</a></div>";}, "aTargets" : [2]}	    		    	       
									   ]}
			);

			pendingServiceOrders_filter(officePref);
		});
	}
	
</script>

<!--
	Seccion tabla ordenes de servicio con pendientes
-->
	<div class="grid_16">
		<div class="box">
			<h2>Ordenes de servicio con pendientes</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtOrdenesPendientes">
				<thead>
					<tr>
						<th>Folio</th>
						<th></th>
						<th>Ticket</th>
						<th>Tipo</th>
						<th>Fecha</th>
						<th>Cliente</th>
						<th>Equipo</th>
						<th>Proyecto</th>
						<th>Oficina</th>
						<th>Marca</th>
						<th>No. Serie</th>
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
