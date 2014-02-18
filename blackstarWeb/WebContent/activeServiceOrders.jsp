<script type="text/javascript">
	
	// Inicializacion de tabla
	function activeServiceOrders_init(){

		// Tabla de ordenes de servicio pendientes
		getActiveServiceOrders();
	}	
	
	function getActiveServiceOrders(){
		$.getJSON("/dashboard/activeServiceOrdersJson.do", function(data){
			// Inicializacion de tabla de ordenes de servicio con algun pendiente
			$('#dtActiveServiceOrders').dataTable({	
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
							  { "mData": "brand" },
							  { "mData": "serialNumber" },
							  { "mData": "serviceStatus" }

							  ],
					"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align='center' style='width:70px;' ><a href='${pageContext.request.contextPath}/osDetail/show.do?serviceOrderId=" + row.DT_RowId + "'>" + data + "</a></div>";}, "aTargets" : [0]},
									  {"mRender" : function(data, type, row){return "<a href='${pageContext.request.contextPath}/report/show.do?serviceOrderId=" + row.DT_RowId + "' target='_blank'><img src='${pageContext.request.contextPath}/img/pdf.png'</a>" ;}, "aTargets" : [1]},
									  {"mRender" : function(data, type, row){return "<div align='center'><a href='${pageContext.request.contextPath}/ticketDetail?ticketNumber=" + data + "'>" + data + "</a></div>";}, "aTargets" : [2]}	    		    	       
									   ]}
			);
		});
	}
	
</script>

<!--
	Seccion tabla de ordenes de servicio asignadas 
-->
	<div class="grid_16">
		<div class="box">
			<h2>Ordenes de Servicio Activas</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtActiveServiceOrders">
				<thead>
					<tr>
						<th>Folio</th>
						<th></th>
						<th>Ticket</th>
						<th>Tipo</th>
						<th>Fecha</th>
						<th>Cliente</th>
						<th>Equipo</th>
						<th>Marca</th>
						<th>No. Serie</th>
						<th>Estatus</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
			<form id="frmFile" action="/dashboard/getServiceOrdersFile.do" target="_blank">
			   <input id="btnFile" name="btnFile" value="Descargar Archivo" type="submit"/>
		   </form>
		</div>
	</div>

<!--
	FIN - Seccion tabla de ordenes de servicio asignadas 
-->
