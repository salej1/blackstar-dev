<script type="text/javascript">
	
	// Inicializacion de tabla de tickets asignados
	function assignedTickets_init(){
		// Tabla de tickets
		var str = getAssignedTickets();
		var data = $.parseJSON(str);
		
		// Inicializacion de tabla de ticets asignados
		$('#assignedTicketsTable').dataTable({	    		
			"bProcessing": true,
			"bFilter": true,
			"bLengthChange": false,
			"iDisplayLength": 10,
			"bInfo": false,
			"sPaginationType": "full_numbers",
			"aaData": data,
			"sDom": '<"top"i>rt<"bottom"flp><"clear">',
			"aoColumns": [
						  { "mData": "ticketNumber" },
						  { "mData": "created" },
						  { "mData": "customer" },
						  { "mData": "equipmentType" },
						  { "mData": "responseTimeHR" },
						  { "mData": "project" }, 	              
						  { "mData": "ticketStatus" },
						  { "mData": "crearServicio" }

					  ],
			"aoColumnDefs" : [
								{"mRender" : function(data, type, row){return "<div align=center style='width:60px;'><a href=${pageContext.request.contextPath}/ticketDetail?ticketId=" + row.DT_RowId + ">" + data + "</a></div>";}, "aTargets" : [0]},
								{"mRender" : function(data, type, row){return "<div align=center style='width:60px;'><a href=${pageContext.request.contextPath}/newOs?ticketId=" + row.DT_RowId + ">" + data + "</a></div>";}, "aTargets" : [7]}	       
							 ]}
		);
	}	
	
	function getAssignedTickets(){
		$.getJson("/dashboard/assignedTicketsJson.do", function(data){ //TODO - Add handler in backend
			return data;
		});
	}
	
</script>

<!--
	Seccion tabla de tickets sin asignar
-->
<div class="grid_16">
	<div class="box">
		<h2>Tickets por asignar</h2>
		<div class="utils">
			
		</div>
		<div id= ticketTablaContainer>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="assignedTicketsTable">
				<thead>
					<tr> 
						<th>Ticket</th>
						<th>Fecha/Hora</th>
						<th>Cliente</th>
						<th>Equipo</th>
						<th>Tiem. R</th>
						<th>Proyecto</th>
						<th>Estatus</th>
						<th>Crear OS</th>
					</tr>
				</thead>
				<tbody>  
				</tbody> 
			</table>
		</div>
	</div>
</div>

<!--
	FIN - Seccion tabla de tickets sin asignar
-->
