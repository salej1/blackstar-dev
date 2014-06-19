<script type="text/javascript">
	
	// Inicializacion de tabla
	function serviceOrdersHistory_init(){

		// Tabla de ordenes de servicio pendientes
		getServiceOrdersHistory();
	}	
	
	function getServiceOrdersHistory(){
		$.getJSON("/serviceOrders/serviceOrdersHistoryJson.do", function(data){
			// Inicializacion de tabla de ordenes de servicio con algun pendiente
			$('#dtOrdersHistory').dataTable({	
					"bProcessing": false,
					"bFilter": true,
					"bLengthChange": false,
					"iDisplayLength": 10,
					"bInfo": false,
					"sPaginationType": "full_numbers",
					"aaData": data,
					"sDom": '<"top"i>rt<"bottom"flp><"clear">',
					"aaSorting": [],
					"aoColumns": [
							  { "mData": "serviceOrderNumber" },
							  { "mData": "placeHolder" },
							  { "mData": "ticketNumber" },
							  { "mData": "serviceType" },
							  { "mData": "serviceDate" },
							  { "mData": "customer" },
							  { "mData": "project" },
							  { "mData": "equipmentType" },
							  { "mData": "brand" },
							  { "mData": "serialNumber" },
							  { "mData": "serviceStatus" },
							  { "mData": "serviceCenter" }

							  ],
					"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align='center' style='width:85px;' ><a href='${pageContext.request.contextPath}/osDetail/show.do?serviceOrderId=" + row.DT_RowId + "'>" + data + "</a></div>";}, "aTargets" : [0]},
									  {"mRender" : function(data, type, row){
									  		if(row.hasPdf == "1"){
									  			return "<a href='${pageContext.request.contextPath}/report/show.do?serviceOrderId=" + row.DT_RowId + "' target='_blank'><img src='${pageContext.request.contextPath}/img/pdf.png'</a>" ;									  			
									  		}
									  		else
									  		{
									  			return "&nbsp";
									  		}
									  	}, "aTargets" : [1]},
									  {"mRender" : function(data, type, row){return "<div align='center'><a href='${pageContext.request.contextPath}/ticketDetail?ticketNumber=" + data + "'>" + data + "</a></div>";}, "aTargets" : [2]}	    		    	       
									   ]}
			);
		});
	}
	
</script>

<!--
	Seccion tabla de historial de ordenes de servicio 
-->
	<div class="grid_16">
		<div class="box">
			<h2>Historial de Ordenes de Servicio</h2>
			<div class="utils">
				
			</div>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtOrdersHistory">
				<thead>
					<tr>
						<th style="width:50px">Folio</th>
						<th style="width:10px"></th>
						<th style="width:70px">Ticket</th>
						<th>Tipo</th>
						<th style="width:90px">Fecha</th>
						<th>Cliente</th>
						<th>Proyecto</th>
						<th>Equipo</th>
						<th>Marca</th>
						<th>No. Serie</th>
						<th>Estatus</th>
						<th>Oficina</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	</div>

<!--
	FIN - Seccion tabla de historial de ordenes de servicio 
-->
