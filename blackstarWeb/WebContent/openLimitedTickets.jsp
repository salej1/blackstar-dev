<script type="text/javascript">
	
	// Inicializacion de tabla de tickets de cliente abiertos
	function openLimitedTickets_init(){
		// Tabla de tickets
		getopenLimitedTickets();
	}	
	
	// Funcion que muestra la tabla de tickets de cliente abiertos
	function getopenLimitedTickets(){
		$.getJSON("/dashboard/openLimitedTicketsJson.do", function(data){ 
			
			// Inicializacion de tabla de ticets asignados
			$('#openLimitedTicketsTable').dataTable({	    		
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
							  { "mData": "ticketDate" },
							  { "mData": "customer" },
							  { "mData": "equipmentType" },
							  { "mData": "responseTime" },
							  { "mData": "project" }, 	              
							  { "mData": "ticketStatus" },
							  { "mData": "placeHolder" }

						  ],
				"aoColumnDefs" : [
									{"mRender" : function(data, type, row){return "<div><a href=${pageContext.request.contextPath}/ticketDetail?ticketId=" + row.DT_RowId + ">" + data + "</a></div>";}, "aTargets" : [0]},
									{"mRender" : function(data, type, row){return "<div><a href=/plainService/show.do?operation=1&idObject=" + row.DT_RowId +">Crear O.S.</a></div>";}, "aTargets" : [7]}	       
								 ]}
			);
		});
	}
	
</script>

<!--
	Seccion tabla de tickets sin asignar
-->
<div class="grid_16">
	<div class="box">
		<h2>tickets de cliente abiertos</h2>
		<div class="utils">
			
		</div>
		<div id= ticketTablaContainer>
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="openLimitedTicketsTable">
				<thead>
					<tr> 
						<th style="width:50px;">Ticket</th>
						<th>Fecha/Hora</th>
						<th style="width:200px;">Cliente</th>
						<th>Equipo</th>
						<th>Tiem. R</th>
						<th>Proyecto</th>
						<th>Estatus</th>
						<th style="width:100px;">Crear O.S.</th>
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
