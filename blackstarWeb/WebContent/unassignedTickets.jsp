<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>
<script type="text/javascript">
	
	// Inicializacion de tabla de tickets y dialogo de asignacion
	function unassignedTickets_init(){
		// Tabla de tickets
		getUnassignedTickets();
		
		// Inicializacion de dialogo de asignacion de tickets
		 $("#tktAssignDlg").dialog({
			autoOpen: false,
			height: 200,
			width: 260,
			modal: true,
			buttons: {
				"Aceptar": function() {
					var employee = $("#employeeSelect option:selected").val();

					postAssignedTicket(assignedTicket, employee);
					
					$( this ).dialog( "close" );
				},
				
				"Cancelar": function() {
				$( this ).dialog( "close" );
			}}
		});
	}	
	
	function getUnassignedTickets(){
		$.getJSON("/dashboard/unassignedTicketsJson.do", function(data){
			// Inicializacion de tabla de ticets
			$('#dtTicketsPorAsignar').dataTable({	    		
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
							  { "mData": "Asignar" }

						  ],
				"aoColumnDefs" : [{"mRender" : function(data, type, row){return "<div align=center style='width:60px;'><a href=${pageContext.request.contextPath}/ticketDetail?ticketId=" + row.DT_RowId + ">" + data + "</a></div>";}, "aTargets" : [0]},
								  {"mRender" : function(data, type, row){return "<a href='#' class='edit' onclick='javascript: assignTicket(" + row.DT_RowId + ", \"" + data + "\"); return false;'>Asignar</a>";}, "aTargets" : [7]}	    		    	       
								 ]}
			);
		});
	}
	// Asignacion del ticket - Muestra el dialogo de asignacion
	function assignTicket(tktId, tktNumber){
		assignedTicket = tktId;
		$('#lblTicketBeignAssigned').html(tktNumber);
		$('#tktAssignDlg').dialog('open');
	}
	
	// Asignacion de ticets - Postea la asignacion
	function postAssignedTicket(pTicketId, pEmployee){
		$('#ticketId').val(pTicketId);
		$('#employee').val(pEmployee);
		$('#ticksetSelect').submit();
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
			<table cellpadding="0" cellspacing="0" border="0" class="display" id="dtTicketsPorAsignar">
				<thead>
					<tr> 
						<th>Ticket</th>
						<th>Fecha/Hora</th>
						<th>Cliente</th>
						<th>Equipo</th>
						<th>Tiem. R</th>
						<th>Proyecto</th>
						<th>Estatus</th>
						<th>Asignar</th>
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


<!-- 
	Seccion de dialogo para asignar ticets 
-->
<div id="tktAssignDlg" title="Asignar Ticket" >
	<p>Asignar ticket<label id="lblTicketBeignAssigned"></label></p>
		<select id="employeeSelect">
			<c:forEach var="employee" items="${staff}">
				<option value = "${employee.email}">${employee.name}</option>
			</c:forEach>
		</select>
	<form id="ticksetSelect" action="/dashboard/asignTicket.do" method="post">
		<input id="ticketId" name="ticketId" type="hidden"/>
		<input id="employee" name="employee" type="hidden"/>
	</form>
</div>
<!-- 
	FIN - Seccion de dialogo para asignar ticets 
-->