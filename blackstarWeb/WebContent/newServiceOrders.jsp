<script type="text/javascript">
	
	// Inicializacion de tabla de tickets y dialogo de asignacion
	function newServiceOrders_init(){

		// Tabla de Ordenes de servicio nuevas
		getNewServiceOrders();
	}	

	// funcion de filtrado por oficina
	function newServiceOrders_filter(office){
		// tabla de OS nuevas
		var newSOTable = $('#dtOrdenesPorRevisar').dataTable();
			newSOTable.fnFilter(office, 8);
	 }
	 
	function getNewServiceOrders(){
		$.getJSON("/dashboard/newServiceOrdersJson.do", function(data){
			// Inicializacion de la tabla de nuevas ordenes de servicio
			$('#dtOrdenesPorRevisar').dataTable({	    		
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
									  {"mRender" : function(data, type, row){return "<a href='${pageContext.request.contextPath}/report/show.do?serviceOrderId=" + row.DT_RowId + "' target='_blank'><img src='${pageContext.request.contextPath}/img/pdf.png'</a>" ;}, "aTargets" : [1]},
									  {"mRender" : function(data){return "<div align='center'><a href='${pageContext.request.contextPath}/ticketDetail?ticketId=" + data + "'>" + data + "</a></div>";}, "aTargets" : [2]}	    		    	       
									   ]}
			);

			newServiceOrders_filter(officePref);
		});
	}
	
</script>

<!--
	Seccion tabla nuevas ordenes de servicio
-->
<div class="grid_16">
	<div class="box">
		<h2>Ordenes de servicio por revisar</h2>
		<div class="utils">
			
		</div>
		<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtOrdenesPorRevisar">
			<thead>
				<tr>
					<th style="width=250px;">Folio</th>
					<th style="width=50px;"></th>
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
	FIN - Seccion tabla nuevas ordenes de servicio
-->
